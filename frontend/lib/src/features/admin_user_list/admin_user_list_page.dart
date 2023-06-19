import 'package:flutter/material.dart';
import 'package:frontend/src/components/breadcrumb.dart';
import 'package:frontend/src/components/input/search_field.dart';
import 'package:frontend/src/features/admin_user_list/components/user_list_card.dart';

/*
  The page where admins can see all the users.
*/
class AdminUserListPage extends StatelessWidget {
  AdminUserListPage({super.key});

  //TODO:Replace Temporary UserList variable with state
  final List<String> userList = [
    'User 1',
    'User 2',
    'User 3',
    'User 4',
    'User 5',
    'User 6',
    'User 7',
    'User 8',
    'User 9',
    'User 10',
    'User 11'
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Column(
        children: [
          const Breadcrumb(
            text: "List of Users",
            withBackIcon: false,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const SearchField(
                    name: "name",
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  color: Colors.white,
                  child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        String name = userList[index];
                        return UserListCard(name: name);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          height: 1,
                          color: Color.fromRGBO(109, 120, 129, 1),
                        );
                      },
                      itemCount: userList.length,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
