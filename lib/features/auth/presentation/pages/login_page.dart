import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:velmar_ads/features/auth/presentation/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 100, width: 100),
              SizedBox(height: 24),
              Text(
                'Velmar Ads',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 24),
              Text(
                'Optimiza tu impacto publicitario',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 24),
              const LoginForm(),
              SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  text: '¿No tienes una cuenta? ',
                  style: Theme.of(context).textTheme.labelMedium,
                  children: [
                    TextSpan(
                      text: 'Registrate',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/register');
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
