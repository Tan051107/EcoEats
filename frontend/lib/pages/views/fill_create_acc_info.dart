import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/fcm_service.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/icon_subtitle.dart';
import 'package:frontend/widgets/int_text_field.dart';
import 'package:frontend/widgets/multi_select_icon_subtitle.dart';
import 'package:frontend/widgets/decimal_text_field.dart';
import 'package:frontend/widgets/radio_card_selector.dart';
import 'package:frontend/widgets/shrink_button.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FillCreateAccInfo extends StatefulWidget {
  const FillCreateAccInfo({super.key});

  @override
  State<FillCreateAccInfo> createState() => _FillCreateAccInfoState();
}

class _FillCreateAccInfoState extends State<FillCreateAccInfo> {
  final List<Map<String,String>> headerTexts =[
    {
      "title":"Tell us about yourself",
      "subtitle":"This helps us calculate your daily needs"
    },
    {
      "title":"What's your goal?",
      "subtitle":"We'll personalize your experience"
    },
    {
      "title":"Diet preferences",
      "subtitle":"Help us recommend the right recipes"
    }
  ];

  int currentProgress = 0;
  String genderSelected = "";
  String activityLevelSelected = "";
  String goalSelected = "";
  String dietTypeSelected = "";
  List<String> allergiesSelected = [];
  bool isButtonEnabled = false;
  Map<String,String> get currentHeader => headerTexts[currentProgress];

  final AuthService authService = AuthService();
  final FcmService fcmService = FcmService();
  String get userName => authService.currentUser?.displayName ?? "";
  String get email => authService.currentUser?.email ?? "";

  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final otherAllergiesController = TextEditingController();
  late TextEditingController nameController = TextEditingController(text: userName);

  List<Widget> get fillUpPages => [
    FirstFillUpSection(
      activityLevelSelected: activityLevelSelected,
      setActivityLevel: setActivityLevel,
      genderSelected: genderSelected,
      setGender: setGender,
      ageController: ageController,
      heightController: heightController,
      weightController: weightController,
      nameController: nameController
    ),
    SecondFillUpSection(
      goalSelected: goalSelected,
      setGoal: setGoal,
    ),
    ThirdFillUpSection(
      dietTypeSelected: dietTypeSelected,
      setDietTypeSelected: setDietType,
      allergiesSelected: allergiesSelected,
      setAllergiesSelected: setAllergiesSelected,
      otherAllergiesController:otherAllergiesController,
    ),
  ];

  @override
  void initState() {
    super.initState();
    ageController.addListener(updateButtonState);
    heightController.addListener(updateButtonState);
    weightController.addListener(updateButtonState);
    otherAllergiesController.addListener(updateButtonState);
    nameController.addListener(updateButtonState);
    updateButtonState();
  }

