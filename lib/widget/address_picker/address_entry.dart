class AddressEntry {
  final String name;
  final String code;
  final List<AddressEntry>? children;

  AddressEntry({required this.name, required this.code, this.children});
}
