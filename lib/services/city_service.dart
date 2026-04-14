import '../models/city_model.dart';
import 'api_service.dart';

class CityService {
  final ApiService _api;

  CityService({required ApiService api}) : _api = api;

  /// GET /api/City
  Future<List<CityModel>> getCities() async {
    final response = await _api.get('/api/City');
    final list = response as List<dynamic>;
    return list
        .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