  @override
  void dispose() {
    ageController.removeListener(updateButtonState);
    heightController.removeListener(updateButtonState);
    weightController.removeListener(updateButtonState);
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    otherAllergiesController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void setActivityLevel(String activityLevelLabel){
    if (activityLevelSelected != activityLevelLabel) {
      setState(() {
        activityLevelSelected = activityLevelLabel;
      });
      updateButtonState();
    }
  }

  void setGender(String genderLabel){
    if (genderSelected != genderLabel) {
      setState(() {
        genderSelected = genderLabel;
      });
      updateButtonState();
    }
  }

  void setGoal(String goalLabel){
    if (goalSelected != goalLabel) {
      setState(() {
        goalSelected = goalLabel;
      });
      updateButtonState();
    }
  }

  void setDietType(String dietTypeLabel){
    if (dietTypeSelected != dietTypeLabel) {
      setState(() {
        dietTypeSelected = dietTypeLabel;
      });
      updateButtonState();
    }
  }

  void setAllergiesSelected(String allergyLabel){
    if(!allergiesSelected.contains(allergyLabel)){
      setState(() {
        allergiesSelected.add(allergyLabel);
      });
    }
    else{
      setState(() {
        allergiesSelected.remove(allergyLabel);
      });
    }
    updateButtonState();
  }

  void updateButtonState(){
    bool shouldBeEnabled = false;
    if (currentProgress == 0) {
      shouldBeEnabled = ageController.text.isNotEmpty
                        &&nameController.text.isNotEmpty
                        && heightController.text.isNotEmpty
                        && weightController.text.isNotEmpty
                        && genderSelected.isNotEmpty
                        && activityLevelSelected.isNotEmpty;
    } else if (currentProgress == 1) {
      shouldBeEnabled = goalSelected.isNotEmpty;
    } else if (currentProgress == 2) {
      if(allergiesSelected.contains("Others")){
        shouldBeEnabled = otherAllergiesController.text.isNotEmpty && dietTypeSelected.isNotEmpty;
      }
      else{
        shouldBeEnabled = dietTypeSelected.isNotEmpty;
      }
    }

    if (isButtonEnabled != shouldBeEnabled) {
      setState(() {
        isButtonEnabled = shouldBeEnabled;
      });
    }
  }

  void onButtonClicked(){
    if (currentProgress < fillUpPages.length - 1) {
      setState(() {
        currentProgress++;
      });
      updateButtonState();
    } else {
      onSubmit();
      FcmService.setFcmToken();
    }
  }

  void onBackButtonClicked() async {
    if(currentProgress == 0){
      // Sign out the user so AuthWrapper can properly rebuild when they log in again
      await authService.signOut();
      // AuthWrapper will automatically rebuild and show Onboarding when user is null
      return;
    }
    if (currentProgress > 0) {
      setState(() {
        currentProgress--;
      });
      updateButtonState();
    } else {
      selectedPageNotifier.value = 0;
    }
  }

  void onSubmit()async{

    Map<String,String> activityLevelMap ={
      "Sedentary" :"sedentary",
      "Light" : "light",
      "Moderate" : "moderate",
      "Active": "active",
      "Very Active": "very_active"
    };

    Map<String,String> gaolMap ={
      "Lose Weight" :"lose_weight",
      "Gain Weight" : "gain_weight",
      "Maintain Weight" : "maintain_weight",
      "Eat Healthier": "eat_healthier"
    };

    if(allergiesSelected.contains("Others")){
      List <String> otherAllergies = otherAllergiesController.text.split(",");
      allergiesSelected.remove("Others");
      allergiesSelected = {...allergiesSelected, ...otherAllergies}.toList();
    }
    Map<String,dynamic> userInfo ={
      "name":nameController.text.trim(),
      "email":email,
      "gender":genderSelected.toLowerCase(),
      "age":int.tryParse(ageController.text) ?? 1,
      "height":double.tryParse(heightController.text.trim()) ?? 0.0,
      "weight":double.tryParse(weightController.text.trim()) ?? 0.0,
      "activity_level":activityLevelMap[activityLevelSelected],
      "diet_type":dietTypeSelected,
      "allergies":allergiesSelected,
      "goal":gaolMap[goalSelected]
    };

    print(userInfo);

    final functions = FirebaseFunctions.instanceFor(region: "us-central1");
    final updateUserProfile = functions.httpsCallable("updateUserProfile");
    try{
      await updateUserProfile.call(userInfo);
    }
    on FirebaseFunctionsException catch(err){
      print("Failed to create new user info doc $err");
    }
    catch(err){
      print("Failed to create new user info doc $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed:() => onBackButtonClicked(),
          icon: const Icon(
            Icons.arrow_back,
            size: 30.0
          ),
        ),
        title: ProgressBar(headerTexts.length, currentProgress),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Header(title: currentHeader["title"]!, isShowBackButton: false , subtitle: currentHeader["subtitle"]!),
          const SizedBox(height: 15.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    fillUpPages[currentProgress],
                    const SizedBox(height: 20.0),
                    ShrinkButton(
                      onPressed: ()=>isButtonEnabled ? onButtonClicked() : null,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: isButtonEnabled ? normalGreen : normalGreen.withValues(alpha: 0.5)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentProgress == 2 ? "Complete Setup" : "Continue",
                                style: TextStyle(
                                  fontSize: subtitleText.fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              )
                            ],
                          ),
                        )
                      )
                    )
                  ],
                )
              ),
            ),
          ),
        ],
      )
    );
  }
}


