// dart
import 'package:flutter/material.dart';

class DetailsStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final String selectedCategory;
  final String selectedType;
  final List<String> categories;
  final List<String> types;

  const DetailsStep({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.priceController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.selectedType,
    required this.categories,
    required this.types,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Property Details',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Property Title',
              prefixIcon: Icon(Icons.title, color: theme.iconTheme.color),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.primaryColor),
              ),
            ),
            validator: (value) =>
            value?.isEmpty ?? true ? 'Please enter title' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'Price',
              prefixIcon: Icon(Icons.attach_money, color: theme.iconTheme.color),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.primaryColor),
              ),
            ),
            keyboardType: TextInputType.number,
            validator: (value) =>
            value?.isEmpty ?? true ? 'Please enter price' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: InputDecoration(
              labelText: 'Category',
              prefixIcon: Icon(Icons.category, color: theme.iconTheme.color),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
            ),
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category, style: theme.textTheme.bodyLarge),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                // Handle category change if needed
              }
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedType,
            decoration: InputDecoration(
              labelText: 'Property Type',
              prefixIcon: Icon(Icons.home_work, color: theme.iconTheme.color),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
            ),
            items: types.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type, style: theme.textTheme.bodyLarge),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                // Handle type change if needed
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.description, color: theme.iconTheme.color),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.primaryColor),
              ),
            ),
            validator: (value) =>
            value?.isEmpty ?? true ? 'Please enter description' : null,
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}