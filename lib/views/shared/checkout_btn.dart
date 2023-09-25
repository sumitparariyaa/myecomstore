import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myecomstore/views/shared/appstyle..dart';

class CheckoutButton extends StatelessWidget {
  const CheckoutButton({super.key, this.onTap, required this.label});

  final void Function()? onTap;
  final String label;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(padding: const EdgeInsets.all(8),
        child: Container(
          height: 50,
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          width: MediaQuery.of(context).size.width*0.9,
          child: Center(
            child: Text(label,style: appstyle(20, Colors.white, FontWeight.bold),),
          ),
        ),
      ),
    );
  }
}
