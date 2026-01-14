import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impact/animations/slide_animation.dart';
import 'package:impact/providers/firebase_provider.dart';

/* Dashboard Pages */
import 'dashboard_contacts.dart';
import 'dashboard_home.dart';
import 'dashboard_payments.dart';
import 'dashboard_bank.dart'; // ✅ Add this line
import 'form_selection_page.dart';

class ImpactDashboard extends ConsumerStatefulWidget {
  const ImpactDashboard({super.key});

  @override
  ConsumerState<ImpactDashboard> createState() => _ImpactDashboardState();
}

class _ImpactDashboardState extends ConsumerState<ImpactDashboard> {
  int _selectedIndex = 0;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final List<DashboardItem> _menuItems;

  @override
  void initState() {
    super.initState();
    _menuItems = _buildMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(context),
          _buildContentArea(),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFFE6F2FF),
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) => _buildMenuItem(
                context,
                item: _menuItems[index],
                isSelected: index == _selectedIndex,
                onTap: () => _handleMenuTap(index),
              ),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildContentArea() {
    return Expanded(
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          return createSlideRoute(
            _menuItems[_selectedIndex].screen,
            beginOffset: const Offset(0.3, 0.0),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset("assets/icons/impact-logo-v5.svg",height: 60,),
          // Text(
          //   'Impact Dashboard',
          //   style: TextStyle(
          //     fontSize: 20,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.blue[900],
          //   ),
          // ),
          const SizedBox(height: 8),
          Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[800],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required DashboardItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        item.icon,
        color: isSelected ? Colors.blue[900] : Colors.blue[800],
      ),
      title: Text(
        item.label,
        style: TextStyle(
          color: isSelected ? Colors.blue[900] : Colors.blue[800],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? Colors.blue[50] : null,
      onTap: onTap,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Divider(color: Colors.blueGrey),
          const SizedBox(height: 8),
          TextButton.icon(onPressed: (){
            ref.read(firebaseAuthProvider).signOut();
          },
            icon: const Icon(Icons.logout,size: 22, color: Colors.red),label: Text(
              'Log Out',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),),
          const SizedBox(height: 15),
          Text(
            'Need help?',
            style: TextStyle(
              color: Colors.blue[800],
              fontSize: 12,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Contact Support',
              style: TextStyle(
                color: Colors.blue[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuTap(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    _navigatorKey.currentState?.pushReplacement(
      createSlideRoute(
        _menuItems[index].screen,
        beginOffset: const Offset(0.3, 0.0),
      ),
    );
  }

  List<DashboardItem> _buildMenuItems() {
    return [
      DashboardItem(
        label: 'Home',
        icon: Icons.home,
        screen: const DashboardHome(),
      ),
      DashboardItem(
        label: 'Forms',
        icon: Icons.edit,
        screen: const FundraisingUI(),
      ),
      DashboardItem(
        label: 'Payments',
        icon: Icons.payment,
        screen: const DashboardPayments(),
      ),
      DashboardItem(
        label: 'Contacts',
        icon: Icons.contacts,
        screen: const DashboardContacts(),
      ),
      DashboardItem(
        label: 'Bank',
        icon: Icons.account_balance,
        screen: const DashboardBank(), 
      ),
    ];
  }
}

class DashboardItem {
  final String label;
  final IconData icon;
  final Widget screen;

  DashboardItem({
    required this.label,
    required this.icon,
    required this.screen,
  });
}
