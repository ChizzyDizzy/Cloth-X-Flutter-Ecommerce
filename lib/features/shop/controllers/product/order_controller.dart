import 'package:cwt_ecommerce_app/common/widgets/success_screen/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/order/order_repository.dart';
import '../../../../home_menu.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/controllers/address_controller.dart';
import '../../models/order_model.dart';
import 'cart_controller.dart';
import 'checkout_controller.dart';
import 'product_controller.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  /// Variables
  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());

  /// Fetch user's order history
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userOrders = await orderRepository.fetchUserOrders();
      return userOrders;
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /// Add methods for order processing
  void processOrder(double subTotal) async {
    try {
      // Start Loader
      TFullScreenLoader.openLoadingDialog('Processing your order', TImages.pencilAnimation);

      // Get user authentication Id
      final userId = AuthenticationRepository.instance.getUserID;
      if (userId.isEmpty) return;

      if (addressController.billingSameAsShipping.isFalse) {
        if (addressController.selectedBillingAddress.value.id.isEmpty) {
          TLoaders.warningSnackBar(title: 'Billing Address Required', message: 'Please add Billing Address in order to proceed.');
          return;
        }
      }

      // Add Details
      final order = OrderModel(
        // Generate a unique ID for the order
        id: UniqueKey().toString(),
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: checkoutController.getTotal(subTotal),
        orderDate: DateTime.now(),
        shippingAddress: addressController.selectedAddress.value,
        billingAddress: addressController.selectedBillingAddress.value,
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        billingAddressSameAsShipping: addressController.billingSameAsShipping.value,
        deliveryDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7),
        items: cartController.cartItems.toList(),
        shippingCost: checkoutController.getShippingCost(subTotal),
        taxCost: checkoutController.getTaxAmount(subTotal),
      );

      // Trigger payment gateway
      // if(checkoutController.selectedPaymentMethod.value.name == PaymentMethods.paypal.name) {
      //   final response = await TPaypalService.getPayment();
      //   print('Paypal Payment is ${response ? 'Successful' : 'Failed'}');
      //   if(response) TLoaders.successSnackBar(title: 'Congratulations', message: 'Paypal Payment Paid');
      //   if(!response) TLoaders.warningSnackBar(title: 'Failed', message: 'Paypal Payment Failed');
      // }

      // Save the order to Firestore
      await orderRepository.saveOrder(order, userId);

      // Once the order placed, update Stock of each item
      final productController = Get.put(ProductController());

      for (var product in cartController.cartItems) {
        await productController.updateProductStock(product.productId, product.quantity, product.variationId);
      }

      // Update the cart status
      cartController.clearCart();

      // Show Success screen
      Get.off(() => SuccessScreen(
            image: TImages.orderCompletedAnimation,
            title: 'Payment Success!',
            subTitle: 'Your item will be shipped soon!',
            onPressed: () => Get.offAll(() => const HomeMenu()),
          ));
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
