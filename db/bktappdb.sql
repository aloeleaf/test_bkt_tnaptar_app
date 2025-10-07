-- Set timezone for the session
SET timezone = 'Europe/Budapest';

-- Drop tables if they exist (for idempotency)
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
    letszam INTEGER,
    resztvevok VARCHAR(100) NOT NULL,
    alperes_terhelt VARCHAR(100) NOT NULL,
    felperes_vadlo VARCHAR(100) NOT NULL,
    foglalas TEXT NOT NULL,
    UNIQUE(date, rooms, start_time)
);

-- Table: settings (dropdown values for UI)
CREATE TABLE settings (
    id SERIAL PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    value VARCHAR(100) NOT NULL,
    sort_order INTEGER DEFAULT NULL,
    active BOOLEAN DEFAULT NULL
);


-- =============================================
-- Add basic datas to settings and rooms tables
-- =============================================
INSERT INTO settings (id, category, value, sort_order, active) VALUES
(11, 'birosag', 'Budapest Környéki Törvényszék', 0, TRUE),
(12, 'birosag', 'Érdi Járásbíróság', 0, TRUE),
(31, 'resztvevok', 'Alperes - Felperes', 0, TRUE),
(32, 'resztvevok', 'Terhelt - Vádló', 0, TRUE),
(40, 'room', 'BKT_A_01T', 0, TRUE),
(41, 'room', 'BKT_A_02T', 0, TRUE),
(42, 'room', 'BKT_A_03T', 0, TRUE),
(43, 'room', 'BKT_A_04T', 0, TRUE),
(44, 'room', 'BKT_A_10T', 0, TRUE),
(45, 'room', 'BKT_A_11T', 0, TRUE),
(46, 'room', 'BKT_A_12T', 0, TRUE),
(47, 'room', 'BKT_A_15T', 0, TRUE),
(48, 'room', 'BKT_A_16T', 0, TRUE),
(49, 'room', 'BKT_A_17T', 0, TRUE),
(50, 'room', 'BKT_A_18T', 0, TRUE),
(51, 'room', 'BKT_A_19T', 0, TRUE),
(52, 'room', 'BKT.B.01T', 0, TRUE),
(53, 'room', 'BKT_A_28T', 0, TRUE),
(54, 'room', 'BKT_A_29T', 0, TRUE),
(55, 'room', 'BKT_A_51T', 0, TRUE),
(56, 'room', 'BKT_A_52T', 0, TRUE),
(57, 'room', 'BKT_A_54T', 0, TRUE),
(58, 'room', 'BKT_A_20T', 0, TRUE),
(59, 'room', 'BKT_A_21T', 0, TRUE),
(60, 'room', 'BKT_A_22T', 0, TRUE),
(61, 'room', 'BKT_A_23T', 0, TRUE),
(62, 'room', 'BKT_A_24T', 0, TRUE),
(63, 'room', 'BKT_A_25T', 0, TRUE),
(64, 'room', 'BKT_A_35T', 0, TRUE),
(65, 'room', 'BKT_A_26T', 0, TRUE),
(66, 'room', 'BKT_A_27T', 0, TRUE),
(67, 'room', 'BKT_A_30T', 0, TRUE),
(68, 'room', 'BKT_A_32T', 0, TRUE),
(69, 'room', 'BKT_A_34T', 0, TRUE),
(70, 'room', 'BKT_A_39T', 0, TRUE),
(71, 'room', 'BKT_A_40T', 0, TRUE),
(72, 'room', 'BKT_A_42T', 0, TRUE),
(73, 'room', 'BKT_A_43T', 0, TRUE),
(74, 'room', 'BKT_A_46T', 0, TRUE),
(75, 'room', 'BKT_A_47T', 0, TRUE),
(76, 'room', 'BKT_A_48T', 0, TRUE),
(77, 'room', 'BKT_A_50T', 0, TRUE),
(78, 'room', 'BKT_B_4.24', 0, TRUE),
(79, 'room', 'BKT_A_05T', 0, TRUE),
(80, 'room', 'BKT_A_06T', 0, TRUE),
(81, 'room', 'BKT_A_07T', 0, TRUE),
(82, 'room', 'BKT_A_08T', 0, TRUE),
(83, 'room', 'BKT_A_09T', 0, TRUE),
(84, 'room', 'BKT_A_33T', 0, TRUE),
(189, 'tanacs', 'dr. Borbély Attila', 0, TRUE),
(190, 'tanacs', 'Dénesiné dr. Tóth Ildikó', 0, TRUE),
(191, 'tanacs', 'dr. Czéh Ágnes', 0, TRUE),
(192, 'tanacs', 'dr. Fazekas Ágnes', 0, TRUE),
(193, 'tanacs', 'dr. Fejős Gabriella', 0, TRUE),
(194, 'tanacs', 'dr. Hazafi Hildegárd', 0, TRUE),
(195, 'tanacs', 'dr. Holdampf Gusztáv', 0, TRUE),
(196, 'tanacs', 'dr. Kasnyik Adrienn Flóra', 0, TRUE),
(197, 'tanacs', 'dr. Katona Rita', 0, TRUE),
(198, 'tanacs', 'dr. Kemény Kornélia', 0, TRUE),
(199, 'tanacs', 'dr. Kenese Attila', 0, TRUE),
(200, 'tanacs', 'dr. Keyha Ádám', 0, TRUE),
(201, 'tanacs', 'dr. Kiss Andrea', 0, TRUE),
(202, 'tanacs', 'dr. Kövesdi Gergely Mihály', 0, TRUE),
(203, 'tanacs', 'dr. Laki Zita', 0, TRUE),
(204, 'tanacs', 'dr. Léhmann Zoltán', 0, TRUE),
(205, 'tanacs', 'dr. Márta Mária', 0, TRUE),
(206, 'tanacs', 'dr. Máthé Magdolna', 0, TRUE),
(207, 'tanacs', 'dr. Oláh Gaszton', 0, TRUE),
(208, 'tanacs', 'dr. Opóczky László', 0, TRUE),
(209, 'tanacs', 'dr. Palásti Sándor', 0, TRUE),
(210, 'tanacs', 'dr. Puskás Ágnes', 0, TRUE),
(211, 'tanacs', 'dr. Répássy Andrea', 0, TRUE),
(212, 'tanacs', 'dr. Somody Nóra', 0, TRUE),
(213, 'tanacs', 'dr. Szabó Anikó', 0, TRUE),
(214, 'tanacs', 'dr. Szalay Csaba', 0, TRUE),
(215, 'tanacs', 'dr. Szegedi Gyöngyvér', 0, TRUE),
(216, 'tanacs', 'dr. Szente László', 0, TRUE),
(217, 'tanacs', 'dr. Tarjányi Márta', 0, TRUE),
(218, 'tanacs', 'dr. Tóth Zsófia Judit', 0, TRUE),
(219, 'tanacs', 'dr. Turu Olga', 0, TRUE),
(220, 'tanacs', 'dr. Urbán-Kiss Andrea', 0, TRUE),
(221, 'tanacs', 'dr. Zsálek Henriett', 0, TRUE),
(222, 'tanacs', 'dr. Zsembery Antal', 0, TRUE),
(223, 'tanacs', 'Ila-Tóthné dr. Vörös Erika', 0, TRUE),
(224, 'tanacs', 'Nyáregyháziné dr. Sánta Emese', 0, TRUE),
(225, 'tanacs', 'Zrupkóné dr. Szender Zsuzsa', 0, TRUE),
(226, 'tanacs', 'dr. Bicskey Eszter', 0, TRUE),
(227, 'tanacs', 'dr. Dénesi András Marcell', 0, TRUE),
(228, 'tanacs', 'dr. Erdős András', 0, TRUE),
(229, 'tanacs', 'dr. Garáné dr. Horváth Diána', 0, TRUE),
(230, 'tanacs', 'dr. Helmeczy Zsófia', 0, TRUE),
(231, 'tanacs', 'dr. Jobbágy János', 0, TRUE),
(232, 'tanacs', 'dr. Keszthelyi Alajos', 0, TRUE),
(233, 'tanacs', 'dr. Bak Szilvia', 0, TRUE),
(234, 'tanacs', 'dr. Bognár Ildikó', 0, TRUE),
(235, 'tanacs', 'dr. Butyka Mária', 0, TRUE),
(236, 'tanacs', 'dr. Durucz-Baráth Zsuzsanna', 0, TRUE),
(237, 'tanacs', 'dr. Kispál Sándorné dr. Balogh Ágnes', 0, TRUE),
(238, 'tanacs', 'dr. Kun Mariann', 0, TRUE),
(239, 'tanacs', 'dr. Liptai Andrea', 0, TRUE),
(240, 'tanacs', 'dr. Németh Erika', 0, TRUE),
(241, 'tanacs', 'dr. Pásztorné Bilik Sarolta', 0, TRUE),
(242, 'tanacs', 'dr. Péli Szilvia', 0, TRUE),
(243, 'tanacs', 'dr. Gerber Tamás', 0, TRUE),
(244, 'tanacs', 'dr. Liziczay Sándor', 0, TRUE),
(245, 'tanacs', 'dr. Szabó Edit', 0, TRUE),
(246, 'tanacs', 'dr. Antal Ildikó', 0, TRUE),
(247, 'tanacs', 'dr. Balka Viktória', 0, TRUE),
(248, 'tanacs', 'dr. Fördös István Tamás', 0, TRUE),
(249, 'tanacs', 'dr. György Mária', 0, TRUE),
(250, 'tanacs', 'dr. Herczeg Margit Márta', 0, TRUE),
(251, 'tanacs', 'dr. Károlyi Kristóf', 0, TRUE),
(252, 'tanacs', 'dr. Konkoly Marianna', 0, TRUE),
(253, 'tanacs', 'dr. Lóránt István', 0, TRUE),
(254, 'tanacs', 'dr. Neumann Zita', 0, TRUE),
(255, 'tanacs', 'dr. Paisné dr. Kolozsvári Ágnes', 0, TRUE),
(256, 'tanacs', 'dr. Pásztor Csaba', 0, TRUE),
(257, 'tanacs', 'dr. Pintér Mária', 0, TRUE),
(258, 'tanacs', 'dr. Ruff Edit', 0, TRUE),
(259, 'tanacs', 'dr. Rusznák Anita', 0, TRUE),
(260, 'tanacs', 'dr. Skrabski Luca', 0, TRUE),
(261, 'tanacs', 'dr. Smuk Anna', 0, TRUE),
(262, 'tanacs', 'dr. Szabó Annamária', 0, TRUE),
(263, 'tanacs', 'dr. Tiszavölgyi Gyöngyvér', 0, TRUE),
(264, 'tanacs', 'dr. Vida-Szabó Katalin', 0, TRUE),
(265, 'tanacs', 'dr. Windecker Erika', 0, TRUE),
(266, 'tanacs', 'Hargitainé dr. Iharos Ágnes', 0, TRUE),
(267, 'tanacs', 'Spiegelbergerné dr. Pofonka Mariann', 0, TRUE),
(268, 'tanacs', 'Bodnárné dr. Kolozsy Andrea dr.', 0, TRUE),
(269, 'tanacs', 'dr. Bacsa Andrea', 0, TRUE),
(270, 'tanacs', 'dr. Bartal Mónika', 0, TRUE),
(271, 'tanacs', 'dr. Bene Enikő Inge', 0, TRUE),
(272, 'tanacs', 'dr. Bozsó Péter', 0, TRUE),
(273, 'tanacs', 'dr. Csőre Eszter', 0, TRUE),
(274, 'tanacs', 'dr. Dávid Irén', 0, TRUE),
(275, 'tanacs', 'dr. Dvoracsek Kutasi Dorottya', 0, TRUE),
(276, 'tanacs', 'dr. Fekete Molnár Orsolya', 0, TRUE),
(277, 'tanacs', 'dr. Horányi Cintia', 0, TRUE),
(278, 'tanacs', 'dr. Kiss Georgina', 0, TRUE),
(279, 'tanacs', 'dr. Kovács Balázs', 0, TRUE),
(280, 'tanacs', 'dr. Króneisz Gábor', 0, TRUE),
(281, 'tanacs', 'dr. Laky Edit Anita', 0, TRUE),
(282, 'tanacs', 'dr. Lejer Barbara', 0, TRUE),
(283, 'tanacs', 'dr. Minya Krisztián', 0, TRUE),
(284, 'tanacs', 'dr. Nagy Gábor', 0, TRUE),
(285, 'tanacs', 'dr. Rozgonyi-Wurst Katalin', 0, TRUE),
(286, 'tanacs', 'dr. Sághi Rita', 0, TRUE),
(287, 'tanacs', 'dr. Sándor Valter Pál', 0, TRUE),
(288, 'tanacs', 'dr. Szincsák-Szászi Judit', 0, TRUE),
(289, 'tanacs', 'dr. Szivák József', 0, TRUE),
(290, 'tanacs', 'dr. Szomszéd Éva', 0, TRUE),
(291, 'tanacs', 'dr. Tergalecz Eszter', 0, TRUE),
(292, 'tanacs', 'dr. Tóth Éva Rita', 0, TRUE),
(293, 'tanacs', 'Jakabné dr. Sándor Nóra', 0, TRUE),
(294, 'tanacs', 'Tihanyiné dr. Matejcsik Emma Ágnes', 0, TRUE),
(295, 'tanacs', 'dr. Ajtay-Horváth Viola', 0, TRUE),
(296, 'tanacs', 'dr. Dudás Lilian', 0, TRUE),
(297, 'tanacs', 'dr. Keszthelyi Bernadett', 0, TRUE),
(298, 'tanacs', 'dr. Krátky Ákos', 0, TRUE),
(299, 'tanacs', 'dr. Litke Ágota', 0, TRUE),
(300, 'tanacs', 'dr. Maschl Ildikó', 0, TRUE),
(301, 'tanacs', 'dr. Németh Zoltán', 0, TRUE),
(302, 'tanacs', 'dr. Pokorny Gabriella', 0, TRUE),
(303, 'tanacs', 'dr. Simon Judit', 0, TRUE),
(304, 'tanacs', 'Beszterceyné dr. Benedek Tímea', 0, TRUE),
(305, 'tanacs', 'Csedrekiné dr. Tóth Boglárka', 0, TRUE),
(306, 'tanacs', 'dr. Ágoston Zoltán', 0, TRUE),
(307, 'tanacs', 'dr. Aszódi László', 0, TRUE),
(308, 'tanacs', 'dr. Bogdán Viola', 0, TRUE),
(309, 'tanacs', 'dr. Csécsei Etele', 0, TRUE),
(310, 'tanacs', 'dr. Csorba Anna', 0, TRUE),
(311, 'tanacs', 'dr. Dancza Judit Katalin', 0, TRUE),
(312, 'tanacs', 'dr. Domonkos Gyöngyi', 0, TRUE),
(313, 'tanacs', 'dr. Élő-Prosszer Bernadett', 0, TRUE),
(314, 'tanacs', 'dr. Erdeiné dr. Veres Ágnes', 0, TRUE),
(315, 'tanacs', 'dr. Fehérné dr. Gaál Tünde', 0, TRUE),
(316, 'tanacs', 'dr. Fekete Henrietta', 0, TRUE),
(317, 'tanacs', 'dr. Félegyházy-Megyesi Fatime', 0, TRUE),
(318, 'tanacs', 'dr. Gaál Erika', 0, TRUE),
(319, 'tanacs', 'dr. Gajdos István', 0, TRUE),
(320, 'tanacs', 'dr. Grasalkovits Irén', 0, TRUE),
(321, 'tanacs', 'dr. Győrffy Katalin', 0, TRUE),
(322, 'tanacs', 'dr. Hajdu Csaba', 0, TRUE),
(323, 'tanacs', 'dr. Horváth Ildikó', 0, TRUE),
(324, 'tanacs', 'dr. Jakab Ildikó Mónika', 0, TRUE),
(325, 'tanacs', 'dr. Káldy Péter', 0, TRUE),
(326, 'tanacs', 'dr. Kardos Gyula', 0, TRUE),
(327, 'tanacs', 'dr. Kiss Éva', 0, TRUE),
(328, 'tanacs', 'dr. Kiss Márta', 0, TRUE),
(329, 'tanacs', 'dr. Klement Katalin', 0, TRUE),
(330, 'tanacs', 'dr. Langmáhr Nóra', 0, TRUE),
(331, 'tanacs', 'dr. Lukácsi Beáta Zsuzsanna', 0, TRUE),
(332, 'tanacs', 'dr. Molnár Andrea', 0, TRUE),
(333, 'tanacs', 'dr. Németh Renáta Mária', 0, TRUE),
(334, 'tanacs', 'dr. Oláh Anita', 0, TRUE),
(335, 'tanacs', 'dr. Polgárné dr. Vida Judit', 0, TRUE),
(336, 'tanacs', 'dr. Rabb Zsuzsanna', 0, TRUE),
(337, 'tanacs', 'dr. Rada Krisztina', 0, TRUE),
(338, 'tanacs', 'dr. Radnóti Farkas Fatime', 0, TRUE),
(339, 'tanacs', 'dr. Ribárszki Erzsébet Éva', 0, TRUE),
(340, 'tanacs', 'dr. Ruszinkó Judit', 0, TRUE),
(341, 'tanacs', 'dr. Stráhl Zita', 0, TRUE),
(342, 'tanacs', 'dr. Szabó Györgyi', 0, TRUE),
(343, 'tanacs', 'dr. Szabolcsi-Varga Krisztina', 0, TRUE),
(344, 'tanacs', 'dr. Szigeti Krisztina Mónika', 0, TRUE),
(345, 'tanacs', 'dr. Telkes Adrienne', 0, TRUE),
(346, 'tanacs', 'dr. Tóth Krisztina Nóra', 0, TRUE),
(347, 'tanacs', 'dr. Tömböly Gabriella Tünde', 0, TRUE),
(348, 'tanacs', 'dr. Urhelyi Rita', 0, TRUE),
(349, 'tanacs', 'dr. Varga Márta', 0, TRUE),
(350, 'tanacs', 'dr. Varga Tünde Piroska', 0, TRUE),
(351, 'tanacs', 'Oláhné dr. Tóth Orsolya', 0, TRUE),
(352, 'tanacs', 'Szegváriné dr. Barócsi Eszter', 0, TRUE),
(353, 'tanacs', 'Vámosiné dr. Marunák Ágnes', 0, TRUE),
(354, 'tanacs', 'Vargáné dr. Erdődi Ágnes', 0, TRUE),
(355, 'tanacs', 'Vojnitsné dr. Kisfaludy Atala', 0, TRUE),
(356, 'tanacs', 'dr. Barnóczki-Elsasser Endre', 0, TRUE),
(357, 'tanacs', 'dr. Bóka Mária', 0, TRUE),
(358, 'tanacs', 'dr. Csontos Dániel', 0, TRUE),
(359, 'tanacs', 'dr. Geiger Cecília', 0, TRUE),
(360, 'tanacs', 'dr. Hajdu Koppány', 0, TRUE),
(361, 'tanacs', 'dr. Hortobágyi-Balázs Anett', 0, TRUE),
(362, 'tanacs', 'dr. Horváth Elvira', 0, TRUE),
(363, 'tanacs', 'dr. Huber Zsuzsanna', 0, TRUE),
(364, 'tanacs', 'dr. Imre Péter', 0, TRUE),
(365, 'tanacs', 'dr. Kiss Krisztina', 0, TRUE),
(366, 'tanacs', 'dr. Kreisz Anita', 0, TRUE),
(367, 'tanacs', 'dr. Miczán Péter', 0, TRUE),
(368, 'tanacs', 'dr. Niklai Zoltán', 0, TRUE),
(369, 'tanacs', 'dr. Piti Sándor', 0, TRUE),
(370, 'tanacs', 'dr. Pleszkáts Anikó', 0, TRUE),
(371, 'tanacs', 'dr. Smid Erika', 0, TRUE),
(372, 'tanacs', 'dr. Szita Natasa', 0, TRUE),
(373, 'tanacs', 'dr. Takácsné dr. Éles Anita', 0, TRUE),
(374, 'tanacs', 'dr. Takács-Tóth Tímea', 0, TRUE),
(375, 'tanacs', 'dr. Tantalics Gabriella', 0, TRUE),
(376, 'tanacs', 'dr. Tóth Tímea', 0, TRUE),
(377, 'tanacs', 'dr. Varga Dóra', 0, TRUE),
(378, 'tanacs', 'dr. Varga Erzsébet', 0, TRUE),
(379, 'tanacs', 'dr. Váry Viktória', 0, TRUE),
(380, 'tanacs', 'dr. Veszprémi Ágnes', 0, TRUE),
(381, 'tanacs', 'Illyésné dr. Lantos Emőke', 0, TRUE),
(382, 'tanacs', 'Koósné dr. Berecz Krisztina', 0, TRUE),
(383, 'tanacs', 'Lugosiné dr. László Mónika', 0, TRUE),
(384, 'tanacs', 'dr. Berzétei Dóra', 0, TRUE),
(385, 'tanacs', 'dr. Császma Júlia', 0, TRUE),
(386, 'tanacs', 'dr. Hajtman Veronika', 0, TRUE),
(387, 'tanacs', 'dr. Horváth Orsolya', 0, TRUE),
(388, 'tanacs', 'dr. Kovács Adrienn', 0, TRUE),
(389, 'tanacs', 'dr. Miskolczi Alexandra', 0, TRUE),
(390, 'tanacs', 'dr. Stifter-Dobos Szilvia Krisztina', 0, TRUE),
(391, 'tanacs', 'dr. Szakács Tünde', 0, TRUE),
(392, 'tanacs', 'dr. Szakácsi Márton', 0, TRUE),
(393, 'tanacs', 'dr. Tauber Annamária', 0, TRUE),
(394, 'tanacs', 'dr. Urbán-Nagy Szilvia', 0, TRUE),
(395, 'tanacs', 'dr. Varga Andrea', 0, TRUE),
(396, 'tanacs', 'dr. Vass László', 0, TRUE),
(397, 'tanacs', 'dr. Zana Gabriella', 0, TRUE),
(398, 'tanacs', 'Kovácsné dr. Droblyen Éva', 0, TRUE),
(399, 'tanacs', 'Simonné dr. Peti Viktória', 0, TRUE),
(400, 'tanacs', 'Skeleczné dr. Horváth Judit', 0, TRUE),
(401, 'tanacs', 'dr. Budaházi Ágnes', 0, TRUE),
(402, 'tanacs', 'dr. Felföldi Anikó', 0, TRUE),
(403, 'tanacs', 'dr. Gesztesi Kinga', 0, TRUE),
(404, 'tanacs', 'dr. Gulyás Mária', 0, TRUE),
(405, 'tanacs', 'dr. Kocsis Ilona', 0, TRUE),
(406, 'tanacs', 'dr. Kocsis Ilona', 0, TRUE),
(407, 'tanacs', 'dr. Luczay-Mazula Sándor', 0, TRUE),
(408, 'tanacs', 'dr. Ördög-Korondi Nóra', 0, TRUE),
(409, 'tanacs', 'dr. Provaznik Balázs', 0, TRUE),
(410, 'tanacs', 'dr. Szűcs Réka', 0, TRUE),
(411, 'tanacs', 'dr. Szűcs-Bodnár Réka', 0, TRUE),
(412, 'tanacs', 'dr. Vágó-Paczolay Liliána', 0, TRUE),
(413, 'tanacs', 'dr. Velez-Borossy Gabriella', 0, TRUE),
(414, 'tanacs', 'dr. Zsengellér Ildikó', 0, TRUE),
(415, 'tanacs', 'Ugrin Dánielné dr. Simon Andrea', 0, TRUE),
(416, 'tanacs', 'dr. Horváth István', 0, TRUE),
(417, 'tanacs', 'dr. Jurkinya Richárd', 0, TRUE),
(418, 'tanacs', 'dr. Kozák Beatrix', 0, TRUE),
(419, 'tanacs', 'dr. Kulcsár Mónika', 0, TRUE),
(420, 'tanacs', 'dr. Lénárd-Komjáthy Kitti Kata', 0, TRUE),
(421, 'tanacs', 'dr. Nyújtó Ildikó', 0, TRUE),
(422, 'tanacs', 'dr. Szabó Ágnes', 0, TRUE),
(423, 'tanacs', 'dr. Szotáczky Gergely', 0, TRUE),
(424, 'tanacs', 'dr. Turóczi Emese', 0, TRUE),
(425, 'tanacs', 'dr. Varsányi Nikolett', 0, TRUE),
(426, 'tanacs', 'Kollerné dr. Kovács Éva', 0, TRUE),
(427, 'tanacs', 'Rózsáné dr. Váradi Edina', 0, TRUE),
(428, 'tanacs', 'dr. Acsádi Tímea', 0, TRUE),
(429, 'tanacs', 'dr. Csák Éva', 0, TRUE),
(430, 'tanacs', 'dr. Csák Éva Elnök', 0, TRUE),
(431, 'tanacs', 'dr. Fényes Andrea', 0, TRUE),
(432, 'tanacs', 'dr. Hajdu Emese', 0, TRUE),
(433, 'tanacs', 'dr. Hársvölgyi Zsuzsanna', 0, TRUE),
(434, 'tanacs', 'dr. Igaz Barbara', 0, TRUE),
(435, 'tanacs', 'dr. Kolossváryné dr. Molnár Mónika', 0, TRUE),
(436, 'tanacs', 'dr. Korsós Judit', 0, TRUE),
(437, 'tanacs', 'dr. Molnár Edina Edit', 0, TRUE),
(438, 'tanacs', 'dr. Nyikos Beatrix', 0, TRUE),
(439, 'tanacs', 'dr. Répássy Andrea Katalin', 0, TRUE),
(440, 'tanacs', 'dr. Sándor András', 0, TRUE),
(441, 'tanacs', 'dr. Sipka Dóra', 0, TRUE),
(442, 'tanacs', 'dr. Solymosi Judit', 0, TRUE),
(443, 'tanacs', 'dr. Szabó Andrea', 0, TRUE),
(444, 'tanacs', 'dr. Szöllősi Lajos', 0, TRUE),
(445, 'tanacs', 'dr. Virányi Karolina', 0, TRUE),
(446, 'tanacs', 'Barcsákné dr. Bolykó Ildikó', 0, TRUE),
(447, 'tanacs', 'dr. Bajusz Kata', 0, TRUE),
(448, 'tanacs', 'dr. Balogh Erika', 0, TRUE),
(449, 'tanacs', 'dr. Borbélyné dr. Nagy Judit', 0, TRUE),
(450, 'tanacs', 'dr. Dékány Virág Bernadett', 0, TRUE),
(451, 'tanacs', 'dr. Dózsa Gábor', 0, TRUE),
(452, 'tanacs', 'dr. Faix Nikoletta', 0, TRUE),
(453, 'tanacs', 'dr. Forintos Eszter Szimonetta', 0, TRUE),
(454, 'tanacs', 'dr. Heinemann Csilla', 0, TRUE),
(455, 'tanacs', 'dr. Kávássy Béni Péter', 0, TRUE),
(456, 'tanacs', 'dr. Kocsis Tamás', 0, TRUE),
(457, 'tanacs', 'dr. Korpás-Földi Zsuzsanna', 0, TRUE),
(458, 'tanacs', 'dr. Lohr Veronika', 0, TRUE),
(459, 'tanacs', 'dr. Loránt Judit', 0, TRUE),
(460, 'tanacs', 'dr. Molnos Dániel', 0, TRUE),
(461, 'tanacs', 'dr. Somogyi Petra Zoé', 0, TRUE),
(462, 'tanacs', 'dr. Szántay Eszter Anna', 0, TRUE),
(463, 'tanacs', 'dr. Tóth Zsuzsanna', 0, TRUE),
(464, 'tanacs', 'dr. Tulkán Katalin Ágnes', 0, TRUE),
(465, 'tanacs', 'dr. Albert Zsuzsanna', 0, TRUE),
(466, 'tanacs', 'dr. Baranyai Krisztina', 0, TRUE),
(467, 'tanacs', 'dr. Betyár Beáta', 0, TRUE),
(468, 'tanacs', 'dr. Bozsár Jusztina', 0, TRUE),
(469, 'tanacs', 'dr. Csécsei Etele Ádám', 0, TRUE),
(470, 'tanacs', 'dr. Csongorádi Anita', 0, TRUE),
(471, 'tanacs', 'dr. Előházi Csilla', 0, TRUE),
(472, 'tanacs', 'dr. Harton András Márton', 0, TRUE),
(473, 'tanacs', 'dr. Hatlaczki-Kálmán Andrea', 0, TRUE),
(474, 'tanacs', 'dr. Imre Noémi Judit', 0, TRUE),
(475, 'tanacs', 'dr. Magyar Viktória', 0, TRUE),
(476, 'tanacs', 'dr. Malik Gábor', 0, TRUE),
(477, 'tanacs', 'dr. Nagy Emese', 0, TRUE),
(478, 'tanacs', 'dr. Sándor István', 0, TRUE),
(479, 'tanacs', 'dr. Simon Levente', 0, TRUE),
(480, 'tanacs', 'dr. Szabó Imre Gergely', 0, TRUE),
(481, 'tanacs', 'dr. Szedmák András', 0, TRUE),
(482, 'tanacs', 'dr. Szigethy-Nagy Zsófia', 0, TRUE),
(483, 'tanacs', 'dr. Veszeli Marcell', 0, TRUE),
(484, 'tanacs', 'Gazdusné dr. Fekete Georgina', 0, TRUE),
(485, 'tanacs', 'Gnájné dr. Porkoláb Erika', 0, TRUE),
(486, 'tanacs', 'Juhászné dr. Kádár Beáta', 0, TRUE),
(487, 'tanacs', 'Szabóné dr. Horvai Melinda', 0, TRUE),
(488, 'tanacs', 'Topolánszkyné dr. Brieber Nóra', 0, TRUE),
(489, 'tanacs', 'Balláné dr. Illés Ivett', 0, TRUE),
(490, 'tanacs', 'dr. Ábrahám Judit', 0, TRUE),
(491, 'tanacs', 'dr. Balassa Virág', 0, TRUE),
(492, 'tanacs', 'dr. Balázs-Simon Magdolna', 0, TRUE),
(493, 'tanacs', 'dr. Bárdy Szilvia', 0, TRUE),
(494, 'tanacs', 'dr. Berecz-Fülöp Emese', 0, TRUE),
(495, 'tanacs', 'dr. Bíró Viktória', 0, TRUE),
(496, 'tanacs', 'dr. Csabay-Toásó Erika', 0, TRUE),
(497, 'tanacs', 'dr. Komlós Ádám', 0, TRUE),
(498, 'tanacs', 'dr. Kováts Tamás Attila', 0, TRUE),
(499, 'tanacs', 'dr. Lakatosné dr. Fitos Dóra', 0, TRUE),
(500, 'tanacs', 'dr. Marton Erika', 0, TRUE),
(501, 'tanacs', 'dr. Nyulak Éva', 0, TRUE),
(502, 'tanacs', 'dr. Papp László', 0, TRUE),
(503, 'tanacs', 'dr. Simon Gabriella', 0, TRUE),
(504, 'tanacs', 'dr. Vetési Melinda', 0, TRUE),
(505, 'tanacs', 'dr. Zsirai Lilla', 0, TRUE),
(506, 'tanacs', 'dr. Gyarmati Gabriella', 0, TRUE),
(507, 'tanacs', 'dr. Hermann Zsófia', 0, TRUE),
(508, 'tanacs', 'dr. Horváth Balázs', 0, TRUE),
(509, 'tanacs', 'dr. Oszterhuber Réka', 0, TRUE),
(510, 'tanacs', 'dr. Pap Anikó', 0, TRUE),
(511, 'tanacs', 'Kepesné dr. Bekő Borbála', 0, TRUE),
(512, 'tanacs', 'Patakiné dr. Nemoda Beáta', 0, TRUE),
(513, 'tanacs', 'dr. Kertész Szilvia', 0, TRUE),
(514, 'tanacs', 'dr. Nagy Anett', 0, TRUE),
(515, 'tanacs', 'dr. Rácz Adrienn', 0, TRUE),
(516, 'tanacs', 'dr. Szelei Erika', 0, TRUE),
(517, 'tanacs', 'dr. Viski Zoltán', 0, TRUE),
(518, 'tanacs', 'Labanczné dr. Ficsor Adél', 0, TRUE),
(519, 'tanacs', 'dr. Balogh László', 0, TRUE),
(520, 'tanacs', 'dr. Demeter Éva', 0, TRUE),
(521, 'tanacs', 'dr. Kasztory László', 0, TRUE),
(522, 'tanacs', 'dr. Király Edit', 0, TRUE),
(523, 'tanacs', 'dr. Molnár Dalma', 0, TRUE),
(524, 'tanacs', 'dr. Nagy Renáta Hajnalka', 0, TRUE),
(525, 'tanacs', 'dr. Parti Zsuzsanna', 0, TRUE),
(526, 'tanacs', 'dr. Plausin Éva', 0, TRUE),
(527, 'tanacs', 'Keményné dr. Forgács Dóra', 0, TRUE),
(528, 'tanacs', 'dr. Bajnokné Kováts Györgyi', 0, TRUE),
(529, 'tanacs', 'dr. Bán Zsuzsanna', 0, TRUE),
(530, 'tanacs', 'dr. Baráth Géza', 0, TRUE),
(531, 'tanacs', 'dr. Eördögh-Leszák Andrea', 0, TRUE),
(532, 'tanacs', 'dr. File Zsuzsanna', 0, TRUE),
(533, 'tanacs', 'dr. Kiss Nóra', 0, TRUE),
(534, 'tanacs', 'dr. Krajnyák Erika', 0, TRUE),
(535, 'tanacs', 'dr. Kuhár Anna Erzsébet', 0, TRUE),
(536, 'tanacs', 'dr. Lőkös Anna', 0, TRUE),
(537, 'tanacs', 'dr. Mátyás Klára', 0, TRUE),
(538, 'tanacs', 'dr. Móri Krisztina', 0, TRUE),
(539, 'tanacs', 'dr. Nagyváradi Izolda Anikó', 0, TRUE),
(540, 'tanacs', 'dr. Seres Péter', 0, TRUE),
(541, 'tanacs', 'dr. Szentkereszty András', 0, TRUE),
(542, 'tanacs', 'dr. Vida-Lukácsi Katalin', 0, TRUE),
(543, 'tanacs', 'dr. Vitai Fruzsina', 0, TRUE),
(544, 'tanacs', 'dr. Barnóczki Péter', 0, TRUE),
(545, 'tanacs', 'dr. Bata Ágnes', 0, TRUE),
(546, 'tanacs', 'dr. Bicskei Tamás', 0, TRUE),
(547, 'tanacs', 'dr. Drahota Anett', 0, TRUE),
(548, 'tanacs', 'dr. Holló Ágnes', 0, TRUE),
(549, 'tanacs', 'dr. Juni Zsuzsanna', 0, TRUE),
(550, 'tanacs', 'dr. Kacsóh Lilla', 0, TRUE),
(551, 'tanacs', 'dr. Nagy Barbara', 0, TRUE),
(552, 'tanacs', 'dr. Papp Renáta', 0, TRUE),
(553, 'tanacs', 'dr. Ruckel-Pandazis Orsolya', 0, TRUE),
(554, 'tanacs', 'dr. Sárközi Eszter', 0, TRUE),
(555, 'tanacs', 'dr. Serfőző Ágnes', 0, TRUE),
(556, 'tanacs', 'dr. Steffel Boglárka', 0, TRUE),
(557, 'tanacs', 'dr. Sztanó Anita', 0, TRUE),
(558, 'tanacs', 'dr. Tolnai Eszter', 0, TRUE),
(559, 'tanacs', 'dr. Víg Zita Veronika', 0, TRUE),
(560, 'tanacs', 'Szűrösné dr. Takács Andrea', 0, TRUE),
(561, 'tanacs', 'Daláné dr. Sándor Zita', 0, TRUE),
(562, 'tanacs', 'Domjánné dr. Hajzsel Krisztina', 0, TRUE),
(563, 'tanacs', 'dr. Antal Ágnes', 0, TRUE),
(564, 'tanacs', 'dr. Ilonczai Ilona', 0, TRUE),
(565, 'tanacs', 'dr. Kerekes József', 0, TRUE),
(566, 'tanacs', 'dr. Klimászné dr. Mikes Eszter', 0, TRUE),
(567, 'tanacs', 'dr. Molnár Zsolt', 0, TRUE),
(568, 'tanacs', 'dr. Nógrádi Krisztián', 0, TRUE),
(569, 'tanacs', 'dr. Palkovics-Révész Dalma', 0, TRUE),
(570, 'tanacs', 'dr. Petri Dávid', 0, TRUE),
(571, 'tanacs', 'dr. Tasi Katalin', 0, TRUE),
(572, 'tanacs', 'dr. Ujvári Andrea', 0, TRUE),
(573, 'tanacs', 'dr. Vavroh Géza', 0, TRUE),
(574, 'tanacs', 'Kocsisné dr. Niedermüller Angelika', 0, TRUE),
(575, 'tanacs', 'Redlné dr. Mészáros Ildikó', 0, TRUE);

