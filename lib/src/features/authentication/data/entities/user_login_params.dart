import '../../../../core/network/api_client.dart';

class UserLoginParams implements APIRouter {
  final String userName;
  final String password;

  UserLoginParams({
    required this.userName,
    required this.password,
  });

  @override
  get body => {
        'userName': userName,
        'password': password,
      };

  @override
  Map<String, String>? get headers => {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  @override
  String get path => '/login.php';

  @override
  Map<String, String>? get queryParams => null;
}
