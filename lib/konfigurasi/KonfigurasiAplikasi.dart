//
//  UBAH PACKAGE NAME:
//  Cara ke-1:
//  jalanin : flutter pub run change_app_package_name:main com.namapackage.namaapp
//
// - Cara ke-2:
// - ubah package di 3 tempat :
//  1. android/app/src/main/androidmanifest.xml
//  2. android/app/src/debug/androidmanifest.xml
//  3. android/app/src/profile/androidmanifest.xml
// - ubah "package" di masing2 tsb menjadi unique & sama (sesuai nama app)
// - di ubah juga di android/app/src/main/androidmanifest.xml android:label di baris ke-18 menjadi nama app yang di.tuju
//
//
//
class TemplateAplikasi {
  static String namaApp = "ediMU";
  static String publicDomain = "https://test.edimu.live/";
  static String apiDomain = publicDomain + "api/";
  //
}
