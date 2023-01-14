import 'package:antrian_online_restu/src/bloc/antrian_petugas_bloc.dart';
import 'package:antrian_online_restu/src/bloc/buka_loket_bloc.dart';
import 'package:antrian_online_restu/src/bloc/loket_bloc.dart';
import 'package:antrian_online_restu/src/bloc/panggil_antrian_bloc.dart';
import 'package:antrian_online_restu/src/bloc/status_loket_bloc.dart';
import 'package:antrian_online_restu/src/bloc/token_bloc.dart';
import 'package:antrian_online_restu/src/bloc/tutup_loket_bloc.dart';
import 'package:antrian_online_restu/src/common/source/color_style.dart';
import 'package:antrian_online_restu/src/common/source/size_config.dart';
import 'package:antrian_online_restu/src/common/widget/error_response_widget.dart';
import 'package:antrian_online_restu/src/common/widget/loading_response_widget.dart';
import 'package:antrian_online_restu/src/common/widget/loading_widget.dart';
import 'package:antrian_online_restu/src/model/antrian_petugas_model.dart';
import 'package:antrian_online_restu/src/model/loket_model.dart';
import 'package:antrian_online_restu/src/model/panggil_antrian_model.dart';
import 'package:antrian_online_restu/src/model/status_loket_model.dart';
import 'package:antrian_online_restu/src/model/token_model.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPetugasWidget extends StatefulWidget {
  @override
  _MenuPetugasWidgetState createState() => _MenuPetugasWidgetState();
}

class _MenuPetugasWidgetState extends State<MenuPetugasWidget> {
  TokenBloc _tokenBloc = TokenBloc();
  BukaLoketBloc _bukaLoketBloc = BukaLoketBloc();
  TutupLoketBloc _tutupLoketBloc = TutupLoketBloc();
  StatusLoketBloc _statusLoketBloc = StatusLoketBloc();
  TextEditingController _loketCon = TextEditingController();
  String? _idPilih;
  String? nama, level, pos, idRef;
  bool _streamStatus = false;
  bool _streamPanggilAntrian = false;

  @override
  void initState() {
    super.initState();
    _tokenBloc.getToken();
    getProfile();
  }

  getProfile() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = _prefs.getString('nama');
      level = _prefs.getString('level');
      pos = _prefs.getString('pos');
    });
  }

  void _showLoket(BuildContext context) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) => ModalLoket(
        pilih: (String id, String deskripsi) => _pilih(id, deskripsi),
        idPilih: '${_idPilih}',
      ),
    );
  }

  void _pilih(String id, String deskripsi) {
    _statusLoketBloc.loketSink.add(id);
    _statusLoketBloc.posSink.add('${pos}');
    _statusLoketBloc.getStatusLoket();
    setState(() {
      _streamStatus = true;
      _loketCon.text = deskripsi;
      _idPilih = id;
    });
  }

  void _loketStatus(int loket) {
    if (loket == 1) {
      _bukaLoketBloc.posSink.add('$pos');
      _bukaLoketBloc.loketSink.add('$_idPilih');
      _bukaLoketBloc.bukaLoket();
    } else {
      _tutupLoketBloc.posSink.add('$pos');
      _tutupLoketBloc.loketSink.add('$_idPilih');
      _tutupLoketBloc.tutupLoket();
    }
    Future.delayed(Duration(milliseconds: 200), () {
      _statusLoketBloc.getStatusLoket();
      setState(() {});
    });
  }

  void _panggilAntrian(String id) {
    if (_idPilih != null) {
      setState(() {
        _streamPanggilAntrian = true;
        idRef = id;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            title: Text('Warning'),
            content: Text('Anda belum memilih loket'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Tutup'),
              ),
            ],
          );
        },
      );
    }
  }

  void _reload() {
    _tokenBloc.getToken();
    setState(() {
      _streamPanggilAntrian = false;
    });
  }

  @override
  void dispose() {
    _loketCon.dispose();
    _tokenBloc.dispose();
    _statusLoketBloc.dispose();
    _bukaLoketBloc.dispose();
    _tutupLoketBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var top = MediaQuery.of(context).padding.top;
    return Column(
      children: [
        SizedBox(
          height: 8.0,
        ),
        Column(
          children: [
            SizedBox(
              height: top,
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama == null ? 'Nama Petugas' : '$nama',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        level == null ? 'Level Petugas' : '$level',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage('assets/images/profile.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 18.0,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 22.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              child: TextField(
                                controller: _loketCon,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  border: OutlineInputBorder(),
                                  hintText: 'Pilih Loket',
                                  suffixIcon: TextButton(
                                    onPressed: () => _showLoket(context),
                                    child: Text(
                                      'GANTI',
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                  ),
                                ),
                                readOnly: true,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          _buildStreamStatusLoket(context),
                        ],
                      ),
                    ),
                    _streamListAntrianPetugas(context),
                  ],
                ),
                _streamPanggilAntrian
                    ? StreamPanggilAntrian(
                        idRef: idRef,
                        pos: pos,
                        loket: _idPilih,
                        reload: _reload,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreamStatusLoket(BuildContext context) {
    if (_streamStatus) {
      return StreamBuilder<ApiResponse<ResponseStatusLoketModel>>(
        stream: _statusLoketBloc.statusLoketStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return Container(
                  height: 47.0,
                  child: TextButton(
                    onPressed: null,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      backgroundColor: Colors.greenAccent[700],
                      disabledBackgroundColor: Colors.green[300],
                      disabledForegroundColor: Colors.grey[300],
                      foregroundColor: Colors.white,
                    ),
                    child: SpinKitThreeBounce(
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                );
              case Status.ERROR:
                return Container(
                  height: 47.0,
                  child: TextButton(
                    onPressed: null,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      backgroundColor: Colors.greenAccent[700],
                      disabledBackgroundColor: Colors.green[300],
                      disabledForegroundColor: Colors.grey[300],
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Error'),
                  ),
                );
              case Status.COMPLETED:
                print(snapshot.data!.data!.success);
                if (!snapshot.data!.data!.success!) {
                  return Container(
                    height: 47.0,
                    child: TextButton(
                      onPressed: () => _loketStatus(1),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock,
                            size: 17.0,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text('Buka Loket'),
                        ],
                      ),
                    ),
                  );
                }
                return Container(
                  height: 47.0,
                  child: TextButton(
                    onPressed: () => _loketStatus(2),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock_open,
                          size: 17.0,
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text('Tutup Loket'),
                      ],
                    ),
                  ),
                );
            }
          }
          return Container();
        },
      );
    }
    return Container(
      height: 47.0,
      child: TextButton(
        onPressed: null,
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          backgroundColor: Colors.red,
          disabledBackgroundColor: Colors.red[300],
          disabledForegroundColor: Colors.grey[300],
          foregroundColor: Colors.white,
        ),
        child: Text('Buka Loket'),
      ),
    );
  }

  Widget _streamListAntrianPetugas(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseTokenModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Expanded(
                child: LoadingResponseWidget(
                  message: snapshot.data!.message,
                ),
              );
            case Status.ERROR:
              return Expanded(
                child: ErrorResponseWidget(
                  message: snapshot.data!.message,
                  reload: () {
                    _tokenBloc.getToken();
                    setState(() {});
                  },
                ),
              );
            case Status.COMPLETED:
              return ListAntrianPetugas(
                panggil: (String id) => _panggilAntrian(id),
              );
          }
        }
        return Container();
      },
    );
  }
}

