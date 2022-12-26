import 'package:crypto_app/domain/domain.dart';
import 'package:crypto_app/presentation/presentation.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _signFormKey = GlobalKey<FormState>();
  final authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Form(
          key: _signFormKey,
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextPoppins(
                  text: 'Correo electrónico',
                  fontSize: 18,
                  color: CustomColors().white,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                TextFormFieldWidget(
                  controller: emailController,
                  validator: (email) => email != null && EmailValidator.validate(email) ? null : 'Ingresa un correo válido',
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                TextPoppins(
                  text: 'Contraseña',
                  fontSize: 18,
                  color: CustomColors().white,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                TextFormFieldWidget(
                  maxLines: 1,
                  controller: passwordController,
                  obscureText: true,
                  validator: (password) => password != null && password.length < 6 ? 'Ingresa una contraseña válida' : null,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                TextPoppins(
                  text: 'Confirma tu contraseña',
                  fontSize: 18,
                  color: CustomColors().white,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                TextFormFieldWidget(
                  maxLines: 1,
                  controller: confirmPasswordController,
                  obscureText: true,
                  validator: (password) => password != null && password.length < 6
                      ? 'Ingresa una contraseña válida'
                      : password != passwordController.text
                          ? 'Ambas contraseñas deben coincidir'
                          : null,
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                LargeButton(
                  text: 'Regístrate',
                  onPressed: () {
                    if (!_signFormKey.currentState!.validate()) return;
                    authService.signIn(emailController.text.toLowerCase().trim(), passwordController.text.toLowerCase().trim());
                  },
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
