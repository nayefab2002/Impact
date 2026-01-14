class BankAccount {
  final String id; // Document ID from Firestore
  final String bankName;
  final String accountType;
  final String accountNumber; // Changed from amount
  final String routingNumber; // New field
  final DateTime createdAt;

  BankAccount({
    this.id = '',
    required this.bankName,
    required this.accountType,
    required this.accountNumber,
    required this.routingNumber,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'accountType': accountType,
      'accountNumber': accountNumber,
      'routingNumber': routingNumber,
      'createdAt': createdAt,
    };
  }

  factory BankAccount.fromFirestore(String id, Map<String, dynamic> data) {
    return BankAccount(
      id: id,
      bankName: data['bankName'] ?? '',
      accountType: data['accountType'] ?? '',
      accountNumber: data['accountNumber'] ?? '',
      routingNumber: data['routingNumber'] ?? '',
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }
}