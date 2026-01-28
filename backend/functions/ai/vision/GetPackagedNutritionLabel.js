
function getPackagingMaterial(packagings){
    if(!Array.isArray(packagings) || !packagings){
        return []
    }
    const materials =  packagings.map(packaging=>packaging.material?.split(":")[1] || packaging.material) 
    
    return [...new Set(materials)];
}

export async function getPackagedNutritionLabel(barcode){
    //use https://world.openfoodfacts.org when deploy
    const url = `https://world.openfoodfacts.net/api/v2/product/${barcode}.json`;

    try{
        const result = await fetch(url)

        if (!result.ok){
            return{
                success:false,
                message: res.statusText,
                data:{}
            }
        }

        const data = await result.json()

        const product = data.product;

        if(product?.no_nutrition_data){
            return{
                success:false,
                message:"No nutrition label",
                data:{}
            }
        }

        const productNutriments = product.nutriments;
        const calories = productNutriments?.["energy-kcal_100g"] || (productNutriments?.["energy-kj_100g"] / 4.184) || ""
        const materials = getPackagingMaterial(product.packagings)

        const output = {
            success: true,
            name: product.product_name,
            per: "100g",
            calories: calories ? `${Math.round(calories)}kcal` : "Not found",
            fat: productNutriments?.["fat_100g"] || "Not found",
            carbs: productNutriments?.["carbohydrates_100g"] || "Not found",
            protein: productNutriments?.["proteins_100g"] || "Not found",
            packagingType: materials,
            productType:product.product_type,
            isPackaged:true
        };

        console.log(JSON.stringify(output, null, 2));

        return{
            success:true,
            message:"Successfully retireved nutritional label",
            data:{
                    name:product.name,
                    per:"100g",
                    calories:calories? `${Math.round(calories)}kcal` : "",
                    fat:productNutriments?.["fat_100g"] || "",
                    carbs:productNutriments?.["carbohydrates_100g"] || "",
                    protein:productNutriments?.["proteins_100g"] || "",
                    packagingType:materials,
                    productType:product.product_type,
                    isPackaged:true
                }
        }
    }
    catch(err){
        return{
            success:false,
            message:err.message,
            data:{}
        }
    }
}