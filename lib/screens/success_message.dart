import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_chatapplication/screens/login_screen.dart';
import 'package:online_chatapplication/widgets/buttons.dart';

import '../widgets/container.dart';

class SuccessMessageScreen extends StatelessWidget {
  const SuccessMessageScreen({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  }) : super(key: key);

  final String title, subtitle;
  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background5.jpg'),
                fit: BoxFit.cover
              )
            ),
          ),
          Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildContainer(
                width: MediaQuery.of(context).size.width* 0.85,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    buildElevatedButton(label: 'Continue', onPressed: ()=> Get.off(()=> LoginScreen()))
                  ],
                ),
              ),
            ),
          ),
        ),
    ],
      ),
    );
  }
}
