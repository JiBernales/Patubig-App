import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/auth_viewmodel.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _phone = '', _password = '';

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final theme = Theme.of(context); // Access the theme for consistent styling

    return Scaffold(
      // AppBar is fine, it will inherit the green/white theme from main.dart
      appBar: AppBar(title: const Text('Mag-log In')),
      body: Center( // Center the content vertically and horizontally
        child: SingleChildScrollView( // Allow scrolling if content overflows
          padding: const EdgeInsets.all(24), // Increased padding
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center column content
              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
              children: [
                // --- App Logo/Icon (Optional but Recommended) ---
                // You can replace this with your actual app logo or an agricultural icon
                Icon(
                  Icons.eco, // Example agricultural icon (leaf)
                  size: 100,
                  color: theme.colorScheme.primary, // Use primary green from theme
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to Patubig!', // Catchy title
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary, // Green headline
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to manage your farm efficiently.', // Subtitle/tagline
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48), // More space before form fields

                // 📱 Mobile number
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Numero ng Telepono',
                    hintText: 'Hal. 09171234567',
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (v) => _phone = v!.trim(),
                  validator: (v) =>
                      v != null && v.length >= 10 ? null : 'Ilagay ang tamang numero',
                ),
                const SizedBox(height: 16), // Slightly increased spacing
                // 🔑 Password
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (v) => _password = v!,
                  validator: (v) =>
                      v != null && v.length >= 6 ? null : 'Min. 6 karakter',
                ),
                const SizedBox(height: 32), // More space before button

                // Login Button with Loading Indicator
                authVm.isLoading
                    ? const Center(child: CircularProgressIndicator()) // Center the progress indicator
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await authVm.signIn(_phone, _password);
                          }
                        },
                        child: const Text('Log In'),
                      ),
                const SizedBox(height: 16),

                // Signup Text Button
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  ),
                  child: const Text('Wala ka pang account? Mag-sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}