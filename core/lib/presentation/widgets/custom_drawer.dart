import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';

import '../pages/home_series_page.dart';
import '../pages/watchlist_movies_page.dart';

class CustomDrawer extends StatefulWidget {
  final Widget content;
  const CustomDrawer({super.key, required this.content});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  Widget _buildDrawer() {
    return Column(
      children: [
        const UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage('assets/circle-g.png'),
          ),
          accountName: Text('Ditonton'),
          accountEmail: Text('ditonton@dicoding.com'),
        ),
        ListTile(
          leading: const Icon(Icons.movie_creation_outlined),
          title: const Text('Movies'),
          onTap: () {
            Navigator.pushNamed(context, '/home-movie');
          },
        ),
        ListTile(
          leading: const Icon(Icons.tv_rounded),
          title: const Text('Series'),
          onTap: () {
            Navigator.pushNamed(context, HomeSeriesPage.ROUTE_NAME);
          },
        ),
        ListTile(
          leading: const Icon(Icons.save_alt),
          title: const Text('Watchlist'),
          onTap: () {
            Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          onTap: () => Navigator.pushNamed(context, ABOUT_ROUTE),
        ),
      ],
    );
  }

  void toggle() => _animationController.isDismissed
      ? _animationController.forward()
      : _animationController.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            double slide = 255.0 * _animationController.value;
            double scale = 1 - (_animationController.value * 0.3);

            return Stack(
              children: [
                _buildDrawer(),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(slide)
                    ..scale(scale),
                  alignment: Alignment.centerLeft,
                  child: widget.content,
                ),
              ],
            );
          }),
    );
  }
}
