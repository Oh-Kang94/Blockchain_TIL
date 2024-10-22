extension AddressStringExtensions on String {
  String get mask => '${substring(0, 6)}...${substring(length - 6, length)}';
}
