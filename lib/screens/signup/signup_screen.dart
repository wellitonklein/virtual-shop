import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/helpers/validators.dart';
import 'package:virtual_shop/models/user.dart';
import 'package:virtual_shop/models/user_manager.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final User _user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) => ListView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                children: <Widget>[
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration:
                        const InputDecoration(hintText: 'Nome Completo'),
                    autocorrect: false,
                    enabled: !userManager.loading,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (value.trim().split(' ').length <= 1) {
                        return 'Preencha seu nome completo';
                      }

                      return null;
                    },
                    onSaved: (value) => _user.name = value,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enabled: !userManager.loading,
                    validator: (value) {
                      if (!emailValid(value)) {
                        return 'E-mail inválido';
                      }

                      return null;
                    },
                    onSaved: (value) => _user.email = value,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: 'Senha'),
                    obscureText: true,
                    enabled: !userManager.loading,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (value.length < 6) {
                        return 'Senha muito curta. Mínimo 6 caracteres';
                      }

                      return null;
                    },
                    onSaved: (value) => _user.password = value,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration:
                        const InputDecoration(hintText: 'Repita a senha'),
                    obscureText: true,
                    enabled: !userManager.loading,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (value.length < 6) {
                        return 'Senha muito curta. Mínimo 6 caracteres';
                      }

                      return null;
                    },
                    onSaved: (value) => _user.confirmPassword = value,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 44,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      disabledColor:
                          Theme.of(context).primaryColor.withAlpha(100),
                      textColor: Colors.white,
                      onPressed: userManager.loading
                          ? null
                          : () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();

                                if (_user.password != _user.confirmPassword) {
                                  _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content:
                                          const Text('Senhas não coincidem!'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                userManager.signUp(
                                  user: _user,
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
                          : const Text(
                              'Criar conta',
                              style: TextStyle(fontSize: 18),
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
