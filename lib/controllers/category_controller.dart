// import 'package:get/get.dart';
// import 'package:money_planning_app/models/category_model.dart';
// import 'package:money_planning_app/services/api_service.dart';

// class CategoryController extends GetxController {
//   final apiService = ApiService();

//   final categories = <CategoryModel>[].obs;
//   final incomeCategories = <CategoryModel>[].obs;
//   final expenseCategories = <CategoryModel>[].obs;
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadCategories();
//   }

//   Future<void> loadCategories() async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final response = await apiService.getCategories();
//       if (response.success) {
//         categories.value = response.data ?? [];

//         incomeCategories.value =
//             categories.where((c) => c.type == 'income').toList();
//         expenseCategories.value =
//             categories.where((c) => c.type == 'expense').toList();
//       } else {
//         errorMessage.value = response.message ?? 'Failed to load categories';
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool> createCategory({
//     required String name,
//     required String type,
//     String? color,
//     String? iconName,
//   }) async {
//     isLoading.value = true;
//     try {
//       final response = await apiService.createCategory(
//         name: name,
//         type: type,
//         color: color,
//         iconName: iconName,
//       );

//       if (response.success) {
//         categories.add(response.data!);
//         if (type == 'income') {
//           incomeCategories.add(response.data!);
//         } else {
//           expenseCategories.add(response.data!);
//         }
//         return true;
//       }
//       errorMessage.value = response.message ?? 'Failed to create category';
//       return false;
//     } catch (e) {
//       errorMessage.value = e.toString();
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
