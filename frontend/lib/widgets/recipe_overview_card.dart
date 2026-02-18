import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class RecipeOverviewCard extends StatefulWidget {
  const RecipeOverviewCard(
    {
      super.key,
      required this.mealName,
      required this.mealType,
      required this.mealCalories,
      required this.mealDesc,
      required this.isFavourite
    }
  );

  final String mealName;
  final String mealType;
  final int mealCalories;
  final String mealDesc;
  final bool isFavourite;

  @override
  State<RecipeOverviewCard> createState() => _RecipeOverviewCardState();
}

class _RecipeOverviewCardState extends State<RecipeOverviewCard> {

  late bool _isFavourite;

  Future<void>addToFavourite()async{
    setState(() {
      _isFavourite = !_isFavourite;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isFavourite = widget.isFavourite;
  }

  @override
  Widget build(BuildContext context) {
    IconData recipeIcon = Icons.set_meal;
    Color iconBackgroundColor =Color(0x1A1E9BD7);
    Color iconColor = Color(0xFF1E9BD7);

    switch(widget.mealType.toLowerCase()){
      case "breakfast":
        recipeIcon = Icons.wb_sunny_outlined;
        iconBackgroundColor = lightYellow;
        iconColor =normalYellow;
        break;
      case "lunch":
        recipeIcon = Icons.cloud_outlined;
        iconBackgroundColor = Color(0x1A2B9348);
        iconColor =Color(0xFF2B9348);
        break;
      case "dinner":
        recipeIcon = Icons.dark_mode_outlined;
        iconBackgroundColor = Color(0x1AE8613A);
        iconColor =Color(0xFFE8613A);
        break;
      default:
        recipeIcon = Icons.set_meal;
        iconBackgroundColor =Color(0x1A1E9BD7);
        iconColor = normalBlue;

    }
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: iconBackgroundColor
                      ),
                      child: Icon(
                        recipeIcon,
                        size: 35.0,
                        color: iconColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.mealName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(widget.mealDesc),
                          SizedBox(height: 4),
                          Text("${widget.mealCalories.toString()} kcal")
                        ],
                      )
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => addToFavourite(),
                      child:Icon(
                        _isFavourite? Icons.favorite :Icons.favorite_border,
                        color: _isFavourite ? Colors.red[400] : Colors.black,
                        size: 30.0,
                      ),
                    )
                  ],
                ),
              )
          ),
    );
  }
}