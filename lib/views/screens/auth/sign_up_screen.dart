import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pressly/providers/auth_provider.dart';
import 'package:pressly/providers/language_provider.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  bool _hasReadTerms = false;
  bool _hasReadPrivacy = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showTermsAndConditions(ThemeProvider theme) {
    final scrollController = ScrollController();
    bool reachedBottom = false;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          scrollController.addListener(() {
            if (scrollController.position.pixels >= 
                scrollController.position.maxScrollExtent - 50) {
              if (!reachedBottom) {
                setDialogState(() => reachedBottom = true);
              }
            }
          });
          
          return AlertDialog(
            backgroundColor: theme.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: theme.isDarkMode ? Colors.white : Colors.black),
            ),
            title: Text(
              'Terms and Conditions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Text(
                          '''TERMS AND CONDITIONS

Last updated: December 14, 2025

1. ACCEPTANCE OF TERMS
By accessing and using Pressly ("the App"), you accept and agree to be bound by these Terms and Conditions. If you do not agree, please do not use the App.

2. USER ACCOUNT
- You must be at least 13 years old to create an account.
- You are responsible for maintaining the confidentiality of your account credentials.
- You agree to provide accurate and complete information during registration.
- You are responsible for all activities under your account.

3. USE OF THE SERVICE
- The App provides news aggregation services from various sources.
- You agree not to misuse the service or help anyone else do so.
- You may not use the App for any illegal or unauthorized purpose.

4. CONTENT
- All news content is sourced from third-party providers.
- We do not guarantee the accuracy or completeness of any content.
- Views expressed in articles do not represent our opinions.

5. USER CONDUCT
You agree NOT to:
- Share false or misleading information
- Harass, abuse, or harm other users
- Attempt to gain unauthorized access to the App
- Use automated systems to access the App without permission
- Violate any applicable laws or regulations

6. INTELLECTUAL PROPERTY
- The App and its original content are protected by copyright laws.
- You may not copy, modify, or distribute our content without permission.

7. PRIVACY
- Your use of the App is also governed by our Privacy Policy.
- We collect and process data as described in the Privacy Policy.

8. TERMINATION
- We may terminate or suspend your account at any time without notice.
- You may delete your account at any time.

9. DISCLAIMER OF WARRANTIES
THE APP IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND.

10. LIMITATION OF LIABILITY
WE SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES.

11. CHANGES TO TERMS
We reserve the right to modify these terms at any time. Continued use after changes constitutes acceptance.

12. CONTACT
For questions about these Terms, please contact us at support@pressly.com.

By using Pressly, you acknowledge that you have read, understood, and agree to these Terms and Conditions.''',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.isDarkMode ? Colors.white70 : Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!reachedBottom)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_downward, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Scroll to bottom to continue',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  side: BorderSide(color: theme.isDarkMode ? Colors.white : Colors.black),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: theme.isDarkMode ? Colors.white : Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: reachedBottom
                    ? () {
                        setState(() => _hasReadTerms = true);
                        Navigator.pop(context);
                        _updateAgreeToTerms();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.isDarkMode ? Colors.white : Colors.black,
                  foregroundColor: theme.isDarkMode ? Colors.black : Colors.white,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text('I have read'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPrivacyPolicy(ThemeProvider theme) {
    final scrollController = ScrollController();
    bool reachedBottom = false;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          scrollController.addListener(() {
            if (scrollController.position.pixels >= 
                scrollController.position.maxScrollExtent - 50) {
              if (!reachedBottom) {
                setDialogState(() => reachedBottom = true);
              }
            }
          });
          
          return AlertDialog(
            backgroundColor: theme.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: theme.isDarkMode ? Colors.white : Colors.black),
            ),
            title: Text(
              'Privacy Policy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Text(
                          '''PRIVACY POLICY

Last updated: December 14, 2025

1. INTRODUCTION
Pressly ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information.

2. INFORMATION WE COLLECT

2.1 Personal Information
- Email address
- Name (if provided)
- Profile picture (if using social login)

2.2 Usage Data
- App usage patterns
- Device information
- IP address
- Browser type

2.3 Cookies and Tracking
- We use cookies to enhance your experience
- Analytics data to improve our services

3. HOW WE USE YOUR INFORMATION
We use collected information to:
- Provide and maintain the App
- Personalize your experience
- Send important notifications
- Improve our services
- Respond to your inquiries
- Detect and prevent fraud

4. DATA SHARING
We may share your data with:
- Service providers who assist our operations
- Legal authorities when required by law
- Business partners with your consent

We do NOT sell your personal information.

5. DATA SECURITY
We implement security measures including:
- Encryption of data in transit
- Secure server infrastructure
- Regular security audits
- Access controls

6. YOUR RIGHTS
You have the right to:
- Access your personal data
- Correct inaccurate data
- Delete your account and data
- Opt-out of marketing communications
- Export your data

7. DATA RETENTION
We retain your data for as long as your account is active or as needed to provide services.

8. CHILDREN'S PRIVACY
The App is not intended for children under 13. We do not knowingly collect data from children.

9. THIRD-PARTY SERVICES
The App may contain links to third-party services. We are not responsible for their privacy practices.

10. INTERNATIONAL TRANSFERS
Your data may be transferred to and processed in countries outside your residence.

11. CHANGES TO THIS POLICY
We may update this Privacy Policy periodically. We will notify you of significant changes.

12. CONTACT US
For privacy concerns, contact us at:
Email: privacy@pressly.com

By using Pressly, you consent to this Privacy Policy and our data practices.''',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.isDarkMode ? Colors.white70 : Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!reachedBottom)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_downward, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Scroll to bottom to continue',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  side: BorderSide(color: theme.isDarkMode ? Colors.white : Colors.black),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: theme.isDarkMode ? Colors.white : Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: reachedBottom
                    ? () {
                        setState(() => _hasReadPrivacy = true);
                        Navigator.pop(context);
                        _updateAgreeToTerms();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.isDarkMode ? Colors.white : Colors.black,
                  foregroundColor: theme.isDarkMode ? Colors.black : Colors.white,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text('I have read'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateAgreeToTerms() {
    if (_hasReadTerms && _hasReadPrivacy) {
      setState(() => _agreeToTerms = true);
    }
  }

  Future<void> _registerWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms and Conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.registerWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _registerWithGoogle() async {
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithGoogle();

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Sign-In successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final language = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset((theme.isDarkMode) ? 'assets/images/logo_app_dark_theme.png' : 'assets/images/logo_app_light_theme.png',
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.1, fit: BoxFit.contain),
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(
            color: (theme.isDarkMode) ? Colors.white : Colors.black,
            width: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // login via Google
                  Text(language.getText('register'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                  Text(language.getText('register_subtitle'), style: TextStyle(fontSize: 13),),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _registerWithGoogle,
                        icon: Image.network(
                          'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-1024.png',
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 24),
                        ),
                        label: Text(
                          language.getText('register_google'),
                          style: TextStyle(
                            color: (theme.isDarkMode) ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: (theme.isDarkMode) ? Colors.white : Colors.black,
                            style: BorderStyle.solid,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                    )
                  ),

                  // separator
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: (theme.isDarkMode) ? Colors.white : Colors.black,
                          thickness: 2.0,
                        )
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                      Text(
                        language.getText('or'),
                        style: TextStyle(color: (theme.isDarkMode) ? Colors.white : Colors.black),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                      Expanded(
                        child: Divider(
                          color: (theme.isDarkMode) ? Colors.white : Colors.black,
                          thickness: 2.0,
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  // register manual
                  Text(language.getText('register_email_title'), style: TextStyle(fontSize: 13, color: (theme.isDarkMode) ? Colors.white : Colors.black),),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                        labelText: language.getText('email'),
                        labelStyle: TextStyle(color: (theme.isDarkMode) ? Colors.white : Colors.black),
                        hintText: language.getText('enter_email_hint'),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: (theme.isDarkMode) ? Colors.white : Colors.black,
                            style: BorderStyle.solid,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3.0,
                              color: (theme.isDarkMode) ? Colors.white : Colors.black,
                              style: BorderStyle.solid,
                            )
                        )
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    enabled: !_isLoading,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                        labelText: language.getText('password'),
                        labelStyle: TextStyle(color: (theme.isDarkMode) ? Colors.white : Colors.black),
                        hintText: language.getText('enter_password_hint'),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(
                            width: 2.0,
                            color: (theme.isDarkMode) ? Colors.white : Colors.black,
                            style: BorderStyle.solid,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3.0,
                              color: (theme.isDarkMode) ? Colors.white : Colors.black,
                              style: BorderStyle.solid,
                            )
                        )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    enabled: !_isLoading,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                        labelText: language.getText('repeat_password'),
                        labelStyle: TextStyle(color: (theme.isDarkMode) ? Colors.white : Colors.black),
                        hintText: language.getText('repeat_password_hint'),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(
                            width: 2.0,
                            color: (theme.isDarkMode) ? Colors.white : Colors.black,
                            style: BorderStyle.solid,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3.0,
                              color: (theme.isDarkMode) ? Colors.white : Colors.black,
                              style: BorderStyle.solid,
                            )
                        )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: _isLoading ? null : (value) {
                          if (value == true && (!_hasReadTerms || !_hasReadPrivacy)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please read both Terms and Conditions and Privacy Policy first'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                        activeColor: theme.isDarkMode ? Colors.white : Colors.black,
                        checkColor: theme.isDarkMode ? Colors.black : Colors.white,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(fontSize: 13, color: (theme.isDarkMode) ? Colors.white : Colors.black),
                                children: [
                                  TextSpan(text: language.getText('i_agree')),
                                  TextSpan(
                                    text: language.getText('terms_conditions'),
                                    style: TextStyle(
                                      color: (theme.isDarkMode) ? Colors.white : Colors.black, 
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => _showTermsAndConditions(theme),
                                  ),
                                  TextSpan(text: language.getText('and')),
                                  TextSpan(
                                    text: language.getText('privacy_policy'),
                                    style: TextStyle(
                                      color: (theme.isDarkMode) ? Colors.white : Colors.black, 
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => _showPrivacyPolicy(theme),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  _hasReadTerms ? Icons.check_circle : Icons.circle_outlined,
                                  size: 14,
                                  color: _hasReadTerms ? Colors.green : Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Terms',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: _hasReadTerms ? Colors.green : Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  _hasReadPrivacy ? Icons.check_circle : Icons.circle_outlined,
                                  size: 14,
                                  color: _hasReadPrivacy ? Colors.green : Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Privacy',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: _hasReadPrivacy ? Colors.green : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          side: BorderSide(
                            color: (theme.isDarkMode) ? Colors.white : Colors.black,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      onPressed: _isLoading ? null : _registerWithEmail,
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(language.getText('register'), style: TextStyle(color: (theme.isDarkMode) ? Colors.white : Colors.black, fontSize: 14, fontWeight: FontWeight.bold),)
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}
