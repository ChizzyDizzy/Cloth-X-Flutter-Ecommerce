import 'package:cwt_ecommerce_app/features/shop/controllers/product/checkout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/sizes.dart';

class TBillingAmountSection extends StatelessWidget {
  const TBillingAmountSection({super.key, required this.subTotal});

  final double subTotal;

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    return Column(
      children: [
        /// -- Sub Total
        Row(
          children: [
            Expanded(child: Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium)),
            Text('\$${subTotal.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),

        /// -- Shipping Fee
        Row(
          children: [
            Expanded(child: Text('Shipping Fee', style: Theme.of(context).textTheme.bodyMedium)),
            Obx(
              () => Text(
                '\$${controller.isShippingFree(subTotal) ? 'Free' : (controller.getShippingCost(subTotal)).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),

        /// -- Tax Fee
        Row(
          children: [
            Expanded(child: Text('Tax Fee', style: Theme.of(context).textTheme.bodyMedium)),
            Obx(
              () => Text(
                '\$${controller.getTaxAmount(subTotal).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        /// -- Order Total
        Row(
          children: [
            Expanded(child: Text('Order Total', style: Theme.of(context).textTheme.titleMedium)),
            Text(
              '\$${controller.getTotal(subTotal)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
