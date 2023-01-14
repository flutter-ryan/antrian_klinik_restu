import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 15.0,
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitHourGlass(
              color: Colors.grey[800]!,
              size: 52.0,
            ),
            SizedBox(
              height: 18.0,
            ),
            Text(
              '$message',
              style: TextStyle(color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }
}
