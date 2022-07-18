import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconify_flutter/icons/healthicons.dart';
import 'package:umfrage/model/surveyWidget_model.dart';

class DatabaseService {

  final CollectionReference surveyCollection = FirebaseFirestore.instance.collection("survey");
  final CollectionReference participationCollection = FirebaseFirestore.instance.collection("participation");
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("userdata");

  Future<void> addSurvey(List<TextEditingController> questionList, List<List<TextEditingController>> answerList, String name, String description, Map<int, SurveyWidget> questionMap, FirebaseAuth auth, User user) async{
    var result = await surveyCollection.add({
      'name': name,
      'description': description,
      'creationTime': DateTime.now(),
      'receiverList': [],
      'countStarted': 0,
      'countFinished': 0
    });
    Map<String, int> tempList = {};
    print(questionList.length);
    print(answerList.length);
    for(int i = 0; i<questionList.length; i++){
      for (var element in answerList.elementAt(i)) {
        print(i);
        print(element.text);
        tempList[element.text] = 0;
      }
      surveyCollection.doc(result.id).collection('question').add({
        'answers': tempList,
        'choice': questionMap[i]!.choice,
        'name': questionList[i].text
      });
      tempList.clear();
    }
    List<String> resultList = [result.id];
    userCollection.doc(user.uid).update({
      'createdSurveys': FieldValue.arrayUnion(resultList)
    });
  }

  Future<Map<dynamic,dynamic>?> getSurveyMap(String surveyID) async {
    Map? surveyData = (await surveyCollection.doc(surveyID).get()).data() as Map<dynamic, dynamic>;
    return surveyData;
  }

  Future<String?> getSurveyName(String surveyID) async {
    String? surveyData = (await surveyCollection.doc(surveyID).get()).get("name") as String?;
    return surveyData;
  }



  Future<Map<dynamic,dynamic>?> getSurveyQuestionsOnlyAnswers(String surveyID) async {
    var surveyData = (await surveyCollection.doc(surveyID).collection("question").get()).docs;
    var surveyMap = {};
    var tempMap = {};
    surveyData.forEach((element) {
      element["answers"].forEach((element){
        tempMap[element] = false;
      });
      surveyMap[element["name"]] = tempMap;
    });
    return surveyMap;
  }

  Future<Map<dynamic,dynamic>?> getSurveyQuestions(String surveyID) async {
    var surveyData = (await surveyCollection.doc(surveyID).collection("question").get()).docs;
    var surveyMap = {};
    surveyData.forEach((element) {
      //print(element.id);
      //print(element.data());
      surveyMap[element.id]=element.data();
    });
    return surveyMap;
  }

  Future<Map<dynamic,dynamic>?> getParticipantsQuestions(User user, String surveyID) async {
    var surveyData = (await participationCollection.doc(user.uid).collection("answerList").doc(surveyID).get()).data();
    return surveyData;
  }

  Future<void> changeBool(User user, String surveyID, bool value) async {
    var surveyData = (await participationCollection.doc(user.uid).collection("answerList").doc(surveyID).update({'answers': value}));

  }

