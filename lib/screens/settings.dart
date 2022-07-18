import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'base.dart';

class SettingsBase extends StatelessWidget {
  const SettingsBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double hSize = MediaQuery.of(context).size.height;
    double wSize = MediaQuery.of(context).size.width;

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
                    text: 'Eins',
                    style: TextStyle(decoration: TextDecoration.underline,
                    decorationThickness: 0.7,
                    decorationColor: Color(0xff34D1C2)
                  )),
                  TextSpan(
                    text: 'tellungen',
            )]))]),
          Padding(
              padding: EdgeInsets.only(
                  top: hSize*0.15, left: 0, right: 20, bottom: 0),
              child: SizedBox(
                  height: 70,
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff4C5051)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)))
                      ),
                      onPressed: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => const PostboxBase()));
                      }, child: Center(
                      child: Text("Anmeldeoptionen",
                          style: TextStyle(color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)))))),
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
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatedSurveyBase()));
                      }, child: Center(
                      child: Text("Support",
                          style: TextStyle(color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)))
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
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => const AnsweredSurveyBase()));
                      }, child: Center(
                          child: Text("Datenschutz",
                              style: TextStyle(color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)))
                  ))),
          SizedBox(
            height: hSize*0.1,
          ),
          Row(children: [
            Expanded(
              child: TextButton(
                  onPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatingSiteBase()));
                  },
                  child: GradientText(
                    ' AGB ',
                    style: const TextStyle(fontSize: 15),
                    gradientDirection: GradientDirection.ltr,
                    colors: [Color(0xff34D1C2),
                      Color(0xff4D7DDC)],
                  )),
            ),
            Text("|", style: TextStyle(color: Color(0xff34D1C2),fontSize: 20)),
            Expanded(
              child: TextButton(
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatingSiteBase()));
                },
                child: GradientText(
                  'Impressum',
                  style: const TextStyle(fontSize: 15),
                  gradientDirection: GradientDirection.rtl,

                  colors: [Color(0xff34D1C2),
                    Color(0xff4D7DDC)],
                )),
            ),
            Text("|", style: TextStyle(color: Color(0xff34D1C2),fontSize: 20)),
            Expanded(
              child: TextButton(
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatingSiteBase()));
                },
                child: GradientText(
                  'About',
                  style: const TextStyle(fontSize: 15),
                  gradientDirection: GradientDirection.ltr,
                  colors: [Color(0xff34D1C2),
                    Color(0xff4D7DDC)],
                )),
            ),
          ]),
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
                          }, icon: const Icon(Icons.arrow_back_rounded) ))))
        ])))));
  }
}
