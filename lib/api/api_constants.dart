class ApiConstants {
  // static const String domain = 'http://172.168.1.106:3000/';
  // static const String socketPoint = 'http://172.168.1.106:3000/';

  static const String domain = 'https://desolate-sierra-90130.herokuapp.com/';
  static const String socketPoint =
      'https://desolate-sierra-90130.herokuapp.com/';

  static const String login = 'login';
  static const String slots = 'getSlots';

  /// GameActions
  static const String buyLand = 'buyLand';
  static const String upgradeSlot = 'upgradeSlot';
  static const String buyProperty = 'buyProperty';
  static const String buyPropertyHalf = 'buyPropertyHalf';
  static const String urgentSell = 'urgentSell';
  static const String getChallengeQuestion = 'getChallengeQuestion';
  static const String submitAnswer = 'submitAnswer';

  /// Transaction
  static const String getTransaction = 'getTransactions';

  /// Admin
  static const String adminLogin = 'adminLogin';
  static const String addQuestion = 'addQuestion';
  static const String getQuestions = 'getQuestions';
  static const String updateQuestion = 'updateQuestion';
  static const String deleteQuestion = 'deleteQuestion';
}
