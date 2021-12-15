import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';


class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _value = false;

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
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
              onPressed: (){
                Navigator.pushNamed(context, '/dashboard');
              },
            ),

          ]),
        ),
        centerTitle: true,
        title:  Container(
          child: Text("Settings", style: normalText6),
        ),
        flexibleSpace: Container(
          height: 100,
          color: Color(0xffffffff),
        ),
        actions: <Widget>[
          /* IconButton(
                icon: const Icon(Icons.power_settings_new),
                onPressed: () async {
                //  _logoutPop();
                  Navigator.pushNamed(context, '/qr-code');
                },
              ),*/
        ],
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(

        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/update-profile');
              },
              child: ListTile(
                trailing: Image(
                    image: AssetImage("assets/images/arrow_next.png"),
                    height: 12.0,
                   ),
                title: Text(
                 "Edit Profile",
                  style: normalText5,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/change-password');
              },
              child: ListTile(
                trailing: Image(
                  image: AssetImage("assets/images/arrow_next.png"),
                  height: 12.0,
                ),
                title: Text(
                  "Change Password",
                  style: normalText5,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            /*ListTile(
              trailing: Image(
                image: AssetImage("assets/images/arrow_next.png"),
                height: 12.0,
              ),
              title: Text(
                "Upgrade Plan",
                style: normalText5,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            ListTile(
              trailing: Image(
                image: AssetImage("assets/images/arrow_next.png"),
                height: 12.0,
              ),
              title: Text(
                "Download Receipt",
                style: normalText5,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            ListTile(
              trailing: Image(
                image: AssetImage("assets/images/arrow_next.png"),
                height: 12.0,
              ),
              title: Text(
                "Invite Friends",
                style: normalText5,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),*/
          ],
        ),
      ),
    );
  }
}
