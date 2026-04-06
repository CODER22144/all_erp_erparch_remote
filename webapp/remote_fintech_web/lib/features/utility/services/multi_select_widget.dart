import 'package:flutter/material.dart';

class MultiSelectCheckbox extends StatefulWidget {
  final List<dynamic> items;
  final Function(String) onSelectionChanged;
  final String idKey;
  final String descKey;

  const MultiSelectCheckbox({
    super.key,
    required this.items,
    required this.onSelectionChanged,
    required this.idKey,
    required this.descKey,
  });

  @override
  State<MultiSelectCheckbox> createState() => _MultiSelectCheckboxState();
}

class _MultiSelectCheckboxState extends State<MultiSelectCheckbox> {
  final List<String> _selectedIds = [];

  void _onItemChecked(String id, bool? checked) {
    setState(() {
      if (checked == true) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
    });

    // Convert selected IDs to comma separated string
    String result = _selectedIds.join(',');
    widget.onSelectionChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items.map((item) {
        final String id = item[widget.idKey].toString();
        final String description = item[widget.descKey].toString();

        return CheckboxListTile(
          title: Text(description), // Show description
          value: _selectedIds.contains(id),
          onChanged: (checked) => _onItemChecked(id, checked),
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }
}
