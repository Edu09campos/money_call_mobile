import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_call/utils/colors.dart';

List<String> expenses = [
  "Bills",
  "Car",
  "Clothes",
  "Travel",
  "Food",
  "Health",
  "Shopping",
  "House",
  "Entertainment",
  "Phone",
  "Pets",
  "Other"
];

List<String> incomes = [
  "Business",
  "Investments",
  "Extra Income",
  "Deposits",
  "Lottery",
  "Gifts",
  "Salary",
  "Savings",
  "Rental Income",
  "Other"
];

IconData getCategoryIcon(String cat) {
  switch (cat) {
    case "Bills":
      return FontAwesomeIcons.moneyBillTransfer;
    case "Car":
      return FontAwesomeIcons.car;
    case "Clothes":
      return FontAwesomeIcons.shirt;
    case "Travel":
      return FontAwesomeIcons.planeDeparture;
    case "Food":
      return FontAwesomeIcons.utensils;
    case "Health":
      return FontAwesomeIcons.fileMedical;
    case "Shopping":
      return FontAwesomeIcons.bagShopping;
    case "House":
      return FontAwesomeIcons.houseChimney;
    case "Entertainment":
      return FontAwesomeIcons.ticket;
    case "Phone":
      return FontAwesomeIcons.mobileRetro;
    case "Pets":
      return FontAwesomeIcons.paw;
    case "Other":
      return FontAwesomeIcons.question;
    case "Business":
      return FontAwesomeIcons.briefcase;
    case "Investments":
      return FontAwesomeIcons.sackDollar;
    case "Extra Income":
      return FontAwesomeIcons.commentDollar;
    case "Deposits":
      return FontAwesomeIcons.buildingColumns;
    case "Lottery":
      return FontAwesomeIcons.clover;
    case "Gifts":
      return FontAwesomeIcons.gift;
    case "Salary":
      return FontAwesomeIcons.moneyCheckDollar;
    case "Savings":
      return FontAwesomeIcons.piggyBank;
    case "Rental Income":
      return FontAwesomeIcons.houseCircleCheck;
    default:
      return FontAwesomeIcons.question;
  }
}

Color getCategoryColor(String cat) {
  switch (cat) {
    case "Bills":
      return billTrans;
    case "Car":
      return carTrans;
    case "Clothes":
      return clothesTrans;
    case "Travel":
      return Colors.black;
    case "Food":
      return foodTrans;
    case "Health":
      return Colors.red;
    case "Shopping":
      return shoppingTrans;
    case "House":
      return houseTrans;
    case "Entertainment":
      return entertainmentTrans;
    case "Phone":
      return Colors.black;
    case "Pets":
      return Colors.brown;
    case "Other":
      return Colors.black;
    case "Business":
      return businessTrans;
    case "Investments":
      return investmentsTrans;
    case "Extra Income":
      return lotteryTrans;
    case "Deposits":
      return Colors.indigoAccent;
    case "Lottery":
      return lotteryTrans;
    case "Gifts":
      return Colors.redAccent;
    case "Salary":
      return investmentsTrans;
    case "Savings":
      return savingsTrans;
    case "Rental Income":
      return businessTrans;
    default:
      return Colors.black;
  }
}
