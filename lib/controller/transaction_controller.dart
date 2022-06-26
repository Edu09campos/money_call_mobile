import 'package:money_call/database/transactions_database.dart';
import 'package:money_call/models/transaction.dart';
import 'package:money_call/utils/categories.dart';
import 'package:money_call/utils/utils.dart';

class TransactionController {
  static Future<Transaction> create(Transaction transaction) async {
    final db = await TransactionsDatabase.instance.database;

    final id = await db.insert(tableTransactions, transaction.toJson());
    return transaction.copy(id: id);
  }

  // TODO: read by if expense or income
  // TODO: read by category

  static Future<List<Transaction>> getTransactionsByDay(DateTime date) async {
    final db = await TransactionsDatabase.instance.database;
    const orderBy = '${TransactionFields.createdTime} DESC';

    final Map<String, int> limit = startEndDay(date);

    final result = await db.query(tableTransactions,
        where:
            '${TransactionFields.createdTime} >= ? AND ${TransactionFields.createdTime} <= ?',
        whereArgs: [limit["start"], limit["end"]],
        limit: 20,
        orderBy: orderBy);
    List<Transaction> trans =
        result.map((json) => Transaction.fromJson(json)).toList();
    List<Transaction> transactions = [];
    for (Transaction tran in trans) {
      transactions.add(tran);
    }

    return transactions;
  }

  static Future<double> getTypeTotalByMonth(DateTime date,
      {required bool isExpense}) async {
    final db = await TransactionsDatabase.instance.database;

    final Map<String, int> limit = startEndMonth(date);

    final result = await db.query(tableTransactions,
        where:
            '${TransactionFields.isExpense} = ? AND ${TransactionFields.createdTime} >= ? AND ${TransactionFields.createdTime} <= ?',
        whereArgs: [isExpense ? 1 : 0, limit["start"], limit["end"]]);
    List<Transaction> trans =
        result.map((json) => Transaction.fromJson(json)).toList();

    double count =
        trans.fold(0, (double acc, Transaction tran) => acc + tran.amount);
    return count;
  }

  static Future<Map<String, double>> getAmountByCategoryByMonth(DateTime date,
      {required bool isExpense}) async {
    final db = await TransactionsDatabase.instance.database;

    final Map<String, int> limit = startEndMonth(date);

    final result = await db.query(tableTransactions,
        where:
            '${TransactionFields.isExpense} = ? AND ${TransactionFields.createdTime} >= ? AND ${TransactionFields.createdTime} <= ?',
        whereArgs: [isExpense ? 1 : 0, limit["start"], limit["end"]]);

    List<Transaction> trans =
        result.map((json) => Transaction.fromJson(json)).toList();

    Map<String, double> transactions = <String, double>{};
    if (isExpense) {
      for (String cat in expenses) {
        for (Transaction tran in trans) {
          if (cat == tran.category) {
            if (transactions[cat] == null) {
              transactions[cat] = 0.0;
            }
            transactions[cat] = transactions[cat]! + tran.amount;
          }
        }
      }
    } else {
      for (String cat in incomes) {
        for (Transaction tran in trans) {
          if (cat == tran.category) {
            if (transactions[cat] == null) {
              transactions[cat] = 0.0;
            }
            transactions[cat] = transactions[cat]! + tran.amount;
          }
        }
      }
    }

    return transactions;
  }
}
