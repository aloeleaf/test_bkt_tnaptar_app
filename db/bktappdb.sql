-- ==========================================
-- BKT Naptár Database Schema
-- Budapest Környéki Törvényszék - Court Room Booking System
-- ==========================================

-- Set timezone for the session
SET timezone = 'Europe/Budapest';

-- Drop tables if they exist (for idempotency)
DROP TABLE IF EXISTS login_attempts CASCADE;
DROP TABLE IF EXISTS name CASCADE;
DROP TABLE IF EXISTS rooms CASCADE;
DROP TABLE IF EXISTS settings CASCADE;

-- ==========================================
-- Table: login_attempts (rate limiting & security audit)
-- ✅ NEW: Required for Auth.php rate limiting
-- ==========================================
CREATE TABLE login_attempts (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    success BOOLEAN NOT NULL DEFAULT FALSE,
    attempt_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(45),
    user_agent TEXT
);

-- ==========================================
-- Table: name (user login data)
-- ✅ FIXED: Changed last_login to TIMESTAMP
-- ✅ FIXED: Added UNIQUE constraint inline
-- ==========================================
CREATE TABLE name (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    last_login TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- Table: rooms (court reservations)
-- ==========================================
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
    letszam INTEGER,
    resztvevok VARCHAR(100) NOT NULL,
    alperes_terhelt VARCHAR(100) NOT NULL,
    felperes_vadlo VARCHAR(100) NOT NULL,
    foglalas TEXT NOT NULL,
    UNIQUE(date, rooms, start_time)
);

-- ==========================================
-- Table: settings (dropdown values for UI)
-- ==========================================
CREATE TABLE settings (
    id SERIAL PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    value VARCHAR(100) NOT NULL,
    sort_order INTEGER DEFAULT NULL,
    active BOOLEAN DEFAULT NULL
);

-- =============================================
-- Add basic data to settings table
-- =============================================
INSERT INTO settings (id, category, value, sort_order, active) VALUES
-- Courts
(11, 'birosag', 'Budapest Környéki Törvényszék', 0, TRUE),
(12, 'birosag', 'Érdi Járásbíróság', 0, TRUE),

-- Participant types
(50, 'resztvevok', 'Alperes - Felperes', 0, TRUE),
(51, 'resztvevok', 'Terhelt - Vádló', 0, TRUE),

-- Courtrooms (BKT_A_01T to BKT_A_54T)
(101, 'room', 'BKT_A_01T', 0, TRUE),
(102, 'room', 'BKT_A_02T', 0, TRUE),
(103, 'room', 'BKT_A_03T', 0, TRUE),
(104, 'room', 'BKT_A_04T', 0, TRUE),
(105, 'room', 'BKT_A_05T', 0, TRUE),
(106, 'room', 'BKT_A_06T', 0, TRUE),
(107, 'room', 'BKT_A_07T', 0, TRUE),
(108, 'room', 'BKT_A_08T', 0, TRUE),
(109, 'room', 'BKT_A_09T', 0, TRUE),
(110, 'room', 'BKT_A_10T', 0, TRUE),
(111, 'room', 'BKT_A_11T', 0, TRUE),
(112, 'room', 'BKT_A_12T', 0, TRUE),
(113, 'room', 'BKT_A_13T', 0, TRUE),
(114, 'room', 'BKT_A_14T', 0, TRUE),
(115, 'room', 'BKT_A_15T', 0, TRUE),
(116, 'room', 'BKT_A_16T', 0, TRUE),
(117, 'room', 'BKT_A_17T', 0, TRUE),
(118, 'room', 'BKT_A_18T', 0, TRUE),
(119, 'room', 'BKT_A_19T', 0, TRUE),
(120, 'room', 'BKT_A_20T', 0, TRUE),
(121, 'room', 'BKT_A_21T', 0, TRUE),
(122, 'room', 'BKT_A_22T', 0, TRUE),
(123, 'room', 'BKT_A_23T', 0, TRUE),
(124, 'room', 'BKT_A_24T', 0, TRUE),
(125, 'room', 'BKT_A_25T', 0, TRUE),
(126, 'room', 'BKT_A_26T', 0, TRUE),
(127, 'room', 'BKT_A_27T', 0, TRUE),
(128, 'room', 'BKT_A_28T', 0, TRUE),
(129, 'room', 'BKT_A_29T', 0, TRUE),
(130, 'room', 'BKT_A_30T', 0, TRUE),
(131, 'room', 'BKT_A_31T', 0, TRUE),
(132, 'room', 'BKT_A_32T', 0, TRUE),
(133, 'room', 'BKT_A_33T', 0, TRUE),
(134, 'room', 'BKT_A_34T', 0, TRUE),
(135, 'room', 'BKT_A_35T', 0, TRUE),
(136, 'room', 'BKT_A_36T', 0, TRUE),
(137, 'room', 'BKT_A_37T', 0, TRUE),
(138, 'room', 'BKT_A_38T', 0, TRUE),
(139, 'room', 'BKT_A_39T', 0, TRUE),
(140, 'room', 'BKT_A_40T', 0, TRUE),
(141, 'room', 'BKT_A_41T', 0, TRUE),
(142, 'room', 'BKT_A_42T', 0, TRUE),
(143, 'room', 'BKT_A_43T', 0, TRUE),
(144, 'room', 'BKT_A_44T', 0, TRUE),
(145, 'room', 'BKT_A_45T', 0, TRUE),
(146, 'room', 'BKT_A_46T', 0, TRUE),
(147, 'room', 'BKT_A_47T', 0, TRUE),
(148, 'room', 'BKT_A_48T', 0, TRUE),
(149, 'room', 'BKT_A_49T', 0, TRUE),
(150, 'room', 'BKT_A_50T', 0, TRUE),
(151, 'room', 'BKT_A_51T', 0, TRUE),
(152, 'room', 'BKT_A_52T', 0, TRUE),
(153, 'room', 'BKT_A_53T', 0, TRUE),
(154, 'room', 'BKT_A_54T', 0, TRUE),
(200, 'room', 'BKT_B_01T', 0, TRUE),

