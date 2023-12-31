import 'dart:convert';
import 'package:dacit/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dacit/main.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Send a POST request to the signup API endpoint
      final response = await http.post(
        Uri.parse('${baseDomain}dj-rest-auth/registration/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': _emailController.text,
          'password1': _password1Controller.text,
          'password2': _password2Controller.text,
        }),
      );

      if (response.statusCode == 204) {
        log.info("SignUp successfull");
        Navigator.pushNamed(context, '/login');
      } else {
        // Signup failed
        setState(() {
          _isLoading = false;
          _errorMessage = 'Invalid registration details';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign up'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(image: AssetImage('icon.png')),
                  Text(
                    AppLocalizations.of(context).welcome,
                    style: const TextStyle(
                        fontSize: 30, fontStyle: FontStyle.normal),
                  ),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).email,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).pleaseEnterEmail;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _password1Controller,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).password,
                    ),
                    autofillHints: const [AutofillHints.password],
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).pleaseEnterPassword;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _password2Controller,
                    decoration: const InputDecoration(
                      labelText: 'Confirm password',
                    ),
                    autofillHints: const [AutofillHints.password],
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _password1Controller.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Sign up'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
