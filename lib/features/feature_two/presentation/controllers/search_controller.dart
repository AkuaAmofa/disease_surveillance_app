import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchState {
  final String query;
  final int dateRangeIndex;
  final String diseaseFilter;
  final String severityFilter;
  final String locationFilter;

  const SearchState({
    this.query = '',
    this.dateRangeIndex = 0,
    this.diseaseFilter = 'All',
    this.severityFilter = 'All',
    this.locationFilter = 'All Locations',
  });

  SearchState copyWith({
    String? query,
    int? dateRangeIndex,
    String? diseaseFilter,
    String? severityFilter,
    String? locationFilter,
  }) {
    return SearchState(
      query: query ?? this.query,
      dateRangeIndex: dateRangeIndex ?? this.dateRangeIndex,
      diseaseFilter: diseaseFilter ?? this.diseaseFilter,
      severityFilter: severityFilter ?? this.severityFilter,
      locationFilter: locationFilter ?? this.locationFilter,
    );
  }
}

class AppSearchController extends StateNotifier<SearchState> {
  AppSearchController() : super(const SearchState());

  void setQuery(String v) => state = state.copyWith(query: v);
  void setDateRange(int v) => state = state.copyWith(dateRangeIndex: v);
  void setDisease(String v) => state = state.copyWith(diseaseFilter: v);
  void setSeverity(String v) => state = state.copyWith(severityFilter: v);
  void setLocation(String v) => state = state.copyWith(locationFilter: v);

  void reset() => state = const SearchState();
}

final appSearchControllerProvider =
    StateNotifierProvider<AppSearchController, SearchState>((ref) {
  return AppSearchController();
});

final recentSearchesProvider = Provider<List<String>>((ref) {
  return ['Malaria Accra', 'Cholera outbreak', 'Ga West alerts'];
});
