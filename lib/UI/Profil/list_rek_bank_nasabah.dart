import 'package:Edimu/UI/TarikTunai/confirm_tariktransfer.dart';
import 'package:Edimu/UI/TarikTunai/tambah_rekening_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';

class ListRekBankNasabahPage extends StatefulWidget {
  final MainModel model;
  //
  ListRekBankNasabahPage(this.model);
  //
  @override
  _ListRekBankNasabahPageState createState() => _ListRekBankNasabahPageState();
}

class _ListRekBankNasabahPageState extends State<ListRekBankNasabahPage> {
  int selectedIDBankNasabah;
  Map selectedDataBank;
  //
  double nominalSlider = 0;
  TextEditingController nominalController = TextEditingController(text: "0");
  //
  @override
  void initState() {
    // TODO: implement initState
    getDataBankNasabah();
    super.initState();
  }

  //
  getDataBankNasabah() async {
    EasyLoading.show(
      dismissOnTap: true,
      status: 'sedang diproses',
      maskType: EasyLoadingMaskType.black,
    );

    await widget.model.getRekeningNasabah();

    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Rekening Bank"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<MainModel>(
        builder: (context, _, model) => Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(11),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    kotakPmberitahuan(),
                    SizedBox(
                      height: 30,
                    ),
                    listRekeningNasabah(model),
                    SizedBox(
                      height: 47,
                    ),
                    Card(
                      // elevation: 15,
                      child: Container(
                        height: 65,
                        width: MediaQuery.of(context).size.width - 31,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Warna.primary,
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          // height: 65,
                          // minWidth: MediaQuery.of(context).size.width - 31,
                          // color: Colors.grey[50],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TambahRekeningPage(widget.model)),
                            );

                            // kalo pake modalbottomsheet
                            // showBarModalBottomSheet(
                            //     duration: Duration(milliseconds: 351),
                            //     bounce: true,
                            //     isDismissible: true,
                            //     elevation: 7,
                            //     enableDrag: true,
                            //     context: context,
                            //     builder: (context) => BottomModalTambahRekening());
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          label: Text(
                            "Tambah rekening",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 75,
                    ),
                  ],
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: selectedIDBankNasabah != null
            //       ? tombolKonfirmasiTarikTransfer(widget.model)
            //       : Container(),
            // )
          ],
        ),
      ),
    );
  }

  Widget kotakPmberitahuan() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.amber[300],
          borderRadius: BorderRadius.all(Radius.circular(7))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline),
          SizedBox(width: 4,),
          Text(
            "Tekan dan tahan untuk menghapus rekening",
            style: TextStyle(
                color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget listRekeningNasabah(MainModel model) {
    if (model.listRekeningBankNasabah.length == 0) {
      return Center(
        child: Text("Anda belum memiliki rekening bank"),
      );
    } else {
      return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: model.listRekeningBankNasabah.length,
          itemBuilder: (context, index) {
            return CupertinoContextMenu(
              actions: [
                CupertinoContextMenuAction(
                    child: Text("Hapus",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500)),
                    trailingIcon: Icons.delete_forever_rounded,
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                      alertHapusRekening(
                        model.listRekeningBankNasabah[index]["id_bank_nasabah"],
                      );
                    }),
              ],
              child: Card(
                elevation:
                    model.listRekeningBankNasabah[index]["isSelected"] ? 0 : 10,
                color: model.listRekeningBankNasabah[index]["isSelected"]
                    ? Warna.primary
                    : Colors.white,
                child: ListTile(
                  leading: Image.asset(
                    'lib/assets/bank_icons/' +
                        model.listRekeningBankNasabah[index]["gambar"],
                    width: 55,
                  ),
                  title: Text(
                    model.listRekeningBankNasabah[index]["nama_bank"],
                    style: model.listRekeningBankNasabah[index]["isSelected"]
                        ? TextStyle(color: Colors.white)
                        : TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    model.listRekeningBankNasabah[index]["norek_bank"],
                    style: model.listRekeningBankNasabah[index]["isSelected"]
                        ? TextStyle(color: Colors.white)
                        : TextStyle(color: Colors.black),
                  ),
                ),
              ),
            );
          });
    }
  }

  void alertHapusRekening(int idBank) {
    Alert(
        context: context,
        type: AlertType.warning,
        title: "Perhatian",
        desc: "Apakah Anda yakin ingin menghapus rekening ini?",
        buttons: [
          DialogButton(
            color: Colors.red[700],
            child: Text("Batal", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          DialogButton(
            color: Colors.blue[800],
            child: Text("Iya", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              EasyLoading.show(
                dismissOnTap: true,
                status: 'sedang diproses',
                maskType: EasyLoadingMaskType.black,
              );

              String responseHapusRekening =
                  await widget.model.hapusRekeningBank(idBank);

              if (responseHapusRekening == 'sukses') {
                debugPrint('Hapus rekening sukses');

                EasyLoading.dismiss();
                Alert(
                    style: AlertStyle(
                      isOverlayTapDismiss: false,
                      isCloseButton: false,
                    ),
                    type: AlertType.success,
                    context: context,
                    title: "SUKSES",
                    desc: "Hapus rekening berhasil.",
                    buttons: [
                      DialogButton(
                        color: Colors.blue[800],
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      )
                    ]).show();
              } else {
                debugPrint(responseHapusRekening.toString());
                EasyLoading.dismiss();
                Alert(
                    type: AlertType.error,
                    context: context,
                    title: "Maaf",
                    desc: "Hapus rekening gagal",
                    buttons: [
                      DialogButton(
                        color: Colors.blue[800],
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      )
                    ]).show();
              }
            },
          ),
        ]).show();
  }

  Widget tombolKonfirmasiTarikTransfer(model) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20),
      child: ElevatedButton(
        child: Text(
          "Tarik Dana",
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Warna.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // <-- Radius
          ),
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(5.0),
        // ),
        // color: Warna.accent,
        onPressed: () async {
          popupTarikUang(model);
        },
      ),
    );
  }

  void popupTarikUang(MainModel model) {
    Alert(
            context: context,
            title: "Tarik Dana",
            closeFunction: () {
              Navigator.pop(context);
            },
            desc: "Masukkan nominal uang yang akan ditarik:",
            buttons: [],
            content: TarikDanaSlider(model, selectedIDBankNasabah))
        .show();
  }
}

class TarikDanaSlider extends StatefulWidget {
  MainModel model;
  int idBank;

  TarikDanaSlider(this.model, this.idBank);

  @override
  _TarikDanaSliderState createState() => _TarikDanaSliderState();
}

class _TarikDanaSliderState extends State<TarikDanaSlider> {
  double nominalSlider = 0;
  TextEditingController nominalController = MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: "",
    precision: 0,
  );

  @override
  void initState() {
    super.initState();
    nominalController.text = "0";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: nominalController,
            autofocus: true,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            onChanged: (value) {
              if (value == null) {
                nominalController.text = "0";
              }
            },
            decoration: InputDecoration(
              prefixText: "Rp. ",
              prefixStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 11,
          ),
          Slider(
              value: nominalSlider,
              min: 0,
              max: double.parse(widget.model.formatedBalance),
              onChanged: (value) {
                nominalController.text = value.toInt().toString();
                setState(() {
                  nominalSlider = value;
                });
              }),
          SizedBox(
            height: 25,
          ),
          Container(
            width: double.infinity,
            height: 51,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Warna.accent,
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.money,
                    //   color: Colors.white,
                    // ),
                    // SizedBox(
                    //   width: 11,
                    // ),
                    Text(
                      "Tarik Dana",
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
