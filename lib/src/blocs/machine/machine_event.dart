part of 'machine_bloc.dart';

sealed class MachineEvent extends Equatable {
  const MachineEvent();

  @override
  List<Object> get props => [];
}

class MachineList extends MachineEvent {
  final List<Machines>? machineList;

  const MachineList({this.machineList});

  @override
  List<Object> get props => [machineList ?? []];
}
