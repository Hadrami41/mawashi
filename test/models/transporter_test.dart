import 'package:flutter_test/flutter_test.dart';
import 'package:mawashi/models/transporter.dart';
import 'package:flutter/material.dart';

void main() {
  group('Transporter Model', () {
    test('should create Transporter with required fields', () {
      final transporter = Transporter(
        id: 't1',
        name: 'Ahmed El Mansour',
        capacity: '15 Têtes',
        rating: 4.8,
        tags: ['GRAND CAMION', 'AGRÉÉ'],
        iconColor: const Color(0xFF4ADE80),
      );

      expect(transporter.id, 't1');
      expect(transporter.name, 'Ahmed El Mansour');
      expect(transporter.capacity, '15 Têtes');
      expect(transporter.rating, 4.8);
      expect(transporter.tags.length, 2);
      expect(transporter.isAvailable, true); // default value
    });

    test('should create Transporter from JSON', () {
      final json = {
        'id': 't2',
        'name': 'Transport Express',
        'capacity': '10 Têtes',
        'rating': 4.5,
        'tags': ['RAPIDE'],
        'iconColor': 0xFF60A5FA,
        'isAvailable': false,
        'phoneNumber': '+212 6 12 34 56 78',
      };

      final transporter = Transporter.fromJson(json);

      expect(transporter.id, 't2');
      expect(transporter.name, 'Transport Express');
      expect(transporter.rating, 4.5);
      expect(transporter.isAvailable, false);
      expect(transporter.phoneNumber, '+212 6 12 34 56 78');
    });

    test('should convert Transporter to JSON', () {
      final transporter = Transporter(
        id: 't3',
        name: 'Test Transporter',
        capacity: '20 Têtes',
        rating: 5.0,
        tags: ['PREMIUM'],
        iconColor: const Color(0xFFFF0000),
        isAvailable: true,
        phoneNumber: '+33 1 23 45 67 89',
      );

      final json = transporter.toJson();

      expect(json['id'], 't3');
      expect(json['name'], 'Test Transporter');
      expect(json['rating'], 5.0);
      expect(json['tags'], ['PREMIUM']);
      expect(json['isAvailable'], true);
    });

    test('should create copy with updated fields', () {
      final transporter = Transporter(
        id: 't1',
        name: 'Original',
        capacity: '10 Têtes',
        rating: 4.0,
        tags: [],
        iconColor: Colors.green,
      );

      final updated = transporter.copyWith(name: 'Updated', rating: 4.5);

      expect(updated.id, 't1'); // unchanged
      expect(updated.name, 'Updated');
      expect(updated.rating, 4.5);
    });

    test('should handle equality correctly', () {
      final t1 = Transporter(
        id: 't1',
        name: 'Test',
        capacity: '10',
        rating: 4.0,
        tags: ['A'],
        iconColor: Colors.blue,
      );

      final t2 = Transporter(
        id: 't1',
        name: 'Test',
        capacity: '10',
        rating: 4.0,
        tags: ['A'],
        iconColor: Colors.blue,
      );

      expect(t1, equals(t2));
    });
  });
}
