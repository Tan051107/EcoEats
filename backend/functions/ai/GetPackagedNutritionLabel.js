import { packageTypeMapping } from "./PackageTypeMapping.js";

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

        if(product.nutriments == undefined){
            return{
                success:false,
                message:"No nutrition label",
                data:{}
            }     
        }

        const productNutriments = product.nutriments;
        const calories = productNutriments?.["energy-kcal_100g"] || (productNutriments?.["energy-kj_100g"] / 4.184) || ""
        const packagings = getPackagingMaterial(product.packagings)
        const materials = await packageTypeMapping(packagings)

        return{
            success:true,
            message:"Successfully retrieved nutritional label",
            data:{
                    name:product?.product_name || "",
                    per:"100g",
                    nutrition:{
                        calories_kcal:calories? `${Math.round(calories)}kcal` : "",
                        fat_g:Math.round(productNutriments?.["fat_100g"]) || "",
                        carbs_g:Math.round(productNutriments?.["carbohydrates_100g"]) || "",
                        protein_g:Math.round(productNutriments?.["proteins_100g"]) || "",
                    },
                    packaging_materials:materials.data,
                    category:`packaged ${product?.product_type || ""}`,
                    is_packaged:true
                }
        }
    }
    catch(err){
        throw new Error("Failed to retrieve nutritional label" , {cause:err})
    }
    
}