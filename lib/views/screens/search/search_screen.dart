import 'package:flutter/material.dart';
import 'package:pressly/views/screens/search/filter_search.dart';
import 'package:pressly/views/screens/search/result_list.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with AutomaticKeepAliveClientMixin {
  bool isExpanded = false;
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  String? selectedCategory;
  String? selectedCountry;
  String? selectedSource;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Provider.of<ThemeProvider>(context);
    
    // Check if any filter is active
    final bool isFilterActive = selectedCategory != null || selectedCountry != null || selectedSource != null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ======================
            // SEARCH BAR DI ATAS
            // ======================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() => isExpanded = true);
                  Future.delayed(
                    const Duration(milliseconds: 300),
                        () => focusNode.requestFocus(),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.isDarkMode
                        ? const Color(0xFF2F2F2F)
                        : const Color(0xFFE8E8E8),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      // FILTER BUTTON
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Material(
                          color: isFilterActive 
                              ? (theme.isDarkMode ? Colors.white : Colors.black)
                              : (theme.isDarkMode
                                  ? const Color(0xFF3A3A3A)
                                  : const Color(0xFFD0D0D0)),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (_) => DraggableScrollableSheet(
                                  initialChildSize: 0.5,
                                  minChildSize: 0.3,
                                  maxChildSize: 0.6,
                                  builder: (context, scrollController) {
                                    return FilterChipsOptions(
                                      scrollController: scrollController,
                                      initialCategory: selectedCategory,
                                      initialCountry: selectedCountry,
                                      initialSource: selectedSource,
                                      onFilterChanged: ({
                                        category,
                                        country,
                                        sourceName,
                                      }) {
                                        setState(() {
                                          selectedCategory = category;
                                          selectedCountry = country;
                                          selectedSource = sourceName;
                                        });
                                      },
                                    );
                                  }
                                ),
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.filter_list, 
                                size: 22,
                                color: isFilterActive 
                                    ? (theme.isDarkMode ? Colors.black : Colors.white)
                                    : (theme.isDarkMode ? Colors.white : Colors.black87),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          onChanged: (v) => setState(() {}),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Anything",
                            hintStyle: TextStyle(
                              color: theme.isDarkMode
                                  ? Colors.white54
                                  : Colors.black54,
                            ),
                          ),
                          style: TextStyle(
                            color: theme.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ================================
            // LIST HASIL PENCARIAN DI BAWAH
            // ================================
            Expanded(
              child: ResultList(
                keyword: controller.text.trim(),
                category: selectedCategory,
                country: selectedCountry,
                source: selectedSource,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
