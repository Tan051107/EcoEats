
export function getUserDailyCalorieIntake(activityLevel,goal,bmr){
    let activityLevel = 1.2;
    let calorieIntakePercentage = 1

    switch(activityLevel){
        case "sedentary":
            activityLevel = 1.2;
            break;
        case "light":
            activityLevel = 1.375;
            break;
        case"moderate":
            activityLevel = 1.55;
            break;
        case "active":
            activityLevel = 1.725;
            break;
        case "very_active":
            activityLevel = 1.9;
            break;
        default:
            activityLevel = 1.2;
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
            calorieIntakePercentage = 1
            break;
        case "eat_healthier":
            calorieIntakePercentage = 1
            break;
        default:
            calorieIntakePercentage = 1
            break;
    }

    const dailyCalorieIntake = bmr*activityLevel*calorieIntakePercentage;

    return dailyCalorieIntake;
}