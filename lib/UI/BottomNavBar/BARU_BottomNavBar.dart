import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BottomBarBaru extends StatefulWidget {
  MainModel model;
  int index;
  //
  BottomBarBaru(this.model, this.index);

  @override
  _BottomBarBaruState createState() => _BottomBarBaruState(index);
}

class _BottomBarBaruState extends State<BottomBarBaru> {
  int _selectedIndex;
  _BottomBarBaruState(this._selectedIndex);

  final List<String> pageList = [
    '/home_page',
    '/contact_page',
    '/bayar_via_scanqr',
    '/transaction_page',
    '/profile_page',
  ];

  void _onItemTapped(int index) {
    if (!widget.model.sudahVerifikasi && index == 1) {
      Alert(
          type: AlertType.info,
          context: context,
          closeFunction: () {},
          title: "Silahkan VERIFIKASI akun anda",
          desc: "Akun anda belum terverifikasi",
          content: Container(
              padding: EdgeInsets.only(top: 25),
              child: Column(
                children: [
                  InkWell(
                    child: Text('Lain kali',
                        style: TextStyle(
                            color: Colors.grey[600],
                            decoration: TextDecoration.underline)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )),
          buttons: [
            DialogButton(
              child: Text('Verifikasi sekarang',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {},
            )
          ]).show();
    } else {
      setState(() {
        _selectedIndex = index;
        Navigator.pushReplacementNamed(context, pageList[index]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      height: 65,
      backgroundColor: Warna.primary,
      style: TabStyle.fixedCircle,
      items: [
        TabItem(icon: Icons.home, title: "Beranda"),
        TabItem(icon: Icons.perm_contact_calendar, title: "Kontak"),
        TabItem(
          icon: Icons.qr_code_scanner_sharp,
        ),
        TabItem(icon: Icons.compare_arrows_outlined, title: "Riwayat"),
        TabItem(icon: Icons.person, title: "Profil"),
      ],
      initialActiveIndex: 0,
      onTap: (int i) {
        print("isi i = $i");
        _onItemTapped(i);
      },
    );
  }
}
