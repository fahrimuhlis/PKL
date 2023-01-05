import 'package:flutter_easyloading/flutter_easyloading.dart';

class EdimuLoading {
  static munculkan() {
    EasyLoading.show(
      status: 'sedang diproses',
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );
  }

  static tutup() {
    EasyLoading.dismiss();
  }
}
