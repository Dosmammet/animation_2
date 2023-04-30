import 'package:animation_2/refresh_ind_menki.dart';
import 'package:animation_2/shimmerheader.dart';
import 'package:animation_2/visible.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  List<String> pageValue = ['One', '2', 'Three'];
  Future _onRefresh() async {
    // monitor network fetch
    print('refreshing');
    await Future.delayed(Duration(milliseconds: 0));
    pagecontroller.animateToPage(0,
        duration: Duration(milliseconds: 600), curve: Curves.easeInOut);

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    print('loading');
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length + 1).toString());
    // if (mounted) setState(() {});

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
            body:
                // SmartRefresher(
                //   controller: _refreshController,
                //   primary: true,
                //   enablePullDown: true,
                //   //enablePullUp: true,
                //   onLoading: _onLoading,
                //   onRefresh: _onRefresh,
                //   header: ShimmerHeader(
                //     text: Text(
                //       "Refresh",
                //       style: TextStyle(color: Colors.black, fontSize: 18),
                //     ),
                //   ),
                //   child:
                RefreshIndicatorMenki(
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
