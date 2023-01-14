import 'package:antrian_online_restu/src/bloc/cara_bayar_bloc.dart';
import 'package:antrian_online_restu/src/bloc/poli_bloc.dart';
import 'package:antrian_online_restu/src/bloc/token_bloc.dart';
import 'package:antrian_online_restu/src/common/source/color_style.dart';
import 'package:antrian_online_restu/src/common/source/size_config.dart';
import 'package:antrian_online_restu/src/common/widget/custom_dialog_form..dart';
import 'package:antrian_online_restu/src/common/widget/dialog_form_daftar.dart';
import 'package:antrian_online_restu/src/common/widget/error_response_widget.dart';
import 'package:antrian_online_restu/src/common/widget/loading_response_widget.dart';
import 'package:antrian_online_restu/src/model/cara_bayar_model.dart';
import 'package:antrian_online_restu/src/model/poli_model.dart';
import 'package:antrian_online_restu/src/model/token_model.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menubody extends StatefulWidget {
  @override
  _MenubodyState createState() => _MenubodyState();
}

class _MenubodyState extends State<Menubody>
    with SingleTickerProviderStateMixin {
  bool _isSearch = false;

  late TabController _controllerTab;

  List<Tabchild> _listTab = [
    Tabchild(
      icon: 'assets/images/invoice.png',
      text: 'Tiket',
    ),
    Tabchild(
      icon: 'assets/images/home.png',
      text: 'Daftar',
    ),
    Tabchild(
      icon: 'assets/images/question.png',
      text: 'Q & A',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controllerTab =
        TabController(length: _listTab.length, vsync: this, initialIndex: 1);
    _tabListener();
  }

  void _tabListener() {
    _controllerTab.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _controllerTab,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.orange[300]!.withAlpha(100),
          ),
          tabs: _listTab,
        ),
        SizedBox(
          height: 15.0,
        ),
        Expanded(
          child: Container(
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 8.0,
                    offset: Offset(5.0, -2.0),
                  ),
                ],
              ),
              child: Container(
                child: TabBarView(
                  controller: _controllerTab,
                  children: [
                    TiketAntrianPage(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: _isSearch
                              ? TextField(
                                  decoration: InputDecoration(
                                    icon: InkWell(
                                      onTap: () =>
                                          setState(() => _isSearch = false),
                                      child: Icon(Icons.arrow_back),
                                    ),
                                    prefixIcon: Icon(Icons.search),
                                    hintText: 'Search',
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 22.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Pilih Poliklinik',
                                        style: TextStyle(
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  5.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isSearch = true;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.search,
                                            size:
                                                SizeConfig.blockSizeHorizontal *
                                                    6.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Expanded(
                          child: Listpoli(),
                        ),
                      ],
                    ),
                    PertanyaanPage(),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}

class Listpoli extends StatefulWidget {
  @override
  _ListpoliState createState() => _ListpoliState();
}

class _ListpoliState extends State<Listpoli> {
  PoliBloc _poliBloc = PoliBloc();
  TokenBloc _blocToken = TokenBloc();
  @override
  void initState() {
    super.initState();
    _poliBloc.getPoli();
  }

  void _showBottomCaraBayar(BuildContext context, String idRuangan) {
    _blocToken.getToken();
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return _streamToken(context, idRuangan);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<ApiResponse<PoliModel>>(
      stream: _poliBloc.poliStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return LoadingResponseWidget(
                message: snapshot.data!.message,
              );
            case Status.ERROR:
              return Center(
                child: ErrorResponseWidget(
                  message: snapshot.data!.message,
                  reload: () {
                    _blocToken.getToken();
                    _poliBloc.getPoli();
                    setState(() {});
                  },
                ),
              );
            case Status.COMPLETED:
              if (!snapshot.data!.data!.success!) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_off,
                        size: SizeConfig.blockSizeHorizontal * 20,
                        color: Colors.grey[300],
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        'Data Poliklinik tidak ditemukan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 18.0),
                itemCount: snapshot.data!.data!.data!.length,
                separatorBuilder: (context, int i) {
                  return Divider(
                    height: 0,
                  );
                },
                itemBuilder: (context, int i) {
                  var poli = snapshot.data!.data!.data![i];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.blue[100],
                      onTap: () => _showBottomCaraBayar(context, '${poli.id}'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: ListTile(
                          leading: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryColor,
                            ),
                            child: Center(
                              child: Text(
                                '${poli.posAntrian}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: SizeConfig.blockSizeHorizontal * 5,
                                ),
                              ),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '${poli.deskripsi}',
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
          }
        }
        return Container();
      },
    );
  }

  Widget _streamToken(BuildContext context, String idRuangan) {
    return Container(
      constraints: BoxConstraints(
        minHeight: SizeConfig.blockSizeVertical * 30,
      ),
      child: StreamBuilder<ApiResponse<ResponseTokenModel>>(
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
                return BodyModalBarCaraBayar(
                  idRuangan: idRuangan,
                );
            }
          }
          return Container();
        },
      ),
    );
  }
}

