import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRadioWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String groupName;
  final ValueChanged<T> onChanged;
  final double width;
  final double height;
  final Color color;

  CustomRadioWidget(
      {this.value,
      this.groupValue,
      this.groupName,
      this.onChanged,
      this.width = 16,
      this.height = 16,
      this.color});

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(this.value);
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 8),
        width: MediaQuery.of(context).size.width * 0.80,
        decoration: BoxDecoration(
            color: value == groupValue ? Color(0xff51DEA0) : Color(0xffF9F9FB),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              height: this.height,
              width: this.width,
              decoration: new BoxDecoration(
                border: new Border.all(
                    width: 0,
                    color: value == groupValue
                        ? Color(0xff51DEA0)
                        : Color(0xffF9F9FB)),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(15.0)),
              ),
              child: Center(
                child: Container(
                  height: this.height - 0,
                  width: this.width - 0,
                  decoration: ShapeDecoration(
                    // color:value == groupValue? Color(0xff51DEA0):Color(0xffF9F9FB) ,
                    shape: CircleBorder(),
                    gradient: LinearGradient(
                      colors: value == groupValue
                          ? [
                              Color(0xff51DEA0),
                              Color(0xff51DEA0),
                            ]
                          : [
                              Theme.of(context).scaffoldBackgroundColor,
                              Theme.of(context).scaffoldBackgroundColor,
                            ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          /*this.groupName.contains('&')
              ?*/
          Flexible(
            child: Html(
              data: this.groupName,
              style: {
                "table": Style(
                  backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                ),
                "tr": Style(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                "th": Style(
                  padding: EdgeInsets.all(6),
                  backgroundColor: Colors.grey,
                ),
                "td": Style(
                  padding: EdgeInsets.all(6),
                  alignment: Alignment.topLeft,
                ),
                'h5': Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
              },
            ),
          )
          /*: Expanded(
                  child: Text(this.groupName,
                      maxLines: 100,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: normalText5),
                ),*/
        ]),
      ),
    );
  }
}
