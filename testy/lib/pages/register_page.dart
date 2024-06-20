import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class Register extends StatefulWidget {
  const Register({super.key});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  _RegisterState();

  bool showProgress = false;
  bool visible = false;

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpassController =
      new TextEditingController();
  final TextEditingController name = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController mobile = new TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;
  var options = [
    'User',
    'Admin',
  ];
  var _currentItemSelected = "User";
  var role = "User";

  Color accentColor = Color.fromARGB(255, 5, 25, 86);
  Color bgColor = Color.fromARGB(255, 52, 81, 161);
  Color textColor = Colors.white;
  Color lightBlueColor = Color.fromARGB(255, 133, 162, 242);
  Color purpleColor = Color.fromARGB(255, 179, 27, 219);

  void goToLoginPage() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://img.freepik.com/free-vector/dark-graphic-wavy-wallpaper_23-2148400270.jpg?size=626&ext=jpg&ga=GA1.1.2116175301.1717804800&semt=ais_user'),
                      fit: BoxFit.cover)),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("Create an account",
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 30),
                          child: Text(
                            "Please fill in your details to start",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: name,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Name',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Name cannot be empty";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: mobile,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Phone',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Phone cannot be empty";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          obscureText: _isObscure,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Password',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return ("please enter valid password min. 6 character");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: _isObscure2,
                          controller: confirmpassController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure2
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Confirm Password',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (confirmpassController.text !=
                                passwordController.text) {
                              return "Password did not match";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "role : ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            DropdownButton<String>(
                              dropdownColor: Colors.blue[900],
                              isDense: true,
                              isExpanded: false,
                              iconEnabledColor: Colors.white,
                              focusColor: Colors.white,
                              items: options.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(
                                    dropDownStringItem,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                setState(() {
                                  _currentItemSelected = newValueSelected!;
                                  role = newValueSelected;
                                });
                              },
                              value: _currentItemSelected,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              elevation: 5.0,
                              height: 40,
                              onPressed: () {
                                setState(() {
                                  showProgress = true;
                                });
                                signUp(emailController.text,
                                    passwordController.text, role);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 125.0, vertical: 15),
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              color: accentColor,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?    ",
                                style: TextStyle(
                                    color: lightBlueColor,
                                    fontWeight: FontWeight.bold)),
                            GestureDetector(
                                onTap: goToLoginPage,
                                child: Text("Login now",
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.bold))),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signUp(String email, String password, String role) async {
    CircularProgressIndicator();
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(email, role)})
          .catchError((e) {});
    }
  }

  postDetailsToFirestore(String email, String role) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
    ref.doc(user!.uid).set({
      'email': emailController.text,
      'role': role,
      'username': emailController.text.split('@')[0],
      'address': 'Not Set',
      'phone': mobile.text,
      'name': name.text,
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}

class ScreenNavigator {
  final BuildContext cx;
  ScreenNavigator({
    required this.cx,
  });
  navigate(Widget page, Tween<Offset> tween) {
    Navigator.push(
      cx,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return page;
        },
        transitionDuration: Durations.long1,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // create CurveTween
          const Curve curve = Curves.easeInOut;
          final CurveTween curveTween = CurveTween(curve: curve);
          // chain Tween with CurveTween
          final Animatable<Offset> chainedTween = tween.chain(curveTween);
          final Animation<Offset> offsetAnimation =
              animation.drive(chainedTween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }
}

class NavigatorTweens {
  static Tween<Offset> bottomToTop() {
    const Offset begin = Offset(0.0, 1.0);
    const Offset end = Offset(0.0, 0.0);
    return Tween(begin: begin, end: end);
  }

  static Tween<Offset> topToBottom() {
    const Offset begin = Offset(0.0, -1.0);
    const Offset end = Offset(0.0, 0.0);
    return Tween(begin: begin, end: end);
  }

  static Tween<Offset> leftToRight() {
    const Offset begin = Offset(-1.0, 0.0);
    const Offset end = Offset(0.0, 0.0);
    return Tween(begin: begin, end: end);
  }

  static Tween<Offset> rightToLeft() {
    const Offset begin = Offset(1.0, 0.0);
    const Offset end = Offset(0.0, 0.0);
    return Tween(begin: begin, end: end);
  }
}
