import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget desktopLayout;

  ResponsiveLayout({
    required this.mobileLayout,
    required this.desktopLayout,
  });

  @override
  Widget build(BuildContext context) {
    // Determinar si es móvil o escritorio
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1000) {
          // Versión móvil
          return mobileLayout;
        } else {
          // Versión escritorio
          return desktopLayout;
        }
      },
    );
  }
}
