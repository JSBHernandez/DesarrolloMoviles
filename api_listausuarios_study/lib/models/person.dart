class Person {
  final String urlImagen;
  final String nombreCompleto;
  final int edad;
  final String profesion;
  final String universidad;
  final String bachillerato;
  
  Person({
    required this.urlImagen,
    required this.nombreCompleto,
    required this.edad,
    required this.profesion,
    required this.universidad, 
    required this.bachillerato,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      urlImagen: json['urlImagen'],
      nombreCompleto: json['nombreCompleto'],
      edad: json['edad'],
      profesion: json['profesion'],
      universidad: json['estudios'][0]['universidad'],
      bachillerato: json['estudios'][0]['bachillerato'],
    );
  }
}