  Future <Object?> getParticipationUID(FirebaseAuth auth, User user) async {
    final list = (await participationCollection.doc(user.uid).get()).get('surveyID');
    return list;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getQuestions(String surveyID) async {
    final surveyData = (await surveyCollection.doc(surveyID).collection("question").get()).docs;
    return surveyData;
  }

  Future<int?> getOpenSurveys(User user) async {
    final surveyData =  (await FirebaseFirestore.instance.collection('participation').doc(user.uid).get()).get("surveyID");
    return surveyData.length;
  }

  Future<bool> startSurvey(FirebaseAuth auth, User user, String surveyID) async {
    QuerySnapshot querySnapshot = await participationCollection.get();
    final allData = querySnapshot.docs.where((element) => element.id == user?.uid).map((doc) => doc.data());
    return false;
  }

  //Antworten aus Survey holen und alle auf false setzen in der Map
  Future<void> addParticipation(User user, String surveyID) async {

    var surveyData = (await participationCollection.doc(user.uid).collection("answerList").get()).docs;
    bool existingID = false;

    surveyData.forEach((element) {
      if(element.id == surveyID) {
        existingID = true;
      }
    });

    //wenn die ID nicht in den Dokumenten ist, dann...
    Map<dynamic, dynamic>? surveyMap = await getSurveyQuestionsOnlyAnswers(surveyID) as Map?;
    if(!existingID){
      participationCollection.doc(user.uid).collection("answerList").doc(
          surveyID).set({'finished': false,
        'time': DateTime.now(),
        'answers' : surveyMap
      }).then((_) => print('Added'))
          .catchError((error) =>
          print('Add failed: $error'));
      //surveyData.where((element) => element.id == surveyID).forEach((element) {});
    }
  }

  Future<void> setStartedTrue(User user, String surveyID) async {
    participationCollection.doc(user!.uid).collection('answerList').doc(surveyID).update({'started': true});
  }


  Future<Object?> getAnsweredSurveys(User user) async {
    var surveyData = (await userCollection.doc(user.uid).get()).get("answeredSurveys");
    return surveyData;
  }


  Future<bool?> getBoolFromAnsweredSurveys(User user) async {
    var surveyData = (await userCollection.doc(user.uid).get()).get("answeredSurveys");
    if(surveyData.length==0) {
      return true;
    } else {
      return false;
    }
  }

  Future<Object?> getCreatedSurveys(User user) async {
    var surveyData = (await userCollection.doc(user.uid).get()).get("createdSurveys");
    return surveyData;

  }


  Future<void> resetAnswers(User user, String surveyID) async {
    Map<dynamic, dynamic>? data = (await participationCollection.doc(user.uid).collection("answerList").doc(surveyID).get()).get('answers') as Map;
    Map<dynamic, dynamic>? newMap = {};

    data.forEach((question, array) {
      Map<dynamic, dynamic>? answerMap = {};
      array.forEach((answer, bool) async {
        print(answer);
        answerMap[answer] = false;
        newMap[question] = answerMap;
        //await participationCollection.doc(user.uid).collection("answerList").doc(surveyID).update({'answers': {question : {answer: false}}});});
      });
    });
    await participationCollection.doc(user.uid).collection("answerList").doc(surveyID).update({'answers': newMap});

  }

  Future<int> countQuestions(String surveyID) async {
    return (await FirebaseFirestore.instance.collection("survey").doc(surveyID).collection('question').get()).docs.length;
  }

  Future<int> countReceiver(String surveyID) async {
    return (await FirebaseFirestore.instance.collection("survey").doc(surveyID).get()).get('receiverList').length;
  }

  Future<int> countStarted(String surveyID) async {
    return (await FirebaseFirestore.instance.collection("survey").doc(surveyID).get()).get('countStarted');
  }

  Future<int> countFinished(String surveyID) async {
    return (await FirebaseFirestore.instance.collection("survey").doc(surveyID).get()).get('countFinished');
  }

  Future<Map<String, dynamic>?> getEmails() async {
    return (await FirebaseFirestore.instance.collection("email").doc('emailMap').get()).data();
  }

/*
  //clicked on category
  Future<void> clickedCategory(String category)async{

    try{
      num clicks = (await questionCollection.doc(category).get()).data()["clicks"];

      await questionCollection.doc(category).update({
        "clicks": clicks+1,
      });}catch (e){
      print(e);
    }
  }

  //upvote question
  Future<void> upvote(String category, String questiontxt)async{

    try{
      List questions = (await questionCollection.doc(category).get()).data()["Fragen"].toList();
      int index = questions.indexWhere((element) => element["Text"]==questiontxt);
      Map questiondata = questions[index];
      questiondata["upvote"]+=1;
      questions[index]= questiondata;

      await questionCollection.doc(category).update({
        "Fragen": questions,
      });}catch (e){
      print(e);
    }
  }

  //upvote question
  Future<void> downvote(String category, String questiontxt)async{

    try{
      List questions = (await questionCollection.doc(category).get()).data()["Fragen"].toList();
      int index = questions.indexWhere((element) => element["Text"]==questiontxt);
      Map questiondata = questions[index];
      questiondata["downvote"]+=1;
      questions[index]= questiondata;


      await questionCollection.doc(category).update({
        "Fragen": questions,
      });}catch (e){
      print(e);
    }
  }

  //upvote question
  Future<String> getImpressum()async{

    return (await impressumCollection.doc("Impressum").get()).data()["Link"];

  }*/

}