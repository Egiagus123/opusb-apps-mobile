import 'dart:convert';

import 'package:apps_mobile/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HeadTrackingScreen extends StatefulWidget {
  @override
  _HeadTrackingScreenState createState() => _HeadTrackingScreenState();
}

class _HeadTrackingScreenState extends State<HeadTrackingScreen> {
  late CameraController _controller;
  bool isInitialized = false;
  String movementResult = "Arah kepala belum terdeteksi.";

  @override
  void initState() {
    super.initState();
    // final frontCamera = cameras.firstWhere(
    //   (camera) => camera.lensDirection == CameraLensDirection.front,
    //   orElse: () => cameras.first,
    // );
    // _controller = CameraController(frontCamera, ResolutionPreset.medium);
    // _controller.initialize().then((_) {
    //   if (!mounted) return;
    //   setState(() => isInitialized = true);
    // });
  }

  Future<void> _detectHeadMovement() async {
    final picture = await _controller.takePicture();
    final uri =
        Uri.parse("http://192.168.9.86:5005/head_movement"); // ← Sesuaikan
    var request = http.MultipartRequest("POST", uri);
    request.files.add(await http.MultipartFile.fromPath("img", picture.path));

    var response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final json = jsonDecode(body);
      final movement = json['movement'] ?? "unknown";

      setState(() {
        movementResult = "Arah kepala: ${_translateMovement(movement)}";
      });
    } else {
      setState(() {
        movementResult = "Gagal mendeteksi arah kepala.";
      });
    }
  }

  String _translateMovement(String movement) {
    switch (movement) {
      case "looking_left":
        return "Menoleh ke kiri";
      case "looking_right":
        return "Menoleh ke kanan";
      case "looking_up":
        return "Melihat ke atas";
      case "looking_down":
        return "Melihat ke bawah";
      case "straight":
        return "Melihat lurus";
      default:
        return "Tidak dikenali";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) return Center(child: CircularProgressIndicator());

    return Column(
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: CameraPreview(_controller),
        ),
        ElevatedButton(
          onPressed: _detectHeadMovement,
          child: Text("Deteksi Pergerakan Kepala"),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            movementResult,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
