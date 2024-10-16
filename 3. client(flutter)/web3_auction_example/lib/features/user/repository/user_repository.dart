abstract interface class UserRepository {
  // Abstract method for generating a mnemonic phrase
  String generateMnemonic();
  // Abstract method for getting the private key from a mnemonic phrase
  Future<String> getPrivateKey(String mnemonic);
  // Abstract method for getting the public key from a private key
  Future<String> getPublicKey(String privateKey);
}
