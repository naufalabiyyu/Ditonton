import 'package:flutter/foundation.dart';

import '../../core.dart';
import '../../domain/entities/series.dart';
import '../../domain/entities/series_detail.dart';
import '../../domain/usecases/get_detail_series.dart';
import '../../domain/usecases/get_series_recommendations.dart';
import '../../domain/usecases/get_watchlist_status_series.dart';
import '../../domain/usecases/remove_watchlist_series.dart';
import '../../domain/usecases/save_watchlist_series.dart';

class SeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetDetailSeries getSeriesDetail;
  final GetSeriesRecommendations getSeriesRecommendations;
  final SaveWatchlistSeries saveWatchlist;
  final RemoveWatchlistSeries removeWatchlist;
  final GetWatchlistStatusSeries getWatchlistStatus;

  SeriesDetailNotifier({
    required this.getSeriesDetail,
    required this.getSeriesRecommendations,
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.getWatchlistStatus,
  });

  late SeriesDetail _series;
  SeriesDetail get series => _series;

  RequestState _seriesState = RequestState.Empty;
  RequestState get seriesState => _seriesState;

  List<Series> _seriesRecommendations = [];
  List<Series> get seriesRecommendations => _seriesRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedtoWatchlist => _isAddedtoWatchlist;

  Future<void> fetchDetailSeries(int id) async {
    _seriesState = RequestState.Loading;
    notifyListeners();

    final detailResult = await getSeriesDetail.execute(id);
    final recommendationResult = await getSeriesRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _seriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (seriesData) {
        _recommendationState = RequestState.Loading;
        _series = seriesData;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (seriesData) {
            _recommendationState = RequestState.Loaded;
            _seriesRecommendations = seriesData;
          },
        );
        _seriesState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(SeriesDetail series) async {
    final result = await saveWatchlist.execute(series);

    result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(series.id);
  }

  Future<void> removeWatchList(SeriesDetail series) async {
    final result = await removeWatchlist.execute(series);

    result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(series.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchlistStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
