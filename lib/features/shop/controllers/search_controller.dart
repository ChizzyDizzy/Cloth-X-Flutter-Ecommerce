import 'package:cwt_ecommerce_app/data/repositories/product/product_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';

class TSearchController extends GetxController {
  static TSearchController get instance => Get.find();

  RxList<ProductModel> searchResults = <ProductModel>[].obs;
  RxBool isLoading = false.obs;
  RxString lastSearchQuery = ''.obs;
  RxDouble minPrice = 0.0.obs;
  RxDouble maxPrice = double.infinity.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategoryId = ''.obs;
  List<String> sortingOptions = ['Name', 'Lowest Price', 'Highest Price', 'Popular', 'Newest', 'Suitable'];
  RxString selectedSortingOption = 'Name'.obs; // Default sorting option

  void search() {
    searchProducts(
      searchQuery.value,
      categoryId: selectedCategoryId.value.isNotEmpty ? selectedCategoryId.value : null,
      minPrice: minPrice.value != 0.0 ? minPrice.value : null,
      maxPrice: maxPrice.value != double.infinity ? maxPrice.value : null,
    );
  }


  void searchProducts(String query, {String? categoryId, String? brandId, double? minPrice, double? maxPrice}) async {
    lastSearchQuery.value = query;
    isLoading.value = true;

    try {
      final results = await ProductRepository.instance
          .searchProducts(query, categoryId: categoryId, brandId: brandId, maxPrice: maxPrice, minPrice: minPrice);

      // Apply sorting
      switch (selectedSortingOption.value) {
        case 'Name':
        // Sort by name
          results.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'Lowest Price':
        // Sort by price in ascending order
          results.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'Highest Price':
        // Sort by price in descending order
          results.sort((a, b) => b.price.compareTo(a.price));
          break;
        // Add other sorting cases as needed
      }

      // Update searchResults with sorted results
      searchResults.assignAll(results);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
