import 'package:core/domain/usecases/get_watchlist_series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistSeries usecase;
  late MockSeriesRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockSeriesRepository();
    usecase = GetWatchlistSeries(mockMovieRepository);
  });

  test('should get list of movies from the repository', () async {
    // arrange
    when(mockMovieRepository.getWatchlistSeries())
        .thenAnswer((_) async => Right(testSeriesList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testSeriesList));
  });
}
