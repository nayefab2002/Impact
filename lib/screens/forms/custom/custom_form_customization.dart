import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/custom_form_provider.dart';


class CustomFormCustomization extends ConsumerStatefulWidget {
  const CustomFormCustomization({super.key});

  @override
  ConsumerState createState() => _CustomFormCustomizationState();
}

class _CustomFormCustomizationState extends ConsumerState<CustomFormCustomization> {
  Color? selectedThemeColor;
  bool toShowProgressBar=true;
  String? logoPath;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 32),

          const Text(
            'Customize Form',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          const Text('Color Theme', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: List.generate(6, (index) {
              final color = Colors.primaries[index * 2];
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedThemeColor=color;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: selectedThemeColor==color?Border.all(color: Colors.blueGrey,width: 1.5):null,

                  ),
                  child: CircleAvatar(radius: 20,backgroundColor: color,
                    child: selectedThemeColor==color?Center(child: Icon(Icons.check),):Container(),),
                )
              );
            }),
          ),

          const SizedBox(height: 24),

          const Text('Upload Your Logo', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          logoPath!=null?Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.symmetric(vertical: 12),
            padding: EdgeInsets.all(15),
            child: Image.asset(logoPath!,fit: BoxFit.cover,),
          ):OutlinedButton(
            onPressed: (){
              setState(() {
                logoPath="assets/images/logo_placeholder.jpg";
              });
            },
            child: const Text("Fill with placeholder"),
          ),

          const SizedBox(height: 24),

          const Text('Welcome Message', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextFormField(
            controller: ref.read(customFormWelcomeMessageControllerProvider),
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Welcome supporters to your custom fundraising form...',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          SwitchListTile(
            value: toShowProgressBar,
            onChanged: (val) {
              setState(() {
                toShowProgressBar=val;
                ref.read(customFormShowProgressBarProvider.notifier).state=val;
              });
            },
            title: const Text('Show progress bar during checkout'),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
