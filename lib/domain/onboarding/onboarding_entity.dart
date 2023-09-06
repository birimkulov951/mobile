import 'package:equatable/equatable.dart';

class OnBoardingEntity with EquatableMixin {
  const OnBoardingEntity({
    required this.title,
    required this.description,
    required this.assetPath,
  });

  final String title;
  final String description;
  final String assetPath;

  @override
  List<Object> get props => [title, description, assetPath];

  @override
  String toString() {
    return 'OnBoardingEntity{'
        'title: $title, description: $description, assetPath: $assetPath}';
  }
}
