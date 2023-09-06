class PaymentCategoryEntity {
  final String title;
  final String icon;
  final List<int> categoryIds;
  final List<int> excludedIds;
  final List<PaymentSubCategoryEntity> subCategories;

  PaymentCategoryEntity(
    this.title,
    this.icon, {
    this.categoryIds = const [],
    this.excludedIds = const [],
    this.subCategories = const [],
  });

  @override
  String toString() {
    return 'PaymentCategoryEntity{title: $title, icon: $icon, categoryIds: $categoryIds, excludedIds: $excludedIds}';
  }
}

class PaymentSubCategoryEntity {
  final String title;
  final String icon;
  final List<int> categoryIds;
  final List<int> excludedIds;

  PaymentSubCategoryEntity(
    this.title,
    this.icon, {
    this.categoryIds = const [],
    this.excludedIds = const [],
  });
}