class ModalLoket extends StatefulWidget {
  final Function pilih;
  final String idPilih;

  const ModalLoket({
    Key? key,
    required this.pilih,
    required this.idPilih,
  }) : super(key: key);

  @override
  _ModalLoketState createState() => _ModalLoketState();
}

class _ModalLoketState extends State<ModalLoket> {
  TokenBloc _tokenBloc = TokenBloc();

  @override
  void initState() {
    super.initState();
    _tokenBloc.getToken();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.0),
      constraints: BoxConstraints(
        minHeight: SizeConfig.blockSizeVertical * 25,
        maxHeight: SizeConfig.blockSizeVertical * 70,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 22.0,
          ),
          Text(
            'Pilih Loket',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 22.0,
          ),
          Divider(
            height: 0.0,
          ),
          StreamBuilder<ApiResponse<ResponseTokenModel>>(
            stream: _tokenBloc.tokenStream,
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
                        _tokenBloc.getToken();
                        setState(() {});
                      },
                    );
                  case Status.COMPLETED:
                    return ListLoket(
                      pilih: (String id, String deskripsi) =>
                          widget.pilih(id, deskripsi),
                      idPilih: widget.idPilih,
                    );
                }
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}

class ListLoket extends StatefulWidget {
  final Function pilih;
  final String idPilih;

  const ListLoket({
    Key? key,
    required this.pilih,
    required this.idPilih,
  }) : super(key: key);
  @override
  _ListLoketState createState() => _ListLoketState();
}

class _ListLoketState extends State<ListLoket> {
  LoketBloc _loketBloc = LoketBloc();

  @override
  void initState() {
    super.initState();
    _loketBloc.getLoket();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<LoketModel>>(
      stream: _loketBloc.loketStream,
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
                  _loketBloc.getLoket();
                  setState(() {});
                },
              );
            case Status.COMPLETED:
              return Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.data!.data!.length,
                  itemBuilder: (context, int i) {
                    var data = snapshot.data!.data!.data![i];
                    return ListTile(
                      onTap: () {
                        widget.pilih(data.id, data.deskripsi);
                        Navigator.pop(context);
                      },
                      leading: Container(
                        width: 40,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/counter.png'))),
                      ),
                      title: Text('${data.deskripsi}'),
                      trailing:
                          widget.idPilih.isEmpty && widget.idPilih == data.id
                              ? Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : null,
                    );
                  },
                ),
              );
          }
        }
        return Container();
      },
    );
  }
}

