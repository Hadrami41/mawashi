# 📊 Requêtes SQL Utiles - Mawashi

Collection de requêtes SQL utiles pour gérer et interroger la base de données Mawashi.

## 📝 Demandes de Transport (Transport Requests)

### Voir toutes les demandes ouvertes
```sql
SELECT
    tr.*,
    p.full_name as eleveur_name,
    p.city as eleveur_city,
    p.phone as eleveur_phone
FROM transport_requests tr
JOIN profiles p ON tr.eleveur_id = p.id
WHERE tr.status = 'open'
ORDER BY tr.created_at DESC;
```

### Rechercher des demandes par localisation
```sql
SELECT *
FROM transport_requests
WHERE
    departure_location ILIKE '%Casablanca%'
    AND destination_location ILIKE '%Marrakech%'
    AND status = 'open';
```

### Voir les demandes d'un éleveur spécifique
```sql
SELECT *
FROM transport_requests
WHERE eleveur_id = 'uuid-de-eleveur'
ORDER BY created_at DESC;
```

## 🚛 Véhicules et Disponibilités

### Voir tous les véhicules disponibles
```sql
SELECT
    v.*,
    t.company_name,
    p.full_name as transporter_name,
    p.rating as transporter_rating
FROM vehicles v
JOIN transporters t ON v.transporter_id = t.id
JOIN profiles p ON t.user_id = p.id
WHERE v.status = 'available'
ORDER BY p.rating DESC;
```

### Voir les disponibilités actives
```sql
SELECT
    va.*,
    v.vehicle_type,
    v.capacity as vehicle_capacity,
    t.company_name,
    p.full_name as transporter_name
FROM vehicle_availability va
JOIN vehicles v ON va.vehicle_id = v.id
JOIN transporters t ON va.transporter_id = t.id
JOIN profiles p ON t.user_id = p.id
WHERE
    va.status = 'available'
    AND va.available_from <= CURRENT_DATE
    AND va.available_until >= CURRENT_DATE
ORDER BY va.price_per_animal ASC;
```

### Rechercher des véhicules par route
```sql
SELECT
    va.*,
    v.vehicle_type,
    v.capacity,
    t.company_name
FROM vehicle_availability va
JOIN vehicles v ON va.vehicle_id = v.id
JOIN transporters t ON va.transporter_id = t.id
WHERE
    va.departure_location ILIKE '%Casablanca%'
    AND va.destination_location ILIKE '%Marrakech%'
    AND va.status = 'available'
    AND va.available_capacity > 0;
```

## 🛣️ Trajets (Trips)

### Voir tous les trajets actifs
```sql
SELECT
    t.*,
    pe.full_name as eleveur_name,
    pt.full_name as transporter_name,
    v.vehicle_type,
    v.plate_number
FROM trips t
JOIN profiles pe ON t.eleveur_id = pe.id
JOIN transporters tr ON t.transporter_id = tr.id
JOIN profiles pt ON tr.user_id = pt.id
JOIN vehicles v ON t.vehicle_id = v.id
WHERE t.status = 'in_progress'
ORDER BY t.start_date DESC;
```

### Voir les trajets d'un utilisateur
```sql
-- Pour un éleveur
SELECT *
FROM trips
WHERE eleveur_id = 'uuid-eleveur'
ORDER BY start_date DESC;

-- Pour un transporteur
SELECT t.*
FROM trips t
JOIN transporters tr ON t.transporter_id = tr.id
WHERE tr.user_id = 'uuid-transporteur'
ORDER BY t.start_date DESC;
```

### Calculer le temps de trajet moyen
```sql
SELECT
    AVG(EXTRACT(EPOCH FROM (actual_arrival - start_date))/3600) as avg_hours,
    COUNT(*) as total_trips
FROM trips
WHERE
    status = 'completed'
    AND actual_arrival IS NOT NULL;
```

## 🤝 Groupage

### Voir toutes les opportunités de groupage ouvertes
```sql
SELECT
    g.*,
    p.full_name as transporter_name,
    v.vehicle_type,
    v.plate_number,
    (g.total_capacity - g.booked_capacity) as remaining_spots,
    ROUND((g.booked_capacity::NUMERIC / g.total_capacity * 100), 2) as fill_percentage
FROM groupage g
JOIN transporters t ON g.transporter_id = t.id
JOIN profiles p ON t.user_id = p.id
JOIN vehicles v ON g.vehicle_id = v.id
WHERE g.status = 'open'
    AND g.available_capacity > 0
ORDER BY g.departure_date ASC;
```

