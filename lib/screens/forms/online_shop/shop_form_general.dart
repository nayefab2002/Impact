import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/online_shop_form_provider.dart';

class ShopFormGeneral extends ConsumerStatefulWidget {
  const ShopFormGeneral({super.key});

  static final formKey = GlobalKey<FormState>(); // Add static form key

  @override
  ConsumerState createState() => _ShopFormGeneralState();
}

class _ShopFormGeneralState extends ConsumerState<ShopFormGeneral> {
  final Map<String, bool> purchaserInfo = {
    'Email': true,
    'First Name': true,
    'Last Name': true,
    'Address': false,
    'State': true,
    'Country': true,
  };

  bool _additionalDonation = false;
  String? shopItemPath;

  void _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      final fileName = result.files.first.name;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Uploaded image: $fileName")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: ShopFormGeneral.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "GENERAL INFO",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF333366),
                fontSize: 13,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "TITLE OF TICKETING FORM*",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFF333366),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: ref.read(shopTitleControllerProvider),
              decoration: InputDecoration(
                hintText: "IMPACT’S SHOP",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xFF6A4CBC)),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
              validator: (value) => value!.trim().isEmpty ? "Title is required" : null,
            ),

            const SizedBox(height: 32),
            const Text(
              "DESCRIPTION",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFF333366),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: ref.read(shopDescriptionControllerProvider),
              maxLines: 8,
              decoration: InputDecoration(
                hintText: "ADD A DESCRIPTION AND ANY DETAILS OF THE EVENT HERE. THIS INFO CAN ALWAYS BE EDITED LATER",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF6A4CBC)),
                ),
              ),
            ),

            const Text("Image details", style: TextStyle(color: Color(0xFF333366), fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Image", style: TextStyle(color: Color(0xFF333366))),
                  const SizedBox(height: 12),
                  shopItemPath != null
                      ? Container(
                          height: 250,
                          width: 250,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          padding: const EdgeInsets.all(15),
                          child: Image.asset(shopItemPath!, fit: BoxFit.cover),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            setState(() {
                              shopItemPath = "assets/images/shop_item.jpg";
                            });
                          },
                          child: const Text("Fill with placeholder"),
                        ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: ref.read(shopItemTitleControllerProvider),
                    decoration: const InputDecoration(
                      labelText: "Title*",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.trim().isEmpty ? "Item title is required" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: ref.read(shopItemPriceControllerProvider),
                    decoration: const InputDecoration(
                      labelText: "Price*",
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.trim().isEmpty ? "Price is required" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: ref.read(shopItemDescriptionControllerProvider),
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      hintText: "You can add here its details on the item (optional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("More options coming soon...")),
                      );
                    },
                    child: const Text("Show More Options ↓"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            CheckboxListTile(
              title: const Text("Additional donation"),
              value: _additionalDonation,
              onChanged: (val) => setState(() {
                _additionalDonation = val!;
                ref.read(shopAllowAdditionalDonationProvider.notifier).state = val;
              }),
            ),

            const SizedBox(height: 16),
            const Text("What info do you need from the purchaser?", style: TextStyle(fontWeight: FontWeight.bold)),
            const Text("By default, we ask email, full name, state, and country."),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: purchaserInfo.keys.map((key) {
                return FilterChip(
                  label: Text(key),
                  selected: purchaserInfo[key]!,
                  onSelected: (val) => setState(() {
                    purchaserInfo[key] = val;
                    ref.read(shopPurchaserInfoProvider.notifier).state = purchaserInfo;
                  }),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Custom question added")),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Add a custom question"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
