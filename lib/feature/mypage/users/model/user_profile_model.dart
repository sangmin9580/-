class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;
  final bool hasAvatar;
  final String address;
  final String detailAddress;
  final String nickName;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
    required this.hasAvatar,
    required this.address,
    required this.detailAddress,
    required this.nickName,
  });

  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        bio = "",
        link = "",
        hasAvatar = false,
        address = "",
        detailAddress = "",
        nickName = "";

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        email = json["email"],
        name = json["name"],
        bio = json["bio"],
        hasAvatar = json["hasAvatar"] ?? false,
        link = json["link"],
        address = json['address'],
        detailAddress = json['detailAddress'] ?? "",
        nickName = json['nickName'] ?? "";

  Map<String, String> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link,
      "address": address,
      "detailAdress": detailAddress,
      "nickName": nickName,
    };
  }

  UserProfileModel copyWith(
      {String? uid,
      String? email,
      String? name,
      String? bio,
      String? link,
      bool? hasAvatar,
      String? detailAddress,
      String? address,
      String? nickName}) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      link: link ?? this.link,
      hasAvatar: hasAvatar ?? this.hasAvatar,
      address: address ?? this.address,
      detailAddress: detailAddress ?? this.detailAddress,
      nickName: nickName ?? this.nickName,
    );
  }
}
