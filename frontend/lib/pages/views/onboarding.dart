import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/pages/views/login.dart';
import 'package:frontend/widgets/shrink_button.dart';


class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF0FAF4),
                Color(0xFFFCFBF7),
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 130.0),
              IconAnimation(),
              SizedBox(height: 15.0),
              Text(
                "EcoEats",
                style:TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                "Your AI-powered companion for healthier eating and zero food waste",
                style:TextStyle(
                  fontSize: headingTwoText.fontSize,
                  color: subtitleText.color
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.0),
              FeaturesSection(),
              SizedBox(height: 15.0),
              ShrinkButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context){
                        return Login(isLogin: true);
                      }
                    )
                  )
                }, 
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  decoration: BoxDecoration(
                    color:normalGreen,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: headingTwoText.fontSize,
                          fontWeight: FontWeight.bold,
                          color:Colors.white
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_outlined,
                        color: Colors.white,
                        size: 28.0,
                      )
                    ],
                  )
                ),
              )        
            ],
          ),
          ),
        ),
      ),
    );
  }
}

class IconAnimation extends StatefulWidget {
  const IconAnimation({super.key});

  @override
  State<IconAnimation> createState() => _IconAnimationState();
}

class _IconAnimationState extends State<IconAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation _animation;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0 , end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation, 
      builder: (context,child){
        return Transform.translate(
          offset: Offset(0, -_animation.value),
          child: child,
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: normalGreen,
          borderRadius: BorderRadius.circular(30.0)
        ),
        child: Icon(
          Icons.eco_outlined,
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}

Widget _FeatureCard(String feature , String svgUrl){
  return Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0)
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgUrl,
            width: 25.0,
            height: 25.0,
          ),
          SizedBox(width: 5.0),
          Text(
            feature,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    ),
  );
}


class FeaturesSection extends StatelessWidget {
  FeaturesSection({super.key});

  final List<Map<String,dynamic>> features = [
    {
      "name":"Scan groceries",
      "iconUrl": 'assets/icons/camera.svg'
    },
    {
      "name":"Track nutrition",
      "iconUrl" :'assets/icons/salad.svg'
    },
    {
      "name":"Weekly insights",
      "iconUrl" :'assets/icons/bar-chart.svg'
    },
    {
      "name":"Expiry alerts",
      "iconUrl" :'assets/icons/alarm.svg'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      childAspectRatio: 3,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap:true,
      children:List.generate(
        features.length, 
        (index){
          final feature = features[index];
          return _FeatureCard(feature["name"], feature["iconUrl"]);
        }
      )
    );
  }
}


