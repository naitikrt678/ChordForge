import 'package:flutter/material.dart';

class ChordSelector extends StatelessWidget {
  final String selectedRoot;
  final String selectedType;
  final String selectedExtension;
  final bool disableExtension;
  final Function(String, String, String) onChanged;

  const ChordSelector({
    super.key,
    required this.selectedRoot,
    required this.selectedType,
    required this.selectedExtension,
    required this.onChanged,
    this.disableExtension = false,
  });

  static const List<String> roots = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];
  
  static const List<String> types = [
    'Major', 'Minor', 'Diminished', 'Power Chord'
  ];
  
  static const List<String> extensions = [
    'None', '7', 'add9'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDropdown(
            value: selectedRoot,
            items: roots,
            onChanged: (val) => onChanged(val!, selectedType, selectedExtension),
          ),
          const SizedBox(width: 8),
          _buildDropdown(
            value: selectedType,
            items: types,
            onChanged: (val) => onChanged(selectedRoot, val!, selectedExtension),
          ),
          const SizedBox(width: 8),
          _buildDropdown(
            value: selectedExtension,
            items: extensions,
            onChanged: disableExtension ? null : (val) => onChanged(selectedRoot, selectedType, val!),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: Colors.grey[850],
            style: const TextStyle(color: Colors.white, fontSize: 14),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
