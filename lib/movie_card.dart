import 'package:flutter/material.dart';
import 'movie_detail_page.dart';
class MovieCard extends StatelessWidget {
  final dynamic movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () {
          // Navigate to movie details page
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.network(
                movie['image'] ?? '',
                height: 150,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    width: 100,
                    color: Colors.grey,
                    child: Icon(Icons.error),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie['title'] ?? 'No Title',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Rating: ${movie['rating'] ?? 'N/A'}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(height: 8),
                    Text(
                      movie['description'] ?? 'No description available',
                      style: Theme.of(context).textTheme.bodyText2,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}