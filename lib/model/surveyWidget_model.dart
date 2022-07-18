import 'package:flutter/cupertino.dart';

class SurveyWidget {

  Widget question;
  List<Widget> answerList;
  String choice;
  Widget button;

  SurveyWidget(this.question, this.answerList, this.choice, this.button){
    this.question = question;
    this.answerList = answerList;
    this.choice = choice;
    this.button = button;
  }

}