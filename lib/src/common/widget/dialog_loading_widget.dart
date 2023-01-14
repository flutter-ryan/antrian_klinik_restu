import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DialogLoadingWidget extends StatelessWidget {
  final String? message;

  const DialogLoadingWidget({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 22.0),
          margin: EdgeInsets.symmetric(horizontal: 52),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SpinKitHourGlass(
                    size: 28.0,
                    color: Colors.grey[600]!,
                  ),
                  SizedBox(
                    width: 22.0,
                  ),
                  Text('$message')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
