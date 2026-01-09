-- Mawashi Database Schema for Supabase (SAFE VERSION)
-- This script safely creates tables only if they don't exist
-- Livestock Transport Application Database

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- USERS & AUTHENTICATION
-- ============================================

-- User Profiles Table
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    city VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('eleveur', 'transporteur')),
    avatar_url TEXT,
    rating DECIMAL(3,2) DEFAULT 0.00,
    total_trips INTEGER DEFAULT 0,
    verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- TRANSPORTEURS (TRANSPORTERS)
-- ============================================

-- Transporters Details Table
CREATE TABLE IF NOT EXISTS transporters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    company_name VARCHAR(255),
    license_number VARCHAR(50),
    insurance_number VARCHAR(50),
    years_experience INTEGER DEFAULT 0,
    specializations TEXT[],
    service_areas TEXT[],
    verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- ============================================
-- VEHICLES
-- ============================================

-- Vehicles Table
CREATE TABLE IF NOT EXISTS vehicles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transporter_id UUID NOT NULL REFERENCES transporters(id) ON DELETE CASCADE,
    vehicle_type VARCHAR(50) NOT NULL,
    brand VARCHAR(50),
    model VARCHAR(50),
    year INTEGER,
    plate_number VARCHAR(20) NOT NULL,
    capacity INTEGER NOT NULL,
    equipment TEXT[],
    status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available', 'in_transit', 'maintenance', 'inactive')),
    current_location VARCHAR(100),
    images TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- TRANSPORT REQUESTS (ÉLEVEURS)
-- ============================================

-- Transport Requests Table (Posted by Éleveurs)
CREATE TABLE IF NOT EXISTS transport_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    eleveur_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    animal_type VARCHAR(50) NOT NULL,
    animal_count INTEGER NOT NULL,
    departure_location VARCHAR(255) NOT NULL,
    departure_latitude DECIMAL(10, 8),
    departure_longitude DECIMAL(11, 8),
    destination_location VARCHAR(255) NOT NULL,
    destination_latitude DECIMAL(10, 8),
    destination_longitude DECIMAL(11, 8),
    preferred_date DATE NOT NULL,
    preferred_time TIME,
    flexible_dates BOOLEAN DEFAULT FALSE,
    special_requirements TEXT,
    estimated_price DECIMAL(10, 2),
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'accepted', 'in_progress', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- VEHICLE AVAILABILITY (TRANSPORTEURS)
-- ============================================

-- Vehicle Availability Table (Posted by Transporteurs)
CREATE TABLE IF NOT EXISTS vehicle_availability (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vehicle_id UUID NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    transporter_id UUID NOT NULL REFERENCES transporters(id) ON DELETE CASCADE,
    departure_location VARCHAR(255) NOT NULL,
    departure_latitude DECIMAL(10, 8),
    departure_longitude DECIMAL(11, 8),
    destination_location VARCHAR(255) NOT NULL,
    destination_latitude DECIMAL(10, 8),
    destination_longitude DECIMAL(11, 8),
    available_from DATE NOT NULL,
    available_until DATE NOT NULL,
    available_capacity INTEGER NOT NULL,
    price_per_animal DECIMAL(10, 2),
    price_total DECIMAL(10, 2),
    animal_types_accepted TEXT[],
    status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available', 'partially_booked', 'fully_booked', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- TRIPS & BOOKINGS
-- ============================================

-- Trips Table (Active transports)
CREATE TABLE IF NOT EXISTS trips (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID REFERENCES transport_requests(id) ON DELETE SET NULL,
    availability_id UUID REFERENCES vehicle_availability(id) ON DELETE SET NULL,
    transporter_id UUID NOT NULL REFERENCES transporters(id) ON DELETE CASCADE,
    vehicle_id UUID NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    eleveur_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    departure_location VARCHAR(255) NOT NULL,
    departure_latitude DECIMAL(10, 8),
    departure_longitude DECIMAL(11, 8),
    destination_location VARCHAR(255) NOT NULL,
    destination_latitude DECIMAL(10, 8),
    destination_longitude DECIMAL(11, 8),
    animal_type VARCHAR(50) NOT NULL,
    animal_count INTEGER NOT NULL,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    estimated_arrival TIMESTAMP WITH TIME ZONE,
    actual_arrival TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'in_progress', 'completed', 'cancelled')),
    current_latitude DECIMAL(10, 8),
    current_longitude DECIMAL(11, 8),
    progress_percentage INTEGER DEFAULT 0 CHECK (progress_percentage >= 0 AND progress_percentage <= 100),
    price_agreed DECIMAL(10, 2),
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'refunded')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- GROUPAGE (SHARED TRANSPORT)
-- ============================================

