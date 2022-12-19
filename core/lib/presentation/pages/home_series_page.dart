// ignore_for_file: library_private_types_in_public_api, constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core.dart';
import '../../domain/entities/series.dart';
import '../provider/series_list_notifier.dart';
import '../widgets/custom_drawer.dart';
import 'on_the_air_series_page.dart';
import 'popular_series_page.dart';
import 'series_detail_page.dart';
import 'top_rated_series_page.dart';

class HomeSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/home-series';

  const HomeSeriesPage({super.key});

  @override
  _HomeSeriesPageState createState() => _HomeSeriesPageState();
}

class _HomeSeriesPageState extends State<HomeSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<SeriesListNotifier>(context, listen: false)
          ..fetchTopRatedSeries()
          ..fetchPopularSeries()
          ..fetchOnTheAirSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomDrawer(
        content: Scaffold(
          appBar: AppBar(
            title: const Text('Moris'),
            leading: const Icon(Icons.menu),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, SEARCH_SERIES_ROUTE);
                },
                icon: const Icon(Icons.search),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSubHeading(
                    title: 'Popular',
                    onTap: () => Navigator.pushNamed(
                        context, PopularSeriesPage.ROUTE_NAME),
                  ),
                  Consumer<SeriesListNotifier>(builder: (context, data, child) {
                    final state = data.popularSeriesState;
                    if (state == RequestState.Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state == RequestState.Loaded) {
                      return MovieList(data.popularSeries);
                    } else {
                      return const Text('Failed');
                    }
                  }),
                  _buildSubHeading(
                    title: 'Top Rated',
                    onTap: () => Navigator.pushNamed(
                        context, TopRatedSeriesPage.ROUTE_NAME),
                  ),
                  Consumer<SeriesListNotifier>(builder: (context, data, child) {
                    final state = data.topRatedSeriesState;
                    if (state == RequestState.Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state == RequestState.Loaded) {
                      return MovieList(data.topRatedSeries);
                    } else {
                      return const Text('Failed');
                    }
                  }),
                  _buildSubHeading(
                    title: 'On The Air',
                    onTap: () => Navigator.pushNamed(
                        context, OnTheAirSeriesPage.ROUTE_NAME),
                  ),
                  Consumer<SeriesListNotifier>(builder: (context, data, child) {
                    final state = data.onTheAirSeriesState;
                    if (state == RequestState.Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state == RequestState.Loaded) {
                      return MovieList(data.onTheAirSeries);
                    } else {
                      return const Text('Failed');
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Series> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SeriesDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
