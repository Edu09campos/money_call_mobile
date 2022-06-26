import 'package:flutter/material.dart';
import 'package:money_call/app_localizations.dart';
import 'package:money_call/controller/transaction_controller.dart';
import 'package:money_call/models/transaction.dart';
import 'package:money_call/provider/currency_provider.dart';
import 'package:money_call/provider/theme_provider.dart';
import 'package:money_call/utils/categories.dart';
import 'package:money_call/utils/colors.dart';
import 'package:money_call/widgets/category_option.dart';
import 'package:provider/provider.dart';

class NewTransactionScreen extends StatefulWidget {
  const NewTransactionScreen({Key? key}) : super(key: key);

  @override
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  final List<bool> _isSelected = [true, false];
  bool _isExpense = false;
  late bool _isDark;
  late String _dropdownValue;
  late final TextStyle _style;
  final TextEditingController _description = TextEditingController(),
      _amount = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dropdownValue = _isExpense ? "Bills" : "Business";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    _style = TextStyle(
        color: _isDark ? Colors.white : grey,
        fontSize: 20,
        fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _isDark ? darkGrey : Colors.white,
        title: Text(
          AppLocalizations.of(context)!.translate("New Transaction"),
          style: TextStyle(color: _isDark ? Colors.white : Colors.black),
        ),
        centerTitle: true,
        titleTextStyle:
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(
            color: primary, size: 30 //change your color here
            ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final iconData = Provider.of<CurrencyProvider>(context).getIcon();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: SingleChildScrollView(
        child: Column(children: [
          Text(
              AppLocalizations.of(context)!
                  .translate("Choose Transaction Type"),
              style: _style),
          const SizedBox(
            height: 15,
          ),
          ToggleButtons(
            disabledColor: Colors.white,
            borderRadius: BorderRadius.circular(30),
            borderWidth: 1.3,
            borderColor: primary,
            fillColor:
                _isDark ? Colors.grey.shade800 : primary.withOpacity(0.05),
            selectedBorderColor: primary,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  width: 85,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate("Income"),
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: income),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  width: 85,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate("Expenses"),
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: expense),
                    ),
                  ),
                ),
              )
            ],
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < _isSelected.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    _isSelected[buttonIndex] = true;
                  } else {
                    _isSelected[buttonIndex] = false;
                  }
                }

                switch (index) {
                  case 0:
                    _isExpense = false;
                    _dropdownValue = "Business";
                    break;
                  case 1:
                    _isExpense = true;
                    _dropdownValue = "Bills";
                }
              });
            },
            isSelected: _isSelected,
          ),
          const SizedBox(
            height: 40,
          ),
          Text(AppLocalizations.of(context)!.translate("Choose Category"),
              style: _style),
          const SizedBox(
            height: 15,
          ),
          DropdownButton<String>(
            value: _dropdownValue,
            icon: Icon(
              Icons.arrow_downward,
              color: _isExpense ? expense : income,
            ),
            elevation: 16,
            style: TextStyle(
                color: _isExpense ? expense : income,
                fontWeight: FontWeight.w600,
                fontSize: 20),
            onChanged: (String? newValue) {
              setState(() {
                _dropdownValue = newValue!;
              });
            },
            items: _buildOptions(),
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
              AppLocalizations.of(context)!
                  .translate("Transaction Description"),
              style: _style),
          const SizedBox(
            height: 15,
          ),
          TextField(
            controller: _description,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 40,
            cursorColor: Colors.black,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                counterStyle: const TextStyle(color: secondary),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 1.3),
                ),
                border: const OutlineInputBorder(),
                hintText: AppLocalizations.of(context)!
                    .translate("Enter a transaction description")),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(AppLocalizations.of(context)!.translate("Transaction Value"),
              style: _style),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _amount,
              cursorColor: Colors.black,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: _isExpense ? Colors.red : Colors.green),
              decoration: InputDecoration(
                  prefixIcon: Icon(iconData),
                  counterStyle: const TextStyle(color: secondary),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 1.3),
                  ),
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!
                      .translate("Enter the transaction amount")),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      textStyle: const TextStyle(fontSize: 27)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                      Text(AppLocalizations.of(context)!.translate('Cancel')),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      textStyle:
                          const TextStyle(fontSize: 27, color: Colors.white)),
                  onPressed: _createTransaction,
                  child:
                      Text(AppLocalizations.of(context)!.translate('Create')),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildOptions() {
    List<DropdownMenuItem<String>> options = _isExpense
        ? expenses.map<DropdownMenuItem<String>>((String name) {
            return DropdownMenuItem<String>(
              value: name,
              child: CategoryOption(
                name: name,
              ),
            );
          }).toList()
        : incomes.map<DropdownMenuItem<String>>((String name) {
            return DropdownMenuItem<String>(
              value: name,
              child: CategoryOption(
                name: name,
              ),
            );
          }).toList();

    return options;
  }

  Future _createTransaction() async {
    String amount = _amount.text.replaceAll(',', '.');
    String descr =
        _description.text.trim().isEmpty ? "" : _description.text.trim();
    double calcAmount =
        _isExpense ? -double.parse(amount) : double.parse(amount);
    Transaction transaction = Transaction(
        amount: calcAmount,
        isExpense: _isExpense,
        category: _dropdownValue,
        description: descr,
        createTime: DateTime.now());

    await TransactionController.create(transaction);

    Navigator.pop(context);
  }
}
