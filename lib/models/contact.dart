

class Contact{
  late final String name;
  late final String email;
  late final double amount;
  late final String type;
  Contact({required this.name,required this.email, required this.amount, required this.type});

  Map<String, dynamic> toJson(){
    return {
      'name':name,
      'email':email,
      'amount':amount,
      'type':type
    };
  }
  factory Contact.fromFirestore(dynamic snapshot){
    final data=snapshot.data();
    return Contact(name: data?["name"]??"", email: data?["email"]??"",
        amount: data?["amount"]??0.0, type: data?["type"]??"donor");
  }
}