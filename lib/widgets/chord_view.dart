import 'package:flutter/material.dart';
import '../models/chord_shape.dart';
import 'chord_painter.dart';

class ChordView extends StatefulWidget {
  final List<ChordShape> shapes;

  const ChordView({super.key, required this.shapes});

  @override
  State<ChordView> createState() => _ChordViewState();
}

class _ChordViewState extends State<ChordView> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(ChordView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shapes != oldWidget.shapes) {
      _currentPage = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shapes.isEmpty) {
      return const Center(
        child: Text(
          'No chord shape available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.shapes.length,
            itemBuilder: (context, index) {
              final shape = widget.shapes[index];
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: CustomPaint(
                  painter: ChordPainter(chordShape: shape),
                  size: Size.infinite,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Shape ${_currentPage + 1} / ${widget.shapes.length}',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
