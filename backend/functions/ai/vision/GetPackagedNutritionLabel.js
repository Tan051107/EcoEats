
function getPackagingMaterial(packagings){
    if(Array.isArray(packagings) || !packagings){
        return []
    }
    const materials =  packagings.map(packaging=>packaging.material?.split(":")[1] || packaging.material) 
    
    return [...new Set(materials)];
}

export async function getPackagedNutritionLabel(barcode){
    const url = `https://world.openfoodfacts.org/api/v2/product/${barcode}.json`;

    try{
        const result = await fetch(url)

        if (!result.ok){
            return{
                success:false,
                errorType:"HTTP error",
                status: res.status, 
                message: res.statusText
            }
        }

        const data = result.json()

        if(data.status !==1){
            return{
                success:false,
                errorType:"Result not found"
            }
        }


        if(product.no_nutrition_data){
            return{
                success:false,
                errorType:"No nutrition label"
            }
        }

        const product = data.product;
        const productNutriments = product.nutriments;
        const calories = productNutriments?.["energy_kcal_100g"] || (productNutriments?.["energy-kj_100g"] / 4.184) || ""
        const materials = getPackagingMaterial(product.packagings)
        return{
            success:true,
            name:product.name,
            per:"100g",
            calories:calories? `${Math.round(calories)}kcal` : "",
            fat:productNutriments?.["fat_100g"] || "",
            carbs:productNutriments?.["carbohydarates_100g"] || "",
            protein:productNutriments?.["proteins_100g"],
            packagingType:materials
        }
    }
    catch(err){
        return{
            success:false,
            errorType:"Error occurred",
            message:err.message
        }
    }
}