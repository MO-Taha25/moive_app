import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/movies_tab/models/results.dart';

class WatchlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Watchlist',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 32,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('movies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'No movies found!',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final movies = snapshot.data!.docs
              .map(
                (doc) => Results.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                leading: SizedBox(
                  width: 60,
                  height: 100,
                  child: movie.posterPath != null
                      ? Image.network(
                          movie.posterPath!,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.movie, color: Colors.white),
                ),
                title: Text(
                  movie.title ?? 'No Title',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                subtitle: movie.releaseDate != null
                    ? Text(
                        'Release Date: ${movie.releaseDate}',
                        style: TextStyle(color: Colors.grey),
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
