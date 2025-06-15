import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_kita_app/features/event_management/presentation/bloc/update_event/update_event_cubit.dart';
import 'package:flutter/material.dart';

import 'screens/homepage.dart';
import 'features/register/register_screen.dart';
import 'screens/profile_page.dart';
import 'screens/search.dart';
import 'screens/myrsvp_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'features/event_management/event_management.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<EventRepository>(
          create: (context) => EventRepositoryImpl(
            remoteDataSource: EventRemoteDataSourceImpl(
              firestore:
                  FirebaseFirestore.instance,
            ),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MyEventsListCubit>(
            create: (context) {
              final eventRepository = context.read<EventRepository>();
              return MyEventsListCubit(
                getMyEventsUsecase: GetMyEvents(eventRepository),
                deleteEventUsecase: DeleteEvent(eventRepository),
              )..fetchMyEvents();
            },
          ),
          BlocProvider<CreateEventCubit>(
            create: (context) {
              final eventRepository = context.read<EventRepository>();
              return CreateEventCubit(
                createEventUsecase: CreateEvent(eventRepository),
              );
            },
          ),
          BlocProvider<UpdateEventCubit>(
            create: (context) {
              final eventRepository = context.read<EventRepository>();
              return UpdateEventCubit(
                updateEventUsecase: UpdateEvent(eventRepository),
              );
            },
          ),
        ],
        child: MaterialApp(
          title: 'EventKita',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          home: const MyHomePage(),
          routes: {
            'home': (context) => const MyHomePage(),
            'register': (context) => const RegisterScreen(),
            'profile_page': (context) => const ProfilePage(),
            'search': (context) => const SearchPage(),
            'my-rsvp': (context) => const MyRSVPPage(),
            'my-events': (context) => const MyEventsPage(), 
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const MyEventsPage(),
    const ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.event_note), label: 'My Events'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}