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
        <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
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
            .row { display: flex; font-size: 18px; margin-bottom: 6px; }
            .cell-ugyszam { width: 120px; font-weight: bold; font-size: 22px; }
            .cell-ugyszam-adat { width: 100%; font-size: 22px; }
            .cell-tanacs { width: 120px; font-weight: bold; font-size: 20px; }
            .cell-tanacs-adat { width: 100%; font-size: 20px; font-size: 20px;}
            .cell-date { width: 120px; font-weight: bold; font-size: 20px;}
            .cell-start { width: 100px; font-weight: bold; font-size: 20px;}
            .cell-end { width: 100px; font-weight: bold; font-size: 20px;}
            .cell-date-adat { width: 120px; font-size: 20px;}
            .cell-start-adat { width: 100px; font-size: 20px;}
            .cell-end-adat { width: 100px; font-size: 20px;}
            .cell-letszam { width: 80px; font-weight: bold; }
            .cell-letszam-adat { width: 40px; }
            .cell-alperes-terhelt { width: 200px; font-weight: bold; }
            .cell-felperes-vadlo { width: 200px; font-weight: bold; }
            .cell-alperes-terhelt-adat { width: 200px; }
            .cell-felperes-vadlo-adat { width: 200px; }
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
        
        -- Use format() for safer SQL generation
        sql_text := sql_text || format(', 
        COALESCE((
            SELECT %L || %L || %L || STRING_AGG(COALESCE(foglalas, ''''), '''') || %L
            FROM rooms 
            WHERE rooms = %L 
              AND date = CURRENT_DATE 
              AND start_time >= (CURRENT_TIME - INTERVAL ''1 hour'')
            HAVING COUNT(*) > 0
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

-- Create the view
SELECT create_foglalas_matrix_view();