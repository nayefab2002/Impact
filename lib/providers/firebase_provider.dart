import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:impact/models/bank_account.dart';
import 'package:impact/screens/forms/models/base_form.dart';
import 'package:impact/screens/forms/models/event_form.dart';
import 'package:impact/services/db_service.dart';

import '../models/contact.dart';

final firebaseAuthProvider = Provider((ref) {
  return FirebaseAuth.instance;
});

final authStateChangeProvider = StreamProvider<User?>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return firebaseAuth.authStateChanges();
});
final currentUserIDProvider = Provider<String>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return firebaseAuth.currentUser!.uid;
});

//Analytics provider
final firebaseAnalyticsProvider = Provider<FirebaseAnalytics>((ref) {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  return analytics;
});


//Firebase firestore related providers

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final allFormsProvider = StreamProvider.autoDispose<List<BaseForm>>((ref) {
  final userId = ref.watch(currentUserIDProvider);
  final dbsService=ref.read(firestoreServiceProvider);

  // Create individual streams
  final eventStream = dbsService.fetchForms(userId, 'event');
  final donationStream = dbsService.fetchForms(userId, 'donation');
  final raffleStream=dbsService.fetchForms(userId, "raffle");
  final auctionStream=dbsService.fetchForms(userId, "auction");
  final peerStream=dbsService.fetchForms(userId, "peer_to_peer");
  final shopStream=dbsService.fetchForms(userId, "shop");
  final customStream=dbsService.fetchForms(userId, "custom");
  final membershipStream=dbsService.fetchForms(userId, "membership");
  //final raffleStream = _fetchForms(userId, 'raffle');

  // Combine using Stream.multi (Riverpod-friendly approach)
  return Stream.multi((controller) {
    var events = <BaseForm>[];
    var donations = <BaseForm>[];
    var raffles = <BaseForm>[];
    var memberships=<BaseForm>[];
    var shops=<BaseForm>[];
    var auctions=<BaseForm>[];
    var peers=<BaseForm>[];
    var custom=<BaseForm>[];

    void emitCombined() {
      controller.add([...events, ...donations,...raffles,...memberships,...shops,...auctions,...peers,...custom]);
    }

    final subscriptions = [
      eventStream.listen((eventForms) {
        events = eventForms;
        emitCombined();
      }),
      donationStream.listen((donationForms) {
        donations = donationForms;
        emitCombined();
      }),
      raffleStream.listen((raffleForms) {
        raffles = raffleForms;
        emitCombined();
      }),
      auctionStream.listen((auctionForms) {
        auctions = auctionForms;
        emitCombined();
      }),
      peerStream.listen((peerForms) {
        peers = peerForms;
        emitCombined();
      }),
      shopStream.listen((shopForms) {
        shops = shopForms;
        emitCombined();
      }),
      customStream.listen((customForms) {
        custom = customForms;
        emitCombined();
      }),
      membershipStream.listen((membershipForms) {
        memberships = membershipForms;
        emitCombined();
      }),

    ];

    // Cleanup
    ref.onDispose(() {
      for (final sub in subscriptions) {
        sub.cancel();
      }
    });
  });
});
final userContactListProvider = StreamProvider<List<Contact>>((ref) {
  final contactList=ref.read(firestoreServiceProvider).fetchUserContacts(ref.read(currentUserIDProvider));
  return contactList;
});

final bankAccountsProvider = StreamProvider.autoDispose<List<BankAccount>>((ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  final userId = ref.read(currentUserIDProvider);
  return firestoreService.fetchUserBankAccounts(userId); 
});