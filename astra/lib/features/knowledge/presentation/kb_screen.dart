import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:astra/widgets/astra_page.dart';
import '../data/kb_api_service.dart';

class KBScreen extends StatefulWidget {
  const KBScreen({super.key});

  @override
  State<KBScreen> createState() => _KBScreenState();
}

class _ConversationItem {
  final String question;
  final String answer;
  final List<dynamic> citations;
  final String? confidence;

  _ConversationItem({
    required this.question,
    required this.answer,
    required this.citations,
    this.confidence,
  });
}

class _KBScreenState extends State<KBScreen> {
  final KBApiService _apiService = KBApiService();
  final TextEditingController _queryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  File? _selectedFile;
  String? _uploadedFileName;
  bool _isUploading = false;
  bool _isQuerying = false;

  String? _uploadStatusMessage;
  String? _uploadStatusMessageType;

  final List<_ConversationItem> _history = [];
  String? _queryError;

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _uploadStatusMessage = null;
      });
    }
  }

  Future<void> _uploadPDF() async {
    if (_selectedFile == null) return;

    setState(() {
      _isUploading = true;
      _uploadStatusMessage = null;
    });

    try {
      final response = await _apiService.uploadPdf(_selectedFile!);

      setState(() {
        _isUploading = false;
        if (response['status'] == 'success') {
          _uploadedFileName =
              _selectedFile!.path.split(Platform.pathSeparator).last;
          _uploadStatusMessage = 'Success! Ready to chat.';
          _uploadStatusMessageType = 'success';
          _history.clear();
        } else {
          _uploadStatusMessage = 'Upload failed.';
          _uploadStatusMessageType = 'error';
        }
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
        _uploadStatusMessage = 'Error uploading file.';
        _uploadStatusMessageType = 'error';
      });
    }
  }

  Future<void> _submitQuery() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isQuerying = true;
      _queryError = null;
    });

    try {
      final result = await _apiService.queryKb(query);

      setState(() {
        _isQuerying = false;
        _history.add(
          _ConversationItem(
            question: query,
            answer: result['answer'] ?? "No answer returned.",
            citations: result['citations'] ?? [],
            confidence: result['confidence'],
          ),
        );
        _queryController.clear();
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      setState(() {
        _isQuerying = false;
        _queryError = 'Query failed.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final canQuery = _uploadedFileName != null;

    return AstraPage(
      title: "Knowledge Base",
      child: Column(
        children: [
          // ─── Upload Section ───
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _selectedFile != null
                      ? 'Selected: ${_selectedFile!.path.split(Platform.pathSeparator).last}'
                      : 'Select a PDF document to begin',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: _pickPDF,
                      child: const Text("Pick PDF"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed:
                          (_selectedFile != null && !_isUploading)
                              ? _uploadPDF
                              : null,
                      icon: _isUploading
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            )
                          : const Icon(Icons.cloud_upload),
                      label: Text(
                          _isUploading ? "Uploading..." : "Upload Document"),
                    ),
                  ],
                ),
                if (_uploadStatusMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _uploadStatusMessage!,
                      style: TextStyle(
                        color: _uploadStatusMessageType == 'success'
                            ? Colors.greenAccent
                            : Colors.redAccent,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 14),
          const Divider(color: Colors.white24),

          // ─── Chat Area ───
          Expanded(
            child: _history.isEmpty
                ? Center(
                    child: Text(
                      canQuery
                          ? "Ask a question about your PDF."
                          : "Upload a PDF to start.",
                      style: const TextStyle(color: Colors.white54),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _history.length,
                    itemBuilder: (_, i) =>
                        _buildConversationCard(_history[i]),
                  ),
          ),

          // ─── Input ───
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              border: Border(
                top: BorderSide(color: Colors.white24),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _queryController,
                    enabled: canQuery && !_isQuerying,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: canQuery
                          ? "Ask a question..."
                          : "Waiting for upload...",
                      hintStyle:
                          const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor:
                          Colors.black.withOpacity(0.35),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            const BorderSide(color: Colors.white24),
                      ),
                    ),
                    onSubmitted: (_) => _submitQuery(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed:
                      (canQuery && !_isQuerying) ? _submitQuery : null,
                  backgroundColor:
                      canQuery ? Colors.blueAccent : Colors.grey,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCard(_ConversationItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade800,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                item.question,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              item.answer,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
