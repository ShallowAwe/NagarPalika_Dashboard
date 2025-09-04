import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nagarpalika_dashboard/model/category_model.dart';
import 'package:smart_nagarpalika_dashboard/model/location_model.dart';
import 'package:smart_nagarpalika_dashboard/providers/category_provider.dart';
import 'package:smart_nagarpalika_dashboard/providers/location_provider.dart';
import 'package:smart_nagarpalika_dashboard/widgets/add_category.dart';
import 'package:smart_nagarpalika_dashboard/widgets/create_location.dart';
import 'package:smart_nagarpalika_dashboard/widgets/expandable_listView.dart';
import 'package:smart_nagarpalika_dashboard/widgets/quickaction_cards.dart';

class LocationPage extends ConsumerStatefulWidget {
  const LocationPage({super.key});

  @override
  ConsumerState<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends ConsumerState<LocationPage> {
  bool _isLocationsExpanded = false;
  bool _isCategoriesExpanded = false;
  String? _selectedCategoryFilter;

  void _refreshCategories() {
    ref.read(categoryProvider.notifier).refresh();
  }

  void _refreshLocations() {
    ref.read(locationProvider.notifier).refresh();
  }

  void _toggleLocationsExpansion() {
    setState(() {
      _isLocationsExpanded = !_isLocationsExpanded;
    });
  }

  void _toggleCategoriesExpansion() {
    setState(() {
      _isCategoriesExpanded = !_isCategoriesExpanded;
    });
  }

  List<Location> _getFilteredLocations(List<Location> locations) {
    if (_selectedCategoryFilter == null || _selectedCategoryFilter == 'All') {
      return locations;
    }
    return locations
        .where((location) => location.categoryName == _selectedCategoryFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(locationProvider);
    final locationList = locations.valueOrNull ?? [];
    final categories = ref.watch(categoryProvider);
    final categoriesList = categories.valueOrNull ?? [];
    final filteredLocations = _getFilteredLocations(locationList);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),

            // Category Filter
            _buildCategoryFilter(categoriesList),
            const SizedBox(height: 16),

            // Locations + Categories side by side (responsive)
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 800) {
                  // Small screen → stack vertically
                  return Column(
                    children: [
                      _buildLocationsTable(filteredLocations, locations),
                      const SizedBox(height: 24),
                      ExpandableListWidget<Categories>(
                        state: categories,
                        list: categoriesList,
                        title: 'Categories',
                        isExpanded: _isCategoriesExpanded,
                        onToggleExpansion: _toggleCategoriesExpansion,
                        onRefresh: _refreshCategories,
                        headerIcon: Icons.category,
                        headerIconColor: Colors.orange,
                        emptyMessage: 'No categories found',
                        errorMessage: 'Failed to load categories',
                        itemBuilder: (category, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange.shade50,
                              child: Icon(Icons.category, color: Colors.orange),
                            ),
                            title: Text(category.name),
                            subtitle: Text(category.name),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  // Large screen → side by side
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child:
                            _buildLocationsTable(filteredLocations, locations),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: ExpandableListWidget<Categories>(
                          state: categories,
                          list: categoriesList,
                          title: 'Categories',
                          isExpanded: _isCategoriesExpanded,
                          onToggleExpansion: _toggleCategoriesExpansion,
                          onRefresh: _refreshCategories,
                          headerIcon: Icons.category,
                          headerIconColor: Colors.orange,
                          emptyMessage: 'No categories found',
                          errorMessage: 'Failed to load categories',
                          itemBuilder: (category, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange.shade50,
                                child:
                                    Icon(Icons.category, color: Colors.orange),
                              ),
                              title: Text(category.name),
                              subtitle: Text(category.name),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(List<Categories> categories) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, color: Colors.blue.shade600),
          const SizedBox(width: 12),
          Text(
            'Filter by Category:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCategoryFilter,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade400),
                ),
              ),
              hint: const Text('All Categories'),
              items: [
                const DropdownMenuItem<String>(
                  value: 'All',
                  child: Text('All Categories'),
                ),
                ...categories.map(
                  (category) => DropdownMenuItem<String>(
                    value: category.name,
                    child: Text(category.name),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategoryFilter = value;
                });
              },
            ),
          ),
          if (_selectedCategoryFilter != null &&
              _selectedCategoryFilter != 'All')
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _selectedCategoryFilter = null;
                  });
                },
                icon: Icon(Icons.clear, color: Colors.grey.shade600),
                tooltip: 'Clear filter',
              ),
            ),
        ],
      ),
    );
  }

  // ---------------- Locations Table ----------------
  Widget _buildLocationsTable(
      List<Location> filteredLocations, AsyncValue locations) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.redAccent),
                const SizedBox(width: 12),
                Text(
                  'Locations (${filteredLocations.length})',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _refreshLocations,
                  icon: Icon(Icons.refresh, color: Colors.redAccent),
                  tooltip: 'Refresh locations',
                ),
                IconButton(
                  onPressed: _toggleLocationsExpansion,
                  icon: Icon(
                    _isLocationsExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: Colors.redAccent,
                  ),
                  tooltip: _isLocationsExpanded ? 'Collapse' : 'Expand',
                ),
              ],
            ),
          ),

          // Content
          if (_isLocationsExpanded)
            locations.when(
              data: (locationData) {
                if (filteredLocations.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.location_off,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          _selectedCategoryFilter != null &&
                                  _selectedCategoryFilter != 'All'
                              ? 'No locations found for "$_selectedCategoryFilter" category'
                              : 'No locations found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Location Name',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Address',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Category',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Actions',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Table Rows
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredLocations.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Colors.grey.shade200,
                      ),
                      itemBuilder: (context, index) {
                        final location = filteredLocations[index];
                        return InkWell(
                          onTap: () => _showLocationDetails(location),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.red.shade50,
                                        child: Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          location.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    location.address,
                                    style: TextStyle(color: Colors.grey.shade600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.orange.shade200,
                                      ),
                                    ),
                                    child: Text(
                                      location.categoryName,
                                      style: TextStyle(
                                        color: Colors.orange.shade700,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.edit,
                                                size: 16, color: Colors.blue),
                                            const SizedBox(width: 8),
                                            const Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.delete,
                                                size: 16, color: Colors.red),
                                            const SizedBox(width: 8),
                                            Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _editLocation(location);
                                      } else if (value == 'delete') {
                                        _deleteLocation(location);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.error_outline,
                        size: 64, color: Colors.red.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load locations',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------- Helper methods ----------------
  void _editCategory(Categories category) {
    showDialog(
      context: context,
      builder: (context) => AddCategory(),
    );
  }

  void _deleteCategory(Categories category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCategoryDetails(Categories category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${category.name}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editLocation(Location location) {
    showDialog(
      context: context,
      builder: (context) => AddLocation(),
    );
  }

  void _deleteLocation(Location location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Location'),
        content: Text('Are you sure you want to delete "${location.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showLocationDetails(Location location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(location.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address: ${location.address}'),
            const SizedBox(height: 8),
            Text('Category: ${location.categoryName}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: buildQuickActionCard(
                  icon: Icons.add_location_alt_outlined,
                  title: 'Create Location',
                  subtitle: 'Add a new municipal location',
                  color: Colors.indigoAccent,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddLocation(),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: buildQuickActionCard(
                  icon: Icons.category_outlined,
                  title: 'Add Category',
                  subtitle: 'Create a new location category',
                  color: Colors.orange,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddCategory(),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.map, color: Colors.blue.shade700, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location Management',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Manage municipal locations and categories',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
