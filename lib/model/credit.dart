import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/movie.dart';
import 'package:good_movie_fan/model/person.dart';

enum CreditType { cast, crew }

class Credit {
  static const keyId = 'credit_id';
  static const keyCharacter = 'character';
  static const keyPersonId = 'person_id';
  static const keyMovieId = 'movie_id';
  static const keyJob = 'job';

  final String id;
  final Person person;
  final Movie movie;
  final String role;

  Credit(
      {@required this.id,
      @required this.person,
      @required this.movie,
      @required this.role}) {
    _checkValidity();
  }

  void _checkValidity() {
    if (id == null || person == null || movie == null) {
      throw Exception(
          'Invalid credit: id = $id, personId = $person, movie = $movie');
    }
  }

  factory Credit.fromMap(Map<String, dynamic> map,
      {@required CreditType creditType, Person person, Movie movie}) {
    movie ??= Movie.fromMap(map);
    person ??= Person.fromMap(map, creditType);
    try {
      return Credit(
          id: map[Credit.keyId],
          person: person,
          movie: movie,
          role: map[roleForType(creditType)]);
    } on Exception {
      return null;
    }
  }

  static String roleForType(CreditType creditType) {
    switch (creditType) {
      case CreditType.cast:
        return keyCharacter;
      case CreditType.crew:
        return keyJob;
    }
    assert(false, "Unknown credit type!");
  }
}
