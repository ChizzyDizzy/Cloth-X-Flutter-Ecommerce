import 'package:cwt_ecommerce_app/common/widgets/icons/t_circular_icon.dart';
import 'package:cwt_ecommerce_app/features/personalization/screens/address/update_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/address_controller.dart';
import '../../../models/address_model.dart';

class TSingleAddress extends StatelessWidget {
  const TSingleAddress({
    super.key,
    required this.address,
    required this.onTap,
    required this.isBillingAddress,
  });

  final AddressModel address;
  final VoidCallback onTap;
  final bool isBillingAddress;

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Obx(
      () {
        String selectedAddressId = '';
        selectedAddressId = isBillingAddress ? controller.selectedBillingAddress.value.id : controller.selectedAddress.value.id;
        final isAddressSelected = selectedAddressId == address.id;
        return GestureDetector(
          onTap: onTap,
          child: TRoundedContainer(
            showBorder: true,
            padding: const EdgeInsets.all(TSizes.md),
            width: double.infinity,
            backgroundColor: isAddressSelected ? TColors.primary.withOpacity(0.1) : Colors.transparent,
            borderColor: isAddressSelected
                ? Colors.transparent
                : dark
                    ? TColors.darkerGrey
                    : TColors.grey,
            margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  child: TCircularIcon(
                    backgroundColor: TColors.primary.withOpacity(0.6),
                    width: 42,
                    height: 42,
                    size: TSizes.md,
                    color: Colors.white,
                    icon: Iconsax.edit_24,
                    onPressed: () => Get.to(() => UpdateAddressScreen(address: address)),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      isAddressSelected ? Iconsax.tick_circle1 : Iconsax.tick_circle1,
                      color: isAddressSelected
                          ? TColors.primary
                          : dark
                              ? TColors.darkerGrey
                              : TColors.grey,
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                address.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            const SizedBox(height: TSizes.sm / 2),
                            Text(address.formattedPhoneNo, maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: TSizes.sm / 2),
                            Expanded(
                              child: Text(
                                address.toString(),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
