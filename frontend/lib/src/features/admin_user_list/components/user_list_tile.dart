import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/src/features/admin_user_list/components/user_delete_dialog.dart';

/*
  ListTile that is used for Admin User List Page
*/

class UserListTile extends StatelessWidget {
  const UserListTile({super.key, required this.name});

  final String name;

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
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => const UserDeleteDialog(),
          );
        },
        icon: SvgPicture.asset('assets/svg/trash.svg'),
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