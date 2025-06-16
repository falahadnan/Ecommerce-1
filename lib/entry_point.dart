import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/screen_export.dart'; // Ensure this imports HomeScreen, BookmarkScreen etc.

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  // Ensure all these screen widgets are correctly imported via screen_export.dart or directly
  final List _pages = const [
    HomeScreen(),
    BookmarkScreen(),
    CartScreen(),
    ProfileScreen(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // --- ADD PRINT STATEMENT TO SEE WHEN THIS BUILDS ---
    print("--- Building EntryPoint widget --- _currentIndex: $_currentIndex");

    try { // <--- START OF THE TRY BLOCK
      SvgPicture svgIcon(String src, {Color? color}) {
        // Potential null check here if Theme.of(context).iconTheme.color is null
        // Let's make it safer:
        final iconColor = color ?? Theme.of(context).iconTheme.color ?? Colors.black; // Fallback to black
        return SvgPicture.asset(
          src,
          height: 24,
          colorFilter: ColorFilter.mode(
            iconColor,
            BlendMode.srcIn,
          ),
        );
      }

      // Another potential null check here for Theme.of(context).iconTheme.color
      final appBarIconColor = Theme.of(context).iconTheme.color ?? Colors.black; // Fallback

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: const SizedBox(),
          leadingWidth: 0,
          centerTitle: false,
          title: SvgPicture.asset(
            "assets/logo/Shoplon.svg",
            colorFilter: ColorFilter.mode(
              appBarIconColor, // Use safer color
              BlendMode.srcIn,
            ),
            height: 20,
            width: 100,
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, searchScreenRoute),
              icon: svgIcon("assets/icons/Search.svg"),
            ),
            IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, notificationsScreenRoute),
              icon: svgIcon("assets/icons/Notification.svg"),
            ),
          ],
        ),
        body: PageTransitionSwitcher(
          duration: defaultDuration,
          transitionBuilder: (child, animation, secondAnimation) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondAnimation,
              child: child,
            );
          },
          child: _pages[_currentIndex], // This will build HomeScreen initially
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(top: defaultPadding / 2),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : const Color(0xFF101015),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            selectedItemColor: primaryColor,
            // Potential null check here if Theme.of(context).textTheme.bodyLarge or its color is null
            unselectedItemColor: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5) ?? Colors.grey, // Safer access
            items: [
              BottomNavigationBarItem(
                icon: svgIcon("assets/icons/Shop.svg"),
                activeIcon:
                    svgIcon("assets/icons/Shop.svg", color: primaryColor),
                label: "Shop",
              ),
              BottomNavigationBarItem(
                icon: svgIcon("assets/icons/Wishlist.svg"),
                activeIcon: svgIcon("assets/icons/Bookmark.svg",
                    color: primaryColor),
                label: "Wishlist",
              ),
              BottomNavigationBarItem(
                icon: svgIcon("assets/icons/Bag.svg"),
                activeIcon:
                    svgIcon("assets/icons/Bag.svg", color: primaryColor),
                label: "Cart",
              ),
              BottomNavigationBarItem(
                icon: svgIcon("assets/icons/Profile.svg"),
                activeIcon:
                    svgIcon("assets/icons/Profile.svg", color: primaryColor),
                label: "Profile",
              ),
            ],
          ),
        ),
      );
    } catch (e, s) { // <--- CATCH BLOCK
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      print("!!! ERROR OCCURRED WHILE BUILDING EntryPoint WIDGET !!!");
      print("Error type: ${e.runtimeType}");
      print("Error message: $e");
      print("Full StackTrace for this error: \n$s");
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      // Return a fallback UI to prevent app from just showing a red screen
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Error building EntryPoint screen. Check console for details.\n\nError: $e",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }
}