-- Groupage Opportunities Table
CREATE TABLE IF NOT EXISTS groupage (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
    transporter_id UUID NOT NULL REFERENCES transporters(id) ON DELETE CASCADE,
    vehicle_id UUID NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    departure_location VARCHAR(255) NOT NULL,
    destination_location VARCHAR(255) NOT NULL,
    total_capacity INTEGER NOT NULL,
    booked_capacity INTEGER DEFAULT 0,
    available_capacity INTEGER NOT NULL,
    price_per_animal DECIMAL(10, 2) NOT NULL,
    animal_types_accepted TEXT[],
    departure_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'closed', 'in_transit', 'completed')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Groupage Participants
CREATE TABLE IF NOT EXISTS groupage_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    groupage_id UUID NOT NULL REFERENCES groupage(id) ON DELETE CASCADE,
    eleveur_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    animal_type VARCHAR(50) NOT NULL,
    animal_count INTEGER NOT NULL,
    price_agreed DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'confirmed' CHECK (status IN ('confirmed', 'cancelled')),
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(groupage_id, eleveur_id)
);

-- ============================================
-- WATER STOPS & TRACKING
-- ============================================

-- Water Stops Table
CREATE TABLE IF NOT EXISTS water_stops (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
    location_name VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    scheduled_time TIMESTAMP WITH TIME ZONE,
    actual_arrival_time TIMESTAMP WITH TIME ZONE,
    duration_minutes INTEGER,
    notes TEXT,
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'skipped')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- INCIDENTS & REPORTS
-- ============================================

-- Incidents Table
CREATE TABLE IF NOT EXISTS incidents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
    reported_by UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    incident_type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) DEFAULT 'low' CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    description TEXT NOT NULL,
    location VARCHAR(255),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    images TEXT[],
    resolved BOOLEAN DEFAULT FALSE,
    resolution_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    resolved_at TIMESTAMP WITH TIME ZONE
);

-- ============================================
-- REVIEWS & RATINGS
-- ============================================

-- Reviews Table
CREATE TABLE IF NOT EXISTS reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
    reviewer_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    reviewed_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(trip_id, reviewer_id)
);

-- ============================================
-- MESSAGES & NOTIFICATIONS
-- ============================================

-- Conversations Table
CREATE TABLE IF NOT EXISTS conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    participant_1 UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    participant_2 UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    trip_id UUID REFERENCES trips(id) ON DELETE SET NULL,
    last_message_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(participant_1, participant_2)
);

-- Messages Table
CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications Table
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    data JSONB,
    read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_city ON profiles(city);
