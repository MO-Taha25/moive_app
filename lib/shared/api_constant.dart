class ApiConstant {

  static const baseImageUrl = 'https://image.tmdb.org/t/p/w200';
  static String imageUrl(String path) => '$baseImageUrl$path' ;
  static const baseUrl = 'https://api.themoviedb.org/3';
  static const popular = '/movie/popular';
  static String details(int movieId) => '$baseUrl/movie/$movieId';
  static String similar(int movieId) => '$baseUrl/movie/$movieId/similar';
  static const upComing = '/movie/upcoming';
  static const topRated = '/movie/top_rated';
  static const search = '/search/movie';
  static const list = '/genre/movie/list';
  static const discover = '/discover/movie';
  static const apiKey = '876d0b60933265cad1eafd3f1ee7de8d';
}
