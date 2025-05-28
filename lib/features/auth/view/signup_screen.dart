import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/auth_viewmodel.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _receiveUpdates = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    _animationController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Kailangan ang numero ng telepono';
    }

    final cleanNumber = value.trim().replaceAll(RegExp(r'[^\d]'), '');
    if (cleanNumber.length < 10) {
      return 'Maglagay ng tamang numero ng telepono';
    }
    if (!cleanNumber.startsWith('09') && cleanNumber.length == 11) {
      return 'Ang numero ay dapat magsimula sa 09';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kailangan ang password';
    }
    if (value.length < 6) {
      return 'Minimum 6 characters ang password';
    }
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password ay dapat may letra at numero';
    }
    return null;
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    // if (!_acceptTerms) {
    //   _showErrorSnackBar(
    //       'Kailangan mo munang tanggapin ang Terms and Conditions');
    //   return;
    // }

    final authVm = context.read<AuthViewModel>();

    try {
      await authVm.signUp(
        _nameController.text.trim(),
        _phoneController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        _showSuccessSnackBar('Account ay successfully na‑create!');
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      _showErrorSnackBar('Hindi matagumpay ang pag‑signup. Subukan ulit.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 20 : 32,
                vertical: 0,
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person_add,
                              size: 40, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Gumawa ng Account',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sumali sa Patubig at simulan ang pamamahala\nng inyong sakahan',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Form
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Full Name
                          TextFormField(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Buong Pangalan',
                              hintText: 'Juan Dela Cruz',
                              prefixIcon: Icon(Icons.person_outline,
                                  color: theme.colorScheme.primary),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: theme.colorScheme.outline
                                        .withOpacity(0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: theme.colorScheme.primary, width: 2),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Kailangan ang buong pangalan';
                              }
                              if (value.trim().length < 2) {
                                return 'Maglagay ng tamang pangalan';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) =>
                                _phoneFocusNode.requestFocus(),
                          ),
                          const SizedBox(height: 20),

                          // Phone Number
                          TextFormField(
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Numero ng Telepono',
                              hintText: '09171234567',
                              prefixIcon: Icon(Icons.phone_outlined,
                                  color: theme.colorScheme.primary),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: theme.colorScheme.outline
                                        .withOpacity(0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: theme.colorScheme.primary, width: 2),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                            ),
                            validator: _validatePhoneNumber,
                            onFieldSubmitted: (_) =>
                                _passwordFocusNode.requestFocus(),
                          ),
                          const SizedBox(height: 20),

                          // Password
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Minimum 6 characters',
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: theme.colorScheme.primary),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: theme.colorScheme.outline
                                        .withOpacity(0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: theme.colorScheme.primary, width: 2),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                            ),
                            validator: _validatePassword,
                            onFieldSubmitted: (_) =>
                                _confirmPasswordFocusNode.requestFocus(),
                          ),
                          const SizedBox(height: 20),

                          // Confirm Password
                          TextFormField(
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocusNode,
                            obscureText: _obscureConfirmPassword,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: 'Kumpirmahin ang Password',
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: theme.colorScheme.primary),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                                onPressed: () => setState(() =>
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: theme.colorScheme.outline
                                        .withOpacity(0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: theme.colorScheme.primary, width: 2),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kailangan kumpirmahin ang password';
                              }
                              if (value != _passwordController.text) {
                                return 'Hindi tugma ang password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // // Terms & Conditions
                          // CheckboxListTile(
                          //   contentPadding: EdgeInsets.zero,
                          //   value: _acceptTerms,
                          //   onChanged: (val) =>
                          //       setState(() => _acceptTerms = val ?? false),
                          //   title: const Text(
                          //       'Sumasang-ayon ako sa Terms and Conditions'),
                          //   controlAffinity: ListTileControlAffinity.leading,
                          // ),
                          // CheckboxListTile(
                          //   contentPadding: EdgeInsets.zero,
                          //   value: _receiveUpdates,
                          //   onChanged: (val) =>
                          //       setState(() => _receiveUpdates = val ?? false),
                          //   title: const Text(
                          //       'Nais kong makatanggap ng mga update'),
                          //   controlAffinity: ListTileControlAffinity.leading,
                          // ),
                          // const SizedBox(height: 10),

                          // Signup Button
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed:
                                  authVm.isLoading ? null : _handleSignup,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: authVm.isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 3),
                                      )
                                    : const Text('Mag‑sign Up'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('May account na? ',
                          style: theme.textTheme.bodyMedium),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Mag‑login',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
