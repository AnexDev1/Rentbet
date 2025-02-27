// dart
import 'package:flutter/material.dart';
import 'package:rentbet/views/listings/listings_page.dart';
import 'package:rentbet/views/listings/widgets/listing_card.dart';
import '../../models/listing_model.dart';
import '../../services/listings_service.dart';
import '../details/details_page.dart';

class SearchResultsPage extends StatefulWidget {
  final String searchQuery;
  const SearchResultsPage({super.key, required this.searchQuery});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<Listing> _listings = [];
  bool _isLoading = true;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults() async {
    setState(() => _isLoading = true);
    final listings = await ListingsService().fetchListings();
    final filtered = listings.where((listing) {
      return listing.title
          .toLowerCase()
          .contains(widget.searchQuery.toLowerCase());
    }).toList();
    setState(() {
      _listings = filtered;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListingsPage(),
                  ),
                );
              },
            ),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchResultsPage(searchQuery: value),
                ),
              );
            }
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _listings.isEmpty
          ? const Center(child: Text('No results found.'))
          : ListView.separated(
        padding: const EdgeInsets.all(16.0),
        separatorBuilder: (context, index) =>
        const SizedBox(height: 16),
        itemCount: _listings.length,
        itemBuilder: (context, index) {
          final listing = _listings[index];
          return ListingCard(
            listing: listing,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    property: {
                      'imageUrl': listing.imageUrl,
                      'price': '\$${listing.price}',
                      'location': listing.location,
                      'title': listing.title,
                      'desc': listing.description,
                      'category': listing.category,
                      'type': listing.type,
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}