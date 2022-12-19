// ignore_for_file: constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core.dart';
import '../provider/on_the_air_notifier.dart';
import '../widgets/series_card_list.dart';

class OnTheAirSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/on-the-air-series';

  const OnTheAirSeriesPage({super.key});

  @override
  _OnTheAirSeriesPageState createState() => _OnTheAirSeriesPageState();
}

class _OnTheAirSeriesPageState extends State<OnTheAirSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<OnTheAirNotifierSeries>(context, listen: false)
            .fetchOnTheAirSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On The Air Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<OnTheAirNotifierSeries>(
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
