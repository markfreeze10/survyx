import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/fa6_solid.dart';
import 'package:iconify_flutter/icons/foundation.dart';
import 'package:iconify_flutter/icons/wpf.dart';
import 'package:umfrage/screens/base.dart';
import 'package:umfrage/services/databaseService.dart';

class PostboxBase extends StatefulWidget {
  const PostboxBase({Key? key}) : super(key: key);

  @override
  State<PostboxBase> createState() => _PostboxBaseState();
}

class _PostboxBaseState extends State<PostboxBase> {

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool firstRun = true;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    double hSize = MediaQuery.of(context).size.height;
    double wSize = MediaQuery.of(context).size.width;
    final User? user = auth.currentUser;

    return SafeArea(child: Scaffold(
        backgroundColor: Color(0xff2D2D2D),
    body: SizedBox(child: Padding(
        padding: EdgeInsets.only(
            top: hSize*0.07, left: 20, right: 20, bottom: 0),
        child: Column( children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
            text: const TextSpan(
            style: TextStyle(fontSize: 30, color: Colors.white,
            fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: 'Post',
                    style: TextStyle(decoration: TextDecoration.underline,
                        decorationThickness: 0.7,
                        decorationColor: Color(0xff34D1C2)
                    )),
                TextSpan(
                    text: 'fach',
              )]))]),
          Padding(padding: EdgeInsets.only(top: 40, left: 0, right: 0, bottom: 0),
          child:
            Container(
            height: hSize*0.6,
            width: wSize*0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
                color: Color(0xff4c5051)
            ),
              child: FutureBuilder<Object?>(
                  future: DatabaseService().getParticipationUID(auth, user!),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {

                    if (!snapshot.hasData) {
                      return Text("Something went wrong");
                    }

                    final list = snapshot.data;

                    return (list.length == 0) ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Text("Es befindet sich keine Umfrage in ihrem Postfach",
                              style: TextStyle(color: Colors.white)),
                        )) : ListView.builder(
                  itemCount: list.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context,int index) {
                      return FutureBuilder<Map?>(
                        future: DatabaseService().getSurveyMap(list[index]),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text("Something went wrong");
                          }
                          Map? data = snapshot.data;
                          return Column(children: [
                            ListTile(
                                title: Text(data!["name"]),
                                subtitle: Text(""),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PostSurveyOverview(),
                                      settings: RouteSettings(arguments: list[index])));
                                },
                                textColor: Colors.white),
                            Divider(
                              color: Colors.white,
                            )]);
                        });
                      });
                }))),
          const Spacer(),
          Container(
              alignment: Alignment.bottomLeft,
              child: Padding(padding: const EdgeInsets.only(
              top: 0, left: 0, right: 0, bottom: 20),
          child: Ink(//
              decoration: const ShapeDecoration(
                color: Color(0xff8a8a8a),
                shape: CircleBorder(),
              ),
              child: IconButton(
                color: Colors.white,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BaseScreen()));
          }, icon: const Icon(Icons.arrow_back_rounded) ))))])))));
  }
}

class PostSurveyOverview extends StatefulWidget {
  const PostSurveyOverview({Key? key}) : super(key: key);

  @override
  State<PostSurveyOverview> createState() => _PostSurveyOverviewState();
}

class _PostSurveyOverviewState extends State<PostSurveyOverview> {

