import 'package:antrian_online_restu/src/common/source/color_style.dart';
import 'package:antrian_online_restu/src/common/source/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomDialogForm extends StatefulWidget {
  final String title, description, buttonText;
  final Function submitForm;

  CustomDialogForm({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.submitForm,
  });

  @override
  _CustomDialogFormState createState() => _CustomDialogFormState();
}

class _CustomDialogFormState extends State<CustomDialogForm> {
  CollectionReference firestore =
      FirebaseFirestore.instance.collection('restu');
  final TextEditingController _inputCon = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: dialogContent(context),
      ),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: 32.0,
            left: 32.0,
            right: 32.0,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(
                  height: 18.0,
                ),
                TextFormField(
                  controller: _inputCon,
                  textInputAction: TextInputAction.newline,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  autofocus: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field is required';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 32.0,
                ),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 80,
                  height: 45.0,
                  child: TextButton(
                    onPressed: () =>
                        widget.submitForm(_inputCon.text, _formKey),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('${widget.buttonText}'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: Consts.avatarRadius + Consts.padding - 18,
          right: 1.0,
          child: Container(
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.grey[500]),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            backgroundColor: kPrimaryColor,
            radius: Consts.avatarRadius,
            child: Icon(
              Icons.question_answer,
              size: 52.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 42.0;
}
