import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hive/hive.dart';
import 'package:myecomstore/controllers/favorites_provider.dart';
import 'package:myecomstore/controllers/product_provider.dart';
import 'package:myecomstore/services/helper.dart';
import 'package:myecomstore/views/shared/appstyle..dart';
import 'package:myecomstore/views/shared/checkout_btn.dart';
import 'package:myecomstore/views/ui/favorites.dart';
import 'package:provider/provider.dart';
import '../../models/constants.dart';
import '../../models/sneaker_model.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.id, required this.category});

  final String id;
  final String category;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final PageController pageController = PageController();
  final _cartBox = Hive.box('cart_box');
  final _favBox = Hive.box('fav_box');
  late Future<Sneakers> _sneaker;


  void getShoes(){
    if(widget.category == "Men's Running"){
      _sneaker = Helper().getMaleSneakersById(widget.id);
    }else if(widget.category == "Women's Running"){
      _sneaker = Helper().getfemaleSneakersById(widget.id);
    }else{
      _sneaker = Helper().getkidsSneakersById(widget.id);
    }
  }
  Future<void> _createCart(Map<String, dynamic> newCart) async{
    await _cartBox.add(newCart);
  }
  Future<void> _createFav(Map<String,dynamic> addFav) async{
    await _favBox.add(addFav);
    getFavorites();
  }
  getFavorites(){
    final favData = _favBox.keys.map((key){
      final item = _favBox.get(key);
      return {
        "key" : key,
        "id": item['id'],
      };
    }).toList();
    favor = favData.toList();
    ids = favor.map((item) => item['id']).toList();
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Sneakers>(
          future: _sneaker,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error ${snapshot.error}');
            } else {
              final sneaker = snapshot.data;
              return Consumer<ProductNotifier>(
                  builder: (context, productNotifier, child) {
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          leadingWidth: 0,
                          title: Padding(padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    productNotifier.shoesSizes.clear();
                                  },
                                  child: const Icon(AntDesign.close, color: Colors.black,),
                                ),
                                GestureDetector(
                                  onTap: () {
                                  },
                                  child: const Icon(Ionicons.ellipsis_horizontal,color: Colors.black),
                                )
                              ],
                            ),),
                          pinned: true,
                          snap: false,
                          floating: true,
                          backgroundColor: Colors.transparent,
                          expandedHeight: MediaQuery.of(context).size.height,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  width: MediaQuery.of(context).size.width,
                                  child: PageView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: sneaker!.imageUrl.length,
                                    controller: pageController,
                                    onPageChanged: (page) {
                                      productNotifier.activePage = page;
                                    },
                                    itemBuilder: (context, int index) {
                                      return Stack(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height * 0.37,
                                            width: MediaQuery.of(context).size.width,
                                            color: Colors.grey.shade300,
                                            child: CachedNetworkImage(
                                              imageUrl: sneaker.imageUrl[index] ,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Positioned(
                                              top: MediaQuery.of(context).size.height * 0.1,
                                              right: 20,
                                              child:Consumer<FavoritesNotifier> (
                                                builder: (context,favoritesNotifier, child){
                                                  return GestureDetector(
                                                      onTap: (){
                                                        if(ids.contains(widget.id)){
                                                          Navigator.push(context,MaterialPageRoute(
                                                              builder:(context) => const Favorites()));
                                                        }else{
                                                          _createFav({
                                                            "id" : sneaker.id,
                                                            "name" : sneaker.name,
                                                            "category" : sneaker.category,
                                                            "price" : sneaker.price,
                                                            "imageUrl" : sneaker.imageUrl[0],
                                                          });
                                                        }
                                                      },
                                                      child: ids.contains(sneaker.id) ? const Icon(AntDesign.heart) : const Icon(AntDesign.hearto,)
                                                  );
                                                },
                                              )),
                                          Positioned(
                                              bottom: 0,
                                              right: 0,
                                              left: 0,
                                              height: MediaQuery.of(context).size.height * 0.35,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: List<Widget>.generate(
                                                    sneaker.imageUrl.length, (index) =>
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                                      child: CircleAvatar(
                                                        radius: 4.5,
                                                        backgroundColor: productNotifier
                                                            .activePage != index
                                                            ? Colors.grey
                                                            : Colors.black,
                                                      ),)),
                                              )
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                    bottom: 28,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30)
                                      ),
                                      child:Container(
                                        height: MediaQuery.of(context).size.height*0.65,
                                        width: MediaQuery.of(context).size.width,
                                        color: Colors.white,
                                        child: Padding(
                                            padding: const EdgeInsets.all(13),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(sneaker.name,style: appstyle(30, Colors.black,FontWeight.bold),),
                                                Row(
                                                  children: [
                                                    Text(sneaker.category, style: appstyle(18, Colors.grey, FontWeight.w500),),
                                                    const SizedBox(width: 15,),
                                                    RatingBar.builder(
                                                      initialRating: 4,
                                                        minRating: 1,
                                                        direction: Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 18,
                                                        itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                                       itemBuilder: ((context, _ ) => const Icon(Icons.star, size: 20 ,color: Colors.black,)),
                                                      onRatingUpdate: (rating){},
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("\$${sneaker.price}", style: appstyle(26,Colors.black, FontWeight.w500),),
                                                    Row(
                                                      children: [
                                                        Text('Colors', style: appstyle(18, Colors.black, FontWeight.w500),),
                                                        const SizedBox(width: 5,),
                                                        const CircleAvatar(radius: 7, backgroundColor: Colors.black,),
                                                        const SizedBox(width: 5,),
                                                        const CircleAvatar(radius: 7, backgroundColor: Colors.red,),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20,),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('Select Sizes', style: appstyle(20, Colors.black, FontWeight.w600),),
                                                        const SizedBox(width: 20,),
                                                        Text('View size guide', style: appstyle(20, Colors.grey,FontWeight.w600),)
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    SizedBox(
                                                      height: 40,
                                                      child:ListView.builder(
                                                        itemCount: productNotifier.shoesSizes.length,
                                                          scrollDirection: Axis.horizontal,
                                                          padding: EdgeInsets.zero,
                                                          itemBuilder: (context, index){
                                                          final sizes = productNotifier.shoesSizes[index];
                                                          return Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                            child: ChoiceChip(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(60),
                                                                side: const BorderSide(
                                                                  color: Colors.black,
                                                                  width: 1,
                                                                  style: BorderStyle.solid,
                                                                ),
                                                              ),
                                                                disabledColor: Colors.white,
                                                                label: Text(sizes['size'], style: appstyle(13, sizes['isSelected'] ? Colors.white : Colors.black, FontWeight.w500),),
                                                                selected: sizes['isSelected'],
                                                                selectedColor: Colors.black,
                                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                                onSelected: (newState) {
                                                                  if (productNotifier.sizes.contains(sizes['size'])) {
                                                                    productNotifier.sizes.remove(sizes['size']);
                                                                  } else {
                                                                    productNotifier.sizes.add(sizes['size']);
                                                                  }
                                                                  productNotifier.toggleCheck(index);
                                                                } ),
                                                              );
                                                          }
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    const Divider(
                                                      indent: 10,
                                                      endIndent: 10,
                                                      color: Colors.black,
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width*0.95,
                                                      child: Text(sneaker.title, style: appstyle(20, Colors.black, FontWeight.w700),),
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    Text(sneaker.description,
                                                      textAlign: TextAlign.justify, maxLines: 4,
                                                      style: appstyle(11, Colors.black, FontWeight.normal),),
                                                    const SizedBox(height: 10,),
                                                    Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 12),
                                                        child: CheckoutButton(
                                                          onTap: () async{
                                                            _createCart({
                                                             "id" : sneaker.id,
                                                             "name" : sneaker.name,
                                                             "category" : sneaker.category,
                                                              "sizes" : sneaker.sizes[0],
                                                             "imageUrl" : sneaker.imageUrl[0],
                                                              "price" : sneaker.price,
                                                              "qty" : '1',
                                                            });
                                                            productNotifier.sizes.clear();
                                                            Navigator.pop(context);
                                                          },
                                                          label: 'Add to Cart',
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  });
            }
          }
      ),
    );
  }
}
