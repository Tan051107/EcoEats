import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/pages/views/onboarding.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/shrink_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  Login(
    {
      super.key,
      required this.isLogin
    }
  );

  final bool isLogin;

  final AuthService _authService = AuthService();

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late bool _isLogin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLogin = widget.isLogin;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: ()=>{
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context){
                    return Onboarding();
                  })
              )
            }, 
            icon: Icon(
              Icons.arrow_back_outlined,
              size: 30.0,
            )
          )
        ),
        body:Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                Desc(_isLogin),
                SizedBox(height: 18.0),
                LogInWithGoogleButton(authService: widget._authService,),
                SizedBox(height: 18.0),
                OrLine(),
                SizedBox(height: 18.0),
                SignInForm(isLogin: _isLogin),
                SizedBox(height: 18.0),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _isLogin ? "Don't have an account? ": "Already have an account? ",
                        style: subtitleText
                      ),
                      TextSpan(
                        text: _isLogin ? "Sign Up" : "Sign In",
                        style: TextStyle(
                          color: normalGreen,
                          fontSize: subtitleText.fontSize,
                          fontWeight: FontWeight.bold
                        ),
                        recognizer: TapGestureRecognizer()
                        ..onTap = (){
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        }
                      )
                    ]
                  )
                )

              ],
            ),
          ),
        ),
      );
  }
}


Widget Desc(_isLogin){
  return Column(
    children: [
      Text(
        _isLogin ? "Welcome Back!" : "Create Account",
        style: headerText,
      ),
      SizedBox(height: 15.0),
      Text(
        _isLogin ? "Sign in to continue your journey" : "Start your healthy eating journey today",
        style: subtitleText,
      ),
    ],
  );              
}

Widget OrLine(){
  return Row(
    children: [
      Expanded(
        child: Divider(
          thickness: 1,
          color:gray,
        )
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Text("or"),
      ),
      Expanded(
        child: Divider(
          thickness: 1,
          color:gray,
        )
      ),
    ],
  );
}


class LogInWithGoogleButton extends StatelessWidget {
  const LogInWithGoogleButton(
    {
      super.key,
      required this.authService
    }
  );

  final AuthService authService;

  @override
  Widget build(BuildContext context) {

    Future<void>signInWithGoogle()async{
      try{
        final UserCredential userCredential = await authService.signInWithGoogle();
      }
      catch(err){
        print(err);
      }

    }
    return ShrinkButton(
      onPressed: ()=>signInWithGoogle(), 
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: normalGreen,
            width: 2.0
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/google.svg',
                height: 20.0,
                width: 20.0,
              ),
              SizedBox(width: 5.0),
              Text(
                "Continue With Google",
                style: TextStyle(
                  fontSize: subtitleText.fontSize,
                  color: normalGreen,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}



class SignInForm extends StatefulWidget {
  const SignInForm(
    {
      super.key,
      required this.isLogin
    }
  );

  final bool isLogin;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;
  
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email",
                style: TextStyle(
                  fontSize: subtitleText.fontSize,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: darkGreen,
                  ),
                  filled: true, //set to be true for input to have bg color
                  fillColor:lightGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: BorderSide.none
                  )
                ),
                validator:(value) {
                  if(value == null || value.isEmpty){
                    return "Email is required.";
                  }
                  if(!value.contains("@") || !value.contains(".")){
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              )
            ],
          ),
          SizedBox(height: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Password",
                style: TextStyle(
                  fontSize: subtitleText.fontSize,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                obscureText: hidePassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: darkGreen,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(hidePassword ? Icons.visibility_off_outlined : Icons.visibility),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none
                  ),
                  filled: true,
                  fillColor: lightGreen
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return "Password is required.";
                  }
                  if(value.length < 6){
                    return "Password must have minimum of 6 characters.";
                  }
                  return null;
                },
              )
            ],
          ),
          SizedBox(height: 20.0),
          ShrinkButton(
            onPressed: () {
              
            }, 
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: normalGreen
              ),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  textAlign: TextAlign.center,
                  widget.isLogin ? "Create Account" : "Sign In",
                  style: TextStyle(
                    fontSize: subtitleText.fontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}