  @override
  Widget build(BuildContext context) {

    double hSize = MediaQuery.of(context).size.height;
    double wSize = MediaQuery.of(context).size.width;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    //aktuelle surveyID aus der Collection "survey"
    //weitergegeben durch Anklicken der jeweiligen Umfrage
    var surveyID = ModalRoute.of(context)!.settings.arguments as String;

    return SafeArea(child:
      Scaffold(
        backgroundColor: Color(0xff2D2D2D),
        body: SizedBox(child: Padding(
        padding: EdgeInsets.only(
        top: hSize*0.07, left: 20, right: 20, bottom: 0),
        child: Column(
            children: [
              FutureBuilder<Map?>(
                future: DatabaseService().getSurveyMap(surveyID),
                  builder: (context, snapshot){
                    if (!snapshot.hasData) {
                      return Text("Something went wrong");
                    }
                  final map = snapshot.data!;
                    return Column(children: [Padding(
                        padding: const EdgeInsets.only(
                            top: 40, left: 20, right: 20, bottom: 0),
                        child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xff4C5051),
                              borderRadius: BorderRadius.all(Radius.circular(14.0)),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 0, right: 0, bottom: 20),
                                child: Center(
                                    child: Text(map["name"],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)))))),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 60, left: 20, right: 20, bottom: 0),
                          child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xff4C5051),
                                borderRadius: BorderRadius.all(Radius.circular(14.0)),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 0, right: 0, bottom: 20),
                                  child: Center(
                                    child: Text(map["description"],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))))))]);
                  }),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 50),
                  child: Container(
                      height: 70.0,
                      child: ElevatedButton(
                          onPressed: () {
                            DatabaseService().addParticipation(user!, surveyID);
                            DatabaseService().setStartedTrue(user, surveyID);

                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PostSurveyStart(),
                                settings: RouteSettings(arguments: surveyID)));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                          ),
                          child: Ink(
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Color(0xff34D1C2), Color(0xff4D7DDC)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14.0)
                              ),
                              child: Container(
                                //constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: const Expanded(
                                      child: Text("Umfrage starten",
                                          style: TextStyle(color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)))))))),
              Container(
                  alignment: Alignment.bottomLeft,
                  child: Padding(padding: const EdgeInsets.only(
                      top: 0, left: 0, right: 0, bottom: 20),
                      child: Ink(//
                          decoration: const ShapeDecoration(
                            color: Color(0xff8a8a8a),
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                              color: Colors.white,
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const PostboxBase()));
                              },
                              icon:  Icon(Icons.arrow_back_rounded) ))))])))));
  }
}

class PostSurveyStart extends StatefulWidget {
  const PostSurveyStart({Key? key}) : super(key: key);

  @override
  State<PostSurveyStart> createState() => _PostSurveyStartState();
}

class _PostSurveyStartState extends State<PostSurveyStart> {

  bool isChecked = false;
  bool mapCreated = false;
  Map<String, Map<String, bool>> saveMap = {};

  String lastTrueElement = "empty";
  int pageCounter = 0;
  String tempStr = "";

  @override
  void initState() {
    super.initState();
  }

  List<Widget> createQuestionWidget (Map<dynamic,dynamic>? map, double hSize, User user, Map<dynamic, dynamic> participMap, String surveyID) {

    List<Widget> list = [];
    list.add(Padding(padding: EdgeInsets.only(
        top: hSize*0.07, left: 20, right: 20, bottom: 20),
      child: Text((pageCounter+1).toString()+". "+map?.entries.elementAt(pageCounter).value["name"],
          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold))));


