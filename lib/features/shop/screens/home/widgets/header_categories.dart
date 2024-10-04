import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/image_text/image_text_vertical.dart';
import '../../../../../common/widgets/shimmers/category_shimmer.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/categories_controller.dart';
import '../../sub_category/sub-categories.dart';

/// A header widget displaying popular categories.
class THeaderCategories extends StatelessWidget {
  /// Constructor for [THeaderCategories].
  const THeaderCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());

    return Padding(
      padding: const EdgeInsets.only(left: TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -- Heading
          const TSectionHeading(title: 'Popular Categories', textColor: TColors.white, showActionButton: false),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// Obx widget for reactive UI updates based on the state of [categoryController].
          /// It displays a shimmer loader while categories are being loaded, shows a message if no data is found,
          /// and renders a horizontal list of featured categories with images and text.
          Obx(
            () {
              // Check if categories are still loading
              if (categoryController.isLoading.value) return const TCategoryShimmer();

              // Check if there are no featured categories found
              if (categoryController.featuredCategories.isEmpty) {
                return Center(child: Text('No Data Found!', style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));
              } else {

                /// Data Found
                // Display a horizontal list of featured categories with images and text
                return SizedBox(
                  height: 80,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categoryController.featuredCategories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      final category = categoryController.featuredCategories[index];
                      return TVerticalImageAndText(
                        title: category.name,
                        image: category.image,
                        onTap: () => Get.to(() => SubCategoriesScreen(category: category)),
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
