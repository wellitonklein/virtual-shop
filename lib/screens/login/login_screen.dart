import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/helpers/validators.dart';
import 'package:virtual_shop/models/user.dart';
import 'package:virtual_shop/models/user_manager.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) => ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    enabled: !userManager.loading,
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (value) {
                      if (!emailValid(value)) {
                        return 'E-mail inválido';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    enabled: !userManager.loading,
                    controller: _passwordController,
                    decoration: const InputDecoration(hintText: 'Senha'),
                    autocorrect: false,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (value.length < 6) {
                        return 'Senha muito curta. Mínimo 6 caracteres';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: const Text('Esqueci minha senha'),
                    ),
                  ),
                  SizedBox(
                    height: 44,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      disabledColor:
                          Theme.of(context).primaryColor.withAlpha(100),
                      onPressed: userManager.loading
                          ? null
                          : () {
                              if (_formKey.currentState.validate()) {
                                userManager.signIn(
                                  user: User(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                  onFail: (String e) {
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(e),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                  onSuccess: () => Navigator.of(context).pop(),
                                );
                              }
                            },
                      child: userManager.loading
                          ? const CircularProgressIndicator()
                          : const Text('Entrar',
                              style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: SizedBox(
                      height: 25,
                      child: FlatButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed('/signup'),
                        child: const Text('Criar conta'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
