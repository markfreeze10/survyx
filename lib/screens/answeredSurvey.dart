import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/fa6_solid.dart';
import 'package:iconify_flutter/icons/foundation.dart';
import 'package:umfrage/screens/base.dart';
import 'package:umfrage/services/databaseService.dart';

class AnsweredSurveyBase extends StatefulWidget {
  const AnsweredSurveyBase({Key? key}) : super(key: key);

  @override
  State<AnsweredSurveyBase> createState() => _AnsweredSurveyBaseState();
}

class _AnsweredSurveyBaseState extends State<AnsweredSurveyBase> {

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
                        text: const TextSpan(
                            style: TextStyle(fontSize: 30, color: Colors.white,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: 'Beantwortete')]))]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                        text: const TextSpan(
                            style: TextStyle(fontSize: 30, color: Colors.white,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: 'Umfr',
                                  style: TextStyle(decoration: TextDecoration.underline,
                                      decorationThickness: 0.7,
                                      decorationColor: Color(0xff34D1C2)
                                  )),
                              TextSpan(
                                text: 'agen',
                              )]))]),
              Padding(padding: EdgeInsets.only(top: 40, left: 0, right: 0, bottom: 0),
                    child: Container(
                          height: hSize*0.6,
                          width: wSize*0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xff4c5051)
                          ),
                          child: FutureBuilder<Object?>(
                        future: DatabaseService().getAnsweredSurveys(user!),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Text("Something went wrong");
                          }
                          final listID = snapshot.data;
                          return (listID.length == 0) ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(30.0),
                                child: Text("Es wurde noch keine Umfrage beantwortet.",
                                    style: TextStyle(color: Colors.white)),
                              )) : ListView.builder(
                            itemCount: listID.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context,int index) {
                              return Column(children: [
                                FutureBuilder<Object?>(
                                  future: DatabaseService().getSurveyName(listID[index]),
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return Text("Something went wrong");
                                    }
                                    final surveyString = snapshot.data;
                                  return ListTile(
                                      title: Text(surveyString),
                                      //subtitle: Text((FirebaseFirestore.instance.collection("participation").doc(user.uid).collection("answerList").doc(listID[index]))),
                                      onTap: () {
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => const PostSurveyOverview(), settings: RouteSettings(arguments: list[index])));
                                      },
                                      textColor: Colors.white);
                                  }),
                                const Divider(
                                  color: Colors.white,
                                )]);
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
                              }, icon: const Icon(Icons.arrow_back_rounded) ))))])))
    ));
  }
}

