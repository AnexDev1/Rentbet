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
  final Color primaryColor;

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
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Property Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Property Title',
              prefixIcon: Icon(Icons.title),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Please enter title' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'Price',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            keyboardType: TextInputType.number,
            validator: (value) => value?.isEmpty ?? true ? 'Please enter price' : null,
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: InputDecoration(
              labelText: 'Category',
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                // Update selected category
              }
            },
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedType,
            decoration: InputDecoration(
              labelText: 'Property Type',
              prefixIcon: Icon(Icons.home_work),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: types.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                // Update selected type
              }
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.description),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Please enter description' : null,
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}