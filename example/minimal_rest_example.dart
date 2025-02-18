import 'package:minimal_rest/minimal_rest.dart';

import 'failure.dart';

class UserModel {
  final String name;
  final String email;

  UserModel({required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}

Future<void> main() async {
  //initializing MinRest
  MinRest.init("https://jsonplaceholder.typicode.com");

  //making a get request
  final tokenOrError = await MinRest().getErrorOr<Failure, UserModel>(
    uri: "/path_to_user_data",
    deSerializer: (json) => UserModel.fromJson(json),
    errorDeserializer: (json) => Failure.fromJson(json),
  );

  //handling the result
  tokenOrError.fold(
    (error) => print("Error: ${error.message} - ${error.message}"),
    (user) => print("User: ${user.name} - ${user.email}"),
  );

  //making a post request
  final postData = await MinRest().postErrorOr<Failure, UserModel>(
    uri: "/path_to_user_data",
    deSerializer: (json) => UserModel.fromJson(json),
    data: {
      "name": "John Doe",
      "email": "example@email.com",
    },
    errorDeserializer: (json) => Failure.fromJson(json),
  );
}
