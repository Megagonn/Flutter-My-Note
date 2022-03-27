class Note {
  final int? id;
  final String content;
  final String category;
  final String date;

  Note({
    this.id,
    required this.content,
    required this.category,
    required this.date,
  });

  Map<String, Object> toMap(Note note) {
    return {
      'content': note.content,
      'category': note.category,
      'date': note.date,
    };
  }

  factory Note.fromMap(Map map) {
    return Note(
      id: map['id'],
      content: map['content'],
      category: map['category'],
      date: map['date'],
    );
  }
}
