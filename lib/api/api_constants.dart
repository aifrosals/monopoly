class ApiConstants {
  static const String domain = 'http://192.168.0.101:3000/';
  static const String socketPoint = 'http://192.168.0.101:3000/';

  // static const String domain = 'https://desolate-sierra-90130.herokuapp.com/';
  // static const String socketPoint =
  //     'https://desolate-sierra-90130.herokuapp.com/';

  static const String registerUserWithEmail = 'registerUserWithEmail';
  static const String registerGuest = 'registerGuest';
  static const String loginWithEmail = 'loginWithEmail';
  static const String registerGuestWithEmail = 'registerGuestWithEmail';
  static const String loginWithToken = 'loginWithToken';
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
  static const String kickUser = 'kickUser';
  static const String useStep = 'useStep';
  static const String loseTreasureHunt = 'loseTreasureHunt';
  static const String getTreasureHuntReward = 'getTreasureHuntReward';

  /// Transaction
  static const String getTransaction = 'getTransactions';
  static const String getPaginatedTransactions = 'getPaginatedTransactions';

  /// Admin
  static const String adminLogin = 'adminLogin';

  /// Admin Question
  static const String addQuestion = 'addQuestion';
  static const String getQuestions = 'getQuestions';
  static const String updateQuestion = 'updateQuestion';
  static const String deleteQuestion = 'deleteQuestion';

  /// Admin User
  static const String getAllUsers = 'getAllUsers';
  static const String activatePremium = 'activatePremium';
  static const String deactivatePremium = 'deactivatePremium';
  static const String addDice = 'addDice';

  /// Stats
  static const String getUserCountStats = 'getUserCountStats';
  static const String getMonthlyActivity = 'getMonthlyActivity';
  static const String get3DayActivity = 'get3DayActivity';
  static const String getWeeklyActivity = 'getWeeklyActivity';

  /// Feedback
  static const String submitFeedback = 'submitFeedback';
  static const String getFeedback = 'getFeedback';
  static const String getPaginatedFeedback = 'getPaginatedFeedback';
}
