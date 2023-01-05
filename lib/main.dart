import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/HomePage/BayarViaScanQR.dart';
import 'package:Edimu/UI/Contact/contact_page.dart';
import 'package:Edimu/UI/Contact/inbox_page.dart';
import 'package:Edimu/UI/Marketplace/marketplace_lokal_page.dart';
import 'package:Edimu/UI/Profil/profile_page.dart';
import 'package:Edimu/UI/Riwayat/transactoin_page.dart';
import 'package:Edimu/konfigurasi/KonfigurasiAplikasi.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:Edimu/root.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scoped_model/scoped_model.dart';
import 'UI/HomePage/home_page.dart';

// main yang asli
// void main() => runApp(MyApp());

// SSL config

class MyHttpOverrides extends HttpOverrides {

  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null).then((_) => runApp(MyApp()));
  // configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Warna.primary
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
          title: TemplateAplikasi.namaApp + ' - dari oleh untuk UMMAT',
          debugShowCheckedModeBanner: false,
          
          builder: EasyLoading.init(),
          routes: {
            '/': (BuildContext context) => root(_model),
            '/home_page': (BuildContext context) => homePage(_model),
            '/contact_page': (BuildContext context) => contactPage(_model),
            '/transaction_page': (BuildContext context) =>
                transactionPage(_model),
            // '/inbox_page': (BuildContext context) => inboxPage(_model),
            '/profile_page': (BuildContext context) => profilePage(_model),
            'marketplace_lokal': (BuildContext context) =>
                MarketPlace_Lokal_Page(_model),
            '/bayar_via_scanqr': (BuildContext context) => BayarViaScanQRPage()
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) => root(_model));
          },
          //home: root(_model)
        ));
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
