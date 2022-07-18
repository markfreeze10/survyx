import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/databaseService.dart';
import 'base.dart';

class CreatedSurveyBase extends StatefulWidget {
  const CreatedSurveyBase({Key? key}) : super(key: key);

  @override
  State<CreatedSurveyBase> createState() => _CreatedSurveyBaseState();
}

class _CreatedSurveyBaseState extends State<CreatedSurveyBase> {
  @override
  @override
  Widget build(BuildContext context) {

    double hSize = MediaQuery.of(context).size.height;
    double wSize = MediaQuery.of(context).size.width;
    final FirebaseAuth auth = FirebaseAuth.instance;
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
                  text: TextSpan(
                      style: TextStyle(fontSize: 30, color: Colors.white,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            style: TextStyle(fontSize: 30, color: Colors.white,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: 'Erst',
                                  style: TextStyle(decoration: TextDecoration.underline,
                                      decorationThickness: 0.7,
                                      decorationColor: Color(0xff34D1C2)
                                  )),
                              TextSpan(
                                text: 'ellte ',
                              )]),
                        TextSpan(
                            text: 'Umfragen '),
                      ]))]),
        Padding(padding: EdgeInsets.only(top: 40, left: 0, right: 0, bottom: 0),
          child: Container(
            height: hSize*0.6,
            width: wSize*0.9,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color(0xff4c5051)
          ),
          child: FutureBuilder<Object?>(
              future: DatabaseService().getCreatedSurveys(user!),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Text("Something went wrong");
                }
                final list = snapshot.data;
                return (list.length == 0) ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Text("Es wurde noch keine Umfrage erstellt.",
                          style: TextStyle(color: Colors.white)),
                    )) : ListView.builder(
                    itemCount: list.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context,int index) {
                      return Column(children: [
                        FutureBuilder<Object?>(
                            future: DatabaseService().getSurveyName(list[index]),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Text("Something went wrong");
                              }
                              final surveyString = snapshot.data;
                              return ListTile(
                                  title: Text(surveyString),
                                  //subtitle: Text((FirebaseFirestore.instance.collection("participation").doc(user.uid).collection("answerList").doc(listID[index]))),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatedSurveyOverview(), settings: RouteSettings(arguments: list[index])));
                                  },
                                  textColor: Colors.white);
                            }),
                        const Divider(
                          color: Colors.white,
                        )]);
                    });
              }))),
        Spacer(),
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

class CreatedSurveyOverview extends StatefulWidget {
  const CreatedSurveyOverview({Key? key}) : super(key: key);

  @override
  State<CreatedSurveyOverview> createState() => _CreatedSurveyOverviewState();
}

