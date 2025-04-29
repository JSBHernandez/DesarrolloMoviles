class ItemsModel {
  ItemsModel({
    required this.precio,
    required this.articulo,
    required this.descuento,
    required this.urlimagen,
    required this.valoracion,
    required this.descripcion,
    required this.calificaciones,
  });
  late final int precio;
  late final String articulo;
  late final String descuento;
  late final String urlimagen;
  late final int valoracion;
  late final String descripcion;
  late final int calificaciones;
  
  ItemsModel.fromJson(Map<String, dynamic> json){
    precio = json['precio'];
    articulo = json['articulo'];
    descuento = json['descuento'];
    urlimagen = json['urlimagen'];
    valoracion = json['valoracion'];
    descripcion = json['descripcion'];
    calificaciones = json['calificaciones'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['precio'] = precio;
    data['articulo'] = articulo;
    data['descuento'] = descuento;
    data['urlimagen'] = urlimagen;
    data['valoracion'] = valoracion;
    data['descripcion'] = descripcion;
    data['calificaciones'] = calificaciones;
    return data;
  }
}