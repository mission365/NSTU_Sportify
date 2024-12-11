class Notice {
  final int noticeId;
  final String title;
  final String content;
  final String postedDate;

  Notice({required this.noticeId, required this.title, required this.content, required this.postedDate});

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      noticeId: json['notice_id'],
      title: json['title'],
      content: json['content'],
      postedDate: json['posted_date'],
    );
  }
}
