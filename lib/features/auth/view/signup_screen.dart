import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/auth_viewmodel.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '', _phone = '', _password = '';

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final theme = Theme.of(context); // Access the theme for consistent styling

    return Scaffold(
      appBar: AppBar(title: const Text('Mag-sign up')),
      body: Center( // Center the content
        child: SingleChildScrollView( // Allow scrolling
          padding: const EdgeInsets.all(24), // Increased padding
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center column content
              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
              children: [
                // --- Welcome Message for Signup ---
                Text(
                  'Join Patubig Today!', // Engaging title
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary, // Green headline
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your account to start managing your crops and resources.', // Informative subtitle
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48), // More space before form fields

                TextFormField(
                  decoration: const InputDecoration(labelText: 'Buong Pangalan'),
                  onSaved: (v) => _fullName = v!.trim(),
                  validator: (v) =>
                      v != null && v.isNotEmpty ? null : 'Kailangan ito',
                ),
                const SizedBox(height: 16), // Consistent spacing
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
                const SizedBox(height: 16), // Consistent spacing
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (v) => _password = v!,
                  validator: (v) =>
                      v != null && v.length >= 6 ? null : 'Min. 6 karakter',
                ),
                const SizedBox(height: 32), // More space before button

                // Create Account Button with Loading Indicator
                authVm.isLoading
                    ? const Center(child: CircularProgressIndicator()) // Center the progress indicator
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await authVm.signUp(_fullName, _phone, _password);
                            // Only pop if signup was successful or if you want to explicitly go back
                            if (!mounted) return; // Check if the widget is still in the tree
                            Navigator.pop(context); // balik log-in
                          }
                        },
                        child: const Text('Gumawa ng Account'),
                      ),
                const SizedBox(height: 16),
                // Optional: Back to Login button if user changes their mind
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Mayroon ka nang account? Mag-log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}