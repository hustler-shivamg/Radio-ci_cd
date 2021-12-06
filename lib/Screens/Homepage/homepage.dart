import 'package:flutter/material.dart';

import '../../base/base_view_view_model.dart';
import 'home_screen_binding.dart';

class HomePage extends BaseView<HomeScreenController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      builder: (controller) {
        return Scaffold(
          body: Obx(
            () {
              return IndexedStack(
                index: controller.tabIndex.toInt(),
                children: controller.pageList,
              );
            },
          ),
        );
      },
    );
  }
}