-- Remove duplicate room entries from settings
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

-- ==========================================
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
-- Dynamic HTML matrix view for LG SuperSign (full HTML document per cell)
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

-- Create the view
SELECT create_foglalas_matrix_view();


-- ==========================================
-- Trigger to auto-refresh foglalas_matrix_view when rooms change
-- ==========================================

DROP FUNCTION IF EXISTS refresh_foglalas_matrix_on_room_change() CASCADE;

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

-- Log trigger creation
DO $$
BEGIN
    RAISE NOTICE 'Trigger trigger_refresh_foglalas_matrix created successfully on settings table';
END $$;


-- ==========================================
-- Utility: Refresh all views
-- ==========================================
CREATE OR REPLACE FUNCTION refresh_room_views()
RETURNS void AS $$
BEGIN
    PERFORM create_room_schedule_view();
    PERFORM create_room_schedule_html_view();
    PERFORM create_foglalas_matrix_view();
END;
$$ LANGUAGE plpgsql;

-- Create the views
SELECT create_room_schedule_view();
SELECT create_room_schedule_html_view();

-- ==========================================
-- Indexes for performance
-- ==========================================
CREATE INDEX IF NOT EXISTS idx_rooms_date ON rooms(date);
CREATE INDEX IF NOT EXISTS idx_rooms_date_rooms ON rooms(date, rooms);
CREATE INDEX IF NOT EXISTS idx_rooms_start_time ON rooms(start_time);
CREATE INDEX IF NOT EXISTS idx_settings_category ON settings(category);
CREATE INDEX IF NOT EXISTS idx_settings_active ON settings(active);
CREATE INDEX IF NOT EXISTS idx_settings_category_active ON settings(category, active);

-- ==========================================
-- Update sequence values to prevent conflicts
-- ==========================================
SELECT setval('name_id_seq', COALESCE((SELECT MAX(id) FROM name), 1));
SELECT setval('rooms_id_seq', COALESCE((SELECT MAX(id) FROM rooms), 1));
SELECT setval('settings_id_seq', COALESCE((SELECT MAX(id) FROM settings), 576));


-- ==========================================
-- Add unique constraint to name table
-- ==========================================
ALTER TABLE name ADD CONSTRAINT name_unique UNIQUE (name);


