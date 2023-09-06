class FieldSwitcher {
  FieldSwitcher._({
    required this.isFieldSwitcherHidden,
    required this.hasPrevious,
    required this.hasNext,
  });

  factory FieldSwitcher.hide() {
    return FieldSwitcher._(
      isFieldSwitcherHidden: true,
      hasPrevious: false,
      hasNext: true,
    );
  }

  factory FieldSwitcher.hasPrev() {
    return FieldSwitcher._(
      isFieldSwitcherHidden: false,
      hasPrevious: true,
      hasNext: false,
    );
  }

  factory FieldSwitcher.hasNext() {
    return FieldSwitcher._(
      isFieldSwitcherHidden: false,
      hasPrevious: false,
      hasNext: true,
    );
  }

  final bool isFieldSwitcherHidden;
  final bool hasPrevious;
  final bool hasNext;
}
