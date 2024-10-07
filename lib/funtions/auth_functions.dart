import 'package:firebase_auth/firebase_auth.dart';

signUp(String email,String password)async{
        try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "ervin@example,com" ,password: "Password"
      );
      } 
      on FirebaseAuthException catch (e) {
      if (e.code =='weak-password') {
      print( 'The password provided is too weak.');
      } else if (e.code == 'email—already in use'){
        print( 'The account already exists for that email.');
      }
    } 
      catch (e) {
      print (e);
      }
}


