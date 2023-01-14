import 'package:antrian_online_restu/src/bloc/daftar_antrian_bloc.dart';
import 'package:antrian_online_restu/src/bloc/token_bloc.dart';
import 'package:antrian_online_restu/src/common/source/color_style.dart';
import 'package:antrian_online_restu/src/common/source/size_config.dart';
import 'package:antrian_online_restu/src/common/widget/error_response_widget.dart';
import 'package:antrian_online_restu/src/common/widget/loading_response_widget.dart';
import 'package:antrian_online_restu/src/model/daftar_antrian_model.dart';
import 'package:antrian_online_restu/src/model/token_model.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialogFormDaftar extends StatefulWidget {
  final String idRuangan;
  final String idCarabayar;

  const DialogFormDaftar({
    Key? key,
    required this.idRuangan,
    required this.idCarabayar,
  }) : super(key: key);

  @override
  _DialogFormDaftarState createState() => _DialogFormDaftarState();
}

class _DialogFormDaftarState extends State<DialogFormDaftar> {
  DaftarAntrianBloc _blocDaftar = DaftarAntrianBloc();
  TokenBloc _blocToken = TokenBloc();
  FocusNode _tanggalFocus = FocusNode();
  TextEditingController _tanggalCon = TextEditingController();
  String? _selectedDate;
  bool _isStreamDaftar = false;

  @override
  void initState() {
    super.initState();
    _inputStream();
  }

  void _inputStream() {
    _blocDaftar.idRuanganSink.add(widget.idRuangan);
    _blocDaftar.idCarabayarSink.add(widget.idCarabayar);
  }

  void _daftarAntrian() {
    _blocToken.getToken();
    setState(() {
      _isStreamDaftar = true;
    });
  }

  Future<void> _showDatePickerKunjungan(BuildContext context) async {
    final DateTime? _picked = await showDatePicker(
        context: context,
        locale: const Locale("id"),
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2030),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: kPrimaryColor,
              colorScheme: ColorScheme.light(primary: kPrimaryColor),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        });

    if (_picked != null) {
      _tanggalFocus.unfocus();
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        _selectedDate = DateFormat("yyyy-MM-dd").format(_picked);
        _tanggalCon.text = '${_selectedDate}';
      });
      _blocDaftar.tanggalSink.add('${_selectedDate}');
    } else {
      _tanggalFocus.unfocus();
      FocusScope.of(context).requestFocus(new FocusNode());
    }
  }

  @override
  void dispose() {
    _blocToken.dispose();
    _blocDaftar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (_isStreamDaftar) {
      return Dialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: dialogStreamToken(context),
        ),
      );
    }
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  'SELANGKAH LAGI',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Pilih tanggal kunjungan untuk pendaftaran anda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 24.0),
              _streamInputTanggal(context),
              SizedBox(height: 22.0),
              _streamButtonDaftar(context),
            ],
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
              Icons.calendar_today,
              size: 42.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _streamButtonDaftar(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _blocDaftar.submitStream,
      builder: (context, snapshot) {
        return Container(
          width: SizeConfig.blockSizeHorizontal * 50,
          height: 42.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.0)),
          child: TextButton(
            onPressed: snapshot.hasData ? _daftarAntrian : null,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: kPrimaryLightColor,
              disabledForegroundColor: Colors.grey[300],
            ),
            child: Text('Daftar Sekarang'),
          ),
        );
      },
    );
  }

  Widget _streamInputTanggal(BuildContext context) {
    return StreamBuilder<String>(
      stream: _blocDaftar.tanggalStream,
      builder: (context, snapshot) {
        return TextField(
          controller: _tanggalCon,
          focusNode: _tanggalFocus,
          readOnly: true,
          onTap: () => _showDatePickerKunjungan(context),
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
            isDense: true,
            errorText: snapshot.hasError ? '${snapshot.error}' : '',
            errorStyle: TextStyle(color: Colors.redAccent),
            hintText: 'Format: YYYY-MM-DD',
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 14.0,
              fontStyle: FontStyle.italic,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
              28.0,
            )),
          ),
        );
      },
    );
  }

  Widget dialogStreamToken(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: SizeConfig.screenWidth,
          constraints:
              BoxConstraints(minHeight: SizeConfig.blockSizeVertical * 30),
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
          child: _buildStreamToken(context),
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
              Icons.info,
              size: 42.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreamToken(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseTokenModel>>(
      stream: _blocToken.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return LoadingResponseWidget(
                message: snapshot.data!.message,
              );
            case Status.ERROR:
              return ErrorResponseWidget(
                message: snapshot.data!.message,
                reload: () {
                  _blocToken.getToken();
                  setState(() {});
                },
              );
            case Status.COMPLETED:
              return Daftarsubmit(
                bloc: _blocDaftar,
              );
          }
        }
        return Container();
      },
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 42.0;
}

class Daftarsubmit extends StatefulWidget {
  final DaftarAntrianBloc bloc;

  const Daftarsubmit({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  _DaftarsubmitState createState() => _DaftarsubmitState();
}

class _DaftarsubmitState extends State<Daftarsubmit> {
  @override
  void initState() {
    super.initState();
    _daftarkanAntrian();
  }

  void _daftarkanAntrian() {
    widget.bloc.daftarAntrian();
  }

  _saveInfoPendaftaran(String noAntrian, String nama, String ruangan,
      String caraBayar, String tanggal) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('noAntrian', noAntrian);
    _prefs.setString('nama', nama);
    _prefs.setString('ruangan', ruangan);
    _prefs.setString('caraBayar', caraBayar);
    _prefs.setString('tanggal', tanggal);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseDaftarAntrianModel>>(
      stream: widget.bloc.daftarStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return LoadingResponseWidget(
                message: snapshot.data!.message,
              );

            case Status.ERROR:
              return ErrorResponseWidget(
                message: snapshot.data!.message,
                reload: () {
                  widget.bloc.daftarAntrian();
                  setState(() {});
                },
              );
            case Status.COMPLETED:
              if (!snapshot.data!.data!.success!) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: SizeConfig.blockSizeVertical * 15,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/failed.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 28.0,
                    ),
                    Text(
                      '${snapshot.data!.data!.message}',
                      style: TextStyle(fontSize: 15.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }
              var data = snapshot.data!.data!.data;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _saveInfoPendaftaran(
                    '${data!.noAntrian}',
                    '${data.nama}',
                    '${data.ruangan}',
                    '${data.carabayar}',
                    '${data.tanggalkunjungan}');
              });

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: SizeConfig.blockSizeVertical * 15,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/success.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 28.0,
                  ),
                  Text(
                    '${snapshot.data!.data!.message}',
                    style: TextStyle(fontSize: 22.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
          }
        }
        return Container();
      },
    );
  }
}
