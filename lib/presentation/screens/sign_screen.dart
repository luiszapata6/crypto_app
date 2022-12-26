import 'package:crypto_app/presentation/presentation.dart';
import 'package:flutter/material.dart';

/* 
  Pantalla para realizar el registro
  o el inicio de sesión en la aplicación
 */

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  bool login = true;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: login ? size.height * 0.14 : size.height * 0.07,
                ),
                Visibility(
                  visible: login,
                  child: TextPoppins(
                    text: 'CRYPTO APP',
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                    color: CustomColors().purple,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.055,
                ),
                TextPoppins(
                  text: login ? 'Ingresa a tu cuenta' : 'Regístrate',
                  fontSize: 22,
                  color: CustomColors().purple,
                ),
                SizedBox(
                  height: size.height * 0.055,
                ),
                Visibility(visible: login, child: const LoginForm()),
                Visibility(visible: !login, child: const SignUpForm()),
                Align(
                  alignment: Alignment.center,
                  child: TextPoppins(
                    text: 'o',
                    fontSize: 22,
                    color: CustomColors().white,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
                LargeButton(
                  text: login ? 'Regístrate' : 'Inicia sesión',
                  onPressed: () => setState(() => login = !login),
                  color: CustomColors().white,
                  textColor: CustomColors().purple,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
