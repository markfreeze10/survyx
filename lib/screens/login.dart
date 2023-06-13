import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/user_model.dart';
import 'base.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController loginEmailController =
  new TextEditingController();
  final TextEditingController loginPasswordController =
  new TextEditingController();

  final _auth = FirebaseAuth.instance;

  String? errorMessage;


  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      style: TextStyle(color: Colors.white),
      autofocus: false,
      controller: loginEmailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Das Textfeld ist leer");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Die Email-Adresse ist ungültig");
        }
        return null;
      },
      onSaved: (value) {
        loginEmailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.mail,
            color: Colors.grey,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffffffff)),
          ),
          focusedBorder:UnderlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff34D1C2)),
          ),
          contentPadding: EdgeInsets.fromLTRB(30, 15, 20, 15),
          hintText: "Email",
          hintStyle: TextStyle(color: Colors.grey)),
    );

    final passwordField = TextFormField(
      style: TextStyle(color: Colors.white),
      autofocus: false,
      controller: loginPasswordController,
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Das Textfeld ist leer");
        }
        if (!regex.hasMatch(value)) {
          return ("Das Passwort muss mindestens 6 Zeichen haben");
        }
      },
      onSaved: (value) {
        loginPasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.vpn_key,
            color: Colors.grey,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffffffff)),
          ),
          focusedBorder:UnderlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff34D1C2)),
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Passwort",
          hintStyle: TextStyle(color: Colors.grey)
    ));

    final loginButton = Container(
      height: 50.0,
      child: ElevatedButton(
        onPressed: () {
          signIn(loginEmailController.text, loginPasswordController.text);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
        ),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xff34D1C2), Color(0xff4D7DDC)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12.0)
          ),
          child: Container(
            //constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );

    final registrationButton = Container(
      height: 50.0,
      child: ElevatedButton(
        onPressed: () {
          signUp(loginEmailController.text, loginPasswordController.text);

        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        ),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xff4C5051), Color(0xff4C5051)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12.0)
          ),
          child: Container(
            //constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              "Registrierung",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );

    //              signIn(loginEmailController.text, loginPasswordController.text);


    return Scaffold(
        backgroundColor: Color(0xff2D2D2D),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                //color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.transparent, spreadRadius: 3),
                ],
              ),
              //decoration: new BoxDecoration(
              //    color: Colors.white,
              //    borderRadius: BorderRadius.all(Radius.circular(20))),
              margin: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 30.0, bottom: 30.0),
              child: Form(
                  key: _formKey,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget> [
                          ShaderMask(
                              blendMode: BlendMode.srcATop,
                              shaderCallback: (bounds) => LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xff34D1C2), Color(0xff4D7DDC)]).createShader(bounds),

                              child: Icon(Icons.library_add_check_outlined,
                                    size: 60.0),

                            ),
                          Padding( padding: EdgeInsets.only(
                              top: 0, left: 0, right: 10, bottom: 0),),
                         Text('Survyx',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  color: Color(0xffF0F7F4),
                                  fontWeight: FontWeight.bold)),
                        ]),
                        Padding(
                            padding: EdgeInsets.only(
                                top:  40, left: 15, right: 15, bottom: 10),
                            child: emailField),
                        Padding(
                            padding: EdgeInsets.all(15), child: passwordField),
                        Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Passwort vergessen? ",
                                  style: TextStyle(color: Color(0xffffffff)),
                                ),

                                ShaderMask(
                                  blendMode: BlendMode.srcATop,
                                  shaderCallback: (bounds) => LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xff34D1C2), Color(0xff4D7DDC)]).createShader(bounds),

                                  child: GestureDetector(
                                      onTap: () {/*
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistrationScreen()));
                                    */},
                                      child: Text("Klicke hier",
                                          style: TextStyle(

                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)))

                                ),

                              ],
                            ))
                        ,
                        Padding(
                            padding: EdgeInsets.only(
                                top: 70, left: 10, right: 10, bottom: 10), child: loginButton),
                        Padding(
                            padding: EdgeInsets.all(10), child: registrationButton),

                      ])),
            ),
          ),
        ));
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
        Fluttertoast.showToast(msg: "Login erfolgreich"),
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BaseScreen()))
      })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  void signUp(String email, String password) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {sendDataToFireStore(),

        })
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);

        });
        
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
      signIn(email, password);
      User? user = _auth.currentUser;
      List<String> list = [];
      FirebaseFirestore.instance.collection("participation").doc(user!.uid).collection('answerList').doc('hi').set({});
      FirebaseFirestore.instance.collection("participation").doc(user!.uid).collection('answerList').doc('hi').delete();
      FirebaseFirestore.instance.collection("participation").doc(user.uid).set({'surveyID': list});
      FirebaseFirestore.instance.collection('email').doc('emailMap').set({user.email.toString(): user.uid},SetOptions(merge: true)).then((value){
        //Do your stuff.
      });

      }

  }

  sendDataToFireStore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    List<String> answeredSurveys = [];
    List<String> createdSurveys = [];

    UserData userData = UserData();

    userData.email = user!.email;
    userData.uid = user.uid;
    userData.answeredSurveys = answeredSurveys;
    userData.createdSurveys = createdSurveys;


    await firebaseFirestore
        .collection("userdata")
        .doc(user.uid)
        .set(userData.toMap());
    Fluttertoast.showToast(msg: "Account wurde erstellt");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const BaseScreen()),
            (route) => false);
  }

}
