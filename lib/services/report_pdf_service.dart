import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:money_planning_app/models/category_model.dart';
import 'package:money_planning_app/models/transaction_item_model.dart';

class ReportPdfService {
  Future<Uint8List> buildReportPdfBytes({
    required String title,
    required String periodLabel,
    required DateTime from,
    required DateTime to,
    required List<CategoryModel> categories,
    required Map<int, double> expenseByCategory,
    required List<TransactionItemModel> allTransactions, // ✅ ALL tx in period
    required PdfColor Function(int categoryId) categoryColor,
  }) async {
    final doc = pw.Document();

    String fmtDate(DateTime d) {
      String two(int v) => v.toString().padLeft(2, '0');
      return "${d.year}-${two(d.month)}-${two(d.day)}";
    }

    String fmtMoney(double v, String cur) {
      final c = cur.toUpperCase().trim();
      if (c == 'KHR') return v.toStringAsFixed(0);
      return v.toStringAsFixed(2);
    }

    // -------------------------
    // Summary split by currency
    // -------------------------
    double incomeUSD = 0, incomeKHR = 0, expenseUSD = 0, expenseKHR = 0;

    for (final t in allTransactions) {
      final cur = t.currencyCode.toUpperCase().trim();
      final isIncome = t.type.toLowerCase().trim() == 'income';
      final isExpense = t.type.toLowerCase().trim() == 'expense';

      if (isIncome) {
        if (cur == 'USD') incomeUSD += t.amount;
        if (cur == 'KHR') incomeKHR += t.amount;
      } else if (isExpense) {
        if (cur == 'USD') expenseUSD += t.amount;
        if (cur == 'KHR') expenseKHR += t.amount;
      }
    }

    final netUSD = incomeUSD - expenseUSD;
    final netKHR = incomeKHR - expenseKHR;

    // -------------------------
    // Category rows (expenses only)
    // -------------------------
    final totalExpense =
        expenseByCategory.values.fold<double>(0.0, (a, b) => a + b);

    final catRows = <List<String>>[];
    for (final c in categories) {
      final cid = c.id;
      if (cid == null) continue;
      final v = expenseByCategory[cid] ?? 0.0;
      if (v <= 0) continue;

      final percent = totalExpense <= 0 ? 0 : (v / totalExpense) * 100.0;

      // ✅ keep amount 2 decimals in category table
      catRows.add([
        c.name,
        v.toStringAsFixed(2),
        "${percent.toStringAsFixed(0)}%",
        cid.toString(),
      ]);
    }

    // -------------------------
    // All transaction rows
    // -------------------------
    final txRows = <List<String>>[];

    // Sort newest -> oldest (just in case)
    final txSorted = [...allTransactions]
      ..sort((a, b) => b.transactedAt.compareTo(a.transactedAt));

    for (final t in txSorted) {
      final isIncome = t.type.toLowerCase().trim() == 'income';
      final sign = isIncome ? '+' : '-';

      final name = (t.itemName?.trim().isNotEmpty == true)
          ? t.itemName!.trim()
          : (t.note?.trim().isNotEmpty == true)
              ? t.note!.trim()
              : 'Transaction';

      final catName = (t.categoryName?.trim().isNotEmpty == true)
          ? t.categoryName!.trim()
          : 'Other';

      final cur = t.currencyCode.toUpperCase().trim();

      txRows.add([
        fmtDate(t.transactedAt),
        name,
        catName,
        "$sign${fmtMoney(t.amount, cur)}",
        cur, // ✅ show currency_code from DB
      ]);
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          // Header
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text("Period: $periodLabel",
              style: const pw.TextStyle(fontSize: 11)),
          pw.Text("Range: ${fmtDate(from)}  →  ${fmtDate(to)}",
              style: const pw.TextStyle(fontSize: 11)),
          pw.Divider(),
          pw.SizedBox(height: 8),

          // ✅ Summary table (USD/KHR)
          pw.Text(
            "Summary (USD / KHR)",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(3),
              2: pw.FlexColumnWidth(3),
              3: pw.FlexColumnWidth(3),
            },
            children: [
              _headerRow(["Currency", "Income", "Expense", "Net"]),
              pw.TableRow(children: [
                _cell("USD"),
                _numCell(fmtMoney(incomeUSD, 'USD')),
                _numCell(fmtMoney(expenseUSD, 'USD')),
                _numCell(fmtMoney(netUSD, 'USD')),
              ]),
              pw.TableRow(children: [
                _cell("KHR"),
                _numCell(fmtMoney(incomeKHR, 'KHR')),
                _numCell(fmtMoney(expenseKHR, 'KHR')),
                _numCell(fmtMoney(netKHR, 'KHR')),
              ]),
            ],
          ),

          pw.SizedBox(height: 16),

          // Spending by category
          pw.Text(
            "Spending by Category",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),

          if (catRows.isEmpty)
            pw.Text("No expenses for this period.")
          else
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: const {
                0: pw.FlexColumnWidth(3),
                1: pw.FlexColumnWidth(2),
                2: pw.FlexColumnWidth(1),
              },
              children: [
                _headerRow(["Category", "Amount", "%"]),
                ...catRows.map((r) {
                  final cid = int.tryParse(r[3]) ?? 0;

                  final dot = pw.Container(
                    width: 8,
                    height: 8,
                    decoration: pw.BoxDecoration(
                      color: categoryColor(cid),
                      shape: pw.BoxShape.circle,
                    ),
                  );

                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Row(
                          children: [
                            dot,
                            pw.SizedBox(width: 6),
                            pw.Expanded(child: pw.Text(r[0])),
                          ],
                        ),
                      ),
                      _numCell(r[1]),
                      _numCell(r[2]),
                    ],
                  );
                }),
              ],
            ),

          pw.SizedBox(height: 16),

          // ✅ All transactions
          pw.Text(
            "Transactions",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),

          if (txRows.isEmpty)
            pw.Text("No transactions for this period.")
          else
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: const {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(4),
                2: pw.FlexColumnWidth(3),
                3: pw.FlexColumnWidth(2),
                4: pw.FlexColumnWidth(2),
              },
              children: [
                _headerRow(["Date", "Name", "Category", "Amount", "Currency"]),
                ...txRows.map((r) => pw.TableRow(
                      children: [
                        _cell(r[0]),
                        _cell(r[1]),
                        _cell(r[2]),
                        _numCell(r[3]),
                        _cell(r[4]),
                      ],
                    )),
              ],
            ),

          pw.SizedBox(height: 12),
          pw.Divider(),
          pw.Text(
            "Generated at: ${fmtDate(DateTime.now())}",
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );

    return doc.save();
  }

  static pw.TableRow _headerRow(List<String> cols) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
      children: cols
          .map(
            (c) => pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                c,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
          )
          .toList(),
    );
  }

  static pw.Widget _cell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text),
    );
  }

  static pw.Widget _numCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(text),
      ),
    );
  }
}
