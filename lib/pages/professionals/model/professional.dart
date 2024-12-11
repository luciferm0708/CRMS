class Professional {
  int professionalId;
  String professionType;
  String firstName;
  String lastName;
  String username;
  String email;
  String organizationName;
  String licenseNumber;
  String nidNumber;
  String expertiseArea;
  String pass;
  String confirmPass;
  String verificationStatus;
  String registeredAt;

  Professional(
        this.professionalId,
        this.professionType,
        this.firstName,
        this.lastName,
        this.username,
        this.email,
        this.organizationName,
        this.licenseNumber,
        this.nidNumber,
        this.expertiseArea,
        this.pass,
        this.confirmPass,
        this.verificationStatus,
        this.registeredAt);

  // Factory method for JSON deserialization
  factory Professional.fromJson(Map<String, dynamic> json) {
    return Professional(
      json["professional_id"] != null
          ? int.tryParse(json["professional_id"].toString()) ?? 0
          : 0,
      json["profession_type"] ?? "",
      json["first_name"] ?? "",
      json["last_name"] ?? "",
      json["username"] ?? "",
      json["email"] ?? "",
      json["organization_name"] ?? "",
      json["license_number"] ?? "",
      json["nid_number"] ?? "",
      json["expertise_area"] ?? "",
      json["pass"] ?? "",
      json["confirm_pass"] ?? "",
      json["verification_status"] ?? "Pending",
      json["registered_at"] ?? "",
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() => {
    'professional_id': professionalId.toString(),
    'profession_type': professionType,
    'first_name': firstName,
    'last_name': lastName,
    'username': username,
    'email': email,
    'organization_name': organizationName,
    'license_number': licenseNumber,
    'nid_number': nidNumber,
    'expertise_area': expertiseArea,
    'pass': pass,
    'confirm_pass': confirmPass,
    'verification_status': verificationStatus,
    'registered_at': registeredAt,
  };
}
