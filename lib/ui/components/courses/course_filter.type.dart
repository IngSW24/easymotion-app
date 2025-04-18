class CourseFilterType {
  const CourseFilterType({
    required this.searchText,
    required this.categories,
    required this.levels,
    required this.frequencies,
    required this.availabilities,
  });
  final String searchText;
  final List<String> categories, levels, frequencies, availabilities;
}
