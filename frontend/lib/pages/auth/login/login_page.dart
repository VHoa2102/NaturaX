import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:shared_preferences/shared_preferences.dart';

import 'package:springr/pages/auth/register/register_page.dart';
import 'package:springr/utils/constants.dart';
import 'package:springr/services/config.dart';
import 'package:springr/utils/routes.dart';

import '../../../components/c_elevated_button.dart';
import '../../../components/c_text_form_field.dart';
import '../../../components/secondary_button.dart';
import '../../../providers/password_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  // FIX 1: Khai báo biến _isLoading
  bool _isLoading = false;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // FIX 2: 
  Future<void> _handleLogin() async {
    // Kích hoạt validation của Form
    if (!(_formKey.currentState?.validate() ?? false)) {
      return; // Dừng lại nếu form không hợp lệ
    }

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // **FIX**: Tạo request body tương thích với backend controller
      // Backend của bạn mong đợi key là "email" hoặc "phonenumber", không phải "identifier".
      final identifier = _loginController.text.trim();
      final loginBody = {
        // Sử dụng collection-if để xác định key cần gửi đi
        if (identifier.contains('@'))
          'email': identifier
        else
          'phonenumber': identifier,
        'password': _passwordController.text,
      };

      final response = await http.post(
        Uri.parse(login), // Đảm bảo URL này là đúng
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginBody),
      );

      if (!mounted) return;

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Đăng nhập thành công
        final userToken = responseData['token'];

        // Lưu token vào SharedPreferences để duy trì đăng nhập
        if (userToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', userToken);
          
          // Chuyển hướng đến trang chính và xóa các trang cũ
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacementNamed(RouteGenerator.navigationPage);
        } else {
           // Xử lý trường hợp API trả về 200 nhưng không có token
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lỗi: Không nhận được token từ server.'),
              backgroundColor: Colors.red,
            ),
          );
        }

      } else {
        // Đăng nhập thất bại, hiển thị lỗi từ server
        final errorMessage = responseData['message'] ?? 'Sai thông tin đăng nhập. Vui lòng thử lại.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Xử lý lỗi mạng hoặc các lỗi không mong muốn khác
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi kết nối: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Luôn đảm bảo tắt trạng thái loading
      if (mounted) {
        setState(() {
          _isLoading = false;
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
              // FIX 4: Sửa withValues thành withOpacity
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
              color: primaryColor.withOpacity(0.2),
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
      body: Stack(
        children: [
          _buildStaticBackground(),
          // IMPROVEMENT 3: Loại bỏ lớp phủ loading toàn màn hình
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 70.h),
                    Text(
                      'Hello, Welcome Back!',
                      textAlign: TextAlign.center,
                      style: heading2Dark,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Login or create an account and experience something amazing',
                      style: descriptionStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 60.h),
                    CTextFormField(
                      textControllor: _loginController,
                      hintText: 'E-mail/Phone Number',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email or phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    Consumer<PasswordProvider>(
                      builder: (context, pp, child) {
                        return CTextFormField(
                          textControllor: _passwordController,
                          obscureText: pp.isObscure,
                          textInputAction: TextInputAction.done,
                          hintText: 'Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            onPressed: () => pp.toggleIsObscure(),
                            icon: Icon(
                              // FIX 4: Sửa lại icon cho đúng
                              pp.isObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 12.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: xSmallTextDark,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: CElevatedButton(
                        // IMPROVEMENT 3: Vô hiệu hóa nút và hiển thị loading indicator
                        onPressed: () {
                          // Chỉ thực thi hàm _handleRegister khi không ở trạng thái loading.
                          if (!_isLoading) {
                            _handleLogin();
                          }
                        },
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text('Or Sign In with', style: xSmallTextDark),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: SecondaryButton(
                        child: const Text(
                          'Google',
                          style: TextStyle(color: Color.fromARGB(255, 250, 250, 250)),
                        ),
                        onPressed: () {
                          // TODO: Implement Google Sign-In
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                      },
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          children: [
                            TextSpan(text: 'Not Register? ', style: smallTextDark),
                            TextSpan(
                              text: 'Create an Account',
                              style: linkText,
                            ),
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
