// Example file showing how to use MainLayout in your pages
// This is for documentation purposes only - delete if not needed

/*
HOW TO USE MainLayout:

1. Wrap your page content with MainLayout widget
2. Use MainLayout for any page that needs bottom navigation
3. The bottom navigation is automatically fixed and handles navigation

EXAMPLE USAGE:

```dart
import 'package:flutter/material.dart';
import '../../../core/widgets/main_layout.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBar: AppBar(
        title: Text('My Page'),
      ),
      child: Center(
        child: Text('Page Content'),
      ),
      // Optional parameters:
      // showBottomNav: true,  // Show/hide bottom nav (default: true)
      // backgroundColor: Colors.white,  // Custom background color
      // drawer: MyDrawer(),  // Optional drawer
      // floatingActionButton: FloatingActionButton(...),  // Optional FAB
    );
  }
}
```

BENEFITS:
- Fixed bottom navigation bar (stays at bottom)
- Automatic navigation handling between pages
- Consistent layout across all pages
- Easy to add new pages
- State management handled automatically
*/
