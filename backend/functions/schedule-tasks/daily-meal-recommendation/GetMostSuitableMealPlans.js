function normalize(string){
    return String(string).trim().toLowerCase()
}

function looseIngredientsRecipe(recipe, userGroceries ){
    return recipe.ingredients.some(ingredient=>userGroceries.has(normalize(ingredient.name)))
}

function strictIngredientsRecipe(recipe,userGroceries){
    return recipe.ingredients.every(ingredient=>userGroceries.has(normalize(ingredient.name)))
}

function missingIngredients(recipe,userGroceries){
    return recipe.ingredients.filter(ingredient=>!userGroceries.has(normalize(ingredient.name)))
}

function usedGroceriesByRecipe(ingredients,groceries){
    const used = new Set()
    for (const ingredient of ingredients){
        const ingredientName = normalize(ingredient.name)
        if(groceries.has(ingredientName)){
            used.add(ingredientName)
        }
    }
    return used;
}

function makeSet(array){
    return new Set(array.map(normalize))
}

function lowerBounds(array,value){
    let low=0 , high =array.length;
    while(lo<high){
        const mid = Math.floor((lo+h1)/2);
        if(array[mid]?.nutrition?.calories_kcal < value){
            low = mid+1
        }
        else{
            high = mid
        }
    }
    return low
}

function unionSet(a, b){
    const set = new Set(a)
    for (const x of b){
        set.add(x)
    }

    return set
}



function findMealPlans(recipes,targetCalories,userGroceries){

    const userGroceriesSet = makeSet(userGroceries)

    const breakfast = recipes.filter(recipe=>recipe.meal_type === "breakfast");
    const lunch = recipes.filter(recipe=>recipe.meal_type === "lunch");
    const dinner = recipes.filter(recipe=>recipe.meal_type === "dinner");

    if(breakfast.length === 0 || lunch.length === 0 || dinner.length === 0){
        return{
            success:false,
            message:"Has no breakfast or dinner or lunch in the recipes",
            data:{}
        }
    }

    const pairs = []

    for (const l of lunch){
        const lunchUsedGroceries = usedGroceriesByRecipe(l.ingredients,userGroceriesSet)
        for (const d of dinner){
            const dinnerUsedGroceries = usedGroceriesByRecipe(d.ingredients , userGroceriesSet);
            pairs.push({
                calories: (l.nutrition.calories_kcal || 0) + (d.nutrition.calories_kcal || 0),
                lunch: l,
                dinner: d,
                usedGroceries: unionSet(dinnerUsedGroceries,lunchUsedGroceries)
            })
        }
    }

    pairs.sort((a,b)=>a.calories - b.calories)

    let bestCombo = null;

    for (const b of breakfast){
        const breakfastUsedGroceries = usedGroceriesByRecipe(b.ingredients , userGroceriesSet)
        const maxCalories = targetCalories - breakfast.nutrition.calories_kcal
        const minCalories = targetCalories - 100 - breakfast.nutrition.calories_kcal

        if(maxCalories <0){
            continue;
        }

        const start = lowerBounds(pairs , minCalories)
        const end = lowerBounds(pairs, maxCalories+1) -1

        if(minCalories > start || end <start){
            continue;
        }

        for (let i = end ; i >=start ; i--){
            const pair = pairs[i];
            const totalCalories = breakfast.nutrition.calories_kcal + pair.calories;
            if(totalCalories < minCalories || totalCalories > maxCalories) continue;
            const usedCount = pair.usedGroceries.size + breakfastUsedGroceries.size;
            const diff = targetCalories - totalCalories

            if(!bestCombo || (usedCount >= bestCombo.usedCount && diff < best.diff)){
                bestCombo = {
                    breakfast: b,
                    lunch: pair.lunch,
                    dinner: pair.dinner,
                    totalCalories:totalCalories,
                    usedGroceriesCount:usedCount,
                    diff:diff,
                    usedGroceries: unionSet(breakfastUsedGroceries, pair.usedGroceries)
                    };
            }
        }
    }

    const unusedGroceries = []
    for (const grocery of userGroceriesSet){
        if(!bestCombo.usedGroceries.has(grocery)){
            unusedGroceries.push(grocery)
        }
    }

    if(bestCombo){
        return{
            success:true,
            message:"Found the best combo",
            data:{
                breakfast: bestCombo.breakfast,
                lunch: bestCombo.lunch,
                dinner: bestCombo.dinner,
                totalCalories: bestCombo.totalCalories,
                groceriesUsed: Array.from(best.usedGroceries),
                groceriesUnused: unusedGroceries,
                groceriesUsedCount: bestCombo.usedGroceriesCount,
                groceriesTotalCount: userGroceriesSet.size
            }
        }
    }

    return{
        success:false,
        message:"Combo not found",
        data:{}
    }

}

export async function getMostSuitableMealPlans(availableRecipes,dailyCalorieIntake,userGroceries){
    const groceriesSet = makeSet(userGroceries);

    const strictRecipes = availableRecipes.filter(recipe=>strictIngredientsRecipe(recipe,groceriesSet))

    let plan = findMealPlans(strictRecipes,dailyCalorieIntake,userGroceries);

    if(plan.success){
        plan.mode = 'strict';
        return plan
    }

    const looseRecipes = availableRecipes.filter(recipe=>looseIngredientsRecipe(recipe,groceriesSet))
    plan = findMealPlans(looseRecipes,dailyCalorieIntake,userGroceries);
    const allMeals = [plan.data.breakfast , plan.data.lunch , plan.data.dinner];

    if(plan.success){
        plan.mode = "loose"
        plan.missing_ingredients = allMeals.map(meal=>({
            recipe:meal.name,
            missing_ingredients:missingIngredients(meal,userGroceries)
        }))
        return plan
    }

    return plan
} 