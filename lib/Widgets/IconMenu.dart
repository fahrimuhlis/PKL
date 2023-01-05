import 'package:flutter/material.dart';
import 'package:universal_html/prefer_universal/js.dart';

class IconMenu extends StatelessWidget {

  String icon = "";
  String title = "";
  Widget page;

  IconMenu(this.icon, this.title, [this.page]);

  @override
  Widget build(BuildContext context) {
    return menuPembayaran(context, icon, title, page);
  }

   Widget menuPembayaran(BuildContext context, String icon, String title, [Widget page = null]) {
    return Opacity(
      opacity: page == null ? 0.3 : 1,
      child: Container(
        width: 80,
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(width: 50, child: Image(image: AssetImage(icon))),
              Container(
                width: 80,
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          onTap: () {
            if (page != null) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => page));
            }
          },
        ),
      ),
    );
  }

}