class Tabchild extends StatelessWidget {
  final String? icon;
  final String? text;

  const Tabchild({Key? key, this.icon, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 22.0,
            height: 22.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('$icon'),
              ),
            ),
          ),
          SizedBox(
            width: 12.0,
          ),
          Text(
            '$text',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class BodyModalBarCaraBayar extends StatefulWidget {
  final String idRuangan;

  const BodyModalBarCaraBayar({
    Key? key,
    required this.idRuangan,
  }) : super(key: key);

  @override
  _BodyModalBarCaraBayarState createState() => _BodyModalBarCaraBayarState();
}

class _BodyModalBarCaraBayarState extends State<BodyModalBarCaraBayar> {
  CaraBayarBloc _blocCaraBayar = CaraBayarBloc();

  @override
  void initState() {
    super.initState();
    _blocCaraBayar.getCaraBayar();
  }

  void _daftarAntrian(BuildContext context, String idCarabayar) {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => DialogFormDaftar(
        idCarabayar: idCarabayar,
        idRuangan: widget.idRuangan,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Text(
            'Cara Bayar',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
          ),
        ),
        Divider(
          height: 0.0,
        ),
        _streamCaraBayar(context),
      ],
    );
  }

  Widget _streamCaraBayar(BuildContext context) {
    return StreamBuilder<ApiResponse<CaraBayarModel>>(
      stream: _blocCaraBayar.caraBayarStream,
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
                  _blocCaraBayar.getCaraBayar();
                  setState(() {});
                },
              );
            case Status.COMPLETED:
              return ListView.separated(
                shrinkWrap: true,
                itemCount: snapshot.data!.data!.data!.length,
                separatorBuilder: (context, int index) {
                  return Divider(
                    height: 0.0,
                  );
                },
                itemBuilder: (context, int i) {
                  var data = snapshot.data!.data!.data![i];
                  return ListTile(
                    onTap: () => _daftarAntrian(context, '${data.id}'),
                    contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
                    title: Text('$data.deskripsi'),
                  );
                },
              );
          }
        }
        return Container();
      },
    );
  }
}

class TiketAntrianPage extends StatefulWidget {
  @override
  _TiketAntrianPageState createState() => _TiketAntrianPageState();
}

class _TiketAntrianPageState extends State<TiketAntrianPage> {
  bool isLoad = false;
  String? ruangan, caraBayar, nomor, tanggal;
  DateTime now = DateTime.now();
  DateFormat _format = DateFormat('EEEE, dd MMMM yyyy', 'ID');

  @override
  void initState() {
    super.initState();
    getInfoPendaftaran();
  }

  void getInfoPendaftaran() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoad = true;
      ruangan = _prefs.getString('ruangan');
      caraBayar = _prefs.getString('caraBayar');
      nomor = _prefs.getString('noAntrian');
      tanggal = _prefs.getString('tanggal');
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Center(
      child: isLoad
          ? ruangan == null
              ? Center(
                  child: Text(
                    'Anda tidak memiliki tiket antrian saat ini.',
                    style: TextStyle(
                        color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                )
              : ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  children: [
                    Text(
                      'Tunjukkan tiket ini pada petugas Kami',
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4.5),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 22.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 12.0,
                            offset: Offset(4.0, 4.0),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Tiket Antrian Anda',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4.8),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 22.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Nomor Antrian',
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4.5),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0),
                                  child: Text(
                                    '$nomor',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 9),
                                  ),
                                ),
                                Text(
                                  _format.format(
                                    DateTime.parse(tanggal!),
                                  ),
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4.5),
                                ),
                                Text(
                                  '$caraBayar',
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$ruangan',
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4.8,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitHourGlass(
                  color: Colors.grey[600]!,
                  size: 32.0,
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  'Please wait...',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
    );
  }
}

class PertanyaanPage extends StatefulWidget {
  @override
  _PertanyaanPageState createState() => _PertanyaanPageState();
}

