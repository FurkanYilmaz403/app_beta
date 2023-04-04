import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/services/cloud/firebase_cloud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenLayout extends StatefulWidget {
  const ScreenLayout({Key? key}) : super(key: key);

  @override
  State<ScreenLayout> createState() => _ScreenLayoutState();
}

class _ScreenLayoutState extends State<ScreenLayout> {
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  changePage(int page) {
    pageController.jumpToPage(page);
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: primaryColor,
            shadowColor: accentColor,
            title: (currentPage == 1)
                ? const Text(
                    "Sepet",
                    style: TextStyle(color: lightTextColor, fontSize: 28),
                  )
                : Image.asset(
                    logo,
                    width: logoSize,
                    height: logoSize,
                  ),
            actions: [
              if (currentPage == 1)
                IconButton(
                  onPressed: () async {
                    await FirebaseCloud().deleteCart();
                  },
                  icon: const Icon(
                    Icons.delete_sweep_sharp,
                    color: errorColor,
                    size: 35,
                  ),
                ),
            ],
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
        ),
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: screens,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
              color: secondaryColor,
              width: 1,
            )),
            color: primaryColor,
          ),
          child: TabBar(
              onTap: changePage,
              indicator: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: accentColor,
                    width: 4.0,
                  ),
                ),
              ),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  child: Icon(
                    Icons.home_outlined,
                    color: currentPage == 0 ? accentColor : secondaryColor,
                  ),
                ),
                Tab(
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: currentPage == 1 ? accentColor : secondaryColor,
                  ),
                ),
                Tab(
                  child: Icon(
                    Icons.motorcycle_sharp,
                    color: currentPage == 2 ? accentColor : secondaryColor,
                  ),
                ),
                Tab(
                  child: Icon(
                    Icons.person_outline,
                    color: currentPage == 3 ? accentColor : secondaryColor,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
