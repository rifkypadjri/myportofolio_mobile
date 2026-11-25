import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Portfolio project synchronized with the Django REST Framework API.
///
/// Mirrors `ProjectSerializer` of the web backend: id, title, description,
/// thumbnail and the read-only star fields.
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    required this.title,
    required this.description,
    this.thumbnail = '',
    this.id,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// UUID assigned by the server, so it is never sent in a request body.
  @JsonKey(includeToJson: false)
  final String? id;

  final String title;
  final String description;

  /// Optional image URL; the API may send null or omit it.
  @JsonKey(defaultValue: '')
  final String thumbnail;

  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;

  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String starredByNames;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
