import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instrument/src/screens/login/login_bloc.dart';
import 'package:wom_package/wom_package.dart';
import '../../utils.dart';
import 'authentication_bloc.dart';
import 'load_stuff_button.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBox extends StatefulWidget {
  final LoginBloc loginBloc;
  final AuthenticationBloc authenticationBloc;

  const LoginBox({
    Key key,
    @required this.loginBloc,
    @required this.authenticationBloc,
  }) : super(key: key);

  @override
  _LoginBoxState createState() => _LoginBoxState();
}

class _LoginBoxState extends State<LoginBox> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  LoginBloc get _loginBloc => widget.loginBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginEvent, LoginState>(
      bloc: _loginBloc,
      builder: (
        BuildContext context,
        LoginState state,
      ) {
        if (state is LoginFailure) {
          onWidgetDidBuild(
            () {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        }

        /*return Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'username'),
                controller: _usernameController,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'password'),
                controller: _passwordController,
                obscureText: true,
              ),
              RaisedButton(
                onPressed:
                    state is! LoginLoading ? _onLoginButtonPressed : null,
                child: Text('Login'),
              ),
              Container(
                child:
                    state is LoginLoading ? CircularProgressIndicator() : null,
              ),
            ],
          ),
        );*/

        return AspectRatio(
          aspectRatio: 1,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlutterLogo(
                      size: 50.0,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {},
                      inputFormatters: [
                        ValidatorInputFormatter(
                          editingValidator: EmailEditingRegexValidator(),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    LoadStuffButton(
                      loginBloc: _loginBloc,
                      onTap: _onLoginButtonPressed,
                    ),
                    /*GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => HomeScreen(),
                                ),
                              );
                            },
                            child: Card(
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                    child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,fontSize: 20.0),
                                )),
                              ),
                            ),
                          ),*/
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _onLoginButtonPressed() {
    final mail = _usernameController.text;
    final password = _passwordController.text;
    bool isValidMail = EmailSubmitRegexValidator().isValid(mail);
    print(isValidMail);
    if (isValidMail && password.length > 5) {
      FocusScope.of(context).requestFocus(new FocusNode());
      _loginBloc.dispatch(LoginButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text,
      ));
    } else {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
