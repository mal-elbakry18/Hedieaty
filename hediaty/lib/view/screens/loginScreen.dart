/*import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true; // Toggle between login and signup

  // Controllers for form inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  // Error message (if any)
  String? _errorMessage;

  // Simulated Login (for demonstration)
  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Example validation
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Please enter email and password.";
      });
    } else {
      setState(() {
        _errorMessage = null; // Clear any previous error
      });
      print("Login successful with email: $email");
    }
  }

  // Simulated Signup (for demonstration)
  void _signup() {
    String first_name = _fnameController.text;
    String last_name = _lnameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    // Example validation
    if (last_name.isEmpty || first_name.isEmpty || email.isEmpty ||
        password.isEmpty) {
      setState(() {
        _errorMessage = "Please fill out all fields.";
      });
    } else {
      setState(() {
        _errorMessage = null; // Clear any previous error
      });
      print(
          "Signup successful with name: $first_name + $last_name, email: $email");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange,
           title:
            const Text('Login / SignUp',
                style: TextStyle(
                fontSize: 25,
                fontFamily: 'Anton',
                fontWeight: FontWeight.normal,
                color: Colors.white)
            ),
          leading: const Icon(Icons.menu,
          color: Colors.white,),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ],
          //bottom: ,
        )
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/firebase/auth_services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.loginWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/home'); // Navigate to home screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loginWithGoogle(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.signInWithGoogle();
      Navigator.pushReplacementNamed(context, '/home'); // Navigate to home screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => _login(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[800],
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Login'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _loginWithGoogle(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Login with Google'),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        'Don\'t have an account? Sign up',
                        style: TextStyle(color: Colors.orange[800]),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}