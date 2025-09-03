import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart' as desktop;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class ImageDropZone extends StatefulWidget {
  final void Function(Uint8List bytes, String filename) onFile;
  final double height;
  final Widget? hint;

  const ImageDropZone({
    super.key,
    required this.onFile,
    this.height = 160,
    this.hint,
  });

  @override
  State<ImageDropZone> createState() => _ImageDropZoneState();
}

class _ImageDropZoneState extends State<ImageDropZone> {
  bool isHovering = false;
  Uint8List? _imageBytes;
  String? _filename;

  Future<void> _openPicker() async {
    final res = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
      type: FileType.custom,
      allowedExtensions: const ['png', 'jpg', 'jpeg', 'gif', 'webp'],
    );
    if (res == null || res.files.isEmpty) return;
    final f = res.files.first;
    final data = f.bytes;
    if (data == null) return;

    setState(() {
      _imageBytes = data;
      _filename = f.name;
    });

    widget.onFile(data, f.name);
  }

  BoxDecoration _decoration(Color borderColor, bool hovering) {
    return BoxDecoration(
      border: Border.all(color: borderColor, width: 2),
      borderRadius: BorderRadius.circular(12),
      color: hovering ? borderColor.withOpacity(0.06) : Colors.transparent,
    );
  }

  Widget _content() {
    if (_imageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          _imageBytes!,
          fit: BoxFit.cover,
          height: widget.height - 16,
          width: double.infinity,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.cloud_upload_outlined, size: 32),
        const SizedBox(height: 8),
        widget.hint ?? const Text('Drag & drop image here or click to upload')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isHovering ? Theme.of(context).colorScheme.primary : Colors.grey.shade400;

    final base = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: _decoration(borderColor, isHovering),
      height: widget.height,
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: _content(),
    );

    if (kIsWeb) {
      return GestureDetector(
        onTap: _openPicker,
        child: DragTarget<Uint8List>(
          onWillAccept: (data) => true,
          onAccept: (_) {},
          builder: (context, candidateData, rejectedData) {
            return base;
          },
        ),
      );
    }

    return desktop.DropTarget(
      onDragEntered: (_) => setState(() => isHovering = true),
      onDragExited: (_) => setState(() => isHovering = false),
      onDragDone: (detail) async {
        setState(() => isHovering = false);
        if (detail.files.isEmpty) return;

        final x = detail.files.first; // only 1 file allowed
        final mime = x.mimeType ?? '';
        if (!mime.startsWith('image/')) return;

        final bytes = await x.readAsBytes();
        final name = x.name;

        setState(() {
          _imageBytes = bytes;
          _filename = name;
        });

        widget.onFile(bytes, name);
      },
      child: GestureDetector(
        onTap: _openPicker,
        child: base,
      ),
    );
  }
}
