import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_cubit.dart';
import 'search_state.dart';

import 'package:movie_app/shared/app_theme.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: Scaffold(
        backgroundColor: AppTheme.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 15),
          child: Column(
            children: [
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return TextFormField(
                    controller: _searchController,
                    style: const TextStyle(color: AppTheme.white),
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search_outlined),
                      ),
                      prefixIconColor: AppTheme.white,
                      hintText: "search",
                      hintStyle: const TextStyle(color: AppTheme.lightGray),
                      filled: true,
                      fillColor: AppTheme.gray,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: AppTheme.lightGray, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: AppTheme.white, width: 2),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      context.read<SearchCubit>().searchMovies(value);
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/Icon material-local-movies.png',
                              width: 70,
                              height: 70,
                              color: AppTheme.lightGray,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "No movies found",
                              style: TextStyle(color: AppTheme.lightGray),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is SearchLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppTheme.primary),
                    );
                  } else if (state is SearchLoaded) {
                    final results = state.results;
                    if (results.isEmpty && _searchController.text.isNotEmpty) {
                      return const Center(
                        child: Text(
                          "No results found.",
                          style: TextStyle(color: AppTheme.lightGray),
                        ),
                      );
                    } else if (results.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final movie = results[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  if (movie['poster_path'] != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        'https://image.tmdb.org/t/p/w92${movie['poster_path']}',
                                        width: 60,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie['title'],
                                          style: const TextStyle(
                                            color: AppTheme.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          movie['overview'] ?? "No description",
                                          style: const TextStyle(
                                            color: AppTheme.lightGray,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  } else if (state is SearchError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppTheme.lightGray),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
