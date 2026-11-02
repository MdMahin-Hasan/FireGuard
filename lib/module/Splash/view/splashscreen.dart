import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(143, 45, 45, 1),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 145),
            Container(
              height: 90,
              width: 90,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromRGBO(245, 245, 245, 0.3),
              ),
              child: Image.asset(
                "assets/images/splashlogo.png",
              ),
            ),
            Text(
              "FireGuard",
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
            Text(
              "Gas • Fire • Tempereture monitoning",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            SizedBox(height: 120),
            SizedBox(width: 90, child: LinearProgressIndicator(minHeight: 2)),
            SizedBox(height: 16),
            Text("Loading...", style: TextStyle(color: Colors.white)),

          ],
        ),
      ),
    );
  }
}
