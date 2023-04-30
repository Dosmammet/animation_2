import 'package:animation_2/refresh_ind_menki.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  Future _onRefresh() async {
    print('refreshing');
    await Future.delayed(Duration(milliseconds: 0));
    pagecontroller.animateToPage(0,
        duration: Duration(milliseconds: 600), curve: Curves.easeInOut);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    print('loading');
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  final pagecontroller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('qrqrqq')),
      body: PageView(
        controller: pagecontroller,
        scrollDirection: Axis.vertical,
        children: [
          Scaffold(
            body: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                    ),
                    Text(
                      'Screen 1',
                      style: TextStyle(fontSize: 19),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.white,
            body: RefreshIndicatorMenki(
              title: 'Refresh',
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      Text(
                        'Screen 2',
                        style: TextStyle(fontSize: 19),
                      ),
                      ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Text('Example 1'),
                          Text('Example 2'),
                          Text('Example 3'),
                          Text('Example 4'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ),
          )
        ],
      ),
    );
  }
}
