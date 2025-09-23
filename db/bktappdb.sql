-- Set timezone
SET timezone = 'Europe/Budapest';

-- Drop tables if they exist
DROP TABLE IF EXISTS name CASCADE;
DROP TABLE IF EXISTS rooms CASCADE;
DROP TABLE IF EXISTS settings CASCADE;

-- Table: name (user login data)
CREATE TABLE name (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    last_login VARCHAR(255) NOT NULL
);

-- Table: rooms (court reservations)
CREATE TABLE rooms (
    id SERIAL PRIMARY KEY,
    birosag VARCHAR(255) NOT NULL,
    tanacs VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL DEFAULT '16:00:00',
    rooms VARCHAR(255) NOT NULL,
    ugyszam VARCHAR(255) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    letszam INTEGER NOT NULL,
    resztvevok VARCHAR(100) NOT NULL,
    alperes_terhelt VARCHAR(100) NOT NULL,
    felperes_vadlo VARCHAR(100) NOT NULL,
    foglalas VARCHAR(255) NOT NULL,
    UNIQUE(date, rooms, start_time)
);

-- Table: settings (dropdown values)
CREATE TABLE settings (
    id SERIAL PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    value VARCHAR(100) NOT NULL,
    sort_order INTEGER DEFAULT NULL,
    active BOOLEAN DEFAULT NULL
);

-- Insert settings data (ensure no duplicate IDs)
-- ... your INSERT INTO settings ... (as in your file) ...

-- Remove duplicate room entries
DELETE FROM settings s1
USING settings s2
WHERE s1.id > s2.id 
AND s1.category = 'room' 
AND s1.value = s2.value 
AND s1.active = s2.active;

-- Drop functions if they exist (for idempotency)
DROP FUNCTION IF EXISTS create_room_schedule_view() CASCADE;
DROP FUNCTION IF EXISTS create_room_schedule_html_view() CASCADE;
DROP FUNCTION IF EXISTS refresh_room_views() CASCADE;

-- Dynamic room schedule view
CREATE OR REPLACE FUNCTION create_room_schedule_view()
RETURNS void AS $$
DECLARE
    room_record RECORD;
    sql_text TEXT;
