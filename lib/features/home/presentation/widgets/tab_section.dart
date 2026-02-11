import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';

class TabSection extends StatefulWidget {
  const TabSection({super.key});

  @override
  State<TabSection> createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final List tabs = ['TERBARU', 'TERPOPULER', 'FOR YOU'];
    return Container(
      color: PortalColors.jtvBiru,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...tabs.map((tab) {
            return Expanded(
              child: InkWell(
                hoverColor: PortalColors.grey100,
                onTap: () {
                  setState(() {
                    index = tabs.indexOf(tab);
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 45,
                  decoration: BoxDecoration(
                    border: tab == tabs[index]
                        ? Border(
                            bottom: BorderSide(
                              color: PortalColors.jtvJingga,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          )
                        : Border(),
                  ),
                  child: Text(
                    tab,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: PortalColors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
