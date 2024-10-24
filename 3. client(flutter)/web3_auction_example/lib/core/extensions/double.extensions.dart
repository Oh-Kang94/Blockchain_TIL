extension DoubleExtensions on double {
  BigInt get toBigIntFromEth => BigInt.from(this * 1e18);
}
