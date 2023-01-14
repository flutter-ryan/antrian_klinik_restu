import 'package:antrian_online_restu/src/common/source/size_config.dart';
import 'package:flutter/material.dart';

class ServerErrorWidget extends StatelessWidget {
  final String? message;
  final Function? reload;

  const ServerErrorWidget({
    Key? key,
    this.message,
    this.reload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 30,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/server_error.png'),
              ),
            ),
          ),
          SizedBox(
            height: 42.0,
          ),
          Text(
            '$message',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[300],
                fontSize: SizeConfig.blockSizeHorizontal * 5),
          ),
          SizedBox(
            height: 22.0,
          ),
          Container(
            width: SizeConfig.blockSizeHorizontal * 40,
            height: 40.0,
            child: TextButton(
              onPressed: () => reload,
              child: Text('Coba Lagi'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
