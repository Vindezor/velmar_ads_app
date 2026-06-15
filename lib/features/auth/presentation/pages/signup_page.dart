import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/features/auth/presentation/widgets/signup_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Image.asset('assets/images/logo.png', height: 100, width: 100),
                const SizedBox(height: 24),
                Text(
                  'Velmar Ads',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  'Crea tu cuenta para comenzar',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                const SignUpForm(),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    text: '¿Ya tienes una cuenta? ',
                    style: Theme.of(context).textTheme.labelMedium,
                    children: [
                      TextSpan(
                        text: 'Inicia sesión',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.go('/login');
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
