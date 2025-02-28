// dart
import 'package:flutter/material.dart';
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
              hintStyle: const TextStyle(color: Colors.black54),
              prefixIcon: const Icon(Icons.search_outlined, size: 30),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(30.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.black26),
            color: Colors.transparent,
          ),
          child: PopupMenuButton<String>(
            icon: Icon(Icons.filter_list_rounded, size: 30, color: Colors.black87),
            offset: const Offset(0, 10),
            elevation: 8,
            color: Colors.white,
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
                    color: _activeValue == 'default' ? Colors.grey[200] : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.sort, color: Colors.black87, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Default',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: _activeValue == 'default' ? FontWeight.w600 : FontWeight.normal,
                          color: Colors.black87,
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
                    color: _activeValue == 'rent' ? Colors.grey[200] : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.home, color: Colors.blue[700], size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Rent',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: _activeValue == 'rent' ? FontWeight.w600 : FontWeight.normal,
                          color: Colors.black87,
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
                    color: _activeValue == 'sell' ? Colors.grey[200] : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.attach_money, color: Colors.green[700], size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Sell',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: _activeValue == 'sell' ? FontWeight.w600 : FontWeight.normal,
                          color: Colors.black87,
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
        )
      ],
    );
  }
}