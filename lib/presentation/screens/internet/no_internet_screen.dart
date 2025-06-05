import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../services/netwok/network_helper.dart';
import '../../../shared/constants/assets.dart';

class NoInternetScreen extends StatelessWidget {
  static const routeName = '/noInternetScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [Color(0xFF0D1B2A), Color(0xFF1B3A4B)] // Dark theme
                : [Color(0xFFE1F5FE), Color(0xFFB3E5FC)], // Light theme
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  Assets.meditation,
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 30),
                Text(
                  'Connection Lost',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01579B),
                    fontFamily: 'Comfortaa',
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Take a deep breath. We\'ll help you reconnect\nwhen you\'re ready.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0277BD),
                    fontFamily: 'Nunito',
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () async {
                    if (await NetworkHelper.hasInternet()) {
                      context.pop();
                    }
                  },
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
