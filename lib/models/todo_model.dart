class TodoModel {
  String? title;
  String? desc;
  int?
      priority; //1-> low(blue),2-> medium(orange),3-> high(red),when completed->(green)
  bool? isCompleted;
  String? assignAt;
  String? completeAt;

  TodoModel(
      {required this.title,
      required this.desc,
      this.isCompleted = false,
      this.priority = 1,
      required this.assignAt,
      this.completeAt});

  factory TodoModel.fromMap({required Map<String, dynamic> map}) {
    return TodoModel(
        title: map['title'],
        desc: map['desc'],
        isCompleted: map['isComp'],
        priority: map['priority'],
        assignAt: map['assignAt'],
        completeAt: map['completeAt']);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'desc': desc,
      'isComp': isCompleted,
      'priority': priority,
      'assignAt': assignAt,
      'completeAt': completeAt
    };
  }
}
