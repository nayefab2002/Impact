import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/firebase_provider.dart';
import '../models/bank_account.dart';
import '../services/db_service.dart';

class BankState {
  const BankState({
    this.accounts = const [],
    this.isLoading = false,
    this.error,
  });

  final List<BankAccount> accounts;
  final bool isLoading;
  final String? error;

  int get accountCount => accounts.length; 

  BankState copyWith({
    List<BankAccount>? accounts,
    bool? isLoading,
    String? error,
  }) {
    return BankState(
      accounts: accounts ?? this.accounts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class BankNotifier extends StateNotifier<BankState> {
  BankNotifier(this._firestoreService, this._userId) : super(const BankState()) {
    loadAccounts();
  }

  final FirestoreService _firestoreService;
  final String _userId;

  Future<void> loadAccounts() async {
    try {
      state = state.copyWith(isLoading: true);
      final accounts = await _firestoreService.getUserBankAccounts(_userId); // Changed from fetchBankAccounts to getUserBankAccounts
      state = state.copyWith(accounts: accounts, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addAccount(BankAccount account) async {
    try {
      state = state.copyWith(isLoading: true);
      await _firestoreService.addBankAccount(_userId, account);
      await loadAccounts();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> removeAccount(String accountId) async {
    try {
      state = state.copyWith(isLoading: true);
      await _firestoreService.deleteBankAccount(_userId, accountId);
      await loadAccounts();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }
}

final bankProvider = StateNotifierProvider.family<BankNotifier, BankState, String>((ref, userId) {
  final firestoreService = ref.read(firestoreServiceProvider);
  return BankNotifier(firestoreService, userId);
});