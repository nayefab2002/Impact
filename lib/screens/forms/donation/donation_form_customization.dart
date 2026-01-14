import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/donation_form_provider.dart';
import '../../../widgets/step_progress_indicator.dart';


class DonationFormCustomization extends ConsumerStatefulWidget {
  const DonationFormCustomization({super.key});

  @override
  ConsumerState createState() => _DonationFormCustomizationState();
}

class _DonationFormCustomizationState extends ConsumerState<DonationFormCustomization> {
  String _selectedAmount = '';
  Color _selectedColor = Colors.deepOrange;
  String _mediaType = 'Image';
  final _emailSubjectController =
  TextEditingController(text: 'Thank you for your donation');
  final quill.QuillController _quillController = quill.QuillController.basic();
  String? logoFilePath;
  String? bannerFilePath;
  //late Uint8List? logoFileBytes;
  //late Uint8List? bannerFileBytes;

  Map<String, bool> donorQuestions = {
    'Email': true,
    'First name': true,
    'Last name': true,
    'State': true,
    'Country': true,
    'Address': true,
  };

  String? _logoPlaceholder;
  String? _bannerPlaceholder;

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
              ref.read(donationThemeColorProvider.notifier).state=color.toHexString();
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

  Future<void> _pickFile(String label, bool isLogo) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      //allowedExtensions: ['jpg', 'png', 'jpeg',],
    );

    if (result != null) {
      final file = result.files.first;
      setState(() {
        // if(isLogo){
        //   logoFilePath=file.path!;
        //   logoFileBytes=file.bytes;
        //   ref.read(donationLogoBytesProvider.notifier).state=logoFileBytes;
        // }else{
        //   bannerFilePath=file.path!;
        //   bannerFileBytes=file.bytes;
        //   ref.read(donationBannerBytesProvider.notifier).state=bannerFileBytes;
        // }
      });
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
          _sectionTitle("Suggested donation amounts"),
          _amountSelector(),

          const SizedBox(height: 24),
          _sectionTitle("Customize your form"),
          const Text("Select a color for your form"),
          Row(
            children: [
              Container(
                height: 20,
                width: 180,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              IconButton(icon: const Icon(Icons.edit), onPressed: _pickColor),
            ],
          ),

          // logoFilePath!=null?Container(
          //   height: 300,
          //   width: 300,
          //   decoration: BoxDecoration(
          //     border: Border.all(color: Colors.grey),
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   margin: EdgeInsets.symmetric(vertical: 12),
          //   padding: EdgeInsets.all(15),
          //   child: Image.memory(logoFileBytes!,height: 100,width: 100,fit: BoxFit.cover,),
          // )
         _logoPlaceholder!=null?Container(
             height: 300,
             width: 300,
             decoration: BoxDecoration(
               border: Border.all(color: Colors.grey),
               borderRadius: BorderRadius.circular(8),
             ),
             margin: EdgeInsets.symmetric(vertical: 12),
             padding: EdgeInsets.all(15),
             child: Image.asset(_logoPlaceholder!,fit: BoxFit.cover,),
           ): _uploadBox(
            label: "Upload Logo",
            onFillPlaceholder: () {
              setState(() =>  _logoPlaceholder="assets/images/logo_placeholder.jpg");
            },
          ),

          const SizedBox(height: 16),
          const Text("Form banner"),
          Row(
            children: [
              Radio(
                value: 'Image',
                groupValue: _mediaType,
                onChanged: (val) => setState(() => _mediaType = val!),
              ),
              const Text("Image"),
            ],
          ),
          _bannerPlaceholder!=null?Container(
            height: 400,
            width: 1200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.symmetric(vertical: 12),
            padding: EdgeInsets.all(15),
            child: Image.asset(_bannerPlaceholder!,fit: BoxFit.cover,),
          ):_uploadBox(
              label: "Upload Form Banner",
              onFillPlaceholder: () {
                setState(() => _bannerPlaceholder="assets/images/banner_placeholder.jpg");
              },
              isLogo: false
          ),
          // bannerFilePath!=null?Container(
          //   height: 400,
          //   width: 1200,
          //   decoration: BoxDecoration(
          //     border: Border.all(color: Colors.grey),
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   margin: EdgeInsets.symmetric(vertical: 12),
          //   padding: EdgeInsets.all(15),
          //   child: Image.memory(bannerFileBytes!,height: 180,fit: BoxFit.cover,),
          // ):

          const SizedBox(height: 24),
          _sectionTitle("Questions for your donors"),
          const Text(
            "By default, we ask for email address, full name, state and country. You can also add customized questions.",
          ),
          Wrap(
            spacing: 8,
            children: donorQuestions.entries.map((entry) {
              return FilterChip(
                label: Text(entry.key),
                selected: entry.value,
                onSelected: (val) {
                  setState(() => donorQuestions[entry.key] = val);
                  ref.read(donationDonorQuestionsProvider.notifier).state=donorQuestions;
                }
              );
            }).toList(),
          ),
          //const SizedBox(height: 8),
          // TextButton.icon(
          //   onPressed: () {},
          //   icon: const Icon(Icons.add),
          //   label: const Text("Add a custom question"),
          // ),

          const SizedBox(height: 24),
          _sectionTitle("Thank you email configuration"),
          const Text(
            "Customize the email that is automatically sent to the donor after they make a donation.",
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: ref.read(emailSubjectProvider),
            decoration: const InputDecoration(
              labelText: "Email Subject",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),
          quill.QuillToolbar.simple(
           controller: ref.read(emailBodyQuillController)
          ),

          const SizedBox(height: 8),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: quill.QuillEditor.basic(
              controller: ref.read(emailBodyQuillController),
              configurations: quill.QuillEditorConfigurations(
                enableInteractiveSelection: true,
                sharedConfigurations: const quill.QuillSharedConfigurations(
                  locale: Locale('en'),
                ),
                expands: false,
                placeholder: 'Write your thank-you message here...',
                padding: const EdgeInsets.all(8),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF333366),
      ),
    ),
  );

  Widget _amountSelector() {
    final options = ['Less than \$100', '\$100 - \$300', 'More than \$300'];
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "How much do you expect to receive from a single donation?*",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text("Boost donations with our personalized suggested amounts"),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: options.map((opt) {
              final selected = _selectedAmount == opt;
              return ChoiceChip(
                label: Text(opt),
                selected: selected,
                onSelected: (_) {
                  setState(() => _selectedAmount = opt);
                  switch(_selectedAmount){
                    case 'Less than \$100':
                      ref.read(donationSuggestedDonationAmountProvider.notifier).state["lessThan100"]=true;
                      break;
                    case '\$100 - \$300':
                      ref.read(donationSuggestedDonationAmountProvider.notifier).state["between100_300"]=true;
                      break;
                    default:
                      ref.read(donationSuggestedDonationAmountProvider.notifier).state["moreThan300"]=true;
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

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
}
