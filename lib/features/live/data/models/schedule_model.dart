import 'package:portal_jtv/features/live/domain/entities/schedule_entity.dart';

class ScheduleModel extends ScheduleEntity {
  const ScheduleModel({
    required super.id,
    required super.jamMulai,
    required super.jamBerakhir,
    required super.nama,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] ?? '',
      jamMulai: json['jam_mulai'] ?? '',
      jamBerakhir: json['jam_berakhir'] ?? '',
      nama: json['nama'] ?? '',
    );
  }

  ScheduleEntity toEntity() => this;
}
