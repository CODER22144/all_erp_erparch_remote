import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/material.dart';

class MultiCheckboxWidget extends StatefulWidget {
  final List<String> items; // List of options
  final List<String> initiallySelected; // Pre-selected values
  final Function(List<String>)
      onSelectionChanged; // Callback for selected values

  const MultiCheckboxWidget({
    super.key,
    required this.items,
    this.initiallySelected = const [],
    required this.onSelectionChanged,
  });

  @override
  _MultiCheckboxWidgetState createState() => _MultiCheckboxWidgetState();
}

class _MultiCheckboxWidgetState extends State<MultiCheckboxWidget> {
  late List<String> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = List.from(widget.initiallySelected);
  }

  void _onItemChecked(bool? value, String item) {
    setState(() {

      item = item == 'All' ? "*" : item;

      if(item == '*') {
        selectedItems.retainWhere((element) => element == "*");
      }

      if (value == true) {
        selectedItems.add(item);
      } else {
        selectedItems.remove(item);
      }
      GlobalVariables.requestBody['selectCols'] = selectedItems.join(",");
      widget.onSelectionChanged(selectedItems); // Return selected items
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 4, // 👈 controls width/height ratio
      children: List.generate(widget.items.length, (index) {
        return SizedBox(
          height: 50, // 👈 fix height so it won’t expand
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero, // 👈 remove default padding
            controlAffinity: ListTileControlAffinity.leading,
            value: selectedItems.contains(widget.items[index] == 'All' ? "*" : widget.items[index]),
            title: Text(widget.items[index]),
            onChanged: (val) => _onItemChecked(val, widget.items[index]),
          ),
        );
      }),
    );
  }
}
