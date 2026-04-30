import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'l10n/app_localizations.dart';

final ValueNotifier<String> globalUserName = ValueNotifier<String>('');
final ValueNotifier<String> globalUserEmail = ValueNotifier<String>('');

final ValueNotifier<String?> globalRegion = ValueNotifier<String?>(null);
final ValueNotifier<String> globalSchoolType = ValueNotifier<String>('urban');
final ValueNotifier<bool> globalHasQuota = ValueNotifier<bool>(false);

final ValueNotifier<bool> globalIsTestPassed = ValueNotifier<bool>(false);
final ValueNotifier<String> globalTestResult = ValueNotifier<String>('');

final ValueNotifier<String> globalProf1 = ValueNotifier<String>('');
final ValueNotifier<String> globalProf2 = ValueNotifier<String>('');

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

Map<String, List<String>> getSmartCombos(AppLocalizations l10n) {
  return {
    l10n.subj_math: [l10n.subj_physics, l10n.subj_geography, l10n.subj_informatics],
    l10n.subj_biology: [l10n.subj_chemistry, l10n.subj_geography],
    l10n.subj_foreign_lang: [l10n.subj_world_history, l10n.subj_geography],
    l10n.subj_geography: [l10n.subj_world_history, l10n.subj_foreign_lang],
    l10n.subj_chemistry: [l10n.subj_physics, l10n.subj_biology],
    l10n.subj_world_history: [l10n.subj_law, l10n.subj_geography],
    l10n.subj_language: [l10n.subj_literature],
    l10n.creative_exam: [l10n.creative_exam],
  };
}

void showSmartComboPicker(BuildContext context, Color cardBgColor, Color textPrimary, Color textSecondary, Color primaryCyan, Function(String, String) onSelect) {
  final l10n = AppLocalizations.of(context)!;
  final combos = getSmartCombos(l10n);
  
  String? tempSubj1;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(color: cardBgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(width: 40, height: 4, decoration: BoxDecoration(color: textSecondary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 16),
                Text(tempSubj1 == null ? l10n.first_subject : l10n.second_subject, style: GoogleFonts.spaceGrotesk(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: tempSubj1 == null ? combos.keys.length : combos[tempSubj1]!.length,
                    itemBuilder: (context, index) {
                      final item = tempSubj1 == null ? combos.keys.elementAt(index) : combos[tempSubj1]![index];
                      return ListTile(
                        leading: Icon(tempSubj1 == null ? Icons.looks_one_rounded : Icons.looks_two_rounded, color: primaryCyan),
                        title: Text(item, style: GoogleFonts.inter(color: textPrimary)),
                        onTap: () {
                          setModalState(() {
                            if (tempSubj1 == null) {
                              tempSubj1 = item;
                              if (tempSubj1 == l10n.creative_exam) {
                                onSelect(tempSubj1!, tempSubj1!);
                                Navigator.pop(context);
                              }
                            } else {
                              onSelect(tempSubj1!, item);
                              Navigator.pop(context);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                if (tempSubj1 != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: () => setModalState(() => tempSubj1 = null),
                      child: Text("Назад", style: TextStyle(color: textSecondary)),
                    ),
                  )
              ],
            ),
          );
        }
      );
    }
  );
}