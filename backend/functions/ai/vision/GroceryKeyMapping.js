
export function groceryKeyMapping(visionResults , packagedKeys , freshKeys){
    for (const visionResult of visionResults){
        const keyword = visionResult.toLowerCase();

        for (const[fruit,fruitSimilarKeys] of Object.entries(freshKeys.fruits)){
            if(fruitSimilarKeys.some(key=>key.toLowerCase() === keyword)){
                return{
                    found:true,
                    itemName:fruit,
                    category:"fruit",
                    isPackaged:false
                }
            }
        }

        for (const[vege,vegeSimilarKeys] of Object.entries(freshKeys.veges)){
            if(vegeSimilarKeys.some(key=>key.toLowerCase() === keyword)){
                return{
                    found:true,
                    itemName:vege,
                    category:"vege",
                    isPackaged:false
                }
            }
        }

        if(packagedKeys.logos.some(logo=>logo.toLowerCase() === keyword)){
            return {
                found:true,
                itemName:keyword,
                category:'packaged',
                packagingType:'unknown',
                isPackaged:true
            }
        }

        for (const[packagingType,packagingTypeSimilarKeys] of Object.entries(packagedKeys.packagingType)){
            if(packagingTypeSimilarKeys.some(key=>key.toLowerCase() === keyword)){
                return{
                    found:true,
                    itemName:packagingType,
                    category:'packaged',
                    packagingType:packagingType,
                    isPackaged:true,
                }
            }
        }
    }

    return{found:false};
}