BEGIN
    DROP VIEW IF EXISTS room_schedule_view;
    sql_text := 'CREATE VIEW room_schedule_view AS SELECT 
        r.date,
        CASE 
            WHEN EXTRACT(DOW FROM r.date) = 1 THEN ''Hétfő''
            WHEN EXTRACT(DOW FROM r.date) = 2 THEN ''Kedd''
            WHEN EXTRACT(DOW FROM r.date) = 3 THEN ''Szerda''
            WHEN EXTRACT(DOW FROM r.date) = 4 THEN ''Csütörtök''
            WHEN EXTRACT(DOW FROM r.date) = 5 THEN ''Péntek''
            WHEN EXTRACT(DOW FROM r.date) = 6 THEN ''Szombat''
            WHEN EXTRACT(DOW FROM r.date) = 0 THEN ''Vasárnap''
        END as hungarian_day,';
    FOR room_record IN 
        SELECT DISTINCT value 
        FROM settings 
        WHERE category = 'room' AND active = true 
        ORDER BY value
    LOOP
        sql_text := sql_text || '
        STRING_AGG(
            CASE WHEN r.rooms = ''' || room_record.value || ''' THEN 
                TO_CHAR(r.start_time, ''HH24:MI'') || '' - '' || 
                TO_CHAR(r.end_time, ''HH24:MI'') || E''\n'' ||
                ''Foglalás: '' || COALESCE(r.foglalas, '''')
            END, E''\n--- --- ---\n''
        ) AS "' || room_record.value || '",';
    END LOOP;
    sql_text := rtrim(sql_text, ',');
    sql_text := sql_text || '
        COUNT(r.id) as total_bookings,
        MIN(r.start_time) as first_booking,
        MAX(r.end_time) as last_booking
    FROM rooms r
    WHERE r.date >= CURRENT_DATE AND r.date <= CURRENT_DATE + INTERVAL ''30 days''
    GROUP BY r.date
    ORDER BY r.date';
    EXECUTE sql_text;
END;
$$ LANGUAGE plpgsql;

-- Dynamic HTML room schedule view
CREATE OR REPLACE FUNCTION create_room_schedule_html_view()
RETURNS void AS $$
DECLARE
    room_record RECORD;
    sql_text TEXT;
BEGIN
    DROP VIEW IF EXISTS room_schedule_html_view;
    sql_text := 'CREATE VIEW room_schedule_html_view AS SELECT 
        r.date,
        CASE 
            WHEN EXTRACT(DOW FROM r.date) = 1 THEN ''Hétfő''
            WHEN EXTRACT(DOW FROM r.date) = 2 THEN ''Kedd''
            WHEN EXTRACT(DOW FROM r.date) = 3 THEN ''Szerda''
            WHEN EXTRACT(DOW FROM r.date) = 4 THEN ''Csütörtök''
            WHEN EXTRACT(DOW FROM r.date) = 5 THEN ''Péntek''
            WHEN EXTRACT(DOW FROM r.date) = 6 THEN ''Szombat''
            WHEN EXTRACT(DOW FROM r.date) = 0 THEN ''Vasárnap''
        END as hungarian_day,';
    FOR room_record IN 
        SELECT DISTINCT value 
        FROM settings 
        WHERE category = 'room' AND active = true 
        ORDER BY value
    LOOP
        sql_text := sql_text || '
        STRING_AGG(
            CASE WHEN r.rooms = ''' || room_record.value || ''' THEN 
                ''<div style="background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 4px; padding: 8px; margin: 4px 0;">'' ||
                ''<div style="font-weight: bold; color: #495057;">'' || 
                TO_CHAR(r.start_time, ''HH24:MI'') || '' - '' || TO_CHAR(r.end_time, ''HH24:MI'') || ''</div>'' ||
                ''<div style="color: #007bff;">Ügyszám: '' || COALESCE(r.ugyszam, '''') || ''</div>'' ||
                ''<div style="color: #28a745;">Foglalás: '' || COALESCE(r.foglalas, '''') || ''</div>'' ||
                ''</div>''
            END, ''''
        ) AS "' || room_record.value || '",';
    END LOOP;
    sql_text := rtrim(sql_text, ',');
    sql_text := sql_text || '
        COUNT(r.id) as total_bookings
    FROM rooms r
    WHERE r.date >= CURRENT_DATE AND r.date <= CURRENT_DATE + INTERVAL ''14 days''
    GROUP BY r.date
    ORDER BY r.date';
    EXECUTE sql_text;
END;
$$ LANGUAGE plpgsql;

-- Function to refresh views
CREATE OR REPLACE FUNCTION refresh_room_views()
RETURNS void AS $$
BEGIN
    PERFORM create_room_schedule_view();
    PERFORM create_room_schedule_html_view();
END;
$$ LANGUAGE plpgsql;

-- Create the views
SELECT create_room_schedule_view();
SELECT create_room_schedule_html_view();

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_rooms_date ON rooms(date);
CREATE INDEX IF NOT EXISTS idx_rooms_date_rooms ON rooms(date, rooms);
CREATE INDEX IF NOT EXISTS idx_rooms_start_time ON rooms(start_time);
CREATE INDEX IF NOT EXISTS idx_settings_category ON settings(category);
CREATE INDEX IF NOT EXISTS idx_settings_active ON settings(active);
CREATE INDEX IF NOT EXISTS idx_settings_category_active ON settings(category, active);

-- Update sequence values to prevent conflicts
SELECT setval('name_id_seq', COALESCE((SELECT MAX(id) FROM name), 1));
SELECT setval('rooms_id_seq', COALESCE((SELECT MAX(id) FROM rooms), 1));
SELECT setval('settings_id_seq', COALESCE((SELECT MAX(id) FROM settings), 576));