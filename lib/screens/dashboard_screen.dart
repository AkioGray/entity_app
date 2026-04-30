import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../globals.dart';
import '../models/university.dart';
import '../data/university_repository.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/animated_button.dart';
import '../widgets/empty_state.dart';
import '../utils/debouncer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  final Debouncer _searchDebouncer = Debouncer(milliseconds: 500);
  final List<University> _universities = [];
  
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 0;
  bool _hasMore = true;
  
  String? _selectedCity;
  String _searchQuery = '';
  List<String> _availableCities = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _currentPage = 0;
      _universities.clear();
      _hasMore = true;
    });

    try {
      final lang = Localizations.localeOf(context).languageCode;
      final cities = await UniversityRepository.getFilterCities();
      final newUniversities = await UniversityRepository.getUniversities(
        page: _currentPage, cityFilter: _selectedCity, searchQuery: _searchQuery, lang: lang,
      );

      if (mounted) {
        setState(() {
          _availableCities = cities;
          _universities.addAll(newUniversities);
          _isLoading = false;
          if (newUniversities.length < 10) _hasMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(UniversityRepository.friendlyError(e)),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() => _isLoadingMore = true);
    _currentPage++;

    try {
      final lang = Localizations.localeOf(context).languageCode;
      final newUniversities = await UniversityRepository.getUniversities(
        page: _currentPage, cityFilter: _selectedCity, searchQuery: _searchQuery, lang: lang,
      );

      if (mounted) {
        setState(() {
          _universities.addAll(newUniversities);
          _isLoadingMore = false;
          if (newUniversities.isEmpty || newUniversities.length < 10) _hasMore = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() { _isLoadingMore = false; _currentPage--; });
    }

  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _showFilterSheet(BuildContext context, Color cardBgColor, Color textPrimary, Color textSecondary, Color primaryCyan, AppLocalizations l10n) {
    String? tempSelectedCity = _selectedCity;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(color: cardBgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: textSecondary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 24),
                  Text(l10n.filters, style: GoogleFonts.spaceGrotesk(color: textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Text(l10n.city_filter, style: GoogleFonts.inter(color: textSecondary, fontSize: 14)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(l10n.all_cities, style: TextStyle(color: tempSelectedCity == null ? Colors.white : textPrimary)),
                        selected: tempSelectedCity == null,
                        selectedColor: primaryCyan,
                        backgroundColor: cardBgColor,
                        onSelected: (val) => setModalState(() => tempSelectedCity = null),
                      ),
                      ..._availableCities.map((city) {
                        return ChoiceChip(
                          label: Text(city, style: TextStyle(color: tempSelectedCity == city ? Colors.white : textPrimary)),
                          selected: tempSelectedCity == city,
                          selectedColor: primaryCyan,
                          backgroundColor: cardBgColor,
                          onSelected: (val) => setModalState(() => tempSelectedCity = city),
                        );
                      }),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedEntityButton(
                          text: l10n.reset_filters,
                          colors: const [Color(0xFF64748B), Color(0xFF64748B)],
                          isOutlined: true,
                          onPressed: () {
                            setState(() {
                              _selectedCity = null;
                            });
                            Navigator.pop(context);
                            _loadInitialData();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AnimatedEntityButton(
                          text: l10n.apply_filters,
                          colors: [primaryCyan, const Color(0xFFAB55F7)],
                          onPressed: () {
                            setState(() {
                              _selectedCity = tempSelectedCity;
                            });
                            Navigator.pop(context);
                            _loadInitialData();
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<bool>(
      valueListenable: globalIsDarkMode,
      builder: (context, isDark, _) {
        final Color cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final Color inputBgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
        final Color primaryCyan = isDark ? const Color(0xFF00E5FF) : const Color(0xFF06B6D4);
        final Color textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
        final Color textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        final Color borderColor = isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0);
        final titleStyle = GoogleFonts.spaceGrotesk(color: textPrimary, fontWeight: FontWeight.bold);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(color: inputBgColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded, color: textSecondary, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              style: TextStyle(color: textPrimary),
                              decoration: InputDecoration(hintText: l10n.search_hint, hintStyle: TextStyle(color: textSecondary), border: InputBorder.none),
                              onChanged: (value) {
                                _searchDebouncer.run(() {
                                  setState(() => _searchQuery = value);
                                  _loadInitialData();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _showFilterSheet(context, cardBgColor, textPrimary, textSecondary, primaryCyan, l10n),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(color: _selectedCity != null ? primaryCyan.withValues(alpha: 0.1) : inputBgColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: _selectedCity != null ? primaryCyan : borderColor)),
                      child: Icon(Icons.tune_rounded, color: _selectedCity != null ? primaryCyan : textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: _isLoading
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: 5,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SkeletonLoader(width: double.infinity, height: 120, borderRadius: 16, isDark: isDark),
                    ),
                  )
                : _universities.isEmpty
                  ? RefreshIndicator(
                      color: primaryCyan,
                      onRefresh: _loadInitialData,
                      child: ListView(
                        children: [EmptyStateWidget(
                          icon: Icons.travel_explore_rounded,
                          title: l10n.not_found,
                          subtitle: "Попробуйте изменить параметры поиска или сбросить фильтры",
                          isDark: isDark,
                          buttonText: l10n.reset_filters,
                          onButtonPressed: () {
                            setState(() { _selectedCity = null; _searchQuery = ''; });
                            _loadInitialData();
                          },
                        )],
                      ),
                    )
                  : RefreshIndicator(
                      color: primaryCyan,
                      onRefresh: _loadInitialData,
                      child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _universities.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _universities.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator(color: primaryCyan)),
                          );
                        }

                        final uni = _universities[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: cardBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(color: primaryCyan.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                                child: uni.logoUrl != null
                                    ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(uni.logoUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.account_balance_rounded, color: primaryCyan)))
                                    : Icon(Icons.account_balance_rounded, color: primaryCyan),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(uni.name, style: titleStyle.copyWith(fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_rounded, size: 14, color: textSecondary),
                                        const SizedBox(width: 4),
                                        Expanded(child: Text(uni.city, style: GoogleFonts.inter(color: textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (uni.rating != null)
                                          Row(children: [
                                            const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
                                            const SizedBox(width: 4),
                                            Text(uni.rating!.toStringAsFixed(1), style: titleStyle.copyWith(fontSize: 14, color: const Color(0xFFFBBF24))),
                                          ]),
                                        if (uni.tuitionFeeMin != null)
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(l10n.score_threshold, style: GoogleFonts.inter(color: textSecondary, fontSize: 10)),
                                              Text('${(uni.tuitionFeeMin! / 1000).toInt()}к ₸', style: titleStyle.copyWith(fontSize: 14, color: primaryCyan)),
                                            ],
                                          ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            ),
          ],
        );
      }
    );
  }
}