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
  bool emailAlreadySent = false;
  AuthState authState = AuthState.signIn;
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

  void _tryCreateAccount() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    UserCredential userCredential;
    try {
      if (isValid) {
        _formKey.currentState!.save();
        FirebaseAuth.instance.createUserWithEmailAndPassword(
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
    if (emailAlreadySent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Email Already Sent',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
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
        authState = AuthState.signIn;
      });
      emailAlreadySent = true;
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(),
        Text(
          authState == AuthState.forgotPass
              ? 'Forgot Password'
              : authState == AuthState.signIn
                  ? 'Sign In'
                  : 'Create Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40, bottom: 5),
          constraints: const BoxConstraints(
            maxWidth: 200,
            minWidth: 100,
          ),
          child: Image.asset('images/hbot leads logo white ex small.png'),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 250,
                  minWidth: 150,
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  controller: _emailController,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.all(14),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    enabledBorder: const OutlineInputBorder(
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
              if (authState != AuthState.forgotPass)
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 250,
                    minWidth: 150,
                  ),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    obscureText: isObscured,
                    controller: _passwordController,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(14),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: const OutlineInputBorder(
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
              const SizedBox(height: 5),
              if (authState != AuthState.forgotPass)
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
                        const SizedBox(width: 3),
                        Text(isObscured ? 'Show Password' : 'Hide Password'),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (authState == AuthState.forgotPass) {
                          _sendForgotPassEmail();
                        } else if (authState == AuthState.signIn) {
                          _trySignIn();
                        } else {
                          _tryCreateAccount();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: Colors.lightBlueAccent,
                      ),
                      child: Text(
                        authState == AuthState.forgotPass
                            ? 'Send Email'
                            : authState == AuthState.signIn
                                ? 'Sign In'
                                : 'Create Account',
                      ),
                    ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  if (authState == AuthState.signIn) {
                    setState(() {
                      authState = AuthState.signUp;
                    });
                  } else {
                    setState(() {
                      authState = AuthState.signIn;
                    });
                  }
                },
                child: Text(
                  authState == AuthState.signIn
                      ? 'Create an Account'
                      : 'Back To Sign In',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 5),
              if (authState == AuthState.signIn)
                TextButton(
                  onPressed: () {
                    setState(() {
                      authState = AuthState.forgotPass;
                    });
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.grey[800],
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                  child: const Text('Forgot Password'),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
