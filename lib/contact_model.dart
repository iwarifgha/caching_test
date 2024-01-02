import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  final String name;
  final String phone;
  final String id;
  final String createdAt;
  //final bool isSynced;

  const Contact({
    required this.phone,
    required this.id,
    required this.createdAt,
    required this.name,
    //required this.isSynced
  });


  Contact copyWith({
    String? name,
    String? phone,
    String? id,
    String? createdAt,
    bool? isSynced
  }){
    return Contact(
        phone: phone ?? this.phone,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        name: name ?? this.name,
        //isSynced: isSynced ?? this.isSynced
    );
  }


  static Contact fromDatabase(Map<String, dynamic> value){
    return Contact(
        phone: value['phone'],
        id: value['id'],
        //isSynced: parseBoolean(value['is_synced'])!,
        createdAt: value['created_at'],
        name: value['name']);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'phone': phone,
    'name': name,
    'created_at': createdAt,
    //'is_synced': isSynced,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [ id, name, phone, createdAt];


}