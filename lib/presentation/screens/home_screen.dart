import 'package:flutter/material.dart';
import 'package:pilem/data/model/movie.dart';
import 'package:pilem/data/services/api_service.dart';
import 'package:pilem/presentation/screens/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  List<Movie> _allMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final List<Map<String, dynamic>> allMoviesData =
        await _apiService.getAllMovies();
    final List<Map<String, dynamic>> trendingMoviesData =
        await _apiService.getTrendingMovies();
    final List<Map<String, dynamic>> popularMoviesData =
        await _apiService.getPopularMovies();

    setState(() {
      _allMovies = allMoviesData.map((json) => Movie.fromJson(json)).toList();
      _trendingMovies =
          trendingMoviesData.map((json) => Movie.fromJson(json)).toList();
      _popularMovies =
          popularMoviesData.map((json) => Movie.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilem'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMovieList('All Movies', _allMovies),
            _buildMovieList('Trending Movies', _trendingMovies),
            _buildMovieList('Popular Movies', _popularMovies)
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              final Movie movie = movies[index];
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DetailScreen(movie: movie);
                  })); // Fix the extra closing parenthesis here
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.network(
                        'https://image.tmbd.org/t/p/w500${movie.posterPath}',
                        height: 150,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        movie.title.length > 14
                            ? '${movie.title.substring(0, 10)}...'
                            : movie.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
