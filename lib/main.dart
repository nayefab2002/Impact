import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:impact/firebase_options.dart';
import 'package:impact/providers/firebase_provider.dart';

import 'package:impact/animations/slide_animation.dart';
import 'package:impact/screens/dashboard/impact_dashboard.dart';
import 'package:impact/screens/dashboard/form_selection_page.dart';
import 'package:impact/screens/forms/auction/auction_screen.dart';
import 'package:impact/screens/forms/custom/custom_screen.dart';
import 'package:impact/screens/forms/donation/donation_screen.dart';
import 'package:impact/screens/forms/membership/membership_screen.dart';
import 'package:impact/screens/forms/online_shop/shop_form_screen.dart';
import 'package:impact/screens/forms/peer_to_peer/peer_to_peer_screen.dart';
import 'package:impact/screens/forms/raffle/raffle_screen.dart';
import 'package:impact/screens/home_page.dart';

/* ------------ Donation ------------ */
import 'package:impact/screens/forms/donation/donation_form_general.dart';
import 'package:impact/screens/forms/donation/donation_form_customization.dart';
import 'package:impact/screens/forms/donation/donation_form_advanced.dart';

/* ------------ Event ------------ */
import 'package:impact/screens/forms/event/event_screen.dart';

/* ------------ Peer-to-Peer ------------ */
import 'package:impact/screens/forms/peer_to_peer/peer_form_general.dart';
import 'package:impact/screens/forms/peer_to_peer/peer_form_customization.dart';
import 'package:impact/screens/forms/peer_to_peer/peer_form_advanced.dart';

/* ------------ Online shop ------------ */
import 'package:impact/screens/forms/online_shop/shop_form_general.dart';
import 'package:impact/screens/forms/online_shop/shop_form_customization.dart';
import 'package:impact/screens/forms/online_shop/shop_form_advanced.dart';


/* ------------ Raffle ------------ */
import 'package:impact/screens/forms/raffle/raffle_form_general.dart';
import 'package:impact/screens/forms/raffle/raffle_form_customization.dart';
import 'package:impact/screens/forms/raffle/raffle_form_advanced.dart';

/* ------------ Membership ------------ */
import 'package:impact/screens/forms/membership/membership_form_general.dart';
import 'package:impact/screens/forms/membership/membership_form_memberships.dart';
import 'package:impact/screens/forms/membership/membership_form_customization.dart';

/* ------------ Auction ------------ */
import 'package:impact/screens/forms/auction/auction_form_general.dart';
import 'package:impact/screens/forms/auction/auction_form_customization.dart';
import 'package:impact/screens/forms/auction/auction_form_advanced.dart';

/* ------------ Custom ------------ */
import 'package:impact/screens/forms/custom/custom_form_general.dart';
import 'package:impact/screens/forms/custom/custom_form_customization.dart';
import 'package:impact/screens/forms/custom/custom_form_advanced.dart';
import 'package:impact/screens/forms/custom/custom_form_confirmation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: ImpactApp()));
}

class ImpactApp extends ConsumerStatefulWidget {
  const ImpactApp({super.key});
  @override
  ConsumerState<ImpactApp> createState() => _ImpactAppState();
}

class _ImpactAppState extends ConsumerState<ImpactApp> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangeProvider);

    return MaterialApp(
      title: 'Impact Fundraising',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.light,
      onGenerateRoute: _generateRoute,
      home: _home(authState),
    );
  }

  /* ---------- Restored Theme ---------- */
  final _lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'poppins',
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF7B8BFF),
      secondary: Colors.tealAccent,
      background: Color(0xFF0B0B5A),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF7B8BFF),
        foregroundColor: Colors.white,
        elevation: 4,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(0xFF0B0B5A),
    ),
  );

  final _darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'poppins',
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7B8BFF),
      secondary: Colors.tealAccent,
    ),
  );

  /* ---------- Routing ---------- */
  Route<dynamic> _generateRoute(RouteSettings s) {
    switch (s.name) {
      case '/donation_screen':
        return createSlideRoute(const DonationScreen(), beginOffset: const Offset(1, 0));
      case '/event_screen':
        return createSlideRoute(const EventScreen(), beginOffset: const Offset(1, 0));

      case '/peer_screen':
        return createSlideRoute(const PeerToPeerScreen(), beginOffset: const Offset(1, 0));

      case '/shop_screen':
        return createSlideRoute(const OnlineShopScreen(), beginOffset: const Offset(1, 0));

      case '/raffle_screen':
        return createSlideRoute(const RaffleScreen(), beginOffset: const Offset(1, 0));

      case '/membership_screen':
        return createSlideRoute(const MembershipScreen(), beginOffset: const Offset(1, 0));

      case '/auction_screen':
        return createSlideRoute(const AuctionScreen(), beginOffset: const Offset(1, 0));

      case '/custom_screen':
        return createSlideRoute(const CustomScreen(), beginOffset: const Offset(1, 0));


      case '/forms':
        return createSlideRoute(const FundraisingUI(), beginOffset: const Offset(1, 0));

      default:
        return createSlideRoute(
          const Scaffold(body: Center(child: Text('Page Not Found'))),
          beginOffset: const Offset(1, 0),
        );
    }
  }

  Widget _home(AsyncValue<User?> auth) => auth.when(
        data: (u) => u != null ? const ImpactDashboard() : const ImpactHomePage(),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      );
}
