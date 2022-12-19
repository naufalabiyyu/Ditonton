// ignore_for_file: constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core.dart';
import '../provider/top_rated_series_notifier.dart';
import '../widgets/series_card_list.dart';

class TopRatedSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-series';

  const TopRatedSeriesPage({super.key});

  @override
  _TopRatedSeriesPageState createState() => _TopRatedSeriesPageState();
}

class _TopRatedSeriesPageState extends State<TopRatedSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TopRatedSeriesNotifier>(context, listen: false)
            .fetchTopRatedSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedSeriesNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data.series[index];
                  return SeriesCard(movie);
                },
                itemCount: data.series.length,
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
    );
  }
}
