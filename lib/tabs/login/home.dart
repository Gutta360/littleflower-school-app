import 'package:flutter/material.dart';
import 'package:littleflower/layouts/homelayout.dart';
import 'package:littleflower/main.dart';
import 'package:littleflower/tabs/login/login.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _forgotPassword() {
    print('Redirect to forgot password screen');
  }

  @override
  Widget build(BuildContext context) {
    final globalData = Provider.of<GlobalData>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: globalData.isUserLoggedIn
              ? HomeLayoutWidget()
              : LoginForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  onEmailChanged: (value) => _email = value,
                  onPasswordChanged: (value) => _password = value,
                  onLoginPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('Logging in with $_email and $_password');
                      globalData.setIsUserLoggedIn(true);
                    }
                  },
                  onForgotPassword: _forgotPassword,
                ),
        ),
      ),
    );
  }
}
