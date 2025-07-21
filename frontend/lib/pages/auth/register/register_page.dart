import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:springr/utils/constants.dart';
import 'package:springr/services/config.dart';
import 'package:springr/pages/auth/login/login_page.dart'; // Import trang login để chuyển hướng

import '../../../components/c_elevated_button.dart';
import '../../../components/c_text_form_field.dart';
import '../../../providers/password_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Sửa lại logic đăng ký, không dùng Form hay isLoading
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return; // Dừng hàm nếu form không hợp lệ
    }

    setState(() {
      _isLoading = true; // Bỏ đi setState cho isLoading
    });

    // Bỏ đi setState cho isLoading
    try {
      final regBody = {
        "email": _emailController.text,
        "phonenumber": _phoneController.text,
        "password": _passwordController.text,
      };

      final response = await http.post(
        Uri.parse(registration),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(regBody),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công! Vui lòng đăng nhập.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Đăng ký thất bại. Vui lòng thử lại.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Bỏ đi setState cho isLoading
        });
      }
    }
  }

  Widget _buildStaticBackground() {
    return Stack(
      children: [
        Positioned(
          top: -100.h,
          left: -150.w,
          child: Container(
            width: 400.w,
            height: 400.h,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 250.h,
          right: -50.w,
          child: Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          _buildStaticBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Create an account',
                      style: heading2Dark,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Start your journey with us',
                      style: descriptionStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h),
                    CTextFormField(
                      textControllor: _emailController,
                      hintText: 'E-mail',
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: secondaryTextColor,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null; // Trả về null nếu không có lỗi
                      },
                    ),
                    SizedBox(height: 20.h),
                    CTextFormField(
                      textControllor: _phoneController,
                      hintText: 'Phone Number',
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: secondaryTextColor,
                      ),
                      keyboardType: TextInputType.phone,
                      // Bỏ validator
                    ),
                    SizedBox(height: 20.h),
                    Consumer<PasswordProvider>(
                      builder: (context, passwordProvider, child) =>
                          CTextFormField(
                            textControllor: _passwordController,
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: secondaryTextColor,
                            ),
                            obscureText: passwordProvider.isObscure,
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordProvider.isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: secondaryTextColor,
                              ),
                              onPressed: () =>
                                  passwordProvider.toggleIsObscure(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null; // Trả về null nếu không có lỗi
                            },
                          ),
                    ),
                    SizedBox(height: 20.h),
                    Consumer<PasswordProvider>(
                      builder: (context, passwordProvider, child) =>
                          CTextFormField(
                            textControllor: _confirmPasswordController,
                            hintText: 'Confirm Password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: secondaryTextColor,
                            ),
                            obscureText: passwordProvider.isConfirmObscure,
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordProvider.isConfirmObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: secondaryTextColor,
                              ),
                              onPressed: () =>
                                  passwordProvider.toggleIsConfirmObscure(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null; // Trả về null nếu không có lỗi
                            },
                          ),
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(
                      width: double.infinity,
                      child: CElevatedButton(
                        // Sửa lại onPressed và child
                        onPressed: () {
                          if (!_isLoading) {
                            _handleRegister();
                          }
                        },
                        child: _isLoading
                            // NẾU `_isLoading` là true, hiển thị một vòng quay tải.
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white, // Màu của vòng quay
                                  strokeWidth: 2,      // Độ dày của vòng quay
                                ),
                              )
                            // NẾU `_isLoading` là false, hiển thị văn bản như cũ.
                            : const Text(
                                'Register',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    InkWell(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      },
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: smallTextDark,
                            ),
                            TextSpan(text: 'Login now', style: linkText),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
