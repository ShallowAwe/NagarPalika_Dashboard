import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nagarpalika_dashboard/providers/location_provider.dart';

class AddLocation extends ConsumerStatefulWidget {
  const AddLocation({super.key});

  @override
  ConsumerState<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends ConsumerState<AddLocation> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _categoryIdController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _categoryIdController.dispose();
    super.dispose();
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? type,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      inputFormatters: formatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator ??
          (v) => v == null || v.trim().isEmpty ? 'Enter $label' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 12,
        color: const Color(0xFFF8FAFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Add Location',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF397DE1),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _field(
                      controller: _nameController,
                      label: "Location Name",
                      icon: Icons.location_city,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _addressController,
                      label: "Address",
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _latitudeController,
                      label: "Latitude",
                      icon: Icons.my_location,
                      type: const TextInputType.numberWithOptions(decimal: true),
                      formatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                      ],
                      validator: (v) => double.tryParse(v ?? '') == null
                          ? 'Enter valid latitude'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _longitudeController,
                      label: "Longitude",
                      icon: Icons.place,
                      type: const TextInputType.numberWithOptions(decimal: true),
                      formatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                      ],
                      validator: (v) => double.tryParse(v ?? '') == null
                          ? 'Enter valid longitude'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _categoryIdController,
                      label: "Category ID",
                      icon: Icons.category,
                      type: TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) => int.tryParse(v ?? '') == null
                          ? 'Enter valid category id'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF397DE1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _handleSubmit,
                        label: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(locationProvider.notifier).create(
            name: _nameController.text.trim(),
            address: _addressController.text.trim(),
            latitude: double.parse(_latitudeController.text.trim()),
            longitude: double.parse(_longitudeController.text.trim()),
            categoryId: int.parse(_categoryIdController.text.trim()),
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location created')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    }
  }
}
