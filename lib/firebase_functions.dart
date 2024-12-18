import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_app/movies_tab/models/results.dart';

class FirebaseFunctions {
  static Future<void> addToWatchlist(
    Results movie,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('movies').add(movie.toJson());
      print('Movie added to watchlist successfully!');
    } catch (e) {
      print('Error adding movie to watchlist: $e');
    }
  }

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<void> saveMovieToWatchlist(Map<String, dynamic> movie) async {
    try {
      String userId = "default_user";
      await _firestore
          .collection('watchlist')
          .doc(userId)
          .collection('movies')
          .doc(movie['id'].toString())
          .add(movie);
    } catch (e) {
      print("Error saving movie to watchlist: $e");
    }
  }
}

extension on DocumentReference<Map<String, dynamic>> {
  add(Map<String, dynamic> movie) {
    FirebaseFirestore.instance.collection('movies').add(movie);
  }
}