class _CreatedSurveyOverviewState extends State<CreatedSurveyOverview> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    double hSize = MediaQuery.of(context).size.height;
    double wSize = MediaQuery.of(context).size.width;
    final User? user = auth.currentUser;
    var surveyID = ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(child:
    Scaffold(
        backgroundColor: Color(0xff2D2D2D),
        body: SizedBox(child: Padding(
            padding: EdgeInsets.only(
                top: hSize*0.05, left: 20, right: 20, bottom: 0),
            child: Column(
                children: [
                  FutureBuilder<Map?>(
                      future: DatabaseService().getSurveyMap(surveyID),
                      builder: (context, snapshot){
                        if (!snapshot.hasData) {
                          return Text("Something went wrong");
                        }
                        final map = snapshot.data!;
                        final len = DatabaseService().countQuestions(surveyID).toString();
                        return Column(children: [
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(decoration: TextDecoration.underline,
                                      decorationThickness: 0.5,
                                      decorationColor: Color(0xff34D1C2),fontSize: 30, color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  text: map["name"])),
                          SizedBox(height: hSize*0.04),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(height: hSize*0.17, width: hSize*0.17,child: Ink(
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [Color(0xff34D1C2), Color(0xff4D7DDC)],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(14.0)
                                    ),
                                    child: FutureBuilder<int>(
                                      future: DatabaseService().countQuestions(surveyID),
                                      builder: (context, snapshot){
                                        if (!snapshot.hasData) {
                                          return Text("Something went wrong");
                                        }
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [Text(snapshot.data.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.white,
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold)),
                                            Text("\nFragen",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.white,
                                                    fontSize: 16))],
                                        );},
                                    ))),
                                Container(height: hSize*0.17, width: hSize*0.17,child: Ink(
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [Color(0xff34D1C2), Color(0xff4D7DDC)],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(14.0)
                                    ),
                                    child: FutureBuilder<int?>(
                                      future: DatabaseService().countReceiver(surveyID),
                                      builder: (context, snapshot){
                                        if (!snapshot.hasData) {
                                          return Text("Something went wrong");
                                        }
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [Text(snapshot.data!.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.white,
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold)),
                                            Text("\nTeilnehmer",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.white,
                                                    fontSize: 16))],
                                        );
                                      },
                                    ))),
                          ]),
                          Padding(padding: const EdgeInsets.only(
                              top: 30, left: 0, right: 0, bottom: 30),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(height: hSize*0.17, width: hSize*0.17,child: Ink(
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(colors: [Color(0xff34D1C2), Color(0xff4D7DDC)],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(14.0)
                                      ),
                                      child: FutureBuilder<int>(
                                        future: DatabaseService().countStarted(surveyID),
                                        builder: (context, snapshot){
                                          if (!snapshot.hasData) {
                                            return Text("Something went wrong");
                                          }
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [Text(snapshot.data.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.white,
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold)),
                                              Text("\ngestartet",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.white,
                                                      fontSize: 16))],
                                          );},
                                      ))),
                                  Container(height: hSize*0.17, width: hSize*0.17,child: Ink(
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(colors: [Color(0xff34D1C2), Color(0xff4D7DDC)],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(14.0)
                                      ),
                                      child: FutureBuilder<int>(
                                        future: DatabaseService().countFinished(surveyID),
                                        builder: (context, snapshot){
                                          if (!snapshot.hasData) {
                                            return Text("Something went wrong");
                                          }
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [Text(snapshot.data.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.white,
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold)),
                                              Text("\nabgeschlossen",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.white,
                                                      fontSize: 16))],
                                          );},
                                      ))),
                                ]),
                          ),
                        ]);
                      }),
                  SizedBox(
                    height: 50,
                    width: wSize*0.83,
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff4C5051)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)))
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatedSurveyResults(), settings: RouteSettings(arguments: surveyID)));
                        }, child:Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.info_outline,
                                size: 25.0),
                          ),
                          Center(
                            child: Text("Ergebnisse",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ])
                    ),
                  ),
                  SizedBox(height: hSize*0.02),
                    SizedBox(
                      height: 50,
                      width: wSize*0.83,
                      child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff4C5051)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)))
                          ),
                          onPressed: ()  {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => Form(
                                key: _formKey,
                                child: AlertDialog(
                                  title: Text('Email-Adresse eingeben'),
                                  actions: <Widget>[
                                FutureBuilder<Object?>(
                                    future: DatabaseService().getEmails(),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if(!snapshot.hasData){
                                    return Text("Something went wrong");
                                  }
                                  final emailMap = snapshot.data;

                                  List<String> listee= [];
                                  emailMap.keys.forEach((element) {
                                    listee.add(element);
                                  });

                                  return Container(
                                    height: 200,
                                    color: Colors.white,
                                    child: FutureBuilder<Object?>(
                                      future: DatabaseService().getQuestions(surveyID),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return Text("Something went wrong");
                                        }
                                        final dataa = snapshot.data;

                                        //FirebaseFirestore.instance.collection("email").doc('emailMap').get().
                                        return  Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: wSize*0.9,
                                              child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(0,0,0,20),
                                                  child: TextFormField(
                                                      controller: emailController,
                                                      validator: (value) {
                                                        if(user!.email == value) {
                                                          return ("Keine Umfragen an eigenes Profil");
                                                        } else if(!listee.contains(value)) {
                                                          return ("Email-Adresse nicht vorhanden");
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        emailController.text = value!;
                                                      },
                                                      style: const TextStyle(color: Color(0xff4C5051), fontSize: 18, fontWeight: FontWeight.bold),
                                                      decoration: const InputDecoration(
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Color(0xff4C5051)),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Color(0xff4C5051)),
                                                          ),
                                                          hintText: "E-Mail-Adresse",
                                                          hintStyle: TextStyle(color: Color(0xB34C5051), fontSize: 18, fontStyle: FontStyle.italic))
                                                  )
                                              ),
                                            ),
                                            SizedBox(
                                                height: 40,
                                                width: wSize*0.9,
                                                child: RaisedButton(
                                                    onPressed: () {
                                                      if (_formKey.currentState!.validate()) {
                                                        var survey = [];
                                                        survey.add(surveyID);
                                                        FirebaseFirestore.instance.collection("participation")
                                                            .doc(emailMap[emailController.text])
                                                            .update({'surveyID': FieldValue.arrayUnion(survey)
                                                        });
                                                        //FirebaseFirestore.instance.collection("participation").doc(user!.uid).collection('answerList').add({'answers': FieldValue.arrayUnion(survey),});
                                                        Map<String, Map<String, bool>> fullMap = {};

                                                        dataa.forEach((element) {
                                                          //Irgendwie ErrorHandling einbauen, dass keine Frage zwei mal vorhanden
                                                          Map<String, bool> tempMap = {};

                                                          element["answers"].keys.forEach((key) {
                                                            tempMap[key] = false;
                                                          });
                                                          fullMap[element["name"]] = tempMap;
                                                        });
                                                        FirebaseFirestore.instance.collection("participation")
                                                            .doc(emailMap[emailController.text])
                                                            .collection('answerList').doc(surveyID).set({
                                                          'answers': fullMap,
                                                          'started': false,
                                                          'finished': false,
                                                          'time': DateTime.utc(2000)
                                                        });
                                                        var userArray = [emailMap[emailController.text.trim()]];
                                                        FirebaseFirestore.instance.collection("survey")
                                                            .doc(surveyID).update({
                                                          'receiverList': FieldValue.arrayUnion(userArray)

                                                        });
                                                        setState(() {

                                                        });
                                                        userArray.clear();
                                                        survey.clear();
                                                        Navigator.pop(context, 'Cancel');
                                                      }
                                                    },
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                                    padding: EdgeInsets.all(0.0),
                                                    child: Ink(
                                                        height: 40,
                                                        width: wSize*0.95,
                                                        decoration: BoxDecoration(
                                                            gradient: const LinearGradient(colors: [Color(0xff34D1C2), Color(0xff4D7DDC)],
                                                              begin: Alignment.centerLeft,
                                                              end: Alignment.centerRight,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8.0)
                                                        ),
                                                        child: Stack(
                                                            children: const [
                                                              Padding(
                                                                padding: EdgeInsets.only(left: 18.0),
                                                                child: Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Icon(Icons.send_outlined,
                                                                      color: Colors.white,
                                                                      size: 25.0),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Text("Versenden",
                                                                    style: TextStyle(color: Colors.white,
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.bold)),
                                                              ),
                                                            ])))
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  );},
                            ),

                                  ],
                                ),
                              ),
                            );
                            /*showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return FutureBuilder<Object?>(
                                  future: DatabaseService().getEmails(),
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if(!snapshot.hasData){
                                      return Text("Something went wrong");
                                    }
                                    final emailMap = snapshot.data;
                                    print("keys");
                                    print(emailMap.keys);
                                  return Container(
                                    height: 300,
                                    color: Colors.white,
                                    child: FutureBuilder<Object?>(
                                      future: DatabaseService().getQuestions(surveyID),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      if (!snapshot.hasData) {
                                      return Text("Something went wrong");
                                      }
                                      final dataa = snapshot.data;
                                      print(emailMap);
                                      print(dataa);
                                      //FirebaseFirestore.instance.collection("email").doc('emailMap').get().
                                      return  Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: wSize*0.85,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(0,0,0,40),
                                              child: TextFormField(
                                                  controller: emailController,
                                                    validator: (value) {
                                                    print("Value");
                                                    print(value);
                                                      if(emailMap.keys.contains(value)) {
                                                        print("geh rein");
                                                        return ("Email-Adresse nicht vorhanden");
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      emailController.text = value!;
                                                    },
                                                    style: const TextStyle(color: Color(0xff4C5051), fontSize: 18, fontWeight: FontWeight.bold),
                                                    decoration: const InputDecoration(
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Color(0xff4C5051)),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Color(0xff4C5051)),
                                                    ),
                                                  hintText: "E-Mail-Adresse",
                                                  hintStyle: TextStyle(color: Color(0xB34C5051), fontSize: 18, fontStyle: FontStyle.italic))
                                                )
                                            ),
                                          ),
                                          SizedBox(
                                            height: 40,
                                            width: wSize*0.85,
                                            child: RaisedButton(
                                                  onPressed: () {
                                                      var survey = [];
                                                      survey.add(surveyID);
                                                      FirebaseFirestore.instance.collection("participation")
                                                          .doc(emailMap[emailController.text])
                                                          .update({'surveyID': FieldValue.arrayUnion(survey)});
                                                      //FirebaseFirestore.instance.collection("participation").doc(user!.uid).collection('answerList').add({'answers': FieldValue.arrayUnion(survey),});
                                                      Map<String,Map<String, bool>> fullMap = {};
                                                      Map<String, bool> tempMap = {};
                                                      dataa.forEach((element) {
                                                        print("element");
                                                        print(element["name"]);
                                                        //Irgendwie ErrorHandling einbauen, dass keine Frage zwei mal vorhanden
                                                        tempMap.clear();
                                                        element["answers"].keys.forEach((key) {
                                                          tempMap[key] = false;
                                                        });
                                                        fullMap[element["name"]] = tempMap;

                                                      });
                                                      FirebaseFirestore.instance.collection("participation")
                                                          .doc(emailMap[emailController.text])
                                                          .collection('answerList').doc(surveyID).set({'answers': fullMap, 'finished' : false, 'time': DateTime.utc(2000)});
                                                      print(fullMap);
                                                      print("data");

                                                  },
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                                  padding: EdgeInsets.all(0.0),
                                                  child: Ink(
                                                      height: 40,
                                                      width: wSize*0.95,
                                                      decoration: BoxDecoration(
                                                          gradient: const LinearGradient(colors: [Color(0xff34D1C2), Color(0xff4D7DDC)],
                                                            begin: Alignment.centerLeft,
                                                            end: Alignment.centerRight,
                                                          ),
                                                          borderRadius: BorderRadius.circular(8.0)
                                                      ),
                                                      child: Stack(
                                                          children: const [
                                                            Padding(
                                                              padding: EdgeInsets.only(left: 18.0),
                                                              child: Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Icon(Icons.send_outlined,
                                                                    color: Colors.white,
                                                                    size: 25.0),
                                                              ),
                                                            ),
                                                            Center(
                                                              child: Text("Versenden",
                                                                  style: TextStyle(color: Colors.white,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.bold)),
                                                            ),
                                                          ])))
                                          )
                                        ],
                                      );
                                      },
                                    ),
                                  );},
                                );
                              },
                            );*/
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => const PostboxBase()));
                          }, child:Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.send_outlined,
                                  size: 25.0),
                            ),
                            Center(
                              child: Text("Versenden",
                                    style: TextStyle(color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                            ),
                        ])
                      ),
                    ),

                  SizedBox(height: hSize*0.02),
                  SizedBox(
                    height: 50,
                    width: wSize*0.83,
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff4C5051)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)))
                        ),
                        onPressed: () {
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => const PostboxBase()));
                        }, child:Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.delete_outlined,
                                size: 25.0),
                          ),
                          Center(
                            child: Text("Löschen",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ])
                    ),
                  ),
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
                                    Navigator.pop(context);
                                  },
                                  icon:  Icon(Icons.arrow_back_rounded) ))))])))));
  }
}