Widget ProgressBar(int totalSteps , int currentProgress){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children:List.generate(
      totalSteps,
      (index){
        bool isActive = index <= currentProgress;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 30,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? normalGreen : gray,
            borderRadius: BorderRadius.circular(3)
          ),
        );
      }
    )
  );
}


Widget FirstFillUpSection({
  required final ValueChanged<String> setGender,
  required final ValueChanged<String> setActivityLevel,
  required final String genderSelected,
  required final String activityLevelSelected,
  required final TextEditingController ageController,
  required final TextEditingController heightController,
  required final TextEditingController weightController,
  required final TextEditingController nameController
}) {
  final List<Map<String,dynamic>> genders = [
    {
      "gender":"Male",
      "icon":Icons.male,
      "iconColor":const Color(0xFF2196F3)
    },
    {
      "gender":"Female",
      "icon":Icons.female,
      "iconColor":const Color(0xFFE91E63)
    }
  ];

  final List<Map<String,dynamic>> activityLevels = [
    {'label': 'Sedentary', 'subtitle': 'Little or no exercise'},
    {'label': 'Light', 'subtitle': '1-3 days/week'},
    {'label': 'Moderate', 'subtitle': '3-5 days/week'},
    {'label': 'Active', 'subtitle': '6-7 days/week'},
    {'label': 'Very Active', 'subtitle': 'Hard exercise daily'},
  ];

  final formKey = GlobalKey<FormState>();

  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name",
          style: subtitleText,
        ),
        SizedBox(height: 10),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: lightGreen,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: normalGreen,
                width: 2.0
              )
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Gender",
          style: subtitleText,
        ),
        const SizedBox(height:10.0),
        Row(
          children: [
            ...List.generate(
              genders.length,
              (index){
                final gender = genders[index];
                return Expanded(
                  child:Row(
                  children: [
                    GestureDetector(
                      onTap: ()=>setGender(gender["gender"]),
                      child:IconSubtitle(
                        icon:gender["icon"] ,
                        name: gender["gender"],
                        iconColor: gender["iconColor"],
                        activeCard: genderSelected,
                      ),
                    ),
                  ],
                )
                );
              }
            )
          ]
        ),
        const SizedBox(height:20.0),
        Form(
          key:formKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: IntTextField(controller: ageController, label: "Age", unit: "years"),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: DecimalTextField(controller: heightController, label: "Height", unit: "cm"),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: DecimalTextField(controller:weightController, label: "Weight", unit: "kg"),
              ),
            ],
          )
        ),
        const SizedBox(height:20.0),
        Text(
          "Activity Level",
          style: subtitleText,
        ),
        const SizedBox(height: 10.0),
        Column(
          children: [
            ...List.generate(activityLevels.length, (index){
              final activityLevel = activityLevels[index];
              return Column(
                children: [
                  GestureDetector(
                    onTap: ()=>setActivityLevel(activityLevel["label"]),
                    child: RadioCardSelector(
                      label:activityLevel["label"] ,
                      subtitle: activityLevel["subtitle"],
                      activeCard: activityLevelSelected,
                    ),
                  ),
                  const SizedBox(height: 5.0)
                ],
              );
            })
          ],
        )
      ],
    );
}


