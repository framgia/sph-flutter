import 'package:flutter/material.dart';
import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/features/admin_user_list/components/user_list_card.dart';
import 'package:get/get.dart';

class AdminUserListPage extends StatelessWidget {
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

  AdminUserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(218, 234, 238, 1),
      body: Column(
        children: [
          const AuthHeader(hasAuthToken: true),
          Container(
            color: const Color.fromRGBO(218, 234, 238, 1),
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 29,
                      color: Color.fromRGBO(120, 144, 156, 1),
                    ),
                  ),
                ),
                const Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    'List of Users',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(120, 144, 156, 1),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 47,
            width: double.infinity,
            color: Colors.red,
            child: Container(),
          ),
          Container(
            height: 10,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.separated(
                  shrinkWrap: true,
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
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(93, 138, 153, 1),
        height: 45,
      ),
    );
  }
}