class CreatedSurveyResults extends StatefulWidget {
  const CreatedSurveyResults({Key? key}) : super(key: key);

  @override
  State<CreatedSurveyResults> createState() => _CreatedSurveyResultsState();
}

class _CreatedSurveyResultsState extends State<CreatedSurveyResults> {

  final FirebaseAuth auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {

    var surveyID = ModalRoute.of(context)!.settings.arguments as String;
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
                        text: TextSpan(
                            style: TextStyle(fontSize: 30, color: Colors.white,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  style: TextStyle(fontSize: 30, color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                        text: 'Erg',
                                        style: TextStyle(decoration: TextDecoration.underline,
                                            decorationThickness: 0.7,
                                            decorationColor: Color(0xff34D1C2)
                                        )),
                                    TextSpan(
                                      text: 'ebnisse ',
                                    )])
                            ]))]),
              Padding(padding: EdgeInsets.only(top: 40, left: 0, right: 0, bottom: 0),
                  child: FutureBuilder<Object?>(
                      future: DatabaseService().getQuestions(surveyID),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Text("Something went wrong");
                        }
                        final list = snapshot.data;

                        return ListView.builder(
                            itemCount: list.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context,int index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Container(
                                    constraints: BoxConstraints(
                                      maxHeight: double.infinity,
                                    ),
                                    width: wSize*0.85,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Color(0xff4c5051)
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text("Frage "+(index+1).toString()+": "+list[index]['name'].toString(),
                                              style: TextStyle(color: Colors.white,
                                                  fontSize: 20)),
                                        ),
                                        Divider(
                                          color: Colors.white,
                                        ),
                                          ListView.builder(
                                          itemCount: list[index]['answers'].length,
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,int index2) {
                                            return Padding(
                                              padding: const EdgeInsets.only(left: 15.0),
                                              child: Text(list[index]['answers'].keys.elementAt(index2).toString()+": "+list[index]['answers'].values.elementAt(index2).toString(),
                                              style: TextStyle(color: Colors.white,
                                                  fontSize: 20)),
                                            );
                                          }),
                                        SizedBox(height: 10)
                                      ],
                                    ),
                                ),
                              );
                            });
                      })),
              Spacer(),
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
                                Navigator.pop(context);
                              }, icon: const Icon(Icons.arrow_back_rounded) ))))])))));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const Center(
          child: MyStatelessWidget(),
        ),
      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}
