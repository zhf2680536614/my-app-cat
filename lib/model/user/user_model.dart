import 'package:json_annotation/json_annotation.dart';

// 生成的代码会在 user_model.g.dart 文件中
part 'user_model.g.dart';

// 标记为需要序列化的类
@JsonSerializable()
class UserModel {
  final int id;
  final String name;
  @JsonKey(defaultValue: 0) // 若age为null，默认值为0
  final int age;
  final String? email; // 可选字段
  final String? phone; // 可选字段
  final String? address; // 可选字段

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    this.email,
    this.phone,
    this.address,
  });

  // 从 JSON 数据创建实例
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  // 将实例转换为 JSON 数据
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
