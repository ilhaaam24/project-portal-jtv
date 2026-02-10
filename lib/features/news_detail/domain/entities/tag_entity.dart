import 'package:equatable/equatable.dart';

class TagEntity extends Equatable {
  final String name;
  final String seo;

  const TagEntity({required this.name, required this.seo});

  @override
  List<Object?> get props => [name, seo];
}
