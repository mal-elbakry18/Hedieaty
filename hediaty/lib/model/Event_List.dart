class ListEvent {
  int? id;
  String name;
  int? listDetailsId;
  int userId;

  ListEvent({
    this.id,
    required this.name,
    this.listDetailsId,
    required this.userId,
  });

  // Convert a ListEvent object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'list_details_id': listDetailsId,
      'user_id': userId,
    };
  }

  // Create a ListEvent object from a Map
  factory ListEvent.fromMap(Map<String, dynamic> map) {
    return ListEvent(
      id: map['id'],
      name: map['name'],
      listDetailsId: map['list_details_id'],
      userId: map['user_id'],
    );
  }
}
