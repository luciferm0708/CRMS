class People {
  int people_id;
  String first_name;
  String last_name;
  String username;
  String email;
  String gender;
  int nid;
  String dob;
  String pass;
  String confirm_pass;

  People(
      this.people_id,
      this.first_name,
      this.last_name,
      this.username,
      this.email,
      this.gender,
      this.nid,
      this.dob,
      this.pass,
      this.confirm_pass);

  factory People.fromJson(Map<String, dynamic> json) {
    return People(
      json["people_id"] != null
          ? int.tryParse(json["people_id"].toString()) ?? 0
          : 0, // Handles string-to-int safely
      json["first_name"] ?? "",
      json["last_name"] ?? "",
      json["username"] ?? "",
      json["email"] ?? "",
      json["gender"] ?? "",
      json["nid"] != null
          ? int.tryParse(json["nid"].toString()) ?? 0
          : 0,
      json["dob"] ?? "",
      json["pass"] ?? "",
      json["confirm_pass"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    'people_id': people_id.toString(),
    'first_name': first_name,
    'last_name': last_name,
    'username': username,
    'email': email,
    'gender': gender,
    'nid': nid.toString(),
    'dob': dob,
    'pass': pass,
    'confirm_pass': confirm_pass,
  };
}
