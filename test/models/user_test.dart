import 'package:flutter_test/flutter_test.dart';
import 'package:mawashi/models/user.dart';

void main() {
  group('User Model', () {
    test('should create User with required fields', () {
      final user = User(
        id: '123',
        fullName: 'Jean Dupont',
        city: 'Bamako',
        role: UserRole.eleveur,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(user.id, '123');
      expect(user.fullName, 'Jean Dupont');
      expect(user.city, 'Bamako');
      expect(user.role, UserRole.eleveur);
      expect(user.avatarUrl, isNull);
    });

    test('should create User from JSON', () {
      final json = {
        'id': '456',
        'fullName': 'Ahmed Mohamed',
        'city': 'Casablanca',
        'role': 'transporteur',
        'avatarUrl': 'https://example.com/avatar.jpg',
        'createdAt': '2024-01-15T10:30:00.000Z',
      };

      final user = User.fromJson(json);

      expect(user.id, '456');
      expect(user.fullName, 'Ahmed Mohamed');
      expect(user.city, 'Casablanca');
      expect(user.role, UserRole.transporteur);
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
    });

    test('should convert User to JSON', () {
      final user = User(
        id: '789',
        fullName: 'Pierre Martin',
        city: 'Lyon',
        role: UserRole.eleveur,
        avatarUrl: null,
        createdAt: DateTime(2024, 2, 20, 14, 30),
      );

      final json = user.toJson();

      expect(json['id'], '789');
      expect(json['fullName'], 'Pierre Martin');
      expect(json['city'], 'Lyon');
      expect(json['role'], 'eleveur');
      expect(json['avatarUrl'], isNull);
      expect(json['createdAt'], contains('2024-02-20'));
    });

    test('should create copy with updated fields', () {
      final user = User(
        id: '123',
        fullName: 'Original Name',
        city: 'Original City',
        role: UserRole.eleveur,
        createdAt: DateTime(2024, 1, 1),
      );

      final updatedUser = user.copyWith(
        fullName: 'Updated Name',
        city: 'Updated City',
      );

      expect(updatedUser.id, '123'); // unchanged
      expect(updatedUser.fullName, 'Updated Name');
      expect(updatedUser.city, 'Updated City');
      expect(updatedUser.role, UserRole.eleveur); // unchanged
    });

    test('should handle equality correctly', () {
      final user1 = User(
        id: '123',
        fullName: 'Jean',
        city: 'Paris',
        role: UserRole.eleveur,
        createdAt: DateTime(2024, 1, 1),
      );

      final user2 = User(
        id: '123',
        fullName: 'Jean',
        city: 'Paris',
        role: UserRole.eleveur,
        createdAt: DateTime(2024, 1, 1),
      );

      final user3 = User(
        id: '456',
        fullName: 'Jean',
        city: 'Paris',
        role: UserRole.eleveur,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });

    test('should handle default role when parsing invalid JSON role', () {
      final json = {
        'id': '123',
        'fullName': 'Test User',
        'city': 'TestCity',
        'role': 'invalid_role',
        'createdAt': '2024-01-01T00:00:00.000Z',
      };

      final user = User.fromJson(json);
      expect(user.role, UserRole.eleveur); // defaults to eleveur
    });
  });

  group('UserRole', () {
    test('should have correct enum values', () {
      expect(UserRole.values.length, 2);
      expect(UserRole.eleveur.name, 'eleveur');
      expect(UserRole.transporteur.name, 'transporteur');
    });
  });
}
