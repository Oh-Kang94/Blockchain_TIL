abstract base class IFeatureDI {
  void init() {
    dataSources();
    repositories();
    useCases();
  }

  void dataSources();
  void repositories();
  void useCases() {}
}
