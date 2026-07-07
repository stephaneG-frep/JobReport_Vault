import 'package:flutter/material.dart';

class VaultSearchBar extends StatelessWidget {
  const VaultSearchBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value)
        ..selection = TextSelection.collapsed(offset: value.length),
      onChanged: onChanged,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        labelText: 'Rechercher',
        border: OutlineInputBorder(),
      ),
    );
  }
}
