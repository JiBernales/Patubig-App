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

    return Scaffold(
      appBar: AppBar(title: const Text('Mag-log In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 📱  mobile number
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
              const SizedBox(height: 12),
              // 🔑  password
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (v) => _password = v!,
                validator: (v) =>
                    v != null && v.length >= 6 ? null : 'Min. 6 karakter',
              ),
              const SizedBox(height: 24),
              authVm.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      child: const Text('Log In'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          await authVm.signIn(_phone, _password);
                        }
                      },
                    ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                ),
                child: const Text('Wala ka pang account?  Mag-sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}