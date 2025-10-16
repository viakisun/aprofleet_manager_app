import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';

class QRLabel extends StatelessWidget {
  final String data;
  final String? title;
  final double size;
  final bool showSaveButton;

  const QRLabel({
    super.key,
    required this.data,
    this.title,
    this.size = 200.0,
    this.showSaveButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],

          // QR Code
          QrImageView(
            data: data,
            version: QrVersions.auto,
            size: size,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),

          const SizedBox(height: 8),

          // Data text
          Text(
            data,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          if (showSaveButton) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _saveQRCode(context),
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Save Label'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _saveQRCode(BuildContext context) async {
    try {
      // Generate QR code as image
      final qrValidationResult = QrValidator.validate(
        data: data,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      );

      if (qrValidationResult.status == QrValidationStatus.valid) {
        final qrCode = qrValidationResult.qrCode!;
        final painter = QrPainter.withQr(
          qr: qrCode,
          color: Colors.black,
          emptyColor: Colors.white,
        );

        final picData = await painter.toImageData(size);
        final bytes = picData!.buffer.asUint8List();

        // Get app directory
        final directory = await getApplicationDocumentsDirectory();
        final qrDir = Directory('${directory.path}/qr_labels');
        if (!await qrDir.exists()) {
          await qrDir.create(recursive: true);
        }

        // Save file
        final fileName = 'qr_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File('${qrDir.path}/$fileName');
        await file.writeAsBytes(bytes);

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('QR label saved to: ${file.path}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save QR label: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
