part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserList extends UserEvent {
  final List<Users>? userList;

  const UserList({this.userList});

  @override
  List<Object> get props => [userList ?? []];
}

class UserData extends UserEvent {
  final List<Users> userData;

  const UserData({required this.userData});

  @override
  List<Object> get props => [userData];
}

class UserLoginLog extends UserEvent {
  final List<UserLoginModel> userLoginLog;

  const UserLoginLog({required this.userLoginLog});

  @override
  List<Object> get props => [userLoginLog];
}