CREATE INDEX IF NOT EXISTS idx_transporters_user_id ON transporters(user_id);
CREATE INDEX IF NOT EXISTS idx_transporters_verified ON transporters(verified);
CREATE INDEX IF NOT EXISTS idx_vehicles_transporter_id ON vehicles(transporter_id);
CREATE INDEX IF NOT EXISTS idx_vehicles_status ON vehicles(status);
CREATE INDEX IF NOT EXISTS idx_transport_requests_eleveur_id ON transport_requests(eleveur_id);
CREATE INDEX IF NOT EXISTS idx_transport_requests_status ON transport_requests(status);
CREATE INDEX IF NOT EXISTS idx_transport_requests_preferred_date ON transport_requests(preferred_date);
CREATE INDEX IF NOT EXISTS idx_vehicle_availability_transporter_id ON vehicle_availability(transporter_id);
CREATE INDEX IF NOT EXISTS idx_vehicle_availability_vehicle_id ON vehicle_availability(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_vehicle_availability_status ON vehicle_availability(status);
CREATE INDEX IF NOT EXISTS idx_vehicle_availability_dates ON vehicle_availability(available_from, available_until);
CREATE INDEX IF NOT EXISTS idx_trips_transporter_id ON trips(transporter_id);
CREATE INDEX IF NOT EXISTS idx_trips_eleveur_id ON trips(eleveur_id);
CREATE INDEX IF NOT EXISTS idx_trips_status ON trips(status);
CREATE INDEX IF NOT EXISTS idx_trips_start_date ON trips(start_date);
CREATE INDEX IF NOT EXISTS idx_groupage_transporter_id ON groupage(transporter_id);
CREATE INDEX IF NOT EXISTS idx_groupage_status ON groupage(status);
CREATE INDEX IF NOT EXISTS idx_groupage_departure_date ON groupage(departure_date);
CREATE INDEX IF NOT EXISTS idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_messages_sender_id ON messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON notifications(read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);

-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE transporters ENABLE ROW LEVEL SECURITY;
ALTER TABLE vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE transport_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE vehicle_availability ENABLE ROW LEVEL SECURITY;
ALTER TABLE trips ENABLE ROW LEVEL SECURITY;
ALTER TABLE groupage ENABLE ROW LEVEL SECURITY;
ALTER TABLE groupage_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE water_stops ENABLE ROW LEVEL SECURITY;
ALTER TABLE incidents ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist and recreate them
DO $$
BEGIN
    -- Profiles policies
    DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON profiles;
    CREATE POLICY "Public profiles are viewable by everyone" ON profiles
        FOR SELECT USING (true);

    DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;
    CREATE POLICY "Users can update their own profile" ON profiles
        FOR UPDATE USING (auth.uid() = id);

    DROP POLICY IF EXISTS "Users can insert their own profile" ON profiles;
    CREATE POLICY "Users can insert their own profile" ON profiles
        FOR INSERT WITH CHECK (auth.uid() = id);

    -- Transporters policies
    DROP POLICY IF EXISTS "Transporters are viewable by everyone" ON transporters;
    CREATE POLICY "Transporters are viewable by everyone" ON transporters
        FOR SELECT USING (true);

    DROP POLICY IF EXISTS "Users can insert their own transporter profile" ON transporters;
    CREATE POLICY "Users can insert their own transporter profile" ON transporters
        FOR INSERT WITH CHECK (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can update their own transporter profile" ON transporters;
    CREATE POLICY "Users can update their own transporter profile" ON transporters
        FOR UPDATE USING (auth.uid() = user_id);

    -- Vehicles policies
    DROP POLICY IF EXISTS "Vehicles are viewable by everyone" ON vehicles;
    CREATE POLICY "Vehicles are viewable by everyone" ON vehicles
        FOR SELECT USING (true);

    DROP POLICY IF EXISTS "Transporters can manage their own vehicles" ON vehicles;
    CREATE POLICY "Transporters can manage their own vehicles" ON vehicles
        FOR ALL USING (
            transporter_id IN (
                SELECT id FROM transporters WHERE user_id = auth.uid()
            )
        );

    -- Transport Requests policies
    DROP POLICY IF EXISTS "Open transport requests are viewable by everyone" ON transport_requests;
    CREATE POLICY "Open transport requests are viewable by everyone" ON transport_requests
        FOR SELECT USING (status = 'open' OR eleveur_id = auth.uid());

    DROP POLICY IF EXISTS "Éleveurs can create transport requests" ON transport_requests;
    CREATE POLICY "Éleveurs can create transport requests" ON transport_requests
        FOR INSERT WITH CHECK (auth.uid() = eleveur_id);

    DROP POLICY IF EXISTS "Éleveurs can update their own requests" ON transport_requests;
    CREATE POLICY "Éleveurs can update their own requests" ON transport_requests
        FOR UPDATE USING (auth.uid() = eleveur_id);

    -- Vehicle Availability policies
    DROP POLICY IF EXISTS "Vehicle availability is viewable by everyone" ON vehicle_availability;
    CREATE POLICY "Vehicle availability is viewable by everyone" ON vehicle_availability
        FOR SELECT USING (true);

    DROP POLICY IF EXISTS "Transporters can manage their vehicle availability" ON vehicle_availability;
    CREATE POLICY "Transporters can manage their vehicle availability" ON vehicle_availability
        FOR ALL USING (
            transporter_id IN (
                SELECT id FROM transporters WHERE user_id = auth.uid()
            )
        );

    -- Trips policies
    DROP POLICY IF EXISTS "Users can view trips they're involved in" ON trips;
    CREATE POLICY "Users can view trips they're involved in" ON trips
        FOR SELECT USING (
            auth.uid() = eleveur_id OR
            transporter_id IN (SELECT id FROM transporters WHERE user_id = auth.uid())
        );

    DROP POLICY IF EXISTS "Transporters can create trips" ON trips;
    CREATE POLICY "Transporters can create trips" ON trips
        FOR INSERT WITH CHECK (
            transporter_id IN (SELECT id FROM transporters WHERE user_id = auth.uid())
        );

    DROP POLICY IF EXISTS "Trip participants can update trips" ON trips;
    CREATE POLICY "Trip participants can update trips" ON trips
        FOR UPDATE USING (
            auth.uid() = eleveur_id OR
            transporter_id IN (SELECT id FROM transporters WHERE user_id = auth.uid())
        );

    -- Notifications policies
    DROP POLICY IF EXISTS "Users can view their own notifications" ON notifications;
    CREATE POLICY "Users can view their own notifications" ON notifications
        FOR SELECT USING (auth.uid() = user_id);

    DROP POLICY IF EXISTS "Users can update their own notifications" ON notifications;
    CREATE POLICY "Users can update their own notifications" ON notifications
        FOR UPDATE USING (auth.uid() = user_id);

    -- Messages policies
    DROP POLICY IF EXISTS "Users can view their own messages" ON messages;
    CREATE POLICY "Users can view their own messages" ON messages
        FOR SELECT USING (
            conversation_id IN (
                SELECT id FROM conversations
                WHERE participant_1 = auth.uid() OR participant_2 = auth.uid()
            )
        );
END $$;

-- ============================================
-- FUNCTIONS & TRIGGERS
-- ============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop triggers if exist and recreate
DROP TRIGGER IF EXISTS update_profiles_updated_at ON profiles;
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_transporters_updated_at ON transporters;
CREATE TRIGGER update_transporters_updated_at BEFORE UPDATE ON transporters
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_vehicles_updated_at ON vehicles;
CREATE TRIGGER update_vehicles_updated_at BEFORE UPDATE ON vehicles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_transport_requests_updated_at ON transport_requests;
CREATE TRIGGER update_transport_requests_updated_at BEFORE UPDATE ON transport_requests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_vehicle_availability_updated_at ON vehicle_availability;
CREATE TRIGGER update_vehicle_availability_updated_at BEFORE UPDATE ON vehicle_availability
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_trips_updated_at ON trips;
CREATE TRIGGER update_trips_updated_at BEFORE UPDATE ON trips
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_groupage_updated_at ON groupage;
CREATE TRIGGER update_groupage_updated_at BEFORE UPDATE ON groupage
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Rating update function
CREATE OR REPLACE FUNCTION update_user_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE profiles
    SET rating = (
        SELECT AVG(rating)
        FROM reviews
        WHERE reviewed_id = NEW.reviewed_id
    )
    WHERE id = NEW.reviewed_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_rating_after_review ON reviews;
CREATE TRIGGER update_rating_after_review AFTER INSERT ON reviews
    FOR EACH ROW EXECUTE FUNCTION update_user_rating();

-- Groupage capacity function
CREATE OR REPLACE FUNCTION update_groupage_capacity()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE groupage
    SET
        booked_capacity = (
            SELECT COALESCE(SUM(animal_count), 0)
            FROM groupage_participants
            WHERE groupage_id = NEW.groupage_id AND status = 'confirmed'
        ),
        available_capacity = total_capacity - (
            SELECT COALESCE(SUM(animal_count), 0)
            FROM groupage_participants
            WHERE groupage_id = NEW.groupage_id AND status = 'confirmed'
        )
    WHERE id = NEW.groupage_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_capacity_after_participant ON groupage_participants;
CREATE TRIGGER update_capacity_after_participant AFTER INSERT OR UPDATE OR DELETE ON groupage_participants
    FOR EACH ROW EXECUTE FUNCTION update_groupage_capacity();

-- ============================================
-- SUCCESS MESSAGE
-- ============================================

DO $$
BEGIN
    RAISE NOTICE '✅ Mawashi database schema created successfully!';
    RAISE NOTICE '📊 All tables, indexes, policies, and triggers are in place.';
    RAISE NOTICE '🔒 Row Level Security enabled on all tables.';
END $$;
