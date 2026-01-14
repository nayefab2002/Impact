import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/firebase_provider.dart';
import 'package:impact/screens/forms/models/auction_form.dart';
import 'package:impact/screens/forms/models/custom_form.dart';
import 'package:impact/screens/forms/models/donation_form.dart';
import 'package:impact/screens/forms/models/event_form.dart';
import 'package:impact/screens/forms/models/membership_form.dart';
import 'package:impact/screens/forms/models/online_shop_form.dart';
import 'package:impact/screens/forms/models/peer_to_peer_form.dart';
import 'package:impact/screens/forms/models/raffle_form.dart';
import 'package:impact/screens/forms/preview/auction_form_preview.dart';
import 'package:impact/screens/forms/preview/custom_form_preview.dart';
import 'package:impact/screens/forms/preview/donation_form_preview.dart';
import 'package:impact/screens/forms/preview/event_form_preview.dart';
import 'package:impact/screens/forms/preview/membership_form_preview.dart';
import 'package:impact/screens/forms/preview/peer_form_preview.dart';
import 'package:impact/screens/forms/preview/raffle_form_preview.dart';
import 'package:impact/screens/forms/preview/shop_form_preview.dart';
import 'package:impact/services/db_service.dart';
import 'package:impact/widgets/forms/auction_form_card.dart';
import 'package:impact/widgets/forms/custom_form_card.dart';
import 'package:impact/widgets/forms/event_form_card.dart';
import 'package:impact/widgets/forms/membership_form_card.dart';
import 'package:impact/widgets/forms/online_shop_form_card.dart';
import 'package:impact/widgets/forms/peer_to_peer_form_card.dart';

import '../../widgets/forms/donation_form_card.dart';
import '../../widgets/forms/raffle_form_card.dart';
import '../forms/models/base_form.dart';

class DashboardHome extends ConsumerStatefulWidget {
  const DashboardHome({super.key});

  @override
  ConsumerState createState() => _DashboardHomeState();
}

class _DashboardHomeState extends ConsumerState<DashboardHome> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget _buildFormCard(BaseForm form) {
    switch (form.formType) {
      case 'event':
        return EventFormCard(form: form as EventForm,onEdit: (){},onView: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>EventFormPreviewScreen(eventData: form)));
        },);
      case 'donation':
        return DonationFormCard(form: form as DonationForm,onEdit: (){},onView: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DonationFormPreviewScreen(donationData: form)));
        },);
      case 'raffle':
        return RaffleFormCard(form: form as RaffleForm,onEdit: (){},onView: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>RaffleFormPreviewScreen(raffleData: form)));
        },);
      case "auction":
        return AuctionFormCard(form: form as AuctionForm, onEdit: (){}, onView: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AuctionFormPreviewScreen(auctionData: form)));
        });
      case "membership":
        return MembershipFormCard(form: form as MembershipForm, onEdit: (){}, onView: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>MembershipFormPreviewScreen(membershipData: form)));
        });
      case "custom":
        return CustomFormCard(form: form as CustomForm, onEdit: (){}, onView: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomFormPreviewScreen(formData: form)));

        });
      case "peer_to_peer":
        return PeerToPeerFormCard(form: form as PeerToPeerForm, onEdit: (){}, onView: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>PeerToPeerFormPreviewScreen(peerFormData: form)));

        });
      case "shop":
        return OnlineShopFormCard(form: form as ShopForm, onEdit: (){}, onView: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>OnlineShopPreviewScreen(shopFormData: form)));
        });
      default:
        return Card(child: Text('Unsupported form: ${form.formType}'));
    }
  }
  @override
  Widget build(BuildContext context) {
    final allForms=ref.watch(allFormsProvider);
    return Scaffold(
      body: allForms.when(data: (data){
        if(data.isEmpty){
          return _buildEmptyState();
        }else{
          debugPrint("Count: ${data.length}");
          return Padding(padding: EdgeInsets.all(16),child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Campaigns',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
             Expanded(child: ListView.builder(itemBuilder: (context, index){
               final currentForm=data[index];

               return _buildFormCard(currentForm);
             },itemCount: data.length,shrinkWrap: true,),)


            ],
          ),);
        }
      },
          error: (_,err){
            print(err.toString());
            return _buildErrorState();
          },
          loading: ()=>_buildLoadingState()),
    );
  }
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.volunteer_activism,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Your recent donations and activity will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Error Loading Data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please try again later',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }


}
