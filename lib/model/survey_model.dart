import 'package:flutter/cupertino.dart';

class Survey {

  String surveyName;
  String description;
  List<Question> question;

  Survey(this.surveyName, this.description, this.question){
    this.surveyName = surveyName;
    this.description = description;
    this.question = question;
  }

}

class Question {
  String questionName;
  List<String> answerList;
  String choice;

  Question(this.questionName, this.answerList, this.choice){
    this.questionName = questionName;
    this.answerList = answerList;
    this.choice = choice;
  }

}