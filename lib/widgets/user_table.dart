import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class UserTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final allSelected = userProvider.users.isNotEmpty &&
        userProvider.selectedUserIds.length == userProvider.users.length;

    int getColumnIndex(String columnName) {
      switch (columnName) {
        case 'name':
          return 0;
        case 'email':
          return 1;
        case 'grade':
          return 2;
        case 'followers':
          return 3;
        case 'engagement_rate':
          return 4;
        case 'tags':
          return 5;
        case 'hashtags':
          return 6;
        default:
          return 0;
      }
    }

    return userProvider.users.isEmpty
        ? Center(child: Text('No data available'))
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DataTable(
                sortColumnIndex: getColumnIndex(userProvider.sortColumn),
                sortAscending: userProvider.isAscending,
                columns: [
                  DataColumn(
                      label: Text('Influencer Name'),
                      onSort: (columnIndex, ascending) {
                        userProvider.updateSortColumn('name');
                      }),
                  DataColumn(
                      label: Text('Email'),
                      onSort: (columnIndex, ascending) {
                        userProvider.updateSortColumn('email');
                      }),
                  DataColumn(
                      label: Text('Grade'),
                      onSort: (columnIndex, ascending) {
                        userProvider.updateSortColumn('grade');
                      }),
                  DataColumn(
                      label: Text('Followers'),
                      onSort: (columnIndex, ascending) {
                        userProvider.updateSortColumn('followers');
                      }),
                  DataColumn(
                      label: Text('Engagement Rate'),
                      onSort: (columnIndex, ascending) {
                        userProvider.updateSortColumn('engagement_rate');
                      }),
                  DataColumn(
                      label: Text('Tags'),
                      onSort: (columnIndex, ascending) {
                        userProvider.updateSortColumn('tags');
                      }),
                  DataColumn(
                      label: Text('Hashtags'),
                      onSort: (columnIndex, ascending) {
                        userProvider.updateSortColumn('hashtags');
                      })
                ],
                rows: userProvider.users.map((user) {
                  return DataRow(
                    selected: userProvider.selectedUserIds.contains(user['id']),
                    onSelectChanged: (bool? selected) {
                      userProvider.selectUser(user['id'], selected ?? false);
                    },
                    cells: [
                      DataCell(Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user['avatarUrl'] ??
                                'https://via.placeholder.com/40'),
                          ),
                          SizedBox(width: 8),
                          Text(user['name'] ?? 'N/A'),
                        ],
                      )),
                      DataCell(Text(user['email'] ?? '-')),
                      DataCell(Text(user['grade'] ?? '-')),
                      DataCell(Text(user['followers']?.toString() ?? '0')),
                      DataCell(Text('${user['engagement_rate'] ?? 0}%')),
                      DataCell(Text(user['tags'] ?? 'No Tags')),
                      DataCell(Text(user['hashtags'] ?? ''))
                    ],
                  );
                }).toList(),
              ),
            ),
          );
  }
}
