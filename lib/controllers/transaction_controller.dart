// import 'package:get/get.dart';
// import '../services/api_service.dart';
// import '../models/transaction_model.dart';

// class TransactionController extends GetxController {
//   final apiService = ApiService();

//   final transactions = <TransactionModel>[].obs;
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;
//   final selectedMonth = DateTime.now().obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadTransactions();
//     watchTransactionsRealtime();
//   }

//   Future<void> loadTransactions({int limit = 20, int offset = 0}) async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final response =
//           await apiService.getTransactions(limit: limit, offset: offset);
//       if (response.success) {
//         transactions.value = response.data ?? [];
//       } else {
//         errorMessage.value = response.message ?? 'Failed to load transactions';
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> loadTransactionsByDateRange({
//     required DateTime startDate,
//     required DateTime endDate,
//     String? type,
//   }) async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final response = await apiService.getTransactionsByDateRange(
//         startDate: startDate,
//         endDate: endDate,
//         type: type,
//       );

//       if (response.success) {
//         transactions.value = response.data ?? [];
//       } else {
//         errorMessage.value =
//             response.message ?? 'Failed to load transactions';
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool> addTransaction({
//     required String categoryId,
//     required String type,
//     required double amount,
//     required String currency,
//     required String title,
//     required DateTime transactionDate,
//     String? description,
//     String? paymentMethod,
//   }) async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final response = await apiService.createTransaction(
//         categoryId: categoryId,
//         type: type,
//         amount: amount,
//         currency: currency,
//         title: title,
//         transactionDate: transactionDate,
//         description: description,
//         paymentMethod: paymentMethod,
//       );

//       if (response.success) {
//         transactions.insert(0, response.data!);
//         return true;
//       } else {
//         errorMessage.value = response.message ?? 'Failed to add transaction';
//         return false;
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool> updateTransaction({
//     required String id,
//     required Map<String, dynamic> data,
//   }) async {
//     isLoading.value = true;
//     try {
//       final response = await apiService.updateTransaction(id: id, data: data);
//       if (response.success) {
//         await loadTransactions();
//         return true;
//       }
//       errorMessage.value = response.message ?? 'Update failed';
//       return false;
//     } catch (e) {
//       errorMessage.value = e.toString();
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool> deleteTransaction(String id) async {
//     try {
//       final response = await apiService.deleteTransaction(id);
//       if (response.success) {
//         transactions.removeWhere((t) => t.id == id);
//         return true;
//       }
//       errorMessage.value = response.message ?? 'Delete failed';
//       return false;
//     } catch (e) {
//       errorMessage.value = e.toString();
//       return false;
//     }
//   }

//   Future<void> searchTransactions(String query) async {
//     isLoading.value = true;
//     try {
//       final response = await apiService.searchTransactions(query);
//       if (response.success) {
//         transactions.value = response.data ?? [];
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void watchTransactionsRealtime() {
//     apiService.watchTransactions().listen((data) {
//       transactions.value = data;
//     });
//   }
// }
