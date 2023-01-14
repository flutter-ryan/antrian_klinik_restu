import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? close;

  const DialogWidget({
    Key? key,
    this.message,
    this.close,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 25.0),
          margin: EdgeInsets.symmetric(horizontal: 52),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Warning',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 22.0,
              ),
              Text(
                '$message',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 32.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: InkWell(
                      onTap: close,
                      child: Text(
                        'Tutup',
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
