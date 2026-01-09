# 🐄 Mawashi - Plateforme de Transport de Bétail

![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?logo=supabase&logoColor=white)

**Mawashi** (مواشي) signifie "bétail" en arabe. C'est une plateforme mobile de logistique pastorale qui connecte les éleveurs avec les transporteurs de bétail en Afrique du Nord et de l'Ouest.

## 📱 Vue d'ensemble

Mawashi facilite le transport de bétail en créant un pont entre :
- **🐄 Éleveurs** : Qui ont besoin de transporter leurs animaux
- **🚚 Transporteurs** : Qui offrent des services de transport avec leurs véhicules

### Problème résolu
- ✅ Difficulté à trouver des transporteurs fiables
- ✅ Coûts de transport élevés
- ✅ Manque de transparence et de suivi
- ✅ Préoccupations sur le bien-être animal pendant le transport

## ✨ Fonctionnalités principales

### Pour les Éleveurs 🐄
- 📝 Publier des demandes de transport d'animaux
- 🔍 Rechercher des transporteurs disponibles
- 🤝 Participer au groupage (transport partagé) pour réduire les coûts
- 📍 Suivre les trajets en temps réel
- 💧 Voir les arrêts d'eau (bien-être animal)
- ⭐ Évaluer les transporteurs
- 💬 Communiquer avec les transporteurs

### Pour les Transporteurs 🚚
- 🚛 Publier leurs véhicules disponibles
- 📅 Gérer leur calendrier de disponibilité
- 👥 Créer des opportunités de groupage
- 📊 Voir les demandes de transport
- 🛣️ Gérer les trajets actifs
- 💰 Fixer leurs tarifs
- ⚠️ Signaler des incidents
- ⭐ Recevoir des évaluations

### Fonctionnalités communes
- 🗺️ Suivi GPS en temps réel
- 📴 Mode hors ligne avec synchronisation
- 🌍 Support bilingue (Français/Arabe)
- 🔔 Notifications push
- 💬 Messagerie intégrée
- 📱 Interface utilisateur moderne et intuitive

## 🏗️ Architecture technique

### Technologies
- **Frontend** : Flutter 3.9.2+
- **État** : Provider (State Management)
- **Backend** : Supabase (PostgreSQL, Auth, Storage)
- **Stockage local** : SharedPreferences
- **Cartes** : Custom map implementation

### Structure du projet
```
mawashi/
├── lib/
│   ├── main.dart                 # Point d'entrée
│   ├── models/                   # Modèles de données
│   │   ├── user.dart
│   │   ├── transporter.dart
│   │   ├── transport_vehicle.dart
│   │   ├── transport_request.dart
│   │   └── trip.dart
│   ├── providers/                # Gestion d'état
│   │   ├── auth_provider.dart
│   │   └── transport_provider.dart
│   ├── services/                 # Logique métier
│   │   ├── auth_service.dart
│   │   ├── transport_service.dart
│   │   ├── storage_service.dart
│   │   └── supabase_service.dart
│   └── screens/                  # Pages UI
│       ├── home_page.dart
│       ├── registration_page.dart
│       ├── find_transport_page.dart
│       ├── groupage_page.dart
│       ├── trip_tracking_page.dart
│       ├── transport_request_page.dart
│       ├── transporters_list_page.dart
│       └── my_truck_page.dart
├── assets/
│   └── images/
├── supabase_schema.sql           # Schéma de base de données
├── DATABASE_SETUP.md             # Guide de configuration DB
└── SQL_QUERIES_EXAMPLES.md       # Exemples de requêtes SQL
```

## 🚀 Installation et Configuration

### Prérequis
- Flutter SDK 3.9.2 ou supérieur
- Dart 3.0+
- Compte Supabase
- Android Studio / VS Code
- Appareil Android ou émulateur

### 1. Cloner le projet
```bash
git clone https://github.com/Hadrami41/mawashi.git
cd mawashi
```

### 2. Installer les dépendances
```bash
flutter pub get
```

### 3. Configurer Supabase

