import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myecomstore/controllers/favorites_provider.dart';
import 'package:myecomstore/controllers/mainscreen_provider.dart';
import 'package:myecomstore/controllers/product_provider.dart';
import 'package:myecomstore/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('cart_box');
  await Hive.openBox('fav_box');

  runApp(MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (context) => MainScreenNotifier()),
        ChangeNotifierProvider(create: (context) => ProductNotifier()),
        ChangeNotifierProvider(create: (context) => FavoritesNotifier()),
      ],
    child: const MyApp(),
  )); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyEcomStore',
      theme: ThemeData(
       primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}
