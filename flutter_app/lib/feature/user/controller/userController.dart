part 'user_controller.g.dart';

@riverpod
class UserController extends _$UserController {
  @override
  User build() {
    // 初期値を設定
    return User(
      id: 0,
      username: 'guest