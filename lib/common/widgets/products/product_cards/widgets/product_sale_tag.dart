import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../custom_shapes/containers/rounded_container.dart';

class ProductSaleTagWidget extends StatelessWidget {
  const ProductSaleTagWidget({
    super.key,
    required this.salePercentage,
  });

  final String? salePercentage;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      child: TRoundedContainer(
        radius: TSizes.sm,
        backgroundColor: TColors.secondary.withOpacity(0.8),
        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
        child: Text('$salePercentage%', style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors.black)),
      ),
    );
  }
}