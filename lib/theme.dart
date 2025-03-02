import 'package:flutter/material.dart';

class KaraageThemeData {
  static ThemeData defaultTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    extensions: [
      /// COLORS
      KaraageColors(
        accent: Color.fromARGB(255, 218, 165, 32),
        textPrimary: Colors.white,
        textSecondary: Colors.white70,
        textTertiary: Colors.white60,
      ),

      /// TEXT STYLES
      KaraageTextStyles(
        bodySmallPrimary: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodySmallSecondary: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white70,
        ),
      ),
    ],
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
      bodySmall: TextStyle(fontSize: 12, color: Colors.grey),
    ),
  );
}

// CUSTOM COLORS EXTENSION
@immutable
class KaraageColors extends ThemeExtension<KaraageColors> {
  final Color? accent;
  final Color? textPrimary;
  final Color? textSecondary;
  final Color? textTertiary;

  const KaraageColors({
    required this.accent,
    this.textPrimary,
    this.textSecondary,
    this.textTertiary,
  });

  @override
  KaraageColors copyWith({Color? accent, Color? danger, Color? success}) {
    return KaraageColors(
      accent: accent ?? this.accent,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
      textTertiary: textTertiary,
    );
  }

  @override
  KaraageColors lerp(ThemeExtension<KaraageColors>? other, double t) {
    if (other is! KaraageColors) return this;
    return KaraageColors(
      accent: Color.lerp(accent, other.accent, t),
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t),
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t),
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t),
    );
  }
}

// CUSTOM TEXT STYLES EXTENSION
@immutable
class KaraageTextStyles extends ThemeExtension<KaraageTextStyles> {
  final TextStyle? bodySmallPrimary;
  final TextStyle? bodySmallSecondary;

  const KaraageTextStyles({
    required this.bodySmallPrimary,
    required this.bodySmallSecondary,
  });

  @override
  KaraageTextStyles copyWith({
    TextStyle? bodySmallPrimary,
    TextStyle? bodySmallSecondary,
    TextStyle? bodySmallTertiary,
  }) {
    return KaraageTextStyles(
      bodySmallPrimary: bodySmallPrimary ?? this.bodySmallPrimary,
      bodySmallSecondary: bodySmallSecondary ?? this.bodySmallSecondary,
    );
  }

  @override
  KaraageTextStyles lerp(ThemeExtension<KaraageTextStyles>? other, double t) {
    if (other is! KaraageTextStyles) return this;
    return KaraageTextStyles(
      bodySmallPrimary: TextStyle.lerp(
        bodySmallPrimary,
        other.bodySmallPrimary,
        t,
      ),
      bodySmallSecondary: TextStyle.lerp(
        bodySmallSecondary,
        other.bodySmallSecondary,
        t,
      ),
    );
  }
}
