import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/style.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String text;
  final TabController? tabController;
  final bool isBottom;
  const CustomAppBar(
      {super.key,
      required this.text,
      required this.isBottom,
      this.tabController});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(isBottom ? 180.0 : 80.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 70.0,
      leading: IconButton(
        padding: CustomPadding.paddingAll_15,
        icon: const Icon(
          Icons.arrow_back_ios_new,
          size: 36.0,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        widget.text,
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      toolbarHeight: 80.0,
      backgroundColor: Colors.white,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 100.0),
          child: Container(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      ),
      bottom: widget.isBottom
          ? PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: TabBar(
                controller: widget.tabController,
                tabs: [
                  Tab(
                    height: 80.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.grid_view_sharp,
                          color: widget.tabController!.index == 0
                              ? ColorsTheme.primary
                              : ColorsTheme.grey,
                          size: 36.0,
                        ),
                        CustomGap.smallHeightGap,
                        Text(
                          'ช่อง',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: widget.tabController!.index == 0
                                ? ColorsTheme.primary
                                : ColorsTheme.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    height: 80.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category,
                          color: widget.tabController!.index == 1
                              ? ColorsTheme.primary
                              : ColorsTheme.grey,
                          size: 36.0,
                        ),
                        CustomGap.smallHeightGap,
                        Text(
                          'กรุ๊ป',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: widget.tabController!.index == 1
                                ? ColorsTheme.primary
                                : ColorsTheme.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                indicatorColor: ColorsTheme.primary,
                indicatorWeight: 5.0,
                labelPadding: const EdgeInsets.symmetric(vertical: 10.0),
                onTap: (index) {
                  setState(() {});
                },
              ),
            )
          : null,
    );
  }
}
