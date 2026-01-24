class DashboardModel {
  final double balance;
  final double income;
  final double expense;

  const DashboardModel({
    required this.balance,
    required this.income,
    required this.expense,
  });

  factory DashboardModel.fromRpc(Map<String, dynamic> json) {
    double toD(dynamic v) => double.tryParse(v.toString()) ?? 0.0;

    return DashboardModel(
      balance: toD(json['balance']),
      income: toD(json['income']),
      expense: toD(json['expense']),
    );
  }
}