class _PertanyaanPageState extends State<PertanyaanPage> {
  late DateFormat _format, _tanggal;
  late CollectionReference firestore;
  bool _initialized = false;
  bool _error = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _format = DateFormat('yyyy-MM-dd HH:mm:ss');
    _tanggal = DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id');
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
      setState(() {
        _error = true;
      });
    }
  }

  _ajukanPertanyaan() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialogForm(
        title: "Apa yang ingin Anda tanyakan?",
        description:
            "Pertanyaan Anda akan ditampilkan setelah dijawab oleh admin.",
        buttonText: 'Ajukan pertanyaan',
        submitForm: (String input, GlobalKey<FormState> formKey) =>
            _pertanyaan(input, formKey),
      ),
    );
  }

  void _pertanyaan(String input, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      Navigator.pop(context);
      setState(() {
        _isLoading = true;
      });
      try {
        await firestore.doc(Timestamp.now().nanoseconds.toString()).set({
          'question': input,
          'answer': '',
          'date': _format.format(DateTime.now()),
        });
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _error = true;
        });
      }
      showDialog(
        context: context,
        builder: (context) => DialogQna(
          isError: _error,
          isloading: _isLoading,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container();
    }
    if (!_initialized) {
      return CircularProgressIndicator();
    }
    return _loadPageBody(context);
  }

  Widget _loadPageBody(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: firestore.where('answer', isNotEqualTo: '').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding:
                    EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 10),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: SizeConfig.blockSizeVertical * 20,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/server_error.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18.0,
                        ),
                        Text(
                          'Server error...please try again later',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                              fontSize: SizeConfig.blockSizeHorizontal * 4.5),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingResponseWidget(
                  message: 'Memuat...',
                ),
              );
            }
            if (snapshot.data!.docs.length == 0) {
              return Padding(
                padding:
                    EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 10),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: SizeConfig.blockSizeVertical * 20,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/server_error.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18.0,
                        ),
                        Text(
                          'Data QnA tidak tersedia',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                              fontSize: SizeConfig.blockSizeHorizontal * 4.5),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              separatorBuilder: (context, int i) {
                return Divider(
                  height: 28,
                  color: Colors.black38,
                );
              },
              padding: EdgeInsets.only(
                  top: 32.0,
                  left: 22.0,
                  right: 22.0,
                  bottom: SizeConfig.blockSizeVertical * 11),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, int i) {
                var data = snapshot.data!.docs[i];
                var doc = data.data() as DocumentSnapshot<Map<String, dynamic>>;
                if (doc['answer'] == '') {
                  return SizedBox();
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 2,
                                  offset: Offset(0.0, 1.0),
                                )
                              ]),
                          child: Center(
                            child: Text(
                              'Q',
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal * 6),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    minHeight:
                                        SizeConfig.blockSizeVertical * 7),
                                child: Bubble(
                                  stick: true,
                                  nip: BubbleNip.leftBottom,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${doc['question']}'),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${_tanggal.format(DateTime.parse(doc['date']))}',
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(
                                minHeight: SizeConfig.blockSizeVertical * 7),
                            child: Bubble(
                              color: kPrimaryDarkColor,
                              nip: BubbleNip.rightBottom,
                              child: Column(
                                children: [
                                  Text(
                                    '${doc['answer']}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${_tanggal.format(DateTime.parse(doc['date']))}',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: kPrimaryDarkColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 2,
                                  offset: Offset(0.0, 1.0),
                                )
                              ]),
                          child: Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal * 6,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: SizeConfig.blockSizeVertical * 10,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4.0,
              )
            ]),
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                width: SizeConfig.blockSizeHorizontal * 80,
                height: SizeConfig.blockSizeVertical * 6,
                child: TextButton(
                  onPressed: _ajukanPertanyaan,
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Text('Ajukan Pertanyaan'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DialogQna extends StatefulWidget {
  final bool isloading;
  final bool isError;

  const DialogQna({
    Key? key,
    this.isloading = false,
    this.isError = false,
  }) : super(key: key);

  @override
  _DialogQnaState createState() => _DialogQnaState();
}

class _DialogQnaState extends State<DialogQna> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.isloading
          ? Container()
          : widget.isError
              ? Text('Warning')
              : Text('Sukses'),
      content: widget.isloading
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SpinKitHourGlass(color: Colors.grey, size: 28.0),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text('Please wait...')
                  ],
                ),
              ],
            )
          : widget.isError
              ? Text('Oops...Terjadi kesalahan. Silahkan coba lagi')
              : Text('Sukses menambahkan pertanyaan'),
      actions: [
        widget.isloading
            ? Container()
            : TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Tutup'),
              )
      ],
    );
  }
}
