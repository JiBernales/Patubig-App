import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/auth_viewmodel.dart';

// …imports…
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

    return Scaffold(
      appBar: AppBar(title: const Text('Mag-sign up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Buong Pangalan'),
                onSaved: (v) => _fullName = v!.trim(),
                validator: (v) =>
                    v != null && v.isNotEmpty ? null : 'Kailangan ito',
              ),
              const SizedBox(height: 12),
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
                      child: const Text('Gumawa ng Account'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          await authVm.signUp(_fullName, _phone, _password);
                          Navigator.pop(context); // balik log-in
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
