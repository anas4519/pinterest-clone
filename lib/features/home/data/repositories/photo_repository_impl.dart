import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/photo_model.dart';

final photoRepositoryProvider = Provider((ref) {
  return PhotoRepositoryImpl(ref.read(dioProvider));
});

class PhotoRepositoryImpl {
  final Dio _dio;

  PhotoRepositoryImpl(this._dio);

  Future<List<PhotoModel>> getCuratedPhotos({int page = 1}) async {
    try {
      final response = await _dio.get(
        'curated',
        queryParameters: {'page': page, 'per_page': 20},
      );

      final List data = response.data['photos'];
      return data.map((e) => PhotoModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load photos: $e');
    }
  }
}
