import 'package:flutter/material.dart';
import 'package:myecomstore/controllers/mainscreen_provider.dart';
import 'package:myecomstore/views/shared/bottom_nav.dart';
import 'package:myecomstore/views/ui/cartpage.dart';
import 'package:myecomstore/views/ui/favorites.dart';
import 'package:myecomstore/views/ui/homepage.dart';
import 'package:myecomstore/views/ui/profile.dart';
import 'package:myecomstore/views/ui/searchpage.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  List<Widget> pageList =  [
    const HomePage(),
    const SearchPage(),
    const Favorites(),
    CartPage(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
        builder: (context, mainScreenNotifier, child ){
          return Scaffold(
            backgroundColor: const Color(0xFFE2E2E2),
            body: pageList[mainScreenNotifier.pageIndex],
            bottomNavigationBar: const BottomNavBar(),
          );
        }
    );
  }
}