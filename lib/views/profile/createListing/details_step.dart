// dart
import 'package:flutter/material.dart';

class DetailsStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final String initialCategory;
  final String initialType;
  final List<String> categories;
  final List<String> types;
  final void Function(String category, String type) onValuesChanged;

  const DetailsStep({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.priceController,
    required this.descriptionController,
    required this.initialCategory,
    required this.initialType,
    required this.categories,
    required this.types,
    required this.onValuesChanged,
  });

  @override
  State<DetailsStep> createState() => _DetailsStepState();
}

class _DetailsStepState extends State<DetailsStep> {
  late String selectedCategory;
  late String selectedType;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    selectedType = widget.initialType;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onValuesChanged(selectedCategory, selectedType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: widget.formKey,
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
            controller: widget.titleController,
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
            validator: (value) => value?.isEmpty ?? true ? 'Please enter title' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.priceController,
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
            validator: (value) => value?.isEmpty ?? true ? 'Please enter price' : null,
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
            items: widget.categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category, style: theme.textTheme.bodyLarge),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedCategory = value;
                });
                widget.onValuesChanged(selectedCategory, selectedType);
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
            items: widget.types.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type, style: theme.textTheme.bodyLarge),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedType = value;
                });
                widget.onValuesChanged(selectedCategory, selectedType);
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.descriptionController,
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