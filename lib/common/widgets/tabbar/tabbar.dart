import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../presentation/views/home_view.dart';
import '../../../presentation/views/library_view.dart';
import '../../../presentation/views/personal_view.dart';
import '../../../presentation/views/search_view.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({super.key});

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int currentTab = 0;
  final List<Widget> screens = [
    HomeView(),
    SearchView(),
    LibraryView(),
    PersonalView()
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTabButton(Icons.home_outlined, 'Home', 0, HomeView()),
              _buildTabButton(Icons.search, 'Search', 1, SearchView()),
              _buildTabButton(Icons.library_music_outlined, 'Library', 2, LibraryView()),
              _buildTabButton(Icons.perm_identity_outlined, 'Personal', 3, PersonalView()),
            ],
          ),
        ),
      ),

    );
  }
  // Tabbar Widget
  Widget _buildTabButton(IconData icon, String label, int index, Widget screen) {
    return MaterialButton(
      minWidth: 40,
      onPressed: () {
        setState(() {
          currentScreen = screen;
          currentTab = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: currentTab == index ? AppColors.primary : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: currentTab == index ? AppColors.primary : Colors.grey,
            ),
          )
        ],
      ),
    );
  }
  
}