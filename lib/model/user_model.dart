class UserData {
  String? uid;
  String? email;
  List<String>? answeredSurveys;
  List<String>? createdSurveys;


  UserData({this.uid, this.email, this.answeredSurveys, this.createdSurveys});

  factory UserData.fromMap(map) {
    return UserData(
        uid: map['uid'], email: map['email'], answeredSurveys: map['answeredSurveys'], createdSurveys: map['createdSurveys']);
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'answeredSurveys': answeredSurveys, 'createdSurveys': createdSurveys};
  }
}