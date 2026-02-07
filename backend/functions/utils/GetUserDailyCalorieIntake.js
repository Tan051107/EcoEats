
export function getUserDailyCalorieIntake(activityLevel,goal,bmr){
    let activityLevelFactor = 1.2;
    let calorieIntakePercentage = 1

    switch(activityLevel){
        case "sedentary":
            activityLevelFactor = 1.2;
            break;
        case "light":
            activityLevelFactor = 1.375;
            break;
        case"moderate":
            activityLevelFactor = 1.55;
            break;
        case "active":
            activityLevelFactor = 1.725;
            break;
        case "very_active":
            activityLevelFactor = 1.9;
            break;
        default:
            activityLevelFactor = 1.2;
            break;
    }

    switch(goal){
        case "lose_weight":
            calorieIntakePercentage = 0.85
            break;
        case "gain_weight":
            calorieIntakePercentage = 1.15
            break;
        case "maintain_weight":
        case "eat_healthier":
            calorieIntakePercentage = 1
            break;
        default:
            calorieIntakePercentage = 1
            break;
    }

    const dailyCalorieIntake = bmr*activityLevelFactor*calorieIntakePercentage;

    return dailyCalorieIntake;
}