import 'package:flutter/material.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class bottomNavBar extends StatefulWidget {
  MainModel model;
  final int index;
  bottomNavBar(this.index, this.model);

  @override
  _bottomNavBarState createState() => _bottomNavBarState(index);
}

class _bottomNavBarState extends State<bottomNavBar> {
  int _selectedIndex;
  _bottomNavBarState(this._selectedIndex);

  final List<String> pageList = [
    '/home_page',
    '/contact_page',
    // '/bayar_via_scanqr',
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
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Warna.primary,
      //showSelectedLabels: false,
      // showUnselectedLabels: false,
      elevation: 5,
      //iconSize: 30,
      selectedIconTheme: IconThemeData(
        size: 35,
      ),
      unselectedIconTheme: IconThemeData(color: Colors.grey),

      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.perm_contact_calendar),
          label: 'Kontak',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.compare_arrows),
          label: 'Transaksi',
        ),
//        BottomNavigationBarItem(
//          icon: Icon(Icons.mail),
//          label: Text('Inbox'),
//        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      currentIndex: _selectedIndex,

      onTap: _onItemTapped,
    );
  }
}
