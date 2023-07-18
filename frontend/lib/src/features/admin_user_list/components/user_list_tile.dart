import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:frontend/src/features/admin_user_list/components/user_delete_dialog.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/navigators/users_list_screen_navigator.dart';

/*
  ListTile that is used for Admin User List Page

  @param user: contains user details.
*/

class UserListTile extends StatelessWidget {
  const UserListTile({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final isAdmin = user.isAdmin == 1;

    return ListTile(
      onTap: isAdmin
          ? null
          : () async {
              await settingsAppNav.currentState?.pushNamed(
                '/profileInfo',
                arguments: ProfileScreenArguments(userId: user.id),
              );
            },
      title: Container(
        height: 50,
        alignment: Alignment.centerLeft,
        child: Text(
          '${user.firstName} ${user.lastName}',
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      trailing: IconButton(
        onPressed: isAdmin
            ? null
            : () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => UserDeleteDialog(
                    id: user.id,
                  ),
                );
              },
        icon: isAdmin
            ? const Icon(Icons.admin_panel_settings)
            : SvgPicture.asset('assets/svg/trash.svg'),
        style: ButtonStyle(
          iconColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.red;
              }
              return Colors.black;
            },
          ),
        ),
      ),
    );
  }
}
