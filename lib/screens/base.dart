import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:umfrage/screens/CreatedSurvey.dart';
import 'package:umfrage/screens/answeredSurvey.dart';
import 'package:umfrage/screens/creatingSite.dart';
import 'package:umfrage/screens/postbox.dart';
import 'package:umfrage/screens/settings.dart';
import 'package:umfrage/services/databaseService.dart';
import '../GradientIcon.dart';
// ingore_for_file: prefer_expression_function_bodies


class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  //TODO: wenn Postfach-UI angelegt wird, dann muss $count-1 berechnet werden beim Öffnen einer Umfrage
  @override
  Widget build(BuildContext context) {
    double hSize = MediaQuery.of(context).size.height;
    double wSize = MediaQuery.of(context).size.width;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    print(user?.email);
    return SafeArea(child: Scaffold(
        backgroundColor: Color(0xff2D2D2D),
        body: FutureBuilder<Object?>(
            future: DatabaseService().getOpenSurveys(user!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          } if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("loading");
          }

          var countOpenSurveys = snapshot.requireData;
          return SizedBox(child: Padding(
            padding: EdgeInsets.only(
                top: hSize*0.07, left: 20, right: 0, bottom: 0),
            child: Column( children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                    style: TextStyle(fontSize: 30, color: Colors.white,
                    fontWeight: FontWeight.bold
              ),
              children: [
              TextSpan(
              text: 'Star',
                style: TextStyle(decoration: TextDecoration.underline,
                    decorationThickness: 0.7,
                    decorationColor: Color(0xff34D1C2)
                )
              ),
              TextSpan(
              text: 'tseite',
              style: TextStyle(
              ))
    ]),

    ),
                new Spacer(),
                Padding(
                    padding: EdgeInsets.only(
                        top: 0, left: 0, right: 0, bottom: 0),
                    child: FlatButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsBase()));
                    },
                         /*ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff2D2D2D)),
                        shadowColor: MaterialStateProperty.all(Color(0xff2D2D2D)),
                            overlayColor: MaterialStateProperty.all(Color(0xff2D2D2D)),
                        foregroundColor: MaterialStateProperty.all(Color(0xff2D2D2D)))*/
                    child: GradientIcon(
                      CupertinoIcons.settings,
                      30.0,
                      LinearGradient(
                        colors: <Color>[
                          Color(0xff34D1C2), Color(0xff4D7DDC)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    )))
                ]),
              Padding(
            padding: EdgeInsets.only(
                top: hSize*0.1, left: 0, right: 20, bottom: 0),
              child: SizedBox(
                height: 70,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff4C5051)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)))
                  ),
                onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PostboxBase()));
                }, child:Row(children: [
                    Icon(Icons.mail_outline,
                    size: 30.0),
                  Expanded(child: ListTile(
                  title: Text("Postfach",
                  style: TextStyle(color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
                    subtitle: (countOpenSurveys == 1 ) ? Text("Du hast 1 ungeöffnete Nachricht",
                      style: TextStyle(color: Colors.white,
                      fontSize: 13
                      )
                  ) :
                    Text("Du hast $countOpenSurveys ungeöffnete Nachrichten",
                        style: TextStyle(color: Colors.white,
                            fontSize: 13
                        )
                    )
                  ))])
                ))),
              Padding(
                  padding: EdgeInsets.only(
                      top: 20, left: 0, right: 20, bottom: 0),
                  child: SizedBox(
                      height: 70,
                      child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff4C5051)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)))),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatedSurveyBase()));
                          }, child:Row(children: [
                        Icon(Icons.addchart,
                            size: 30.0),
                        Expanded(child: ListTile(
                            title: Text("Erstellte Umfragen",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))))])
                      ))),
              Padding(
                  padding: EdgeInsets.only(
                      top: 20, left: 0, right: 20, bottom: 0),
                  child: SizedBox(
                      height: 70,
                      child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff4C5051)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0))
                              )
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AnsweredSurveyBase()));
                          }, child:Row(children: [
                        Icon(Icons.history,
                            size: 30.0),
                        Expanded(child: ListTile(
                            title: Text("Beantwortete Umfragen",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))))])
                      ))),
              Spacer(),
              Padding(
                  padding: EdgeInsets.only(
                      top: 20, left: 0, right: 20, bottom: 30),
                  child: Container(
                    height: 70.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatingSiteBase()));
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xff34D1C2), Color(0xff4D7DDC)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(14.0)
                        ),
                        child: Container(
                          //constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Row(children: [
                            Padding(padding: EdgeInsets.only(
                                top: 0, left: 20, right: 0, bottom: 0), child: Icon(Icons.add,
                            color: Colors.white,
                            size: 30)),
                            Expanded(child:ListTile(
                              title: Text("Neue Umfrage erstellen",
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              ))]
                      ))))))])));
            })));
  }
}
