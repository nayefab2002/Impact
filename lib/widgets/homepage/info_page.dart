import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key, required this.title});

  final String title;

  static const _brandBlue = Color(0xFF0B0B5A);
  static const _accentBlue = Color(0xFF7B8BFF);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final _PageContent c = _content(title);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(title),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8CBFFF), _brandBlue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 120, 28, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [_accentBlue, _brandBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _accentBlue.withOpacity(.35),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Icon(c.icon, size: 64, color: Colors.white),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              title,
              style: textTheme.headlineMedium?.copyWith(
                color: _brandBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (c.subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                c.subtitle!,
                style: textTheme.titleMedium?.copyWith(
                  color: _brandBlue.withOpacity(.70),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 24),
            Container(
              height: 4,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: const LinearGradient(
                  colors: [_accentBlue, _brandBlue],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              c.description,
              style: textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 24),
            if (c.bullets.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: c.bullets
                    .map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ',
                                  style: TextStyle(
                                      fontSize: 20, color: _brandBlue)),
                              Expanded(
                                  child: Text(
                                b,
                                style: textTheme.bodyLarge
                                    ?.copyWith(height: 1.55),
                              )),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentBlue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                label: const Text('Back to homepage'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageContent {
  const _PageContent({
    required this.icon,
    required this.description,
    this.subtitle,
    this.bullets = const [],
  });

  final IconData icon;
  final String description;
  final String? subtitle;
  final List<String> bullets;
}

_PageContent _content(String t) {
  switch (t) {
    case 'Donation Pages':
      return _PageContent(
        icon: Icons.volunteer_activism,
        subtitle: 'Accept donations with confidence',
        description:
            'Set up a clean and easy-to-use donation form that helps supporters contribute to your cause effortlessly.',
        bullets: [
          'Custom titles, colors, and descriptions.',
          'Support for recurring and one-time gifts.',
        ],
      );
    case 'Event Ticketing':
      return _PageContent(
        icon: Icons.event_available,
        subtitle: 'Manage your next event seamlessly',
        description:
            'Easily create event pages, track attendees, and collect ticket purchases all in one place.',
        bullets: [
          'Add ticket prices and event details.',
          'Monitor ticket sales and capacity.',
        ],
      );
    case 'Peer-to-Peer':
      return _PageContent(
        icon: Icons.groups_2,
        subtitle: 'Let others fundraise on your behalf',
        description:
            'Allow your supporters to create their own fundraising pages tied to your main campaign.',
        bullets: [
          'Peer page customization options.',
          'Track top fundraisers and teams.',
        ],
      );
    case 'Crowdfunding':
      return _PageContent(
        icon: Icons.track_changes,
        subtitle: 'Fuel big ideas with shared support',
        description:
            'Create campaign pages for specific goals and share them with your community.',
        bullets: [
          'Real-time progress tracking.',
          'Engaging layout to boost sharing.',
        ],
      );
    case 'Zero Fees':
      return _PageContent(
        icon: Icons.money_off_csred,
        subtitle: 'Every dollar supports your mission',
        description:
            'Our platform doesn’t take a cut from your donations, so you keep what you raise.',
        bullets: [
          'Only standard payment processing fees apply.',
          'Optional tips help support the platform.',
        ],
      );
    case 'Mobile App':
      return _PageContent(
        icon: Icons.smartphone,
        subtitle: 'Fundraise on the go',
        description:
            'Manage your forms and campaigns from your phone or tablet with a smooth, mobile-ready interface.',
        bullets: [
          'Clean layout for small screens.',
          'Fast access to key form data.',
        ],
      );
    case 'Analytics':
      return _PageContent(
        icon: Icons.equalizer,
        subtitle: 'Track and improve performance',
        description:
            'Get a snapshot of your fundraising activity through clean visual summaries.',
        bullets: [
          'View total donations and campaign activity.',
          'Identify popular forms and trends.',
        ],
      );
    case 'Integrations':
      return _PageContent(
        icon: Icons.extension,
        subtitle: 'Connect with your tools',
        description:
            'Easily sync your campaigns with key tools you already use.',
        bullets: [
          'Simple export features available.',
          'Future support for common APIs planned.',
        ],
      );
    case 'Help Center':
      return _PageContent(
        icon: Icons.help_outline,
        subtitle: 'Guidance when you need it',
        description:
            'Access helpful documentation and examples to guide your setup and fundraising.',
        bullets: [
          'Clear step-by-step help articles.',
          'Dedicated setup examples and tutorials.',
        ],
      );
    case 'Contact Us':
      return _PageContent(
        icon: Icons.mail_outline,
        subtitle: 'Reach out anytime',
        description:
            'Have questions or suggestions? Our team is ready to support you.',
        bullets: [
          'Use the built-in contact form.',
          'Expect fast and helpful replies.',
        ],
      );
    case 'Blog':
      return _PageContent(
        icon: Icons.article_outlined,
        subtitle: 'Stories and insights',
        description:
            'Explore our latest updates, community success stories, and tips for better fundraising.',
        bullets: [
          'Helpful tips for maximizing reach.',
          'News about platform features.',
        ],
      );
    case 'Resources':
      return _PageContent(
        icon: Icons.menu_book,
        subtitle: 'Useful tools at your fingertips',
        description:
            'Access downloadable resources to improve your fundraising strategy.',
        bullets: [
          'Design templates and planning tools.',
          'New materials added regularly.',
        ],
      );
    case 'Sign up':
      return _PageContent(
        icon: Icons.rocket_launch_rounded,
        subtitle: 'Get started in minutes',
        description:
            'Create your account and start building your first fundraising form in just a few clicks.',
        bullets: [
          'No setup fees or contracts.',
          'Access to all major features from day one.',
        ],
      );
    default:
      return _PageContent(
        icon: Icons.info_outline,
        description:
            'More information about this page will be available soon. Stay tuned for updates.',
      );
  }
}
