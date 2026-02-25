import 'package:equatable/equatable.dart';

class ScheduleEntity extends Equatable {
  final String id;
  final String jamMulai;
  final String jamBerakhir;
  final String nama;

  const ScheduleEntity({
    required this.id,
    required this.jamMulai,
    required this.jamBerakhir,
    required this.nama,
  });

  @override
  List<Object?> get props => [id, jamMulai, jamBerakhir, nama];
}
