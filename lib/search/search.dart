class SearchParams {
  String title_keyword;
  DateTime start_date;
  DateTime end_date;
  List<String> categories;

  SearchParams(
      this.title_keyword, this.start_date, this.end_date, this.categories);
}
