import 'package:flutter/material.dart';
import 'info_page.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  static const _brandBlue = Color(0xFF0B0B5A);
  static const _accentBlue = Color(0xFF7B8BFF);
  static const _lightTeal = Color(0xFF7CF5E4);

  static final Map<String, List<_FooterItem>> _sections = {
    'Solutions': [
      _FooterItem('Donation Pages', Icons.volunteer_activism),
      _FooterItem('Event Ticketing', Icons.event_available),
      _FooterItem('Peer-to-Peer', Icons.groups_2),
      _FooterItem('Crowdfunding', Icons.track_changes),
    ],
    'Features': [
      _FooterItem('Zero Fees', Icons.money_off_csred),
      _FooterItem('Mobile App', Icons.smartphone),
      _FooterItem('Analytics', Icons.equalizer),
      _FooterItem('Integrations', Icons.extension),
    ],
    'Support': [
      _FooterItem('Help Center', Icons.help_outline),
      _FooterItem('Contact Us', Icons.mail_outline),
      _FooterItem('Blog', Icons.article_outlined),
      _FooterItem('Resources', Icons.menu_book),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_brandBlue, Color(0xFF05052F)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
      child: Column(
        children: [
          _ctaCard(context),
          const SizedBox(height: 60),
          Wrap(
            spacing: 60,
            runSpacing: 40,
            alignment: WrapAlignment.spaceEvenly,
            children: _sections.entries
                .map((e) => _FooterColumn(title: e.key, items: e.value))
                .toList(),
          ),
          const SizedBox(height: 48),
          Divider(color: Colors.white.withOpacity(.08)),
          const SizedBox(height: 24),
          _bottomBar(width),
        ],
      ),
    );
  }

  Widget _ctaCard(BuildContext ctx) => Container(
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(maxWidth: 700),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF3944F7), Color(0xFF151580)],
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Ready to get started for free?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Join thousands of nonprofits raising money with zero fees.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 4,
              ),
              onPressed: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => const InfoPage(title: 'Sign up'),
                ),
              ),
              icon: const Icon(Icons.rocket_launch_rounded),
              label: const Text(
                'Sign up for free',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );

  Widget _bottomBar(double width) => Column(
        children: [
          Text(
            '© 2025 Impact — All Rights Reserved',
            style: TextStyle(
              color: Colors.white.withOpacity(.45),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          if (width < 500) const SizedBox(height: 8),
        ],
      );
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.items});

  final String title;
  final List<_FooterItem> items;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...items.map((i) => _FooterLink(item: i)),
        ],
      );
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.item});
  final _FooterItem item;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => InfoPage(title: item.label)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 18, color: Colors.tealAccent.shade100),
              const SizedBox(width: 8),
              Text(
                item.label,
                style: TextStyle(
                  color: Colors.white.withOpacity(.72),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
}

class _FooterItem {
  const _FooterItem(this.label, this.icon);
  final String label;
  final IconData icon;
}