#### a. Créer un projet Supabase
1. Allez sur [supabase.com](https://supabase.com)
2. Créez un nouveau projet
3. Notez votre URL et clé API

#### b. Configurer la base de données
1. Ouvrez le SQL Editor dans Supabase
2. Copiez le contenu de `supabase_schema.sql`
3. Exécutez le script

Pour plus de détails, consultez [DATABASE_SETUP.md](DATABASE_SETUP.md)

### 4. Configurer les variables d'environnement
Créez un fichier `.env` à la racine :
```env
SUPABASE_URL=https://votre-projet.supabase.co
SUPABASE_ANON_KEY=votre-cle-anon
```

### 5. Lancer l'application
```bash
flutter run
```

## 📊 Base de Données

### Tables principales
- **profiles** : Profils utilisateurs (éleveurs et transporteurs)
- **transporters** : Informations détaillées des transporteurs
- **vehicles** : Véhicules des transporteurs
- **transport_requests** : Demandes de transport publiées par les éleveurs
- **vehicle_availability** : Disponibilités publiées par les transporteurs
- **trips** : Trajets actifs et historiques
- **groupage** : Opportunités de transport partagé
- **water_stops** : Arrêts d'eau pour le bien-être animal
- **reviews** : Évaluations et avis
- **messages** : Système de messagerie
- **notifications** : Notifications utilisateur

### Sécurité
- ✅ Row Level Security (RLS) activé sur toutes les tables
- ✅ Authentification Supabase Auth
- ✅ Policies pour contrôler l'accès aux données
- ✅ Validation des données côté serveur

## 🎨 Design

### Palette de couleurs
- **Vert principal** : `#4ADE80` - Actions principales, éleveurs
- **Bleu** : `#3B82F6` - Transporteurs
- **Gris clair** : `#F8F9FA` - Arrière-plan
- **Blanc** : `#FFFFFF` - Cartes et conteneurs

### Icônes
- Material Design Icons
- Emojis contextuels (🐄, 🚚, 💧)

## 🧪 Tests

```bash
# Lancer tous les tests
flutter test

# Tests unitaires
flutter test test/models/
flutter test test/services/

# Tests de widgets
flutter test test/registration_page_test.dart

# Coverage
flutter test --coverage
```

## 📱 Captures d'écran

### Éleveur
- Page d'accueil avec recherche de transporteurs
- Formulaire de demande de transport
- Liste des transporteurs disponibles
- Page de groupage

### Transporteur
- Dashboard avec statistiques
- Gestion des véhicules
- Liste des demandes reçues
- Suivi des trajets actifs

### Commun
- Suivi GPS en temps réel
- Timeline des arrêts d'eau
- Système de messagerie
- Profil et évaluations

## 🗺️ Roadmap

### Phase 1 - MVP ✅ (Actuel)
- [x] Interface utilisateur complète
- [x] Schéma de base de données
- [x] Services mock pour développement
- [x] Séparation Éleveur/Transporteur
- [x] Architecture propre

### Phase 2 - Backend (En cours)
- [ ] Connexion Supabase réelle
- [ ] Authentification fonctionnelle
- [ ] CRUD complet pour toutes les entités
- [ ] Upload d'images

### Phase 3 - Fonctionnalités avancées
- [ ] Suivi GPS en temps réel
- [ ] Notifications push
- [ ] Paiement intégré
- [ ] Système de chat en temps réel
- [ ] Export de rapports

### Phase 4 - Optimisations
- [ ] Tests d'intégration complets
- [ ] Optimisation des performances
- [ ] Mode hors ligne robuste
- [ ] Internationalisation complète
- [ ] Analytics et monitoring

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Forkez le projet
2. Créez une branche (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add AmazingFeature'`)
4. Pushez vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Équipe

- **Développeur principal** : Hadrami
- **Assistance IA** : Claude Sonnet 4.5 (Anthropic)

## 📞 Contact

- GitHub : [@Hadrami41](https://github.com/Hadrami41)
- Projet : [Mawashi](https://github.com/Hadrami41/mawashi)

## 🙏 Remerciements

- Flutter Team pour le framework exceptionnel
- Supabase pour le backend as a service
- La communauté open source

---

**Mawashi** - Facilitant le transport de bétail, une livraison à la fois 🐄🚚

![Made with Flutter](https://img.shields.io/badge/Made%20with-Flutter-02569B?logo=flutter)
![Powered by Supabase](https://img.shields.io/badge/Powered%20by-Supabase-3ECF8E?logo=supabase)