-- Councils
(300, 'tanacs', 'dr. Szente László', 0, TRUE);

-- Remove duplicate room entries from settings
DELETE FROM settings s1
USING settings s2
WHERE s1.id > s2.id 
AND s1.category = 'room' 
AND s1.value = s2.value 
AND s1.active = s2.active;

-- ==========================================
-- Drop functions if they exist (for idempotency)
-- ==========================================
DROP FUNCTION IF EXISTS cleanup_old_login_attempts() CASCADE;
DROP FUNCTION IF EXISTS create_room_schedule_view() CASCADE;
DROP FUNCTION IF EXISTS create_room_schedule_html_view() CASCADE;
DROP FUNCTION IF EXISTS create_foglalas_matrix_view() CASCADE;
DROP FUNCTION IF EXISTS refresh_room_views() CASCADE;
DROP FUNCTION IF EXISTS refresh_foglalas_matrix_on_room_change() CASCADE;

-- ==========================================
-- Function: cleanup_old_login_attempts
-- ✅ NEW: Cleanup old login attempt records
-- ==========================================
CREATE OR REPLACE FUNCTION cleanup_old_login_attempts()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM login_attempts 
    WHERE attempt_time < NOW() - INTERVAL '30 days';
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RAISE NOTICE 'Deleted % old login attempts', deleted_count;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- Function: create_room_schedule_view
-- Dynamic room schedule view (text summary)
-- ==========================================
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
    -- Add aggregate columns before removing the trailing comma
    sql_text := sql_text || '
        COUNT(r.id) as total_bookings,
        MIN(r.start_time) as first_booking,
        MAX(r.end_time) as last_booking';
    -- Remove the last comma if present
    sql_text := rtrim(sql_text, ',');
    sql_text := sql_text || '
    FROM rooms r
    WHERE r.date >= CURRENT_DATE AND r.date <= CURRENT_DATE + INTERVAL ''30 days''
    GROUP BY r.date
    ORDER BY r.date';
    EXECUTE sql_text;
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- Function: create_room_schedule_html_view
-- Dynamic HTML room schedule view (HTML summary)
-- ==========================================
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
    -- Add a column for each active room with HTML formatting        
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
    -- Add aggregate column before removing the trailing comma
    sql_text := sql_text || '
        COUNT(r.id) as total_bookings';
    sql_text := rtrim(sql_text, ',');
    sql_text := sql_text || '
    FROM rooms r
    WHERE r.date >= CURRENT_DATE AND r.date <= CURRENT_DATE + INTERVAL ''14 days''
    GROUP BY r.date
    ORDER BY r.date';
    EXECUTE sql_text;
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- Function: create_foglalas_matrix_view
-- Dynamic HTML matrix view for LG SuperSign (full HTML document per cell)
-- ==========================================
CREATE OR REPLACE FUNCTION create_foglalas_matrix_view()
RETURNS void AS $$
DECLARE
    room_record RECORD;
    sql_text TEXT;
    room_count INTEGER := 0;
    default_html TEXT;
    room_html TEXT;
