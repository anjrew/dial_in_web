import 'package:meta/meta.dart';

class Like {
    DateTime createdAt;
    final String emoji;
    final String userId;

    Like({@required this.userId, this.emoji }){
        createdAt = DateTime.now();
    }
}