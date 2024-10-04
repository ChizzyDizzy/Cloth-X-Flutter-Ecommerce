import 'package:cwt_ecommerce_app/common/widgets/images/t_circular_image.dart';
import 'package:cwt_ecommerce_app/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:cwt_ecommerce_app/common/widgets/shimmers/category_shimmer.dart';
import 'package:cwt_ecommerce_app/common/widgets/shimmers/search_category_shimmer.dart';
import 'package:cwt_ecommerce_app/features/shop/controllers/brand_controller.dart';
import 'package:cwt_ecommerce_app/features/shop/controllers/categories_controller.dart';
import 'package:cwt_ecommerce_app/features/shop/screens/all_products/all_products.dart';
import 'package:cwt_ecommerce_app/features/shop/screens/brand/brand.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/image_text/image_text_vertical.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/search_controller.dart';
import '../../models/category_model.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final categoryController = CategoryController.instance;
  final searchController = Get.put(TSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text('Search', style: Theme.of(context).textTheme.headlineMedium),
        actions: [TextButton(onPressed: () => Get.back(), child: const Text('Cancel'))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Search bar & Filter Button
              Row(
                children: [
                  /// Search
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      onChanged: (search) => searchController.searchProducts(search),
                      decoration: const InputDecoration(prefixIcon: Icon(Iconsax.search_normal), hintText: 'Search'),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),

                  /// Filter
                  OutlinedButton(
                    onPressed: () => filterModalBottomSheet(context),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey)),
                    child: const Icon(Iconsax.setting, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Search
              Obx(
                () => searchController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    :
                    // Show search if not Empty
                    searchController.searchResults.isNotEmpty
                        ? TGridLayout(
                            itemCount: searchController.searchResults.length,
                            itemBuilder: (_, index) => TProductCardVertical(product: searchController.searchResults[index]),
                          )
                        : brandsAndCategories(context),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }

  /// Brands & Categories Widget
  Column brandsAndCategories(BuildContext context) {
    final brandController = Get.put(BrandController());
    final categoryController = Get.put(CategoryController());
    final isDark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        /// Brands Heading
        const TSectionHeading(title: 'Brands', showActionButton: false),

        /// -- Brands
        Obx(
          () {
            // Check if categories are still loading
            if (brandController.isLoading.value) return const TCategoryShimmer();

            /// Data Found
            return Wrap(
              children: brandController.allBrands
                  .map((brand) => GestureDetector(
                        onTap: () => Get.to(BrandScreen(brand: brand)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: TSizes.md),
                          child: TVerticalImageAndText(
                            image: brand.image,
                            title: brand.name,
                            isNetworkImage: true,
                            textColor: THelperFunctions.isDarkMode(context) ? TColors.white : TColors.dark,
                            backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.darkerGrey : TColors.light,
                          ),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        /// Categories
        const TSectionHeading(title: 'Categories', showActionButton: false),
        const SizedBox(height: TSizes.spaceBtwItems),

        /// Obx widget for reactive UI updates based on the state of [categoryController].
        /// It displays a shimmer loader while categories are being loaded, shows a message if no data is found,
        /// and renders a horizontal list of featured categories with images and text.
        Obx(
          () {
            // Check if categories are still loading
            if (categoryController.isLoading.value) return const TSearchCategoryShimmer();

            // Check if there are no featured categories found
            if (categoryController.allCategories.isEmpty) {
              return Center(child: Text('No Data Found!', style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));
            } else {
              /// Data Found
              // Display a horizontal list of featured categories with images and text
              final categories = categoryController.allCategories;
              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                itemCount: categories.length,
                shrinkWrap: true,
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () => Get.to(
                    () => AllProducts(
                      title: categories[index].name,
                      futureMethod: categoryController.getCategoryProducts(categoryId: categories[index].id),
                    ),
                  ),
                  child: Row(
                    children: [
                      TCircularImage(
                        width: 25,
                        height: 25,
                        padding: 0,
                        isNetworkImage: true,
                        overlayColor: isDark ? TColors.white : TColors.dark,
                        image: categories[index].image,
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems / 2),
                      Text(categories[index].name)
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Future<dynamic> filterModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: TSizes.defaultSpace,
          right: TSizes.defaultSpace,
          top: TSizes.defaultSpace,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TSectionHeading(title: 'Filter', showActionButton: false),
                  IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.close_square))
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              /// Sort
              Text('Sort by', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: TSizes.spaceBtwItems / 2),

              _buildSortingDropdown(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Categories

              Text('Category', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildCategoryList(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Sort by Radios
              Text('Pricing', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) => searchController.minPrice.value = double.parse(value),
                      decoration: const InputDecoration(hintText: '\$ Lowest'),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) => searchController.maxPrice.value = double.parse(value),
                      decoration: const InputDecoration(hintText: '\$ Highest'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    searchController.search();
                    Get.back();
                  },
                  child: const Text('Apply'),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortingDropdown() {
    return Obx(
      () => DropdownButton<String>(
        value: searchController.selectedSortingOption.value,
        onChanged: (String? newValue) {
          if (newValue != null) {
            searchController.selectedSortingOption.value = newValue;
            searchController.search(); // Trigger the search when the sorting option changes
          }
        },
        items: searchController.sortingOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: categoryController.allCategories.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildCategoryTile(categoryController.allCategories[index]);
      },
    );
  }

  Widget _buildCategoryTile(CategoryModel category) {
    return category.parentId.isEmpty ? Obx(() => _buildParentCategoryTile(category)) : const SizedBox.shrink();
  }

  Widget _buildParentCategoryTile(CategoryModel category) {
    return ExpansionTile(
      title: Text(category.name),
      children: _buildSubCategories(category.id),
    );
  }

  List<Widget> _buildSubCategories(String parentId) {
    List<CategoryModel> subCategories = categoryController.allCategories.where((cat) => cat.parentId == parentId).toList();
    return subCategories.map((subCategory) => _buildSubCategoryTile(subCategory)).toList();
  }

  Widget _buildSubCategoryTile(CategoryModel category) {
    return RadioListTile(
      title: Text(category.name),
      value: category.id,
      groupValue: searchController.selectedCategoryId.value,
      onChanged: (value) {
        searchController.selectedCategoryId.value = value.toString();
      },
    );
  }
}
