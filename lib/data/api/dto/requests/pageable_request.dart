class PageableRequest {
  const PageableRequest({
    this.page = 0,
    this.size = 30,
    this.sort = const [],
  });

  final int page;
  final int size;

  final List<Sort> sort;

  Map<String, dynamic> toJson() => {
        'page': this.page,
        'size': this.size,
        'sort': this.sort.map((e) => e.toString()).toList()
      };
}

class Sort {
  Sort({
    required this.fieldName,
    this.direction = SortDirection.asc,
  });

  final String fieldName;
  final SortDirection direction;

  @override
  String toString() {
    return '$fieldName,${direction.name}';
  }
}

enum SortDirection { asc, desc }
