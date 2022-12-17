import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../entities/series_detail.dart';
import '../repositories/series_repository.dart';

class GetDetailSeries {
  final SeriesRepository repository;

  GetDetailSeries(this.repository);

  Future<Either<Failure, SeriesDetail>> execute(int id) {
    return repository.getSeriesDetail(id);
  }
}
