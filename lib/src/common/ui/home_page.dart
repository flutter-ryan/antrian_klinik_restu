import 'package:antrian_online_restu/src/bloc/auth_bloc.dart';
import 'package:antrian_online_restu/src/bloc/token_bloc.dart';
import 'package:antrian_online_restu/src/common/source/color_style.dart';
import 'package:antrian_online_restu/src/common/source/size_config.dart';
import 'package:antrian_online_restu/src/common/source/transition/slide_left_transition.dart';
import 'package:antrian_online_restu/src/common/ui/pertanyaan_page.dart';
import 'package:antrian_online_restu/src/common/widget/antrian_berjalan.dart';
import 'package:antrian_online_restu/src/common/widget/loading_widget.dart';
import 'package:antrian_online_restu/src/common/widget/menu_body.dart';
import 'package:antrian_online_restu/src/common/widget/menu_petugas_widget.dart';
import 'package:antrian_online_restu/src/common/widget/server_error_widget.dart';
import 'package:antrian_online_restu/src/model/token_model.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CollectionReference? firestore;
  String? level;
  String? nama;
  TokenBloc _tokenBloc = TokenBloc();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _cekLevel();
    _tokenBloc.getToken();
    initFirebase();
  }

  void initFirebase() async {
    try {
      await Firebase.initializeApp();
      firestore = FirebaseFirestore.instance.collection('restu');
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void choiceAction(String choice) async {
    if (choice == Constants.SignOut) {
      authBloc.closedSession();
    }
  }

  void _cekLevel() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? level = _prefs.getString('level');
    String? nama = _prefs.getString('nama');
    setState(() {
      this.level = level;
      this.nama = nama;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          title: Row(
            children: [
              Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                width: 12.0,
              ),
              Text('RESTU'),
            ],
          ),
          actions: [
            level != 'Pasien'
                ? _initialized
                    ? _buildDataFirestore(context)
                    : Container()
                : Container(),
            PopupMenuButton<String>(
              onSelected: choiceAction,
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 28.0,
              ),
              itemBuilder: (context) {
                return Constants.choices
                    .map(
                      (choice) => PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      ),
                    )
                    .toList();
              },
            ),
          ],
        ),
        body: StreamBuilder<ApiResponse<ResponseTokenModel>>(
          stream: _tokenBloc.tokenStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return LoadingWidget(
                    message: snapshot.data!.message,
                  );
                case Status.ERROR:
                  return ServerErrorWidget(
                    message: snapshot.data!.message,
                    reload: () {
                      _tokenBloc.getToken();
                      setState(() {});
                    },
                  );
                case Status.COMPLETED:
                  if (level == null) {
                    return Container();
                  }

                  if (level == 'Pasien') {
                    return Column(
                      children: [
                        Antrianberjalan(),
                        SizedBox(
                          height: 22.0,
                        ),
                        Flexible(
                          child: Menubody(),
                        ),
                      ],
                    );
                  }
                  return MenuPetugasWidget();
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildDataFirestore(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore!.where('answer', isEqualTo: '').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitSpinningCircle(
            size: 22,
            color: Colors.grey[300],
          );
        }

        return IconButton(
          icon: Badge(
            badgeContent: Text(
              '${snapshot.data!.docs.length}',
              style: TextStyle(color: Colors.white),
            ),
            showBadge: snapshot.data!.docs.length > 0 ? true : false,
            child: Icon(Icons.chat_bubble_outline_rounded),
          ),
          onPressed: () {
            Navigator.push(
              context,
              SlideLeftRoute(
                page: PertanyaanAdminPage(),
              ),
            );
          },
        );
      },
    );
  }
}

class Constants {
  static const String SignOut = 'Sign out';

  static const List<String> choices = <String>[SignOut];
}
