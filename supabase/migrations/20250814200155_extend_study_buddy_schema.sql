-- Location: supabase/migrations/20250814200155_extend_study_buddy_schema.sql
-- Schema Analysis: Extending existing schema (profiles, chat_rooms, messages) for Study Buddy App
-- Integration Type: Partial extension - adding matching system to existing chat functionality
-- Dependencies: Existing profiles table, existing chat_rooms and messages tables

-- 1. Create enhanced enum types for study system
CREATE TYPE public.study_track AS ENUM (
    'class_10', 'class_11', 'class_12',
    'iit_jee_main', 'iit_jee_advanced', 'neet',
    'ugc_net_paper_1', 'ugc_net_cs', 'ugc_net_commerce',
    'ssc_cgl', 'ssc_chsl',
    'engineering_first_year', 'coding_dsa'
);

CREATE TYPE public.study_mode AS ENUM (
    'one_on_one', 'small_group', 'silent_co_study', 'problem_solving'
);

CREATE TYPE public.study_intent AS ENUM (
    'quick_doubts', 'regular_buddy', 'mock_tests', 'notes_exchange'
);

CREATE TYPE public.availability_days AS ENUM (
    'weekdays_only', 'weekends_only', 'both'
);

CREATE TYPE public.time_slot AS ENUM (
    'early_morning', 'morning', 'afternoon', 'evening', 'late_night'
);

CREATE TYPE public.study_language AS ENUM (
    'english', 'hindi', 'bengali', 'marathi', 'tamil', 'telugu', 
    'kannada', 'gujarati', 'urdu'
);

CREATE TYPE public.match_status AS ENUM (
    'pending', 'accepted', 'expired', 'rejected'
);

-- 2. Update existing profiles table with new columns
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS track public.study_track,
ADD COLUMN IF NOT EXISTS subjects text[] DEFAULT '{}',
ADD COLUMN IF NOT EXISTS study_languages public.study_language[] DEFAULT '{}',
ADD COLUMN IF NOT EXISTS geohash text,
ADD COLUMN IF NOT EXISTS lat double precision,
ADD COLUMN IF NOT EXISTS lng double precision,
ADD COLUMN IF NOT EXISTS avatar_url text,
ADD COLUMN IF NOT EXISTS is_anonymous boolean DEFAULT true;

