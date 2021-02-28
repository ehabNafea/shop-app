import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widget/default_btn.dart';

enum AuthMode { LoginIn, SignUp }

class AuthScreen extends StatefulWidget {
  static const routeName = 'auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  var _authMode = AuthMode.LoginIn;
  var _isLoading = false;
  
  // AnimationController _controller;
  // Animation<Size> _heightAnimation;
  
  

  _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred!'),
              content: Text(message),
              actions: [
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (_authMode == AuthMode.LoginIn) {
          await Provider.of<Auth>(context, listen: false)
              .login(_authData['email'], _authData['password']);
        } else {
          await Provider.of<Auth>(context, listen: false)
              .signUp(_authData['email'], _authData['password']);
        }
      } on HttpException catch (error) {
        var errorMessage = 'Authentication failed';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'This email address is already in use.';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email address';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is too weak.';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Could not find a user with that email.';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid password.';
        }
        _showErrorDialog(errorMessage);
      } catch (error) {
        const errorMessage =
            'Could not authenticate you. Please check network and try again later.';
        _showErrorDialog(errorMessage);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _switchAuthMode() {
    if (_authMode == AuthMode.LoginIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.LoginIn;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          _authMode == AuthMode.LoginIn ? 'Sign In' : 'Sign Up',
          style: TextStyle(color: kTextColor),
        ),
        centerTitle: true,
        brightness: Brightness.light,
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20.0)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight * 0.04,
              ),
              Text(
                _authMode == AuthMode.LoginIn
                    ? 'Welcome Back'
                    : 'Register Account',
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Text(
                _authMode == AuthMode.LoginIn
                    ? 'Sign in with your email and password  \nor continue with social media'
                    : "Complete your details or continue \nwith social media",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.08,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter valid Email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['email'] = value;
                      },
                      decoration: inputDecoration(
                          labelText: 'Email', hintText: 'Enter your Email'),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20.0),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: inputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your Password',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter password';
                        }
                        if (value.length < 6) {
                          return 'Password should be at least 6 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                    ),
                    if (_authMode == AuthMode.SignUp)
                      SizedBox(
                        height: getProportionateScreenHeight(20.0),
                      ),
                    if (_authMode == AuthMode.SignUp)
                      TextFormField(
                        obscureText: true,
                        decoration: inputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Confirm Password',
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        },
                      ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _authMode == AuthMode.LoginIn
                              ? 'Don\'t have an account?'
                              : 'Do you have an account?',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(16.0),
                          ),
                        ),
                        GestureDetector(
                          onTap: _switchAuthMode,
                          child: Text(
                            _authMode == AuthMode.LoginIn
                                ? 'Sign Up'
                                : 'Log In',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(16.0),
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.08,
                    ),
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : DefaultBtn(
                            onTap: _submit,
                            text: _authMode == AuthMode.LoginIn
                                ? 'Log In'
                                : 'Sign Up',
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
