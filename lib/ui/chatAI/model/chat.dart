class Chat {
  final String prompt;
  final String response;
  final DateTime createdAt;
  final bool hasAttachment;
  final String? fileName; // Add this new nullable field

  Chat({
    required this.prompt,
    required this.response,
    required this.createdAt,
    this.hasAttachment = false,
    this.fileName, // Make it optional
  });
}
