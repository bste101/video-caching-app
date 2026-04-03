import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            authenticated: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login successful!')),
              );

              // Navigate to feed page after successful login
              context.go('/');
            },
            failure: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            orElse: () {},
          );
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Video Caching App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 80),
                _SocialButton(
                  icon: Icons.g_mobiledata,
                  label: 'Continue with Google',
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEvent.googleSignInRequested());
                  },
                ),
                const SizedBox(height: 15),
                _SocialButton(
                  icon: Icons.apple,
                  label: 'Continue with Apple',
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEvent.appleSignInRequested());
                  },
                ),
                const SizedBox(height: 15),
                _SocialButton(
                  icon: Icons.chat_bubble,
                  label: 'Continue with LINE',
                  color: const Color(0xFF00B900),
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEvent.lineSignInRequested());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: textColor),
        label: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
