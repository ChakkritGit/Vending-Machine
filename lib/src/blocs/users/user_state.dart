part of 'user_bloc.dart';

class UserState extends Equatable {
  final List<Users> userList;
  final List<Users> userData;

  const UserState({required this.userList, required this.userData});

  UserState copywith({List<Users>? userList, List<Users>? userData}) {
    return UserState(
        userList: userList ?? this.userList,
        userData: userData ?? this.userData);
  }

  @override
  List<Object> get props => [userList, userData];
}
