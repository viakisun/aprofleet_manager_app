import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import '../../../core/widgets/via/via_bottom_sheet.dart';
import '../../../core/widgets/via/via_button.dart';

class ImageUploadGrid extends StatefulWidget {
  final List<UploadedImage> images;
  final Function(List<UploadedImage>) onImagesChanged;
  final int maxImages;
  final List<String> allowedCategories;

  const ImageUploadGrid({
    super.key,
    required this.images,
    required this.onImagesChanged,
    this.maxImages = 10,
    this.allowedCategories = const [
      'General',
      'Damage',
      'Components',
      'Documents'
    ],
  });

  @override
  State<ImageUploadGrid> createState() => _ImageUploadGridState();
}

class _ImageUploadGridState extends State<ImageUploadGrid> {
  late List<UploadedImage> _images;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.images);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'DOCUMENTATION',
              style: IndustrialDarkTokens.getUppercaseLabelStyle(
                fontSize: IndustrialDarkTokens.fontSizeLabel,
                fontWeight: IndustrialDarkTokens.fontWeightBold,
                color: IndustrialDarkTokens.textPrimary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: IndustrialDarkTokens.spacingCompact,
                vertical: IndustrialDarkTokens.spacingMinimal,
              ),
              decoration: BoxDecoration(
                color: IndustrialDarkTokens.statusActive.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
              ),
              child: Text(
                '${_images.length}/${widget.maxImages}',
                style: const TextStyle(
                  fontSize: IndustrialDarkTokens.fontSizeSmall,
                  fontWeight: IndustrialDarkTokens.fontWeightBold,
                  color: IndustrialDarkTokens.statusActive,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: IndustrialDarkTokens.spacingItem),

        // Image grid
        if (_images.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(IndustrialDarkTokens.spacingSection),
            decoration: BoxDecoration(
              color: IndustrialDarkTokens.bgSurface,
              borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
              border: Border.all(
                color: IndustrialDarkTokens.outline,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.photo_camera_outlined,
                  size: 32,
                  color: IndustrialDarkTokens.textSecondary,
                ),
                const SizedBox(height: IndustrialDarkTokens.spacingItem),
                Text(
                  'No images uploaded',
                  style: TextStyle(
                    fontSize: IndustrialDarkTokens.fontSizeLabel,
                    fontWeight: IndustrialDarkTokens.fontWeightMedium,
                    color: IndustrialDarkTokens.textSecondary,
                  ),
                ),
                const SizedBox(height: IndustrialDarkTokens.spacingCompact),
                Text(
                  'Add photos to document cart condition and components',
                  style: TextStyle(
                    fontSize: IndustrialDarkTokens.fontSizeSmall,
                    color: IndustrialDarkTokens.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: IndustrialDarkTokens.spacingCompact,
              mainAxisSpacing: IndustrialDarkTokens.spacingCompact,
            ),
            itemCount:
                _images.length + (_images.length < widget.maxImages ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _images.length) {
                return _buildImageItem(_images[index], index);
              } else {
                return _buildAddButton();
              }
            },
          ),
      ],
    );
  }

  Widget _buildImageItem(UploadedImage image, int index) {
    return GestureDetector(
      onTap: () => _showImageDetail(image, index),
      child: Container(
        decoration: BoxDecoration(
          color: IndustrialDarkTokens.bgSurface,
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          border: Border.all(
            color: IndustrialDarkTokens.outline,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
              child: image.file != null
                  ? Image.file(
                      image.file!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: IndustrialDarkTokens.bgSurface,
                      child: Icon(
                        Icons.image,
                        size: 24,
                        color: IndustrialDarkTokens.textSecondary,
                      ),
                    ),
            ),

            // Category badge
            Positioned(
              top: IndustrialDarkTokens.spacingMinimal,
              left: IndustrialDarkTokens.spacingMinimal,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: IndustrialDarkTokens.spacingMinimal,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: IndustrialDarkTokens.statusActive.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
                ),
                child: Text(
                  image.category,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: IndustrialDarkTokens.fontWeightBold,
                    color: IndustrialDarkTokens.bgBase,
                    letterSpacing: IndustrialDarkTokens.letterSpacing,
                  ),
                ),
              ),
            ),

            // Delete button
            Positioned(
              top: IndustrialDarkTokens.spacingMinimal,
              right: IndustrialDarkTokens.spacingMinimal,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: IndustrialDarkTokens.error.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: IndustrialDarkTokens.bgBase,
                  ),
                ),
              ),
            ),

            // Image number
            Positioned(
              bottom: IndustrialDarkTokens.spacingMinimal,
              right: IndustrialDarkTokens.spacingMinimal,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: IndustrialDarkTokens.bgBase.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: IndustrialDarkTokens.fontWeightBold,
                      color: IndustrialDarkTokens.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Container(
        decoration: BoxDecoration(
          color: IndustrialDarkTokens.bgSurface,
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          border: Border.all(
            color: IndustrialDarkTokens.outlineSoft,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              size: 32,
              color: IndustrialDarkTokens.statusActive,
            ),
            SizedBox(height: IndustrialDarkTokens.spacingCompact),
            Text(
              'ADD PHOTO',
              style: TextStyle(
                fontSize: 10,
                fontWeight: IndustrialDarkTokens.fontWeightBold,
                color: IndustrialDarkTokens.statusActive,
                letterSpacing: IndustrialDarkTokens.letterSpacing,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: IndustrialDarkTokens.bgSurface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(IndustrialDarkTokens.radiusButton),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin:
                  const EdgeInsets.symmetric(vertical: IndustrialDarkTokens.spacingItem),
              decoration: BoxDecoration(
                color: IndustrialDarkTokens.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
              child: Column(
                children: [
                  Text(
                    'ADD PHOTO',
                    style: IndustrialDarkTokens.getUppercaseLabelStyle(
                      fontSize: IndustrialDarkTokens.fontSizeBody,
                      fontWeight: IndustrialDarkTokens.fontWeightBold,
                      color: IndustrialDarkTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: IndustrialDarkTokens.spacingItem),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSourceOption(
                          icon: Icons.camera_alt,
                          title: 'CAMERA',
                          onTap: () {
                            Navigator.of(context).pop();
                            _pickImage(ImageSource.camera);
                          },
                        ),
                      ),
                      const SizedBox(width: IndustrialDarkTokens.spacingItem),
                      Expanded(
                        child: _buildSourceOption(
                          icon: Icons.photo_library,
                          title: 'GALLERY',
                          onTap: () {
                            Navigator.of(context).pop();
                            _pickImage(ImageSource.gallery);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
        decoration: BoxDecoration(
          color: IndustrialDarkTokens.bgSurface,
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          border: Border.all(
            color: IndustrialDarkTokens.outline,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: IndustrialDarkTokens.statusActive,
            ),
            const SizedBox(height: IndustrialDarkTokens.spacingCompact),
            Text(
              title,
              style: const TextStyle(
                fontSize: IndustrialDarkTokens.fontSizeSmall,
                fontWeight: IndustrialDarkTokens.fontWeightBold,
                color: IndustrialDarkTokens.textPrimary,
                letterSpacing: IndustrialDarkTokens.letterSpacing,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      _showCategoryDialog(File(image.path));
    }
  }

  void _showCategoryDialog(File imageFile) {
    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.4, 0.6],
      header: Text(
        'SELECT CATEGORY',
        style: IndustrialDarkTokens.getUppercaseLabelStyle(
          fontSize: IndustrialDarkTokens.fontSizeBody,
          fontWeight: IndustrialDarkTokens.fontWeightBold,
          color: IndustrialDarkTokens.textPrimary,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.allowedCategories.map((category) {
          return ListTile(
            title: Text(
              category,
              style: TextStyle(color: IndustrialDarkTokens.textPrimary),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: IndustrialDarkTokens.textSecondary,
              size: 16,
            ),
            onTap: () {
              Navigator.of(context).pop();
              _addImage(imageFile, category);
            },
          );
        }).toList(),
      ),
      footer: ViaButton.ghost(
        text: 'CANCEL',
        onPressed: () => Navigator.of(context).pop(),
        isFullWidth: true,
      ),
    );
  }

  void _addImage(File imageFile, String category) {
    setState(() {
      _images.add(UploadedImage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        file: imageFile,
        category: category,
        uploadedAt: DateTime.now(),
      ));
    });
    widget.onImagesChanged(_images);
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesChanged(_images);
  }

  void _showImageDetail(UploadedImage image, int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            // Image
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
                  child: image.file != null
                      ? Image.file(
                          image.file!,
                          fit: BoxFit.contain,
                        )
                      : Container(
                          color: IndustrialDarkTokens.bgSurface,
                          child: Icon(
                            Icons.image,
                            size: 32,
                            color: IndustrialDarkTokens.textSecondary,
                          ),
                        ),
                ),
              ),
            ),

            // Close button
            Positioned(
              top: 50,
              right: 50,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: IndustrialDarkTokens.bgBase.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: IndustrialDarkTokens.textPrimary,
                  ),
                ),
              ),
            ),

            // Image info
            Positioned(
              bottom: 50,
              left: 50,
              right: 50,
              child: Container(
                padding: const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
                decoration: BoxDecoration(
                  color: IndustrialDarkTokens.bgBase.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Image ${index + 1}',
                      style: const TextStyle(
                        fontSize: IndustrialDarkTokens.fontSizeBody,
                        fontWeight: IndustrialDarkTokens.fontWeightBold,
                        color: IndustrialDarkTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: IndustrialDarkTokens.spacingMinimal),
                    Text(
                      'Category: ${image.category}',
                      style: TextStyle(
                        fontSize: IndustrialDarkTokens.fontSizeSmall,
                        color: IndustrialDarkTokens.textSecondary,
                      ),
                    ),
                    Text(
                      'Uploaded: ${_formatDateTime(image.uploadedAt)}',
                      style: TextStyle(
                        fontSize: IndustrialDarkTokens.fontSizeSmall,
                        color: IndustrialDarkTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class UploadedImage {
  final String id;
  final File? file;
  final String category;
  final DateTime uploadedAt;

  const UploadedImage({
    required this.id,
    this.file,
    required this.category,
    required this.uploadedAt,
  });
}
