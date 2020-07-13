import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final String message;

  Loader({
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 15.0,
            ),
            Text(
              this.message,
            ),
          ]),
    );
  }
}
