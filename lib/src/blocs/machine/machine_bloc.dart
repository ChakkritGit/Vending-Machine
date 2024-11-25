// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vending_standalone/src/models/machine/machine_model.dart';
part 'machine_state.dart';
part 'machine_event.dart';

class MachineBloc extends Bloc<MachineEvent, MachineState> {
  MachineBloc() : super(const MachineState(machineList: [])) {
    on<MachineList>((event, emit) {
      emit(state.copywith(machineList: event.machineList));
    });
  }
}
