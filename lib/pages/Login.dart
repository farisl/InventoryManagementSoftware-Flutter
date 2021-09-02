import 'package:flutter/material.dart';
import 'package:inventory_management_software/services/APIService.dart';
import 'package:inventory_management_software/models/AuthResult.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/imssq-newwhite.jpg')
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (value){
                          if(value == null || value.isEmpty)
                            return 'Email is a required field';
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          hintText: 'Email'
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (value){
                          if(value == null || value.isEmpty)
                            return 'Password is a required field';
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            hintText: 'Password'
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 60,
                          width: 300,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: TextButton(
                          onPressed: () async{
                            if(_formKey.currentState!.validate()) {
                              var response = await Login();
                              if (response != null)
                                Navigator.of((context)).pushReplacementNamed(
                                    '/userProfile');
                            }
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                            ),
                          ),
                        ),
                      )
                    ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String message) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error!"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<dynamic>? Login() async{
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
      String query = 'Email=' + emailController.text
          + '&Password=' + passwordController.text;
      var json = await APIService.Post('AuthManagement/Login', query);
      if(json == null) {
        showAlertDialog(context, 'Email or password is incorrect.');
        return null;
      }
      AuthResult authResult = AuthResult.fromJson(json);
      if(authResult.inventoryId == 0){
        showAlertDialog(context, 'You are not assigned to any inventory.');
        return null;
      }
      APIService.token = authResult.token;
      APIService.employeeId = authResult.employeeId!;
      APIService.inventoryId = authResult.inventoryId!;
      APIService.userId = authResult.userId!;
      return authResult;
    }
    else {
      showAlertDialog(context, 'All fields are required.');
      return null;
    }
  }

}