BEGIN
    DROP VIEW IF EXISTS foglalas_matrix_view CASCADE;

    -- Prepare HTML templates as variables (safer than inline)
    default_html := '
    <!DOCTYPE html>
    <html lang="hu">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="refresh" content="600">
        <style>
            .foglalas {
                border: 1px solid #ccc;
                border-radius: 6px;
                padding: 10px;
                font-size: 16px;
                width: 100%;
                box-sizing: border-box;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
            }
            .info {
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 62px;
                font-weight: bold;
                text-align: center;
                margin: 40px 0;
            }  
        </style>
        <title>TÁRGYALÓ</title>
    </head>
    <body>
        <div class="info">NINCS TÁRGYALÁS</div>
    </body>
    </html>';
    
    room_html := '
    <!DOCTYPE html>
    <html lang="hu">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="refresh" content="600">
        <style>
            .foglalas {
                border: 1px solid #ccc;
                border-radius: 6px;
                padding: 10px;
                font-size: 16px;
                width: 100%;
                box-sizing: border-box;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
            }
            .info {
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 62px;
                font-weight: bold;
                text-align: center;
                margin: 40px 0;
            }        
            .row { display: flex; font-size: 20px; margin-bottom: 6px; }
            .cell-ugyszam { width: 140px; font-weight: bold; font-size: 24px; }
            .cell-ugyszam-adat { width: 100%; font-size: 24px; }
            .cell-tanacs { width: 140px; font-weight: bold; font-size: 22px; }
            .cell-tanacs-adat { width: 100%; font-size: 22px; }
            .cell-date { width: 140px; font-weight: bold; font-size: 22px; }
            .cell-start { width: 120px; font-weight: bold; font-size: 22px; }
            .cell-end { width: 120px; font-weight: bold; font-size: 22px; }
            .cell-date-adat { width: 140px; font-size: 22px; }
            .cell-start-adat { width: 120px; font-size: 22px; }
            .cell-end-adat { width: 120px; font-size: 22px; }
            .cell-letszam { width: 100px; font-weight: bold; }
            .cell-letszam-adat { width: 40px; }
            .cell-alperes-terhelt { width: 240px; font-weight: bold; }
            .cell-felperes-vadlo { width: 240px; font-weight: bold; }
            .cell-alperes-terhelt-adat { width: 240px; }
            .cell-felperes-vadlo-adat { width: 240px; }
            .cell-targy { width: 80px; font-weight: bold; }
            .cell-targy-adat { width: 100%; }
            .bold { font-weight: bold; }
        </style>
        <title>';

    -- Start building the query
    sql_text := 'CREATE VIEW foglalas_matrix_view AS SELECT CURRENT_DATE as date';

    -- Add a column for each active room
    FOR room_record IN 
        SELECT value FROM settings WHERE category = 'room' AND active = true ORDER BY value
    LOOP
        room_count := room_count + 1;
        
        -- Use format() for safer SQL generation with proper ordering and limit
        sql_text := sql_text || format(', 
        COALESCE((
            SELECT %L || %L || %L || STRING_AGG(foglalas, '''' ORDER BY start_time) || %L
            FROM (
                SELECT foglalas, start_time
                FROM rooms 
                WHERE rooms = %L 
                  AND date = CURRENT_DATE 
                  AND end_time >= (CURRENT_TIME - INTERVAL ''1 hour'')
                ORDER BY start_time
                LIMIT 5
            ) limited_rooms
            WHERE foglalas IS NOT NULL
        ), %L) AS %I',
        room_html, -- HTML start
        room_record.value, -- title
        '</title></head><body>', -- HTML middle
        '</body></html>', -- HTML end
        room_record.value, -- room filter
        default_html, -- fallback HTML
        room_record.value -- column name
        );
    END LOOP;

    -- Only create view if we have rooms
    IF room_count > 0 THEN
        EXECUTE sql_text;
        RAISE NOTICE 'foglalas_matrix_view created successfully with % rooms', room_count;
    ELSE
        RAISE NOTICE 'No active rooms found, creating minimal view';
        EXECUTE 'CREATE VIEW foglalas_matrix_view AS SELECT CURRENT_DATE as date, ''No rooms configured'' as status';
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error creating foglalas_matrix_view: %', SQLERRM;
        -- Create a fallback view so the system doesn't break
        BEGIN
            EXECUTE 'CREATE VIEW foglalas_matrix_view AS SELECT CURRENT_DATE as date, ''Error creating view'' as error_message';
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Failed to create fallback view: %', SQLERRM;
        END;
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- Function: refresh_foglalas_matrix_on_room_change
-- Trigger to auto-refresh foglalas_matrix_view when rooms change
-- ==========================================
CREATE OR REPLACE FUNCTION refresh_foglalas_matrix_on_room_change()
RETURNS TRIGGER AS $$
BEGIN
    -- Only refresh if the change is related to rooms
    IF (TG_OP = 'DELETE' AND OLD.category = 'room') OR
       (TG_OP IN ('INSERT', 'UPDATE') AND NEW.category = 'room') THEN
        
        -- Call the function to recreate the view
        PERFORM create_foglalas_matrix_view();
        
        RAISE NOTICE 'foglalas_matrix_view refreshed due to room change (operation: %)', TG_OP;
    END IF;
    
    -- Return appropriate value based on operation
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Drop trigger if exists
DROP TRIGGER IF EXISTS trigger_refresh_foglalas_matrix ON settings;

-- Create trigger on settings table
CREATE TRIGGER trigger_refresh_foglalas_matrix
AFTER INSERT OR UPDATE OR DELETE ON settings
FOR EACH ROW
EXECUTE FUNCTION refresh_foglalas_matrix_on_room_change();

-- ==========================================
-- Function: refresh_room_views
-- Utility: Refresh all views
-- ==========================================
CREATE OR REPLACE FUNCTION refresh_room_views()
RETURNS void AS $$
BEGIN
    PERFORM create_room_schedule_view();
    PERFORM create_room_schedule_html_view();
    PERFORM create_foglalas_matrix_view();
    RAISE NOTICE 'All room views refreshed successfully';
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- Create the initial views
-- ==========================================
SELECT create_room_schedule_view();
SELECT create_room_schedule_html_view();
SELECT create_foglalas_matrix_view();

-- ==========================================
-- Indexes for performance
-- ==========================================
-- login_attempts indexes
CREATE INDEX IF NOT EXISTS idx_login_attempts_username_time ON login_attempts(username, attempt_time);
CREATE INDEX IF NOT EXISTS idx_login_attempts_time ON login_attempts(attempt_time);
CREATE INDEX IF NOT EXISTS idx_login_attempts_ip ON login_attempts(ip_address);

-- rooms indexes
CREATE INDEX IF NOT EXISTS idx_rooms_date ON rooms(date);
CREATE INDEX IF NOT EXISTS idx_rooms_date_rooms ON rooms(date, rooms);
CREATE INDEX IF NOT EXISTS idx_rooms_start_time ON rooms(start_time);

-- settings indexes
CREATE INDEX IF NOT EXISTS idx_settings_category ON settings(category);
CREATE INDEX IF NOT EXISTS idx_settings_active ON settings(active);
CREATE INDEX IF NOT EXISTS idx_settings_category_active ON settings(category, active);

-- ==========================================
-- Update sequence values to prevent conflicts
-- ==========================================
SELECT setval('login_attempts_id_seq', COALESCE((SELECT MAX(id) FROM login_attempts), 1));
SELECT setval('name_id_seq', COALESCE((SELECT MAX(id) FROM name), 1));
SELECT setval('rooms_id_seq', COALESCE((SELECT MAX(id) FROM rooms), 1));
SELECT setval('settings_id_seq', COALESCE((SELECT MAX(id) FROM settings), 576));

-- ==========================================
-- Log completion
-- ==========================================
DO $$
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'BKT Naptár Database Schema Created';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Tables:';
    RAISE NOTICE '  ✅ login_attempts (NEW - rate limiting)';
    RAISE NOTICE '  ✅ name (FIXED - TIMESTAMP for last_login)';
    RAISE NOTICE '  ✅ rooms';
    RAISE NOTICE '  ✅ settings';
    RAISE NOTICE 'Views:';
    RAISE NOTICE '  ✅ room_schedule_view';
    RAISE NOTICE '  ✅ room_schedule_html_view';
    RAISE NOTICE '  ✅ foglalas_matrix_view';
    RAISE NOTICE 'Functions:';
    RAISE NOTICE '  ✅ cleanup_old_login_attempts (NEW)';
    RAISE NOTICE '  ✅ create_room_schedule_view';
    RAISE NOTICE '  ✅ create_room_schedule_html_view';
    RAISE NOTICE '  ✅ create_foglalas_matrix_view';
    RAISE NOTICE '  ✅ refresh_foglalas_matrix_on_room_change';
    RAISE NOTICE '  ✅ refresh_room_views';
    RAISE NOTICE 'Triggers:';
    RAISE NOTICE '  ✅ trigger_refresh_foglalas_matrix';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Database ready for use!';
    RAISE NOTICE '========================================';
END $$;