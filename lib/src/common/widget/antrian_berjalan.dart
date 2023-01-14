import 'package:antrian_online_restu/src/bloc/antrian_berjalan_bloc.dart';
import 'package:antrian_online_restu/src/bloc/token_bloc.dart';
import 'package:antrian_online_restu/src/common/source/size_config.dart';
import 'package:antrian_online_restu/src/common/widget/loading_response_widget.dart';
import 'package:antrian_online_restu/src/model/antrian_berjalan_model.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:flutter/material.dart';

class Antrianberjalan extends StatefulWidget {
  @override
  _AntrianberjalanState createState() => _AntrianberjalanState();
}

class _AntrianberjalanState extends State<Antrianberjalan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.blockSizeVertical * 25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 8,
          ),
          Expanded(
            child: Antrian(),
          ),
        ],
      ),
    );
  }
}

class Antrian extends StatefulWidget {
  @override
  _AntrianState createState() => _AntrianState();
}

class _AntrianState extends State<Antrian> {
  AntrianBerjalanBloc _antrianBerjalanBloc = AntrianBerjalanBloc();
  TokenBloc _tokenBloc = TokenBloc();

  @override
  void initState() {
    super.initState();
    _antrianBerjalanBloc.getAntrianBerjalan();
  }

  void _refresh() {
    _antrianBerjalanBloc.getAntrianBerjalan();
    setState(() {});
  }

  @override
  void dispose() {
    _antrianBerjalanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<ApiResponse<AntrianBerjalanModel>>(
      stream: _antrianBerjalanBloc.antrianBerjalanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18.0),
                  width: SizeConfig.blockSizeHorizontal * 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                  ),
                  child: LoadingResponseWidget(
                    message: snapshot.data!.message,
                  ),
                ),
              );
            case Status.ERROR:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${snapshot.data!.message}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _tokenBloc.getToken();
                        _antrianBerjalanBloc.getAntrianBerjalan();
                        setState(() {});
                      },
                      child: Text('Coba lagi'),
                    ),
                  ],
                ),
              );
            case Status.COMPLETED:
              if (!snapshot.data!.data!.success!) {
                return Center(
                  child: Text(
                    '${snapshot.data!.data!.message}',
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Antrian berjalan',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: _refresh,
                          child: Row(
                            children: [
                              Icon(
                                Icons.refresh,
                                size: 20.0,
                                color: Colors.orange[300],
                              ),
                              SizedBox(
                                width: 2.0,
                              ),
                              Text(
                                'Refresh',
                                style: TextStyle(
                                  color: Colors.orange[300],
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding:
                          EdgeInsets.only(left: 18.0, top: 8.0, bottom: 8.0),
                      itemCount: snapshot.data!.data!.data!.length,
                      itemBuilder: (context, int i) {
                        var data = snapshot.data!.data!.data![i];
                        return Center(
                          child: Container(
                            padding: EdgeInsets.all(18.0),
                            margin: EdgeInsets.only(right: 18.0),
                            height: double.infinity,
                            width: SizeConfig.blockSizeHorizontal * 35,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 4.0,
                                    offset: Offset(3.0, 3.0),
                                  )
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${data.deskripsi}',
                                ),
                                Text(
                                  '${data.nomor}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 7),
                                ),
                                Text(
                                  'Status: ${data.statusLoket}',
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
