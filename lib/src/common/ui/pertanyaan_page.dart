import 'package:antrian_online_restu/src/common/source/color_style.dart';
import 'package:antrian_online_restu/src/common/source/size_config.dart';
import 'package:antrian_online_restu/src/common/widget/custom_dialog_form..dart';
import 'package:antrian_online_restu/src/common/widget/loading_widget.dart';
import 'package:antrian_online_restu/src/common/widget/server_error_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PertanyaanAdminPage extends StatefulWidget {
  @override
  _PertanyaanAdminPageState createState() => _PertanyaanAdminPageState();
}

class _PertanyaanAdminPageState extends State<PertanyaanAdminPage> {
  late CollectionReference firestore;
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  Future<void> initFirebase() async {
    try {
      await Firebase.initializeApp();
      firestore = FirebaseFirestore.instance.collection('restu');
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = true;
      });
    }
  }

  void _jawabPertanyaan(String pertanyaan, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialogForm(
        title: "Menjawab Pertanyaan User",
        description: "$pertanyaan",
        buttonText: 'Jawab pertanyaan',
        submitForm: (String input, GlobalKey<FormState> formKey) =>
            _jawab(id, input, formKey),
      ),
    );
  }

  void _jawab(String id, String input, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      DocumentReference query =
          FirebaseFirestore.instance.collection('restu').doc(id);
      await query.update({'answer': '$input'});
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        centerTitle: false,
        title: Text('QnA'),
      ),
      body: _buildBodyPage(context),
    );
  }

  Widget _buildBodyPage(BuildContext context) {
    if (_error) {
      return ServerErrorWidget(
        message: 'Oops...terjadi kesalahan. Silahkan coba lagi',
        reload: () {
          initFirebase();
        },
      );
    }
    if (!_initialized) {
      return LoadingWidget(
        message: 'Memuat...',
      );
    }
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.where('answer', isEqualTo: '').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ServerErrorWidget(
            message: 'Oops...terjadi kesalahan. Silahkan coba lagi',
            reload: () {
              setState(() {});
            },
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget(
            message: 'Memuat...',
          );
        }

        if (snapshot.data!.docs.length == 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: SizeConfig.blockSizeVertical * 30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/server_error.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 42.0,
              ),
              Text(
                'Saat ini tidak ada pertanyaan',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                    fontSize: SizeConfig.blockSizeHorizontal * 5),
              ),
            ],
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(18.0),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, int i) {
            var data = snapshot.data!.docs[i];
            var doc = data.data() as DocumentSnapshot<Map<String, dynamic>>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Card(
                child: ListTile(
                  onTap: () => _jawabPertanyaan(doc['question'], data.id),
                  title: Text('${doc['question']}'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