class ListAntrianPetugas extends StatefulWidget {
  final Function? panggil;

  const ListAntrianPetugas({
    Key? key,
    this.panggil,
  }) : super(key: key);

  @override
  _ListAntrianPetugasState createState() => _ListAntrianPetugasState();
}

class _ListAntrianPetugasState extends State<ListAntrianPetugas> {
  AntrianPetugasBloc _antrianPetugasBloc = AntrianPetugasBloc();

  @override
  void initState() {
    super.initState();
    _antrianPetugasBloc.getAntrianPetugas();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseAntrianPetugasModel>>(
      stream: _antrianPetugasBloc.antrianPetugasStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Expanded(
                  child: LoadingResponseWidget(
                message: snapshot.data!.message,
              ));
            case Status.ERROR:
              return Expanded(
                  child: ErrorResponseWidget(
                message: snapshot.data!.message,
                reload: () {
                  _antrianPetugasBloc.getAntrianPetugas();
                  setState(() {});
                },
              ));
            case Status.COMPLETED:
              if (!snapshot.data!.data!.success!) {
                return Expanded(
                  child: Center(
                    child: Text(
                      '${snapshot.data!.data!.message}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  itemCount: snapshot.data!.data!.data!.length,
                  itemBuilder: (context, int i) {
                    var antrian = snapshot.data!.data!.data![i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Card(
                        elevation: 4.0,
                        color:
                            antrian.status == '2' ? Colors.white : Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: ListTile(
                          onTap: () => widget.panggil!(antrian.id),
                          leading: Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26, blurRadius: 2.0)
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${antrian.noAntrian}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ),
                          ),
                          title: Text(
                            '${antrian.nama} - ${antrian.tanggal}',
                            style: TextStyle(
                                color: antrian.status == '2'
                                    ? Colors.black
                                    : Colors.white),
                          ),
                          subtitle: Text(
                            '${antrian.ruangan} - ${antrian.carabayar}\n${antrian.statusAntrian}',
                            style: TextStyle(
                                color: antrian.status == '2'
                                    ? Colors.black
                                    : Colors.white),
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    );
                  },
                ),
              );
          }
        }
        return Container();
      },
    );
  }
}

class StreamPanggilAntrian extends StatefulWidget {
  final String? pos;
  final String? loket;
  final String? idRef;
  final VoidCallback? reload;

  const StreamPanggilAntrian({
    Key? key,
    this.pos,
    this.loket,
    this.idRef,
    this.reload,
  }) : super(key: key);

  @override
  _StreamPanggilAntrianState createState() => _StreamPanggilAntrianState();
}

class _StreamPanggilAntrianState extends State<StreamPanggilAntrian> {
  TokenBloc _tokenBloc = TokenBloc();

  @override
  void initState() {
    super.initState();
    _tokenBloc.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: StreamBuilder<ApiResponse<ResponseTokenModel>>(
        stream: _tokenBloc.tokenStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return LoadingWidget(
                  message: snapshot.data!.message,
                );
              case Status.ERROR:
                return Container();
              case Status.COMPLETED:
                return ResponseStreamPanggilAntrian(
                  pos: '${widget.pos}',
                  loket: '${widget.loket}',
                  idRef: '${widget.idRef}',
                  reload: () => widget.reload,
                );
            }
          }
          return Container();
        },
      ),
    );
  }
}

class ResponseStreamPanggilAntrian extends StatefulWidget {
  final String? pos;
  final String? loket;
  final String? idRef;
  final Function? reload;

  const ResponseStreamPanggilAntrian({
    Key? key,
    this.pos,
    this.loket,
    this.idRef,
    this.reload,
  }) : super(key: key);

  @override
  _ResponseStreamPanggilAntrianState createState() =>
      _ResponseStreamPanggilAntrianState();
}

class _ResponseStreamPanggilAntrianState
    extends State<ResponseStreamPanggilAntrian> {
  PanggilAntrianBloc _panggilAntrianBloc = PanggilAntrianBloc();

  @override
  void initState() {
    super.initState();
    panggil();
  }

  void panggil() {
    _panggilAntrianBloc.posSink.add('${widget.pos}');
    _panggilAntrianBloc.loketSink.add('${widget.loket}');
    _panggilAntrianBloc.nomorSink.add('${widget.idRef}');
    _panggilAntrianBloc.panggilAntrian();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<ApiResponse<ResponsePanggilAntrianModel>>(
      stream: _panggilAntrianBloc.panggilAntrianStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return LoadingWidget(
                message: snapshot.data!.message,
              );
            case Status.ERROR:
              return Container(
                child: Text('${snapshot.data!.message}'),
              );
            case Status.COMPLETED:
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text('Sukses'),
                content: Text('${snapshot.data!.data!.message}'),
                actions: [
                  TextButton(
                    onPressed: () => widget.reload,
                    child: Text('Tutup'),
                  )
                ],
              );
          }
        }
        return Container();
      },
    );
  }
}
