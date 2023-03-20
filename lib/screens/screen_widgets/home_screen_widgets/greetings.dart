import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/utilities/functions/utils.dart';
import 'package:flutter/material.dart';

class Greetings extends StatelessWidget {
  const Greetings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Utils().getRandomGreeting(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Text(
                snapshot.data!,
                style: const TextStyle(
                  color: darkTextColor,
                  fontFamily: "DancingScript",
                  fontSize: 32,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Container();
          }
        } else {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(
                color: warningColor,
              ),
            ),
          );
        }
      },
    );
  }
}
