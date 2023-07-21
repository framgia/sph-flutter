import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

import 'package:frontend/src/components/empty_graph.dart';
import 'package:frontend/src/components/legend_section.dart';
import 'package:frontend/src/controllers/graph_controller.dart';
import 'package:frontend/src/controllers/spending_breakdown_controller.dart';
import 'package:frontend/src/features/dashboard/components/account_card.dart';
import 'package:frontend/src/helper/transaction_category_color.dart';

/*
  A Graph widget where transaction data can be displayed graphically

  @param onTap: optional function and this is called when user tapped the widget
*/

class Graph extends StatelessWidget {
  Graph({
    super.key,
    this.onTap,
  });

  final GraphController graphController = Get.put(GraphController());
  final SpendingBreakdownController spendingBreakdownController =
      Get.put(SpendingBreakdownController());

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as AccountScreenArguments;
    return FutureBuilder(
      future: spendingBreakdownController.getSpendingBreakdown(
        accountId: arguments.accountId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }

        if (spendingBreakdownController.spendingList.isEmpty) {
          return const EmptyGraph();
        }

        return Center(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  blurRadius: 2,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                width: double.maxFinite,
                height: 236,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: StatefulBuilder(
                        builder: (context, stateful) {
                          return Obx(
                            () => PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    stateful(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        graphController.setFocusIndex = -1;

                                        return;
                                      }
                                      graphController.setFocusIndex =
                                          pieTouchResponse.touchedSection!
                                              .touchedSectionIndex;
                                    });
                                  },
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 0,
                                centerSpaceRadius: 30,
                                sections: showingSections(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    LegendSection(
                      spendingList: spendingBreakdownController.spendingList,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> list = [];

    spendingBreakdownController.spendingList
        .asMap()
        .forEach((index, breakdown) {
      final isTouched = index == graphController.focusIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      var totalSpentPercentage = ((breakdown.totalTransactionAmount /
                  spendingBreakdownController.totalSpent) *
              100)
          .toStringAsFixed(1);

      list.add(
        PieChartSectionData(
          color: transactionCategoryColor(breakdown.category),
          value: double.parse(totalSpentPercentage),
          title: '$totalSpentPercentage%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        ),
      );
    });

    return list;
  }
}
