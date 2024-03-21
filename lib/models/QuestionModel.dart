class Question {
  final String que;
  final String a;
  final String b;
  final String c;
  final String d;
  final String correct;
  final String subject;
  final String? desc;

  Question(this.que, this.a, this.b, this.c, this.d, this.correct, this.subject,
      this.desc);

  static Question listToQuestion(List<String> data) {
    return Question(
        data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]);
  }
}
