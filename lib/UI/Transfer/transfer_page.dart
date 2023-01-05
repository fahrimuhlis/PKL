import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:Edimu/UI/Transfer/confirm_transfer_page.dart';
import 'package:Edimu/models/contacts_model.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:Edimu/scoped_model/connected_model.dart';

class transferPage extends StatefulWidget {
  final String userName;
  final MainModel model;

  transferPage(this.model, {this.userName});

  @override
  _transferPageState createState() => _transferPageState();
}

class _transferPageState extends State<transferPage> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController amountController = MoneyMaskedTextController(
      thousandSeparator: '.', decimalSeparator: "", precision: 0);
  TextEditingController noteController = new TextEditingController();
  TextEditingController searchController = TextEditingController();

  //duplicate items = list yang berisi nama > listNama
  // items = items biasa
  List<String> listNama = [];
  List<String> listUsername = [];
  var itemsNama = List<String>();
  var itemsUsername = List<String>();

  List listContacts;
  List listDisplayName = [];

  String namaPenerima;

  String catatan = '-';

  // tambahan buat ningkatin UX
  var scrollController = ScrollController();
  var focusNodeNominal = FocusNode();
  var catatanFocusNode = FocusNode();

  @override
  void initState() {
    checkUserName();
    buatNama();
    buatUsername();
    itemsNama.addAll(listNama);
    itemsUsername.addAll(listUsername);

    listContacts = widget.model.listContacts.contactLists;
    listDisplayName = listContacts;

    //init catatan biar ga kosong
    noteController.text = "";

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    focusNodeNominal.dispose();
    //
    super.dispose();
  }

  buatNama() {
    for (var i = 0; i < widget.model.listContacts.contactLists.length; i++) {
      //list.add(widget.model.listContacts.contactLists[i].name);
      listNama.add(widget.model.listContacts.contactLists[i].name);
    }
  }

  buatUsername() {
    for (var i = 0; i < widget.model.listContacts.contactLists.length; i++) {
      //list.add(widget.model.listContacts.contactLists[i].name);
      listUsername.add(widget.model.listContacts.contactLists[i].id);
    }
  }

  void cariNama(String text) {}

  //coding lama
  void filterSearchResults(String query) {
    List<String> dummySearchListNama = List<String>();
    dummySearchListNama.addAll(listNama);

    List<String> dummySearchListUsername = List<String>();
    dummySearchListUsername.addAll(listUsername);

    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      List<String> dummyListDataUsername = List<String>();

      dummySearchListNama.forEach((item) {
        if (item.contains(query)) {
          dummyListDataUsername.add(item);
        }
      });

      setState(() {
        itemsNama.clear();
        itemsUsername.clear();
        itemsNama.addAll(dummyListData);
        itemsUsername.addAll(dummyListDataUsername);
      });
      return;
    } else {
      setState(() {
        itemsNama.clear();
        itemsUsername.clear();
        itemsNama.addAll(listNama);
        itemsUsername.addAll(listUsername);
      });
    }
  }

  checkUserName() {
    if (widget.userName == null) {
      usernameController.text = "";
    } else {
      usernameController.text = widget.userName;
    }
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      //items = duplicateItems
      // itemListnya = items

      return Scaffold(
        appBar: AppBar(
          title: Text("Transfer dana"),
          centerTitle: true,
        ),
        body: ListView(
          controller: scrollController,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (text) {
                  text = text.toLowerCase();

                  setState(() {
                    listDisplayName = listContacts.where((note) {
                      var nama = note.name.toLowerCase();
                      return nama.contains(text);
                    }).toList();
                  });
                },
                controller: searchController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Cari nama",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Container(
              color: Colors.white30,
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listDisplayName.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${listDisplayName[index].name}'),
                    subtitle: Text(
                      listDisplayName[index].id,
                      style: TextStyle(color: Warna.accent),
                    ),
                    onTap: () {
                      usernameController.text = listDisplayName[index].id;
                      namaPenerima = listDisplayName[index].name;
                      nameController.text = listDisplayName[index].name;
                      noteController.text = ' ';
                      setState(() {});
                      //
                      // scrollController.animateTo(
                      //     scrollController.position.maxScrollExtent,
                      //     duration: Duration(milliseconds: 501),
                      //     curve: Curves.easeIn);

                      focusNodeNominal.requestFocus();
                    },
                  );
                },
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(28, 20, 27, 0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Saldo",
                                style: TextStyle(
                                    fontSize: 15, color: Warna.primary)),
                          ),
                          Align(
                            child: Text(rupiah(model.formatedBalance),
                                style: TextStyle(
                                  fontSize: 15,
                                )),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 35.17,
                      ),
                      TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: "Nama Penerima",
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Warna.primary, width: 3.0)),
                        ),

                        //initialValue: usernameController.text,

                        // initialValue: initialUsername,
                        controller: nameController,
                        validator: (value) {
                          if (usernameController.text.length < 1) {
                            return "masukkan username tujuan anda";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 25.17,
                      ),
                      TextFormField(
                          focusNode: focusNodeNominal,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            catatanFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            prefixText: "Rp.",
                            labelText: "Nominal",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Warna.primary, width: 3.0)),
                          ),
                          keyboardType: TextInputType.number,
                          controller: amountController,
                          validator: (value) {
                            //debugPrint(
                            // "balancenya ======= ${model.formatedBalance.toString()}");
                            int a = int.parse(
                                amountController.text.replaceAll(".", ""));
                            //debugPrint(a.toString());
                            if (a > int.parse(model.formatedBalance)) {
                              //debugPrint(a.toString());
                              return "saldo anda kurang";
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(
                        height: 25.17,
                      ),
                      TextField(
                        focusNode: catatanFocusNode,
                        textInputAction: TextInputAction.go,
                        onSubmitted: (_) {
                          prosesKeHalamanKonfirmasiTransfer();
                        },
                        decoration: InputDecoration(
                            labelText: "Catatan",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Warna.primary, width: 3.0))),
                        controller: noteController,
                        // validator: (value) {
                        //   if (noteController.text.length < 1) {
                        //     return "masukkan note";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 57,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Warna.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(9), // <-- Radius
                              ),
                            ),
                            // color: Warna.accent,
                            child: Text(
                              "Lanjut",
                              style: TextStyle(color: Colors.white),
                            ),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(9.0)),
                            onPressed: () async {
                              prosesKeHalamanKonfirmasiTransfer();
                            },
                          )),
                      SizedBox(height: 25),
                    ],
                  ),
                )),
          ],
        ),
      );
    });
  }

  prosesKeHalamanKonfirmasiTransfer() async {
    formKey.currentState.validate();

    if (formKey.currentState.validate()) {
      //debugPrint(".......");
      //debugPrint('isi namaPenerima $namaPenerima');
      //debugPrint(".......");

      if (amountController.text.length > 2) {
        String modifAngka = amountController.text.replaceAll(".", "");

        String catatan;

        if (noteController.text == "" ||
            noteController.text == null ||
            noteController.text.length < 2) {
          catatan = "tidak ada catatan";
          //debugPrint("null or ''");
        } else {
          catatan = noteController.text;
          //debugPrint("note ada isinya");
        }

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => confirmTransferPage(namaPenerima,
                  usernameController.text, catatan, int.parse(modifAngka))),
        );
      } else if (amountController.text.length < 3) {
        Alert(
            type: AlertType.warning,
            context: context,
            title: "Minimum transfer adalah Rp. 100",
            buttons: [
              DialogButton(
                color: Colors.blue[800],
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ]).show();
      }
    }
  }
}
