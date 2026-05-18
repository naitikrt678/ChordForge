import 'package:flutter/material.dart';
import '../data/chords.dart';
import '../models/chord_shape.dart';
import '../widgets/chord_selector.dart';
import '../widgets/chord_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedRoot = 'C';
  String _selectedType = 'Major';
  String _selectedExtension = 'None';

  List<ChordShape> _getFilteredShapes() {
    return sampleChords.where((chord) {
      return chord.root == _selectedRoot &&
             chord.type == _selectedType &&
             chord.extension == _selectedExtension;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredShapes = _getFilteredShapes();
    
    // Assemble chord name
    String chordName = '$_selectedRoot $_selectedType';
    if (_selectedExtension != 'None') {
      chordName += ' $_selectedExtension';
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // near black
      appBar: AppBar(
        title: const Text('ChordForge', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            ChordSelector(
              selectedRoot: _selectedRoot,
              selectedType: _selectedType,
              selectedExtension: _selectedExtension,
              disableExtension: _selectedType == 'Power Chord',
              onChanged: (root, type, ext) {
                setState(() {
                  _selectedRoot = root;
                  _selectedType = type;
                  if (type == 'Power Chord') {
                    _selectedExtension = 'None';
                  } else {
                    _selectedExtension = ext;
                  }
                });
              },
            ),
            const SizedBox(height: 24),
            Text(
              chordName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ChordView(shapes: filteredShapes),
            ),
          ],
        ),
      ),
    );
  }
}
