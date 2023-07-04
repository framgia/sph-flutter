import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:frontend/src/features/dashboard/components/account_card.dart';
import 'package:frontend/src/controllers/dashboard_controller.dart';

/*
  This widget displays the dashboard of the application 
  User should see:
   - App logo (top-left)
   - User name (top-right)
   - Account list
*/
class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.getUserAccounts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }

        if (controller.accounts.isEmpty) {
          return Column(
            children: [
              Center(
                child: Text(
                  "Dashboard",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 75,),
              Center(
                child: Text(
                  'No Account Found.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            Center(
              child: Text(
                "Dashboard",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Accounts",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => RefreshIndicator(
                      onRefresh: () => controller.getUserAccounts(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.48,
                        child: ListView.builder(
                          itemCount: controller.accounts.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return AccountCard(
                              account: controller.accounts[index],
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
