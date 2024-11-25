class Machines {
  final String id;
  final String machineName;
  final int machineStatus;
  final String comment;
  final String createdAt;
  final String updatedAt;

  Machines({
    required this.id,
    required this.machineName,
    required this.machineStatus,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'machineName': machineName,
      'machineStatus': machineStatus,
      'comment': comment,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Machines.fromMap(Map<String, dynamic> map) {
    return Machines(
      id: map['id'] as String? ?? '',
      machineName: map['machineName'] as String? ?? '',
      machineStatus: map['machineStatus'] as int? ?? 0,
      comment: map['comment'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? '',
      updatedAt: map['updatedAt'] as String? ?? '',
    );
  }
}
