extension StringExtension on String {
  String capitalize() {
    return length > 0 ? "${this[0].toUpperCase()}${this.substring(1)}" : "";
  }
}
