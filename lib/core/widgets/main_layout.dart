import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme/app_colors.dart';
import '../providers/bottom_navigation_provider.dart';
import 'custom_bottom_navigation_bar.dart';

/// MainLayout widget that provides a fixed bottom navigation bar
/// Wrap your page content with this widget for consistent navigation
class MainLayout extends StatelessWidget {
  final Widget child;
  final bool showBottomNav;
  final AppBar? appBar;
  final FloatingActionButton? floatingActionButton;
  final Widget? drawer;
  final Color? backgroundColor;

  const MainLayout({
    super.key,
    required this.child,
    this.showBottomNav = true,
    this.appBar,
    this.floatingActionButton,
    this.drawer,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = Provider.of<BottomNavigationProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.textWhite,
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Main content area
            Expanded(
              child: child,
            ),
            // Fixed bottom navigation bar
            if (showBottomNav)
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                child: CustomBottomNavigationBar(
                  selectedIndex: bottomNavProvider.currentIndex,
                  onItemTapped: (index) {
                    bottomNavProvider.setCurrentIndex(index, context);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
