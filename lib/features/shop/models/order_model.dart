import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../personalization/models/address_model.dart';
import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final double shippingCost;
  final double taxCost;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? shippingAddress;
  final AddressModel? billingAddress;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;
  final bool billingAddressSameAsShipping;

  OrderModel({
    required this.id,
    this.userId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.shippingCost,
    required this.taxCost,
    required this.orderDate,
    this.paymentMethod = 'Cash on Delivery',
    this.billingAddress,
    this.shippingAddress,
    this.deliveryDate,
    this.billingAddressSameAsShipping = true,
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => deliveryDate != null ? THelperFunctions.getFormattedDate(deliveryDate!) : '';

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Delivered'
      : status == OrderStatus.shipped
          ? 'Shipment on the way'
          : 'Processing';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(), // Enum to string
      'totalAmount': totalAmount,
      'shippingCost': shippingCost,
      'taxCost': taxCost,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'billingAddress': billingAddress?.toJson(), // Convert AddressModel to map
      'shippingAddress': shippingAddress?.toJson(), // Convert AddressModel to map
      'deliveryDate': deliveryDate,
      'billingAddressSameAsShipping': billingAddressSameAsShipping,
      'items': items.map((item) => item.toJson()).toList(), // Convert CartItemModel to map
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return OrderModel(
      id: data.containsKey('id') ? data['id'] as String : '',
      userId: data.containsKey('userId') ? data['userId'] as String : '',
      status: data.containsKey('status') ? OrderStatus.values.firstWhere((e) => e.toString() == data['status']) : OrderStatus.pending, // Default status
      totalAmount: data.containsKey('totalAmount') ? data['totalAmount'] as double : 0.0,
      shippingCost: data.containsKey('shippingCost') ? (data['shippingCost'] as num).toDouble() : 0.0,
      taxCost: data.containsKey('taxCost') ? (data['taxCost'] as num).toDouble() : 0.0,
      orderDate: data.containsKey('orderDate') ? (data['orderDate'] as Timestamp).toDate() : DateTime.now(), // Default to current time
      paymentMethod: data.containsKey('paymentMethod') ? data['paymentMethod'] as String : '',
      billingAddressSameAsShipping: data.containsKey('billingAddressSameAsShipping') ? data['billingAddressSameAsShipping'] as bool : true,
      billingAddress: data.containsKey('billingAddress') ? AddressModel.fromMap(data['billingAddress'] as Map<String, dynamic>) : AddressModel.empty(),
      shippingAddress: data.containsKey('shippingAddress') ? AddressModel.fromMap(data['shippingAddress'] as Map<String, dynamic>) : AddressModel.empty(),
      deliveryDate: data.containsKey('deliveryDate') && data['deliveryDate'] != null ? (data['deliveryDate'] as Timestamp).toDate() : null,
      items: data.containsKey('items') ? (data['items'] as List<dynamic>).map((itemData) => CartItemModel.fromJson(itemData as Map<String, dynamic>)).toList() : [],
    );
  }
}