### Voir les participants d'un groupage
```sql
SELECT
    gp.*,
    p.full_name as eleveur_name,
    p.phone as eleveur_phone
FROM groupage_participants gp
JOIN profiles p ON gp.eleveur_id = p.id
WHERE gp.groupage_id = 'uuid-groupage'
    AND gp.status = 'confirmed'
ORDER BY gp.joined_at ASC;
```

### Calculer les revenus d'un groupage
```sql
SELECT
    g.id,
    g.departure_location,
    g.destination_location,
    COUNT(gp.id) as participants_count,
    SUM(gp.animal_count) as total_animals,
    SUM(gp.price_agreed) as total_revenue
FROM groupage g
LEFT JOIN groupage_participants gp ON g.id = gp.groupage_id
WHERE g.id = 'uuid-groupage'
GROUP BY g.id, g.departure_location, g.destination_location;
```

## 💧 Arrêts d'eau (Water Stops)

### Voir les arrêts d'eau d'un trajet
```sql
SELECT *
FROM water_stops
WHERE trip_id = 'uuid-trip'
ORDER BY scheduled_time ASC;
```

### Voir les arrêts manqués
```sql
SELECT
    ws.*,
    t.departure_location,
    t.destination_location
FROM water_stops ws
JOIN trips t ON ws.trip_id = t.id
WHERE ws.status = 'skipped'
ORDER BY ws.scheduled_time DESC;
```

## ⭐ Évaluations et Statistiques

### Voir les meilleurs transporteurs
```sql
SELECT
    p.id,
    p.full_name,
    p.city,
    p.rating,
    p.total_trips,
    COUNT(r.id) as review_count
FROM profiles p
LEFT JOIN reviews r ON p.id = r.reviewed_id
WHERE p.role = 'transporteur'
GROUP BY p.id, p.full_name, p.city, p.rating, p.total_trips
ORDER BY p.rating DESC, p.total_trips DESC
LIMIT 10;
```

### Statistiques d'un transporteur
```sql
SELECT
    p.full_name,
    COUNT(DISTINCT t.id) as total_trips,
    COUNT(DISTINCT CASE WHEN t.status = 'completed' THEN t.id END) as completed_trips,
    AVG(r.rating) as avg_rating,
    COUNT(r.id) as total_reviews,
    SUM(t.price_agreed) as total_revenue
FROM profiles p
JOIN transporters tr ON p.id = tr.user_id
LEFT JOIN trips t ON tr.id = t.transporter_id
LEFT JOIN reviews r ON p.id = r.reviewed_id
WHERE p.id = 'uuid-transporteur'
GROUP BY p.full_name;
```

### Avis récents d'un utilisateur
```sql
SELECT
    r.*,
    pr.full_name as reviewer_name,
    t.departure_location,
    t.destination_location
FROM reviews r
JOIN profiles pr ON r.reviewer_id = pr.id
JOIN trips t ON r.trip_id = t.id
WHERE r.reviewed_id = 'uuid-user'
ORDER BY r.created_at DESC
LIMIT 10;
```

## 📊 Statistiques Générales

### Vue d'ensemble de la plateforme
```sql
SELECT
    (SELECT COUNT(*) FROM profiles WHERE role = 'eleveur') as total_eleveurs,
    (SELECT COUNT(*) FROM profiles WHERE role = 'transporteur') as total_transporteurs,
    (SELECT COUNT(*) FROM transport_requests WHERE status = 'open') as open_requests,
    (SELECT COUNT(*) FROM trips WHERE status = 'in_progress') as active_trips,
    (SELECT COUNT(*) FROM trips WHERE status = 'completed') as completed_trips,
    (SELECT COUNT(*) FROM groupage WHERE status = 'open') as open_groupages;
```

### Routes les plus populaires
```sql
SELECT
    departure_location,
    destination_location,
    COUNT(*) as trip_count,
    AVG(price_agreed) as avg_price
FROM trips
WHERE status = 'completed'
GROUP BY departure_location, destination_location
ORDER BY trip_count DESC
LIMIT 10;
```

### Types d'animaux les plus transportés
```sql
SELECT
    animal_type,
    COUNT(*) as trip_count,
    SUM(animal_count) as total_animals
FROM trips
WHERE status = 'completed'
GROUP BY animal_type
ORDER BY total_animals DESC;
```

## 💬 Messages et Notifications

