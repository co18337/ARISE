/// What came back from a model call.
///
/// A sealed result rather than exceptions, because "no key configured" and
/// "the network is down" are NORMAL states in this app, not errors. Every
/// caller has to have an offline answer anyway (see CLAUDE.md), so making the
/// unavailable case part of the type means the compiler asks for it.
library;

sealed class AiResult<T> {
  const AiResult();

  /// The value, or null for anything that did not succeed.
  T? get valueOrNull => switch (this) {
    AiOk<T>(:final value) => value,
    _ => null,
  };

  bool get isOk => this is AiOk<T>;

  /// One line suitable for showing a person.
  String get message => switch (this) {
    AiOk<T>() => 'ok',
    AiNoKey<T>() => 'No API key set — add one in assets/config/.env',
    AiOffline<T>(:final detail) => 'Could not reach the model: $detail',
    AiOverBudget<T>(:final used, :final limit) =>
      'Held back at $used of $limit calls today',
    AiBadResponse<T>(:final detail) => 'The model replied in an unusable shape: $detail',
  };
}

class AiOk<T> extends AiResult<T> {
  final T value;

  /// True when this came from the cache rather than the network.
  final bool cached;

  const AiOk(this.value, {this.cached = false});
}

/// No key configured. The expected state until one is added.
class AiNoKey<T> extends AiResult<T> {
  const AiNoKey();
}

/// Network, timeout, or the service refusing.
class AiOffline<T> extends AiResult<T> {
  final String detail;

  const AiOffline(this.detail);
}

/// Stopped before calling, to stay inside the free tier.
class AiOverBudget<T> extends AiResult<T> {
  final int used;
  final int limit;

  const AiOverBudget({required this.used, required this.limit});
}

/// A 200 that could not be parsed into the shape we asked for.
///
/// Deliberately distinct from [AiOffline]: this one means our schema and the
/// model's output disagree, which is a bug to fix rather than a condition to
/// wait out.
class AiBadResponse<T> extends AiResult<T> {
  final String detail;

  const AiBadResponse(this.detail);
}
