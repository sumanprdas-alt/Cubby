import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cubby/core/theme.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  String _countryCode = '+971';
  String? _verificationId;
  bool _codeSent = false;
  bool _loading = false;
  String? _error;

  Future<void> _signInAnonymously() async {
    setState(() { _loading = true; _error = null; });
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Sign in failed: $e';
      });
    }
  }

  Future<void> _sendOtp() async {
    final phone = '$_countryCode${_phoneController.text.trim()}';
    if (_phoneController.text.trim().isEmpty) {
      setState(() => _error = 'Enter your phone number');
      return;
    }

    setState(() { _loading = true; _error = null; });

    await FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: true,
    );

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        setState(() {
          _loading = false;
          _error = e.message ?? 'Verification failed. Try again.';
        });
      },
      codeSent: (verificationId, resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _loading = false;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().length != 6) {
      setState(() => _error = 'Enter the 6-digit code');
      return;
    }

    setState(() { _loading = true; _error = null; });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;
        _error = e.message ?? 'Invalid code. Try again.';
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),

              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.all_inbox_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 20),

              const Text(
                'Cubby',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: AppColors.ink),
              ),
              const SizedBox(height: 4),
              const Text(
                "Your family's everything,\nin one place.",
                style: TextStyle(fontSize: 16, color: AppColors.ink2, height: 1.4),
              ),
              const SizedBox(height: 40),

              if (!_codeSent) ...[
                const Text(
                  'Sign in with your phone',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _showCountryPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border, width: 0.5),
                        ),
                        child: Text(_countryCode, style: const TextStyle(fontSize: 15, color: AppColors.ink)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 15, color: AppColors.ink),
                        decoration: InputDecoration(
                          hintText: 'Phone number',
                          hintStyle: const TextStyle(color: AppColors.ink3),
                          filled: true,
                          fillColor: AppColors.card,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.border, width: 0.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.border, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const Text(
                  'Enter the 6-digit code',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sent to $_countryCode ${_phoneController.text}',
                  style: const TextStyle(fontSize: 13, color: AppColors.ink3),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  autofocus: true,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.ink, letterSpacing: 8),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.card,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border, width: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border, width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1),
                    ),
                  ),
                ),
              ],

              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(fontSize: 13, color: AppColors.red)),
              ],

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : (_codeSent ? _verifyOtp : _sendOtp),
                  child: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(_codeSent ? 'Verify' : 'Send code'),
                ),
              ),

              const SizedBox(height: 16),

              // Dev mode: skip auth for simulator testing
              Center(
                child: GestureDetector(
                  onTap: _loading ? null : _signInAnonymously,
                  child: const Text(
                    'Continue without sign in (dev mode)',
                    style: TextStyle(fontSize: 13, color: AppColors.ink3),
                  ),
                ),
              ),

              if (_codeSent) ...[
                const SizedBox(height: 12),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _codeSent = false;
                        _otpController.clear();
                        _error = null;
                      });
                    },
                    child: const Text(
                      'Use a different number',
                      style: TextStyle(fontSize: 13, color: AppColors.primary),
                    ),
                  ),
                ),
              ],

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final codes = [
          ('+971', 'UAE'),
          ('+91', 'India'),
          ('+44', 'UK'),
          ('+1', 'US / Canada'),
          ('+65', 'Singapore'),
          ('+61', 'Australia'),
          ('+966', 'Saudi Arabia'),
          ('+974', 'Qatar'),
          ('+973', 'Bahrain'),
          ('+968', 'Oman'),
          ('+965', 'Kuwait'),
        ];
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text('Select country', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.ink)),
            ),
            ...codes.map((c) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: Text('${c.$2}  ${c.$1}', style: const TextStyle(fontSize: 14)),
              onTap: () {
                setState(() => _countryCode = c.$1);
                Navigator.pop(context);
              },
            )),
          ],
        );
      },
    );
  }
}