Widget SecondFillUpSection({
  required String goalSelected,
  required ValueChanged<String> setGoal
}){

  List<Map<String,String>> goals = [
    {
      "label": "Lose Weight",
      "subtitle":"Burn more than you consume"
    },
    {
      "label": "Gain Weight",
      "subtitle":"Build muscle and mass"
    },
    {
      "label": "Maintain Weight",
      "subtitle":"Keep your current weight"
    },
    {
      "label": "Eat Healthier",
      "subtitle":"Improve overall nutrition"
    }
  ];

  return Column(
      children: [
        ...List.generate(
          goals.length,
          (index){
            final Map<String,String> goal = goals[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: GestureDetector(
                onTap: ()=>setGoal(goal["label"]!),
                child: RadioCardSelector(
                label: goal["label"]!,
                subtitle: goal["subtitle"]!,
                activeCard: goalSelected,
              ),
              )
            );
          }
        )
      ],
    );
}

Widget ThirdFillUpSection({
  required final String dietTypeSelected,
  required final ValueChanged<String> setDietTypeSelected,
  required final List<String> allergiesSelected,
  required final ValueChanged<String> setAllergiesSelected,
  required final TextEditingController otherAllergiesController
  })
  {

  final List<Map<String,dynamic>> dietTypes = [
    {
      "label":"Vegetarian",
      "icon":Icons.eco
    },
    {
      "label":"Non-vegetarian",
      "icon":Icons.food_bank
    },
    {
      "label":"Vegan",
      "icon":Icons.nature
    }
  ];


  final List<Map<String,dynamic>> allergicTypes =[
    {
      "icon":"assets/icons/nut.svg",
      "name": "Nuts",
    },
    {
      "icon":"assets/icons/milk.svg",
      "name": "Dairy",
    },
    {
      "icon":"assets/icons/seafood.svg",
      "name": "Seafood",
    },
    {
      "icon":"assets/icons/wheat-with-color.svg",
      "name": "Gluten",
    },
    {
      "icon":"assets/icons/egg.svg",
      "name": "Eggs",
    },
    {
      "icon":"assets/icons/red-bean.svg",
      "name": "Soy",
    },
    {
      "icon":"assets/icons/pencil.svg",
      "name": "Others",
    }
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Diet Type",
        style: subtitleText,
      ),
      const SizedBox(height: 10.0),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(dietTypes.length, (index) {
            final dietType = dietTypes[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0), // spacing between cards
              child: GestureDetector(
                onTap: () => setDietTypeSelected(dietType["label"]),
                child: IconSubtitle(
                  icon: dietType["icon"],
                  name: dietType["label"],
                  iconColor: gray,
                  activeCard: dietTypeSelected,
                ),
              ),
            );
          }),
        ),
      ),
      const SizedBox(height: 20.0),
      Text(
        "Any Allergies?",
        style: subtitleText,
      ),
      const SizedBox(height: 10.0),
      Text(
        "Select all that apply (optional)",
        style: smallText,
      ),
      const SizedBox(height: 10.0),
      Center(
        child: Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: List.generate(
            allergicTypes.length,
            (index) {
              final allergyType = allergicTypes[index];
              return GestureDetector(
                onTap: () => setAllergiesSelected(allergyType["name"]),
                child: MultiSelectIconSubtitle(
                  icon: allergyType["icon"],
                  name: allergyType["name"],
                  activeCards: allergiesSelected,
                ),
              );
            },
          ),
        ),
      ),
      const SizedBox(height: 10.0),
      if(allergiesSelected.contains("Others"))...[
        const SizedBox(height: 10.0),
        Text(
          "Others (Separate allergies with ',')",
          style: subtitleText,
        ),
        SizedBox(height:10.0),
        TextField(
          controller: otherAllergiesController,
          decoration: InputDecoration(
            hintText: "Specify your allergies",
            filled: true,
            fillColor: lightGreen,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: normalGreen,
                width: 2.0
              )
            ),
          ),
        )
      ]
    ],
  );
}
