abstract base class DiInterface {
  void init() {
    dataSources();
    repositories();
    useCases();
  }

  void dataSources();
  void repositories();
  void useCases() {}
}
