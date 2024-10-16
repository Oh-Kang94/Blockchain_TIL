abstract base class FeatureDiInterface {
  void init() {
    dataSources();
    repositories();
    useCases();
  }

  void dataSources();
  void repositories();
  void useCases() {}
}
