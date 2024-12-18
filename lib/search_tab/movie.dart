class Movie {
  final String title;
  final String? overview; 
  final String? releaseDate; 
  final String? posterPath; 

  Movie({
    required this.title,
    this.overview,
     this.releaseDate,
    this.posterPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? '',
      overview: json['overview'], 
      releaseDate: json['release_date'],
      posterPath: json['poster_path'],
    );
  }
}
