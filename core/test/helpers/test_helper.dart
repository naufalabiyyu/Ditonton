// ignore_for_file: depend_on_referenced_packages

import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/db/database_helper_series.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/series_local_data_source.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/series_repository.dart';
import 'package:core/utils/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  SeriesRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  SeriesLocalDataSource,
  DatabaseHelper,
  DatabaseHelperSeries,
  NetworkInfo,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
