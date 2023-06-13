import 'package:flutter/material.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/features/admin_user_list/components/user_list_card.dart';
import 'package:get/get.dart';

class AdminUserListPage extends StatelessWidget {
  const AdminUserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(218, 234, 238, 1),
      body: Column(
        children: [
          Container(
            color: const Color.fromRGBO(218, 234, 238, 1),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 180, 0),
                  child: Image.asset(
                    'assets/images/corner.png',
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 70),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 103,
                        height: 62,
                        child: Image.asset(
                          'assets/images/logo.png',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'JOASH C. CANETE',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey[400],
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color.fromRGBO(218, 234, 238, 1),
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.blueGrey[400],
                      // size: 21,
                    ),
                  ),
                ),
                Text(
                  'List of Users',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blueGrey[400],
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                  ),
                ),
                const SizedBox(
                  width: 30,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            color: const Color.fromRGBO(218, 234, 238, 1),
            child: const InputField(name: 'Search...'),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              children: const [
                UserListCard(name: 'JOASH C. CANETE'),
                UserListCard(name: 'JOASH C. CANETE'),
                UserListCard(name: 'JOASH C. CANETE'),
                UserListCard(name: 'JOASH C. CANETE'),
                UserListCard(name: 'JOASH C. CANETE'),
                UserListCard(name: 'JOASH C. CANETE'),
                UserListCard(name: 'JOASH C. CANETE'),
                UserListCard(name: 'JOASH C. CANETE'),
                UserListCard(name: 'JOASH C. CANETE'),
                UserListCard(name: 'JOASH C. CANETE'),
                UserListCard(name: 'JOASH C. CANETE'),
                UserListCard(name: 'JOASH C. CANETE'),
                UserListCard(name: 'JOASH C. CANETE'),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.green,
        height: 45,
      ),
    );
  }
}
