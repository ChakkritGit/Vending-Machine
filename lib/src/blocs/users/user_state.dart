part of 'user_bloc.dart';

class UserState extends Equatable {
  final List<Users> userList;
  final List<Users> userData;
  final List<UserLoginModel> userLoginLog;

  const UserState({
    required this.userList,
    required this.userData,
    required this.userLoginLog,
  });

  UserState copywith({List<Users>? userList, List<Users>? userData, List<UserLoginModel>? userLoginLog}) {
    return UserState(
      userList: userList ?? this.userList,
      userData: userData ?? this.userData,
      userLoginLog: userLoginLog ?? this.userLoginLog,
    );
  }

  @override
  List<Object> get props => [userList, userData, userLoginLog];
}
