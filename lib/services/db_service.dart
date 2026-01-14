import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:impact/models/bank_account.dart';
import 'package:impact/models/contact.dart';
import 'package:impact/screens/forms/models/auction_form.dart';
import 'package:impact/screens/forms/models/base_form.dart';
import 'package:impact/screens/forms/models/custom_form.dart';
import 'package:impact/screens/forms/models/donation_form.dart';
import 'package:impact/screens/forms/models/event_form.dart';
import 'package:impact/screens/forms/models/membership_form.dart';
import 'package:impact/screens/forms/models/peer_to_peer_form.dart';
import 'package:impact/screens/forms/models/raffle_form.dart';
import '../screens/forms/models/online_shop_form.dart';

class FirestoreService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  // Existing form methods
  Stream<List<BaseForm>> fetchForms(String userId, String formType) {
    var allForms = firebaseFirestore
        .collection('forms')
        .doc(formType)
        .collection(formType)
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            switch (formType) {
              case "event":
                return EventForm.fromFirestore(doc);
              case "donation":
                return DonationForm.fromFirestore(doc);
              case "membership":
                return MembershipForm.fromFirestore(doc);
              case "shop":
                return ShopForm.fromFirestore(doc);
              case "peer_to_peer":
                return PeerToPeerForm.fromFirestore(doc);
              case "raffle":
                return RaffleForm.fromFirestore(doc);
              case "custom":
                return CustomForm.fromFirestore(doc);
              default:
                return AuctionForm.fromFirestore(doc);
            }
          }).toList(),
        );
    return allForms;
  }

  Future addEventForm(EventForm form) async {
    final formDocRef = firebaseFirestore
        .collection('forms')
        .doc(form.formType)
        .collection(form.formType)
        .doc();
    final updatedForm = form.copyWith(id: formDocRef.id);
    await formDocRef.set(updatedForm.toJson());
  }

  Future addDonationForm(DonationForm form) async {
    final formDocRef = firebaseFirestore
        .collection('forms')
        .doc(form.formType)
        .collection(form.formType)
        .doc();
    final updatedForm = form.copyWith(id: formDocRef.id);
    await formDocRef.set(updatedForm.toJson());
  }

  Future addMembershipForm(MembershipForm form) async {
    final formDocRef = firebaseFirestore
        .collection('forms')
        .doc(form.formType)
        .collection(form.formType)
        .doc();
    final updatedForm = form.copyWith(id: formDocRef.id);
    await formDocRef.set(updatedForm.toJson());
  }

  Future addOnlineShopForm(ShopForm form) async {
    final formDocRef = firebaseFirestore
        .collection('forms')
        .doc(form.formType)
        .collection(form.formType)
        .doc();
    final updatedForm = form.copyWith(id: formDocRef.id);
    await formDocRef.set(updatedForm.toJson());
  }

  Future addCustomForm(CustomForm form) async {
    final formDocRef = firebaseFirestore
        .collection('forms')
        .doc(form.formType)
        .collection(form.formType)
        .doc();
    final updatedForm = form.copyWith(id: formDocRef.id);
    await formDocRef.set(updatedForm.toJson());
  }

  Future addPeerToPeerForm(PeerToPeerForm form) async {
    final formDocRef = firebaseFirestore
        .collection('forms')
        .doc(form.formType)
        .collection(form.formType)
        .doc();
    final updatedForm = form.copyWith(id: formDocRef.id);
    await formDocRef.set(updatedForm.toJson());
  }

  Future addRaffleForm(RaffleForm form) async {
    final formDocRef = firebaseFirestore
        .collection('forms')
        .doc(form.formType)
        .collection(form.formType)
        .doc();
    final updatedForm = form.copyWith(id: formDocRef.id);
    await formDocRef.set(updatedForm.toJson());
  }

  Future addAuctionForm(AuctionForm form) async {
    final formDocRef = firebaseFirestore
        .collection('forms')
        .doc(form.formType)
        .collection(form.formType)
        .doc();
    final updatedForm = form.copyWith(id: formDocRef.id);
    await formDocRef.set(updatedForm.toJson());
  }

  // Existing contact methods
  Future addContact(String userID, Contact contact) async {
    await firebaseFirestore
        .collection('contact')
        .doc(userID)
        .collection('contacts')
        .add(contact.toJson());
  }

  Stream<List<Contact>> fetchUserContacts(String userID) {
    return firebaseFirestore
        .collection('contact')
        .doc(userID)
        .collection('contacts')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Contact.fromFirestore(doc)).toList(),
        );
  }

  // New bank account methods (following same pattern as contacts)
  Future<void> addBankAccount(String userId, BankAccount account) async {
    await firebaseFirestore
        .collection('bank')
        .doc(userId)
        .collection('accounts')
        .add(account.toJson());
  }

  Future<void> deleteBankAccount(String userId, String accountId) async {
    await firebaseFirestore
        .collection('bank')
        .doc(userId)
        .collection('accounts')
        .doc(accountId)
        .delete();
  }

  Stream<List<BankAccount>> fetchUserBankAccounts(String userId) {
    return firebaseFirestore
        .collection('bank')
        .doc(userId)
        .collection('accounts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return BankAccount.fromFirestore(doc.id, doc.data());
            }).toList());
  }

  Future<List<BankAccount>> getUserBankAccounts(String userId) async {
    final snapshot = await firebaseFirestore
        .collection('bank')
        .doc(userId)
        .collection('accounts')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => BankAccount.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}