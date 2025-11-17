-- ==========================================
-- Update create_foglalas_matrix_view() function only
-- Modify HTML styles here and run this script
-- ==========================================

DROP FUNCTION IF EXISTS create_foglalas_matrix_view() CASCADE;

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

    -- ========================================
    -- 🎨 MODIFY HTML STYLES HERE
    -- ========================================
    
    -- Default HTML (when no bookings)
    default_html := '
    <!DOCTYPE html>
    <html lang="hu">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="refresh" content="600">
        <style>
            body {
                font-family: Arial, sans-serif;
                color: white;                 
                margin: 0;
                padding: 0;
                background-color: #000000;
            }
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
                color: #ffffff;  /* 🎨 White text for black background */
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
    
    -- HTML with bookings
    room_html := '
    <!DOCTYPE html>
    <html lang="hu">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="refresh" content="600">
        <style>
            body {
                font-family: Arial, sans-serif;
                color: black;                 
                margin: 0;
                padding: 0;
                background-color: #ffffffff;
            }            
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
            .row { 
                display: flex; 
                font-size: 20px; 
                margin-bottom: 6px;
                color: #000000ff;  /* 🎨 Default text color */
            }
            .cell-ugyszam { 
                width: 140px; 
                font-weight: bold; 
                font-size: 24px;
                color: #dc3545;;  /* 🎨 Case number color */
            }
            .cell-ugyszam-adat { 
                width: 100%; 
                font-size: 24px;
                color: #dc3545;;  /* 🎨 Case number data color */
            }
            .cell-tanacs { 
                width: 140px; 
                font-weight: bold; 
                font-size: 22px;
                color: #000000ff;  /* 🎨 Council label color */
            }
            .cell-tanacs-adat { 
                width: 100%; 
                font-size: 22px;
                color: #000000ff;  /* 🎨 Council data color */
            }
            .cell-date { 
                width: 140px; 
                font-weight: bold; 
                font-size: 22px;
                color: #dc3545;  /* 🎨 Date label color */
            }
            .cell-start { 
                width: 120px; 
                font-weight: bold; 
                font-size: 22px;
                color: #dc3545;  /* 🎨 Start time label color */
            }
            .cell-end { 
                width: 120px; 
                font-weight: bold; 
                font-size: 22px;
                color: #dc3545;  /* 🎨 End time label color */
            }
            .cell-date-adat { 
                width: 140px; 
                font-size: 22px;
                color: #dc3545;  /* 🎨 Date data color */
            }
            .cell-start-adat { 
                width: 120px; 
                font-size: 22px;
                color: #dc3545;  /* 🎨 Start time data color */
            }
            .cell-end-adat { 
                width: 120px; 
                font-size: 22px;
                color: #dc3545;  /* 🎨 End time data color */
            }
            .cell-letszam { 
                width: 100px; 
                font-weight: bold;
                color: #000000ff;  /* 🎨 Participant count label color */
            }
            .cell-letszam-adat { 
                width: 40px;
                color: #000000ff;  /* 🎨 Participant count data color */
            }
            .cell-alperes-terhelt { 
                width: 240px; 
                font-weight: bold;
                color: #000000ff;  /* 🎨 Defendant label color */
            }
            .cell-felperes-vadlo { 
                width: 240px; 
                font-weight: bold;
                color: #000000ff;  /* 🎨 Plaintiff label color */
            }
            .cell-alperes-terhelt-adat { 
                width: 240px;
                color: #000000ff;  /* 🎨 Defendant data color */
            }
            .cell-felperes-vadlo-adat { 
                width: 240px;
                color: #000000ff;  /* 🎨 Plaintiff data color */
            }
            .cell-targy { 
                width: 80px; 
                font-weight: bold;
                color: #000000ff;  /* 🎨 Subject label color */
            }
            .cell-targy-adat { 
                width: 100%;
                color: #000000ff;  /* 🎨 Subject data color */
            }
            .bold { 
                font-weight: bold; 
            }
        </style>
        <title>';

    -- ========================================
    -- END OF STYLE MODIFICATION SECTION
    -- ========================================

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
-- Apply the changes immediately
-- ==========================================
SELECT create_foglalas_matrix_view();

SELECT 'Function updated and view refreshed successfully!' as status;
