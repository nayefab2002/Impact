import 'package:flutter_riverpod/flutter_riverpod.dart';

// The state class that holds ticket selection data
class TicketSelectionData {
  final int quantity;
  final double ticketPrice;
  final double totalPrice;

  TicketSelectionData({
    required this.quantity,
    required this.ticketPrice,
  }) : totalPrice = quantity * ticketPrice;

  // Helper method to update the ticket price (called when the event data changes)
  TicketSelectionData updateTicketPrice(double newPrice) {
    return TicketSelectionData(
      quantity: quantity,
      ticketPrice: newPrice,
    );
  }

  // Method to increment quantity
  TicketSelectionData incrementQuantity() {
    return TicketSelectionData(
      quantity: quantity + 1,
      ticketPrice: ticketPrice,
    );
  }

  // Method to decrement quantity
  TicketSelectionData decrementQuantity() {
    return TicketSelectionData(
      quantity: quantity > 1 ? quantity - 1 : 1,
      ticketPrice: ticketPrice,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TicketSelectionData &&
        other.quantity == quantity &&
        other.ticketPrice == ticketPrice;
  }

  @override
  int get hashCode => quantity.hashCode ^ ticketPrice.hashCode;
}

// The provider notifier class
class TicketSelectionNotifier extends StateNotifier<TicketSelectionData> {
  TicketSelectionNotifier()
      : super(TicketSelectionData(quantity: 1, ticketPrice: 0.0));

  void incrementQuantity() {
    state = state.incrementQuantity();

  }

  void decrementQuantity() {
    state = state.decrementQuantity();
  }

  void updateTicketPrice(double newPrice) {
    state = state.updateTicketPrice(newPrice);
  }
}

// The provider declaration
final ticketSelectionProvider =
StateNotifierProvider<TicketSelectionNotifier, TicketSelectionData>((ref) {
  return TicketSelectionNotifier();
});