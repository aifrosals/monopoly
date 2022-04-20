import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/models/admin.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/models/time_series_login.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatsProvider extends ChangeNotifier {
  StatsProvider(Admin admin) {
    getUserCountStats(admin);
    getMonthlyActivity(admin);
    get3DayActivity(admin);
    getWeeklyActivity(admin);
  }

  int _totalUsers = 0;
  int _guests = 0;
  int _dailyActiveUsers = 0;
  int _registeredUsers = 0;
  int _3dayInactiveUers = 0;
  int _weeklyInactiveUsers = 0;

  List<TimeSeriesLogin> _monthlyActivitySeries = [];
  List<charts.Series<TimeSeriesLogin, DateTime>> _loginSeries = [];

  bool _userCountStatsLoading = false;
  bool _monthlyActivityLoading = false;

  Future<void> getUserCountStats(Admin admin) async {
    try {
      _userCountStatsLoading = true;
      await Future.delayed(const Duration(milliseconds: 1));
      notifyListeners();

      Uri uri =
          Uri.parse('${ApiConstants.domain}${ApiConstants.getUserCountStats}');
      var response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': admin.token
        },
      );
      debugPrint(
          'getUserCountStats response ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _totalUsers = data['totalUsers'];
        _registeredUsers = data['registeredUsers'];
        _guests = data['guests'];
        _dailyActiveUsers = data['dailyActiveUsers'];
      } else {}
    } catch (error, st) {
      debugPrint('StatsProvider getUsersCountStats error $error $st');
    } finally {
      _userCountStatsLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMonthlyActivity(Admin admin) async {
    try {
      _monthlyActivityLoading = true;
      await Future.delayed(const Duration(milliseconds: 1));
      notifyListeners();
      Uri uri =
          Uri.parse('${ApiConstants.domain}${ApiConstants.getMonthlyActivity}');
      var response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': admin.token
        },
      );
      debugPrint(
          'getMonthlyActivity response ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        _monthlyActivitySeries =
            data.map((e) => TimeSeriesLogin.fromJson(e)).toList();
        generateLoginHistoryChartData();
      } else {}
    } catch (error, st) {
      debugPrint('StatsProvider getMonthlyActivity error $error $st');
    } finally {
      _monthlyActivityLoading = false;
      notifyListeners();
    }
  }

  Future<void> get3DayActivity(Admin admin) async {
    try {
      _userCountStatsLoading = true;
      await Future.delayed(const Duration(milliseconds: 1));
      notifyListeners();

      Uri uri =
          Uri.parse('${ApiConstants.domain}${ApiConstants.get3DayActivity}');
      var response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': admin.token
        },
      );
      debugPrint(
          'get3DayActivity response ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        int activeUsers = data['loginRecords'];
        _totalUsers = data['totalUsers'];
        _3dayInactiveUers = _totalUsers - activeUsers;
      } else {}
    } catch (error, st) {
      debugPrint('StatsProvider get3DayActivity error $error $st');
    } finally {
      _userCountStatsLoading = false;
      notifyListeners();
    }
  }

  Future<void> getWeeklyActivity(Admin admin) async {
    try {
      _userCountStatsLoading = true;
      await Future.delayed(const Duration(milliseconds: 1));
      notifyListeners();

      Uri uri =
          Uri.parse('${ApiConstants.domain}${ApiConstants.getWeeklyActivity}');
      var response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': admin.token
        },
      );
      debugPrint(
          'getWeeklyActivity response ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        int activeUsers = data['loginRecords'];
        _totalUsers = data['totalUsers'];
        _weeklyInactiveUsers = _totalUsers - activeUsers;
      } else {}
    } catch (error, st) {
      debugPrint('StatsProvider getWeeklyActivity error $error $st');
    } finally {
      _userCountStatsLoading = false;
      notifyListeners();
    }
  }

  int get3DaysInactivePercentage() {
    return _totalUsers != 0
        ? (_3dayInactiveUers / _totalUsers * 100).toInt()
        : 0;
  }

  int getWeeklyInactivePercentage() {
    return _totalUsers != 0
        ? (_weeklyInactiveUsers / _totalUsers * 100).toInt()
        : 0;
  }

  generateLoginHistoryChartData() {
    try {
      _monthlyActivitySeries.sort((a, b) => a.date!.compareTo(b.date!));
      _loginSeries = [
        charts.Series<TimeSeriesLogin, DateTime>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesLogin sales, _) => sales.date!,
          measureFn: (TimeSeriesLogin sales, _) => sales.users!,
          data: _monthlyActivitySeries,
        )
      ];
    } catch (error, st) {
      debugPrint('generateLoginHistoryChartDate error $error $st');
      rethrow;
    }
  }

  int get totalUsers => _totalUsers;

  int get registeredUsers => _registeredUsers;

  int get guests => _guests;

  int get dailyActiveUsers => _dailyActiveUsers;

  int get threeDaysInactiveUsers => _3dayInactiveUers;

  int get weeklyInactiveUsers => _weeklyInactiveUsers;

  List<TimeSeriesLogin> get monthlyActivitySeries => _monthlyActivitySeries;

  List<charts.Series<TimeSeriesLogin, DateTime>> get loginSeries =>
      _loginSeries;

  bool get monthlyActivityLoading => _monthlyActivityLoading;
}
