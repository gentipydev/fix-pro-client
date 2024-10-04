import 'dart:math';
import 'package:fit_pro_client/models/review.dart';
import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/models/task_group.dart';
import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/models/tasker_skill.dart';
import 'package:fit_pro_client/models/user.dart';
import 'package:fit_pro_client/models/availability.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FakeData {
  // Fake Task Groups
  final List<TaskGroup> fakeTaskGroups = [
    TaskGroup(
      id: '1',
      title: 'Montim mobiliesh',
      description: 'Montimi i mobilieve të ndryshme',
      feePerHour: 2000,
      imagePath: 'assets/images/montim_mobiliesh.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '2',
      title: 'Patinime muresh',
      description: 'Patinim dhe përgatitje e mureve',
      feePerHour: 1800,
      imagePath: 'assets/images/patinime_muresh.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '3',
      title: 'Lyerje muresh',
      description: 'Shërbim profesional për lyerjen e mureve',
      feePerHour: 1600,
      imagePath: 'assets/images/lyerje_muresh.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '4',
      title: 'Punime në kopesht',
      description: 'Punime dhe mirëmbajtje për kopshtin',
      feePerHour: 2200,
      imagePath: 'assets/images/punime_ne_kopesht.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '5',
      title: 'Montime Dyer/Dritare',
      description: 'Montimi i dyerve dhe dritareve',
      feePerHour: 2400,
      imagePath: 'assets/images/montim_dyer_dritare.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '6',
      title: 'Montim Kondicioneri',
      description: 'Instalim dhe mirëmbajtje e kondicionerëve',
      feePerHour: 2500,
      imagePath: 'assets/images/montim_kondicioneri.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '7',
      title: 'Pastrim shtepie',
      description: 'Shërbime për pastrimin e shtëpisë',
      feePerHour: 1500,
      imagePath: 'assets/images/pastrim_shtepie.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '8',
      title: 'Pastrim zyre',
      description: 'Pastrimi i zyrave dhe ambienteve të punës',
      feePerHour: 1600,
      imagePath: 'assets/images/pastrim_zyre.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '9',
      title: 'Punime hidraulike',
      description: 'Shërbime për instalime dhe riparime hidraulike',
      feePerHour: 2300,
      imagePath: 'assets/images/punime_hidraulike.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '10',
      title: 'Punime elektrike',
      description: 'Punime dhe instalime elektrike',
      feePerHour: 2500,
      imagePath: 'assets/images/punime_elektrike.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '11',
      title: 'Punime druri',
      description: 'Shërbime për ndërtimin dhe riparimin e objekteve prej druri',
      feePerHour: 2600,
      imagePath: 'assets/images/punime_druri.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '12',
      title: 'Vjelje ullinjsh',
      description: 'Shërbime për vjeljen e ullinjve',
      feePerHour: 1400,
      imagePath: 'assets/images/vjelje_ullinjsh.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '13',
      title: 'Karrotrec',
      description: 'Shërbime karrotreku për transport dhe ndihmë teknike',
      feePerHour: 2800,
      imagePath: 'assets/images/karrotrec.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '14',
      title: 'Montim kamerash',
      description: 'Instalimi dhe konfigurimi i kamerave të sigurisë',
      feePerHour: 2700,
      imagePath: 'assets/images/montim_kamerash.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '15',
      title: 'Riparim dushi',
      description: 'Riparim dhe instalim i pajisjeve të dushit',
      feePerHour: 2100,
      imagePath: 'assets/images/riparime_banjo.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '16',
      title: 'Instalim paneli',
      description: 'Instalim i paneleve diellore për energji',
      feePerHour: 3200,
      imagePath: 'assets/images/instalim_panelesh_diellore.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '17',
      title: 'Riparime çatie',
      description: 'Riparim dhe mirëmbajtje e çative',
      feePerHour: 2900,
      imagePath: 'assets/images/riparim_catie.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '18',
      title: 'Pastrim oxhaqesh',
      description: 'Shërbime për pastrimin e oxhaqeve',
      feePerHour: 1500,
      imagePath: 'assets/images/pastrim_oxhaqesh.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '19',
      title: 'Punime me gips',
      description: 'Instalim dhe dekorim me gips',
      feePerHour: 2200,
      imagePath: 'assets/images/punime_gipsi.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '20',
      title: 'Instalim ndriçimi',
      description: 'Instalimi i sistemeve të ndriçimit',
      feePerHour: 2400,
      imagePath: 'assets/images/instalim_ndricimi.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '21',
      title: 'Shtrim pllakash',
      description: 'Shtrim dhe riparim pllakash dyshemeje dhe muri',
      feePerHour: 2000,
      imagePath: 'assets/images/shtrim_pllakash.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '22',
      title: 'Pastrim pishinash',
      description: 'Shërbime për pastrimin dhe mirëmbajtjen e pishinave',
      feePerHour: 2500,
      imagePath: 'assets/images/pastrim_pishinash.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '23',
      title: 'Pastrim xhamash',
      description: 'Pastrimi profesional i xhamave të dritareve dhe dyerve',
      feePerHour: 1600,
      imagePath: 'assets/images/pastrim_dyer_dritare.jpg',
      isActive: true,
    ),
    TaskGroup(
      id: '24',
      title: 'Larje tapeti',
      description: 'Shërbime për larjen dhe pastrimin e tapetave',
      feePerHour: 1300,
      imagePath: 'assets/images/larje_tapeti.jpg',
      isActive: true,
    ),
  ];

  // Example function to convert TaskGroups to TaskerSkills
  List<TaskerSkill> convertTaskGroupsToSkills(List<TaskGroup> taskGroups) {
    final random = Random();
    
    return taskGroups.map((taskGroup) {
      return TaskerSkill(
        taskGroup: taskGroup,
        tasksCompleted: random.nextInt(50) + 1, 
      );
    }).toList();
  }

  final User fakeUser = User(
    id: "1",
    fullName: "Alexa Burgaj",
    profileImage: "assets/images/client4.png",
    contactInfo: "+355696443833",
  );

  late final List<Tasker> fakeTaskers;
  late final List<Review> fakeReviews;
  late final List<Task> fakeTasks;

  // Constructor to initialize fakeTaskers after fakeTaskGroups are available
  FakeData() {

    fakeReviews = [
      Review(
        reviewerId: "1",
        reviewerName: "Harriet",
        reviewText: "Jam shumë e kënaqur me riparimin e lavatriçes time! Gentiani ishte shumë profesionist dhe i saktë. Do ta rekomandoja patjetër!",
        rating: 5.0,
        reviewDate: DateTime.parse("2023-02-27"),
        profileImage: "assets/images/client2.png",
        taskGroup: fakeTaskGroups[0], // Montim mobiliesh
      ),
      Review(
        reviewerId: "2",
        reviewerName: "Aurora",
        reviewText: "Punëtor i mrekullueshëm! Ai e bëri montimin e mobilieve shumë të lehtë dhe i sqaroi të gjitha detajet në mënyrë të thjeshtë.",
        rating: 4.5,
        reviewDate: DateTime.parse("2023-01-25"),
        profileImage: "assets/images/client4.png",
        taskGroup: fakeTaskGroups[0], // Montim mobiliesh
      ),
      Review(
        reviewerId: "3",
        reviewerName: "Bashkim",
        reviewText: "Shërbim i shkëlqyer! Do të thërras patjetër përsëri për riparime të tjera. Shumë profesional dhe i sjellshëm.",
        rating: 5.0,
        reviewDate: DateTime.parse("2022-12-12"),
        profileImage: "assets/images/client6.png",
        taskGroup: fakeTaskGroups[2], // Pastrim zyre
      ),
    ];

    fakeTaskers = [
      Tasker(
        id: "1",
        fullName: "Arben G.",
        profileImage: "assets/images/client3.png",
        mapProfileImage: "assets/images/tasker3.png",
        contactInfo: "+355696443833",
        isFavorite: false,
        rating: 5,
        videoPresentationUrl: "https://example.com/video1",
        reviews: [fakeReviews[0], fakeReviews[1], fakeReviews[2]],
        bio: 'Jam një punëtor me përvojë me mbi 10 vjet në zanatin tim...',
        averagePrice: 1500,
        availability: Availability(availableDays: {"Monday": ["9:00 AM", "5:00 PM"]}),
        totalNumberTasks: 100,
        skills: convertTaskGroupsToSkills(fakeTaskGroups.take(3).toList()),
      ),
      Tasker(
        id: "2",
        fullName: "Eriona H.",
        profileImage: "assets/images/client2.png",
        mapProfileImage: "assets/images/tasker2.png",
        contactInfo: "+355696443833",
        isFavorite: false,
        rating: 5,
        videoPresentationUrl: "https://example.com/video2",
        reviews: [fakeReviews[2], fakeReviews[0], fakeReviews[1]],
        bio: 'Jam nje eksperte në përmirësimin dhe dekorimin e shtëpisë...',
        averagePrice: 1800,
        availability: Availability(availableDays: {"Tuesday": ["10:00 AM", "6:00 PM"]}),
        totalNumberTasks: 80,
        skills: convertTaskGroupsToSkills(fakeTaskGroups.skip(3).take(3).toList()),
      ),
      Tasker(
        id: "3",
        fullName: "Lulzim B.",
        profileImage: "assets/images/client6.png",
        mapProfileImage: "assets/images/tasker6.png",
        contactInfo: "+355696333333",
        isFavorite: true,
        rating: 5,
        videoPresentationUrl: "https://example.com/video3",
        reviews: [fakeReviews[0],fakeReviews[1], fakeReviews[2]],
        bio: 'Jam një ekspert në pastrimin dhe organizimin e hapësirave...',
        averagePrice: 2000,
        availability: Availability(availableDays: {"Wednesday": ["11:00 AM", "7:00 PM"]}),
        totalNumberTasks: 120,
        skills: convertTaskGroupsToSkills(fakeTaskGroups.take(3).toList()),
      ),
      Tasker(
        id: "4",
        fullName: "Erion D.",
        profileImage: "assets/images/client1.png",
        mapProfileImage: "assets/images/tasker1.png",
        contactInfo: "+355696333333",
        isFavorite: false,
        rating: 5,
        videoPresentationUrl: "https://example.com/video4",
        reviews: [fakeReviews[0],fakeReviews[2], fakeReviews[1]],
        bio: 'Jam një punëtor me përvojë me mbi 10 vjet në punime druri...',
        averagePrice: 2200,
        availability: Availability(availableDays: {"Thursday": ["8:00 AM", "4:00 PM"]}),
        totalNumberTasks: 90,
        skills: convertTaskGroupsToSkills(fakeTaskGroups.skip(3).take(3).toList()),
      ),
    ];

      fakeTasks = [
        Task(
          id: "2",
          client: fakeUser,
          tasker: fakeTaskers[1],
          userLocation: const LatLng(41.3275, 19.8189),
          taskerLocation: const LatLng(41.3317, 19.8345),
          polylineCoordinates: [],
          bounds: null,
          taskWorkGroup: fakeTaskGroups[1],
          date: DateTime.parse("2024-05-28"),
          time: const TimeOfDay(hour: 16, minute: 0),
          taskerArea: "Lagjja Nr.1, Tirane",
          taskPlaceDistance: '1.5',
          userArea: "Durres",
          taskTools: ["Wrench", "Pliers"],
          paymentMethod: "Credit Card",
          promoCode: null,
          taskFullAddress: "Durres, Lagjja Nr.1, Pallati 12, Hyrja 3",
          taskDetails: "Zëvendësimi i rubinetave të vjetra me të reja",
          taskEvaluation: "Shpejtë - Vlerësuar 1-2 orë",
          taskExtraDetails: "Veglat e duhura për rubinetë",
          status: TaskStatus.past,
        ),
        Task(
          id: "3",
          client: fakeUser,
          tasker: fakeTaskers[2],
          userLocation: const LatLng(41.3275, 19.8189),
          taskerLocation: const LatLng(41.3317, 19.8345),
          polylineCoordinates: [],
          bounds: null,
          taskWorkGroup: fakeTaskGroups[6],
          date: DateTime.parse("2024-06-06"),
          time: const TimeOfDay(hour: 13, minute: 0),
          taskerArea: "Fresk, Tirane",
          taskPlaceDistance: '0.8',
          userArea: "Tirane",
          taskTools: ["Shower installation tools"],
          paymentMethod: "Cash",
          promoCode: "SHOWER123",
          taskFullAddress: "Vlore, Rruga Ismail Qemali, Ndërtesa 5, Apartamenti 8",
          taskDetails: "Instalimi i kabinës së dushit me të gjitha aksesorët",
          taskEvaluation: "Normale - Vlerësuar 2-3 orë",
          taskExtraDetails: "Profesionisti duhet të sjellë veglat e veta",
          status: TaskStatus.past,
        ),
        Task(
          id: "4",
          client: fakeUser,
          tasker: fakeTaskers[3],
          userLocation: const LatLng(41.3275, 19.8189),
          taskerLocation: const LatLng(41.3317, 19.8345),
          polylineCoordinates: [],
          bounds: null,
          taskWorkGroup: fakeTaskGroups[10],
          date: DateTime.parse("2024-06-07"),
          time: const TimeOfDay(hour: 14, minute: 0),
          taskerArea: "Rruga George W Bush, Tirane",
          taskPlaceDistance: '3.2',
          userArea: "Tirane",
          taskTools: ["Air conditioning tools"],
          paymentMethod: "Cash",
          promoCode: null,
          taskFullAddress: "Tirane, Rruga George W Bush, Ndërtesa 10, Apartamenti 12",
          taskDetails: "Instalimi i kondicionerit dhe lidhja me sistemin elektrik",
          taskEvaluation: "E gjatë - Vlerësuar 3-4 orë",
          taskExtraDetails: "Profesionisti duhet të sjellë veglat e veta",
          status: TaskStatus.past,
        ),
      ];
  }
}
