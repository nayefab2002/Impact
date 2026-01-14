import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/screens/forms/preview/ticket_selection_provider.dart';
import 'package:intl/intl.dart';

import '../models/event_form.dart';


class EventFormPreviewScreen extends ConsumerStatefulWidget {
  final EventForm eventData;
  const EventFormPreviewScreen({super.key,required this.eventData});

  @override
  ConsumerState createState() => _EventFormPreviewScreenState();
}

class _EventFormPreviewScreenState extends ConsumerState<EventFormPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    String displayDateMonth = '';
    String displayDateDay = '';
    String displayFullDate = '';
    String displayTimeRange = '';

    try {
      final List<String> dateTimeParts =widget.eventData.dateTime.split(' ');
      final DateTime parsedDate = DateTime.parse(dateTimeParts[0]);
      displayDateMonth = DateFormat.MMM().format(parsedDate);
      displayDateDay = DateFormat.d().format(parsedDate);
      displayFullDate = DateFormat('MMM dd').format(parsedDate);

      if (dateTimeParts.length > 1) {
        String timeString = dateTimeParts.sublist(1).join(' '); // "16:00 - 20:00"
        List<String> timeRangeParts = timeString.split(' - ');
        if (timeRangeParts.length == 2) {
          final DateTime startTime = DateFormat('HH:mm').parse(timeRangeParts[0]);
          final String formattedStartTime = DateFormat('h:mm a').format(startTime);

          final DateTime endTime = DateFormat('HH:mm').parse(timeRangeParts[1]);
          final String formattedEndTime = DateFormat('h:mm a').format(endTime);

          displayTimeRange = '$formattedStartTime - $formattedEndTime';
        } else {
          displayTimeRange = timeString; // Fallback if format is not as expected
        }
      }
    } catch (e) {
      debugPrint('Error parsing date/time: $e');
      displayDateMonth = 'N/A';
      displayDateDay = 'N/A';
      displayFullDate = 'Date N/A';
      displayTimeRange = 'Time N/A';
    }

    final Color themeColor = hexToColor(widget.eventData.themeColor);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.grey[700]),
          onPressed: () {
            // This is a preview, so the close action can just print to console or navigate back in a real app.
            debugPrint('Close button pressed');
            Navigator.pop(context);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 800) {
            // Wide screen layout (desktop/tablet)
            return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        child: EventDetailsSection(
                          eventData: widget.eventData,
                          displayDateMonth: displayDateMonth,
                          displayDateDay: displayDateDay,
                          displayFullDate: displayFullDate,
                          displayTimeRange: displayTimeRange,
                          themeColor: themeColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(flex: 2,child: TicketSelectionSection(
                      themeColor: themeColor, form: widget.eventData,
                    ),)
                  ],
                )
            );
          } else {
            // Narrow screen layout (mobile)
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    EventDetailsSection(
                      eventData: widget.eventData,
                      displayDateMonth: displayDateMonth,
                      displayDateDay: displayDateDay,
                      displayFullDate: displayFullDate,
                      displayTimeRange: displayTimeRange,
                      themeColor: themeColor,
                    ),
                    const SizedBox(height: 24),
                    TicketSelectionSection(
                      form: widget.eventData,
                      themeColor: themeColor,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}


/// Widget for displaying event details (image, title, date, address, description).
class EventDetailsSection extends StatelessWidget {
  final EventForm eventData;
  final String displayDateMonth;
  final String displayDateDay;
  final String displayFullDate;
  final String displayTimeRange;
  final Color themeColor;

  const EventDetailsSection({
    super.key,
    required this.eventData,
    required this.displayDateMonth,
    required this.displayDateDay,
    required this.displayFullDate,
    required this.displayTimeRange,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Event Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.asset('assets/images/banner_placeholder.jpg',height: 400,width: double.infinity,)
        ),
        const SizedBox(height: 24.0),
        // Event Title
        Text(
          eventData.title,
          style: const TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF21005D), // Dark purple for text
          ),
        ),
        const SizedBox(height: 16.0),
        // Date and Time
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    displayDateMonth,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                  Text(
                    displayDateDay,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  displayFullDate,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF21005D),
                  ),
                ),
                Text(
                  displayTimeRange,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        // Address
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.location_on, color: themeColor),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                eventData.address,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        // Description
        QuillEditor(focusNode: FocusNode(),
          scrollController: ScrollController(),controller: QuillController(document: Document.fromJson(eventData.description),
              selection: TextSelection(baseOffset: 0, extentOffset: 0)),
          configurations: QuillEditorConfigurations(checkBoxReadOnly: true),),
      ],
    );
  }
}

