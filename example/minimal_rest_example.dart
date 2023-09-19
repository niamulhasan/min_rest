import 'package:minimal_rest/minimal_rest.dart';

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
  final tokenOrError = await MinRest().getErrorOr<UserModel>(
    "/path_to_user_data",
    (json) => UserModel.fromJson(json),
  );

  //handling the result
  tokenOrError.fold(
    (error) => print("Error: ${error.code} - ${error.message}"),
    (user) => print("User: ${user.name} - ${user.email}"),
  );

  //making a post request
  final postData = await MinRest().postErrorOr<UserModel>(
    "/path_to_user_data",
    {
      "name": "John Doe",
      "email": "example@email.com",
    },
    (json) => UserModel.fromJson(json),
  );
}
