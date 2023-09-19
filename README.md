If you like `Either<L, R>` datatype from the `dartz` package, and tired of writting boilerplates for consuming REST Api in `Either<L, R>` This Package is the solution for you.

`MinRest` acts as a REST Client and returns data as your `DataModel` or `Entity` whichever object you want.

## Features

* Making all kind of `http` request
* It returns your `DataModel` by making a `http` request and returns `Either<YourModel, Error>`
## Getting started

You need to Initialize the `MinRest` singleton with the base url
Let's do it int the `main.dart` file
```dart
void main() {  
  WidgetsFlutterBinding.ensureInitialized();  
  ...
  MinRest.init("https://developer.darc.gg/api");  
  ...
  runApp(Main());  
}
```

### Make a `GET` request
1. **Your own DataModel class**
   Let's say we have a `DataModel`named `UserModel`
```dart
  
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
```
2. **Make the API call and get** `Either<MinRestError, UserModel>`
```dart
final userOrError = await MinRest().getErrorOr<UserModel>(  
  "/path_to_user_data",  
  (json) => UserModel.fromJson(json),  
);
```
> Note that `MinRestError` is the default error object `MinRest` will return in the `Left` side of `Either`

3. **Fold and using the data**
   Now you can use `userOrError` just like any `Either<L, R>` object.
   Let's `fold` userOrError and print the
   * `name` and `email` of the user if the request and response is successful. (status code from 200 to 199)
   * or print the `error` status code and `message` of the request is failed
```dart
userOrError.fold(  
  (error) => print("Error: ${error.code} - ${error.message}"),  
  (user) => print("User: ${user.name} - ${user.email}"),  
);
```



## Usage

How to use `MinRest`
### Get Request
```dart
final userOrError = await MinRest().getErrorOr<UserModel>(  
  "/path_to_user_data",  
  (json) => UserModel.fromJson(json),  
  token: token.accessToken, 
);
```
### Post Request
```dart
final postData = await MinRest().postErrorOr<UserModel>(  
  "/path_to_user_data",  
  userModel.toJson(),  
  (json) => UserModel.fromJson(json),  
  token: token.accessToken,
);
```
### Patch Request
```dart
final patchData = MinRest().patchErrorOr<UserModel>(  
  uri: "/auth/update-profile",  
  data: userModel.toJson(),  
  deSerializer: (json) => UserModel.fromJson(json),  
  errorDeserializer: (json) => AppError.fromJson(json),  
  token: token.accessToken,  
);
```

### Delete Request
```dart
final deleteData = MinRest().deleteErrorOr(  
  uri: "/auth/delete-account",  
  deSerializer: (json) => RestResponseNoEntity.fromJson(json),  
  errorDeserializer: (json) => AppError.fromJson(json),  
  token: token.accessToken,  
)
```



> Here AppError is your custom ErrorModel, (Later this will be implemented in other methods as well, Get and Post methods now returns `MinRestError` only)

 # min_rest
