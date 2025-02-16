import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../model/user_data.dart';
import '../../services/auth_service.dart';

import '../../components/custom_elevated_button.dart';
import '../../components/outline_text_form.dart';

import '../../constants.dart';
import '../../main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final cpfController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    surnameController.dispose();
    cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Cadastro',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: OutlineTextForm(
                          hintTxt: 'Nome',
                          iconData: Icons.person,
                          hideText: false,
                          txtController: nameController,
                          textInputAction: TextInputAction.next,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Campo obrigatório.'
                              : null,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: OutlineTextForm(
                          hintTxt: 'Sobrenome',
                          iconData: Icons.person,
                          hideText: false,
                          txtController: surnameController,
                          textInputAction: TextInputAction.next,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Campo obrigatório.'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  kSpaceBox,
                  OutlineTextForm(
                    hintTxt: 'Digite o seu cpf',
                    iconData: FontAwesomeIcons.addressCard,
                    hideText: false,
                    txtController: cpfController,
                    keyType: TextInputType.number,
                    inputFormat: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11)
                    ],
                    textInputAction: TextInputAction.next,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => (value != null && !value.isCpf)
                        ? "Por favor, coloque um CPF Válido!."
                        : null,
                  ),
                  kSpaceBox,
                  OutlineTextForm(
                    hintTxt: 'Digite o seu e-mail',
                    iconData: Icons.email,
                    hideText: false,
                    txtController: emailController,
                    textInputAction: TextInputAction.next,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => (value == null || value.isEmail)
                        ? null
                        : "Por favor, coloque um e-mail válido.",
                  ),
                  kSpaceBox,
                  OutlineTextForm(
                    hintTxt: 'Digite a sua senha',
                    iconData: Icons.lock,
                    hideText: true,
                    txtController: passwordController,
                    textInputAction: TextInputAction.go,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => (value != null && value.length < 6)
                        ? 'A senha deve contar no mínimo 6 caracteres'
                        : null,
                  ),
                  kSpaceBox,
                  CustomElevetedButton(
                    btnLabel: 'Cadastrar-se',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        signUp();
                      }
                    },
                  ),
                  kSpaceBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Já cadastrado?'),
                      TextButton(
                        onPressed: () {
                          AuthService.to.toggle();
                        },
                        child: const Text(
                          'Entrar',
                          style: TextStyle(color: kDefaultColorGreen),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();

    //Verifica se o formulário foi preenchido.
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final UserData user = UserData(
      name: nameController.text.trim(),
      surname: surnameController.text.trim(),
      cpf: cpfController.text.trim(),
      email: emailController.text.trim().toLowerCase(),
    );

    AuthService.to.createUser(
      user,
      passwordController.text,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    });
  }
}
