import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String icon;
  final String dot;
  final bool isSelected;
  final Function onTap;

  const TabItem({Key key, this.icon,this.dot, this.isSelected, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(icon,width: 16,height: 16,color: isSelected ? Color(0xff017EFF) : Colors.black,),
            Text(dot, style: TextStyle(color: isSelected ?Color(0xff017EFF):Colors.white,fontWeight: FontWeight.bold ))
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}