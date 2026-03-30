import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Widget build(BuildContext context){
    return const MaterialApp(home: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

Widget build(BuildContext context){
  return MaterialApp(
    home:Scaffold(
      appBar: AppBar(title: Text('Página de Login'), centerTitle: true,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
            ],
          ))
      )
    )
  )
}
}
