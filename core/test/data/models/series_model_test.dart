import 'package:core/data/models/series_model.dart';
import 'package:core/domain/entities/series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ignore: prefer_const_constructors
  final tSeriesModel = SeriesModel(
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: const ['us'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  final tSeries = Series(
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: const ['us'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of Movie entity', () async {
    final result = tSeriesModel.toEntity();
    expect(result, tSeries);
  });
}
