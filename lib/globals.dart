import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'l10n/app_localizations.dart';

final ValueNotifier<String> globalUserName = ValueNotifier<String>('Adil');
final ValueNotifier<String> globalUserEmail = ValueNotifier<String>('adilaiserik@gmail.com');

final ValueNotifier<String?> globalRegion = ValueNotifier<String?>(null);
final ValueNotifier<String> globalSchoolType = ValueNotifier<String>('city');
final ValueNotifier<bool> globalHasQuota = ValueNotifier<bool>(false);

List<String> getLocalizedRegions(String langCode) {
  if (langCode == 'kk') {
    return [
      'Астана қ.', 'Алматы қ.', 'Шымкент қ.', 'Абай обл.', 'Ақмола обл.',
      'Ақтөбе обл.', 'Алматы обл.', 'Атырау обл.', 'Батыс Қазақстан обл.',
      'Жамбыл обл.', 'Жетісу обл.', 'Қарағанды обл.', 'Қостанай обл.',
      'Қызылорда обл.', 'Маңғыстау обл.', 'Павлодар обл.', 'Солтүстік Қазақстан обл.',
      'Түркістан обл.', 'Ұлытау обл.', 'Шығыс Қазақстан обл.'
    ];
  } else if (langCode == 'en') {
    return [
      'Astana', 'Almaty', 'Shymkent', 'Abai Region', 'Akmola Region',
      'Aktobe Region', 'Almaty Region', 'Atyrau Region', 'West Kazakhstan Region',
      'Zhambyl Region', 'Zhetysu Region', 'Karaganda Region', 'Kostanay Region',
      'Kyzylorda Region', 'Mangystau Region', 'Pavlodar Region', 'North Kazakhstan Region',
      'Turkistan Region', 'Ulytau Region', 'East Kazakhstan Region'
    ];
  }
  return [
    'Астана', 'Алматы', 'Шымкент', 'Абайская обл.', 'Акмолинская обл.',
    'Актюбинская обл.', 'Алматинская обл.', 'Атырауская обл.',
    'Западно-Казахстанская обл.', 'Жамбылская обл.', 'Жетысуская обл.',
    'Карагандинская обл.', 'Костанайская обл.', 'Кызылординская обл.',
    'Мангистауская обл.', 'Павлодарская обл.', 'Северо-Казахстанская обл.',
    'Туркестанская обл.', 'Улытауская обл.', 'Восточно-Казахстанская обл.'
  ];
}

void showRegionPicker(BuildContext context, Color cardBgColor, Color textPrimary, Color textSecondary, Color primaryCyan, Function(String) onSelect) {
  final langCode = Localizations.localeOf(context).languageCode;
  final regions = getLocalizedRegions(langCode);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(color: cardBgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: textSecondary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text(langCode == 'kk' ? 'Аймақты таңдаңыз' : (langCode == 'en' ? 'Select Region' : 'Выберите регион'), style: GoogleFonts.spaceGrotesk(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: regions.length,
                itemBuilder: (context, index) {
                  final region = regions[index];
                  return ListTile(
                    leading: Icon(Icons.location_on_outlined, color: primaryCyan),
                    title: Text(region, style: GoogleFonts.inter(color: textPrimary)),
                    onTap: () {
                      onSelect(region);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  );
}

final ValueNotifier<bool> globalIsDarkMode = ValueNotifier<bool>(false);
final ValueNotifier<int> globalComboIndex = ValueNotifier<int>(2); 

class EntCombo {
  final String subj1;
  final String subj2;
  EntCombo(this.subj1, this.subj2);
}

List<EntCombo> getEntCombos(AppLocalizations l10n) {
  return [
    EntCombo(l10n.subj_math, l10n.subj_physics),
    EntCombo(l10n.subj_math, l10n.subj_geography),
    EntCombo(l10n.subj_math, l10n.subj_informatics), 
    EntCombo(l10n.subj_biology, l10n.subj_chemistry),
    EntCombo(l10n.subj_biology, l10n.subj_geography),
    EntCombo(l10n.subj_foreign_lang, l10n.subj_world_history),
    EntCombo(l10n.subj_geography, l10n.subj_world_history),
    EntCombo(l10n.subj_chemistry, l10n.subj_physics),
    EntCombo(l10n.subj_world_history, l10n.subj_law),
    EntCombo(l10n.subj_language, l10n.subj_literature),
  ];
}

void showComboPicker(BuildContext context, Color cardBgColor, Color textPrimary, Color textSecondary, Color primaryCyan, Function(int) onSelect) {
  final l10n = AppLocalizations.of(context)!;
  final combos = getEntCombos(l10n);
  
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(color: cardBgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: textSecondary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text(l10n.select_combo, style: GoogleFonts.spaceGrotesk(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: combos.length,
                itemBuilder: (context, index) {
                  final combo = combos[index];
                  return ListTile(
                    leading: Icon(Icons.school_outlined, color: primaryCyan),
                    title: Text("${combo.subj1} + ${combo.subj2}", style: GoogleFonts.inter(color: textPrimary)),
                    onTap: () {
                      onSelect(index);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  );
}