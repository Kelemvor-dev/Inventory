import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants.dart';


class Navbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String categoryOne;
  final String categoryTwo;
  final bool searchBar;
  final bool backButton;
  final bool transparent;
  final bool reverseTextcolor;
  final bool rightOptions;
  final bool isOnSearch;
  final bool searchAutofocus;
  final bool noShadow;
  final Color bgColor;

  const Navbar(
      {super.key,
      this.title = "Home",
      this.categoryOne = "",
      this.categoryTwo = "",
      this.transparent = false,
      this.rightOptions = true,
      this.reverseTextcolor = false,
      this.isOnSearch = false,
      this.searchAutofocus = false,
      this.backButton = false,
      this.noShadow = false,
      this.bgColor = Colors.white,
      this.searchBar = false});

  final double _prefferedHeight = 180.0;

  @override
  _NavbarState createState() => _NavbarState();

  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);
}

class _NavbarState extends State<Navbar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool categories = widget.categoryOne.isNotEmpty && widget.categoryTwo.isNotEmpty;

    return Container(
        height: 55,
        decoration: BoxDecoration(color: !widget.transparent ? widget.bgColor : Colors.transparent, boxShadow: [
          BoxShadow(
              color: !widget.transparent && !widget.noShadow ? UiColors.kmuted : Colors.transparent,
              spreadRadius: -10,
              blurRadius: 12,
              offset: const Offset(0, 5))
        ]),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(!widget.backButton ? Icons.menu : Icons.arrow_back_ios,
                              color: !widget.transparent
                                  ? (widget.bgColor == Colors.white ? Colors.black : Colors.white)
                                  : (widget.reverseTextcolor ? Colors.black : Colors.white),
                              size: 24.0),
                          onPressed: () {
                            if (!widget.backButton) {
                              Scaffold.of(context).openDrawer();
                            } else {
                              Navigator.pop(context);
                            }
                          }),
                      Center(
                          child: Text(widget.title,
                              style: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: !widget.transparent
                                      ? (widget.bgColor == Colors.white ? Colors.black : Colors.white)
                                      : (widget.reverseTextcolor ? Colors.black : Colors.white))))
                    ],
                  ),
                  if (widget.rightOptions)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //Si quiero poner iconos en el navbar children: [ ],
                    )
                ],
              ),
              if (widget.searchBar)
                const SizedBox(
                  height: 10.0,
                ),
              if (categories)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Trending()));
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.camera, color: Colors.black, size: 18.0),
                          const SizedBox(width: 8),
                          Text(widget.categoryOne, style: const TextStyle(color: Colors.black, fontSize: 14.0)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      color: Colors.black,
                      height: 25,
                      width: 1,
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Fashion()));
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_cart, color: Colors.black, size: 18.0),
                          const SizedBox(width: 8),
                          Text(widget.categoryTwo, style: const TextStyle(color: Colors.black, fontSize: 14.0)),
                        ],
                      ),
                    )
                  ],
                ),
            ],
          ),
        ));
  }
}
