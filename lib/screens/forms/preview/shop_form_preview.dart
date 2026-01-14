import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/screens/forms/models/online_shop_form.dart';


class OnlineShopPreviewScreen extends StatelessWidget {
  final ShopForm shopFormData;

  const OnlineShopPreviewScreen({super.key, required this.shopFormData});

  // Helper method to safely extract item data
  Map<String, dynamic> _getItemData() {
    try {
      if (shopFormData.items is Map<String, dynamic>) {
        return shopFormData.items as Map<String, dynamic>;
      } else if (shopFormData.items is Map) {
        return Map<String, dynamic>.from(shopFormData.items as Map);
      }
    } catch (e) {
      debugPrint('Error parsing item data: $e');
    }
    return {
      'title': 'Shop Item',
      'price': '0.00',
      'description': 'No description available'
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = hexToColor(shopFormData.themeColor);
    final itemData = _getItemData();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _HeaderSection(shopFormData: shopFormData, themeColor: themeColor),
            const SizedBox(height: 24),
            _ItemSection(item: itemData, themeColor: themeColor),
            const SizedBox(height: 24),
            if (shopFormData.description.isNotEmpty)
              _DescriptionSection(text: shopFormData.description, themeColor: themeColor),
            const SizedBox(height: 24),
            _CheckoutSection(shopFormData: shopFormData, themeColor: themeColor, item: itemData),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final ShopForm shopFormData;
  final Color themeColor;

  const _HeaderSection({
    required this.shopFormData,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (shopFormData.bannerUrl.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset("assets/images/banner_placeholder.jpg",height: 400,width: double.infinity,)
          ),
        const SizedBox(height: 16),
        Text(
          shopFormData.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (shopFormData.shopLogoUrl.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Image.asset('assets/images/logo_placeholder.jpg',height: 300,width: 300,)
          ),
      ],
    );
  }
}

class _ItemSection extends StatelessWidget {
  final Map<String, dynamic> item;
  final Color themeColor;

  const _ItemSection({
    required this.item,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/shop_item.jpg',height: 150,width: 150,),
            Text(
              item['title']?.toString() ?? 'Item',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${item['price']?.toString() ?? '0.00'}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
            if (item['description']?.toString().isNotEmpty ?? false) ...[
              const SizedBox(height: 12),
              Text(
                item['description']!.toString(),
                style: TextStyle(
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _QuantitySelector(themeColor: themeColor),
          ],
        ),
      ),
    );
  }
}
final quantityProvider = StateProvider<int>((_) => 1);
class _QuantitySelector extends ConsumerWidget {
  final Color themeColor;

  const _QuantitySelector({required this.themeColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(quantityProvider);
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove, color: quantity > 1 ? themeColor : Colors.grey),
          onPressed: quantity > 1 
              ? () => ref.read(quantityProvider.notifier).state--
              : null,
        ),
        Text(quantity.toString(), style: const TextStyle(fontSize: 18)),
        IconButton(
          icon: Icon(Icons.add, color: themeColor),
          onPressed: () => ref.read(quantityProvider.notifier).state++,
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final String text;
  final Color themeColor;

  const _DescriptionSection({
    required this.text,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About This Shop',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _CheckoutSection extends ConsumerWidget {
  final ShopForm shopFormData;
  final Color themeColor;
  final Map<String, dynamic> item;

  const _CheckoutSection({
    required this.shopFormData,
    required this.themeColor,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(quantityProvider);
    final price = double.tryParse(item['price']?.toString() ?? '0') ?? 0;
    final total = price * quantity;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _CheckoutRow(
              label: 'Subtotal',
              value: '\$${price.toStringAsFixed(2)} x $quantity',
            ),
            const Divider(),
            _CheckoutRow(
              label: 'Total',
              value: '\$${total.toStringAsFixed(2)}',
              isTotal: true,
            ),
            if (shopFormData.allowAdditionalDonation)
              Column(
                children: [
                  const Divider(),
                  _AdditionalDonation(themeColor: themeColor),
                ],
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Processing payment for \$${total.toStringAsFixed(2)}')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (shopFormData.suggestCheckOption && total >= 1000)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Check payment instructions sent')),
                    );
                  },
                  child: Text(
                    'Pay by Check Instead',
                    style: TextStyle(color: themeColor),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _CheckoutRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

class _AdditionalDonation extends ConsumerWidget {
  final Color themeColor;

  const _AdditionalDonation({required this.themeColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final donationProvider = StateProvider<double?>((_) => null);
    final donation = ref.watch(donationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Add a donation to support our cause', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [10, 25, 50, 100].map((amount) {
            return ChoiceChip(
              label: Text('\$$amount'),
              selected: donation == amount.toDouble(),
              onSelected: (_) => ref.read(donationProvider.notifier).state = amount.toDouble(),
              selectedColor: themeColor.withOpacity(0.2),
              labelStyle: TextStyle(
                color: donation == amount.toDouble() ? themeColor : Colors.grey.shade700,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            prefixText: '\$',
            hintText: 'Other amount',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final amount = double.tryParse(value);
            ref.read(donationProvider.notifier).state = amount;
          },
        ),
      ],
    );
  }
}