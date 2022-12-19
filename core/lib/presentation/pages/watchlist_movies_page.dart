// ignore_for_file: constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core.dart';
import '../../utils/utils.dart';
import '../provider/watchlist_movie_notifier.dart';
import '../provider/watchlist_series_notifier.dart';
import '../widgets/movie_card_list.dart';
import '../widgets/series_card_list.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  const WatchlistMoviesPage({super.key});

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<WatchlistMovieNotifier>(context, listen: false)
          .fetchWatchlistMovies();
      Provider.of<WatchlistSeriesNotifier>(context, listen: false)
          .fetchWatchlistSeries();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(context, listen: false)
        .fetchWatchlistMovies();
    Provider.of<WatchlistSeriesNotifier>(context, listen: false)
        .fetchWatchlistSeries();
  }

  int current = 0;

  List<String> items = ["Movies", "Series"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.only(left: 16),
            decoration: const BoxDecoration(color: kGrey),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            current = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          margin: const EdgeInsets.all(5),
                          width: 93,
                          height: 44,
                          decoration: BoxDecoration(
                            color:
                                current == index ? kMikadoYellow : kDavysGrey,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Center(
                            child: Text(
                              items[index],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          if (current == 0) ...[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<WatchlistMovieNotifier>(
                  builder: (context, data, child) {
                    if (data.watchlistState == RequestState.Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (data.watchlistState == RequestState.Loaded) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final movie = data.watchlistMovies[index];
                          return MovieCard(movie);
                        },
                        itemCount: data.watchlistMovies.length,
                      );
                    } else {
                      return Center(
                        key: const Key('error_message'),
                        child: Text(data.message),
                      );
                    }
                  },
                ),
              ),
            ),
          ] else if (current == 1) ...[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<WatchlistSeriesNotifier>(
                  builder: (context, data, child) {
                    if (data.watchlistState == RequestState.Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (data.watchlistState == RequestState.Loaded) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final movie = data.watchlistSeries[index];
                          return SeriesCard(movie);
                        },
                        itemCount: data.watchlistSeries.length,
                      );
                    } else {
                      return Center(
                        key: const Key('error_message'),
                        child: Text(data.message),
                      );
                    }
                  },
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
