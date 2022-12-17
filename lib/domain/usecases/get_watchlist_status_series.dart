import '../repositories/series_repository.dart';

class GetWatchlistStatusSeries {
  final SeriesRepository repository;

  GetWatchlistStatusSeries(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
