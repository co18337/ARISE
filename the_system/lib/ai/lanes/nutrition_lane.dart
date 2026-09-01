import 'dart:convert';

import '../../game/game.dart';
import '../../models/models.dart';
import '../ai_result.dart';
import '../gemini_client.dart';

/// One food from an entry, costed.
class AnalysedItem {
  final String name;

  /// As written, e.g. "2" or "1 cup". Kept so a wrong assumption is visible.
  final String quantity;

  final int kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fibreG;

  const AnalysedItem({
    required this.name,
    required this.quantity,
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fibreG,
  });

  MacroTotals get macros => MacroTotals(
    kcal: kcal,
    proteinG: proteinG,
    carbsG: carbsG,
    fatG: fatG,
    fibreG: fibreG,
  );

  Map<String, Object?> toJson() => {
    'name': name,
    'quantity': quantity,
    'kcal': kcal,
    'protein_g': proteinG,
    'carbs_g': carbsG,
    'fat_g': fatG,
    'fibre_g': fibreG,
  };

  static AnalysedItem fromJson(Map<String, Object?> json) => AnalysedItem(
    name: json['name'] as String? ?? 'item',
    quantity: json['quantity'] as String? ?? '',
    kcal: _num(json['kcal']).round(),
    proteinG: _num(json['protein_g']),
    carbsG: _num(json['carbs_g']),
    fatG: _num(json['fat_g']),
    fibreG: _num(json['fibre_g']),
  );

  static double _num(Object? v) => v is num ? v.toDouble() : 0;
}

/// What the model made of a typed meal.
class FoodAnalysis {
  final List<AnalysedItem> items;

  /// 0..1. Low means it had to guess a portion, and the screen says so rather
  /// than showing a number that looks measured.
  final double confidence;

  /// The guesses it had to make, in its own words.
  final String assumptions;

  const FoodAnalysis({
    required this.items,
    required this.confidence,
    required this.assumptions,
  });

  /// Summed HERE, not taken from the model.
  ///
  /// Language models are unreliable at arithmetic and reliable at recognising
  /// "two chapatis". Asking only for the per-item figures and adding them up
  /// ourselves plays to what it is actually good at, and means the totals can
  /// never disagree with the breakdown shown underneath them.
  MacroTotals get totals =>
      items.fold(MacroTotals.zero, (sum, item) => sum.plus(item.macros));

  String encodeItems() => jsonEncode([for (final i in items) i.toJson()]);

  static List<AnalysedItem> decodeItems(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final list = jsonDecode(raw) as List;
      return [
        for (final item in list)
          AnalysedItem.fromJson(item as Map<String, Object?>),
      ];
    } catch (_) {
      return const [];
    }
  }
}

/// Turns "2 chapatis whole wheat + 1 cup tea + salad" into macros.
///
/// Deliberately narrow. It costs food and nothing else: it does not comment on
/// whether the meal was a good idea, and it is told not to — interpreting what
/// someone should eat is a doctor's job, and this app totals and displays.
class NutritionLane {
  final GeminiClient client;

  const NutritionLane(this.client);

  static const String name = 'nutrition';

  static const String _system = '''
You estimate the nutritional content of food that someone has described in
their own words. They are logging what they actually ate, in plain English,
often in Indian home-cooking terms (chapati, dal, sabzi, poha, paneer, curd).

Rules:
- Break the description into individual foods. One entry per food.
- Use typical home portion sizes when a quantity is not given, and SAY SO in
  the assumptions field.
- "1 cup", "2 pieces", "a handful" are normal — interpret them sensibly.
- Give per-item figures only. Do not give totals; they are summed elsewhere.
- confidence is 0 to 1: near 1 when quantities are explicit and the foods are
  common, lower when you had to guess a portion or a recipe.
- Do NOT give dietary, medical or weight-loss advice. Do not comment on
  whether the meal was healthy. Only estimate what is in it.
''';

  static const Map<String, Object?> _schema = {
    'type': 'OBJECT',
    'properties': {
      'items': {
        'type': 'ARRAY',
        'items': {
          'type': 'OBJECT',
          'properties': {
            'name': {'type': 'STRING'},
            'quantity': {'type': 'STRING'},
            'kcal': {'type': 'NUMBER'},
            'protein_g': {'type': 'NUMBER'},
            'carbs_g': {'type': 'NUMBER'},
            'fat_g': {'type': 'NUMBER'},
            'fibre_g': {'type': 'NUMBER'},
          },
          'required': [
            'name',
            'quantity',
            'kcal',
            'protein_g',
            'carbs_g',
            'fat_g',
            'fibre_g',
          ],
        },
      },
      'confidence': {'type': 'NUMBER'},
      'assumptions': {'type': 'STRING'},
    },
    'required': ['items', 'confidence'],
  };

  Future<AiResult<FoodAnalysis>> analyse(String text, {MealSlot? slot}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return const AiBadResponse('nothing to analyse');
    }

    final result = await client.completeJson(
      lane: name,
      systemPrompt: _system,
      userPrompt: [
        if (slot != null) 'Meal: ${slot.label.toLowerCase()}.',
        'Eaten: $trimmed',
      ].join('\n'),
      schema: _schema,
      temperature: 0.1,
    );

    return switch (result) {
      AiOk(:final value, :final cached) => _parse(value, cached),
      AiNoKey<Map<String, Object?>>() => const AiNoKey(),
      AiOffline(:final detail) => AiOffline(detail),
      AiOverBudget(:final used, :final limit) =>
        AiOverBudget(used: used, limit: limit),
      AiBadResponse(:final detail) => AiBadResponse(detail),
    };
  }

  AiResult<FoodAnalysis> _parse(Map<String, Object?> json, bool cached) {
    final rawItems = json['items'];
    if (rawItems is! List || rawItems.isEmpty) {
      return const AiBadResponse('no items in the reply');
    }

    final items = [
      for (final item in rawItems)
        if (item is Map<String, Object?>) AnalysedItem.fromJson(item),
    ];
    if (items.isEmpty) return const AiBadResponse('items were unreadable');

    final confidence = json['confidence'];
    return AiOk(
      FoodAnalysis(
        items: items,
        confidence: confidence is num
            ? confidence.toDouble().clamp(0.0, 1.0)
            : 0.5,
        assumptions: json['assumptions'] as String? ?? '',
      ),
      cached: cached,
    );
  }
}
