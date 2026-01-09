# 🗄️ Mawashi - Configuration de la Base de Données

Ce document explique comment configurer la base de données Supabase pour l'application Mawashi.

## 📋 Vue d'ensemble

La base de données est conçue pour gérer deux types d'utilisateurs principaux :
- **🐄 Éleveurs** : Publient des demandes de transport pour leurs animaux
- **🚚 Transporteurs** : Partagent leurs véhicules disponibles et acceptent les demandes

## 🚀 Étapes d'installation

### 1. Créer un projet Supabase

1. Allez sur [supabase.com](https://supabase.com)
2. Créez un nouveau projet
3. Notez votre **URL du projet** et **clé API (anon key)**

### 2. Configurer les variables d'environnement

Créez ou modifiez le fichier `.env` à la racine du projet :

```env
SUPABASE_URL=https://votre-projet.supabase.co
SUPABASE_ANON_KEY=votre-cle-anon-ici
```

### 3. Exécuter le script SQL

1. Ouvrez votre projet Supabase
2. Allez dans **SQL Editor**
3. Créez une nouvelle requête
4. Copiez tout le contenu de `supabase_schema.sql`
5. Exécutez le script (Run)

✅ Cela va créer toutes les tables, indexes, policies et triggers nécessaires.

## 📊 Structure de la Base de Données

### Tables Principales

#### 1. **profiles** 👤
Profils utilisateurs (éleveurs et transporteurs)
- `id`, `full_name`, `city`, `role`, `rating`, etc.

#### 2. **transporters** 🚚
Détails des transporteurs
- `company_name`, `license_number`, `years_experience`, etc.

#### 3. **vehicles** 🚛
Véhicules des transporteurs
- `vehicle_type`, `capacity`, `status`, `plate_number`, etc.

#### 4. **transport_requests** 📝
Demandes de transport publiées par les éleveurs
- `animal_type`, `animal_count`, `departure_location`, `destination_location`, etc.

#### 5. **vehicle_availability** 📅
Disponibilités publiées par les transporteurs
- `available_from`, `available_until`, `price_per_animal`, etc.

#### 6. **trips** 🛣️
Trajets actifs/complétés
- `status`, `progress_percentage`, `current_location`, etc.

#### 7. **groupage** 🤝
Opportunités de transport partagé
- `total_capacity`, `booked_capacity`, `available_capacity`, etc.

#### 8. **groupage_participants** 👥
Éleveurs participant au groupage

#### 9. **water_stops** 💧
Arrêts d'eau pour le bien-être animal
- `scheduled_time`, `actual_arrival_time`, `duration_minutes`, etc.

#### 10. **incidents** ⚠️
Rapports d'incidents pendant le transport

#### 11. **reviews** ⭐
Évaluations et avis

#### 12. **conversations** & **messages** 💬
Système de messagerie

#### 13. **notifications** 🔔
Notifications utilisateur

## 🔐 Sécurité (Row Level Security)

Toutes les tables ont des politiques RLS (Row Level Security) activées :

- ✅ **Profiles** : Tout le monde peut voir, mais seulement modifier le sien
- ✅ **Transporteurs** : Visible par tous, modifiable par le propriétaire
- ✅ **Véhicules** : Visible par tous, géré par le transporteur propriétaire
- ✅ **Demandes** : Visibles par tous (si ouvertes), gérées par l'éleveur
- ✅ **Trajets** : Visibles uniquement par les participants
- ✅ **Messages** : Visibles uniquement par les participants de la conversation
- ✅ **Notifications** : Visibles uniquement par le destinataire

## 🔄 Triggers Automatiques

### 1. **update_updated_at_column()**
Met à jour automatiquement le champ `updated_at` à chaque modification

### 2. **update_user_rating()**
Recalcule la note moyenne d'un utilisateur après chaque nouvel avis

### 3. **update_groupage_capacity()**
Met à jour automatiquement les capacités disponibles dans le groupage

## 📊 Indexes pour Performance

Des indexes sont créés sur les colonnes fréquemment recherchées :
- Statuts (status)
- Dates (dates, timestamps)
- IDs utilisateurs
- Localisations

## 🧪 Données de Test

Pour tester l'application, vous pouvez insérer des données de test :

```sql
-- Exemple : Créer un profil éleveur (après inscription via Supabase Auth)
INSERT INTO profiles (id, full_name, city, role) VALUES
('uuid-from-auth', 'Mohamed Ali', 'Casablanca', 'eleveur');

-- Exemple : Créer un profil transporteur
INSERT INTO profiles (id, full_name, city, role) VALUES
('uuid-from-auth-2', 'Ahmed Transport', 'Marrakech', 'transporteur');

-- Exemple : Créer un transporteur
INSERT INTO transporters (user_id, company_name, years_experience) VALUES
('uuid-from-auth-2', 'Ahmed Transport SARL', 10);

-- Exemple : Créer un véhicule
INSERT INTO vehicles (transporter_id, vehicle_type, capacity, plate_number, status) VALUES
('transporter-id', 'truck', 50, 'A-12345-B', 'available');

-- Exemple : Créer une demande de transport
INSERT INTO transport_requests (
    eleveur_id,
    animal_type,
    animal_count,
    departure_location,
    destination_location,
    preferred_date,
    status
) VALUES (
    'uuid-from-auth',
    'cattle',
    20,
    'Casablanca',
    'Marrakech',
    '2026-02-01',
    'open'
);
```

## 🔗 Connexion depuis Flutter

Dans votre fichier `.env`, configurez :

```env
SUPABASE_URL=https://votre-projet.supabase.co
SUPABASE_ANON_KEY=eyJhbG...votre-cle
```

Dans le code Flutter, le service Supabase est déjà configuré dans `lib/services/supabase_service.dart`.

## 📱 Utilisation dans l'Application

### Pour les Éleveurs :
1. S'inscrire avec le rôle "éleveur"
2. Publier une demande de transport (table `transport_requests`)
3. Voir les véhicules disponibles (table `vehicle_availability`)
4. Participer à un groupage (table `groupage_participants`)
5. Suivre les trajets (table `trips`)

### Pour les Transporteurs :
1. S'inscrire avec le rôle "transporteur"
2. Créer un profil transporteur (table `transporters`)
3. Ajouter des véhicules (table `vehicles`)
4. Publier des disponibilités (table `vehicle_availability`)
5. Créer des opportunités de groupage (table `groupage`)
6. Voir les demandes de transport
7. Gérer les trajets actifs

## 🛠️ Maintenance

### Backup
Supabase fait des backups automatiques. Vous pouvez aussi :
```bash
# Export via Supabase Dashboard
# Settings > Database > Backup
```

### Migrations
Pour modifier la structure :
1. Créez un nouveau fichier SQL pour la migration
2. Testez sur un environnement de développement
3. Appliquez sur production

## 📚 Ressources

- [Documentation Supabase](https://supabase.com/docs)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Supabase Flutter SDK](https://supabase.com/docs/reference/dart/introduction)

## ❓ Troubleshooting

### Erreur : "relation does not exist"
➡️ Le script SQL n'a pas été exécuté. Retournez à l'étape 3.

### Erreur : "permission denied"
➡️ Vérifiez les policies RLS. L'utilisateur doit être authentifié.

### Erreur de connexion
➡️ Vérifiez que l'URL et la clé API dans `.env` sont correctes.

---

✅ **Base de données prête !** Vous pouvez maintenant utiliser l'application Mawashi.
