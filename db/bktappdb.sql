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
(1, 'birosag', 'Budapest Környéki Törvényszék', 0, true),
(2, 'resztvevok', 'Alperes - Felperes', 0, true),
(3, 'resztvevok', 'Terhelt - Vádló', 0, true),
(4, 'room', 'BKT_A_01T', 0, true),
(5, 'room', 'BKT_A_02T', 0, true),
(6, 'room', 'BKT_A_03T', 0, true),
(7, 'room', 'BKT_A_04T', 0, true),
(8, 'room', 'BKT_A_05T', 0, true),
(9, 'room', 'BKT_A_06T', 0, true),
(10, 'room', 'BKT_A_07T', 0, true),
(11, 'room', 'BKT_A_08T', 0, true),
(12, 'room', 'BKT_A_09T', 0, true),
(13, 'room', 'BKT_A_10T', 0, true),
(14, 'room', 'BKT_A_11T', 0, true),
(15, 'room', 'BKT_A_12T', 0, true),
(16, 'room', 'BKT_A_13T', 0, true),
(17, 'room', 'BKT_A_14T', 0, true),
(18, 'room', 'BKT_A_15T', 0, true),
(19, 'room', 'BKT_A_16T', 0, true),
(20, 'room', 'BKT_A_17T', 0, true),
(21, 'room', 'BKT_A_18T', 0, true),
(22, 'room', 'BKT_A_19T', 0, true),
(23, 'room', 'BKT_A_20T', 0, true),
(24, 'room', 'BKT_A_21T', 0, true),
(25, 'room', 'BKT_A_22T', 0, true),
(26, 'room', 'BKT_A_23T', 0, true),
(27, 'room', 'BKT_A_24T', 0, true),
(28, 'room', 'BKT_A_25T', 0, true),
(29, 'room', 'BKT_A_26T', 0, true),
(30, 'room', 'BKT_A_27T', 0, true),
(31, 'room', 'BKT_A_28T', 0, true),
(32, 'room', 'BKT_A_29T', 0, true),
(33, 'room', 'BKT_A_30T', 0, true),
(34, 'room', 'BKT_A_31T', 0, true),
(35, 'room', 'BKT_A_32T', 0, true),
(36, 'room', 'BKT_A_33T', 0, true),
(37, 'room', 'BKT_A_34T', 0, true),
(38, 'room', 'BKT_A_35T', 0, true),
(39, 'room', 'BKT_A_36T', 0, true),
(40, 'room', 'BKT_A_37T', 0, true),
(41, 'room', 'BKT_A_38T', 0, true),
(42, 'room', 'BKT_A_39T', 0, true),
(43, 'room', 'BKT_A_40T', 0, true),
(44, 'room', 'BKT_A_41T', 0, true),
(45, 'room', 'BKT_A_42T', 0, true),
(46, 'room', 'BKT_A_43T', 0, true),
(47, 'room', 'BKT_A_44T', 0, true),
(48, 'room', 'BKT_A_45T', 0, true),
(49, 'room', 'BKT_A_46T', 0, true),
(50, 'room', 'BKT_A_47T', 0, true),
(51, 'room', 'BKT_A_48T', 0, true),
(52, 'room', 'BKT_A_49T', 0, true),
(53, 'room', 'BKT_A_50T', 0, true),
(54, 'room', 'BKT_A_51T', 0, true),
(55, 'room', 'BKT_A_52T', 0, true),
(56, 'room', 'BKT_A_53T', 0, true),
(57, 'room', 'BKT_A_54T', 0, true),
(58, 'room', 'BKT_B_01T', 0, true),
(59, 'tanacs', 'Csedrekiné dr. Tóth Boglárka', 1, true),
(60, 'tanacs', 'Danyiné dr. Borsy Edit', 1, true),
(61, 'tanacs', 'Dénesiné dr. Tóth Ildikó', 1, true),
(62, 'tanacs', 'dr. Bartal Mónika', 1, true),
(63, 'tanacs', 'dr. Ajtay-Horváth Viola', 1, true),
(64, 'tanacs', 'dr. Antal Ildikó', 1, true),
(65, 'tanacs', 'dr. Aszódi László', 1, true),
(66, 'tanacs', 'dr. Bacsa Andrea', 1, true),
(67, 'tanacs', 'dr. Benedek Ibolya', 1, true),
(68, 'tanacs', 'dr. Bene Enikő Inge', 1, true),
(69, 'tanacs', 'dr. Beszterczeyné dr. Benedek Tímea', 1, true),
(70, 'tanacs', 'dr. Bicskey Eszter', 1, true),
(71, 'tanacs', 'dr. Bodnárné dr. Kolozsy Andrea', 1, true),
(72, 'tanacs', 'dr. Bogdán Viola', 1, true),
(73, 'tanacs', 'dr. Bozsó Péter', 1, true),
(74, 'tanacs', 'dr. Butyka Mária', 1, true),
(75, 'tanacs', 'dr. Cserháti-Tóth Edina', 1, true),
(76, 'tanacs', 'dr. Csőre Eszter', 1, true),
(77, 'tanacs', 'dr. Dávid Irén', 1, true),
(78, 'tanacs', 'dr. Dénesi András Marcell', 1, true),
(79, 'tanacs', 'dr. Diós Erzsébet', 1, true),
(80, 'tanacs', 'dr. Domonkos Gyöngyi', 1, true),
(81, 'tanacs', 'dr. Dudás Lilian', 1, true),
(82, 'tanacs', 'dr. Dvoracsek-Kutasi Dorottya', 1, true),
(83, 'tanacs', 'dr. Erdős András', 1, true),
(84, 'tanacs', 'dr. Fazekas Ágnes', 1, true),
(85, 'tanacs', 'dr. Fehérné dr. Gaál  Tünde', 1, true),
(86, 'tanacs', 'dr. Fejős Gabriella', 1, true),
(87, 'tanacs', 'dr. Fekete-Molnár Orsolya', 1, true),
(88, 'tanacs', 'dr. Félegyházy Megyesy Fatime', 1, true),
(89, 'tanacs', 'dr. Fördős István', 1, true),
(90, 'tanacs', 'dr. Gáspár Zsófia', 1, true),
(91, 'tanacs', 'Garáné dr. Horváth Diána', 1, true),
(92, 'tanacs', 'dr. Gerber Tamás', 1, true),
(93, 'tanacs', 'dr. Grassalkovits Irén', 1, true),
(94, 'tanacs', 'dr. Greskó Judit', 1, true),
(95, 'tanacs', 'dr. Gulyás Márta', 1, true),
(96, 'tanacs', 'dr. Győrffy Katalin', 1, true),
(97, 'tanacs', 'dr. György Mária', 1, true),
(98, 'tanacs', 'dr. Hajdu Csaba', 1, true),
(99, 'tanacs', 'Hargitainé dr. Iharos Ágnes', 1, true),
(100, 'tanacs', 'dr. Helmeczy Zsófia', 1, true),
(101, 'tanacs', 'dr. Herczeg Margit Márta', 1, true),
(102, 'tanacs', 'dr. Hermann Zsófia', 1, true),
(103, 'tanacs', 'dr. Hilbert Edit', 1, true),
(104, 'tanacs', 'dr. Holdampf Gusztáv', 1, true),
(105, 'tanacs', 'dr. Horányi Cintia', 1, true),
(106, 'tanacs', 'Ila Tóthné dr. Vörös Erika', 1, true),
(107, 'tanacs', 'Jakabné dr. Sándor Nóra', 1, true),
(108, 'tanacs', 'dr. Jobbágy János', 1, true),
(109, 'tanacs', 'dr. Joós Judit', 1, true),
(110, 'tanacs', 'dr. Káldy Péter', 1, true),
(111, 'tanacs', 'dr. Kardos Gyula', 1, true),
(112, 'tanacs', 'Katonáné dr. Gombos Ilona', 1, true),
(113, 'tanacs', 'dr. Katona Rita', 1, true),
(114, 'tanacs', 'dr. Kenese Attila', 1, true),
(115, 'tanacs', 'dr. Kertész Szilvia', 1, true),
(116, 'tanacs', 'dr. Keszthelyi Alajos', 1, true),
(117, 'tanacs', 'dr. Keszthelyi Bernadett', 1, true),
(118, 'tanacs', 'dr. Keyha Ádám', 1, true),
(119, 'tanacs', 'dr. Kiss Georgina', 1, true),
(120, 'tanacs', 'dr. Kiss Sándor', 1, true),
(121, 'tanacs', 'dr. Konkoly Marianna', 1, true),
(122, 'tanacs', 'dr. Kovács Balázs', 1, true),
(123, 'tanacs', 'dr. Kövesdi Gergely Mihály', 1, true),
(124, 'tanacs', 'dr. Krajnyák Erika', 1, true),
(125, 'tanacs', 'dr. Krátky Ákos', 1, true),
(126, 'tanacs', 'dr. Króneisz Gábor', 1, true),
(127, 'tanacs', 'dr. Kun Mariann', 1, true),
(128, 'tanacs', 'Kuruczné dr. Jankovics Anna', 1, true),
(129, 'tanacs', 'Labanczné dr. Ficsór Adél', 1, true),
(130, 'tanacs', 'dr. Laki Zita', 1, true),
(131, 'tanacs', 'dr. Laky Edit Anita', 1, true),
(132, 'tanacs', 'dr. Langmáhr Nóra', 1, true),
(133, 'tanacs', 'dr. Lehmann Zoltán', 1, true),
(134, 'tanacs', 'dr. Lejer Barbara', 1, true),
(135, 'tanacs', 'dr. Leszák Andrea', 1, true),
(136, 'tanacs', 'dr. Liptai Andrea', 1, true),
(137, 'tanacs', 'dr. Litke Ágota', 1, true),
(138, 'tanacs', 'dr. Lóránt István', 1, true),
(139, 'tanacs', 'dr. Lukácsi Beáta', 1, true),
(140, 'tanacs', 'dr. Magyar Viktória', 1, true),
(141, 'tanacs', 'dr. Maschl Ildikó', 1, true),
(142, 'tanacs', 'dr. Minya Krisztián', 1, true),
(143, 'tanacs', 'Muriné dr. Tóth Mária', 1, true),
(144, 'tanacs', 'dr. Nagy Gábor', 1, true),
(145, 'tanacs', 'dr. Németh Erika', 1, true),
(146, 'tanacs', 'dr. Németh Renáta', 1, true),
(147, 'tanacs', 'dr. Németh Zoltán', 1, true),
(148, 'tanacs', 'Nyáregyháziné dr. Sánta Emese', 1, true),
(149, 'tanacs', 'dr. Oláh Anita', 1, true),
(150, 'tanacs', 'dr. Oláh Gaszton', 1, true),
(151, 'tanacs', 'dr. Opóczky László', 1, true),
(152, 'tanacs', 'dr. Oszterhuber Réka', 1, true),
(153, 'tanacs', 'Paisné dr. Kolozsvári Ágnes', 1, true),
(154, 'tanacs', 'dr. Palásti  Sándor', 1, true),
(155, 'tanacs', 'dr. Pásztor Csaba', 1, true),
(156, 'tanacs', 'dr. Pesti Zsuzsanna', 1, true),
(157, 'tanacs', 'dr. Pintér Mária', 1, true),
(158, 'tanacs', 'dr. Pleszkáts Anikó', 1, true),
(159, 'tanacs', 'dr. Pokorny Gabriella', 1, true),
(160, 'tanacs', 'Polgárné dr. Vida Judit', 1, true),
(161, 'tanacs', 'dr. Rabb Zsuzsánna Mária', 1, true),
(162, 'tanacs', 'dr. Rada Krisztina', 1, true),
(163, 'tanacs', 'dr. Radnóti-Farkas Fatime', 1, true),
(164, 'tanacs', 'dr. Ribárszki Erzsébet Éva', 1, true),
(165, 'tanacs', 'dr. Rozgonyi-Wurst Katalin', 1, true),
(166, 'tanacs', 'dr. Ruff Edit', 1, true),
(167, 'tanacs', 'dr. Rusznák Anita', 1, true),
(168, 'tanacs', 'dr. Ruszinkó Judit', 1, true),
(169, 'tanacs', 'dr. Sági Zsuzsanna', 1, true),
(170, 'tanacs', 'dr. Sághi Rita', 1, true),
(171, 'tanacs', 'dr. Sándor Valter Pál', 1, true),
(172, 'tanacs', 'dr. Simon Judit', 1, true),
(173, 'tanacs', 'dr. Skrabski Luca', 1, true),
(174, 'tanacs', 'dr. Smuk Anna', 1, true),
(175, 'tanacs', 'Spiegelbergerné dr. Pofonka Mariann', 1, true),
(176, 'tanacs', 'dr. Stráhl Zita', 1, true),
(177, 'tanacs', 'dr. Stubeczky Sarolta', 1, true),
(178, 'tanacs', 'dr. Szabó Anikó', 1, true),
(179, 'tanacs', 'dr. Szabó Annamária', 1, true),
(180, 'tanacs', 'dr. Szabolcsi-Varga Krisztina', 1, true),
(181, 'tanacs', 'dr. Szalay Csaba', 1, true),
(182, 'tanacs', 'dr. Szegedi Gyöngyvér', 1, true),
(183, 'tanacs', 'dr. Szente László', 1, true),
(184, 'tanacs', 'dr. Szigeti Krisztina', 1, true),
(185, 'tanacs', 'dr. Szikszai Anett', 1, true),
(186, 'tanacs', 'dr. Szincsák-Szászi Judit', 1, true),
(187, 'tanacs', 'dr. Szivák József', 1, true),
(188, 'tanacs', 'dr. Szomszéd Éva', 1, true),
(189, 'tanacs', 'dr. Tarjányi Márta', 1, true),
(190, 'tanacs', 'dr. Tergalecz Eszter', 1, true),
(191, 'tanacs', 'dr. Tihanyi Emma Ágnes', 1, true),
(192, 'tanacs', 'dr. Tiszavölgyi Gyöngyvér', 1, true),
(193, 'tanacs', 'dr. Tóth Éva Rita', 1, true),
(194, 'tanacs', 'dr. Tóth Zsófia Judit', 1, true),
(195, 'tanacs', 'dr. Turu Olga', 1, true),
(196, 'tanacs', 'dr. Urbán-Kiss Andrea', 1, true),
(197, 'tanacs', 'Vámosiné dr. Marunák Ágnes', 1, true),
(198, 'tanacs', 'dr. Varga Dóra', 1, true),
(199, 'tanacs', 'dr. Varga Márta', 1, true),
(200, 'tanacs', 'Vargáné dr. Erdődi Ágnes', 1, true),
(201, 'tanacs', 'dr. Váry Viktória Ildikó', 1, true),
(202, 'tanacs', 'dr. Vida-Szabó Katalin Boglárka', 1, true),
(203, 'tanacs', 'dr. Windecker Erika', 1, true),
(204, 'tanacs', 'dr. Zsáky Mária Zsuzsanna', 1, true),
(205, 'tanacs', 'dr. Zsálek Henriett', 1, true),
(206, 'tanacs', 'dr. Kasnyik Adrienn', 1, true),
(207, 'tanacs', 'dr. Barnóczki-Elsasser Endre', 1, true),
(208, 'tanacs', 'dr. Bóka Mária', 1, true),
(209, 'tanacs', 'dr. Csontos Dániel', 1, true),
(210, 'tanacs', 'dr. Geiger Cecília', 1, true),
(211, 'tanacs', 'dr. Hajdu Koppány', 1, true),
(212, 'tanacs', 'dr. Hortobágyi-Balázs Anett', 1, true),
(213, 'tanacs', 'dr. Horváth Elvira', 1, true),
(214, 'tanacs', 'dr. Huber Zsuzsanna', 1, true),
(215, 'tanacs', 'Illyésné dr. Lantos Emőke', 1, true),
(216, 'tanacs', 'dr. Imre Péter', 1, true),
(217, 'tanacs', 'dr. Kiss Krisztina', 1, true),
(218, 'tanacs', 'Koósné dr. Berecz Krisztina', 1, true),
(219, 'tanacs', 'dr. Kreisz Anita', 1, true),
(220, 'tanacs', 'Lugosiné dr. László Mónika', 1, true),
(221, 'tanacs', 'dr. Miczán Péter', 1, true),
(222, 'tanacs', 'dr. Niklai Zoltán', 1, true),
(223, 'tanacs', 'dr. Piti Sándor', 1, true),
(224, 'tanacs', 'dr. Smid Erika', 1, true),
(225, 'tanacs', 'dr. Szita Natasa', 1, true),
(226, 'tanacs', 'dr. Takács-Tóth Tímea', 1, true),
(227, 'tanacs', 'dr. Takácsné dr. Éles Anita', 1, true),
(228, 'tanacs', 'dr. Tantalics Gabriella', 1, true),
(229, 'tanacs', 'dr. Vágó Veronika Zsófia', 1, true),
(230, 'tanacs', 'dr. Varga Erzsébet', 1, true),
(231, 'tanacs', 'dr. Váry Viktória', 1, true),
(232, 'tanacs', 'dr. Veszprémi  Ágnes', 1, true),
(233, 'birosag', 'Budakörnyéki Járásbíróság', 0, true);

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
                color: #dc3545;  /* 🎨 Case number color */
            }
            .cell-ugyszam-adat { 
                width: 100%; 
                font-size: 24px;
                color: #dc3545;  /* 🎨 Case number data color */
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
SELECT setval('settings_id_seq', COALESCE((SELECT MAX(id) FROM settings), 1));

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