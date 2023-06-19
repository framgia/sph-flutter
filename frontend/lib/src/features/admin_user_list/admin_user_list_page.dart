import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      body: HeaderImage(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: FittedBox(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'REDEMPTO D. LEGASPI III',
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 30),
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
                width: double.infinity,
                alignment: Alignment.center,
                child: const SearchField(
                  name: "name",
                ),
              ),
              Container(
                height: 25,
              ),
              Expanded(
                child: Container(
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
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFFDAEAEE),
        color: const Color(0xFF5D8A99),
        items: <Widget>[
          SvgPicture.asset('assets/svg/list.svg'),
          SvgPicture.asset('assets/svg/home.svg'),
          SvgPicture.asset('assets/svg/profile_settings.svg'),
        ],
        onTap: (index) {},
      ),
    );
  }
}
