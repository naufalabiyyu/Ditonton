import 'package:core/domain/usecases/remove_watchlist_series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistSeries usecase;
  late MockSeriesRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockSeriesRepository();
    usecase = RemoveWatchlistSeries(mockMovieRepository);
  });

  test('should remove watchlist movie from repository', () async {
    // arrange
    when(mockMovieRepository.removeWatchlist(testSeriesDetail))
        .thenAnswer((_) async => const Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testSeriesDetail);
    // assert
    verify(mockMovieRepository.removeWatchlist(testSeriesDetail));
    expect(result, const Right('Removed from watchlist'));
  });
}
