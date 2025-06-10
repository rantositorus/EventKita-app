import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_kita_app/features/event_management/presentation/bloc/update_event/update_event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

// Import barrel file dari fiturmu
import 'features/event_management/event_management.dart';

// Jika kamu menggunakan flutterfire_cli, uncomment baris ini
// import 'firebase_options.dart';

void main() async {
  // Pastikan Flutter sudah siap sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform, // Uncomment jika pakai flutterfire_cli
  );

  // Inisialisasi format tanggal Indonesia untuk paket intl
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Menyediakan semua Repository di level tertinggi
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<EventRepository>(
          create:
              (context) => EventRepositoryImpl(
                remoteDataSource: EventRemoteDataSourceImpl(
                  firestore:
                      FirebaseFirestore.instance, // Datasource butuh Firestore
                ),
              ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // 2. Menyediakan Cubit untuk daftar acara
          BlocProvider<MyEventsListCubit>(
            create: (context) {
              // Saat membuat MyEventsListCubit, kita ambil EventRepository
              // yang sudah disediakan di atas menggunakan context.read<T>()
              final eventRepository = context.read<EventRepository>();

              // Berikan 'bahan' yang dibutuhkan oleh Cubit, yaitu Usecase.
              // Usecase sendiri dibuat dengan menggunakan repository.
              return MyEventsListCubit(
                getMyEventsUseCase: GetMyEvents(eventRepository),
                deleteEventUseCase: DeleteEvent(eventRepository),
              )..fetchMyEvents(); // Langsung panggil fetchMyEvents saat Cubit dibuat
            },
          ),
          // 3. Menyediakan Cubit untuk form pembuatan acara
          BlocProvider<CreateEventCubit>(
            create: (context) {
              // Prosesnya sama seperti di atas
              final eventRepository = context.read<EventRepository>();

              return CreateEventCubit(
                createEventUseCase: CreateEvent(eventRepository),
              );
            },
          ),
          BlocProvider<UpdateEventCubit>(
            create: (context) {
              final eventRepository = context.read<EventRepository>();
              return UpdateEventCubit(
                updateEventUseCase: UpdateEvent(eventRepository),
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
          home: const MyEventsPage(),
        ),
      ),
    );
  }
}
