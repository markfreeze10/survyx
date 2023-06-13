import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/raphael.dart';
import 'package:umfrage/screens/base.dart';

import '../model/surveyWidget_model.dart';
import '../model/survey_model.dart';
import '../services/databaseService.dart';

class CreatingSiteBase extends StatefulWidget {
  const CreatingSiteBase({Key? key}) : super(key: key);

  @override
  State<CreatingSiteBase> createState() => _CreatingSiteBaseState();
}

class _CreatingSiteBaseState extends State<CreatingSiteBase> {
  final _formKey = GlobalKey<FormState>();

  Map<int, SurveyWidget> questionMap = {};
  List<Widget> answerList = [];

  SurveyWidget? surveyWidget;
  Survey? survey;
  bool start = false;
  bool isChecked = false;

  final TextEditingController surveyNameController =
  new TextEditingController();
  final TextEditingController descriptionController =
  new TextEditingController();
  List<TextEditingController> questionControllerList = [];
  List<List<TextEditingController>> answerControllerList = [];

  final CollectionReference surveyCollection = FirebaseFirestore.instance.collection("survey");


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    Widget answerButton = Padding(
        padding: const EdgeInsets.only(
            top: 0, left: 0, right: 5, bottom: 0),
        child: ElevatedButton(onPressed: () {
          setState(() {});
        }, child: const Text("Antwortbutton")));

    if(!start){
      questionControllerList.add(new TextEditingController());
      answerControllerList.add([new TextEditingController()]);
      questionMap[0] = SurveyWidget(addQuestion(questionMap,0), [addFirstAnswer()], "" , answerButton);
      start = true;
    }

