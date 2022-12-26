import 'package:crypto_app/domain/domain.dart';
import 'package:crypto_app/presentation/presentation.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final AuthenticationService authService = AuthenticationService();

  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Form(
          key: _loginFormKey,
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
                  obscureText: hidden,
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () => setState(() => hidden = !hidden),
                  ),
                  validator: (password) => password != null && password.length < 6 ? 'Ingresa una contraseña válida' : null,
                  autovalidateMode: AutovalidateMode.disabled,
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                LargeButton(
                  text: 'Inicia sesión',
                  onPressed: () async {
                    if (!_loginFormKey.currentState!.validate()) return;
                    await authService.logIn(
                      emailController.text.toLowerCase().trim(),
                      passwordController.text.toLowerCase().trim(),
                    );
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
    super.dispose();
  }
}
