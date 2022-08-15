import 'package:flutter/material.dart';
import 'package:lead_selling/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPopUp extends StatefulWidget {
  const AuthPopUp({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthPopUp> createState() => _AuthPopUpState();
}

class _AuthPopUpState extends State<AuthPopUp> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool isObscured = true;
  bool _isForgotPassword = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _trySignIn() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    UserCredential userCredential;
    try {
      if (isValid) {
        _formKey.currentState!.save();
        userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      var message = 'An error occurred';

      if (e.message != null) {
        message = e.message!;
      }

      print(e);

      if (message.contains(
          'There is no user record corresponding to this identifier')) {
        message = 'User not found';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.toString(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor.withOpacity(.9),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor.withOpacity(.9),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _sendForgotPassEmail() {
    final isValid = _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Email Sent',
            textAlign: TextAlign.center,
          ),
          backgroundColor: themeColor,
        ),
      );
      Navigator.of(context).pop();
      setState(() {
        _isForgotPassword = false;
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 800,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(left: 40, right: 40, bottom: 5),
            child: Image.asset('images/easy eats white bg.png'),
            constraints: BoxConstraints(
              maxWidth: 380,
              minWidth: 200,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 250,
                    minWidth: 150,
                  ),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    controller: _emailController,
                    style: TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(14),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Enter a valid email address';
                      } else if (value.contains(' ')) {
                        return 'Email cannot contain spaces';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                if (!_isForgotPassword)
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 250,
                      minWidth: 150,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      obscureText: isObscured,
                      controller: _passwordController,
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(14),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.length < 7) {
                          return 'Password must be at least 7 characters long';
                        } else if (value.contains(' ')) {
                          return 'Password cannot contain spaces';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                SizedBox(height: 5),
                if (!_isForgotPassword)
                  InkWell(
                    onTap: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isObscured
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye,
                            size: 20,
                          ),
                          SizedBox(width: 3),
                          Text(isObscured ? 'Show Password' : 'Hide Password'),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 10),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (_isForgotPassword) {
                            _sendForgotPassEmail();
                          } else {
                            _trySignIn();
                          }
                        },
                        child:
                            Text(_isForgotPassword ? 'Send Email' : 'Sign In'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(themeColor),
                        ),
                      ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isForgotPassword = !_isForgotPassword;
                    });
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(themeColor),
                    overlayColor:
                        MaterialStateProperty.all(themeColor.withOpacity(.03)),
                  ),
                  child: Text(
                      _isForgotPassword ? 'Back to Login' : 'Forgot Password'),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'If you\'d like to create an account, you can do so after you order.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
