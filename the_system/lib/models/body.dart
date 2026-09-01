/// A body region the MC-780 reports separately.
///
/// Five segments, always the same five, in the order the report prints them.
enum BodySegment {
  trunk('TRUNK'),
  rightArm('RIGHT ARM'),
  leftArm('LEFT ARM'),
  rightLeg('RIGHT LEG'),
  leftLeg('LEFT LEG');

  final String label;

  const BodySegment(this.label);
}
