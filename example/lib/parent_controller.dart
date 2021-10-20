abstract class ParentController {
  DateTime lastUpdated = DateTime.now();
  List<String> textLog = [];
  String id = '';

  //final SecureStorage secureStorage = SecureStorage();

  ParentController() {
    logAction('Class initialisation');
  }

  void assignId(String deviceId);

  // void checkFirstTime() async {
  //   logAction('Checking first time setup');
  //
  //   await secureStorage.containsKey('$id.active').then((bool exists) {
  //     if (exists) {
  //       // create secure storage value
  //     } else {
  //       // assign active variable value
  //     }
  //   });
  //
  //   doFirstTimeSetup();
  // }

  void doFirstTimeSetup();

  void updateData(DateTime startDate, DateTime endDate);

  void logAction(String log) {
    // print(log);
    textLog.add(log);
  }
}
