import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/peer_to_peer_form_provider.dart';

class PeerFormCustomization extends ConsumerStatefulWidget {
  const PeerFormCustomization({super.key});

  @override
  ConsumerState createState() => _PeerFormCustomizationState();
}

class _PeerFormCustomizationState extends ConsumerState<PeerFormCustomization> {
  final Map<String, List<TextEditingController>> _amountControllers = {
    'One-Time': List.generate(4, (_) => TextEditingController(text: '0.0')),
    'Monthly': List.generate(4, (_) => TextEditingController(text: '0.0')),
    'Yearly': List.generate(4, (_) => TextEditingController(text: '0.0')),
  };

  String _selectedFrequency = 'Monthly';
  Color _selectedColor = Colors.deepOrange;
  String _mediaType = 'Image';
  String? _logoPlaceholder;
  String? _bannerPlaceholder;
  Map<String, bool> donorQuestions = {
    'Email': true,
    'First Name': false,
    'Last Name': false,
    'Address': false,
    'State': false,
    'Country': false,
  };

  void _pickColor() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select a color"),
        content: BlockPicker(
          pickerColor: _selectedColor,
          onColorChanged: (color) {
            setState(() => _selectedColor = color);
            ref.read(peerToPeerThemeColorProvider.notifier).state=color.toHexString();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Done"),
          )
        ],
      ),
    );
  }

  Future<void> _pickFile(String label) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      final fileName = result.files.single.name;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label uploaded: $fileName')),
      );
    }
  }

  void _fillPlaceholder(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label filled with placeholder')),
    );
  }
  Widget _amountSelector() {
    final options = ['One-Time', 'Monthly', 'Yearly'];
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
            "Select the frequency",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text("Boost donations with our personalized suggested amounts"),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: options.map((opt) {
              final selected = _selectedFrequency == opt;
              return ChoiceChip(
                label: Text(opt),
                selected: selected,
                onSelected: (_) {
                  setState(() => _selectedFrequency = opt);
                  switch(_selectedFrequency){
                    case 'One-Time':
                      ref.read(peerToPeerSuggestedAmountsProvider.notifier).state["One-Time"]=
                        _amountControllers['One-Time']!.map((val)=>double.parse(val.text.toString())).toList();
                      break;
                    case 'Monthly':
                      ref.read(peerToPeerSuggestedAmountsProvider.notifier).state["Monthly"]=
                          _amountControllers['Monthly']!.map((val)=>double.parse(val.text.toString())).toList();
                      break;
                    default:
                      ref.read(peerToPeerSuggestedAmountsProvider.notifier).state["Yearly"]=
                          _amountControllers['Yearly']!.map((val)=>double.parse(val.text.toString())).toList();
                      break;
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Amounts Grid
          Wrap(
            runSpacing: 12,
            spacing: 12,
            children: List.generate(4, (i) {
              return SizedBox(
                width: 150,
                child: TextFormField(
                  controller: _amountControllers[_selectedFrequency]![i],
                  decoration: const InputDecoration(
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle section
          _amountSelector(),


          const SizedBox(height: 24),
          const Text("Customize your form", style: TextStyle(fontWeight: FontWeight.bold)),
          const Text("Select a color of your form"),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 180,
                height: 20,
                decoration: BoxDecoration(
                  color: _selectedColor,
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              ):_uploadSection("Logo",(){
                setState(() =>  _logoPlaceholder="assets/images/logo_placeholder.jpg");

              }),
              const SizedBox(width: 16),
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
              ):_uploadSection("Banner",(){
                setState(() => _bannerPlaceholder="assets/images/banner_placeholder.jpg");
              }),
            ],
          ),

          const SizedBox(height: 24),
          const Text("Questions for your donors", style: TextStyle(fontWeight: FontWeight.bold)),
          const Text("By default, we ask email, full name, state, and country."),
          Wrap(
            spacing: 12,
            children: donorQuestions.keys.map((key) {
              return FilterChip(
                label: Text(key),
                selected: donorQuestions[key]!,
                onSelected: (val){
                  setState(() => donorQuestions[key] = val);
                  ref.read(peerToPeerDonorQuestionsProvider.notifier).state=donorQuestions;
                },
              );
            }).toList(),
          ),
          // const SizedBox(height: 8),
          // TextButton.icon(
          //   onPressed: () {},
          //   icon: const Icon(Icons.add),
          //   label: const Text("Add a custom question"),
          // ),

          const SizedBox(height: 24),
          const Text("Thank you email configuration", style: TextStyle(fontWeight: FontWeight.bold)),
          const Text("Customize the email sent after a donation."),
          const SizedBox(height: 8),
          TextFormField(
            controller: ref.read(peerToPeerEmailSubjectControllerProvider),
            decoration: const InputDecoration(
              labelText: "Email subject",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          quill.QuillToolbar.simple(
            configurations: quill.QuillSimpleToolbarConfigurations(controller: ref.read(peerToPeerEmailQuillProvider)),
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
                controller: ref.read(peerToPeerEmailQuillProvider),
                enableInteractiveSelection: true,
                sharedConfigurations: const quill.QuillSharedConfigurations(locale: Locale('en')),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _uploadSection(String label, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 18,
      children: [
        Text(label,style: Theme.of(context).textTheme.headlineMedium,),
      OutlinedButton(
      onPressed: onPressed,
      child: const Text("Fill with placeholder"),
    )
      ],
    );
  }
}
