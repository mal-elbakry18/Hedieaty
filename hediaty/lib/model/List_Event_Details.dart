class ListEventDetails {
  int? id;
  int listId;
  int giftId;
  String status; // 'available', 'pledged', etc.
  int? pledgedBy; // User who pledged the gift

  ListEventDetails({
    this.id,
    required this.listId,
    required this.giftId,
    required this.status,
    this.pledgedBy,
  });

  // Convert a ListEventDetails object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'list_id': listId,
      'gift_id': giftId,
      'status': status,
      'pledged_by': pledgedBy,
    };
  }

  // Create a ListEventDetails object from a Map
  factory ListEventDetails.fromMap(Map<String, dynamic> map) {
    return ListEventDetails(
      id: map['id'],
      listId: map['list_id'],
      giftId: map['gift_id'],
      status: map['status'],
      pledgedBy: map['pledged_by'],
    );
  }
}
