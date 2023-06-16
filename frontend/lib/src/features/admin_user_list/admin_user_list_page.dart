import 'package:flutter/material.dart';
import 'package:frontend/src/components/input/search_field.dart';
import 'package:frontend/src/components/templates/header_image.dart';
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
          //TODO: Replace with selected Header Component
          HeaderImage(
            child: Container(
              margin: const EdgeInsets.only(top: 70),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Image.asset('assets/images/sph-flutter-logo.png'),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: FittedBox(
                      child: Text(
                        'REDEMPTO D. LEGASPI III',
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
            width: double.infinity,
            alignment: Alignment.center,
            child: const SearchField(
              name: "name",
            ),
          ),
          Container(
            height: 10,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
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

      // TODO (ian): replace temporary widget with Navbar Widget
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(93, 138, 153, 1),
        height: 45,
      ),
    );
  }
}
