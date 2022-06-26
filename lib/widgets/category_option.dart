import 'package:flutter/material.dart';
import 'package:money_call/app_localizations.dart';
import 'package:money_call/utils/categories.dart';

class CategoryOption extends StatefulWidget {
  final String name;
  const CategoryOption({Key? key, required this.name}) : super(key: key);

  @override
  _CategoryOptionState createState() => _CategoryOptionState();
}

class _CategoryOptionState extends State<CategoryOption> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Row(
        children: [
          Icon(
            getCategoryIcon(widget.name),
            color: getCategoryColor(widget.name),
            size: 20,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(AppLocalizations.of(context)!.translate(widget.name))
        ],
      ),
    );
  }
}
