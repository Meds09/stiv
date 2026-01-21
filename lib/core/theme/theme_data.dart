// ===== Colores de marca y semánticos =====
import 'package:flutter/material.dart';

class AppColors {
  // Marca
  static const Color primary = Color(0xFF0663EF); // Azul STIV
  static const Color primaryDark = Color(0xFF0A1E3A);
  static const Color background = Color(0xFFEFEAE3);
  static const Color surface = Colors.white;
  static const Color card = Color.fromARGB(255, 243, 239, 235);
  static const Color card2 =   Color.fromARGB(255, 246, 243, 243);

  // Texto
  static const Color textPrimary = Color(0xFF0B1220);
  static const Color textSecondary = Color(0xFF5B667A);
  static const Color textOnPrimary = Colors.white;

  // Líneas / bordes
  static const Color border = Color(0xFFE3E8EF);
  static const Color outline = Color(0xFFD6DEEB);

  // Semánticos
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}

// ===== Espaciados, radios, sombras, duraciones =====
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppRadii {
  static const Radius sm = Radius.circular(8);
  static const Radius md = Radius.circular(12);
  static const Radius lg = Radius.circular(20);
  static const BorderRadius brSm = BorderRadius.all(sm);
  static const BorderRadius brMd = BorderRadius.all(md);
  static const BorderRadius brLg = BorderRadius.all(lg);
}

class AppShadows {
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x14000000), // 8% negro
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
  static const List<BoxShadow> none = [];
}

class AppDurations {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 400);
}

// ===== Tipografías Rubik / Inter =====
class AppTextStyles {
  // Titulares (Rubik)
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Rubik',
    fontWeight: FontWeight.w700,
    fontSize: 28,
    height: 1.2,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );
  // titular en azul
  static const TextStyle t1 = TextStyle(
    fontFamily: 'Rubik',
    fontWeight: FontWeight.w700,
    fontSize: 26,
    height: 1.2,
    letterSpacing: -0.2,
    color: AppColors.primary,
  );

  // titular en azul
  static const TextStyle t2 = TextStyle(
    fontFamily: 'Rubik',
    fontWeight: FontWeight.w700,
    fontSize: 22,
    height: 1.2,
    letterSpacing: -0.2,
    color: AppColors.primary,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'Rubik',
    fontWeight: FontWeight.w700,
    fontSize: 22,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: 'Rubik',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: 'Rubik',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.3,
    color: AppColors.primary,
  );

  // Subtítulos (Inter)
  static const TextStyle subtitle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  // Texto normal (Inter)
  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: Color(0xFF363D48),
  );

  // Texto pequeño (Inter)
  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}

// ===== Estilos de botones =====
class AppButtonStyles {
  static final ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textOnPrimary,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: AppRadii.brMd),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    textStyle: const TextStyle(
      fontFamily: 'Rubik',
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
  );

  static final ButtonStyle tonal = FilledButton.styleFrom(
    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
    foregroundColor: AppColors.primary,
    shape: RoundedRectangleBorder(borderRadius: AppRadii.brMd),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    textStyle: const TextStyle(
      fontFamily: 'Rubik',
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
  );

  static final ButtonStyle outline = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    side: const BorderSide(color: AppColors.outline),
    shape: RoundedRectangleBorder(borderRadius: AppRadii.brMd),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    textStyle: const TextStyle(
      fontFamily: 'Rubik',
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
  );
}

// ===== ThemeData (claro / oscuro) =====
class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      secondary: AppColors.info,
      outline: AppColors.outline,
      error: AppColors.danger,
    ),
    fontFamily: 'Inter', // Fuente base
    textTheme: const TextTheme(
      displaySmall: AppTextStyles.h1,
      headlineSmall: AppTextStyles.h2,
      titleMedium: AppTextStyles.subtitle,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.caption,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: AppButtonStyles.primary,
    ),
    filledButtonTheme: FilledButtonThemeData(style: AppButtonStyles.tonal),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: AppButtonStyles.outline,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: AppRadii.brMd,
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadii.brMd,
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadii.brMd,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
      hintStyle: AppTextStyles.body,
      labelStyle: AppTextStyles.body,
    ),
    dividerColor: AppColors.border,
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D1526),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColors.primary,
      surface: Color(0xFF0F1B33),
      onSurface: Colors.white,
      secondary: AppColors.info,
      outline: Color(0xFF23314D),
      error: AppColors.danger,
    ),
    fontFamily: 'Inter', // Fuente base
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontFamily: 'Rubik',
        fontWeight: FontWeight.w700,
        fontSize: 28,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Rubik',
        fontWeight: FontWeight.w700,
        fontSize: 22,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Color(0xFFB7C2D6),
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: Color(0xFF8FA0BF),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: AppButtonStyles.primary,
    ),
    filledButtonTheme: FilledButtonThemeData(style: AppButtonStyles.tonal),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: AppButtonStyles.outline,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF0F1B33),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: AppRadii.brMd,
        borderSide: const BorderSide(color: Color(0xFF23314D)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadii.brMd,
        borderSide: const BorderSide(color: Color(0xFF23314D)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: AppRadii.brMd,
        borderSide: BorderSide(color: AppColors.primary, width: 1.4),
      ),
      hintStyle: TextStyle(fontFamily: 'Inter', color: Color(0xFF8FA0BF)),
      labelStyle: TextStyle(fontFamily: 'Inter', color: Color(0xFF8FA0BF)),
    ),
    dividerColor: const Color(0xFF23314D),
  );
}

// ===== Extensiones útiles =====
extension BuildContextThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get text => Theme.of(this).textTheme;
  ColorScheme get scheme => Theme.of(this).colorScheme;
}

extension NameFormatter on String {
  String get capitalized {
    return split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
