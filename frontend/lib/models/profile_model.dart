class ProfileModel {
  final String? id;
  final String userId;
  final String fullName;
  final String? bio;
  final String? avatar;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileModel({
    this.id,
    required this.userId,
    required this.fullName,
    this.bio,
    this.avatar,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'],
      userId: json['userId'],
      fullName: json['fullName'],
      bio: json['bio'],
      avatar: json['avatar'],
      address: json['address'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'bio': bio,
      'avatar': avatar,
      'address': address,
    };
  }

  ProfileModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? bio,
    String? avatar,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
