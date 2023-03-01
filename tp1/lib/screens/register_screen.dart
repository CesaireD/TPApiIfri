import '../data/services/users_service.dart';
import '../screens/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _passwordVisible = false;

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  _register(email, username, password) async {
    setState(() {
      isLoading = true;
    });
    try {
      print('-----------------');
      var result = await UserService.create({
        'username':username,
        'email':email,
        'password': password
      });
      print('-----------------$result');
      Fluttertoast.showToast(msg: "Utilisateur créé avec succès");
    } on DioError catch (e) {
      /*Map<String, dynamic> error = e.response?.data;
      if (error != null && error.containsKey('message')) {
        Fluttertoast.showToast(msg: error['message']);
      } else {
        Fluttertoast.showToast(msg: "Une erreur est survenue veuillez rééssayer");
      }*/
      print(e.response);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Inscription", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.blue),),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          hintText: "Entrez votre pseudo",
                          labelText: "Pseudo",
                          icon: Icon(Icons.person)
                      ),
                      validator: (value) {
                        return value == null || value == "" ? "Ce champs est obligatoire" : null;
                      },
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: "Entrez votre e-mail",
                          labelText: "E-mail",
                          icon: Icon(Icons.alternate_email)
                      ),
                      validator: (value) {
                        return value == null || value == "" ? "Ce champs est obligatoire" : null;
                      },
                    ),
                    SizedBox(height: 10.0,),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                          hintText: "Entrez votre mot de passe",
                          labelText: "Mot de passe",
                          icon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: _passwordVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                          ),
                      ),
                      validator: (value) {
                        return value == null || value == "" ? "Ce champs est obligatoire" : null;
                      },
                    ),
                    SizedBox(height: 20.0,),
                    ElevatedButton(
                        onPressed: () async {
                          if (!isLoading && formKey.currentState!.validate()) {
                            await _register(emailController.text, usernameController.text, passwordController.text);
                            /*emailController.text = "";
                            usernameController.text = "";
                            passwordController.text = "";*/
                          }
                        },
                        child: isLoading ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)) : Text("S'inscrire")
                    )
                  ],
                )
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text("Vous avez un compte? Connectez vous", style: TextStyle(fontSize: 17, color: Colors.blue),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
