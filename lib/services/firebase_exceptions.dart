class FirebaseException implements Exception {
  const FirebaseException();
}

class CouldNotCreateUserData extends FirebaseException {}

class CouldNotFindReference extends FirebaseException {}