    return SafeArea(child: Scaffold(
        backgroundColor: const Color(0xff2D2D2D),
        body: SizedBox(
            //height: MediaQuery.of(context).size.height * 0.7,
            child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                          children: [
                      Padding(
                      padding: const EdgeInsets.only(
                      top: 0, left: 0, right: 0, bottom: 40),
                          child:Row(children: [
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
                                        }, icon: const Icon(Icons.close) )))),
                          const Spacer(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                  height: 50,
                                  width: 120,
                                  //width: MediaQuery.of(context).size.width,
                                  // ignore: deprecated_member_use
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff34D1C2), Color(0xff4D7DDC)],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(8.0)
                                    ),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            DatabaseService().addSurvey(questionControllerList, answerControllerList, surveyNameController.text, descriptionController.text, questionMap, auth, user!);
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const BaseScreen()));
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                                          primary: Colors.transparent, // Setze die Hintergrundfarbe des ElevatedButton auf transparent
                                          padding: EdgeInsets.zero,
                                          elevation: 0,
                                        ),

                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.add,
                                                      color: Colors.white,
                                                      size: 15),
                                                  Align(
                                                    child: Text("Speichern",
                                                        style: TextStyle(color: Colors.white,
                                                            fontSize: 13)),
                                                  )]
                                            )),
                                  )),
                            ),
                        ])),
                            //Umfragenname
                            Padding(padding: EdgeInsets.only(
                                top: 0, left: 0, right: 0, bottom: 0),
                                child: TextFormField(
                                  controller: surveyNameController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return ("Das Textfeld ist leer");
                                      }
                                    },
                                    onSaved: (value) {
                                      surveyNameController.text = value!;
                                    },
                                    minLines: 1,
                                    maxLines: 2,
                                    style: const TextStyle(color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Umfragenname...",
                                      hintStyle: TextStyle(color: Colors.white),
                                      /*enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          borderSide: BorderSide(color: Colors.white, width: 1.0)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        borderSide: BorderSide(width: 1,color: Colors.white),
                                      ),*/
                                    ))),
                            //Beschreibung
                            Padding(padding: EdgeInsets.only(
                                top: 0, left: 5, right: 0, bottom: 10),
                                child: TextFormField(
                                    controller: descriptionController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return ("Das Textfeld ist leer");
                                      }
                                    },
                                    onSaved: (value) {
                                      descriptionController.text = value!;
                                    },
                                    minLines: 1,
                                    maxLines: 1000,
                                    style: const TextStyle(color: Colors.white,
                                      fontSize: 18
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Beschreibung...",
                                      hintStyle: TextStyle(color: Color(0x8CFFFFFF), fontWeight: FontWeight.bold)))),
                            ListView.builder(
                                itemCount: questionMap.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context,int index) {
                                  return Column(
                                      children: [
                                        addQuestion(questionMap, index),
                                      Row(children: [Expanded(
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            unselectedWidgetColor: Colors.white,
                                          ),
                                          child: CheckboxListTile(
                                            title: Text("Single Choice", style: TextStyle(color: Colors.white, fontSize: 11.5),),
                                            checkColor: Color(0xff34D1C2),
                                            activeColor: Colors.white,
                                            selectedTileColor: Colors.white,
                                            value: (questionMap[index]?.choice=="SINGLE_CHOICE"),
                                            onChanged: (bool? value) {
                                              setState(() {
                                                if(questionMap[index]?.choice!="SINGLE_CHOICE"){
                                                  questionMap[index]?.choice = "SINGLE_CHOICE";
                                                } else {
                                                  questionMap[index]?.choice = "";
                                                }
                                              });
                                            }))),
                                        Expanded(
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                              unselectedWidgetColor: Colors.white,
                                            ),
                                            child: CheckboxListTile(
                                              title: Text("Multiple Choice", style: TextStyle(color: Colors.white, fontSize: 11.5)),
                                              checkColor: Color(0xff34D1C2),
                                              activeColor: Colors.white,
                                              selectedTileColor: Colors.white,
                                              value: (questionMap[index]?.choice=="MULTIPLE_CHOICE"),
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  if(questionMap[index]?.choice!="MULTIPLE_CHOICE"){
                                                    questionMap[index]?.choice = "MULTIPLE_CHOICE";
                                                  } else {
                                                    questionMap[index]?.choice = "";
                                                  }
                                                });
                                              })))]),
                                    ListView.builder(
                                        itemCount: questionMap[index]?.answerList.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext context,int answerIndex){
                                          bool cantSwipe = (questionMap[index]?.answerList.length == 1);
                                          return Dismissible(
                                            key: UniqueKey(),
                                            child: questionMap[index]!.answerList[answerIndex],
                                            direction: cantSwipe ? DismissDirection.none : DismissDirection.startToEnd,
                                            onDismissed: (DismissDirection direction) {
                                              if(questionMap[index]!.answerList.length > 1){
                                                questionMap[index]!.answerList.removeAt(answerIndex);
                                                answerControllerList.elementAt(index).removeAt(answerIndex);
                                              }
                                              setState(() {});
                                            },
                                          );
                                    }),
                                    createAnswerButton(questionMap, index),
                                  ]);
                                }
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff4C5051)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))
                                        )
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        questionControllerList.add(new TextEditingController());
                                        answerControllerList.add([new TextEditingController()]);
                                        questionMap[questionMap.length] = new SurveyWidget(addQuestion(questionMap, questionMap.length), [addAnswer(questionMap, questionMap.length, 0)] , "", answerButton);

                                      });
                                    }, child: const Text(" + Frage hinzufügen ")),
                              ),
                            ),
                          ])))))));

  }

  Widget createAnswerButton(Map<int, SurveyWidget> questionMap, int index){
    int answerIndex = questionMap[index]!.answerList.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
          height: 30,
          width: MediaQuery.of(context).size.width,
        // ignore: deprecated_member_use
        child: ElevatedButton(
            onPressed: () {
              setState(() {
                answerControllerList.elementAt(index).insert(answerIndex, TextEditingController());
                questionMap[index]?.answerList.add(addAnswer(questionMap, index, answerIndex));
              });
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
              padding: EdgeInsets.zero, // Entferne das interne Padding des ElevatedButton
              primary: Colors.transparent, // Setze die Hintergrundfarbe des ElevatedButton auf transparent
              elevation: 0, // Entferne den Schatten des ElevatedButton
            ),
            child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xff34D1C2), Color(0xff4D7DDC)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8.0)
                ),
                child: Container(
                  //constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Icon(Icons.add,
                      color: Colors.white,
                      size: 15),
                      Align(
                        child: Text(" Antwort hinzufügen",
                            style: TextStyle(color: Colors.white,
                                fontSize: 13)),
                      )]
                    ))))),
    );
  }

  Widget addAnswer(Map<int, SurveyWidget> questionMap, int index, int answerIndex) {
    return Padding(padding: EdgeInsets.only(
        top: 0, left: 0, right: 0, bottom: 5),
        child: TextFormField(
            controller: answerControllerList.elementAt(index).elementAt(answerIndex),
            validator: (value) {
              if (value!.isEmpty) {
                return ("Das Textfeld ist leer");
              }
            },
            onSaved: (value) {
              answerControllerList.elementAt(index).elementAt(answerIndex).text = value!;
            },
            minLines: 1,
            maxLines: 3,
            style: TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              fillColor: Color(0xff4C5051),
              filled: true,
              hintText: "Antwort...",
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.white, width: 1.0)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(width: 1,color: Colors.white),
              ),
            )));
  }


  Widget addQuestion (Map<int, SurveyWidget> questionMap, int index){
    return Padding(padding: EdgeInsets.only(
        top: 20, left: 5, right: 10, bottom: 0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                  controller: questionControllerList[index],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Das Textfeld ist leer");
                    }
                  },
                  onSaved: (value) {
                    questionControllerList[index].text = value!;
                  },
                  minLines: 1,
                  maxLines: 5,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Frage",
                    hintStyle: TextStyle(color: Colors.white),
                  )),
            ),
              ButtonTheme(
              alignedDropdown: true,
                child: DropdownButton<String>(
                  menuMaxHeight: 45.0,
                  //alignment: Alignment.center,
                  dropdownColor: Color(0xff4C5051),
                  icon: const Icon(Icons.more_horiz),
                  elevation: 20,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  style: const TextStyle(color: Colors.deepPurple, fontSize: 14, fontWeight: FontWeight.bold),
                  //isDense: true,
                  underline: Container(
                    height: 10,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      //dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Löschen']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        Map<int, SurveyWidget> tempMap = {};
                        questionControllerList.removeAt(index);
                        answerControllerList.removeAt(index);
                        //Wenn nur eine Frage da ist, einfach Controller clearen aber keine Elemente löschen
                          if(questionMap.length-1 > index) {
                            questionMap.forEach((key, value) {
                              if(key>index) {
                                tempMap[key-1] = value;
                              } else if (key < index){
                                tempMap[key] = value;
                              }
                            });
                            questionMap.clear();
                            questionMap.addAll(tempMap);
                          } else {
                            questionMap.remove(index);
                          }
                        setState(() {});
                      },
                      alignment: Alignment.centerLeft,
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.red),));
                  }).toList(),
                ))]));
  }

  Widget addFirstAnswer() {
    return Padding(padding: EdgeInsets.only(
        top: 0, left: 0, right: 0, bottom: 5),
        child: TextFormField(
            controller: (questionMap.length == 0) ? answerControllerList.elementAt(0).elementAt(0) : answerControllerList.elementAt(questionMap.length-1).elementAt(0),
            validator: (value) {
              if (value!.isEmpty) {
                return ("Das Textfeld ist leer");
              }
            },
            onSaved: (value) {
              if(questionMap.length == 0) {
                answerControllerList.elementAt(0).elementAt(0).text = value!;
              } else {
                answerControllerList.elementAt(questionMap.length-1).elementAt(0).text = value!;
              }
              setState(() {

              });
            },
            minLines: 1,
            maxLines: 3,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: Color(0xff4C5051),
              filled: true,
              hintText: "Antwort...",
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.white, width: 1.0)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1,color: Colors.white),
              ),
            )));
  }

}
