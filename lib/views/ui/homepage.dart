import 'package:flutter/material.dart';
import 'package:myecomstore/models/sneaker_model.dart';
import 'package:myecomstore/services/helper.dart';
import 'package:myecomstore/views/shared/appstyle..dart';
import 'package:myecomstore/views/shared/home_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  late final TabController _tabController = TabController(
      length: 3,
      vsync: this);
    late Future<List<Sneakers>> _male;
    late Future<List<Sneakers>> _female;
    late Future<List<Sneakers>> _kids;

    void getMale(){
      _male = Helper().getMaleSneakers();
    }
  void getFemale(){
    _female = Helper().getFemaleSneakers();
  }
  void getKids(){
    _kids = Helper().getKidsSneakers();
  }

    @override
  void initState() {
    super.initState();
    getMale();
    getFemale();
    getKids();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            //tab bar and title
            Container(
              padding: const EdgeInsets.fromLTRB(16, 45, 0, 0),
              height: MediaQuery.of(context).size.height*0.4,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/img.png'),fit: BoxFit.fill)
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 8,bottom: 15),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Athletics Shoes',style: appstyleWIthHt(42, Colors.white,FontWeight.bold, 1.5),),
                    Text('Collection', style: appstyleWIthHt(42, Colors.white,FontWeight.bold, 1.2,),),
                    TabBar(
                        padding: EdgeInsets.zero,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Colors.transparent,
                        controller: _tabController,
                        isScrollable: true,
                        labelColor: Colors.white,
                        labelStyle: appstyle(24, Colors.white,FontWeight.bold),
                        unselectedLabelColor: Colors.grey.withOpacity(0.3),
                        tabs: const [
                          Tab(text: 'Men Shoes',),
                          Tab(text: 'Women Shoes',),
                          Tab(text: 'Kids Shoes',)
                        ]),
                  ],
                ),
              ),
            ),
            //tab bar view
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.265),
              child: Container(
                padding: const EdgeInsets.only(left: 12),
                child: TabBarView(
                    controller: _tabController,
                    children: [
                      //men tabview
                       HomeWidget(male: _male, tabIndex: 0,),
                      //women tabview
                      HomeWidget(male: _female, tabIndex: 1,),
                      //kid tabview
                      HomeWidget(male: _kids, tabIndex: 2,),
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
