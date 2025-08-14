import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ScanFaceScreen extends StatefulWidget {
  final String registeredName;
  final String registeredImagePath;

  const ScanFaceScreen({
    required this.registeredName,
    required this.registeredImagePath,
    Key? key,
  }) : super(key: key);

  @override
  State<ScanFaceScreen> createState() => _ScanFaceScreenState();
}

class _ScanFaceScreenState extends State<ScanFaceScreen> {
  final String deepfaceUrl = "https://face-recognation.opusb.co.id/verify";

  File? selectedImage;
  String? img1Base64;
  late String img2Base64;

  String resultText = "";
  bool? isVerified;
  String distance = "";
  bool _showHeadPoseButton = false;
  bool _isImageCapturedAndEncoded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _convertRegisteredImageToBase64();
  }

  Future<void> _convertRegisteredImageToBase64() async {
    final registeredFile = File(widget.registeredImagePath);

    if (await registeredFile.exists()) {
      final compressedFile = await FlutterImageCompress.compressWithFile(
        registeredFile.path,
        quality: 30, // 🔽 kompresi ekstrim (20% kualitas)
        minWidth: 360, // 🔽 lebar dikurangi agar ukuran file kecil
        minHeight: 480, // 🔽 tinggi dikurangi
        format: CompressFormat.jpeg, // ✅ JPEG = kompresi lebih efisien
        autoCorrectionAngle: true, // ✅ rotasi otomatis
      );

      if (compressedFile != null) {
        img2Base64 = "data:image/jpeg;base64,${base64Encode(compressedFile)}";
      } else {
        img2Base64 = "";
      }
    } else {
      img2Base64 = "";
    }
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() => _isLoading = true);

      final compressedBytes = await FlutterImageCompress.compressWithFile(
        pickedFile.path,
        quality: 30, // 🔽 kompresi ekstrim (20% kualitas)
        minWidth: 360, // 🔽 lebar dikurangi agar ukuran file kecil
        minHeight: 480, // 🔽 tinggi dikurangi
        format: CompressFormat.jpeg, // ✅ JPEG = kompresi lebih efisien
        autoCorrectionAngle: true, // ✅ rotasi otomatis
      );

      if (compressedBytes != null) {
        final compressedFile = File(pickedFile.path)
          ..writeAsBytesSync(compressedBytes);

        setState(() {
          selectedImage = compressedFile;
          img1Base64 =
              "data:image/jpeg;base64,${base64Encode(compressedBytes)}";
          resultText = "";
          isVerified = null;
          distance = "";
          _showHeadPoseButton = false;
          _isImageCapturedAndEncoded = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          resultText = "❌ Gagal mengompres gambar";
        });
      }
    }
  }

  Future<void> _compareFace() async {
    if (img1Base64 == null || img1Base64!.isEmpty || img2Base64.isEmpty) {
      setState(() {
        resultText =
            "❌ Gambar belum dipilih atau gambar terdaftar tidak ditemukan.";
        isVerified = false;
        _showHeadPoseButton = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(deepfaceUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "img1": img1Base64,
          "img2": img2Base64,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        isVerified = data['verified'] == true;
        distance = (data['distance'] is num)
            ? double.parse(data['distance'].toString()).toStringAsFixed(4)
            : "-";

        setState(() {
          if (isVerified == true) {
            resultText = "✅ (${widget.registeredName}) Wajah cocok ";
            _showHeadPoseButton = true;
          } else {
            resultText = "❌ Wajah tidak cocok";
            _showHeadPoseButton = false;
          }
        });
      } else {
        setState(() {
          resultText =
              "⚠️ Gagal verifikasi wajah.\nStatus: ${response.statusCode}";
          isVerified = false;
          _showHeadPoseButton = false;
        });
      }
    } catch (e) {
      setState(() {
        resultText = "❌ Error:\n${e.toString()}";
        isVerified = false;
        _showHeadPoseButton = false;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildResultCard() {
    if (resultText.isEmpty) return const SizedBox();

    return Card(
      color: isVerified == null
          ? Colors.grey.shade200
          : isVerified == true
              ? Colors.green.shade100
              : Colors.red.shade100,
      margin: const EdgeInsets.symmetric(vertical: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              resultText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isVerified == true ? Colors.green[800] : Colors.red[800],
              ),
            ),
            if (distance.isNotEmpty)
              Text(
                "Jarak (distance): $distance",
                style: const TextStyle(fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageFrame(File imageFile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        imageFile,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCompareButton() {
    // if (!_isImageCapturedAndEncoded) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: ElevatedButton.icon(
        onPressed: _compareFace,
        icon: const Icon(Icons.check_circle),
        label: const Text("Bandingkan Wajah"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: isVerified == null
              ? Colors.grey.shade200
              : isVerified == true
                  ? Colors.white
                  : Colors.red.shade100,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verifikasi: ${widget.registeredName}"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _pickFromCamera,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Ambil Gambar Wajah"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading) _buildLoadingIndicator(),
              if (selectedImage != null && !_isLoading)
                _buildImageFrame(selectedImage!),
              if (!_isLoading) _buildCompareButton(),
              if (!_isLoading) _buildResultCard(),
              // if (!_isLoading) _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }
}
