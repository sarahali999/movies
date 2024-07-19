import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'movie_card.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<dynamic> movies = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    Dio dio = Dio();
    dio.options.connectTimeout = Duration(seconds: 30);
    dio.options.receiveTimeout = Duration(seconds: 30);

    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        print('Attempting to fetch movies (attempt ${retryCount + 1})');
        final response = await dio.get(
          'https://imdb-top-100-movies.p.rapidapi.com/',
          options: Options(
            headers: {
              'X-RapidAPI-Key': '722d8c4501msh557eee964317515p1c549cjsn8c4931e1e1ba',
              'X-RapidAPI-Host': 'imdb-top-100-movies.p.rapidapi.com',
            },
          ),
        );

        print('Response received. Status code: ${response.statusCode}');

        if (response.statusCode == 200) {
          setState(() {
            movies = response.data;
            movies.shuffle(); // Randomize the order of all movies
            isLoading = false;
          });
          return;
        } else {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: 'Failed to load movies. Status code: ${response.statusCode}',
          );
        }
      } on DioException catch (e) {
        print('DioError occurred: $e');
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          errorMessage = 'The connection has timed out. Please check your internet connection and try again.';
        } else if (e.type == DioExceptionType.badResponse) {
          errorMessage = 'Server error: ${e.response?.statusCode}. Please try again later.';
        } else {
          errorMessage = 'Network error: ${e.message}. Please check your connection and try again.';
        }
      } catch (e) {
        print('Unexpected error occurred: $e');
        errorMessage = 'An unexpected error occurred. Please try again.';
      }

      retryCount++;
      if (retryCount < maxRetries) {
        await Future.delayed(Duration(seconds: 2 * retryCount));
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : errorMessage.isNotEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMessage, style: TextStyle(color: Colors.white)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: fetchMovies,
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    )
        : movies.isEmpty
        ? Center(child: Text('No movies found', style: TextStyle(color: Colors.white)))
        : Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
          items: movies.take(5).map((movie) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(movie['image'] ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(movie: movie);
            },
          ),
        ),
      ],
    );
  }
}