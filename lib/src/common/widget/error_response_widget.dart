import 'package:antrian_online_restu/src/common/source/size_config.dart';
import 'package:flutter/material.dart';

class ErrorResponseWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? reload;

  const ErrorResponseWidget({Key? key, this.message, this.reload})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$message',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 18.0,
        ),
        Container(
          width: SizeConfig.blockSizeHorizontal * 40,
          child: TextButton(
            onPressed: reload,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Coba Lagi'),
          ),
        )
      ],
    );
  }
}
