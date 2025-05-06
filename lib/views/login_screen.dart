import 'package:flutter/material.dart';
import 'package:truthscan_app/services/auth_services.dart';
import 'package:truthscan_app/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  bool isLoading = false;
  String? errorMessage;
  bool _obscureText = true; // For toggling password visibility

  void _login(BuildContext context) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    final result = await authService.login(username, password);

    setState(() {
      isLoading = false;
    });

    if (result) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      setState(() {
        errorMessage = "Invalid username or password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Reduce vertical space
            children: [
              Image.asset(
                'lib/assets/images/detectai.png',
                height: 80,
              ), // Smaller image
              const SizedBox(height: 15), // Reduced spacing
              ConstrainedBox(
                // Control maximum width of the Card
                constraints: BoxConstraints(
                  maxWidth: 350,
                ), // Set a maximum width
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // Slightly smaller radius
                  ),
                  margin: const EdgeInsets.only(top: 12), // Reduced top margin
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Reduced padding
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Reduce vertical space within Card
                      children: [
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 18, // Smaller font size
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 6), // Reduced spacing
                        Text(
                          "Login to your account",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ), // Smaller font size
                        ),
                        const SizedBox(height: 18), // Reduced spacing
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // Smaller radius
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              size: 20,
                            ), // Smaller icon
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ), // Reduced padding
                          ),
                          style: TextStyle(fontSize: 14), // Smaller text size
                        ),
                        const SizedBox(height: 12), // Reduced spacing
                        TextField(
                          controller: passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: "Password",
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // Smaller radius
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 20,
                            ), // Smaller icon
                            suffixIcon: IconButton(
                              // Eye button here
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ), // Reduced padding
                          ),
                          style: TextStyle(fontSize: 14), // Smaller text size
                        ),
                        if (errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                            ), // Reduced top padding
                            child: Text(
                              errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ), // Smaller font size
                            ),
                          ),
                        const SizedBox(height: 18), // Reduced spacing
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () => _login(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ), // Reduced padding
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ), // Smaller radius
                              ),
                            ),
                            child:
                                isLoading
                                    ? SizedBox(
                                      // Smaller progress indicator
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 14, // Smaller font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 12), // Reduced spacing
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.register,
                            );
                          },
                          child: Text(
                            "Don't have an account? Register",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 12, // Smaller font size
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
        ),
      ),
    );
  }
}
