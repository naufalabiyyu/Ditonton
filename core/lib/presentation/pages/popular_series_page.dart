// ignore_for_file: constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core.dart';
import '../provider/popular_series_notifier.dart';
import '../widgets/series_card_list.dart';

class PopularSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-series';

  const PopularSeriesPage({super.key});

  @override
  _PopularSeriesPageState createState() => _PopularSeriesPageState();
}

class _PopularSeriesPageState extends State<PopularSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PopularSeriesNotifier>(context, listen: false)
            .fetchPopularSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularSeriesNotifier>(
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
