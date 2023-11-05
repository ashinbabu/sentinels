import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:busco/utils/colors.dart';
import 'package:provider/provider.dart';

class AppBarWithSearch extends StatefulWidget implements PreferredSizeWidget {
  AppBarWithSearch({
    Key? key,
    this.isSearchVisible = true,
    this.isFavVisible = false,
    this.isCartVisible = true,
  }) : super(key: key);
  @override
  Size get preferredSize =>
      isSearchVisible ? new Size.fromHeight(120) : new Size.fromHeight(60);

  final bool isSearchVisible;
  final bool isFavVisible;
  final bool isCartVisible;
  @override
  _AppBarWithSearchState createState() => _AppBarWithSearchState();
}

class _AppBarWithSearchState extends State<AppBarWithSearch> {
  FocusNode _noFocusFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
   
    return AppBar(
      leading: InkWell(
        onTap: () => Scaffold.of(context).openDrawer(),
        borderRadius: BorderRadius.circular(1000),
        child: Icon(
          Icons.menu,
          color: Color(TEXT_COLOR),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            './assets/images/top-bar-logo.png',
            width: 40,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'BusCo',
              style: GoogleFonts.montserrat(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
     
      bottom: widget.isSearchVisible
          ? PreferredSize(
              preferredSize: Size(double.infinity, 10),
              child: Container(
                height: 60,
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.search,
                          color: Colors.black54,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: _noFocusFocusNode,
                          onTap: () {
                            _noFocusFocusNode.unfocus();
                            Navigator.pushNamed(context, '/search-screen');
                          },
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.montserrat(),
                            border: InputBorder.none,
                            hintText: 'Search here',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
