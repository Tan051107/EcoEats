import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/services/shelf_item_service.dart';
import 'package:frontend/widgets/add_grocery_form.dart';
import 'package:frontend/widgets/form_dialog.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/shelf_item_card.dart';

class Pantry extends StatefulWidget {
  const Pantry(
    {
      super.key,
    }
  );



  @override
  State<Pantry> createState() => _PantryState();
}

class _PantryState extends State<Pantry> {
  late String category = "";
  List<Map<String,dynamic>> shelfItemsRetrieved = [];
  bool isLoadingShelfItem = false;

  Future<void> getShelfItems(String categorySelected)async{
    if(category == categorySelected){
      return;
    }
    setState(() {
      isLoadingShelfItem = true;
    });
    try{
      setState(() {
        category =categorySelected;
      });
      List<Map<String,dynamic>> shelfItems = await ShelfItemService.getShelfItems(category);
      setState(() {
        shelfItemsRetrieved = shelfItems;
        isLoadingShelfItem = false;
      });
      print("Shelf Items:$shelfItems");
      print ("Category: $categorySelected");
    }
    catch(err){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to fetch shelf items: $err ")
        )
      );
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    getShelfItems("packaged food");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 30.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HeaderSection(
                      itemCount: shelfItemsRetrieved.length,
                      isLoading: isLoadingShelfItem,
                    ),
                    SizedBox(height: 20.0),
                    CategorySelectionSection(
                      getShelfItems: getShelfItems,
                      category: category
                    ),
                    isLoadingShelfItem
                    ?Center(
                      child: Column(
                        children: [
                          Text("Loading shelf items"),
                          SizedBox(height: 5.0,),
                          CircularProgressIndicator(),
                        ], 
                      ),
                    )
                    :shelfItemsRetrieved.isEmpty
                    ?Center(
                      child: Text("No shelf items found"),
                    )
                    :GridView.builder(
                      itemCount: shelfItemsRetrieved.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        childAspectRatio: 200/150,
                        maxCrossAxisExtent: 200,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10
                      ), 
                      itemBuilder: (context,index){
                        final shelfItemRetrieved = shelfItemsRetrieved[index];
                        return ShelfItemCard(
                          context: context,
                          estimatedShelfLife: shelfItemRetrieved["estimated_shelf_life"] ?? 0, 
                          groceryName: shelfItemRetrieved["name"] ?? "", 
                          category: shelfItemRetrieved["category"] ?? "", 
                          quantity: shelfItemRetrieved["quantity"] ?? 0
                        );
                      }
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}


class HeaderSection extends StatefulWidget {
  const HeaderSection(
    {
      super.key,
      required this.itemCount,
      required this.isLoading
    }
  );

  final int itemCount;
  final bool isLoading;

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Header(title: "Shelf" , subtitle: "${widget.isLoading? "0": widget.itemCount} items in stock", isShowBackButton: false),
        GestureDetector(
          onTap: ()async{
            await showFormDialog(
              context: context, 
              child: AddGroceryForm()
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: normalGreen
            ),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
        )
      ],
    )
  );
  }
}




class CategorySelectionSection extends StatefulWidget {
  const CategorySelectionSection(
    {
      super.key,
      required this.getShelfItems,
      required this.category
    }
  );
  final Future<void> Function(String) getShelfItems;
  final String category;

  @override
  State<CategorySelectionSection> createState() => _CategorySelectionSectionState();
}

class _CategorySelectionSectionState extends State<CategorySelectionSection> {
  @override
  Widget build(BuildContext context) {
    List<String> groceryCategory = ["Packaged Food" , "Packaged Beverage" , "Fresh Produce"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
                ...List.generate(
            groceryCategory.length,
            (index){
              final String categoryName = groceryCategory[index];
              return GestureDetector(
                onTap: ()async {
                  await widget.getShelfItems(categoryName.toLowerCase());
                },
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:widget.category == categoryName.toLowerCase() ? normalGreen : lightGreen,
                        borderRadius: BorderRadius.circular(12.0)
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 8 , horizontal: 10),
                        child: Text(
                          categoryName,
                          style: TextStyle(
                            color:widget.category == categoryName.toLowerCase() ? Colors.white : darkGreen,
                            fontSize:15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0)
                  ],
                ),
              );
            }      
          )
        ],
      ),
    );
  }
}
