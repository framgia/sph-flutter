import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/src/features/admin_user_list/components/user_delete_dialog.dart';

/*
  ListTile that is used for Admin User List Page

  @param name, full name of the user to be displayed
  
  @param isAdmin, bool that controls prevention of user deletion (cant delete admin user)
*/

class UserListTile extends StatelessWidget {
  const UserListTile({super.key, required this.name, required this.isAdmin});

  final String name;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        height: 50,
        alignment: Alignment.centerLeft,
        child: Text(
          name,
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
                  builder: (BuildContext context) => const UserDeleteDialog(),
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
