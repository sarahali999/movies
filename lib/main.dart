import 'package:flutter/material.dart';
import 'movie_list_page.dart';
import 'movie_card.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMDB Top Movies',
      theme: ThemeData(
        colorScheme: ColorScheme.dark().copyWith(
          primary: Color(0xFF1A237E), // Deep Indigo
          secondary: Color(0xFFFFD54F), // Soft Gold
          background: Color(0xFF121212), // Dark Gray
          surface: Color(0xFF1E1E1E), // Slightly Lighter Gray
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onBackground: Colors.white,
        ),
        scaffoldBackgroundColor: Color(0xFF121212), // Dark Gray
        appBarTheme: AppBarTheme(
          color: Color(0xFF1A237E), // Deep Indigo
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Color(0xFFFFD54F), // Soft Gold
            onPrimary: Colors.black,
          ),
        ),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark().copyWith(
          primary: Color(0xFF1A237E), // Deep Indigo
          secondary: Color(0xFFFFD54F), // Soft Gold
          background: Color(0xFF121212), // Dark Gray
          surface: Color(0xFF1E1E1E), // Slightly Lighter Gray
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onBackground: Colors.white,
        ),
        scaffoldBackgroundColor: Color(0xFF121212), // Dark Gray
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MovieListPage(),
    GenresPage(),
    RatingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          margin: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: AppBar(
            title: Text('IMDB Top Movies'),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: MovieSearchDelegate());
                },
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
            elevation: 10,
            shadowColor: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('IMDB Top Movies'),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings page
              },
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                // Navigate to about page
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _children[_currentIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BottomNavigationBar(
                    onTap: onTabTapped,
                    currentIndex: _currentIndex,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.white.withOpacity(0.6),
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.movie),
                        label: 'All Movies',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.category),
                        label: 'Genres',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.star),
                        label: 'Top Rated',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
class GenresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement genres page
    return Center(child: Text('Genres Page', style: TextStyle(color: Colors.white)));
  }
}
class RatingsPage extends StatefulWidget {
  @override
  _RatingsPageState createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  List<dynamic> topRatedMovies = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchTopRatedMovies();
  }

  Future<void> fetchTopRatedMovies() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    Dio dio = Dio();
    dio.options.connectTimeout = Duration(seconds: 30);
    dio.options.receiveTimeout = Duration(seconds: 30);

    try {
      final response = await dio.get(
        'https://imdb-top-100-movies.p.rapidapi.com/',
        options: Options(
          headers: {
            'X-RapidAPI-Key': '722d8c4501msh557eee964317515p1c549cjsn8c4931e1e1ba',
            'X-RapidAPI-Host': 'imdb-top-100-movies.p.rapidapi.com',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          topRatedMovies = (response.data as List).take(10).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load top-rated movies. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load top-rated movies: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 40.0,

              flexibleSpace: FlexibleSpaceBar(
                title: Text('Top 10 Rated Movies'),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
        ),
      );
    } else if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchTopRatedMovies,
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.secondary,
                onPrimary: Colors.black,
              ),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: topRatedMovies.length,
        itemBuilder: (context, index) {
          final movie = topRatedMovies[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: MovieCard(movie: movie),
          );
        },
      );
    }
  }
}
class MovieSearchDelegate extends SearchDelegate {
  List<dynamic> allMovies = []; // Add a way to initialize with the movie list

  @override
  String get searchFieldLabel => 'Search movies';

  @override
  TextStyle get searchFieldStyle => TextStyle(color: Colors.white);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
      ),
      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = allMovies.where((movie) {
      return movie['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final movie = results[index];
        return MovieCard(movie: movie);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = allMovies.where((movie) {
      return movie['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final movie = suggestions[index];
        return MovieCard(movie: movie);
      },
    );
  }
}