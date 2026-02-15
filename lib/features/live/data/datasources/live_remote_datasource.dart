import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/livestream_model.dart';

abstract class LiveRemoteDataSource {
  Future<LivestreamModel> getLivestream();
}

class LiveRemoteDataSourceImpl implements LiveRemoteDataSource {
  final ApiClient client;

  LiveRemoteDataSourceImpl({required this.client});

  @override
  Future<LivestreamModel> getLivestream() async {
    try {
      final response = await client.get('/livestream');
      return LivestreamModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
