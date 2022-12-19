import 'dart:io';

import 'package:core/core.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/series_detail_model.dart';
import 'package:core/data/models/series_model.dart';
import 'package:core/data/models/series_table.dart';
import 'package:core/data/repositories/series_repository_impl.dart';
import 'package:core/domain/entities/series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SeriesRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockSeriesLocalDataSource();
    repository = SeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  // ignore: prefer_const_constructors
  final tSeriesModel = SeriesModel(
    backdropPath: "/4QNBIgt5fwgNCN3OSU6BTFv0NGR.jpg",
    genreIds: const [16, 10759],
    id: 888,
    name: "Spider-Man",
    originCountry: const ["US"],
    originalLanguage: "en",
    originalName: "Spider-Man",
    overview:
        "Bitten by a radioactive spider, Peter Parker develops spider-like superpowers. He uses these to fight crime while trying to balance it with the struggles of his personal life.",
    popularity: 64.599,
    posterPath: "/wXthtEN5kdWA1bHz03lkuCJS6hA.jpg",
    voteAverage: 8.3,
    voteCount: 833,
  );

  final tSeries = Series(
    backdropPath: "/4QNBIgt5fwgNCN3OSU6BTFv0NGR.jpg",
    genreIds: const [16, 10759],
    id: 888,
    name: "Spider-Man",
    originCountry: const ["US"],
    originalLanguage: "en",
    originalName: "Spider-Man",
    overview:
        "Bitten by a radioactive spider, Peter Parker develops spider-like superpowers. He uses these to fight crime while trying to balance it with the struggles of his personal life.",
    popularity: 64.599,
    posterPath: "/wXthtEN5kdWA1bHz03lkuCJS6hA.jpg",
    voteAverage: 8.3,
    voteCount: 833,
  );

  final tSeriesModelList = <SeriesModel>[tSeriesModel];
  final tSeriesList = <Series>[tSeries];

  group('Popular Movies', () {
    test('should return movie list when call to data source is success',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularSeries())
          .thenAnswer((_) async => tSeriesModelList);
      // act
      final result = await repository.getPopularSeries();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tSeriesList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularSeries())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularSeries();
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularSeries())
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularSeries();
      // assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Movies', () {
    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedSeries())
          .thenAnswer((_) async => tSeriesModelList);
      // act
      final result = await repository.getTopRatedSeries();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tSeriesList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedSeries())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedSeries();
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedSeries())
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedSeries();
      // assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Movie Detail', () {
    const tId = 210855;
    // ignore: prefer_const_declarations
    final tSeriesResponse = const SeriesDetailModel(
      adult: false,
      backdropPath: '/cl8NLaoztP877hTSYSy6YIUkChF.jpg',
      createdBy: [],
      episodeRunTime: [11],
      genres: [GenreModel(id: 10764, name: 'Reality')],
      homepage: "https://www.goplay.be/now-what",
      id: 210855,
      inProduction: true,
      languages: ["nl"],
      name: 'Now what',
      numberOfEpisodes: 90,
      numberOfSeasons: 1,
      originCountry: ["BE"],
      originalLanguage: "nl",
      originalName: "Now what",
      overview:
          "7 young people co-house in Antwerp. They are all at the beginning of their adult life and have to decide what that should look like.",
      popularity: 1358.348,
      posterPath: '/89kiLK0S7Rbfjorvhm0vxTAgAH3.jpg',
      productionCompanies: [],
      status: 'Returning Series',
      tagline: '',
      type: 'Reality',
      voteAverage: 5.2,
      voteCount: 4,
    );

    test(
        'should return Movie data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesDetail(tId))
          .thenAnswer((_) async => tSeriesResponse);
      // act
      final result = await repository.getSeriesDetail(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesDetail(tId));
      expect(result, equals(Right(testSeriesDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getSeriesDetail(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesDetail(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesDetail(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getSeriesDetail(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesDetail(tId));
      expect(
          result,
          equals(const Left(
              ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Movie Recommendations', () {
    final tMovieList = <SeriesModel>[];
    const tId = 1;

    test('should return data (movie list) when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesRecommendations(tId))
          .thenAnswer((_) async => tMovieList);
      // act
      final result = await repository.getSeriesRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tMovieList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getSeriesRecommendations(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getSeriesRecommendations(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesRecommendations(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getSeriesRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesRecommendations(tId));
      expect(
          result,
          equals(const Left(
              ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach Movies', () {
    const tQuery = 'spiderman';

    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchSeries(tQuery))
          .thenAnswer((_) async => tSeriesModelList);
      // act
      final result = await repository.searchSeries(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tSeriesList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchSeries(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchSeries(tQuery);
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchSeries(tQuery))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchSeries(tQuery);
      // assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource
              .insertWatchlistSeries(SeriesTable.fromEntity(testSeriesDetail)))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlistSeries(testSeriesDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource
              .insertWatchlistSeries(SeriesTable.fromEntity(testSeriesDetail)))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlistSeries(testSeriesDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource
              .removeWatchlistSeries(SeriesTable.fromEntity(testSeriesDetail)))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testSeriesDetail);
      // assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource
              .removeWatchlistSeries(SeriesTable.fromEntity(testSeriesDetail)))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testSeriesDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tId = 1;
      when(mockLocalDataSource.getSeriesById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistSeries())
          .thenAnswer((_) async => [testSeriesTable]);
      // act
      final result = await repository.getWatchlistSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistSeries]);
    });
  });
}
