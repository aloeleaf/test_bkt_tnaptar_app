-- Bírósági Tárgyaló Naptár (bktApp) Adatbázis Struktúra
-- Verzió: 1.0
-- Készült: 2025-09-15
-- Ez a szkript létrehozza és feltölti az alkalmazás adatbázisát.

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


--
-- Adatbázis: `bktAppdb`
-- Létrehozza az adatbázist, ha még nem létezik.
--
CREATE DATABASE IF NOT EXISTS `bktAppdb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci;
USE `bktAppdb`;


--
-- Tábla szerkezet ehhez a táblához `name`
-- Felhasználói bejelentkezési adatok és időbélyegek tárolására.
--
DROP TABLE IF EXISTS `name`;
CREATE TABLE `name` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `last_login` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


--
-- Tábla szerkezet ehhez a táblához `rooms`
-- A tárgyalási bejegyzések (foglalások) fő táblája.
--
DROP TABLE IF EXISTS `rooms`;
CREATE TABLE `rooms` (
  `id` int(11) NOT NULL,
  `birosag` varchar(255) NOT NULL, -- Bíróság neve
  `tanacs` varchar(255) NOT NULL, -- Tanács vagy bíró neve
  `date` date NOT NULL, -- Foglalás dátuma
  `start_time` time NOT NULL, -- Foglalás kezdési ideje
  `end_time` time NOT NULL DEFAULT '16:00:00', -- Foglalás befejezési ideje
  `rooms` varchar(255) NOT NULL, -- Tárgyaló azonosító
  `sorszam` varchar(255) DEFAULT NULL, -- Sorszám vagy egyéb azonosító
  `ugyszam` varchar(255) NOT NULL, -- Ügyszám
  `subject` varchar(255) NOT NULL, -- Ügy tárgya vagy leírása
  `letszam` int(11) NOT NULL, -- Idézettek létszáma
  `resztvevok` varchar(100) NOT NULL, -- Résztvevők típusa (pl. Alperes - Felperes)
  `alperes_terhelt` varchar(100) NOT NULL, -- Alperes vagy Terhelt neve
  `felperes_vadlo` varchar(100) NOT NULL, -- Felperes vagy Vádló neve
  `foglalas` varchar(255) NOT NULL, -- Foglalás összevont információ
  PRIMARY KEY (`date`, `rooms`, `start_time`) -- ÖSSZETETT ELSŐDLEGES KULCS
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


--
-- Tábla szerkezet ehhez a táblához `settings`
-- Kulcs-érték párok tárolására szolgál, főként a legördülő menük
-- (birosag, tanacs, room, resztvevok) feltöltéséhez.
--
DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `category` varchar(100) NOT NULL,
  `value` varchar(100) NOT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


--
-- A tábla adatainak kiíratása `settings`
-- Alapértelmezett beállítások és legördülő menü elemek.
--
INSERT INTO `settings` (`id`, `category`, `value`, `sort_order`, `active`) VALUES
(19, 'birosag', 'Érdi Járásbíróság', 0, 1),
(20, 'birosag', 'Budapest Környéki Törvényszék', 0, 1),
(21, 'birosag', 'Nagykátai Járásbíróság', 0, 1),
(22, 'birosag', 'Váci Járásbíróság', 0, 1),
(23, 'birosag', 'Gödöllői Járásbíróság', 0, 1),
(24, 'birosag', 'Szigetszentmiklósi Járásbíróság', 0, 1),
(25, 'birosag', 'Ráckevei Járásbíróság', 0, 1),
(31, 'resztvevok', 'Alperes - Felperes', 0, 1),
(32, 'resztvevok', 'Vádlott - Terhelt', 0, 1),
(38, 'room', 'BKT_A_01T', 0, 1),
(39, 'room', 'BKT_A_02T', 0, 1),
(40, 'room', 'BKT_A_03T', 0, 1),
(41, 'room', 'BKT_A_02T', 0, 1),
(42, 'room', 'BKT_A_03T', 0, 1),
(43, 'room', 'BKT_A_04T', 0, 1),
(44, 'room', 'BKT_A_10T', 0, 1),
(45, 'room', 'BKT_A_11T', 0, 1),
(46, 'room', 'BKT_A_12T', 0, 1),
(47, 'room', 'BKT_A_15T', 0, 1),
(48, 'room', 'BKT_A_16T', 0, 1),
(49, 'room', 'BKT_A_17T', 0, 1),
(50, 'room', 'BKT_A_18T', 0, 1),
(51, 'room', 'BKT_A_19T', 0, 1),
(52, 'room', 'BKT.B.01T', 0, 1),
(53, 'room', 'BKT_A_28T', 0, 1),
(54, 'room', 'BKT_A_29T', 0, 1),
(55, 'room', 'BKT_A_51T', 0, 1),
(56, 'room', 'BKT_A_52T', 0, 1),
(57, 'room', 'BKT_A_54T', 0, 1),
(58, 'room', 'BKT_A_20T', 0, 1),
(59, 'room', 'BKT_A_21T', 0, 1),
(60, 'room', 'BKT_A_22T', 0, 1),
(61, 'room', 'BKT_A_23T', 0, 1),
(62, 'room', 'BKT_A_24T', 0, 1),
(63, 'room', 'BKT_A_25T', 0, 1),
(64, 'room', 'BKT_A_35T', 0, 1),
(65, 'room', 'BKT_A_26T', 0, 1),
(66, 'room', 'BKT_A_27T', 0, 1),
(67, 'room', 'BKT_A_30T', 0, 1),
(68, 'room', 'BKT_A_32T', 0, 1),
(69, 'room', 'BKT_A_34T', 0, 1),
(70, 'room', 'BKT_A_39T', 0, 1),
(71, 'room', 'BKT_A_40T', 0, 1),
(72, 'room', 'BKT_A_42T', 0, 1),
(73, 'room', 'BKT_A_43T', 0, 1),
(74, 'room', 'BKT_A_46T', 0, 1),
(75, 'room', 'BKT_A_47T', 0, 1),
(76, 'room', 'BKT_A_48T', 0, 1),
(77, 'room', 'BKT_A_50T', 0, 1),
(78, 'room', 'BKT_B_4.24', 0, 1),
(79, 'room', 'BKT_A_05T', 0, 1),
(80, 'room', 'BKT_A_06T', 0, 1),
(81, 'room', 'BKT_A_07T', 0, 1),
(82, 'room', 'BKT_A_08T', 0, 1),
(83, 'room', 'BKT_A_09T', 0, 1),
(84, 'room', 'BKT_A_33T', 0, 1),
(187, 'tanacs', 'dr. Batta Júlia Dóra', 0, 1),
(188, 'tanacs', 'Dénesiné dr. Tóth Ildikó', 0, 1),
(189, 'tanacs', 'dr. Batta Júlia Dóra', 0, 1),
(190, 'tanacs', 'dr. Borbély Attila', 0, 1),
(191, 'tanacs', 'dr. Czéh Ágnes', 0, 1),
(192, 'tanacs', 'dr. Fazekas Ágnes', 0, 1),
(193, 'tanacs', 'dr. Fejős Gabriella', 0, 1),
(194, 'tanacs', 'dr. Hazafi Hildegárd', 0, 1),
(195, 'tanacs', 'dr. Holdampf Gusztáv', 0, 1),
(196, 'tanacs', 'dr. Kasnyik Adrienn Flóra', 0, 1),
(197, 'tanacs', 'dr. Katona Rita', 0, 1),
(198, 'tanacs', 'dr. Kemény Kornélia', 0, 1),
(199, 'tanacs', 'dr. Kenese Attila', 0, 1),
(200, 'tanacs', 'dr. Keyha Ádám', 0, 1),
(201, 'tanacs', 'dr. Kiss Andrea', 0, 1),
(202, 'tanacs', 'dr. Kövesdi Gergely Mihály', 0, 1),
(203, 'tanacs', 'dr. Laki Zita', 0, 1),
(204, 'tanacs', 'dr. Léhmann Zoltán', 0, 1),
(205, 'tanacs', 'dr. Márta Mária', 0, 1),
(206, 'tanacs', 'dr. Máthé Magdolna', 0, 1),
(207, 'tanacs', 'dr. Oláh Gaszton', 0, 1),
(208, 'tanacs', 'dr. Opóczky László', 0, 1),
(209, 'tanacs', 'dr. Palásti Sándor', 0, 1),
(210, 'tanacs', 'dr. Puskás Ágnes', 0, 1),
(211, 'tanacs', 'dr. Répássy Andrea', 0, 1),
(212, 'tanacs', 'dr. Somody Nóra', 0, 1),
(213, 'tanacs', 'dr. Szabó Anikó', 0, 1),
(214, 'tanacs', 'dr. Szalay Csaba', 0, 1),
(215, 'tanacs', 'dr. Szegedi Gyöngyvér', 0, 1),
(216, 'tanacs', 'dr. Szente László', 0, 1),
(217, 'tanacs', 'dr. Tarjányi Márta', 0, 1),
(218, 'tanacs', 'dr. Tóth Zsófia Judit', 0, 1),
(219, 'tanacs', 'dr. Turu Olga', 0, 1),
(220, 'tanacs', 'dr. Urbán-Kiss Andrea', 0, 1),
(221, 'tanacs', 'dr. Zsálek Henriett', 0, 1),
(222, 'tanacs', 'dr. Zsembery Antal', 0, 1),
(223, 'tanacs', 'Ila-Tóthné dr. Vörös Erika', 0, 1),
(224, 'tanacs', 'Nyáregyháziné dr. Sánta Emese', 0, 1),
(225, 'tanacs', 'Zrupkóné dr. Szender Zsuzsa', 0, 1),
(226, 'tanacs', 'dr. Bicskey Eszter', 0, 1),
(227, 'tanacs', 'dr. Dénesi András Marcell', 0, 1),
(228, 'tanacs', 'dr. Erdős András', 0, 1),
(229, 'tanacs', 'dr. Garáné dr. Horváth Diána', 0, 1),
(230, 'tanacs', 'dr. Helmeczy Zsófia', 0, 1),
(231, 'tanacs', 'dr. Jobbágy János', 0, 1),
(232, 'tanacs', 'dr. Keszthelyi Alajos', 0, 1),
(233, 'tanacs', 'dr. Bak Szilvia', 0, 1),
(234, 'tanacs', 'dr. Bognár Ildikó', 0, 1),
(235, 'tanacs', 'dr. Butyka Mária', 0, 1),
(236, 'tanacs', 'dr. Durucz-Baráth Zsuzsanna', 0, 1),
(237, 'tanacs', 'dr. Kispál Sándorné dr. Balogh Ágnes', 0, 1),
(238, 'tanacs', 'dr. Kun Mariann', 0, 1),
(239, 'tanacs', 'dr. Liptai Andrea', 0, 1),
(240, 'tanacs', 'dr. Németh Erika', 0, 1),
(241, 'tanacs', 'dr. Pásztorné Bilik Sarolta', 0, 1),
(242, 'tanacs', 'dr. Péli Szilvia', 0, 1),
(243, 'tanacs', 'dr. Gerber Tamás', 0, 1),
(244, 'tanacs', 'dr. Liziczay Sándor', 0, 1),
(245, 'tanacs', 'dr. Szabó Edit', 0, 1),
(246, 'tanacs', 'dr. Antal Ildikó', 0, 1),
(247, 'tanacs', 'dr. Balka Viktória', 0, 1),
(248, 'tanacs', 'dr. Fördös István Tamás', 0, 1),
(249, 'tanacs', 'dr. György Mária', 0, 1),
(250, 'tanacs', 'dr. Herczeg Margit Márta', 0, 1),
(251, 'tanacs', 'dr. Károlyi Kristóf', 0, 1),
(252, 'tanacs', 'dr. Konkoly Marianna', 0, 1),
(253, 'tanacs', 'dr. Lóránt István', 0, 1),
(254, 'tanacs', 'dr. Neumann Zita', 0, 1),
(255, 'tanacs', 'dr. Paisné dr. Kolozsvári Ágnes', 0, 1),
(256, 'tanacs', 'dr. Pásztor Csaba', 0, 1),
(257, 'tanacs', 'dr. Pintér Mária', 0, 1),
(258, 'tanacs', 'dr. Ruff Edit', 0, 1),
(259, 'tanacs', 'dr. Rusznák Anita', 0, 1),
(260, 'tanacs', 'dr. Skrabski Luca', 0, 1),
(261, 'tanacs', 'dr. Smuk Anna', 0, 1),
(262, 'tanacs', 'dr. Szabó Annamária', 0, 1),
(263, 'tanacs', 'dr. Tiszavölgyi Gyöngyvér', 0, 1),
(264, 'tanacs', 'dr. Vida-Szabó Katalin', 0, 1),
(265, 'tanacs', 'dr. Windecker Erika', 0, 1),
(266, 'tanacs', 'Hargitainé dr. Iharos Ágnes', 0, 1),
(267, 'tanacs', 'Spiegelbergerné dr. Pofonka Mariann', 0, 1),
(268, 'tanacs', 'Bodnárné dr. Kolozsy Andrea dr.', 0, 1),
(269, 'tanacs', 'dr. Bacsa Andrea', 0, 1),
(270, 'tanacs', 'dr. Bartal Mónika', 0, 1),
(271, 'tanacs', 'dr. Bene Enikő Inge', 0, 1),
(272, 'tanacs', 'dr. Bozsó Péter', 0, 1),
(273, 'tanacs', 'dr. Csőre Eszter', 0, 1),
(274, 'tanacs', 'dr. Dávid Irén', 0, 1),
(275, 'tanacs', 'dr. Dvoracsek Kutasi Dorottya', 0, 1),
(276, 'tanacs', 'dr. Fekete Molnár Orsolya', 0, 1),
(277, 'tanacs', 'dr. Horányi Cintia', 0, 1),
(278, 'tanacs', 'dr. Kiss Georgina', 0, 1),
(279, 'tanacs', 'dr. Kovács Balázs', 0, 1),
(280, 'tanacs', 'dr. Króneisz Gábor', 0, 1),
(281, 'tanacs', 'dr. Laky Edit Anita', 0, 1),
(282, 'tanacs', 'dr. Lejer Barbara', 0, 1),
(283, 'tanacs', 'dr. Minya Krisztián', 0, 1),
(284, 'tanacs', 'dr. Nagy Gábor', 0, 1),
(285, 'tanacs', 'dr. Rozgonyi-Wurst Katalin', 0, 1),
(286, 'tanacs', 'dr. Sághi Rita', 0, 1),
(287, 'tanacs', 'dr. Sándor Valter Pál', 0, 1),
(288, 'tanacs', 'dr. Szincsák-Szászi Judit', 0, 1),
(289, 'tanacs', 'dr. Szivák József', 0, 1),
(290, 'tanacs', 'dr. Szomszéd Éva', 0, 1),
(291, 'tanacs', 'dr. Tergalecz Eszter', 0, 1),
(292, 'tanacs', 'dr. Tóth Éva Rita', 0, 1),
(293, 'tanacs', 'Jakabné dr. Sándor Nóra', 0, 1),
(294, 'tanacs', 'Tihanyiné dr. Matejcsik Emma Ágnes', 0, 1),
(295, 'tanacs', 'dr. Ajtay-Horváth Viola', 0, 1),
(296, 'tanacs', 'dr. Dudás Lilian', 0, 1),
(297, 'tanacs', 'dr. Keszthelyi Bernadett', 0, 1),
(298, 'tanacs', 'dr. Krátky Ákos', 0, 1),
(299, 'tanacs', 'dr. Litke Ágota', 0, 1),
(300, 'tanacs', 'dr. Maschl Ildikó', 0, 1),
(301, 'tanacs', 'dr. Németh Zoltán', 0, 1),
(302, 'tanacs', 'dr. Pokorny Gabriella', 0, 1),
(303, 'tanacs', 'dr. Simon Judit', 0, 1),
(304, 'tanacs', 'Beszterceyné dr. Benedek Tímea', 0, 1),
(305, 'tanacs', 'Csedrekiné dr. Tóth Boglárka', 0, 1),
(306, 'tanacs', 'dr. Ágoston Zoltán', 0, 1),
(307, 'tanacs', 'dr. Aszódi László', 0, 1),
(308, 'tanacs', 'dr. Bogdán Viola', 0, 1),
(309, 'tanacs', 'dr. Csécsei Etele', 0, 1),
(310, 'tanacs', 'dr. Csorba Anna', 0, 1),
(311, 'tanacs', 'dr. Dancza Judit Katalin', 0, 1),
(312, 'tanacs', 'dr. Domonkos Gyöngyi', 0, 1),
(313, 'tanacs', 'dr. Élő-Prosszer Bernadett', 0, 1),
(314, 'tanacs', 'dr. Erdeiné dr. Veres Ágnes', 0, 1),
(315, 'tanacs', 'dr. Fehérné dr. Gaál Tünde', 0, 1),
(316, 'tanacs', 'dr. Fekete Henrietta', 0, 1),
(317, 'tanacs', 'dr. Félegyházy-Megyesi Fatime', 0, 1),
(318, 'tanacs', 'dr. Gaál Erika', 0, 1),
(319, 'tanacs', 'dr. Gajdos István', 0, 1),
(320, 'tanacs', 'dr. Grasalkovits Irén', 0, 1),
(321, 'tanacs', 'dr. Győrffy Katalin', 0, 1),
(322, 'tanacs', 'dr. Hajdu Csaba', 0, 1),
(323, 'tanacs', 'dr. Horváth Ildikó', 0, 1),
(324, 'tanacs', 'dr. Jakab Ildikó Mónika', 0, 1),
(325, 'tanacs', 'dr. Káldy Péter', 0, 1),
(326, 'tanacs', 'dr. Kardos Gyula', 0, 1),
(327, 'tanacs', 'dr. Kiss Éva', 0, 1),
(328, 'tanacs', 'dr. Kiss Márta', 0, 1),
(329, 'tanacs', 'dr. Klement Katalin', 0, 1),
(330, 'tanacs', 'dr. Langmáhr Nóra', 0, 1),
(331, 'tanacs', 'dr. Lukácsi Beáta Zsuzsanna', 0, 1),
(332, 'tanacs', 'dr. Molnár Andrea', 0, 1),
(333, 'tanacs', 'dr. Németh Renáta Mária', 0, 1),
(334, 'tanacs', 'dr. Oláh Anita', 0, 1),
(335, 'tanacs', 'dr. Polgárné dr. Vida Judit', 0, 1),
(336, 'tanacs', 'dr. Rabb Zsuzsanna', 0, 1),
(337, 'tanacs', 'dr. Rada Krisztina', 0, 1),
(338, 'tanacs', 'dr. Radnóti Farkas Fatime', 0, 1),
(339, 'tanacs', 'dr. Ribárszki Erzsébet Éva', 0, 1),
(340, 'tanacs', 'dr. Ruszinkó Judit', 0, 1),
(341, 'tanacs', 'dr. Stráhl Zita', 0, 1),
(342, 'tanacs', 'dr. Szabó Györgyi', 0, 1),
(343, 'tanacs', 'dr. Szabolcsi-Varga Krisztina', 0, 1),
(344, 'tanacs', 'dr. Szigeti Krisztina Mónika', 0, 1),
(345, 'tanacs', 'dr. Telkes Adrienne', 0, 1),
(346, 'tanacs', 'dr. Tóth Krisztina Nóra', 0, 1),
(347, 'tanacs', 'dr. Tömböly Gabriella Tünde', 0, 1),
(348, 'tanacs', 'dr. Urhelyi Rita', 0, 1),
(349, 'tanacs', 'dr. Varga Márta', 0, 1),
(350, 'tanacs', 'dr. Varga Tünde Piroska', 0, 1),
(351, 'tanacs', 'Oláhné dr. Tóth Orsolya', 0, 1),
(352, 'tanacs', 'Szegváriné dr. Barócsi Eszter', 0, 1),
(353, 'tanacs', 'Vámosiné dr. Marunák Ágnes', 0, 1),
(354, 'tanacs', 'Vargáné dr. Erdődi Ágnes', 0, 1),
(355, 'tanacs', 'Vojnitsné dr. Kisfaludy Atala', 0, 1),
(356, 'tanacs', 'dr. Barnóczki-Elsasser Endre', 0, 1),
(357, 'tanacs', 'dr. Bóka Mária', 0, 1),
(358, 'tanacs', 'dr. Csontos Dániel', 0, 1),
(359, 'tanacs', 'dr. Geiger Cecília', 0, 1),
(360, 'tanacs', 'dr. Hajdu Koppány', 0, 1),
(361, 'tanacs', 'dr. Hortobágyi-Balázs Anett', 0, 1),
(362, 'tanacs', 'dr. Horváth Elvira', 0, 1),
(363, 'tanacs', 'dr. Huber Zsuzsanna', 0, 1),
(364, 'tanacs', 'dr. Imre Péter', 0, 1),
(365, 'tanacs', 'dr. Kiss Krisztina', 0, 1),
(366, 'tanacs', 'dr. Kreisz Anita', 0, 1),
(367, 'tanacs', 'dr. Miczán Péter', 0, 1),
(368, 'tanacs', 'dr. Niklai Zoltán', 0, 1),
(369, 'tanacs', 'dr. Piti Sándor', 0, 1),
(370, 'tanacs', 'dr. Pleszkáts Anikó', 0, 1),
(371, 'tanacs', 'dr. Smid Erika', 0, 1),
(372, 'tanacs', 'dr. Szita Natasa', 0, 1),
(373, 'tanacs', 'dr. Takácsné dr. Éles Anita', 0, 1),
(374, 'tanacs', 'dr. Takács-Tóth Tímea', 0, 1),
(375, 'tanacs', 'dr. Tantalics Gabriella', 0, 1),
(376, 'tanacs', 'dr. Tóth Tímea', 0, 1),
(377, 'tanacs', 'dr. Varga Dóra', 0, 1),
(378, 'tanacs', 'dr. Varga Erzsébet', 0, 1),
(379, 'tanacs', 'dr. Váry Viktória', 0, 1),
(380, 'tanacs', 'dr. Veszprémi Ágnes', 0, 1),
(381, 'tanacs', 'Illyésné dr. Lantos Emőke', 0, 1),
(382, 'tanacs', 'Koósné dr. Berecz Krisztina', 0, 1),
(383, 'tanacs', 'Lugosiné dr. László Mónika', 0, 1),
(384, 'tanacs', 'dr. Berzétei Dóra', 0, 1),
(385, 'tanacs', 'dr. Császma Júlia', 0, 1),
(386, 'tanacs', 'dr. Hajtman Veronika', 0, 1),
(387, 'tanacs', 'dr. Horváth Orsolya', 0, 1),
(388, 'tanacs', 'dr. Kovács Adrienn', 0, 1),
(389, 'tanacs', 'dr. Miskolczi Alexandra', 0, 1),
(390, 'tanacs', 'dr. Stifter-Dobos Szilvia Krisztina', 0, 1),
(391, 'tanacs', 'dr. Szakács Tünde', 0, 1),
(392, 'tanacs', 'dr. Szakácsi Márton', 0, 1),
(393, 'tanacs', 'dr. Tauber Annamária', 0, 1),
(394, 'tanacs', 'dr. Urbán-Nagy Szilvia', 0, 1),
(395, 'tanacs', 'dr. Varga Andrea', 0, 1),
(396, 'tanacs', 'dr. Vass László', 0, 1),
(397, 'tanacs', 'dr. Zana Gabriella', 0, 1),
(398, 'tanacs', 'Kovácsné dr. Droblyen Éva', 0, 1),
(399, 'tanacs', 'Simonné dr. Peti Viktória', 0, 1),
(400, 'tanacs', 'Skeleczné dr. Horváth Judit', 0, 1),
(401, 'tanacs', 'dr. Budaházi Ágnes', 0, 1),
(402, 'tanacs', 'dr. Felföldi Anikó', 0, 1),
(403, 'tanacs', 'dr. Gesztesi Kinga', 0, 1),
(404, 'tanacs', 'dr. Gulyás Mária', 0, 1),
(405, 'tanacs', 'dr. Kocsis Ilona', 0, 1),
(406, 'tanacs', 'dr. Kocsis Ilona', 0, 1),
(407, 'tanacs', 'dr. Luczay-Mazula Sándor', 0, 1),
(408, 'tanacs', 'dr. Ördög-Korondi Nóra', 0, 1),
(409, 'tanacs', 'dr. Provaznik Balázs', 0, 1),
(410, 'tanacs', 'dr. Szűcs Réka', 0, 1),
(411, 'tanacs', 'dr. Szűcs-Bodnár Réka', 0, 1),
(412, 'tanacs', 'dr. Vágó-Paczolay Liliána', 0, 1),
(413, 'tanacs', 'dr. Velez-Borossy Gabriella', 0, 1),
(414, 'tanacs', 'dr. Zsengellér Ildikó', 0, 1),
(415, 'tanacs', 'Ugrin Dánielné dr. Simon Andrea', 0, 1),
(416, 'tanacs', 'dr. Horváth István', 0, 1),
(417, 'tanacs', 'dr. Jurkinya Richárd', 0, 1),
(418, 'tanacs', 'dr. Kozák Beatrix', 0, 1),
(419, 'tanacs', 'dr. Kulcsár Mónika', 0, 1),
(420, 'tanacs', 'dr. Lénárd-Komjáthy Kitti Kata', 0, 1),
(421, 'tanacs', 'dr. Nyújtó Ildikó', 0, 1),
(422, 'tanacs', 'dr. Szabó Ágnes', 0, 1),
(423, 'tanacs', 'dr. Szotáczky Gergely', 0, 1),
(424, 'tanacs', 'dr. Turóczi Emese', 0, 1),
(425, 'tanacs', 'dr. Varsányi Nikolett', 0, 1),
(426, 'tanacs', 'Kollerné dr. Kovács Éva', 0, 1),
(427, 'tanacs', 'Rózsáné dr. Váradi Edina', 0, 1),
(428, 'tanacs', 'dr. Acsádi Tímea', 0, 1),
(429, 'tanacs', 'dr. Csák Éva', 0, 1),
(430, 'tanacs', 'dr. Csák Éva Elnök', 0, 1),
(431, 'tanacs', 'dr. Fényes Andrea', 0, 1),
(432, 'tanacs', 'dr. Hajdu Emese', 0, 1),
(433, 'tanacs', 'dr. Hársvölgyi Zsuzsanna', 0, 1),
(434, 'tanacs', 'dr. Igaz Barbara', 0, 1),
(435, 'tanacs', 'dr. Kolossváryné dr. Molnár Mónika', 0, 1),
(436, 'tanacs', 'dr. Korsós Judit', 0, 1),
(437, 'tanacs', 'dr. Molnár Edina Edit', 0, 1),
(438, 'tanacs', 'dr. Nyikos Beatrix', 0, 1),
(439, 'tanacs', 'dr. Répássy Andrea Katalin', 0, 1),
(440, 'tanacs', 'dr. Sándor András', 0, 1),
(441, 'tanacs', 'dr. Sipka Dóra', 0, 1),
(442, 'tanacs', 'dr. Solymosi Judit', 0, 1),
(443, 'tanacs', 'dr. Szabó Andrea', 0, 1),
(444, 'tanacs', 'dr. Szöllősi Lajos', 0, 1),
(445, 'tanacs', 'dr. Virányi Karolina', 0, 1),
(446, 'tanacs', 'Barcsákné dr. Bolykó Ildikó', 0, 1),
(447, 'tanacs', 'dr. Bajusz Kata', 0, 1),
(448, 'tanacs', 'dr. Balogh Erika', 0, 1),
(449, 'tanacs', 'dr. Borbélyné dr. Nagy Judit', 0, 1),
(450, 'tanacs', 'dr. Dékány Virág Bernadett', 0, 1),
(451, 'tanacs', 'dr. Dózsa Gábor', 0, 1),
(452, 'tanacs', 'dr. Faix Nikoletta', 0, 1),
(453, 'tanacs', 'dr. Forintos Eszter Szimonetta', 0, 1),
(454, 'tanacs', 'dr. Heinemann Csilla', 0, 1),
(455, 'tanacs', 'dr. Kávássy Béni Péter', 0, 1),
(456, 'tanacs', 'dr. Kocsis Tamás', 0, 1),
(457, 'tanacs', 'dr. Korpás-Földi Zsuzsanna', 0, 1),
(458, 'tanacs', 'dr. Lohr Veronika', 0, 1),
(459, 'tanacs', 'dr. Loránt Judit', 0, 1),
(460, 'tanacs', 'dr. Molnos Dániel', 0, 1),
(461, 'tanacs', 'dr. Somogyi Petra Zoé', 0, 1),
(462, 'tanacs', 'dr. Szántay Eszter Anna', 0, 1),
(463, 'tanacs', 'dr. Tóth Zsuzsanna', 0, 1),
(464, 'tanacs', 'dr. Tulkán Katalin Ágnes', 0, 1),
(465, 'tanacs', 'dr. Albert Zsuzsanna', 0, 1),
(466, 'tanacs', 'dr. Baranyai Krisztina', 0, 1),
(467, 'tanacs', 'dr. Betyár Beáta', 0, 1),
(468, 'tanacs', 'dr. Bozsár Jusztina', 0, 1),
(469, 'tanacs', 'dr. Csécsei Etele Ádám', 0, 1),
(470, 'tanacs', 'dr. Csongorádi Anita', 0, 1),
(471, 'tanacs', 'dr. Előházi Csilla', 0, 1),
(472, 'tanacs', 'dr. Harton András Márton', 0, 1),
(473, 'tanacs', 'dr. Hatlaczki-Kálmán Andrea', 0, 1),
(474, 'tanacs', 'dr. Imre Noémi Judit', 0, 1),
(475, 'tanacs', 'dr. Magyar Viktória', 0, 1),
(476, 'tanacs', 'dr. Malik Gábor', 0, 1),
(477, 'tanacs', 'dr. Nagy Emese', 0, 1),
(478, 'tanacs', 'dr. Sándor István', 0, 1),
(479, 'tanacs', 'dr. Simon Levente', 0, 1),
(480, 'tanacs', 'dr. Szabó Imre Gergely', 0, 1),
(481, 'tanacs', 'dr. Szedmák András', 0, 1),
(482, 'tanacs', 'dr. Szigethy-Nagy Zsófia', 0, 1),
(483, 'tanacs', 'dr. Veszeli Marcell', 0, 1),
(484, 'tanacs', 'Gazdusné dr. Fekete Georgina', 0, 1),
(485, 'tanacs', 'Gnájné dr. Porkoláb Erika', 0, 1),
(486, 'tanacs', 'Juhászné dr. Kádár Beáta', 0, 1),
(487, 'tanacs', 'Szabóné dr. Horvai Melinda', 0, 1),
(488, 'tanacs', 'Topolánszkyné dr. Brieber Nóra', 0, 1),
(489, 'tanacs', 'Balláné dr. Illés Ivett', 0, 1),
(490, 'tanacs', 'dr. Ábrahám Judit', 0, 1),
(491, 'tanacs', 'dr. Balassa Virág', 0, 1),
(492, 'tanacs', 'dr. Balázs-Simon Magdolna', 0, 1),
(493, 'tanacs', 'dr. Bárdy Szilvia', 0, 1),
(494, 'tanacs', 'dr. Berecz-Fülöp Emese', 0, 1),
(495, 'tanacs', 'dr. Bíró Viktória', 0, 1),
(496, 'tanacs', 'dr. Csabay-Toásó Erika', 0, 1),
(497, 'tanacs', 'dr. Komlós Ádám', 0, 1),
(498, 'tanacs', 'dr. Kováts Tamás Attila', 0, 1),
(499, 'tanacs', 'dr. Lakatosné dr. Fitos Dóra', 0, 1),
(500, 'tanacs', 'dr. Marton Erika', 0, 1),
(501, 'tanacs', 'dr. Nyulak Éva', 0, 1),
(502, 'tanacs', 'dr. Papp László', 0, 1),
(503, 'tanacs', 'dr. Simon Gabriella', 0, 1),
(504, 'tanacs', 'dr. Vetési Melinda', 0, 1),
(505, 'tanacs', 'dr. Zsirai Lilla', 0, 1),
(506, 'tanacs', 'dr. Gyarmati Gabriella', 0, 1),
(507, 'tanacs', 'dr. Hermann Zsófia', 0, 1),
(508, 'tanacs', 'dr. Horváth Balázs', 0, 1),
(509, 'tanacs', 'dr. Oszterhuber Réka', 0, 1),
(510, 'tanacs', 'dr. Pap Anikó', 0, 1),
(511, 'tanacs', 'Kepesné dr. Bekő Borbála', 0, 1),
(512, 'tanacs', 'Patakiné dr. Nemoda Beáta', 0, 1),
(513, 'tanacs', 'dr. Kertész Szilvia', 0, 1),
(514, 'tanacs', 'dr. Nagy Anett', 0, 1),
(515, 'tanacs', 'dr. Rácz Adrienn', 0, 1),
(516, 'tanacs', 'dr. Szelei Erika', 0, 1),
(517, 'tanacs', 'dr. Viski Zoltán', 0, 1),
(518, 'tanacs', 'Labanczné dr. Ficsor Adél', 0, 1),
(519, 'tanacs', 'dr. Balogh László', 0, 1),
(520, 'tanacs', 'dr. Demeter Éva', 0, 1),
(521, 'tanacs', 'dr. Kasztory László', 0, 1),
(522, 'tanacs', 'dr. Király Edit', 0, 1),
(523, 'tanacs', 'dr. Molnár Dalma', 0, 1),
(524, 'tanacs', 'dr. Nagy Renáta Hajnalka', 0, 1),
(525, 'tanacs', 'dr. Parti Zsuzsanna', 0, 1),
(526, 'tanacs', 'dr. Plausin Éva', 0, 1),
(527, 'tanacs', 'Keményné dr. Forgács Dóra', 0, 1),
(528, 'tanacs', 'dr. Bajnokné Kováts Györgyi', 0, 1),
(529, 'tanacs', 'dr. Bán Zsuzsanna', 0, 1),
(530, 'tanacs', 'dr. Baráth Géza', 0, 1),
(531, 'tanacs', 'dr. Eördögh-Leszák Andrea', 0, 1),
(532, 'tanacs', 'dr. File Zsuzsanna', 0, 1),
(533, 'tanacs', 'dr. Kiss Nóra', 0, 1),
(534, 'tanacs', 'dr. Krajnyák Erika', 0, 1),
(535, 'tanacs', 'dr. Kuhár Anna Erzsébet', 0, 1),
(536, 'tanacs', 'dr. Lőkös Anna', 0, 1),
(537, 'tanacs', 'dr. Mátyás Klára', 0, 1),
(538, 'tanacs', 'dr. Móri Krisztina', 0, 1),
(539, 'tanacs', 'dr. Nagyváradi Izolda Anikó', 0, 1),
(540, 'tanacs', 'dr. Seres Péter', 0, 1),
(541, 'tanacs', 'dr. Szentkereszty András', 0, 1),
(542, 'tanacs', 'dr. Vida-Lukácsi Katalin', 0, 1),
(543, 'tanacs', 'dr. Vitai Fruzsina', 0, 1),
(544, 'tanacs', 'dr. Barnóczki Péter', 0, 1),
(545, 'tanacs', 'dr. Bata Ágnes', 0, 1),
(546, 'tanacs', 'dr. Bicskei Tamás', 0, 1),
(547, 'tanacs', 'dr. Drahota Anett', 0, 1),
(548, 'tanacs', 'dr. Holló Ágnes', 0, 1),
(549, 'tanacs', 'dr. Juni Zsuzsanna', 0, 1),
(550, 'tanacs', 'dr. Kacsóh Lilla', 0, 1),
(551, 'tanacs', 'dr. Nagy Barbara', 0, 1),
(552, 'tanacs', 'dr. Papp Renáta', 0, 1),
(553, 'tanacs', 'dr. Ruckel-Pandazis Orsolya', 0, 1),
(554, 'tanacs', 'dr. Sárközi Eszter', 0, 1),
(555, 'tanacs', 'dr. Serfőző Ágnes', 0, 1),
(556, 'tanacs', 'dr. Steffel Boglárka', 0, 1),
(557, 'tanacs', 'dr. Sztanó Anita', 0, 1),
(558, 'tanacs', 'dr. Tolnai Eszter', 0, 1),
(559, 'tanacs', 'dr. Víg Zita Veronika', 0, 1),
(560, 'tanacs', 'Szűrösné dr. Takács Andrea', 0, 1),
(561, 'tanacs', 'Daláné dr. Sándor Zita', 0, 1),
(562, 'tanacs', 'Domjánné dr. Hajzsel Krisztina', 0, 1),
(563, 'tanacs', 'dr. Antal Ágnes', 0, 1),
(564, 'tanacs', 'dr. Ilonczai Ilona', 0, 1),
(565, 'tanacs', 'dr. Kerekes József', 0, 1),
(566, 'tanacs', 'dr. Klimászné dr. Mikes Eszter', 0, 1),
(567, 'tanacs', 'dr. Molnár Zsolt', 0, 1),
(568, 'tanacs', 'dr. Nógrádi Krisztián', 0, 1),
(569, 'tanacs', 'dr. Palkovics-Révész Dalma', 0, 1),
(570, 'tanacs', 'dr. Petri Dávid', 0, 1),
(571, 'tanacs', 'dr. Tasi Katalin', 0, 1),
(572, 'tanacs', 'dr. Ujvári Andrea', 0, 1),
(573, 'tanacs', 'dr. Vavroh Géza', 0, 1),
(574, 'tanacs', 'Kocsisné dr. Niedermüller Angelika', 0, 1),
(575, 'tanacs', 'Redlné dr. Mészáros Ildikó', 0, 1);


--
-- Indexek a kiírt táblákhoz
-- Az elsődleges kulcsok beállítása a táblákhoz.
--



--
-- A tábla indexei `name`
--
ALTER TABLE `name`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `rooms`
--
ALTER TABLE `rooms`
    ADD UNIQUE KEY `id` (`id`);


--
-- A tábla indexei `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

-- --------------------------------------------------------

--
-- AUTO_INCREMENT a kiírt táblákhoz
-- Az automatikusan növekvő ID-k beállítása.
--

--
-- AUTO_INCREMENT a táblához `name`
--
ALTER TABLE `name`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT a táblához `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT a táblához `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=576;
COMMIT;

