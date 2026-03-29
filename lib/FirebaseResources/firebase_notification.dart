import 'package:expert_support_admin/BlocResources/auth_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {
  late FirebaseMessaging _firebaseMessaging;
  late AuthBloc _bloc;

  void setUpFirebase(AuthBloc bloc) {
    _firebaseMessaging = FirebaseMessaging.instance;
    _bloc = bloc;
    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    _firebaseMessaging.getToken().then((token) {
      if (token != null) {
        _bloc.fcmTokenChange.add(token);
      }
      print(token);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('on message ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('on resume ${message.data}');
    });
  }
}
