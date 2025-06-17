import '../model/user.dart';

class UserController {
  static User get defaultUser => const User(
    id: 0,
    username: 'guest',
    email: 'guest@example.com',
    phone: '000-0000-0000',
  );
}