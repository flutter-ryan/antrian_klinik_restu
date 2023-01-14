import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TextInputAuthWidget extends StatefulWidget {
  final String? hint;
  final IconData? icon;
  final IconButton? iconSuffix;
  final bool isDate;
  final FocusNode? focus;
  final TextEditingController controller;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final Function? onSubmitted;
  final Stream blocStream;
  final StreamSink blocSink;
  final bool isPassword;
  final bool isJenisKelamin;
  final bool isAgama;

  const TextInputAuthWidget({
    Key? key,
    this.hint,
    this.icon,
    this.iconSuffix,
    this.isDate = false,
    this.focus,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.sentences,
    this.onSubmitted,
    required this.blocStream,
    required this.blocSink,
    this.isPassword = false,
    this.isJenisKelamin = false,
    this.isAgama = false,
  }) : super(key: key);

  @override
  _TextInputAuthWidgetState createState() => _TextInputAuthWidgetState();
}

class _TextInputAuthWidgetState extends State<TextInputAuthWidget> {
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.focus != null) {
      widget.focus!.addListener(() => _focusListener(context));
    }
  }

  void _focusListener(BuildContext context) {
    if (widget.isDate && widget.focus!.hasFocus) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _showDatePicker(context);
    } else if (widget.isAgama && widget.focus!.hasFocus) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      Future.delayed(Duration(milliseconds: 700), () {
        showBarModalBottomSheet(
          context: context,
          builder: (context) => Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 18.0,
                ),
                Text(
                  'Pilih Agama',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 18.0,
                ),
                Divider(
                  height: 0.0,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: AgamaData.getAgama().length,
                  separatorBuilder: (context, int i) {
                    return Divider(
                      height: 0,
                    );
                  },
                  itemBuilder: (context, int i) {
                    var agama = AgamaData.getAgama()[i];
                    return ListTile(
                      onTap: () {
                        widget.controller.text = agama.desc;
                        widget.blocSink.add(agama.id.toString());
                        Navigator.pop(context);
                      },
                      title: Text("${agama.desc}"),
                    );
                  },
                ),
              ],
            ),
          ),
        ).whenComplete(() {
          FocusScope.of(context).nextFocus();
        });
      });
    } else if (widget.isJenisKelamin && widget.focus!.hasFocus) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      Future.delayed(Duration(milliseconds: 700), () {
        showBarModalBottomSheet(
          context: context,
          builder: (context) => Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 18.0,
                ),
                Text(
                  'Pilih jenis kelamin',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 18.0,
                ),
                Divider(
                  height: 0.0,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: JenisKelaminData.getJenisKelamin().length,
                  separatorBuilder: (context, int i) {
                    return Divider(
                      height: 0,
                    );
                  },
                  itemBuilder: (context, int i) {
                    var jk = JenisKelaminData.getJenisKelamin()[i];
                    return ListTile(
                      onTap: () {
                        widget.controller.text = jk.gender;
                        widget.blocSink.add(jk.code);
                        Navigator.pop(context);
                      },
                      title: Text("${jk.gender}"),
                    );
                  },
                ),
              ],
            ),
          ),
        ).whenComplete(() {
          FocusScope.of(context).nextFocus();
        });
      });
    }
  }

  Future<Null> _showDatePicker(BuildContext context) async {
    Future.delayed(Duration(milliseconds: 500), () async {
      final DateTime? _picked = await showDatePicker(
          context: context,
          locale: const Locale("id"),
          initialDate: DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime(2030),
          initialDatePickerMode: DatePickerMode.year,
          builder: (context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child!,
            );
          });
      if (_picked != null &&
          DateFormat("yyyy-MM-dd").format(_picked) != _selectedDate) {
        FocusScope.of(context).nextFocus();
        String tanggal = DateFormat("yyyy-MM-dd").format(_picked);
        widget.blocSink.add(tanggal);
        setState(
          () {
            _selectedDate = tanggal;
            widget.controller.text = DateFormat("yyyy-MM-dd").format(_picked);
          },
        );
      } else {
        FocusScope.of(context).nextFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: widget.blocStream,
      builder: (context, snapshot) {
        return Theme(
          data: ThemeData(
            primaryColor: Colors.yellow[700],
            hintColor: Colors.white,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focus,
            style: TextStyle(color: Colors.grey[200]),
            keyboardType: widget.textInputType,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            obscureText: widget.isPassword,
            onChanged: (value) {
              widget.blocSink.add(value);
            },
            decoration: InputDecoration(
              errorText: snapshot.hasError ? '${snapshot.error}' : '',
              errorStyle: TextStyle(color: Colors.red[100]),
              prefixIcon: Icon(
                widget.icon,
                color: Colors.grey[300],
              ),
              suffixIcon: widget.iconSuffix,
              enabledBorder: UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.yellow),
              ),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[200]!)),
              hintText: '${widget.hint}',
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w300, color: Colors.grey[300]),
            ),
            onSubmitted: (value) => widget.onSubmitted!(value),
          ),
        );
      },
    );
  }
}

class JenisKelaminData {
  int id;
  String code;
  String gender;

  JenisKelaminData({
    required this.id,
    required this.code,
    required this.gender,
  });

  static List<JenisKelaminData> getJenisKelamin() {
    return <JenisKelaminData>[
      JenisKelaminData(id: 1, code: "L", gender: 'Laki-laki'),
      JenisKelaminData(id: 2, code: "P", gender: 'Perempuan'),
    ];
  }
}

class AgamaData {
  int id;
  String desc;

  AgamaData({
    required this.id,
    required this.desc,
  });

  static List<AgamaData> getAgama() {
    return <AgamaData>[
      AgamaData(id: 1, desc: 'Islam'),
      AgamaData(id: 2, desc: 'Kristen'),
      AgamaData(id: 3, desc: 'Hindu'),
      AgamaData(id: 4, desc: 'Budha'),
    ];
  }
}
