import adminModule from '../utils/firebase-admin.cjs';
const admin = adminModule.default ?? adminModule;

const getDiff = (a, b) => {
  if (!a || a === 0) return 0;
  return Math.abs(a - b) / a;
};

export function getPackagedInfoPendingEdits(newRecordedData ,existingData,pendingEdits){
    const{
        item_name:currentName,
        category:currentCategory,
        nutrition:currentNutrition

    } = existingData

    const{
        item_name:receivedName,
        category:receivedCategory,
        nutrition:receivedNutrition

    } = newRecordedData

    const nutritionKeys = [
        "calories_kcal",
        "protein_g",
        "fat_g",
        "carbs_g"
    ];

    const difference ={}

    if(currentName.toLowerCase() !== receivedName.toLowerCase()){
        difference.item_name = receivedName
    }

    if(currentCategory.toLowerCase() !== receivedCategory.toLowerCase() && (receivedCategory == "packaged food" || receivedCategory == "packaged_beverage")){
        difference.category = receivedCategory
    }

    for(const nutritionKey of nutritionKeys){
        const nutritionDifference = getDiff(currentNutrition[nutritionKey],receivedNutrition[nutritionKey])
        if(nutritionDifference > 0.2){
            difference.nutrition[nutritionKey] = receivedNutrition[nutritionKey]
        }
    }

    for (const pendingEdit of pendingEdits){
        if(difference.hasOwnProperty("item_name") && pendingEdit.hasOwnProperty("item_name")){
            if (pendingEdit.item_name.toLowerCase() === difference.item_name.toLowerCase()){
                pendingEdit.verified_count++;
            }
            else{
                pendingEdits.push({
                    item_name:difference.item_name,
                    verified_count:1,
                })
            }
        }
        if(difference.hasOwnProperty("category") && pendingEdit.hasOwnProperty("category")){
            if (pendingEdit.category.toLowerCase() === difference.category.toLowerCase()){
                pendingEdit.verified_count++;
            }
            else{
                pendingEdits.push({
                    category:difference.category,
                    verified_count:1
                })
            }
        }

        if(difference.hasOwnProperty("nutrition") && pendingEdit.hasOwnProperty("nutrition")){
            for (const [nutritionKey ,nutritionValue] of Object.entries(difference.nutrition)){
                if(pendingEdit.nutrition.hasOwnProperty(nutritionKey)){
                    if(getDiff(pendingEdit.nutrition[nutritionKey] , nutritionValue) < 0.2){
                        pendingEdit.verified_count++;
                    }
                }
                else{
                    pendingEdits.push({
                        nutrition:{
                            [nutritionKey]:nutritionValue
                        } 
                    })
                }
            }
        }
    }

    return pendingEdits;
}