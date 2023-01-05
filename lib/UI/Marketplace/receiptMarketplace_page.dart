import 'package:flutter/material.dart';
import 'package:Edimu/UI/Marketplace/marketplace_lokal_page.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class ReceiptMarketplace_Page extends StatefulWidget {
  MainModel model;
  String title;

  String namaPenerima;
  String nohapePenerima;
  String alamatPenerima;
  int metodePengiriman;
  int idLapak;
  int totalHarga;
  String catatanPembeli;
  String rekPenjual;
  String gambar;
  int jumlah;
  String usernamePenjual;
  String nohapePenjual;
  Map respon;
  String deskripsi;
  String alamatPenjual;

  ReceiptMarketplace_Page(
      this.model,
      this.title,
      this.namaPenerima,
      this.nohapePenerima,
      this.alamatPenerima,
      this.metodePengiriman,
      this.idLapak,
      this.totalHarga,
      this.catatanPembeli,
      this.rekPenjual,
      this.gambar,
      this.jumlah,
      this.usernamePenjual,
      this.nohapePenjual,
      this.respon,
      this.deskripsi,
      this.alamatPenjual);

  @override
  _ReceiptMarketplace_PageState createState() =>
      _ReceiptMarketplace_PageState();
}

class _ReceiptMarketplace_PageState extends State<ReceiptMarketplace_Page> {
  String nomerUntukWa;
  String alamatUntukWa;
  String alamatPembeli;

  List<bool> _selections = List.generate(3, (_) => false);

  bool _canVibrate;

  bisaGetar() async {
    _canVibrate = await Vibration.hasVibrator();
    bisaGetar();
  }

  @override
  void initState() {
    if (widget.nohapePenjual != null) {
      nomerUntukWa = widget.nohapePenjual.substring(1);
    } else {
      nomerUntukWa = widget.usernamePenjual.substring(1);
    }

    alamatUntukWa = widget.metodePengiriman == 2
        ? "Barang mohon dikirimkan ke *${widget.alamatPenerima.toUpperCase()}*"
        : "Barang akan kami ambil di *${widget.alamatPenjual ?? '(alamat penjual belum tertera)'}*";

    alamatPembeli = widget.alamatPenerima == null || widget.alamatPenerima == ""
        ? "_(pembeli tidak menyertakan alamat)_"
        : widget.alamatPenerima;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Bukti Pembelian',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MarketPlace_Lokal_Page(widget.model)),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 9, horizontal: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    boxPeringatan(),
                    SizedBox(height: 7),
                    detailPembeli(),
                    SizedBox(height: 1),
                    metodePengiriman(),
                    SizedBox(height: 1),
                    detailPesanan(),
                    SizedBox(height: 75)
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 125,
                width: double.infinity,
                // padding: EdgeInsets.only(bottom: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 65,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only()),
                          ),
                          // height: 65,
                          // color: Colors.blue[700],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 19,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "belanja lagi",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.only()),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MarketPlace_Lokal_Page(widget.model)),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 65,
                        child: ElevatedButton(
                           style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only()),
                            ),
                          // height: 65,
                          // color: Colors.green[700],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "lib/assets/whatsapp.png",
                                width: 35,
                                height: 35,
                              ),
                              SizedBox(width: 7),
                              Text(
                                "Konfirmasi Pembelian",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.only()),
                          onPressed: () async {
                            launchWhatsApp();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  launchWhatsApp() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+62' + nomerUntukWa,
      text: """
      Assalamualaikum wr wb. 
        
        saya *${widget.model.nama.toUpperCase()}* dari *${alamatPembeli}* telah membeli barang yang bapak/ibu jual di ${widget.model.namaKomunitas}, yaitu : 
        
        *${widget.deskripsi.toUpperCase()}* sebanyak ${widget.jumlah.toString()} pcs.  
        
        *dana sebesar ${rupiah(widget.totalHarga.toString())} telah saya transfer ke rekening Edimu bapak/ibu.* 
        
        ${alamatUntukWa} 

        Terimakasih
      """,
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }

  Widget boxPeringatan() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.amber[200], borderRadius: BorderRadius.circular(9)),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.green[600]),
              child: Icon(
                Icons.check,
                size: 65,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Transaksi anda berhasil.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            // SizedBox(
            //   height: 5,
            // ),
            // Text("Total Belanja Anda:"),
            // SizedBox(
            //   height: 5,
            // ),
            // Text(
            //   rupiah(widget.totalHarga.toString()),
            //   style: TextStyle(fontSize: 29),
            // )
          ],
        ),
      ),
    );
  }

  Widget detailPembeli() {
    return Card(
      elevation: 7,
      child: Container(
        padding: EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detail Penerima barang',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 7),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(widget.namaPenerima,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              // trailing: InkWell(
              //   onTap: () {},
              //   child: Text(
              //     'Ubah',
              //     style: TextStyle(color: Colors.blue[800]),
              //   ),
              // ),
              // isThreeLine: true,
              // subtitle: Text(alamatPenerima)
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(widget.nohapePenerima,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              // trailing: InkWell(
              //   onTap: () {},
              //   child: Text(
              //     'Ubah',
              //     style: TextStyle(color: Colors.blue[800]),
              //   ),
              // ),
            )
          ],
        ),
      ),
    );
  }

  Widget metodePengiriman() {
    return Card(
      elevation: 7,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 6),
              child: Text('Metode Pengiriman',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 0),
            ListTile(
                leading: Icon(Icons.local_shipping),
                title: Text(
                    widget.metodePengiriman == 1
                        ? "Ambil Sendiri"
                        : "Barang akan dikirim ke :",
                    style: TextStyle(color: Colors.red[800])),
                subtitle: widget.metodePengiriman == 1
                    ? Text("Ini alamat seller")
                    : Text(widget.alamatPenerima))
          ],
        ),
      ),
    );
  }

  Widget detailPesanan() {
    return Card(
      elevation: 7,
      child: Container(
        padding: EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detail Pesanan',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 7),
            ListTile(
              dense: true,
              leading: Image.network(widget.gambar,
                  fit: BoxFit.cover, width: 50, height: 50),
              title: Text(widget.title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              trailing: InkWell(
                onTap: () {},
                child: Text(
                  '${widget.jumlah.toString()} x',
                  style: TextStyle(color: Colors.blue[800]),
                ),
              ),
            ),
            ListTile(
                dense: true,
                title: widget.catatanPembeli == ' '
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'catatan : ',
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Container(
                              child: Text(widget.catatanPembeli),
                            ),
                          )
                        ],
                      )),

            ListTile(
              title: Text('kwitansi',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              trailing: InkWell(
                onTap: () {},
                child: Text(
                  widget.respon['kwitansi'],
                  style: TextStyle(fontSize: 14, color: Colors.blue[800]),
                ),
              ),
            ),

            ListTile(
              title: Text('waktu',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              trailing: InkWell(
                onTap: () {},
                child: Text(
                  widget.respon['waktu'],
                  style: TextStyle(fontSize: 14, color: Colors.blue[800]),
                ),
              ),
            ),

            ListTile(
              title: Text('total belanja',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              trailing: InkWell(
                onTap: () {},
                child: Text(
                  rupiah(widget.totalHarga),
                  style: TextStyle(fontSize: 14, color: Colors.red[800]),
                ),
              ),
            ),
            // trailing: catatanPembeli != ' '
            //     ? InkWell(
            //         onTap: () {},
            //         child: Text(
            //           'Ubah',
            //           style: TextStyle(color: Colors.blue[800]),
            //         ),
            //       )
            //     : Container()
          ],
        ),
      ),
    );
  }
}
