import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/modules/connection/networkControl.dart';
import 'package:movie_booking_app/modules/valid/validException.dart';
import 'package:movie_booking_app/pages/index/components/bottomnav.dart';
import 'package:movie_booking_app/pages/index/components/drawer.dart';
import 'package:movie_booking_app/pages/order/orderPage.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:movie_booking_app/routes/AppRoutes.dart';
import 'package:movie_booking_app/services/Users/logout/logoutService.dart';
import 'package:movie_booking_app/services/Users/order/returnSeat/returnSeat.dart';
import 'package:movie_booking_app/services/Users/refresh/tokenManager.dart';
import 'package:movie_booking_app/pages/search/search.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';

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
  late int _selectedIndex;
  late List<Widget> pages;
  ValidInput valid = ValidInput();
  PageController _pageController = PageController();
  bool _isConnected = false;
  @override
  void initState() {
    super.initState();
    ConnectionController.startListening((isConnected) {
      setState(() {
        _isConnected = isConnected;
        if (_isConnected == false) {
          ShowMessage.noNetworkConnection(context);
          pref.clear();
        }
      });
    });

    _selectedIndex = widget.initialIndex;
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController(initialPage: _selectedIndex);
    pages = [
      Builder(
        builder: (context) => AppRoutes.routes[AppRoutes.store]!(context),
      ),
      Builder(
        builder: (context) => AppRoutes.routes[AppRoutes.homeScreen]!(context),
      ),
      Builder(
        builder: (context) => AppRoutes.routes[AppRoutes.profile]!(context),
      ),
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
      handleAppDetached(context);
    }
  }

  Future<void> handleAppDetached(context) async {
    Preferences pref = Preferences();
    await LogOutServices.logout(context);
    TokenManager.cancelTokenRefreshTimer();
    String? seatpref = await pref.getHoldSeats();
    int? scheduleIdpref = await pref.getSchedule();
    if (seatpref != null && seatpref.isNotEmpty && scheduleIdpref != null) {
      Set<String> heldSeats = ConverterUnit.convertStringToSet(seatpref);
      ReturnSeatService.returnSeat(context, scheduleIdpref, heldSeats);
      pref.clearHoldSeats();
      pref.clearSchedule();
      print("Hold seats returned successfully");
    } else {
      print("No seats were held");
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
            pinned: false,
            floating: true,
            snap: true,
            flexibleSpace: const FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
            ),
            title: Image.asset(
              'assets/icons/ic_logo.png',
              height: 70,
              width: 70,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Search()));
                },
                icon: const Icon(Icons.search),
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
