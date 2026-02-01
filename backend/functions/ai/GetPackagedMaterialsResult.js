export function getPackagedMaterialsResult(AIFoundPackagingMaterials , nutritionalAPIFoundPackagingMaterials){
    if(Array.isArray(AIFoundPackagingMaterials) && AIFoundPackagingMaterials.length > 0){
        return AIFoundPackagingMaterials;
    }
    else if(Array.isArray(nutritionalAPIFoundPackagingMaterials) && nutritionalAPIFoundPackagingMaterials.length > 0){
        return nutritionalAPIFoundPackagingMaterials
    }
    else{
        return []
    }
}