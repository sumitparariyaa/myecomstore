import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myecomstore/views/shared/appstyle..dart';

 class Favorites extends StatefulWidget {
   const Favorites({super.key});

   @override
   State<Favorites> createState() => _FavoritesState();
 }

 class _FavoritesState extends State<Favorites> {
   final _favBox = Hive.box('fav_box');

   _deleteFav(int key) async{
     await _favBox.delete(key);
   }
   @override
   Widget build(BuildContext context) {
     List<dynamic> fav = [];
     final favData = _favBox.keys.map((key) {
       final item = _favBox.get(key);
       return {
         "key" : key,
         "id" : item['id'],
         "category" : item['category'] ,
         "price" : item['price'],
         "imageUrl" : item['imageUrl'] ,
       };
     }).toList();
     fav = favData.reversed.toList();
     return Scaffold(
       body: SizedBox(
         height: MediaQuery.of(context).size.height,
         width: MediaQuery.of(context).size.width,
         child: Stack(
           children: [
             Container(
               padding: const EdgeInsets.fromLTRB(16, 45, 0, 0),
               height: MediaQuery.of(context).size.height*0.4,
               decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/top_image.png'),fit: BoxFit.fill),
               ),
             )
           ],
         ),
       ),
     );
   }
 }
// Positioned(
// top: MediaQuery.of(context).size.height * 0.1,
// right: 20,
// child:Consumer<FavoritesNotifier> (
// builder: (context,favoritesNotifier, child){
// return GestureDetector(
// onTap: (){
// if(ids.contains(widget.id)){
// Navigator.push(context,MaterialPageRoute(
// builder:(context) => const Favorites()));
// }else{
// _createFav({
// "id" : sneaker.id,
// "name" : sneaker.name,
// "category" : sneaker.category,
// "price" : sneaker.price,
// "imageUrl" : sneaker.imageUrl[0],
// });
// }
// },
// child: ids.contains(sneaker.id) ? const Icon(AntDesign.heart) : const Icon(AntDesign.hearto, color: Colors.grey,)
// );
// },
// )),