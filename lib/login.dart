import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:heretaunga/components/Login/phoenix_text_field.dart';
import 'package:heretaunga/components/keys.dart';
import 'package:heretaunga/main.dart';
import 'package:heretaunga/tools/API/api.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  String errorText = "";
  bool isLoading = false;

  tryLogin() async {
    setState(() => isLoading = true);
    var result;
    if (_usernameController.text.toString().isNotEmpty) {
      if (_passwordController.text.toString().isNotEmpty) {
        result = await API().logon(
          _usernameController.text.toString().trim().toLowerCase(),
          _passwordController.text.toString().trim().toLowerCase(),
        );
      } else
        result = "Please fill out the password field";
    } else
      result = "Please fill out the username field";
    if (result == "success") {
      if(Keys.accessGlobalData.currentState.mounted) {
        Keys.accessGlobalData.currentState.refreshGlobals();
      }
      setState(() => isLoading = false);
      Navigator.of(context).pushReplacementNamed("/");
    } else {
      setState(() => isLoading = false);
      _passwordController.clear();
      setState(() {
        errorText = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).cardColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        errorText == "" ? "Login to Heretaunga" : errorText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 100,
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                width: double.infinity,
                height: double.infinity,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  PhoenixTextField(
                                    controller: _usernameController,
                                    labelText: "Username",
                                    helperText: "Ex: firstname.lastname",
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  PhoenixTextField(
                                    controller: _passwordController,
                                    labelText: "Password",
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: tryLogin,
                                    child: Text(
                                      isLoading
                                          ? "Loading".toUpperCase()
                                          : "Login".toUpperCase(),
                                      style: TextStyle(
                                        letterSpacing: 1.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0)),
                                    ),
                                  ),
                                ),
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
      ),
    );
  }
}
