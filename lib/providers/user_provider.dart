import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  List<dynamic> _users = [];
  List<dynamic> _filteredUsers = [];
  int _page = 1;
  String _searchQuery = '';
  String _followersFilter = '';
  String _gradeFilter = '';
  String _sortColumn = 'id';
  bool _isAscending = true;
  Set<int> _selectedUserIds = {};

  List<dynamic> get users => _filteredUsers;
  int get page => _page;
  String get followersFilter => _followersFilter;
  String get gradeFilter => _gradeFilter;
  Set<int> get selectedUserIds => _selectedUserIds;
  bool get isAscending => _isAscending;
  String get sortColumn => _sortColumn;

  void fetchUsers() async {
    final apiService = ApiService();
    try {
      final data = await apiService.fetchUsers(_page);
      print('Fetched users data: $data');
      _users = data
          .map((user) => {
                'id': user['id'],
                'avatarUrl': user['avatar'] ?? 'https://via.placeholder.com/40',
                'name': user['first_name'] + ' ' + user['last_name'],
                'grade': user['grade'] ?? '-',
                'followers': user['followers'] ?? 0,
                'engagement_rate': user['engagement_rate'] ?? 0,
                'tags': user['tags'] ?? 'No Tags',
                'hashtags': user['hashtags'] ?? '',
                'email': user['email'] ?? '-',
              })
          .toList();
      _sortColumn = 'id';
      _isAscending = true;
      applyFilters();
    } catch (e) {
      print('Error fetching users: $e');
    }
    notifyListeners();
  }

  void applyFilters() {
    _filteredUsers = _users.where((user) {
      bool matchesSearchQuery =
          user['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesFollowersFilter = _matchesFollowersFilter(user['followers']);
      bool matchesGradeFilter = _matchesGradeFilter(user['grade']);
      return matchesSearchQuery && matchesFollowersFilter && matchesGradeFilter;
    }).toList();
    sortUsers();
  }

  bool _matchesFollowersFilter(int followers) {
    if (_followersFilter == '0-50') {
      return followers >= 0 && followers <= 50;
    } else if (_followersFilter == '50-100') {
      return followers > 50 && followers <= 100;
    }
    return true;
  }

  bool _matchesGradeFilter(String grade) {
    if (_gradeFilter.isEmpty) {
      return true;
    }
    return grade == _gradeFilter;
  }

  void sortUsers() {
    _filteredUsers.sort((a, b) {
      int cmp;

      if (_sortColumn == 'name') {
        cmp = a['name'].compareTo(b['name']);
      } else if (_sortColumn == 'grade') {
        cmp = a['grade'].compareTo(b['grade']);
      } else if (_sortColumn == 'followers') {
        cmp = a['followers'].compareTo(b['followers']);
      } else if (_sortColumn == 'engagement_rate') {
        cmp = a['engagement_rate'].compareTo(b['engagement_rate']);
      } else if (_sortColumn == 'tags') {
        cmp = a['tags'].compareTo(b['tags']);
      } else if (_sortColumn == 'hashtags') {
        cmp = a['hashtags'].compareTo(b['hashtags']);
      } else if (_sortColumn == 'email') {
        cmp = a['email'].compareTo(b['email']);
      } else {
        cmp = a['id'].compareTo(b['id']);
      }

      return _isAscending ? cmp : -cmp;
    });

    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    applyFilters();
    notifyListeners();
  }

  void updateFollowersFilter(String filter) {
    _followersFilter = filter;
    applyFilters();
    notifyListeners();
  }

  void updateGradeFilter(String filter) {
    _gradeFilter = filter;
    applyFilters();
    notifyListeners();
  }

  void clearAllFilters() {
    _searchQuery = '';
    _followersFilter = '';
    _gradeFilter = '';
    fetchUsers();
  }

  void updateSortColumn(String column) {
    if (_sortColumn == column) {
      _isAscending = !_isAscending;
    } else {
      _sortColumn = column;
      _isAscending = true;
    }
    sortUsers();
    notifyListeners();
  }

  void nextPage() {
    _page++;
    fetchUsers();
  }

  void previousPage() {
    if (_page > 1) {
      _page--;
    }
    fetchUsers();
  }

  void selectUser(int userId, bool isSelected) {
    if (isSelected) {
      _selectedUserIds.add(userId);
    } else {
      _selectedUserIds.removeWhere((id) => id == userId);
    }
    notifyListeners();
  }

  void selectAllUsers(bool isSelected) {
    if (isSelected) {
      _selectedUserIds = _filteredUsers.map<int>((user) => user['id']).toSet();
    } else {
      _selectedUserIds.clear();
    }
    notifyListeners();
  }
}
