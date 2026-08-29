import 'package:flutter/material.dart';

/// Every colour in the app lives here. Nothing else should hardcode a hex
/// value — that way the whole look can be retuned from one file.
///
/// The palette is a dark sci-fi HUD: near-black navy backgrounds, an electric
/// cyan signature glow, with purple and gold reserved for rank/level-up
/// moments so those stay rare and feel special.
class AppColors {
  AppColors._(); // never instantiated — this is just a namespace

  // --- Backgrounds: near-black, tinted slightly blue so it reads as "screen"
  // rather than flat black.
  static const Color background = Color(0xFF05070D);
  static const Color surface = Color(0xFF0A0F18);
  static const Color surfaceRaised = Color(0xFF111826);

  /// Fill for panels. Deliberately semi-transparent so the grid backdrop
  /// shows faintly through the glass, like a projected status window.
  static const Color panelFill = Color(0x140E7FA8);

  // --- The signature glow.
  static const Color primary = Color(0xFF22D3EE); // electric cyan
  static const Color primaryBright = Color(0xFF7DF9FF); // hot highlight
  static const Color primaryDim = Color(0xFF0E7490); // inactive borders

  // --- Accents. Each has exactly ONE meaning; see DESIGN.md §1. A colour that
  // means something cannot also be used decoratively.
  static const Color accentPurple = Color(0xFFA855F7); // energy & progress
  static const Color accentGold = Color(0xFFFFC53D); // reward, claim, earned
  static const Color accentMagenta = Color(0xFFF0389D); // live / urgent
  static const Color danger = Color(0xFFFF4D6D); // penalties, missed quests

  /// The unfilled part of a tiered bar — what there still is to earn. Paired
  /// with [accentGold] for what already has been.
  static const Color remaining = Color(0xFF4ADE80);

  // --- Text. Cool-tinted whites; never pure #FFFFFF (too harsh on OLED).
  static const Color textPrimary = Color(0xFFE6F1FF);
  static const Color textSecondary = Color(0xFF8BA3BC);
  static const Color textDim = Color(0xFF52657C);

  // --- Per-stat colours, ready for the STATUS screen in Phase 4.
  static const Color statStr = Color(0xFFFF6B6B);
  static const Color statSta = Color(0xFF4ADE80);
  static const Color statDis = Color(0xFFA855F7);
  static const Color statRec = Color(0xFF22D3EE);

  /// The faint scanline/grid drawn behind everything (an Ingress-style
  /// "tactical overlay" touch).
  static const Color grid = Color(0x0F22D3EE);
}
