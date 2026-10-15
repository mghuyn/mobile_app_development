class Vocabulary {
  final String word;
  final String meaning;

  Vocabulary({required this.word, required this.meaning});

  String toFileString() => '${_escape(word)}|${_escape(meaning)}';

  static Vocabulary fromString(String line) {
    final parts = _splitEscaped(line);
    if (parts.length < 2) throw const FormatException('Dữ liệu từ vựng lỗi');
    return Vocabulary(word: _unescape(parts[0]), meaning: _unescape(parts[1]));
  }

  static String _escape(String value) =>
      value.replaceAll('\\', '\\\\').replaceAll('|', '\\|').replaceAll('\n', '\\n');

  static String _unescape(String value) {
    final out = StringBuffer();
    var escaped = false;
    for (final rune in value.runes) {
      final ch = String.fromCharCode(rune);
      if (escaped) {
        out.write(ch == 'n' ? '\n' : ch);
        escaped = false;
      } else if (ch == '\\') {
        escaped = true;
      } else {
        out.write(ch);
      }
    }
    if (escaped) out.write('\\');
    return out.toString();
  }

  static List<String> _splitEscaped(String line) {
    final result = <String>[];
    final current = StringBuffer();
    var escaped = false;
    for (final rune in line.runes) {
      final ch = String.fromCharCode(rune);
      if (escaped) {
        current.write('\\$ch');
        escaped = false;
      } else if (ch == '\\') {
        escaped = true;
      } else if (ch == '|') {
        result.add(current.toString());
        current.clear();
      } else {
        current.write(ch);
      }
    }
    if (escaped) current.write('\\');
    result.add(current.toString());
    return result;
  }
}
