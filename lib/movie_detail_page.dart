import 'package:flutter/material.dart';
class MovieDetailPage extends StatelessWidget {
  final dynamic movie;
  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title'] ?? 'Movie Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              movie['image'] ?? '',
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'] ?? 'No title',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Theme.of(context).colorScheme.secondary, // Soft Gold
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Rating: ${movie['rating'] ?? 'N/A'}',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    movie['description'] ?? 'No description',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  // Add more details here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
