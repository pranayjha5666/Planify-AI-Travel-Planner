class ProfileModel {
  final String name;
  final String email;
  final String profileImage;

  ProfileModel({
    required this.name,
    required this.email,
    required this.profileImage,
  });

  // Factory method to create an instance from Firestore data
  factory ProfileModel.fromMap(Map<String, dynamic> data) {
    return ProfileModel(
      name: data['name'] ?? "Unknown",
      email: data['email'] ?? "No Email",
      profileImage: data['profileImage'] ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=500&auto=format&fit=crop',
    );
  }
}
