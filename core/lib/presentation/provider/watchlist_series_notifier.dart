import 'package:flutter/foundation.dart';

import '../../core.dart';
import '../../domain/entities/series.dart';
import '../../domain/usecases/get_watchlist_series.dart';

class WatchlistSeriesNotifier extends ChangeNotifier {
  var _watchlistSeries = <Series>[];
  List<Series> get watchlistSeries => _watchlistSeries;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  final GetWatchlistSeries getWatchlistSeries;

  WatchlistSeriesNotifier({required this.getWatchlistSeries});

  Future<void> fetchWatchlistSeries() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistSeries.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (seriesData) {
        _watchlistState = RequestState.Loaded;
        _watchlistSeries = seriesData;
        notifyListeners();
      },
    );
  }
}
