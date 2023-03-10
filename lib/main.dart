import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
//--------------------------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatelessWidget {
  const LoginDemo({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('asset/images/flutter-logo.png')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 300.0, right: 300.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 300.0, right: 300.0, top: 15, bottom: 15),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(

                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            /*FlatButton(
              onPressed: (){
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),*/
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              /*child: FlatButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                },*/
              child: ElevatedButton(
                child: Text('Login'),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => HomeDemo()));
                  }

              ),
            ),
            //),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }

}

//HOME PAGE--------------------------------------------------------------------------------------------

class HomeDemo extends StatelessWidget {
  const HomeDemo({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 400,
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                      color: Colors.black,
                ),
                ),
              ),
            ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 400,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(
                      color: Colors.black,
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

}