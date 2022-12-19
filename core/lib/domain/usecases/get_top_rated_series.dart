import 'package:dartz/dartz.dart';

import '../../core.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';

class GetTopRatedSeries {
  final SeriesRepository repository;

  GetTopRatedSeries(this.repository);

  Future<Either<Failure, List<Series>>> execute() {
    return repository.getTopRatedSeries();
  }
}
