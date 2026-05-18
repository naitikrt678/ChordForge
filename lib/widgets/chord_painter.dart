import 'package:flutter/material.dart';
import '../models/chord_shape.dart';

class ChordPainter extends CustomPainter {
  final ChordShape chordShape;

  ChordPainter({required this.chordShape});

  @override
  void paint(Canvas canvas, Size size) {
    // Styling constants
    const int numStrings = 6;
    const int numFrets = 5; // visible frets

    final Paint stringPaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 2.0;

    final Paint nutPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 6.0;

    final Paint fretPaint = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 2.0;

    final Paint dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint barrePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    final Paint openPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Calculate layout
    // We need space at the top for open/muted string indicators
    // We need space on the left for fret numbers
    final double topMargin = 40.0;
    final double leftMargin = 40.0;
    final double rightMargin = 20.0;
    final double bottomMargin = 20.0;

    final double boardWidth = size.width - leftMargin - rightMargin;
    final double boardHeight = size.height - topMargin - bottomMargin;

    final double stringSpacing = boardWidth / (numStrings - 1);
    final double fretSpacing = boardHeight / numFrets;

    // Draw base fret label if > 1
    if (chordShape.baseFret > 1) {
      textPainter.text = TextSpan(
        text: '${chordShape.baseFret}fr',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          leftMargin - textPainter.width - 8.0,
          topMargin + (fretSpacing / 2) - (textPainter.height / 2),
        ),
      );
    }

    // Draw fretboard
    // Draw nut (top line)
    if (chordShape.baseFret == 1) {
      canvas.drawLine(
        Offset(leftMargin, topMargin),
        Offset(leftMargin + boardWidth, topMargin),
        nutPaint,
      );
    } else {
      canvas.drawLine(
        Offset(leftMargin, topMargin),
        Offset(leftMargin + boardWidth, topMargin),
        fretPaint,
      );
    }

    // Draw frets (horizontal lines)
    for (int i = 1; i <= numFrets; i++) {
      final double y = topMargin + (i * fretSpacing);
      canvas.drawLine(
        Offset(leftMargin, y),
        Offset(leftMargin + boardWidth, y),
        fretPaint,
      );
    }

    // Draw strings (vertical lines)
    for (int i = 0; i < numStrings; i++) {
      final double x = leftMargin + (i * stringSpacing);
      canvas.drawLine(
        Offset(x, topMargin),
        Offset(x, topMargin + boardHeight),
        stringPaint,
      );
    }

    // Helper to get relative fret (0-indexed for positioning)
    int getRelativeFret(int absoluteFret) {
      return absoluteFret - chordShape.baseFret + 1;
    }

    // Draw barre
    if (chordShape.barre != null) {
      final barre = chordShape.barre!;
      final int relFret = getRelativeFret(barre.fret);
      
      if (relFret > 0 && relFret <= numFrets) {
        final double startX = leftMargin + (barre.startString * stringSpacing);
        final double endX = leftMargin + (barre.endString * stringSpacing);
        final double y = topMargin + (relFret * fretSpacing) - (fretSpacing / 2);
        
        final Rect barreRect = Rect.fromCenter(
          center: Offset((startX + endX) / 2, y),
          width: endX - startX + 24.0, // padded a bit
          height: 16.0,
        );
        
        canvas.drawRRect(
          RRect.fromRectAndRadius(barreRect, const Radius.circular(8.0)),
          barrePaint,
        );
      }
    }

    // Draw notes
    for (int i = 0; i < numStrings; i++) {
      final int fret = chordShape.frets[i];
      final double x = leftMargin + (i * stringSpacing);

      if (fret == -1) {
        // Draw 'X' (muted)
        textPainter.text = const TextSpan(
          text: 'X',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - (textPainter.width / 2), topMargin - 30.0),
        );
      } else if (fret == 0) {
        // Draw 'O' (open)
        canvas.drawCircle(Offset(x, topMargin - 20.0), 6.0, openPaint);
      } else {
        // Draw filled dot (fretted note)
        final int relFret = getRelativeFret(fret);
        
        // Only draw if within visible bounds
        if (relFret > 0 && relFret <= numFrets) {
          // If a barre covers this note, we don't need to draw it, 
          // but we can draw it on top or skip. The spec says:
          // "Do NOT render barre notes as separate circles."
          bool isBarred = false;
          if (chordShape.barre != null) {
            final barre = chordShape.barre!;
            if (fret == barre.fret && i >= barre.startString && i <= barre.endString) {
              isBarred = true;
            }
          }

          if (!isBarred) {
            final double y = topMargin + (relFret * fretSpacing) - (fretSpacing / 2);
            canvas.drawCircle(Offset(x, y), 8.0, dotPaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Simple app, fine to always repaint
  }
}
