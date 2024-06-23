import 'package:flutter/material.dart';

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
    precacheImage(const AssetImage("assets/background5.jpg"), context);

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
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensure the column only takes necessary space
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: onPressed,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Continue',
                            style: TextStyle(fontSize: 16.0,color: Colors.white),
                          ),
                        ),
                      ),
                    ),
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
