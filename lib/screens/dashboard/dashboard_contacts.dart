import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/models/contact.dart';
import 'package:impact/providers/firebase_provider.dart';
import 'package:intl/intl.dart';

class DashboardContacts extends ConsumerStatefulWidget {
  const DashboardContacts({super.key});

  @override
  ConsumerState createState() => _DashboardContactsState();
}

class _DashboardContactsState extends ConsumerState<DashboardContacts> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTypeFilter = 'All';
  final List<String> _typeFilters = ['All', 'Donor', 'Volunteer', 'Sponsor'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Contacts',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            //_buildSearchAndFilterRow(),
            const SizedBox(height: 16),

           // Expanded(child: _buildContactsListView()),
           Expanded(child:buildEventListItem() )

          ],
        ),
      ),
    );
  }
  buildEventListItem(){
    final contactList=ref.watch(userContactListProvider);
    return contactList.when(data: (data){
      if(data.isEmpty){
        return _buildEmptyWidget();
      }
      else{
        return Expanded(child: DataTable2(
            columns: [
              DataColumn(label: Text(
                'Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),),
              DataColumn(label: Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),),
              DataColumn(label: Text(
                'Total amount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),),
              DataColumn(label: TextButton.icon(onPressed: (){},
                icon: const Icon(Icons.person, size: 16, color: Colors.grey),label: Text(
                    'Type',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),)),
            ],
            rows: data.map(_dataRow).toList()));
       // return Column(
       //   children: [
       //     _buildHeaderSection(),
       //     ListView.separated(itemBuilder: (context, index){
       //       return contactListItem(data[index]);
       //     },
       //         separatorBuilder:  (context, index) => const Divider(height: 1),
       //         itemCount: data.length,shrinkWrap: true,)
       //   ],
       // );
      }
    }, error: (_,err){
      print(err.toString());
    }, loading: ()=>Center(child: CircularProgressIndicator(),));
  }
  DataRow _dataRow(Contact contact) {
    return DataRow(
      cells: [
        DataCell(Text(contact.name)),
        DataCell(Text(contact.email)),
        DataCell(Text(contact.amount.toString())),
        DataCell(Text(contact.type)),

      ],
    );
  }


  Widget _buildSearchAndFilterRow() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search Contacts',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                _typeFilters.map((type) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: _selectedTypeFilter == type,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTypeFilter = selected ? type : 'All';
                        });
                      },
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final amountController = TextEditingController();
    String selectedType = 'Donor';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Contact'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items:
                  _typeFilters.where((type) => type != 'All').map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedType = value;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                //todo create Contact model and add it to db
                final contact=Contact(name: nameController.text, email: emailController.text,
                    amount: amountController.text.isEmpty?0.0:double.parse(amountController.text), type: selectedType);
                ref.read(firestoreServiceProvider).addContact(ref.read(currentUserIDProvider), contact);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget contactListItem(Contact contact){
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(contact.name),
          Text(contact.email),
          Text("\$${contact.amount}"),
          Text(contact.type)
        ],
      ),
    );
  }
  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.contacts, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No contacts found'),
          TextButton(
            onPressed: _showAddContactDialog,
            child: const Text('Add your first contact'),
          ),
        ],
      ),
    );
  }
}

// Widget _buildContactsListView() {
//   return StreamBuilder<QuerySnapshot>(
//     stream:
//     FirebaseFirestore.instance
//         .collection('contacts')
//         .orderBy('date', descending: true)
//         .snapshots(),
//     builder: (context, snapshot) {
//       if (snapshot.hasError)
//         return _buildErrorWidget(snapshot.error.toString());
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return _buildLoadingWidget();
//       }
//       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//         return _buildEmptyWidget();
//       }
//
//       var contacts =
//       snapshot.data!.docs.where((doc) {
//         final contact = doc.data() as Map<String, dynamic>;
//         final name = contact['name']?.toString().toLowerCase() ?? '';
//         final email = contact['email']?.toString().toLowerCase() ?? '';
//         final type = contact['type']?.toString() ?? '';
//         final searchTerm = _searchController.text.toLowerCase();
//
//         // Apply type filter
//         if (_selectedTypeFilter != 'All' && type != _selectedTypeFilter) {
//           return false;
//         }
//
//         // Apply search filter
//         return name.contains(searchTerm) || email.contains(searchTerm);
//       }).toList();
//
//       return ListView.separated(
//         itemCount: contacts.length,
//         separatorBuilder: (_, __) => const Divider(height: 1),
//         itemBuilder: (context, index) {
//           final doc = contacts[index];
//           final contact = doc.data() as Map<String, dynamic>;
//           return ListTile(
//             onTap: () => _showContactDetails(doc.id, contact),
//             title: Text(contact['name'] ?? 'Unknown'),
//             subtitle: Text(contact['email'] ?? ''),
//             trailing: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   '\$${contact['amount']?.toStringAsFixed(2) ?? '0.00'}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   _formatDate(contact['date']),
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//             leading: CircleAvatar(
//               backgroundColor: _getTypeColor(contact['type']),
//               child: Text(
//                 contact['type']?.substring(0, 1).toUpperCase() ?? '?',
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
//
//
//
//
//   void _showContactDetails(String docId, Map<String, dynamic> contact) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(contact['name'] ?? 'Contact Details'),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildDetailRow('Email', contact['email'] ?? ''),
//                 _buildDetailRow('Type', contact['type'] ?? ''),
//                 _buildDetailRow(
//                   'Amount',
//                   '\$${contact['amount']?.toStringAsFixed(2) ?? '0.00'}',
//                 ),
//                 _buildDetailRow('Date Added', _formatDate(contact['date'])),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Close'),
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () => _deleteContact(docId),
//               color: Colors.red,
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _deleteContact(String docId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('contacts')
//           .doc(docId)
//           .delete();
//       Navigator.pop(context);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Contact deleted')));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error deleting contact: $e')));
//     }
//   }
//
//   // Helper methods
//   String _formatDate(Timestamp? timestamp) {
//     if (timestamp == null) return 'Not available';
//     return DateFormat('MMM d, y - h:mm a').format(timestamp.toDate());
//   }
//
//   Color _getTypeColor(String? type) {
//     switch (type?.toLowerCase()) {
//       case 'donor':
//         return Colors.green;
//       case 'volunteer':
//         return Colors.blue;
//       case 'sponsor':
//         return Colors.purple;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   Widget _buildLoadingWidget() {
//     return const Center(child: CircularProgressIndicator());
//   }
//
//   Widget _buildEmptyWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.contacts, size: 64, color: Colors.grey),
//           const SizedBox(height: 16),
//           const Text('No contacts found'),
//           TextButton(
//             onPressed: _showAddContactDialog,
//             child: const Text('Add your first contact'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorWidget(String error) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, size: 64, color: Colors.red),
//           const SizedBox(height: 16),
//           const Text('Error loading contacts'),
//           Text(error, style: const TextStyle(color: Colors.red)),
//         ],
//       ),
//     );
//   }
// }
