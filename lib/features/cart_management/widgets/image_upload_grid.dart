import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/design_tokens.dart';

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
              style: DesignTokens.getUppercaseLabelStyle(
                fontSize: DesignTokens.fontSizeMd,
                fontWeight: DesignTokens.fontWeightSemibold,
                color: DesignTokens.textPrimary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingSm,
                vertical: DesignTokens.spacingXs,
              ),
              decoration: BoxDecoration(
                color: DesignTokens.statusActive.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              ),
              child: Text(
                '${_images.length}/${widget.maxImages}',
                style: const TextStyle(
                  fontSize: DesignTokens.fontSizeSm,
                  fontWeight: DesignTokens.fontWeightSemibold,
                  color: DesignTokens.statusActive,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingMd),

        // Image grid
        if (_images.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(DesignTokens.spacingXl),
            decoration: BoxDecoration(
              color: DesignTokens.bgSecondary,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              border: Border.all(
                color: DesignTokens.borderPrimary,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.photo_camera_outlined,
                  size: DesignTokens.iconXl,
                  color: DesignTokens.textTertiary,
                ),
                const SizedBox(height: DesignTokens.spacingMd),
                Text(
                  'No images uploaded',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeMd,
                    fontWeight: DesignTokens.fontWeightMedium,
                    color: DesignTokens.textTertiary,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                Text(
                  'Add photos to document cart condition and components',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    color: DesignTokens.textTertiary,
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
              crossAxisSpacing: DesignTokens.spacingSm,
              mainAxisSpacing: DesignTokens.spacingSm,
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
          color: DesignTokens.bgSecondary,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          border: Border.all(
            color: DesignTokens.borderPrimary,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
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
                      color: DesignTokens.bgTertiary,
                      child: Icon(
                        Icons.image,
                        size: DesignTokens.iconLg,
                        color: DesignTokens.textTertiary,
                      ),
                    ),
            ),

            // Category badge
            Positioned(
              top: DesignTokens.spacingXs,
              left: DesignTokens.spacingXs,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingXs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: DesignTokens.statusActive.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Text(
                  image.category,
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSizeXs,
                    fontWeight: DesignTokens.fontWeightSemibold,
                    color: DesignTokens.bgPrimary,
                    letterSpacing: DesignTokens.letterSpacingWide,
                  ),
                ),
              ),
            ),

            // Delete button
            Positioned(
              top: DesignTokens.spacingXs,
              right: DesignTokens.spacingXs,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: DesignTokens.statusCritical.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: DesignTokens.iconSm,
                    color: DesignTokens.bgPrimary,
                  ),
                ),
              ),
            ),

            // Image number
            Positioned(
              bottom: DesignTokens.spacingXs,
              right: DesignTokens.spacingXs,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: DesignTokens.bgPrimary.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: DesignTokens.fontSizeXs,
                      fontWeight: DesignTokens.fontWeightSemibold,
                      color: DesignTokens.textPrimary,
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
          color: DesignTokens.bgSecondary,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          border: Border.all(
            color: DesignTokens.borderSecondary,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              size: DesignTokens.iconXl,
              color: DesignTokens.statusActive,
            ),
            SizedBox(height: DesignTokens.spacingSm),
            Text(
              'ADD PHOTO',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXs,
                fontWeight: DesignTokens.fontWeightSemibold,
                color: DesignTokens.statusActive,
                letterSpacing: DesignTokens.letterSpacingWide,
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
          color: DesignTokens.bgSecondary,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radiusLg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin:
                  const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
              decoration: BoxDecoration(
                color: DesignTokens.borderPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Column(
                children: [
                  Text(
                    'ADD PHOTO',
                    style: DesignTokens.getUppercaseLabelStyle(
                      fontSize: DesignTokens.fontSizeLg,
                      fontWeight: DesignTokens.fontWeightBold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
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
                      const SizedBox(width: DesignTokens.spacingMd),
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
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        decoration: BoxDecoration(
          color: DesignTokens.bgTertiary,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          border: Border.all(
            color: DesignTokens.borderPrimary,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: DesignTokens.iconXl,
              color: DesignTokens.statusActive,
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            Text(
              title,
              style: const TextStyle(
                fontSize: DesignTokens.fontSizeSm,
                fontWeight: DesignTokens.fontWeightSemibold,
                color: DesignTokens.textPrimary,
                letterSpacing: DesignTokens.letterSpacingWide,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignTokens.bgSecondary,
        title: Text(
          'SELECT CATEGORY',
          style: DesignTokens.getUppercaseLabelStyle(
            fontSize: DesignTokens.fontSizeLg,
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.allowedCategories.map((category) {
            return ListTile(
              title: Text(
                category,
                style: const TextStyle(color: DesignTokens.textPrimary),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _addImage(imageFile, category);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: DesignTokens.textSecondary,
                fontWeight: DesignTokens.fontWeightSemibold,
                letterSpacing: DesignTokens.letterSpacingWide,
              ),
            ),
          ),
        ],
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
                  borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  child: image.file != null
                      ? Image.file(
                          image.file!,
                          fit: BoxFit.contain,
                        )
                      : Container(
                          color: DesignTokens.bgSecondary,
                          child: Icon(
                            Icons.image,
                            size: DesignTokens.iconXl,
                            color: DesignTokens.textTertiary,
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
                    color: DesignTokens.bgPrimary.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: DesignTokens.textPrimary,
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
                padding: const EdgeInsets.all(DesignTokens.spacingMd),
                decoration: BoxDecoration(
                  color: DesignTokens.bgPrimary.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Image ${index + 1}',
                      style: const TextStyle(
                        fontSize: DesignTokens.fontSizeLg,
                        fontWeight: DesignTokens.fontWeightBold,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingXs),
                    Text(
                      'Category: ${image.category}',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeSm,
                        color: DesignTokens.textSecondary,
                      ),
                    ),
                    Text(
                      'Uploaded: ${_formatDateTime(image.uploadedAt)}',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeSm,
                        color: DesignTokens.textSecondary,
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
