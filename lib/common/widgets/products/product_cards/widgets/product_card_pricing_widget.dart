import 'package:cwt_ecommerce_app/features/shop/models/product_model.dart';
import 'package:flutter/material.dart';

import '../../../../../features/shop/controllers/product/product_controller.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../texts/t_product_price_text.dart';

class PricingWidget extends StatelessWidget {
  const PricingWidget({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Actual Price if sale price not null
          if (product.productType == ProductType.single.toString() && product.salePrice > 0)
            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: Text(
                product.price.toString(),
                style: Theme.of(context).textTheme.labelMedium!.apply(decoration: TextDecoration.lineThrough),
              ),
            ),

          /// Price, Show sale price as main price if sale exist.
          Padding(
            padding: const EdgeInsets.only(left: TSizes.sm),
            child: TProductPriceText(price: ProductController.instance.getProductPrice(product)),
          ),
        ],
      ),
    );
  }
}
