const getDiff = (a, b) => {
  if (!a || a === 0) return 0;
  return Math.abs(a - b) / a;
};

export function getPackagedInfoPendingEdits(newRecordedData ,existingData,pendingEdits){
    console.log("EXISTING DATA")
    console.log(JSON.stringify(existingData, null, 2));
    console.log("NEW DATA")
    console.log(JSON.stringify(newRecordedData, null, 2));
    const{
        name:currentName,
        category:currentCategory,
        nutrition:currentNutrition

    } = existingData

    const{
        name:receivedName,
        category:receivedCategory,
        nutrition:receivedNutrition

    } = newRecordedData

    const nutritionKeys = [
        "calories_kcal",
        "protein_g",
        "fat_g",
        "carbs_g",
    ];

    const difference ={}

    if(currentName.toLowerCase() !== receivedName.toLowerCase()){
        difference.name = receivedName
    }

    if(currentCategory.toLowerCase() !== receivedCategory.toLowerCase() && (receivedCategory == "packaged food" || receivedCategory == "packaged_beverage")){
        difference.category = receivedCategory
    }

    for(const nutritionKey of nutritionKeys){
        const nutritionDifference = getDiff(currentNutrition[nutritionKey],receivedNutrition[nutritionKey])
        if(nutritionDifference > 0.2){
            if (!difference.nutrition) {
            difference.nutrition = {};
        }
            difference.nutrition[nutritionKey] = receivedNutrition[nutritionKey]
        }
    }
    console.log("DIFFERENCE")
    console.log(JSON.stringify(difference, null, 2));

    if (Object.keys(difference).length == 0){
        console.log("No difference with current data")
        return pendingEdits;
    }

    for (const [differenceKey,differenceValue] of Object.entries(difference)){
        let found = false;
        for(const pendingEdit of pendingEdits){
            if (pendingEdit.hasOwnProperty(differenceKey)){
                if(differenceKey == "nutrition"){
                    for (const [nutritionKey,nutritionValue] of Object.entries(difference.nutrition)){
                        if(pendingEdit.nutrition.hasOwnProperty(nutritionKey)){
                           if(getDiff(nutritionValue , pendingEdit.nutrition[nutritionKey]) < 0.2){
                            console.log(`different ${nutritionKey} as current info. Found in pending edits. Add pending edits verified count`)
                            pendingEdit.verified_count++
                            found = true;
                            break;
                           } 
                        }
                    }
                }
                else{
                    if(pendingEdit[differenceKey].toLowerCase() == differenceValue.toLowerCase()){
                        console.log(`different ${differenceKey} as current info. Found in pending edits.Add pending edits verified count`)
                        pendingEdit.verified_count++
                        found = true;
                        break;
                    }
                }
            }
            if(found)break;
        }
        if(!found){
            console.log(`different ${differenceKey} as current info.Not in pending edits.Add pending edits"`)
            pendingEdits.push({
                [differenceKey]:differenceValue,
                verified_count:1
            })
        }
    }

    return pendingEdits;
}