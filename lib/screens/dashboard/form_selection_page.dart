import 'package:flutter/material.dart';

class FundraisingUI extends StatelessWidget {
  const FundraisingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Create New Fundraiser',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const SafeArea(
        child: FundraisingGrid(),
      ),
    );
  }
}

class FundraisingGrid extends StatelessWidget {
  const FundraisingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _calculateColumnCount(constraints.maxWidth);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: fundraisingItems.length,
            itemBuilder: (context, index) {
              return FundraisingCard(item: fundraisingItems[index]);
            },
          ),
        );
      },
    );
  }

  int _calculateColumnCount(double width) {
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 500) return 2;
    return 1;
  }
}

class FundraisingCard extends StatelessWidget {
  final FundraisingItem item;

  const FundraisingCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToForm(context),
        splashColor: Colors.blue.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  size: 28,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                item.subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToForm(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed(item.routeName);
  }
}

class FundraisingItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String routeName;

  const FundraisingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.routeName,
  });
}

/// List of fundraiser types shown in the grid.
const List<FundraisingItem> fundraisingItems = [
  FundraisingItem(
    title: 'Event',
    subtitle: 'Sell tickets for your fundraising event',
    icon: Icons.event,
    routeName: '/event_screen',
  ),
  FundraisingItem(
    title: 'Donation',
    subtitle: 'Collect one-time or recurring donations',
    icon: Icons.volunteer_activism,
    routeName: '/donation_screen',
  ),
  FundraisingItem(
    title: 'Peer-to-Peer',
    subtitle: 'Let supporters fundraise for you',
    icon: Icons.group,
    routeName: '/peer_screen',
  ),
  FundraisingItem(
    title: 'Online Shop',
    subtitle: 'Sell products to raise funds',
    icon: Icons.storefront,
    routeName: '/shop_screen',
  ),
  FundraisingItem(
    title: 'Raffle',
    subtitle: 'Sell raffle tickets with prizes',
    icon: Icons.confirmation_number,
    routeName: '/raffle_screen',
  ),
  FundraisingItem(
    title: 'Membership',
    subtitle: 'Offer membership subscriptions',
    icon: Icons.credit_card,
    routeName: '/membership_screen',
  ),
  FundraisingItem(
    title: 'Auction',
    subtitle: 'Host an auction fundraiser',
    icon: Icons.gavel,
    routeName: '/auction_screen',
  ),
  FundraisingItem(
    title: 'Custom',
    subtitle: 'Create a custom fundraising form',
    icon: Icons.tune,
    routeName: '/custom_screen',
  ),
];
