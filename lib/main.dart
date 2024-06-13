import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'widgets/user_table.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: UserPage(),
      ),
    );
  }
}

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _selectedFollowersFilter = 'Followers';
  String _selectedGradeFilter = 'Grade';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
                title: Text('Influencer Directory',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2)),
                centerTitle: true,
                backgroundColor: Colors.purple)),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(children: [
              SizedBox(height: 10),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    _buildFilterDropdown(
                        _selectedFollowersFilter, ['All', '0-50', '50-100'],
                        (value) {
                      setState(() {
                        _selectedFollowersFilter =
                            value == '' ? 'Followers' : value;
                      });
                      userProvider.updateFollowersFilter(value);
                    }),
                    _buildFilterDropdown(
                        _selectedGradeFilter, ['All', 'A', 'B', 'C'], (value) {
                      setState(() {
                        _selectedGradeFilter = value == '' ? 'Grade' : value;
                      });
                      userProvider.updateGradeFilter(value);
                    })
                  ])),
              SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                ElevatedButton.icon(
                    onPressed: () {
                      userProvider.clearAllFilters();
                      setState(() {
                        _selectedFollowersFilter = 'Followers';
                        _selectedGradeFilter = 'Grade';
                      });
                    },
                    icon: Icon(Icons.clear),
                    label: Text('Clear All'),
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ))),
                ElevatedButton.icon(
                    onPressed: () {
                      userProvider.fetchUsers();
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Refresh Data'),
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )))
              ]),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextField(
                    decoration: InputDecoration(
                        labelText: 'Search',
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                        prefixIcon:
                            Icon(Icons.search, color: Colors.grey.shade600),
                        suffixIcon: IconButton(
                            icon:
                                Icon(Icons.clear, color: Colors.grey.shade600),
                            onPressed: () {
                              userProvider.updateSearchQuery('');
                            })),
                    onChanged: (value) =>
                        userProvider.updateSearchQuery(value)),
              ),
              SizedBox(height: 8),
              Expanded(
                child: UserTable(),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => userProvider.previousPage(),
                          child: Text('Previous'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => userProvider.nextPage(),
                          child: Text('Next'),
                        )
                      ]))
            ])));
  }

  Widget _buildFilterDropdown(
      String label, List<String> options, Function(String) onChanged) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade400)),
            child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    hint: Text(label,
                        style: TextStyle(color: Colors.grey.shade600)),
                    value:
                        label != 'Followers' && label != 'Grade' ? label : null,
                    onChanged: (value) {
                      if (value == 'All') {
                        value = '';
                      }
                      onChanged(value!);
                    },
                    icon: Icon(Icons.arrow_drop_down,
                        color: Colors.grey.shade600),
                    items: options.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()))));
  }
}
