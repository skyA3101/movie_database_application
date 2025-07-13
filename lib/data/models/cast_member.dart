class CastMember {
  final String name;
  final String role;

  CastMember({required this.name, required this.role});

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      name: json['name'],
      role: json['character'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'character': role, // using 'character' key to match TMDB API format
    };
  }
}
