import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/livestream_model.dart';
import '../models/schedule_model.dart';

abstract class LiveRemoteDataSource {
  Future<LivestreamModel> getLivestream();
  Future<List<ScheduleModel>> getLiveSchedule(int dayIndex);
}

class LiveRemoteDataSourceImpl implements LiveRemoteDataSource {
  final ApiClient client;
  final Dio _scheduleDio;

  LiveRemoteDataSourceImpl({required this.client})
    : _scheduleDio = Dio(
        BaseOptions(
          baseUrl: 'http://plus.jtv.co.id',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

  @override
  Future<LivestreamModel> getLivestream() async {
    try {
      final response = await client.get('/livestream');
      return LivestreamModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ScheduleModel>> getLiveSchedule(int dayIndex) async {
    try {
      final response = await _scheduleDio.get(
        '/Apiupdate/live_streaming_jadwal',
        queryParameters: {'hari': dayIndex},
      );

      final List<dynamic> data = response.data is List ? response.data : [];
      return data
          .map((json) => ScheduleModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
