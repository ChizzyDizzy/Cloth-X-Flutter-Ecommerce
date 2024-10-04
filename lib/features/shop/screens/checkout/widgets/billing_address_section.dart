import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../personalization/controllers/address_controller.dart';
import '../../../../personalization/models/address_model.dart';

/// Widget representing the billing address section.
class TAddressSection extends StatelessWidget {
  const TAddressSection({
    super.key,
    required this.isBillingAddress,
  });

  final bool isBillingAddress;

  @override
  Widget build(BuildContext context) {
    final addressController = AddressController.instance;

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display shipping address heading with a change button.
          TSectionHeading(
            title: isBillingAddress ? 'Billing Address' : 'Shipping Address',
            buttonTitle: 'Change',
            showActionButton: true,
            onPressed: () => addressController.selectNewAddressPopup(context: context, isBillingAddress: isBillingAddress),
          ),

          // Check if an address is selected, if true, display address details; otherwise, prompt to select an address.
          isBillingAddress
              ? addressController.selectedBillingAddress.value.id.isNotEmpty
                  ? _buildAddressDetails(context, addressController.selectedBillingAddress.value)
                  : Text('Select Address', style: Theme.of(context).textTheme.bodyMedium)
              : addressController.selectedAddress.value.id.isNotEmpty
                  ? _buildAddressDetails(context, addressController.selectedAddress.value)
                  : Text('Select Address', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  /// Build address details widget.
  Widget _buildAddressDetails(BuildContext context, AddressModel selectedAddress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the name of the selected address.
        Text(selectedAddress.name, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Row(
          children: [
            // Display a phone icon followed by the formatted phone number.
            const Icon(Icons.phone, color: Colors.grey, size: 16),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(selectedAddress.formattedPhoneNo, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Row(
          children: [
            // Display a location history icon followed by the address.
            const Icon(Icons.location_history, color: Colors.grey, size: 16),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              child: Text(
                selectedAddress.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
