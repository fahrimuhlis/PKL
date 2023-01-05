import 'package:flutter/material.dart';
import 'package:Edimu/UI/Marketplace/shipping_cart_page.dart';
import 'package:Edimu/UI/Marketplace/receipt_marketplace_cart.dart';
import 'package:Edimu/UI/Topup/topUp_page.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CartDisplayPage extends StatefulWidget {
  MainModel model;

  CartDisplayPage(this.model);

  @override
  _CartDisplayPageState createState() => _CartDisplayPageState();
}

class _CartDisplayPageState extends State<CartDisplayPage> {
  List<List> isiKeranjang = [];
  List totalBelanjaPerSeller = [];

  @override
  void initState() {
    // TODO: implement initState

    widget.model.isiKeranjang.forEach((key, value) {
      List penampung = [];
      value.forEach((keyDalem, valueDalem) {
        penampung.add(valueDalem);
      });
      isiKeranjang.add(penampung);
    });

    updateTotalBelanja();

    //debugPrint("isi isiKeranjang :");
    //debugPrint(isiKeranjang.toString());

    //debugPrint("isi Array totalBelanjaPerSeller");
    //debugPrint(totalBelanjaPerSeller.toString());

    // isiKeranjang.forEach((index) {
    //   totalBelanja += index["total"];
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.hijauBG2,
      appBar: AppBar(
        title: Text("keranjang Belanja"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            // physics: NeverScrollableScrollPhysics(),
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 11,
                  ),
                  listViewBaru(),
                  SizedBox(
                    height: 15,
                  )
                ],
              )
            ],
          ),
          Positioned(left: 0.5, bottom: 0, child: Container())
        ],
      ),
    );
  }

  //update 13 juli 2021
  //listview berdasarkan penjual
  Widget listViewBaru() {
    return Container(
      child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: isiKeranjang.length,
          itemBuilder: (context, index) {
            // List isiKeranjangBagianDalam = [];

            // isiKeranjang[index].forEach((key, value) {
            //   isiKeranjangBagianDalam.add(value);
            // });

            return Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 14, left: 17),
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  color: Colors.green,
                  child: Text(
                    "Penjual : ${isiKeranjang[index][0]["namaPenjual"]}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Card(
                    elevation: 11,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(11, 11, 11, 0),
                          child: ListView.builder(
                            reverse: true,
                            itemCount: isiKeranjang[index].length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, indexDalam) {
                              return Container(
                                padding: EdgeInsets.all(11),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.network(
                                          isiKeranjang[index][indexDalam]
                                              ["urlGambar"],
                                          cacheHeight: 75,
                                          cacheWidth: 75,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(isiKeranjang[index]
                                                  [indexDalam]["namaBarang"]),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                rupiah(isiKeranjang[index]
                                                        [indexDalam]
                                                    ["hargaSatuan"]),
                                                style: TextStyle(
                                                    color: Colors.blue[800],
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    counterJumlahBarang(index, indexDalam),
                                    SizedBox(
                                      height: 11,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 11,
                        ),
                        tombolBayarDanTotalBelanjaBaru(index),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                )
              ],
            );
          }),
    );
  }

  // Widget listViewLama() {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(11, 25, 11, 115),
  //     child: Container(
  //       child: ListView.builder(
  //           reverse: true,
  //           shrinkWrap: true,
  //           physics: NeverScrollableScrollPhysics(),
  //           itemCount: widget.model.isiKeranjang.length,
  //           itemBuilder: (context, index) {
  //             return Card(
  //               child: Container(
  //                 padding: EdgeInsets.all(11),
  //                 child: Column(
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Image.network(
  //                           isiKeranjang[index]["urlGambar"],
  //                           cacheHeight: 75,
  //                           cacheWidth: 75,
  //                           fit: BoxFit.cover,
  //                         ),
  //                         SizedBox(
  //                           width: 15,
  //                         ),
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(isiKeranjang[index]["namaBarang"]),
  //                               SizedBox(
  //                                 height: 5,
  //                               ),
  //                               Text(
  //                                 rupiah(isiKeranjang[index]["hargaSatuan"]),
  //                                 style: TextStyle(
  //                                     color: Colors.blue[800],
  //                                     fontWeight: FontWeight.w700),
  //                               )
  //                             ],
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: 7,
  //                     ),
  //                     // counterJumlahBarang(index),
  //                     SizedBox(
  //                       height: 11,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Text("total "),
  //                         SizedBox(
  //                           width: 3,
  //                         ),
  //                         Text(
  //                           rupiah(isiKeranjang[index]["total"]),
  //                           style: TextStyle(
  //                               color: Colors.blue[800],
  //                               fontWeight: FontWeight.w700,
  //                               fontSize: 19),
  //                         ),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             );
  //           }),
  //     ),
  //   );
  // }

  Widget counterJumlahBarang(int index, int indexDalam) {
    var _isianJumlah = TextEditingController();
    _isianJumlah.text =
        isiKeranjang[index][indexDalam]["jumlahBarang"].toString();

    bool isKonfirmasiHapus = false;

    double _ukuranIcon = 35;

    return Container(
      // width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        size: _ukuranIcon,
                        color: Colors.blue[800],
                      ),
                      onPressed: () {
                        if (int.parse(_isianJumlah.text) > 1) {
                          isiKeranjang[index][indexDalam]["jumlahBarang"]--;
                          _isianJumlah.text = isiKeranjang[index][indexDalam]
                                  ["jumlahBarang"]
                              .toString();

                          setState(() {
                            totalBelanjaPerSeller[index] = 0;

                            isiKeranjang[index][indexDalam]["total"] -=
                                isiKeranjang[index][indexDalam]["hargaSatuan"];

                            isiKeranjang[index].forEach((indexDalam) {
                              totalBelanjaPerSeller[index] +=
                                  indexDalam["total"];
                            });
                          });

                          //debugPrint("kondisi perubahan isi keranjang :");
                          //debugPrint(
                          // isiKeranjang[index][indexDalam].toString());
                        } else if (int.parse(_isianJumlah.text) == 1) {
                          showPopupDelete(index, indexDalam);
                        }
                      }),
                  SizedBox(width: 7),
                  SizedBox(
                    width: 45,
                    height: 25,
                    child: TextField(
                      controller: _isianJumlah,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        focusColor: Colors.blue[800],
                        fillColor: Colors.blue[800],
                        hoverColor: Colors.blue[800],
                      ),
                      onChanged: (value) {
                        if (int.parse(value) > 0) {
                          setState(() {
                            totalBelanjaPerSeller[index] = 0;

                            isiKeranjang[index][indexDalam]["total"] -=
                                isiKeranjang[index][indexDalam]["hargaSatuan"];

                            isiKeranjang[index].forEach((item) {
                              totalBelanjaPerSeller[index] -= item["total"];
                            });
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 7),
                  IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        size: _ukuranIcon,
                        color: Colors.blue[800],
                      ),
                      onPressed: () {
                        isiKeranjang[index][indexDalam]["jumlahBarang"]++;
                        _isianJumlah.text = isiKeranjang[index][indexDalam]
                                ["jumlahBarang"]
                            .toString();

                        setState(() {
                          totalBelanjaPerSeller[index] = 0;

                          isiKeranjang[index][indexDalam]["total"] +=
                              isiKeranjang[index][indexDalam]["hargaSatuan"];

                          isiKeranjang[index].forEach((item) {
                            totalBelanjaPerSeller[index] += item["total"];
                          });
                        });

                        //debugPrint("kondisi perubahan isi keranjang :");
                        //debugPrint(isiKeranjang[index][indexDalam].toString());
                      }),
                ],
              ),
              SizedBox(
                height: 7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("total "),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    rupiah(isiKeranjang[index][indexDalam]["total"]),
                    style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.w700,
                        fontSize: 19),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            width: 11,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800],),
              // color: Colors.red[800],
              onPressed: () {
                showPopupDelete(index, indexDalam);
              },
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              label: Text(
                "Hapus",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }

  Widget tombolBayarDanTotalBelanjaBaru(int index) {
    // isiKeranjang[index].forEach((item) {
    //   totalBelanjaPerSeller += item
    // });

    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(11),
              child: Row(
                children: [
                  Text("Total belanja :"),
                  SizedBox(width: 7),
                  Text(rupiah(totalBelanjaPerSeller[index]),
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w700,
                          fontSize: 27))
                ],
              ),
            ),
            SizedBox(
              height: 7,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: 55,
                color: Colors.blue[800],
                child: ElevatedButton(
                  // color: Colors.blue[800],
                  // height: 55,
                  child: Text(
                    "Bayar",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    //debugPrint("total belanja per seller yang dikirim");
                    //debugPrint(rupiah(totalBelanjaPerSeller[index].toString()));

                    if (int.parse(widget.model.formatedBalance) >=
                        totalBelanjaPerSeller[index] +
                            widget.model.biayaLayananAplikasi) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckoutCartPage(
                                widget.model,
                                isiKeranjang[index],
                                totalBelanjaPerSeller[index])),
                      );
                    } else {
                      alertSaldoTidakCukup(index);
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //ketika saldo tidak cukup
  alertSaldoTidakCukup(index) {
    Alert(
        context: context,
        title: "Saldo tidak cukup",
        type: AlertType.info,
        closeFunction: () {},
        desc: "Maaf saldo anda tidak cukup untuk melakukan pembayaran",
        content: Column(
          children: [
            SizedBox(
              height: 7,
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(9),
              ),
              padding: EdgeInsets.all(11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //     "Saldo anda : ${rupiah(widget.model.formatedBalance)}"),
                  // Text(
                  //     "Total belanja : ${rupiah((jumlahBarang * hargaSatuan) + widget.model.biayaLayananAplikasi)}"),
                  ListTile(
                      title: Text("Saldo anda"),
                      trailing: Text(
                        rupiah(widget.model.formatedBalance),
                        style: TextStyle(color: Colors.red[900]),
                      )),
                  ListTile(
                    title: Text("Harga"),
                    trailing: Text(rupiah(totalBelanjaPerSeller[index])),
                  ),
                  ListTile(
                    title: Text("Biaya layanan:"),
                    trailing: Text(rupiah(widget.model.biayaLayananAplikasi)),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Text("Total:"),
                    trailing: Text(rupiah(totalBelanjaPerSeller[index] +
                        widget.model.biayaLayananAplikasi)),
                  ),
                ],
              ),
            )
          ],
        ),
        buttons: [
          DialogButton(
              child: Text(
                "Isi Saldo",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => topUpPage(
                            widget.model,
                          )),
                );
              })
        ]).show();
  }

  showPopupDelete(int index, int indexDalam) {
    Alert(
        context: context,
        type: AlertType.warning,
        closeFunction: () {},
        title: 'Menghapus barang',
        desc: "Apakah anda mau menghapus barang ini?",
        content: Container(
          padding: EdgeInsets.all(15),
          child: Text(
            isiKeranjang[index][indexDalam]["namaBarang"],
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
        ),
        buttons: [
          DialogButton(
              color: Colors.blueGrey[100],
              child: Text(
                "tidak",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          DialogButton(
              color: Colors.red[800],
              child: Text(
                "Hapus",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                String norekPenjual =
                    isiKeranjang[index][indexDalam]["norekPenjual"];

                Map isiKeranjangPerSeller =
                    widget.model.isiKeranjang[norekPenjual];

                int idLapakYangDihapus =
                    isiKeranjang[index][indexDalam]["idLapak"];

                if (isiKeranjang[index].length > 1) {
                  setState(() {
                    isiKeranjang[index].removeAt(indexDalam);
                    isiKeranjangPerSeller.remove(idLapakYangDihapus);
                    //ngapus yang di scopedmodel
                    widget.model.isiKeranjang[norekPenjual]
                        .remove(idLapakYangDihapus);
                  });
                  updateTotalBelanja();
                  setState(() {});
                  widget.model.notifyListeners();
                } else if (isiKeranjang[index].length == 1) {
                  setState(() {
                    isiKeranjang.removeAt(index);
                    widget.model.isiKeranjang.remove(norekPenjual);
                  });

                  totalBelanjaPerSeller = [];
                  updateTotalBelanja();
                  setState(() {});
                  widget.model.notifyListeners();
                }
                Navigator.pop(context);
              })
        ]).show();
  }

  updateTotalBelanja() {
    totalBelanjaPerSeller = [];
    isiKeranjang.forEach((item) {
      var penampungTotalBelanja = 0;

      item.forEach((itemDalem) {
        penampungTotalBelanja += itemDalem["total"];
      });

      totalBelanjaPerSeller.add(penampungTotalBelanja);
    });
  }

  // Widget tombolHitungJumlahBarang() {
  //   double lebarSayapTombol = 235;
  //   double tinggiSayapTombol = 51;

  //   return Column(
  //     // crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         height: tinggiSayapTombol,
  //         width: lebarSayapTombol,
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(9), color: Colors.blue[800]),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             Flexible(
  //               flex: 1,
  //               child: InkWell(
  //                 onTap: () {
  //                   _canVibrate
  //                       ? Vibration.vibrate(
  //                           pattern: [0, 75],
  //                         )
  //                       : null;
  //                   if (jumlahBarang > 0) {
  //                     setState(() {
  //                       jumlahBarang = int.parse(isianJumlahBarang.text) - 1;

  //                       isianJumlahBarang.text = jumlahBarang.toString();

  //                       totalHarga = hargaSatuan * jumlahBarang;
  //                     });
  //                   }
  //                 },
  //                 child: Container(
  //                   height: 41,
  //                   width: double.infinity,
  //                   child: Center(
  //                     child: Text('-',
  //                         style: TextStyle(color: Colors.white, fontSize: 21)),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             InkWell(
  //               child: Container(
  //                 color: Colors.white,
  //                 height: 35,
  //                 width: 55,
  //                 child: Center(
  //                   child: TextField(
  //                     keyboardType: TextInputType.number,
  //                     controller: isianJumlahBarang,
  //                     autofocus: autoFocusIsianJumlah,
  //                     focusNode: focusNode,
  //                     // keyboardType: TextInputType.number,
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(color: Colors.blue[800]),
  //                     // decoration: InputDecoration(),

  //                     onChanged: (isian) {
  //                       if (int.parse(isian) > widget.stok) {
  //                         popUpMelebihiStok();
  //                       } else if (isian == "") {
  //                         setState(() {
  //                           isianJumlahBarang.text = "0";
  //                         });
  //                       } else if (int.parse(isian) <= widget.stok) {
  //                         //debugPrint("amaaannnnn");
  //                         setState(() {
  //                           jumlahBarang = int.parse(isian);
  //                           totalHarga = int.parse(widget.price) * jumlahBarang;
  //                         });
  //                       } else {
  //                         setState(() {
  //                           isianJumlahBarang.text = "0";
  //                         });
  //                       }
  //                     },

  //                     onTap: () {
  //                       focusNode.requestFocus();
  //                       _scrollController.animateTo(
  //                           _scrollController.position.pixels + 455,
  //                           duration: Duration(milliseconds: 2701),
  //                           curve: Curves.linearToEaseOut);

  //                       setState(() {
  //                         autoFocusIsianJumlah = true;
  //                       });

  //                       if (isianJumlahBarang.text == "0") {
  //                         isianJumlahBarang.text = "";
  //                       }
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Flexible(
  //               flex: 1,
  //               child: InkWell(
  //                 onTap: () {
  //                   _canVibrate
  //                       ? Vibration.vibrate(
  //                           pattern: [0, 75],
  //                         )
  //                       : null;
  //                   if (int.parse(isianJumlahBarang.text) < widget.stok) {
  //                     setState(() {
  //                       jumlahBarang = int.parse(isianJumlahBarang.text) + 1;

  //                       isianJumlahBarang.text = jumlahBarang.toString();

  //                       totalHarga = hargaSatuan * jumlahBarang;

  //                       //debugPrint("isi total harga : ${rupiah(totalHarga)}");
  //                     });
  //                   } else if (int.parse(isianJumlahBarang.text) ==
  //                       widget.stok) {
  //                     popUpMelebihiStok();
  //                   }
  //                 },
  //                 child: Container(
  //                   height: tinggiSayapTombol,
  //                   width: lebarSayapTombol,
  //                   child: Center(
  //                     child: Text('+',
  //                         style: TextStyle(color: Colors.white, fontSize: 21)),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       SizedBox(height: 5),
  //       Container(
  //         child: Text('sisa : ' + widget.stok.toString() + ' pcs',
  //             style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
  //       )
  //     ],
  //   );
  // }
}
