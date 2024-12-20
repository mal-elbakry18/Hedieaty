import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';




import 'package:provider/provider.dart';
import '../model/firebase/auth_services.dart'; // Import AuthService
import '../view/screens/loginScreen.dart';
import '../view/screens/signUpScreen.dart';
import '../view/screens/homeScreen.dart';
import '../view/screens/splashScreen.dart';
import '../view/screens/notification_page.dart';
import '../view/screens/create_event.dart';
import '../view/screens/events.dart';
import '../view/screens/add_friend.dart';
import '../view/screens/friend_list.dart';
import 'view/screens/event_details.dart';
import '/../view/screens/all_gift.dart';
import '/../view/screens/add_gift.dart';
import '../../view/screens/profile.dart';
import '../../view/screens/edit_event.dart';
import '../../view/screens/edit_gift.dart';
import '../../view/screens/gift_detail.dart';
import '../../view/screens/pledgedGifts.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

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
          //Profile
          '/profile': (context)=> const ProfileScreen(),
          //Notification Routing
         //
          '/notifications': (context) =>  NotificationPage(),
          //Event Routing
          '/createEvent': (context) => CreateEventScreen(),
          '/events': (context) => const EventsPage(),
          '/eventDetails': (context) {
            final eventId = ModalRoute
                .of(context)
                ?.settings
                .arguments as String;
            return EventDetailsPage(eventId: eventId);
          },
          '/editEvent': (context) {
            final event = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
            return EditEventScreen(event: event);
          },
          //Friends
          '/friends': (context) => FriendsListScreen(),
          '/addFriend': (context) => AddFriendScreen(),
          //Gift
          '/giftScreen':(context)=> GiftScreen(),
          '/addGift':(context)=> AddGiftScreen(),
          '/editGift': (context) {
            final gift = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
            return EditGiftScreen(gift: gift);
          },
          '/giftDetails': (context) {
            final gift = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
            return GiftDetailsScreen(gift: gift);
          },
          '/pledgedGifts': (context) => const PledgedGiftsScreen(),




        }
      ),
    );
  }
}



