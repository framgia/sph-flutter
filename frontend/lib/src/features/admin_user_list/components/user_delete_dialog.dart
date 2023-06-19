import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDeleteDialog extends StatelessWidget {
  const UserDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Confirmation',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: const Color.fromRGBO(109, 120, 129, 1),
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: const Color.fromRGBO(109, 120, 129, 1),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
            Container(
              width: 220,
              alignment: Alignment.center,
              child: Text(
                'ARE YOU SURE YOU WANT TO DELETE THE USER?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    backgroundColor: const Color.fromRGBO(0, 204, 255, 1),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'No',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
                    shadowColor: Colors.black,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Yes',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
