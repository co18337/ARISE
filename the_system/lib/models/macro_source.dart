/// Where a food entry's macros came from.
enum MacroSource {
  /// Typed but not yet costed.
  none('NOT ANALYSED'),

  /// Estimated by the model.
  model('ESTIMATED'),

  /// Entered or corrected by hand. Always wins — a correction is the one
  /// number in the row that somebody actually knows.
  manual('YOURS');

  final String label;

  const MacroSource(this.label);
}
