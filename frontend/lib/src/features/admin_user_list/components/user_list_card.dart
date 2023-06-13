import 'package:flutter/material.dart';
import 'package:frontend/src/features/admin_user_list/components/user_delete_dialog.dart';

class UserListCard extends StatelessWidget {
  final String name;

  const UserListCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
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
        icon: const Icon(Icons.delete),
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