-- 3. Create user preferences table
CREATE TABLE public.user_preferences (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
    study_mode public.study_mode DEFAULT 'one_on_one',
    intent public.study_intent DEFAULT 'regular_buddy',
    languages public.study_language[] DEFAULT '{}',
    days public.availability_days DEFAULT 'both',
    time_slots public.time_slot[] DEFAULT '{}',
    online_only boolean DEFAULT true,
    radius_km integer DEFAULT 25,
    min_compatibility integer DEFAULT 50,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- 4. Create study pools table for matching
CREATE TABLE public.study_pools (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    pool_key text NOT NULL,
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    track public.study_track NOT NULL,
    subjects text[] NOT NULL,
    languages public.study_language[] NOT NULL,
    geohash text,
    intent public.study_intent NOT NULL,
    joined_at timestamptz DEFAULT now(),
    expires_at timestamptz DEFAULT (now() + INTERVAL '2 hours'),
    is_active boolean DEFAULT true
);

-- 5. Create matches table for user connections
CREATE TABLE public.matches (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user1_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    user2_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    compatibility_score integer NOT NULL CHECK (compatibility_score >= 0 AND compatibility_score <= 100),
    status public.match_status DEFAULT 'pending',
    matched_at timestamptz DEFAULT now(),
    expires_at timestamptz DEFAULT (now() + INTERVAL '24 hours'),
    chat_room_id uuid REFERENCES public.chat_rooms(id) ON DELETE SET NULL
);

-- 6. Create essential indexes
CREATE INDEX idx_profiles_track ON public.profiles(track);
CREATE INDEX idx_profiles_geohash ON public.profiles(geohash);
CREATE INDEX idx_profiles_looking_for_match ON public.profiles(is_looking_for_match);

CREATE INDEX idx_user_preferences_user_id ON public.user_preferences(user_id);
CREATE INDEX idx_user_preferences_study_mode ON public.user_preferences(study_mode);

CREATE INDEX idx_study_pools_pool_key ON public.study_pools(pool_key);
CREATE INDEX idx_study_pools_user_id ON public.study_pools(user_id);
CREATE INDEX idx_study_pools_active ON public.study_pools(is_active);
CREATE INDEX idx_study_pools_expires_at ON public.study_pools(expires_at);

CREATE INDEX idx_matches_user1_id ON public.matches(user1_id);
CREATE INDEX idx_matches_user2_id ON public.matches(user2_id);
CREATE INDEX idx_matches_status ON public.matches(status);

-- 7. Enable RLS for new tables
ALTER TABLE public.user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_pools ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;

-- 8. Create RLS policies following Pattern 2 (Simple User Ownership)

-- User preferences policies
CREATE POLICY "users_manage_own_preferences"
ON public.user_preferences
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Study pools policies  
CREATE POLICY "users_manage_own_pools"
ON public.study_pools
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "users_view_active_pools"
ON public.study_pools
FOR SELECT
TO authenticated
USING (is_active = true AND expires_at > now());

-- Matches policies
CREATE POLICY "users_view_own_matches"
ON public.matches
FOR SELECT
TO authenticated
USING (user1_id = auth.uid() OR user2_id = auth.uid());

CREATE POLICY "users_update_own_matches"
ON public.matches
FOR UPDATE
TO authenticated
USING (user1_id = auth.uid() OR user2_id = auth.uid())
WITH CHECK (user1_id = auth.uid() OR user2_id = auth.uid());

-- 9. Create utility functions for matching system

-- Function to calculate compatibility score
CREATE OR REPLACE FUNCTION public.calculate_compatibility(
    user1_track public.study_track,
    user1_subjects text[],
    user1_languages public.study_language[],
    user2_track public.study_track,
    user2_subjects text[],
    user2_languages public.study_language[]
)
RETURNS integer
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    track_score integer := 0;
    subject_score integer := 0;
    language_score integer := 0;
    total_score integer;
BEGIN
    -- Track match (35 points)
    IF user1_track = user2_track THEN
        track_score := 35;
    END IF;
    
    -- Subject overlap (25 points)
    IF array_length(user1_subjects, 1) > 0 AND array_length(user2_subjects, 1) > 0 THEN
        subject_score := LEAST(25, 
            (array_length(ARRAY(SELECT unnest(user1_subjects) INTERSECT SELECT unnest(user2_subjects)), 1) * 25) / 
            GREATEST(array_length(user1_subjects, 1), array_length(user2_subjects, 1))
        );
    END IF;
    
    -- Language overlap (15 points)
    IF array_length(user1_languages, 1) > 0 AND array_length(user2_languages, 1) > 0 THEN
        language_score := LEAST(15,
            (array_length(ARRAY(SELECT unnest(user1_languages) INTERSECT SELECT unnest(user2_languages)), 1) * 15) /
            GREATEST(array_length(user1_languages, 1), array_length(user2_languages, 1))
        );
    END IF;
    
    total_score := track_score + subject_score + language_score;
    
    RETURN LEAST(100, total_score);
END;
$$;

-- Function to generate pool key
CREATE OR REPLACE FUNCTION public.generate_pool_key(
    user_track public.study_track,
    user_geohash text,
    primary_language public.study_language
)
RETURNS text
LANGUAGE plpgsql
STABLE
AS $$
BEGIN
    RETURN user_track::text || '_' || 
           COALESCE(substring(user_geohash, 1, 5), 'global') || '_' || 
           primary_language::text;
END;
$$;

-- Function to clean expired data
CREATE OR REPLACE FUNCTION public.cleanup_expired_data()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Remove expired pool members
    DELETE FROM public.study_pools 
    WHERE expires_at < now() OR is_active = false;
    
    -- Remove expired matches
    UPDATE public.matches 
    SET status = 'expired'
    WHERE expires_at < now() AND status = 'pending';
    
    -- Clean up old expired matches (older than 7 days)
    DELETE FROM public.matches 
    WHERE status = 'expired' AND expires_at < (now() - INTERVAL '7 days');
END;
$$;

-- 10. Create triggers for updated_at columns
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_user_preferences_updated_at 
    BEFORE UPDATE ON public.user_preferences
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 11. Mock data for testing
DO $$
DECLARE
    user1_uuid uuid := '6a4c11fb-5877-4acc-bed6-9975a7da11ee';
    user2_uuid uuid := '68adc0bd-9489-442b-b93e-2407c20d549c';
    user3_uuid uuid := gen_random_uuid();
    user4_uuid uuid := gen_random_uuid();
BEGIN
    -- Create additional test auth users if they don't exist
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (user3_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'arjun@studybuddy.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Arjun Sharma"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, true, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (user4_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'priya@studybuddy.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Priya Patel"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, true, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null)
    ON CONFLICT (id) DO NOTHING;

    -- Update existing profiles with study data
    UPDATE public.profiles SET
        track = 'iit_jee_main'::public.study_track,
        subjects = ARRAY['mathematics', 'physics', 'chemistry'],
        study_languages = ARRAY['english', 'hindi']::public.study_language[],
        geohash = 'u4pru',
        lat = 28.6139,
        lng = 77.2090,
        avatar_url = 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400'
    WHERE user_id = user1_uuid;

    UPDATE public.profiles SET
        track = 'neet'::public.study_track,
        subjects = ARRAY['biology', 'chemistry', 'physics'],
        study_languages = ARRAY['english', 'gujarati']::public.study_language[],
        geohash = 'u4pru',
        lat = 28.6129,
        lng = 77.2100,
        avatar_url = 'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400'
    WHERE user_id = user2_uuid;

    -- Create additional profiles
    INSERT INTO public.profiles (id, user_id, display_name, is_online, track, subjects, study_languages, geohash, lat, lng, avatar_url, preferred_subjects, is_looking_for_match)
    VALUES
        (gen_random_uuid(), user3_uuid, 'Arjun Sharma', true, 'iit_jee_main'::public.study_track, 
         ARRAY['mathematics', 'physics', 'chemistry'], ARRAY['english', 'hindi']::public.study_language[],
         'u4pru', 28.6149, 77.2080, 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400',
         ARRAY['mathematics']::public.study_subject[], true),
        (gen_random_uuid(), user4_uuid, 'Priya Patel', true, 'neet'::public.study_track,
         ARRAY['biology', 'chemistry', 'physics'], ARRAY['english', 'gujarati', 'hindi']::public.study_language[],
         'u4pru', 28.6119, 77.2110, 'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400',
         ARRAY['biology']::public.study_subject[], true);

    -- Create user preferences
    INSERT INTO public.user_preferences (user_id, study_mode, intent, languages, days, time_slots, online_only, radius_km)
    VALUES
        (user1_uuid, 'one_on_one'::public.study_mode, 'regular_buddy'::public.study_intent,
         ARRAY['english', 'hindi']::public.study_language[], 'both'::public.availability_days,
         ARRAY['evening', 'late_night']::public.time_slot[], false, 50),
        (user2_uuid, 'small_group'::public.study_mode, 'mock_tests'::public.study_intent,
         ARRAY['english', 'gujarati']::public.study_language[], 'weekends_only'::public.availability_days,
         ARRAY['morning', 'afternoon']::public.time_slot[], true, 25),
        (user3_uuid, 'problem_solving'::public.study_mode, 'quick_doubts'::public.study_intent,
         ARRAY['english', 'hindi']::public.study_language[], 'both'::public.availability_days,
         ARRAY['evening', 'late_night']::public.time_slot[], false, 30),
        (user4_uuid, 'one_on_one'::public.study_mode, 'notes_exchange'::public.study_intent,
         ARRAY['english', 'gujarati']::public.study_language[], 'weekends_only'::public.availability_days,
         ARRAY['afternoon', 'evening']::public.time_slot[], true, 40);

    -- Create active study pools
    INSERT INTO public.study_pools (pool_key, user_id, track, subjects, languages, geohash, intent)
    VALUES
        (public.generate_pool_key('iit_jee_main'::public.study_track, 'u4pru', 'english'::public.study_language),
         user1_uuid, 'iit_jee_main'::public.study_track, ARRAY['mathematics', 'physics'], 
         ARRAY['english', 'hindi']::public.study_language[], 'u4pru', 'regular_buddy'::public.study_intent),
        (public.generate_pool_key('neet'::public.study_track, 'u4pru', 'english'::public.study_language),
         user2_uuid, 'neet'::public.study_track, ARRAY['biology', 'chemistry'], 
         ARRAY['english', 'gujarati']::public.study_language[], 'u4pru', 'mock_tests'::public.study_intent);

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Mock data insertion failed: %', SQLERRM;
END $$;