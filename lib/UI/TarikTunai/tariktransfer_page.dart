import 'package:Edimu/UI/TarikTunai/confirm_tariktransfer.dart';
import 'package:Edimu/UI/TarikTunai/tambah_rekening_page.dart';
import 'package:flutter/material.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TarikTransferPage extends StatefulWidget {
  MainModel model;
  int jumlah;
  //
  TarikTransferPage(this.model, this.jumlah);
  //
  @override
  _TarikTransferPageState createState() => _TarikTransferPageState();
}

class _TarikTransferPageState extends State<TarikTransferPage> {
  int selectedIDBankNasabah;
  Map selectedDataBank;
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
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(11),
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Text("dana yang akan ditarik :"),
                SizedBox(
                  height: 15,
                ),
                Text(
                  rupiah(widget.jumlah),
                  style: TextStyle(
                      color: Colors.green[600],
                      fontSize: 35,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text("Pilih no. rekening:"),
                ),
                SizedBox(
                  height: 25,
                ),
                listRekeningNasabah(),
                SizedBox(
                  height: 7,
                ),
                Card(
                  // elevation: 15,
                  child: Container(
                    height: 65,
                    width: MediaQuery.of(context).size.width - 31,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[50],
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
                      icon: Icon(Icons.add, color: Colors.black,),
                      label: Text("Tambah rekening", style: TextStyle(color: Colors.black),),
                      // shape: RoundedRectangleBorder(
                      //     side: BorderSide(
                      //         color: Warna.primary,
                      //         width: 3,
                      //         style: BorderStyle.solid),
                      //     borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 75,
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: selectedIDBankNasabah != null
              ? tombolKonfirmasiTarikTransfer(widget.model)
              : Container(),
        )
      ],
    );
  }

  Widget listRekeningNasabah() {
    if (widget.model.listRekeningBankNasabah == null) {
      return Center(
        child: Text("Anda belum memasukkan rekening bank"),
      );
    } else {
      return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.model.listRekeningBankNasabah.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                if (widget.model.listRekeningBankNasabah[index]["isSelected"] ==
                    true) {
                  //
                  setState(() {
                    widget.model.listRekeningBankNasabah[index]["isSelected"] =
                        !widget.model.listRekeningBankNasabah[index]
                            ["isSelected"];
                  });
                  //
                  selectedIDBankNasabah = null;
                } else {
                  widget.model.listRekeningBankNasabah.forEach((item) {
                    item["isSelected"] = false;
                  });

                  setState(() {
                    widget.model.listRekeningBankNasabah[index]["isSelected"] =
                        !widget.model.listRekeningBankNasabah[index]
                            ["isSelected"];

                    selectedDataBank =
                        widget.model.listRekeningBankNasabah[index];

                    selectedIDBankNasabah = widget.model
                        .listRekeningBankNasabah[index]["id_bank_nasabah"];
                  });

                  selectedIDBankNasabah = widget
                      .model.listRekeningBankNasabah[index]["id_bank_nasabah"];
                }

                //debugPrint(
                // "id_bank_nasabah terpilih = ${widget.model.listRekeningBankNasabah[index]["id_bank_nasabah"]}");
              },
              child: Card(
                elevation: widget.model.listRekeningBankNasabah[index]
                        ["isSelected"]
                    ? 0
                    : 15,
                color: widget.model.listRekeningBankNasabah[index]["isSelected"]
                    ? Warna.primary
                    : Colors.white,
                child: ListTile(
                  leading: Image.asset(
                    'lib/assets/bank_icons/' +
                        widget.model.listRekeningBankNasabah[index]["gambar"],
                    width: 51,
                  ),
                  title: Text(
                    widget.model.listRekeningBankNasabah[index]["nama_bank"],
                    style: widget.model.listRekeningBankNasabah[index]
                            ["isSelected"]
                        ? TextStyle(color: Colors.white)
                        : TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    widget.model.listRekeningBankNasabah[index]["norek_bank"],
                    style: widget.model.listRekeningBankNasabah[index]
                            ["isSelected"]
                        ? TextStyle(color: Colors.white)
                        : TextStyle(color: Colors.black),
                  ),
                ),
              ),
            );
          });
    }
  }

  Widget tombolKonfirmasiTarikTransfer(model) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20),
      child: ElevatedButton(
        
        child: Text(
          "Lanjutkan",
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
          // selectedDataBank["gambar"] = listDaftarBank
          //     .where((element) =>
          //         element["namaBank"].toLowerCase() ==
          //         selectedDataBank["nama_bank"].toLowerCase())
          //     .toList()[0]["gambar"];
          //
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => KonfirmasiTarikTransfer(
                    model, selectedDataBank, widget.jumlah)),
          );
        },
      ),
    );
  }
}