    //map -> {aDkejhkdd : answers[antwort: false, antwort2: false], name: "", choice: "SINGLE_CHOICE"}
    map?.entries.elementAt(pageCounter).value["answers"].forEach((answer, count) {
      String choice = map?.entries.elementAt(pageCounter).value["choice"];
      if (choice == "SINGLE_CHOICE") {
        participMap["answers"][map.entries.elementAt(pageCounter).value["name"]].forEach((key, value) {
          if(value){
            lastTrueElement = key;
          }
        });
      }


      list.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: Text(answer.toString(), style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold))),
            Checkbox(
                value: participMap["answers"][map.entries.elementAt(pageCounter).value["name"]][answer],
                onChanged: (value) {

                  setState(() {
                    if(choice == "SINGLE_CHOICE") {
                      if(value == true) {
                        if (lastTrueElement != "empty") {

                          participMap["answers"][map.entries
                              .elementAt(pageCounter)
                              .value["name"]][lastTrueElement] = false;

                          FirebaseFirestore.instance.collection("survey").doc(
                              surveyID).collection("question")
                              .doc(map.entries
                              .elementAt(pageCounter)
                              .key)
                              .update({
                            'answers.$lastTrueElement': FieldValue.increment(-1)
                          });
                          FirebaseFirestore.instance.collection("survey").doc(surveyID).collection("question")
                              .doc(map.entries.elementAt(pageCounter).key)
                              .update({'answers.$answer': FieldValue.increment(1)});

                        } else {
                          FirebaseFirestore.instance.collection("survey").doc(surveyID).collection("question")
                              .doc(map.entries.elementAt(pageCounter).key)
                              .update({'answers.$answer': FieldValue.increment(1)});
                        }
                        lastTrueElement = answer;
                      } else {

                        FirebaseFirestore.instance.collection("survey").doc(
                            surveyID).collection("question")
                            .doc(map.entries
                            .elementAt(pageCounter)
                            .key)
                            .update({
                          'answers.$answer': FieldValue.increment(-1)
                        });
                        lastTrueElement = "empty";
                      }

                    } else {
                      if(value==true) {
                        FirebaseFirestore.instance.collection("survey").doc(surveyID).collection("question")
                            .doc(map.entries.elementAt(pageCounter).key)
                            .update({'answers.$answer': FieldValue.increment(1)});
                      } else {
                        FirebaseFirestore.instance.collection("survey").doc(surveyID).collection("question")
                            .doc(map.entries.elementAt(pageCounter).key)
                            .update({'answers.$answer': FieldValue.increment(-1)});
                        lastTrueElement = "empty";
                      }
                    }
                    participMap["answers"][map.entries.elementAt(pageCounter).value["name"]][answer] = value;



                      //'answers' muss die ganze Liste der Fragen bekommen, und element: muss die komplette Liste übergeben bekommen mit true und false Werten
                      FirebaseFirestore.instance.collection("participation").doc(user.uid).collection("answerList")
                          .doc(surveyID).update({'answers': participMap["answers"]});
                    });
                })
          ]));
    });

    list.add((Container(
        height: 100,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [ElevatedButton(
              style: ElevatedButton.styleFrom(
              // Foreground color 0xff34D1C2  0xff4D7DDC
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              primary: Color(0xff34D1C2),
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
              onPressed: (pageCounter == 0) ? null : () {
                if(pageCounter>0){
                  setState(() {
                    pageCounter--;
                  });
                }},
              child: const Icon(Icons.arrow_back_ios_outlined),
            ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                primary: Color(0xff34D1C2),
                  ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                onPressed: () {
                  lastTrueElement = "empty";
                  if(pageCounter+1 != map?.length){

                    setState(() {
                      pageCounter++;
                    });
                  } else {
                    FirebaseFirestore.instance.collection("participation").doc(user.uid).collection("answerList").doc(surveyID).update({'finished': true});
                    FirebaseFirestore.instance.collection("participation").doc(user.uid).collection("answerList").doc(surveyID).update({'time': DateTime.now()});
                    FirebaseFirestore.instance.collection("survey").doc(surveyID).update({'countFinished': FieldValue.increment(1)});

                    var removeArray = [];
                    removeArray.add(surveyID);
                    FirebaseFirestore.instance.collection("participation").doc(user.uid).update({'surveyID': FieldValue.arrayRemove(removeArray)});
                    FirebaseFirestore.instance.collection("userdata").doc(user.uid).update({'answeredSurveys': FieldValue.arrayUnion(removeArray)});

                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PostboxBase()));
                  }
                },
                child: (pageCounter + 1 == map?.length) ? const Icon(Icons.check) : const Icon(Icons.arrow_forward_ios_outlined)),
              ]))));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    double hSize = MediaQuery.of(context).size.height;
    var surveyID = ModalRoute.of(context)!.settings.arguments as String;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return SafeArea(child: Scaffold(
        backgroundColor: Color(0xff2D2D2D),
        body: Container(child: Padding(padding: const EdgeInsets.only(
          top: 0, left: 20, right: 0, bottom: 20),child: Column(children:[
          FutureBuilder<Map?>(
            future: DatabaseService().getSurveyQuestions(surveyID),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("Something went wrong");
              }
              final map = snapshot.data;
              return FutureBuilder<Map?>(
                  future: DatabaseService().getParticipantsQuestions(user!, surveyID),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Something went wrong");
                    }
                    final participleMap = snapshot.data;
                    return SingleChildScrollView(
                      child: Column(
                      children: createQuestionWidget(map, hSize, user, participleMap!, surveyID)
                    ));
                  });
              }),
            Spacer(),
            Container(
                alignment: Alignment.bottomLeft,
                child: Padding(padding: const EdgeInsets.only(
                    top: 0, left: 0, right: 0, bottom: 0),
                    child: Ink(//
                        decoration: const ShapeDecoration(
                          color: Color(0xff8a8a8a),
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                            color: Colors.white,
                            onPressed: (){
                              //DatabaseService().resetAnswers(user!, surveyID);
                              Navigator.pop(context);

                            },
                            icon: const Icon(Icons.arrow_back_rounded) ))))]
          )))));

  }
}

