class Wards{
 final int id;
 final String name;
 
 Wards({required this.id, required this.name});

 factory Wards.fromJson(Map<String, dynamic> json){
  return Wards(id: json['id'], name: json['name'] as String);
 }
 
}