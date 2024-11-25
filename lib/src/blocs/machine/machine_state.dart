part of 'machine_bloc.dart';

class MachineState extends Equatable {
  final List<Machines> machineList;

  const MachineState({required this.machineList});

  MachineState copywith({List<Machines>? machineList}) {
    return MachineState(machineList: machineList ?? this.machineList);
  }

  @override
  List<Object> get props => [machineList];
}