### Conversations récentes d'un utilisateur
```sql
SELECT
    c.*,
    p1.full_name as participant_1_name,
    p2.full_name as participant_2_name,
    (SELECT message FROM messages WHERE conversation_id = c.id ORDER BY created_at DESC LIMIT 1) as last_message
FROM conversations c
JOIN profiles p1 ON c.participant_1 = p1.id
JOIN profiles p2 ON c.participant_2 = p2.id
WHERE c.participant_1 = 'uuid-user' OR c.participant_2 = 'uuid-user'
ORDER BY c.last_message_at DESC;
```

### Messages non lus
```sql
SELECT
    m.*,
    p.full_name as sender_name
FROM messages m
JOIN profiles p ON m.sender_id = p.id
JOIN conversations c ON m.conversation_id = c.id
WHERE
    (c.participant_1 = 'uuid-user' OR c.participant_2 = 'uuid-user')
    AND m.sender_id != 'uuid-user'
    AND m.read = false
ORDER BY m.created_at DESC;
```

### Notifications non lues
```sql
SELECT *
FROM notifications
WHERE user_id = 'uuid-user'
    AND read = false
ORDER BY created_at DESC;
```

## ⚠️ Incidents

### Voir les incidents actifs
```sql
SELECT
    i.*,
    t.departure_location,
    t.destination_location,
    p.full_name as reporter_name
FROM incidents i
JOIN trips t ON i.trip_id = t.id
JOIN profiles p ON i.reported_by = p.id
WHERE i.resolved = false
ORDER BY i.severity DESC, i.created_at DESC;
```

### Statistiques d'incidents par type
```sql
SELECT
    incident_type,
    severity,
    COUNT(*) as incident_count,
    COUNT(CASE WHEN resolved THEN 1 END) as resolved_count,
    COUNT(CASE WHEN NOT resolved THEN 1 END) as pending_count
FROM incidents
GROUP BY incident_type, severity
ORDER BY incident_count DESC;
```

## 🔧 Maintenance et Nettoyage

### Supprimer les demandes expirées
```sql
-- Marquer comme expirées les demandes de plus de 30 jours
UPDATE transport_requests
SET status = 'cancelled'
WHERE
    status = 'open'
    AND preferred_date < CURRENT_DATE - INTERVAL '30 days';
```

### Nettoyer les anciennes notifications
```sql
-- Supprimer les notifications lues de plus de 90 jours
DELETE FROM notifications
WHERE
    read = true
    AND created_at < NOW() - INTERVAL '90 days';
```

### Archiver les anciens trajets
```sql
-- Créer une table d'archive (à faire une fois)
CREATE TABLE IF NOT EXISTS trips_archive AS TABLE trips WITH NO DATA;

-- Archiver les trajets complétés depuis plus d'un an
INSERT INTO trips_archive
SELECT * FROM trips
WHERE
    status = 'completed'
    AND actual_arrival < NOW() - INTERVAL '1 year';

-- Puis les supprimer de la table principale
DELETE FROM trips
WHERE
    status = 'completed'
    AND actual_arrival < NOW() - INTERVAL '1 year';
```

## 📈 Rapports

### Rapport mensuel des revenus par transporteur
```sql
SELECT
    DATE_TRUNC('month', t.start_date) as month,
    p.full_name as transporter_name,
    COUNT(t.id) as trips_count,
    SUM(t.price_agreed) as total_revenue,
    AVG(t.price_agreed) as avg_price_per_trip
FROM trips t
JOIN transporters tr ON t.transporter_id = tr.id
JOIN profiles p ON tr.user_id = p.id
WHERE
    t.status = 'completed'
    AND t.payment_status = 'paid'
    AND t.start_date >= NOW() - INTERVAL '6 months'
GROUP BY DATE_TRUNC('month', t.start_date), p.full_name
ORDER BY month DESC, total_revenue DESC;
```

### Taux d'utilisation des véhicules
```sql
SELECT
    v.id,
    v.vehicle_type,
    v.capacity,
    t.company_name,
    COUNT(tr.id) as total_trips,
    AVG(tr.animal_count::NUMERIC / v.capacity * 100) as avg_capacity_usage
FROM vehicles v
JOIN transporters t ON v.transporter_id = t.id
LEFT JOIN trips tr ON v.id = tr.vehicle_id AND tr.status = 'completed'
GROUP BY v.id, v.vehicle_type, v.capacity, t.company_name
ORDER BY avg_capacity_usage DESC;
```

---

💡 **Astuce** : Vous pouvez exécuter ces requêtes directement dans le SQL Editor de Supabase ou les adapter dans votre code Flutter avec le Supabase SDK.
