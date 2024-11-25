// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vending_standalone/src/models/users/user_login_model.dart';
import 'package:vending_standalone/src/models/users/user_model.dart';
part 'user_state.dart';
part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState(userList: [], userData: [], userLoginLog: [])) {
    on<UserList>((event, emit) {
      emit(state.copywith(userList: event.userList));
    });
    on<UserData>((event, emit) {
      emit(state.copywith(userData: event.userData));
    });
    on<UserLoginLog>((event, emit) {
      emit(state.copywith(userLoginLog: event.userLoginLog));
    });
  }
}
