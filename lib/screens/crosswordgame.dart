import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grewal/api/data_list.dart';

class CrossWordGame extends StatefulWidget {
  @override
  _CrossWordGameState createState() => _CrossWordGameState();
}

class _CrossWordGameState extends State<CrossWordGame> {
  List crossWordMatrix = [];
  int matrixLength = 0;
  List questionData = [];
  List indexingArray = [];
  List across = [];
  List down = [];
  bool isLoading = true;
  int row = 0;
  int col = 0;
  bool finalSubmission = false;

  List correctAnswer = [];
  List incorrectAnswer = [];

  void findMissingIndex(List data) {
    data.forEach((element) {
      String val = element['answer'].toString();
      int startIndex = int.parse(element['start_index'].toString());
      bool type = element['type'] == "ACROSS" ? true : false;

      if (type) {
        setState(() {
          across.add(element);
        });
        for (var i = 0; i < val.length; i++) {
          if (i == 0) {
            indexingArray[startIndex]['active'] = true;
            indexingArray[startIndex]['answer'] = val[i].toString();
            indexingArray[startIndex]['start_index'] = element['id'].toString();
            indexingArray[startIndex]['direction'] = "ACROSS";
          } else {
            indexingArray[startIndex + i]['active'] = true;
            indexingArray[startIndex + i]['answer'] = val[i].toString();
            indexingArray[startIndex + i]['direction'] = "ACROSS";
          }
        }
      } else {
        setState(() {
          down.add(element);
        });
        int changeIndex = startIndex;
        for (var i = 0; i < val.length; i++) {
          if (i == 0) {
            indexingArray[startIndex]['active'] = true;
            indexingArray[startIndex]['answer'] = val[i].toString();
            indexingArray[startIndex]['start_index'] = element['id'].toString();
            indexingArray[startIndex]['direction'] = "DOWN";
          } else {
            changeIndex = changeIndex + col;
            indexingArray[changeIndex]['answer'] = val[i].toString();
            indexingArray[changeIndex]['active'] = true;
            indexingArray[changeIndex]['direction'] = "DOWN";
          }
        }
      }
    });
    print(indexingArray[0]);
    print(indexingArray[1]);
    print(indexingArray[2]);
    print(indexingArray[3]);
  }

  void checkAnswer(List data) {
    indexingArray.forEach((element) {
      if (element['active']) {
        print(element['input'].toString() + "-" + element['answer'].toString());
        if (element['input'].toString() == element['answer'].toString()) {
          element['correct'] = true;
        } else {
          element['correct'] = false;
        }
      }
    });
    setState(() {
      finalSubmission = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DataListOfSubjects().crossWordGameData().then((value) {
      setState(() {
        questionData.addAll(value['data']);
        matrixLength = int.parse(value['row'].toString()) *
            int.parse(value['col'].toString());
        for (var i = 0; i < matrixLength; i++) {
          indexingArray.add({
            "active": false,
            "input": "",
            "start_index": "",
            "answer": "",
            "direction": ""
          });
        }
        row = int.parse(value['row']);
        col = int.parse(value['col']);

        findMissingIndex(questionData);
        isLoading = false;
      });
    });
  }

  final FocusScopeNode _node = new FocusScopeNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Game"),
          actions: [
            TextButton.icon(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  checkAnswer(indexingArray);
                },
                icon: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
                label: Text("FINISH", style: TextStyle(color: Colors.white)))
          ],
        ),
        body: isLoading
            ? Center(
                child: Text("Game Loading..."),
              )
            : Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: GridView.count(
                        padding: EdgeInsets.all(8),
                        physics: ClampingScrollPhysics(),
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                        primary: true,
                        crossAxisCount: col,
                        scrollDirection: Axis.vertical,
                        children: indexingArray.map((e) {
                          if (e['active']) {
                            return FocusScope(
                              node: _node,
                              child: Container(
                                child: TextFormField(
                                    // initialValue: e['answer'].toString(),
                                    maxLength: 1,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      new FilteringTextInputFormatter.allow(
                                          RegExp("[A-Z0-9]")),
                                    ],
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        e['direction'] == "ACROSS"
                                            ? _node.focusInDirection(
                                                TraversalDirection.right)
                                            : _node.focusInDirection(
                                                TraversalDirection.down);
                                        setState(() {
                                          e['input'] = value;
                                        });
                                      }
                                    },
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      filled: finalSubmission ? true : false,
                                      fillColor: finalSubmission
                                          ? e['correct']
                                              ? Colors.green[100]
                                              : Colors.red[100]
                                          : Colors.transparent,
                                      contentPadding: EdgeInsets.all(0),
                                      labelText: e['start_index'].toString(),
                                      labelStyle: TextStyle(
                                        color: Colors.red,
                                        backgroundColor: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    )),
                              ),
                            );
                          } else {
                            return Container(
                              color: Colors.black,
                            );
                          }
                        }).toList()),
                  ),
                  Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      "ACROSS",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    children: across.map((e) {
                                      return ListTile(
                                        minLeadingWidth: 1,
                                        leading: Text(
                                          e['id'].toString() + ". ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        title: Text(e['question'].toString()),
                                        subtitle: finalSubmission
                                            ? Text(
                                                "Ans : " + e['answer'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              )
                                            : Text(""),
                                      );
                                    }).toList(),
                                  ),
                                  Divider(thickness: 2),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      "DOWN",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    children: down.map((e) {
                                      return ListTile(
                                        minLeadingWidth: 1,
                                        leading: Text(
                                          e['id'].toString() + ". ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        title: Text(e['question'].toString()),
                                        subtitle: finalSubmission
                                            ? Text(
                                                "Ans : " + e['answer'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              )
                                            : Text(""),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ));
  }
}
