import 'package:antrian_online_restu/src/bloc/auth_bloc.dart';
import 'package:antrian_online_restu/src/bloc/login_bloc.dart';
import 'package:antrian_online_restu/src/bloc/register_bloc.dart';
import 'package:antrian_online_restu/src/bloc/token_bloc.dart';
import 'package:antrian_online_restu/src/common/source/color_style.dart';
import 'package:antrian_online_restu/src/common/source/size_config.dart';
import 'package:antrian_online_restu/src/common/widget/dialog_widget.dart';
import 'package:antrian_online_restu/src/common/widget/dialog_loading_widget.dart';
import 'package:antrian_online_restu/src/common/widget/text_input_auth_widget.dart';
import 'package:antrian_online_restu/src/model/login_model.dart';
import 'package:antrian_online_restu/src/model/register_model.dart';
import 'package:antrian_online_restu/src/model/token_model.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  LoginBloc _loginBloc = LoginBloc();
  TokenBloc _tokenBloc = TokenBloc();
  RegisterBloc _registerBloc = RegisterBloc();
  bool _isVisible = true;
  bool _isVisibleLogin = true;
  bool _isStreamResponse = false;
  bool _isStreamResponseRegister = false;

  bool _login = true;
  final ScrollController _scrollCon = ScrollController();
  final TextEditingController _emailLoginCon = TextEditingController();
  final TextEditingController _passLoginCon = TextEditingController();
  final TextEditingController _namaCon = TextEditingController();
  final TextEditingController _tempatLahirCon = TextEditingController();
  final TextEditingController _tanggalLahirCon = TextEditingController();
  final TextEditingController _agamaCon = TextEditingController();
  final TextEditingController _jenisKelaminCon = TextEditingController();
  final TextEditingController _alamatCon = TextEditingController();
  final TextEditingController _kontakCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _ulangiPassCon = TextEditingController();

  final FocusNode _emailLoginFocus = FocusNode();
  final FocusNode _passLoginFocus = FocusNode();
  final FocusNode _namaFocus = FocusNode();
  final FocusNode _tempatLahirFocus = FocusNode();
  final FocusNode _tanggalLahirFocus = FocusNode();
  final FocusNode _agamaFocus = FocusNode();
  final FocusNode _jenisKelaminFocus = FocusNode();
  final FocusNode _alamatFocus = FocusNode();
  final FocusNode _kontakFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _ulangiPassFocus = FocusNode();

  void _loginNow() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _tokenBloc.getToken();
    setState(() {
      _isStreamResponse = true;
    });
  }

  void _registerNow() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _tokenBloc.getToken();
    _registerBloc.register();
    setState(() {
      _isStreamResponseRegister = true;
    });
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    _emailLoginCon.dispose();
    _passLoginCon.dispose();
    _namaCon.dispose();
    _tempatLahirCon.dispose();
    _tanggalLahirCon.dispose();
    _agamaCon.dispose();
    _jenisKelaminCon.dispose();
    _alamatCon.dispose();
    _kontakCon.dispose();
    _emailCon.dispose();
    _passwordCon.dispose();
    _ulangiPassCon.dispose();
    _emailLoginFocus.dispose();
    _passLoginFocus.dispose();
    _namaFocus.dispose();
    _tempatLahirFocus.dispose();
    _tanggalLahirFocus.dispose();
    _agamaFocus.dispose();
    _jenisKelaminFocus.dispose();
    _alamatFocus.dispose();
    _kontakFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _ulangiPassFocus.dispose();
    _loginBloc.dispose();
    _registerBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Hero(
                      tag: 'logoHero',
                      child: Container(
                          width: SizeConfig.blockSizeHorizontal * 70,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/restu_logo.png'),
                            ),
                          )),
                    ),
                  ),
                ),
                Expanded(
                  flex: _login ? 1 : 6,
                  child: Scrollbar(
                    controller: _scrollCon,
                    thumbVisibility: _login ? false : true,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      controller: _scrollCon,
                      child: Column(
                        children: [
                          _login
                              ? _loginSession(context)
                              : _registerSession(context),
                          Row(
                            children: [
                              _loginButtonStream(context),
                              _registerButtonStream(context),
                            ],
                          ),
                          SizedBox(
                            height: 42.0,
                          ),
                          _login
                              ? Container(
                                  width: SizeConfig.blockSizeHorizontal * 40,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Lupa password?',
                                      style: TextStyle(
                                          color: Colors.grey[200],
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildStreamResponse(context),
        ],
      ),
    );
  }

  Widget _registerButtonStream(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _registerBloc.submitStream,
      builder: (context, snapshot) {
        return Expanded(
          child: Container(
            height: 42.0,
            child: TextButton(
              onPressed: _login
                  ? () {
                      setState(() {
                        _login = false;
                        _isStreamResponse = false;
                      });
                    }
                  : snapshot.hasData
                      ? _registerNow
                      : null,
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                disabledBackgroundColor: Colors.yellow[100],
                disabledForegroundColor: Colors.grey[300],
                backgroundColor: _login ? Colors.transparent : Colors.yellow,
                foregroundColor: _login ? Colors.white : Colors.black,
              ),
              child: Text(
                'REGISTER',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _loginButtonStream(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _loginBloc.submitStream,
      builder: (context, snapshot) {
        return Expanded(
          child: Container(
            height: 42.0,
            child: TextButton(
              onPressed: _login
                  ? snapshot.hasData
                      ? _loginNow
                      : null
                  : () {
                      setState(() {
                        _login = true;
                        _isStreamResponseRegister = false;
                      });
                    },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                disabledBackgroundColor: Colors.yellow[100],
                disabledForegroundColor: Colors.grey[300],
                backgroundColor: _login ? Colors.yellow : Colors.transparent,
                foregroundColor: _login ? Colors.black : Colors.white,
              ),
              child: Text(
                'LOGIN',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _loginSession(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 22.0,
        ),
        TextInputAuthWidget(
          blocStream: _loginBloc.emailStream,
          blocSink: _loginBloc.emailSink,
          controller: _emailLoginCon,
          focus: _emailLoginFocus,
          hint: 'Email Address',
          icon: Icons.email,
          textInputType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(
          height: 22.0,
        ),
        TextInputAuthWidget(
          blocStream: _loginBloc.passwordStream,
          blocSink: _loginBloc.passwordSink,
          controller: _passLoginCon,
          focus: _passLoginFocus,
          hint: 'Password',
          icon: Icons.lock,
          textInputType: TextInputType.text,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.done,
          iconSuffix: IconButton(
            onPressed: () {
              if (_isVisibleLogin) {
                setState(() {
                  _isVisibleLogin = false;
                });
              } else {
                setState(() {
                  _isVisibleLogin = true;
                });
              }
            },
            icon: _isVisibleLogin
                ? Icon(
                    Icons.visibility,
                    color: Colors.grey[100],
                  )
                : Icon(
                    Icons.visibility_off,
                    color: Colors.grey[100],
                  ),
          ),
          isPassword: _isVisibleLogin,
        ),
        SizedBox(
          height: 52.0,
        ),
      ],
    );
  }

  Widget _registerSession(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 22.0,
        ),
        TextInputAuthWidget(
          blocStream: _registerBloc.namaStream,
          blocSink: _registerBloc.namaSink,
          controller: _namaCon,
          focus: _namaFocus,
          hint: 'Nama',
          icon: Icons.person,
        ),
        SizedBox(
          height: 22.0,
        ),
        TextInputAuthWidget(
          blocStream: _registerBloc.tempatLahirStream,
          blocSink: _registerBloc.tempatLahirSink,
          controller: _tempatLahirCon,
          focus: _tempatLahirFocus,
          hint: 'Tempat lahir',
          icon: Icons.person_pin_circle,
        ),
        SizedBox(
          height: 22.0,
        ),
        TextInputAuthWidget(
          blocStream: _registerBloc.tanggalLahirStream,
          blocSink: _registerBloc.tanggalLahirSink,
          controller: _tanggalLahirCon,
          focus: _tanggalLahirFocus,
          isDate: true,
          hint: 'Tanggal lahir',
          icon: Icons.calendar_today_outlined,
        ),
        SizedBox(
          height: 22.0,
        ),
        TextInputAuthWidget(
          blocStream: _registerBloc.agamaStream,
          blocSink: _registerBloc.agamaSink,
          controller: _agamaCon,
          focus: _agamaFocus,
          hint: 'Agama',
          icon: Icons.hourglass_empty,
          isAgama: true,
        ),
        SizedBox(
          height: 22.0,
        ),
        TextInputAuthWidget(
          blocStream: _registerBloc.genderStream,
          blocSink: _registerBloc.genderSink,
          controller: _jenisKelaminCon,
          focus: _jenisKelaminFocus,
          hint: 'Jenis kelamin',
          icon: Icons.supervised_user_circle,
          isJenisKelamin: true,
        ),
        SizedBox(
          height: 22.0,
        ),
        TextInputAuthWidget(
          blocStream: _registerBloc.alamatStream,
          blocSink: _registerBloc.alamatSink,
          controller: _alamatCon,
          focus: _alamatFocus,
          hint: 'Alamat',
          icon: Icons.location_city,
        ),
        SizedBox(
          height: 22.0,
        ),
        TextInputAuthWidget(
          blocStream: _registerBloc.kontakStream,
          blocSink: _registerBloc.kontakSink,
          controller: _kontakCon,
          focus: _kontakFocus,
          hint: 'Nomor Kontak',
          icon: Icons.phone_android,
          textInputType: TextInputType.phone,
        ),
        SizedBox(
          height: 22.0,
        ),
        TextInputAuthWidget(
          blocStream: _registerBloc.emailStream,
          blocSink: _registerBloc.emailSink,
          controller: _emailCon,
          focus: _emailFocus,
          hint: 'Alamat email',
          icon: Icons.email,
          textInputType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
        ),
        SizedBox(
          height: 22.0,
        ),
        TextInputAuthWidget(
          blocStream: _registerBloc.passwordStream,
          blocSink: _registerBloc.passwordSink,
          controller: _passwordCon,
          focus: _passwordFocus,
          hint: 'Password',
          icon: Icons.lock,
          textCapitalization: TextCapitalization.none,
          iconSuffix: IconButton(
            onPressed: () {
              if (_isVisible) {
                setState(() {
                  _isVisible = false;
                });
              } else {
                setState(() {
                  _isVisible = true;
                });
              }
            },
            icon: _isVisible
                ? Icon(
                    Icons.visibility,
                    color: Colors.grey,
                  )
                : Icon(
                    Icons.visibility_off,
                    color: Colors.grey,
                  ),
          ),
          onSubmitted: () =>
              _fieldFocusChange(context, _passwordFocus, _ulangiPassFocus),
          isPassword: _isVisible,
        ),
        SizedBox(
          height: 22.0,
        ),
        TextInputAuthWidget(
          blocStream: _registerBloc.ulangiPassStream,
          blocSink: _registerBloc.ulangiPassSink,
          controller: _ulangiPassCon,
          focus: _ulangiPassFocus,
          hint: 'Ulangi password',
          icon: Icons.lock,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.none,
          isPassword: _isVisible,
        ),
        SizedBox(
          height: 52.0,
        ),
      ],
    );
  }

  Widget _buildStreamResponse(BuildContext context) {
    if (_isStreamResponse) {
      return StreamBuilder<ApiResponse<ResponseTokenModel>>(
        stream: _tokenBloc.tokenStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return DialogLoadingWidget(
                  message: snapshot.data!.message,
                );
              case Status.ERROR:
                return DialogWidget(
                  message: snapshot.data!.message,
                  close: () {
                    setState(() {
                      _isStreamResponse = false;
                    });
                  },
                );
              case Status.COMPLETED:
                return LoginStream(
                  bloc: _loginBloc,
                  close: () {
                    setState(() {
                      _isStreamResponse = false;
                    });
                  },
                );
            }
          }
          return Container();
        },
      );
    } else if (_isStreamResponseRegister) {
      return StreamBuilder<ApiResponse<ResponseRegisterModel>>(
        stream: _registerBloc.registreStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return DialogLoadingWidget(
                  message: snapshot.data!.message,
                );
              case Status.ERROR:
                return DialogWidget(
                  message: snapshot.data!.message,
                  close: () {
                    setState(() {
                      _isStreamResponseRegister = false;
                    });
                  },
                );
              case Status.COMPLETED:
                if (!snapshot.data!.data!.success!) {
                  return DialogWidget(
                    message: snapshot.data!.data!.message,
                    close: () {
                      setState(() {
                        _isStreamResponseRegister = false;
                      });
                    },
                  );
                }
                return DialogWidget(
                  message: snapshot.data!.data!.message,
                  close: () {
                    setState(() {
                      _isStreamResponseRegister = false;
                    });
                  },
                );
            }
          }
          return Container();
        },
      );
    }
    return Container();
  }
}

class LoginStream extends StatefulWidget {
  final LoginBloc bloc;
  final VoidCallback close;

  const LoginStream({
    Key? key,
    required this.bloc,
    required this.close,
  }) : super(key: key);

  @override
  _LoginStreamState createState() => _LoginStreamState();
}

class _LoginStreamState extends State<LoginStream> {
  @override
  void initState() {
    super.initState();
    widget.bloc.login();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseLoginModel>>(
      stream: widget.bloc.loginStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return DialogLoadingWidget(
                message: snapshot.data!.message,
              );
            case Status.ERROR:
              return DialogWidget(
                message: snapshot.data!.message,
                close: widget.close,
              );
            case Status.COMPLETED:
              if (!snapshot.data!.data!.success!) {
                return DialogWidget(
                  message: snapshot.data!.data!.message,
                  close: widget.close,
                );
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                authBloc.openSession(
                  '${snapshot.data!.data!.data!.id}',
                  '${snapshot.data!.data!.data!.nama}',
                  '${snapshot.data!.data!.data!.levelAkses}',
                  '${snapshot.data!.data!.data!.posAntrian}',
                );
              });
              break;
          }
        }
        return Container();
      },
    );
  }
}
