class Item {
  Item({
    required this.id,
    required this.nombre,
    required this.vendedor,
    required this.calificacion,
    required this.image,
  });

  late final String id;
  late final String nombre;
  late final String vendedor;
  late final String calificacion;
  late final String image;

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nombre = json['nombre'],
        vendedor = json['vendedor'],
        calificacion = json['calificacion'],
        image = json['image'];

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nombre'] = nombre;
    _data['vendedor'] = vendedor;
    _data['calificacion'] = calificacion;
    _data['image'] = image;
    return _data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'vendedor': vendedor,
      'calificacion': calificacion,
      'image': image,
    };
  }
}