/// Widget for displaying ticket selection and a disclaimer.
class TicketSelectionSection extends ConsumerWidget {
  final EventForm form;
  final Color themeColor;
  const TicketSelectionSection({super.key,required this.form, required this.themeColor});

  @override
  Widget build(BuildContext context, ref) {
    // Safely get the first ticket option from the map.
    final Map<String, dynamic> firstTicketOption = form.ticketOptions;


    final String ticketName = firstTicketOption['name'] as String? ?? 'Ticket Name';
    final double ticketPrice = (firstTicketOption['price'] as num?)?.toDouble() ?? 0.0;
    final String ticketDescription = firstTicketOption['description'] as String? ?? 'No description available.';

    // Ensure the TicketSelectionData's price is updated if the initial event data changes.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final TicketSelectionData ticketSelectionData = ref.read(ticketSelectionProvider);
      ticketSelectionData.updateTicketPrice(ticketPrice);
    });

    return Column(
      children: <Widget>[
        // Ticket Selection Card
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ticketName,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF21005D),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '\$${ticketPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  ticketDescription,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16.0),
                Consumer(
                  builder: (context, ref, child) {
                    final ticketSelection=ref.watch(ticketSelectionProvider);
                    debugPrint(ticketSelection.quantity.toString());
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _buildQuantityButton(
                          icon: Icons.remove,
                          onPressed: (){
                            //ticketSelection.decrementQuantity();
                            ref.read(ticketSelectionProvider.notifier).decrementQuantity();
                            },
                          isEnabled: ticketSelection.quantity > 1,
                          themeColor: themeColor,
                        ),
                        SizedBox(
                          width: 48.0,
                          child: Center(
                            child: Text(
                              ticketSelection.quantity.toString(),
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF21005D),
                              ),
                            ),
                          ),
                        ),
                        _buildQuantityButton(
                          icon: Icons.add,
                          onPressed:  (){ref.read(ticketSelectionProvider.notifier).incrementQuantity();},
                          isEnabled: true, // Always allow adding more tickets
                          themeColor: themeColor,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        // Disclaimer Card
        // Card(
        //   elevation: 0,
        //   color: themeColor.withOpacity(0.1),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(16.0),
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.all(20.0),
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        //         Icon(Icons.lightbulb_outline, color: themeColor),
        //         const SizedBox(width: 12.0),
        //         Expanded(
        //           child: Text(
        //             'Did you know? We fundraise with Zeppy to ensure 100% of your purchase goes to our mission!',
        //             style: TextStyle(
        //               fontSize: 14.0,
        //               color: Colors.grey[800],
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        const SizedBox(height: 24.0),
        // Continue Button
        Consumer(
          builder: (context, ref, child) {
            final ticketSelection=ref.watch(ticketSelectionProvider);
            return SizedBox(
              width: double.infinity,
              height: 56.0,
              child: ElevatedButton(
                onPressed: () {
                  // Handle continue action, e.g., navigate to next step
                  debugPrint(
                      'Continue with ${ticketSelection.quantity} tickets for \$${ticketSelection.totalPrice.toStringAsFixed(2)}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Continue (${ticketSelection.quantity}) →',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Helper widget for quantity control buttons (- and +).
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isEnabled,
    required Color themeColor,
  }) {
    return Container(
      width: 48.0,
      height: 48.0,
      decoration: BoxDecoration(
        color: isEnabled ? themeColor.withOpacity(0.1) : themeColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: IconButton(
        icon: Icon(icon, color: isEnabled ? themeColor : Colors.grey[400]),
        onPressed: isEnabled ? onPressed : null,
      ),
    );
  }
}