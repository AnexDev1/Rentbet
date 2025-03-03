// dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_providers.dart';
import '../search_result_page.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onFilter;
  const SearchBarWidget({Key? key, required this.onFilter}) : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  String _activeValue = 'default';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseTextColor = theme.textTheme.bodyLarge?.color;
    return Row(
      children: [
        Expanded(
          child: TextField(
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultsPage(searchQuery: value),
                  ),
                );
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              hintText: 'Search',
              hintStyle: TextStyle(color: theme.hintColor),
              prefixIcon: Icon(
                Icons.search_outlined,
                size: 30,
                color: theme.iconTheme.color,
              ),
              filled: true,
              fillColor: theme.inputDecorationTheme.fillColor ?? Colors.transparent,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(30.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: theme.dividerColor),
            color: Colors.transparent,
          ),
          child: PopupMenuButton<String>(
            icon: Icon(
              Icons.filter_list_rounded,
              size: 30,
              color: theme.iconTheme.color,
            ),
            offset: const Offset(0, 10),
            elevation: 8,
            color: theme.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'default',
                height: 50,
                padding: EdgeInsets.zero,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _activeValue == 'default'
                        ? theme.highlightColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.canvasColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.sort,
                            color: theme.iconTheme.color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Default',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: _activeValue == 'default'
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: baseTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'rent',
                height: 50,
                padding: EdgeInsets.zero,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _activeValue == 'rent'
                        ? theme.highlightColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.home,
                            color: theme.colorScheme.onPrimary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Rent',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          _activeValue == 'rent' ? FontWeight.w600 : FontWeight.normal,
                          color: baseTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'sell',
                height: 50,
                padding: EdgeInsets.zero,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _activeValue == 'sell'
                        ? theme.highlightColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.attach_money,
                            color: theme.colorScheme.onSecondary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Sell',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          _activeValue == 'sell' ? FontWeight.w600 : FontWeight.normal,
                          color: baseTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            onSelected: (value) {
              setState(() {
                _activeValue = value;
              });
              widget.onFilter(value);
            },
          ),
        ),
        // IconButton(
        //   icon: Icon(
        //     Provider.of<ThemeProviders>(context).isDarkMode ? Icons.light_mode : Icons.dark_mode,
        //     color: theme.iconTheme.color,
        //   ),
        //   onPressed: () {
        //     Provider.of<ThemeProviders>(context, listen: false).toggleThemeMode();
        //   },
        // ),
      ],
    );
  }
}