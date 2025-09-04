import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_nagarpalika_dashboard/services/category_service.dart';
import 'package:smart_nagarpalika_dashboard/widgets/image_drop_zone.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  Uint8List? imageBytes;
  String? imageName;
  final titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload an image")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      File? file;
      
      if (kIsWeb) {
        // For web - pass bytes directly
        await CategoryService.createCategory(
          name: titleController.text,
          imageBytes: imageBytes,
          imageName: imageName,
        );
      } else {
        // For mobile/desktop - create temp file
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/$imageName';
        file = File(filePath);
        await file.writeAsBytes(imageBytes!);
        
        await CategoryService.createCategory(
          name: titleController.text,
          imageFile: file,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Category created successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); // close dialog/page after success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 16,
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
                      'Add Category',
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

              // ImageDropZone remains unchanged
              ImageDropZone(
                onFile: (bytes, filename) {
                  setState(() {
                    imageBytes = bytes;
                    imageName = filename;
                  });
                },
                height: 160,
                hint: const Text('Upload Category Image'),
              ),

              if (imageName != null) ...[
                const SizedBox(height: 8),
                Text(
                  "Selected: $imageName",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Category Name is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 300,
                  height: 48,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        const Color(0xFF397DE1),
                      ),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 16),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text("Save Category"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}