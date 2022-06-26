import 'package:money_call/models/transaction.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TransactionsDatabase {
  static final TransactionsDatabase instance = TransactionsDatabase._init();
  static Database? _database;

  TransactionsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('transactions.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const amountType = "REAL NOT NULL";
    const expenseType = "BOOLEAN NOT NULL";
    const textType = "TEXT NOT NULL";
    const integerType = "INTEGER NOT NULL";

    await db.execute('''
    CREATE TABLE $tableTransactions (
     ${TransactionFields.id} $idType,
     ${TransactionFields.amount} $amountType, 
     ${TransactionFields.isExpense} $expenseType,
     ${TransactionFields.category} $textType,
     ${TransactionFields.description} $textType,
     ${TransactionFields.createdTime} $integerType
    )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
