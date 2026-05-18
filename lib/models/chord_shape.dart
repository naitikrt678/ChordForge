import 'barre_data.dart';

class ChordShape {
  final String root;
  final String type;
  final String extension;
  final int baseFret;
  
  // One value per string (E A D G B e)
  // -1 = muted
  // 0 = open
  // positive integer = fret
  final List<int> frets;
  
  // Finger positions
  final List<int?> fingers;
  
  // Barre info
  final BarreData? barre;

  const ChordShape({
    required this.root,
    required this.type,
    required this.extension,
    required this.baseFret,
    required this.frets,
    required this.fingers,
    this.barre,
  });
}
