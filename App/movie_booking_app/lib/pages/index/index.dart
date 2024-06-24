import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/pages/index/components/bottomnav.dart';
import 'package:movie_booking_app/pages/index/components/drawer.dart';
import 'package:movie_booking_app/routes/AppRoutes.dart';
import 'package:movie_booking_app/services/Users/logout/logoutService.dart';
import 'package:movie_booking_app/services/Users/refresh/tokenManager.dart';
import 'package:movie_booking_app/services/Users/signup/handleSignup.dart';
import 'package:movie_booking_app/pages/search/search.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({
    super.key,
    required this.initialIndex,
  });

  final int initialIndex;

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with WidgetsBindingObserver {
  late int index;
  late List<Widget> pages;
  ValidInput valid = ValidInput();
  PageController _pageController = PageController();
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _pageController = PageController(initialPage: _selectedIndex);
    pages = [
      Builder(
          builder: (context) =>
              AppRoutes.routes[AppRoutes.homeScreen]!(context)),
      Builder(
          builder: (context) => AppRoutes.routes[AppRoutes.shimmer]!(context)),
      Builder(
          builder: (context) =>
              AppRoutes.routes[AppRoutes.homeScreen]!(context)),
      Builder(
          builder: (context) => AppRoutes.routes[AppRoutes.store]!(context)),
      Builder(
          builder: (context) => AppRoutes.routes[AppRoutes.profile]!(context)),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      LogOutServices.logout();
      TokenManager.cancelTokenRefreshTimer();
      print("logout success");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BuildDrawer(context),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0.0,
            backgroundColor: AppColors.backgroundColor,
            iconTheme: const IconThemeData(color: AppColors.iconThemeColor),
            pinned: true,
            floating: true,
            snap: true,
            flexibleSpace: const FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(AppIcon.tickets),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Search()));
                },
                icon: Icon(AppIcon.search),
              ),
            ],
          ),
          SliverFillRemaining(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return pages[index];
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigator(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 50),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
    );
  }
}
