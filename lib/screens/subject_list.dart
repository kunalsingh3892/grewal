import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/api/data_list.dart';
import 'package:grewal/screens/chapters_list.dart';
import 'package:grewal/services/shared_preferences.dart';

class SubjectList extends StatefulWidget {
  String order_id;
  String user_id;
  String mobile;
  String email_id;
  String total_test;
  String payment;
  SubjectList(
      {this.mobile,
      this.email_id,
      this.order_id,
      this.payment,
      this.total_test,
      this.user_id});

  @override
  _SubjectListState createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextStyle normalText4 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.underline,
      color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextStyle normalText55 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  List data = [];
  List dataCopy = [];

  void seraching(String search) {
    List<Map<String, dynamic>> dummyListData = [];
    if (search.isNotEmpty) {
      dataCopy.forEach((item) {
        item.forEach((key, value) {
          if (value.toString().toLowerCase().contains(search)) {
            dummyListData.add(item);
          }
        });
      });
      setState(() {
        data.clear();
        data.addAll(dummyListData);
      });
    } else {
      setState(() {
        data.clear();
        data.addAll(dataCopy);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DataListOfSubjects().getSubjectsList().then((value) {
      if (value.length > 0) {
        setState(() {
          data.clear();
          dataCopy.clear();
          data.addAll(value);
          dataCopy.addAll(value);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: InkWell(
          child: Row(children: <Widget>[
            IconButton(
              icon: Image(
                image: AssetImage("assets/images/Icon.png"),
                height: 20.0,
                width: 10.0,
                color: Color(0xff2E2A4A),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ]),
        ),
        centerTitle: true,
        title: Container(
          child: Text("Subject Lists", style: normalText6),
        ),
        flexibleSpace: Container(
          height: 100,
          color: Color(0xffffffff),
        ),
        actions: <Widget>[
          /*Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: _networkImage1(
                profile_image,
              ),
            ),
          ),*/
        ],
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                enabled: true,
                decoration: InputDecoration(
                  fillColor: Color(0xfff9f9fb),
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Color(0xfff9f9fb),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Color(0xfff9f9fb),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Color(0xfff9f9fb),
                    ),
                  ),
                  counterText: "",
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Color(0xfff9f9fb),
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Color(0xfff9f9fb),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xff200E32),
                    size: 24,
                  ),
                  hintStyle: TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                  hintText: 'Search your chapters... ',
                ),
                style: TextStyle(
                  color: Colors.black,
                ),
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                textCapitalization: TextCapitalization.none,
                onChanged: (value) => seraching(value),
              ),
              flex: 1,
            ),
            Expanded(
              flex: 7,
              child: ListView(
                children: data
                    .map((e) => Card(
                          elevation: 8,
                          color: Colors.teal[100],
                          shadowColor: Colors.teal,
                          child: ListTile(
                            title: Text(
                              e['subject_name'].toString(),
                              style: normalText55,
                            ),
                            leading: Icon(Icons.article_outlined),
                            subtitle: Text("Term " + e['term'].toString()),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {},
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
