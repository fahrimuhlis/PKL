import 'package:flutter/material.dart';
import 'package:Edimu/UI/BottomNavBar/bottomNavBar.dart';
import 'package:Edimu/UI/Transfer/transfer_page.dart';
import 'package:Edimu/models/contacts_model.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:scoped_model/scoped_model.dart';

class contactPage extends StatefulWidget {
  final MainModel model;

  contactPage(this.model);

  @override
  _contactPageState createState() => _contactPageState();
}

class _contactPageState extends State<contactPage> {
  // contactsList listContacts;
  contactsList masterContactList;

  List displayContactList = [];

  var searchController = TextEditingController();

  initState() {
    widget.model.getContacts();
    masterContactList = widget.model.listContacts;
    // listContacts = widget.model.listContacts;
    displayContactList = masterContactList.contactLists;
    //sorting contact alphabetically
    displayContactList.sort((a, b) => a.name.compareTo(b.name));
    super.initState();
  }

//  void getContact() {
//    listContacts = widget.model.listContacts;
//
//    //debugPrint("==========117==========");
//    ////debugPrint(displayContactList[0].username);
//    //debugPrint("==========117==========");
//  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text("no contacts"));

        if (!model.isLoad && displayContactList != null) {
          content = Scaffold(
            appBar: AppBar(
              title: Text('Kontak'),
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: Container(
              decoration: Warna.bgGradient(Warna.warnaTunai),
              child: ListView(
                // shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: TextField(
                      onChanged: (text) {
                        text = text.toLowerCase();

                        setState(() {
                          bool isAngka = apakahAngka(text);

                          if (isAngka) {
                            //debugPrint("adalah ANGKA");
                            //coba angka rekening
                            displayContactList =
                                masterContactList.contactLists.where((contact) {
                              var rekening =
                                  contact.id.toString().toLowerCase();

                              return rekening.contains(text.toLowerCase());
                            }).toList();
                          } else {
                            //debugPrint("adalah HURUF");
                            //  udah bisa
                            displayContactList =
                                masterContactList.contactLists.where((contact) {
                              var nama = contact.name.toLowerCase();
                              return nama.contains(text);
                            }).toList();
                          }
                        });
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Cari nama",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.95,
                    child: ListView.builder(
                        // physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: displayContactList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(displayContactList[index].name),
                            subtitle: Text(
                              displayContactList[index].id,
                              style: TextStyle(color: Colors.blue),
                            ),
                            onTap: () {},
                            //trailing: Text(displayContactList[index].name),
                            trailing: IconButton(
                              //icon: Icon(Icons.send),
                              icon: Image.asset(
                                "lib/assets/transfer@contact.png",
                                width: 40,
                                height: 40,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => transferPage(
                                            model,
                                            userName:
                                                displayContactList[index].id,
                                          )),
                                );
                              },
                            ),
                          );
                        }),
                  ),
                  Container(
                    height: 175,
                    color: Colors.blue,
                  )
                ],
              ),
            ),
            bottomNavigationBar: bottomNavBar(1, widget.model),
          );
        } else {
          content = Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return content;
      },
    );
  }

  //cek inputan apakah angka semua
  apakahAngka(String str) {
    // int.parse(str, onError: (e) => null);

    if (str == null) {
      return false;
    } else {
      return int.tryParse(str) != null;
    }
  }
}
