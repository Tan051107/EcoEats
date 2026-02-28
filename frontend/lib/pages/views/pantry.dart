import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/providers/grocery_provider.dart';
import 'package:frontend/widgets/add_grocery_form.dart';
import 'package:frontend/widgets/form_dialog.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/shelf_item_card.dart';
import 'package:frontend/widgets/shelf_item_details.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final GroceryProvider groceryProvider = context.watch<GroceryProvider>();
    final List<Map<String,dynamic>> shelfItemsRetrieved = groceryProvider.groceries;
    final int totalShelfItems = shelfItemsRetrieved.length; 
    bool isLoadingShelfItem = groceryProvider.isLoading;
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
                      itemCount: totalShelfItems,
                      isLoading: isLoadingShelfItem,
                    ),
                    SizedBox(height: 20.0),
                    CategorySelectionSection(),
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
                        childAspectRatio: 200/170,
                        maxCrossAxisExtent: 200,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10
                      ), 
                      itemBuilder: (context,index){
                        final Map<String,dynamic>shelfItemRetrieved = shelfItemsRetrieved[index];
                        final List<String> images = (shelfItemRetrieved["image_urls"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
                        return GestureDetector(
                          onTap: () async{
                            await showFormDialog(
                              context: context, 
                              child: ShelfItemDetails(groceryDetails: shelfItemRetrieved)
                            );
                          },
                          child: ShelfItemCard(
                            context: context,
                            estimatedShelfLife: shelfItemRetrieved["estimated_shelf_life"] ?? 0, 
                            groceryName: shelfItemRetrieved["name"] ?? "", 
                            category: shelfItemRetrieved["category"] ?? "", 
                            quantity: shelfItemRetrieved["quantity"] ?? 0,
                            image: images.isNotEmpty ? images[0] : "",
                            unit: shelfItemRetrieved["unit"] ?? ""
                        )
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
    }
  );

  @override
  State<CategorySelectionSection> createState() => _CategorySelectionSectionState();
}

class _CategorySelectionSectionState extends State<CategorySelectionSection> {

  @override
  Widget build(BuildContext context) {
    final GroceryProvider groceryProvider = context.watch<GroceryProvider>();
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
                  groceryProvider.setCategorySelected(categoryName.toLowerCase());
                },
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:groceryProvider.categorySelected == categoryName.toLowerCase() ? normalGreen : lightGreen,
                        borderRadius: BorderRadius.circular(12.0)
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 8 , horizontal: 10),
                        child: Text(
                          categoryName,
                          style: TextStyle(
                            color:groceryProvider.categorySelected == categoryName.toLowerCase() ? Colors.white : darkGreen,
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
