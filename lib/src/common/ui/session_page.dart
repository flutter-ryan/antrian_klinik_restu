import 'package:antrian_online_restu/src/bloc/auth_bloc.dart';
import 'package:antrian_online_restu/src/common/ui/home_page.dart';
import 'package:antrian_online_restu/src/common/ui/login_page.dart';
import 'package:flutter/material.dart';

class Sessionpage extends StatefulWidget {
  @override
  _SessionpageState createState() => _SessionpageState();
}

class _SessionpageState extends State<Sessionpage> {
  @override
  void initState() {
    super.initState();
    authBloc.restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: authBloc.isSessionValid,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return Homepage();
        }
        return Loginpage();
      },
    );
  }
}
