import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/personalization/models/address_model.dart';
import '../authentication/authentication_repository.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;

  /* ---------------------------- FUNCTIONS ---------------------------------*/

  /// Get all order related to current User
  Future<List<AddressModel>> fetchUserAddresses() async {
    try {
      final userId = AuthenticationRepository.instance.firebaseUser!.uid;
      if (userId.isEmpty) throw 'Unable to find user information. Try again in few minutes.';

      final result = await _db.collection('Users').doc(userId).collection('Addresses').get();
      return result.docs.map((documentSnapshot) => AddressModel.fromDocumentSnapshot(documentSnapshot)).toList();
    } catch (e) {
      // log e.toString();
      throw 'Something went wrong while fetching Address Information. Try again later';
    }
  }

  /// Store new user order
  Future<String> addAddress(AddressModel address, String userId) async {
    try {
      final currentAddress = await _db.collection('Users').doc(userId).collection('Addresses').add(address.toJson());
      return currentAddress.id;
    } catch (e) {
      throw 'Something went wrong while saving Address Information. Try again later';
    }
  }

  /// Update user address
  Future<void> updateAddress(AddressModel address, String userId) async {
    try {
      await _db.collection('Users').doc(userId).collection('Addresses').doc(address.id).update(address.toJson());
    } catch (e) {
      throw 'Something went wrong while saving Address Information. Try again later';
    }
  }

  /// Clear the "selected" field for all addresses
  Future<void> updateSelectedField(String userId, String addressId, bool selected) async {
    try {
      await _db.collection('Users').doc(userId).collection('Addresses').doc(addressId).update({'SelectedAddress': selected});
    } catch (e) {
      throw 'Unable to update your address selection. Try again later';
    }
  }
}
