import 'package:crypto_app/domain/services/auth_service.dart';
import 'package:crypto_app/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/* 
  Pantalla principal para mostrar los
  diferentes módulos de la aplicación
 */

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;
  PageController pageController = PageController();
  final authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.05),
              child: GestureDetector(
                onTap: () => authService.logOut(),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: CustomColors().purple,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (index) => _currentIndex = index,
          children: const [
            CryptoScreen(),
            FavoriteScreen(),
            CompareScreen(),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: size.height * 0.12,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (value) {
              setState(() => _currentIndex = value);
              pageController.jumpToPage(
                value,
              );
            },
            iconSize: 32,
            fixedColor: CustomColors().purple,
            backgroundColor: CustomColors().black,
            unselectedItemColor: CustomColors().white,
            selectedLabelStyle: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Color.fromRGBO(142, 111, 247, 1),
              ),
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: Color.fromRGBO(142, 111, 247, 1),
              ),
            ),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Cryptos'),
              BottomNavigationBarItem(icon: Icon(Icons.star_rounded), label: 'Favoritas'),
              BottomNavigationBarItem(icon: Icon(Icons.compare_arrows_rounded), label: 'Comparar'),
            ],
          ),
        ),
      ),
    );
  }
}
