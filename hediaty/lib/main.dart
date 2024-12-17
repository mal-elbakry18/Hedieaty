import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


//TO DO :
// Implement the routing
// Import all the screens
// Start tests to test the flow


/*void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
runApp(Hediety());}

class Hediety extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/signUp',
      routes: {
        '/': (context) => const Splash_Front(),
        '/login': (context) => LoginScreen(),
        '/signUp': (context) => SignupScreen(),
        '/home':(context) => HomeScreen(),
        //'/Login': (context) => LoginPage(),
        //'/Events': (context) => EventsPage(),

      },
    );
  }
}*/

import 'package:provider/provider.dart';
import '../model/firebase/auth_services.dart'; // Import AuthService
import '../view/screens/loginScreen.dart';
import '../view/screens/signUpScreen.dart';
import '../view/screens/homeScreen.dart';
import '../view/screens/splashScreen.dart';
import '../view/screens/notification_screen.dart';
import '../view/screens/create_event.dart';
import '../view/screens/events.dart';
import '../view/screens/add_friend.dart';
import '../view/screens/friend_list.dart';
import 'view/screens/event_details.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await NotificationService.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        title: 'Hedieaty',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.orange),
        initialRoute: '/',
        routes: {
          '/': (context) => const Splash_Front(),
          //Login and Sign Up Routing
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          //Home Routing
          '/home': (context) => const HomeScreen(),
          //Notification Routing
          '/notifications': (context) => const NotificationScreen(),
          //Event Routing
          '/createEvent': (context) => const CreateEventScreen(),
          '/events': (context) => const EventsPage(),
          '/eventDetails': (context) {
            final eventId = ModalRoute
                .of(context)
                ?.settings
                .arguments as String;
            return EventDetailsPage(eventId: eventId);
          },
          //Friend Routing
          '/friends': (context) => FriendsListScreen(),
          '/addFriend': (context) => AddFriendScreen(),

        }
      ),
    );
  }
}



