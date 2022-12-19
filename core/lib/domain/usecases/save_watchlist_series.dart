import 'package:dartz/dartz.dart';

import '../../core.dart';
import '../entities/series_detail.dart';
import '../repositories/series_repository.dart';

class SaveWatchlistSeries {
  final SeriesRepository repository;

  SaveWatchlistSeries(this.repository);

  Future<Either<Failure, String>> execute(SeriesDetail series) {
    return repository.saveWatchlistSeries(series);
  }
}
