import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../providers/language_provider.dart';
import '../../../providers/theme_provider.dart';

class FilterChipsOptions extends StatefulWidget {
  final String? initialCategory;
  final String? initialCountry;
  final String? initialSource;
  final ScrollController? scrollController;
  final Function({
  String? category,
  String? country,
  String? sourceName,
  })? onFilterChanged;

  const FilterChipsOptions({
    super.key,
    this.initialCategory,
    this.initialCountry,
    this.initialSource,
    this.scrollController,
    this.onFilterChanged,
  });

  @override
  State<FilterChipsOptions> createState() => _FilterChipsOptionsState();
}

class _FilterChipsOptionsState extends State<FilterChipsOptions> {
  final supabase = Supabase.instance.client;

  String? selectedCategory;
  String? selectedCountry;
  String? selectedSource;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    selectedCountry = widget.initialCountry;
    selectedSource = widget.initialSource;
  }

  Future<Map<String, List<String>>> loadFilterData() async {
    final List<dynamic> response = await supabase
        .from("news_article")
        .select("category, country, source_name");

    final items = response.cast<Map<String, dynamic>>();

    final categories = <String>{};
    final countries = <String>{};
    final sources = <String>{};

    for (var item in items) {
      if (item["category"] != null && item["category"].toString().isNotEmpty) {
        categories.add(item["category"]);
      }
      if (item["country"] != null && item["country"].toString().isNotEmpty) {
        countries.add(item["country"]);
      }
      if (item["source_name"] != null &&
          item["source_name"].toString().isNotEmpty) {
        sources.add(item["source_name"]);
      }
    }

    return {
      "category": categories.toList(),
      "country": countries.toList(),
      "source_name": sources.toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final language = Provider.of<LanguageProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: FutureBuilder(
        future: loadFilterData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(
              height: 200,
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          final data = snapshot.data!;
          final categories = data["category"]!;
          final countries = data["country"]!;
          final sources = data["source_name"]!;

          return SingleChildScrollView(
            controller: widget.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // DRAG HANDLE INDICATOR
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: theme.isDarkMode ? Colors.white24 : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                _section(language.getText('category'), categories, selectedCategory, theme,
                        (value) {
                      setState(() {
                        selectedCategory =
                        selectedCategory == value ? null : value;
                      });

                      widget.onFilterChanged?.call(
                        category: selectedCategory,
                        country: selectedCountry,
                        sourceName: selectedSource,
                      );
                    }),

                const SizedBox(height: 20),

                _section(language.getText('country'), countries, selectedCountry, theme, (value) {
                  setState(() {
                    selectedCountry = selectedCountry == value ? null : value;
                  });

                  widget.onFilterChanged?.call(
                    category: selectedCategory,
                    country: selectedCountry,
                    sourceName: selectedSource,
                  );
                }),

                const SizedBox(height: 20),

                _section(
                    language.getText('source'), sources, selectedSource, theme, (value) {
                  setState(() {
                    selectedSource = selectedSource == value ? null : value;
                  });

                  widget.onFilterChanged?.call(
                    category: selectedCategory,
                    country: selectedCountry,
                    sourceName: selectedSource,
                  );
                }),
                
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ----------- UI RAPIH UNTUK SETIAP SECTION -----------
  Widget _section(
      String title,
      List<String> items,
      String? selectedValue,
      ThemeProvider theme,
      Function(String) onTap,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: theme.isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items
              .map((e) => _chip(
            label: e,
            selected: selectedValue == e,
            isDark: theme.isDarkMode,
            onTap: () => onTap(e),
          ))
              .toList(),
        ),
      ],
    );
  }

  /// ----------- CHIP RAPIH & MODERN -----------
  Widget _chip({
    required String label,
    required bool selected,
    required bool isDark,
    required Function() onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected
            ? Colors.blue
            : (isDark ? const Color(0xFF2E2E2E) : const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected
              ? Colors.blueAccent
              : (isDark ? Colors.white10 : Colors.black12),
          width: selected ? 1.2 : 0.8,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: selected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.black87),
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
