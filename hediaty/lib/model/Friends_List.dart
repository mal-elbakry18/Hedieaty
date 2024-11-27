class FriendsList {
  int userId;
  int friendId;

  FriendsList({
    required this.userId,
    required this.friendId,
  });

  // Convert a FriendsList object to a Map
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'friend_id': friendId,
    };
  }

  // Create a FriendsList object from a Map
  factory FriendsList.fromMap(Map<String, dynamic> map) {
    return FriendsList(
      userId: map['user_id'],
      friendId: map['friend_id'],
    );
  }
}
