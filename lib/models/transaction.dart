const String tableTransactions = "transactions";

class TransactionFields {
  static final List<String> values = [
    id,
    amount,
    isExpense,
    category,
    description,
    createdTime
  ];

  static const String id = "_id";
  static const String amount = "amount";
  static const String isExpense = "isExpense";
  static const String category = "category";
  static const String description = "description";
  static const String createdTime = "createdTime";
}

class Transaction {
  final int? id;
  final double amount;
  final bool isExpense;
  final String category, description;
  final DateTime createTime;

  Transaction(
      {this.id,
      required this.amount,
      required this.isExpense,
      required this.category,
      required this.description,
      required this.createTime});

  Map<String, Object?> toJson() => {
        TransactionFields.id: id,
        TransactionFields.amount: amount,
        TransactionFields.isExpense: isExpense ? 1 : 0,
        TransactionFields.category: category,
        TransactionFields.description: description,
        TransactionFields.createdTime: createTime.millisecondsSinceEpoch
      };

  static Transaction fromJson(Map<String, Object?> json) => Transaction(
      id: json[TransactionFields.id] as int?,
      amount: json[TransactionFields.amount] as double,
      isExpense: json[TransactionFields.isExpense] == 1,
      category: json[TransactionFields.category] as String,
      description: json[TransactionFields.description] as String,
      createTime: DateTime.fromMillisecondsSinceEpoch(
          json[TransactionFields.createdTime] as int));

  Transaction copy(
          {int? id,
          double? amount,
          bool? isExpense,
          String? category,
          String? description,
          DateTime? createTime}) =>
      Transaction(
          id: id ?? this.id,
          amount: amount ?? this.amount,
          isExpense: isExpense ?? this.isExpense,
          category: category ?? this.category,
          description: description ?? this.description,
          createTime: createTime ?? this.createTime);
}
