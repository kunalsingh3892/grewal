import 'package:servicestack/servicestack.dart';
import 'dart:convert';

class XMLJSON implements IConvertible{
  String question;
  String answer;
  String time_taken;

  XMLJSON(
      {
        this.question,
        this.answer,
        this.time_taken,

      });

  XMLJSON.fromJson(Map<String, dynamic> json)
  {
    fromMap(json);
  }

  fromMap(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
    time_taken = json['time_taken'];
    return this;
  }

  Map<String, dynamic> toJson() =>{
    'question' : question,
    'answer' :answer,
    'time_taken' :time_taken
  };

  @override
  TypeContext context;

}