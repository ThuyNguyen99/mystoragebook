import 'package:flutter/foundation.dart';

class Probook {
  final String? id;
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final ValueNotifier<bool> _isStar;
  final ValueNotifier<bool> _isCompleted;

  Probook({
    this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    isStar = false,
    isCompleted = false,
  })  : _isStar = ValueNotifier(isStar),
        _isCompleted = ValueNotifier(isCompleted);

  set isStar(bool newValue) {
    _isStar.value = newValue;
  }

  bool get isStar {
    return _isStar.value;
  }

  ValueNotifier<bool> get isStarListenable {
    return _isStar;
  }

  set isCompleted(bool newValue) {
    _isCompleted.value = newValue;
  }

  bool get isCompleted {
    return _isCompleted.value;
  }

  ValueNotifier<bool> get isCompletedListenable {
    return _isCompleted;
  }

  Probook copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? imageUrl,
    bool? isStar,
    bool? isCompleted,
  }) {
    return Probook(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isStar: isStar ?? this.isStar,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  static Probook fromJson(Map<String, dynamic> json) {
    return Probook(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
