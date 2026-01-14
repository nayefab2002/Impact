import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/online_shop_form_provider.dart';

class ShopFormCustomization extends ConsumerStatefulWidget {
  const ShopFormCustomization({super.key});

  @override
  ConsumerState createState() => _ShopFormCustomizationState();
}

class _ShopFormCustomizationState extends ConsumerState<ShopFormCustomization> {

  Color _formColor = Colors.deepOrange;
  String _mediaType = 'Image';

  String? _logoPlaceholder;
  String? _bannerPlaceholder;

  void _pickColor() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pick a color"),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _formColor,
            onColorChanged: (color) => setState(() {
              _formColor = color;
              ref.read(shopThemeColorProvider.notifier).state=color.toHexString();
            }),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile(String label) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      final file = result.files.first;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label selected: ${file.name}')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Customize your form",
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333366)),
          ),
          const SizedBox(height: 8),
          const Text("Select a color for your form"),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 180,
                height: 20,
                decoration: BoxDecoration(
                  color: _formColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.color_lens),
                onPressed: _pickColor,
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text("Logo", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _pickFile("Logo"),
            child: const Text("Upload Logo"),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              setState(() => _logoPlaceholder = "Placeholder logo applied");
            },
            child: const Text("Fill with placeholder"),
          ),
          if (_logoPlaceholder != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(_logoPlaceholder!, style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
            ),

          const SizedBox(height: 24),
          const Text("Form banner", style: TextStyle(fontWeight: FontWeight.bold)),
          const Text(
            "Your image can be any size, but for an optimal experience choose an image that is less than 1200px in width and a ratio of pixels of 16:9.",
            style: TextStyle(fontSize: 12),
          ),
          // Row(
          //   children: [
          //     Radio(value: 'Image', groupValue: _mediaType, onChanged: (val) => setState(() => _mediaType = val!)),
          //     const Text("Image"),
          //     Radio(value: 'Video', groupValue: _mediaType, onChanged: (val) => setState(() => _mediaType = val!)),
          //     const Text("Video"),
          //   ],
          // ),
          Container(
            height: 150,
            color: const Color(0xFFEAE6FD),
            child: Center(child: TextButton(onPressed: (){

            }, child: const Text("Upload Form Banner"))),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              setState(() => _bannerPlaceholder = "Placeholder banner applied");
            },
            child: const Text("Fill with placeholder"),
          ),
          if (_bannerPlaceholder != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(_bannerPlaceholder!, style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
            ),

          const SizedBox(height: 32),
          const Text("Thank you email configuration", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Customize the email that is automatically sent to the donor after they make a donation."),
          const SizedBox(height: 8),
          TextFormField(
            controller: ref.read(shopEmailSubjectControllerProvider),
            decoration: const InputDecoration(
              labelText: "Email Subject",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          quill.QuillToolbar.simple(
            configurations: quill.QuillSimpleToolbarConfigurations(controller: ref.read(onlineShopEmailDescriptionQuillController)),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: quill.QuillEditor.basic(
              configurations: quill.QuillEditorConfigurations(
                controller: ref.read(onlineShopEmailDescriptionQuillController),
                sharedConfigurations: const quill.QuillSharedConfigurations(locale: Locale('en')),
                enableInteractiveSelection: true,
                padding: const EdgeInsets.all(8),
                placeholder: "Type here",
              ),
            ),
          ),
        ],
      ),
    );
  }

}
