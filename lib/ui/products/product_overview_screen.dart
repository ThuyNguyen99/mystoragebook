import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'products_grid.dart';
import '../shared/app_drawer.dart';
import 'products_manager.dart';

enum FilterOptions { stars, all }

class ProbooksOverviewScreen extends StatefulWidget {
  const ProbooksOverviewScreen({super.key});

  @override
  State<ProbooksOverviewScreen> createState() => _ProbooksOverviewScreenState();
}

class _ProbooksOverviewScreenState extends State<ProbooksOverviewScreen> {
  final _showOnlyStars = ValueNotifier<bool>(false);
  List<String> imageList = [
    "https://i.pinimg.com/736x/6b/91/90/6b91908898d9201678f8c321e087252f.jpg",
    "https://wallpaperaccess.com/full/1121997.jpg",
    "https://avante.biz/wp-content/uploads/Ysk-ygc/Ysk-ygc17.jpg",
    "https://www.hdwallpapers.in/download/brown_hair_dress_short_hair_hd_girl_anime-1366x768.jpg"
  ];
  late Future<void> _fetchProbooks;

  @override
  void initState() {
    super.initState();
    _fetchProbooks = context.read<ProbooksManager>().fetchProbooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Book',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          buildProbookFilterMenu(),
        ],
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: CarouselSlider(
                items: imageList
                    .map((e) => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                e,
                                height: 200,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  height: 180,
                )),
          ),
          Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 200.0),
                child: ListTile(
                  leading: const Icon(Icons.home,
                      color: Color.fromARGB(255, 16, 139, 241)),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Color.fromARGB(255, 16, 139, 241)),
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
              ),
              const Divider(),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 280.0),
            child: FutureBuilder(
              future: _fetchProbooks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ValueListenableBuilder<bool>(
                      valueListenable: _showOnlyStars,
                      builder: (context, onlyStars, child) {
                        return ProbooksGrid(onlyStars);
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProbookFilterMenu() {
    return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
        if (selectedValue == FilterOptions.stars) {
          _showOnlyStars.value = true;
        } else {
          _showOnlyStars.value = false;
        }
      },
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.stars,
          child: Icon(Icons.star),
        ),
      ],
    );
  }
}
