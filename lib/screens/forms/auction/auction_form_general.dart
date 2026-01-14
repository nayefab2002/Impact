import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auction_form_provider.dart';

class AuctionFormGeneral extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;

  const AuctionFormGeneral({super.key, required this.formKey});

  @override
  ConsumerState createState() => _AuctionFormGeneralState();
}

class _AuctionFormGeneralState extends ConsumerState<AuctionFormGeneral> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Auction Setup", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            const LabelText("Title of Auction*"),
            TextFormField(
              controller: ref.read(auctionTitleControllerProvider),
              decoration: const InputDecoration(
                hintText: "Ex: Impact 2025 Charity Auction",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 20),

            const LabelText("Start Date & Time*"),
            TextFormField(
              controller: ref.read(auctionStartDateControllerProvider),
              decoration: const InputDecoration(
                hintText: "MM/DD/YYYY HH:MM",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 20),

            const LabelText("End Date & Time*"),
            TextFormField(
              controller: ref.read(auctionEndDateControllerProvider),
              decoration: const InputDecoration(
                hintText: "MM/DD/YYYY HH:MM",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 20),

            const LabelText("Auction Description"),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.grey[200],
                    child: Row(
                      children: const [
                        Icon(Icons.format_bold),
                        SizedBox(width: 8),
                        Icon(Icons.format_italic),
                        SizedBox(width: 8),
                        Icon(Icons.format_underlined),
                        SizedBox(width: 8),
                        Icon(Icons.format_align_left),
                        SizedBox(width: 8),
                        Icon(Icons.image),
                        SizedBox(width: 8),
                        Icon(Icons.link),
                        Spacer(),
                        Text("Pre-fill text", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  TextField(
                    maxLines: 6,
                    controller: ref.read(auctionDescriptionControllerProvider),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      border: InputBorder.none,
                      hintText:
                          "Add a description of your auction, including what items will be available and how proceeds will be used.",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LabelText extends StatelessWidget {
  final String text;

  const LabelText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
