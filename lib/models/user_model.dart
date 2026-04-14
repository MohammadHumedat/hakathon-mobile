class UserModel {
  final String id;
  final String firstName;
  final String secondName;
  final String thirdName;
  final String lastName;
  final String email;
  final String userName;
  final String phoneNumber;
  final String nationalId;
  final String birthdate;
  final int cityId;
  final String? roleName;
  final String? token;
  final String? refreshToken;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.secondName,
    required this.thirdName,
    required this.lastName,
    required this.email,
    required this.userName,
    required this.phoneNumber,
    required this.nationalId,
    required this.birthdate,
    required this.cityId,
    this.roleName,
    this.token,
    this.refreshToken,
  });

  String get fullName => '$firstName $secondName $thirdName $lastName'.trim();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName'] as String? ?? '',
      secondName: json['secondName'] as String? ?? '',
      thirdName: json['thirdName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      nationalId: json['nationalId'] as String? ?? '',
      birthdate: json['birthdate'] as String? ?? '',
      cityId: (json['cityId'] as num?)?.toInt() ?? 0,
      roleName: json['roleName'] as String?,
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'secondName': secondName,
      'thirdName': thirdName,
      'lastName': lastName,
      'email': email,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'nationalId': nationalId,
      'birthdate': birthdate,
      'cityId': cityId,
      if (roleName != null) 'roleName': roleName,
      if (token != null) 'token': token,
      if (refreshToken != null) 'refreshToken': refreshToken,
    };
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? secondName,
    String? thirdName,
    String? lastName,
    String? email,
    String? userName,
    String? phoneNumber,
    String? nationalId,
    String? birthdate,
    int? cityId,
    String? roleName,
    String? token,
    String? refreshToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      secondName: secondName ?? this.secondName,
      thirdName: thirdName ?? this.thirdName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nationalId: nationalId ?? this.nationalId,
      birthdate: birthdate ?? this.birthdate,
      cityId: cityId ?? this.cityId,
      roleName: roleName ?? this.roleName,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
