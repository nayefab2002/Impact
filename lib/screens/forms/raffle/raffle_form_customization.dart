import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/raffle_form_provider.dart';
import '../step_progress_indicator.dart';
import 'package:impact/widgets/step_progress_indicator.dart';


class RaffleFormCustomization extends ConsumerStatefulWidget {
  const RaffleFormCustomization({super.key});

  @override
  ConsumerState createState() => _RaffleFormCustomizationState();
}

class _RaffleFormCustomizationState extends ConsumerState<RaffleFormCustomization> {
  Color _selectedColor = Colors.deepOrange;
  String? _logoPath;
  String? _bannerPath;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _sectionTitle("Customize your raffle form"),
          const SizedBox(height: 16),

          _sectionTitle("Form Color"),
          const Text("Select a color for your form"),
          SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: _selectedColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              ElevatedButton(
                onPressed: _pickColor,
                child: const Text("Choose Color"),
              ),
            ],
          ),

          const SizedBox(height: 24),
          _sectionTitle("Upload Logo"),
          _logoPath!=null?Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.symmetric(vertical: 12),
            padding: EdgeInsets.all(15),
            child: Image.asset(_logoPath!,fit: BoxFit.cover,),
          ):_uploadBox(label: "Upload Logo",
              onFillPlaceholder: (){
                setState(() =>  _logoPath="assets/images/logo_placeholder.jpg");

              }),

          const SizedBox(height: 24),
          _sectionTitle("Form Banner"),
          _bannerPath!=null?Container(
            height: 400,
            width: 1200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.symmetric(vertical: 12),
            padding: EdgeInsets.all(15),
            child: Image.asset(_bannerPath!,fit: BoxFit.cover,),
          ):_uploadBox(
              label: "Upload Form Banner",
              onFillPlaceholder: () {
                setState(() => _bannerPath="assets/images/banner_placeholder.jpg");
              },
              isLogo: false
          ),

        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Color(0xFF333366),
    ),
  );

  Widget _uploadBox({
    required String label,
    required VoidCallback onFillPlaceholder,
    bool isLogo=true
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 120,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ElevatedButton(
                //   onPressed: () => _pickFile(label,isLogo),
                //   child: Text(label),
                // ),
                // SizedBox(height: 15,),
                // Text(isLogo? "300x300":"1500x500", textAlign: TextAlign.center,style: TextStyle(fontSize: 12),),
                // const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: onFillPlaceholder,
                  child: const Text("Fill with placeholder"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pick a color"),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() => _selectedColor = color);
              ref.read(raffleThemeColorProvider.notifier).state=color.toHexString();
            },
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

  Future<void> _pickFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        if (type == 'logo') {
          _logoPath = result.files.first.name;
        } else {
          _bannerPath = result.files.first.name;
        }
      });
    }
  }
}
