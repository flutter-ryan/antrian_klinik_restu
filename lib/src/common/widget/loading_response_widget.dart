import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingResponseWidget extends StatelessWidget {
  final String? message;

  const LoadingResponseWidget({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitHourGlass(
          color: Colors.grey[600]!,
          size: 42.0,
        ),
        SizedBox(
          height: 18.0,
        ),
        Text('$message'),
      ],
    );
  }
}
