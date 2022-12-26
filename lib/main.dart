import 'package:crypto_app/domain/config/config.dart';
import 'package:crypto_app/presentation/presentation.dart';
import 'package:crypto_app/provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CryptoApp());
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CryptoProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Crypto App',
        navigatorKey: NavigationService.navigatorKey,
        scaffoldMessengerKey: Utils.scaffoldKey,
        theme: ThemeData(
          scaffoldBackgroundColor: CustomColors().black,
          appBarTheme: AppBarTheme(color: CustomColors().black),
        ),
        home: const MainScreen(),
      ),
    );
  }
}
