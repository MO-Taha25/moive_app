import 'dart:convert';

// import 'package:collection/collection.dart';

// @immutable
class Search {
  final int? page;
  final List<dynamic>? results;
  final int? totalPages;
  final int? totalResults;

  const Search({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory Search.fromMap(Map<String, dynamic> data) => Search(
        page: data['page'] as int?,
        results: data['results'] as List<dynamic>?,
        totalPages: data['total_pages'] as int?,
        totalResults: data['total_results'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'page': page,
        'results': results,
        'total_pages': totalPages,
        'total_results': totalResults,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Search].
  factory Search.fromJson(String data) {
    return Search.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Search] to a JSON string.
  String toJson() => json.encode(toMap());
}
