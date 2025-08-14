import 'dart:convert';

import 'package:apps_mobile/ui/chatAI/service/chatservice.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class ChatEntry {
  final String prompt;
  final String response;
  final PlatformFile? file;
  final String? sheetUrl;

  ChatEntry({
    required this.prompt,
    required this.response,
    this.file,
    this.sheetUrl,
  });
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();

  PlatformFile? _selectedFile;
  List<ChatEntry> _chatHistory = [];
  bool _isLoading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'csv', 'tsv'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _sendPrompt() async {
    if (_controller.text.trim().isEmpty && _selectedFile == null) return;

    setState(() => _isLoading = true);

    try {
      final prompt = _controller.text.trim();

      if (_selectedFile != null) {
        final fileBytes = _selectedFile!.bytes;
        if (fileBytes == null) throw Exception('File kosong');

        final content = utf8.decode(fileBytes);
        final lines = LineSplitter.split(content).toList();

        const chunkSize = 50;
        final chunks = <List<String>>[];

        for (var i = 0; i < lines.length; i += chunkSize) {
          final end =
              (i + chunkSize > lines.length) ? lines.length : i + chunkSize;
          chunks.add(lines.sublist(i, end));
        }

        String combinedResponse = '';
        for (int i = 0; i < chunks.length; i++) {
          final chunkLines = chunks[i];

          final partPrompt = '''
$prompt

📄 Bagian ${i + 1}/${chunks.length} (${chunkLines.length} baris):
${chunkLines.join('\n')}
''';

          print('🧪 DEBUG Prompt size (char): ${partPrompt.length}');

          const maxChars = 7000;
          final trimmedPrompt = partPrompt.length > maxChars
              ? partPrompt.substring(0, maxChars)
              : partPrompt;

          final response = await _chatService.sendPrompt(trimmedPrompt);

          combinedResponse +=
              '\n\n📄 Bagian ${i + 1}/${chunks.length}:\n$response';
        }

        setState(() {
          _chatHistory.insert(
            0,
            ChatEntry(
              prompt: prompt,
              response: combinedResponse,
              file: _selectedFile,
            ),
          );
          _controller.clear();
          _selectedFile = null;
        });
      } else {
        final response = await _chatService.sendPrompt(prompt);
        setState(() {
          _chatHistory.insert(0, ChatEntry(prompt: prompt, response: response));
          _controller.clear();
        });
      }
    } catch (e, stack) {
      debugPrint('❌ Error: $e\n$stack');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveResponseToSheets(ChatEntry entry) async {
    const snack = SnackBar(
      duration: Duration(minutes: 1),
      content: Row(children: [
        CircularProgressIndicator(),
        SizedBox(width: 16),
        Text('Menyimpan ke Google Sheets…')
      ]),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);

    final csvContent = 'Response\n"${entry.response.replaceAll('"', '""')}"';
    final title = 'Chat_Response_${DateTime.now().millisecondsSinceEpoch}';

    try {
      final url = await _chatService.uploadCsvToGoogleSheets(title, csvContent);
      setState(() {
        _chatHistory = _chatHistory
            .map((e) => e == entry
                ? ChatEntry(
                    prompt: e.prompt,
                    response: e.response,
                    file: e.file,
                    sheetUrl: url)
                : e)
            .toList();
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: const Text('✅ Tersimpan di Google Sheets'),
          action: SnackBarAction(
              label: 'Buka',
              onPressed: () => launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication)),
        ));
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('❌ Gagal menyimpan: $e')));
    }
  }

  Widget _buildChatBubble(ChatEntry chat) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('🧑‍💻 Kamu:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text(chat.prompt),
        if (chat.file != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              const Icon(Icons.attach_file, size: 16),
              const SizedBox(width: 4),
              Text(chat.file!.name,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12))
            ]),
          ),
        const SizedBox(height: 8),
        const Text('🤖 AI:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(chat.response),
        const SizedBox(height: 8),
        Row(children: [
          ElevatedButton.icon(
            onPressed: () => _saveResponseToSheets(chat),
            icon: const Icon(Icons.table_view, size: 16),
            label: const Text('Save to Sheets', style: TextStyle(fontSize: 12)),
          ),
          if (chat.sheetUrl != null)
            TextButton(
              onPressed: () => launchUrl(Uri.parse(chat.sheetUrl!),
                  mode: LaunchMode.externalApplication),
              child: const Text('Lihat Sheet'),
            ),
        ]),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat AI')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          TextField(
            controller: _controller,
            maxLines: 3,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tulis prompt kamu di sini'),
          ),
          const SizedBox(height: 8),
          Row(children: [
            ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: Text(_selectedFile?.name ?? 'Pilih File')),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _sendPrompt,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send),
              label: const Text('Kirim'),
            ),
          ]),
          const SizedBox(height: 16),
          Expanded(
            child: _chatHistory.isEmpty
                ? const Center(child: Text('Belum ada riwayat chat'))
                : ListView.builder(
                    reverse: true,
                    itemCount: _chatHistory.length,
                    itemBuilder: (_, i) => _buildChatBubble(_chatHistory[i]),
                  ),
          ),
        ]),
      ),
    );
  }
}
