class Thing {
  String title;
  String content;
  DateTime date;

  Thing({this.title, this.content, this.date});
}

final Map<String, int> categories = {
  'All': 112,
  'Work': 58,
  'Home': 23,
};

final List<Thing> things = [
  Thing(
    title: 'Buy ticket',
    content: 'Buy airplane ticket through Kayak for \$318.38',
    date: DateTime(2019, 10, 10, 8, 30),
  ),
  Thing(
    title: 'Walk with dog',
    content: 'Walk on the street with my favorite dog.',
    date: DateTime(2019, 10, 10, 8, 30),
  ),
];
