-- =============================================
-- FUTBOL STATS PRO - Base de Datos Masiva v6
-- 6 Ligas | 20 Equipos por Liga | 120 Equipos
-- =============================================

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    verification_token VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS player_match_stats CASCADE;
DROP TABLE IF EXISTS match_stats CASCADE;
DROP TABLE IF EXISTS players CASCADE;
DROP TABLE IF EXISTS matches CASCADE;
DROP TABLE IF EXISTS teams CASCADE;
DROP TABLE IF EXISTS leagues CASCADE;

CREATE TABLE leagues (id SERIAL PRIMARY KEY, name VARCHAR(100) NOT NULL, country VARCHAR(50));
CREATE TABLE teams (id SERIAL PRIMARY KEY, name VARCHAR(100) NOT NULL, league_id INTEGER REFERENCES leagues(id));
CREATE TABLE players (id SERIAL PRIMARY KEY, name VARCHAR(100) NOT NULL, position VARCHAR(50), team_id INTEGER REFERENCES teams(id));

CREATE TABLE matches (
    id SERIAL PRIMARY KEY,
    league_id INTEGER REFERENCES leagues(id),
    home_team_id INTEGER REFERENCES teams(id),
    away_team_id INTEGER REFERENCES teams(id),
    result VARCHAR(20) DEFAULT '0-0',
    match_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE match_stats (
    id SERIAL PRIMARY KEY,
    match_id INTEGER REFERENCES matches(id),
    team_id INTEGER REFERENCES teams(id),
    possession INTEGER,
    shots INTEGER,
    corners INTEGER
);

CREATE TABLE player_match_stats (
    id SERIAL PRIMARY KEY,
    match_id INTEGER REFERENCES matches(id),
    player_id INTEGER REFERENCES players(id),
    rating DECIMAL(3,1),
    goals INTEGER DEFAULT 0,
    assists INTEGER DEFAULT 0
);

-- =============================================
-- LIGAS
-- =============================================
INSERT INTO leagues (id, name, country) VALUES
(1, 'La Liga', 'España'),
(2, 'Premier League', 'Inglaterra'),
(3, 'Serie A', 'Italia'),
(4, 'Bundesliga', 'Alemania'),
(5, 'Primeira Liga', 'Portugal'),
(6, 'Ligue 1', 'Francia');

-- =============================================
-- 🇪🇸 LA LIGA - 20 EQUIPOS
-- =============================================
INSERT INTO teams (id, name, league_id) VALUES
(1, 'Real Madrid', 1),
(2, 'FC Barcelona', 1),
(3, 'Atlético Madrid', 1),
(4, 'Villarreal', 1),
(5, 'Real Sociedad', 1),
(6, 'Athletic Club', 1),
(7, 'Real Betis', 1),
(8, 'Girona', 1),
(9, 'Sevilla', 1),
(10, 'Valencia', 1),
(11, 'Getafe', 1),
(12, 'Celta de Vigo', 1),
(13, 'Osasuna', 1),
(14, 'Mallorca', 1),
(15, 'Rayo Vallecano', 1),
(16, 'Las Palmas', 1),
(17, 'Alavés', 1),
(18, 'Cádiz', 1),
(19, 'Granada', 1),
(20, 'Almería', 1);

-- =============================================
-- 🏴󠁧󠁢󠁥󠁮󠁧󠁿 PREMIER LEAGUE - 20 EQUIPOS
-- =============================================
INSERT INTO teams (id, name, league_id) VALUES
(21, 'Manchester City', 2),
(22, 'Arsenal', 2),
(23, 'Liverpool', 2),
(24, 'Aston Villa', 2),
(25, 'Tottenham', 2),
(26, 'Chelsea', 2),
(27, 'Newcastle', 2),
(28, 'Man United', 2),
(29, 'West Ham', 2),
(30, 'Crystal Palace', 2),
(31, 'Brighton', 2),
(32, 'Bournemouth', 2),
(33, 'Fulham', 2),
(34, 'Wolves', 2),
(35, 'Everton', 2),
(36, 'Brentford', 2),
(37, 'Nottingham Forest', 2),
(38, 'Luton Town', 2),
(39, 'Burnley', 2),
(40, 'Sheffield United', 2);

-- =============================================
-- 🇮🇹 SERIE A - 20 EQUIPOS
-- =============================================
INSERT INTO teams (id, name, league_id) VALUES
(41, 'Inter Milan', 3),
(42, 'AC Milan', 3),
(43, 'Juventus', 3),
(44, 'Napoli', 3),
(45, 'AS Roma', 3),
(46, 'Lazio', 3),
(47, 'Atalanta', 3),
(48, 'Fiorentina', 3),
(49, 'Bologna', 3),
(50, 'Torino', 3),
(51, 'Monza', 3),
(52, 'Genoa', 3),
(53, 'Lecce', 3),
(54, 'Udinese', 3),
(55, 'Cagliari', 3),
(56, 'Empoli', 3),
(57, 'Frosinone', 3),
(58, 'Hellas Verona', 3),
(59, 'Sassuolo', 3),
(60, 'Salernitana', 3);

-- =============================================
-- 🇩🇪 BUNDESLIGA - 18 EQUIPOS
-- =============================================
INSERT INTO teams (id, name, league_id) VALUES
(61, 'Bayern Munich', 4),
(62, 'Bayer Leverkusen', 4),
(63, 'Borussia Dortmund', 4),
(64, 'RB Leipzig', 4),
(65, 'Eintracht Frankfurt', 4),
(66, 'Stuttgart', 4),
(67, 'Union Berlin', 4),
(68, 'Wolfsburg', 4),
(69, 'Freiburg', 4),
(70, 'Werder Bremen', 4),
(71, 'Hoffenheim', 4),
(72, 'Mainz 05', 4),
(73, 'Borussia Mönchengladbach', 4),
(74, 'Augsburg', 4),
(75, 'Heidenheim', 4),
(76, 'Köln', 4),
(77, 'Darmstadt', 4),
(78, 'Bochum', 4);

-- =============================================
-- 🇵🇹 PRIMEIRA LIGA - 18 EQUIPOS
-- =============================================
INSERT INTO teams (id, name, league_id) VALUES
(79, 'Benfica', 5),
(80, 'FC Porto', 5),
(81, 'Sporting CP', 5),
(82, 'Braga', 5),
(83, 'Vitória SC', 5),
(84, 'Boavista', 5),
(85, 'Famalicão', 5),
(86, 'Gil Vicente', 5),
(87, 'Rio Ave', 5),
(88, 'Moreirense', 5),
(89, 'Casa Pia', 5),
(90, 'Arouca', 5),
(91, 'Estoril', 5),
(92, 'Vizela', 5),
(93, 'Portimonense', 5),
(94, 'Chaves', 5),
(95, 'Estrela Amadora', 5),
(96, 'Farense', 5);

-- =============================================
-- 🇫🇷 LIGUE 1 - 18 EQUIPOS
-- =============================================
INSERT INTO teams (id, name, league_id) VALUES
(97, 'PSG', 6),
(98, 'Marseille', 6),
(99, 'Monaco', 6),
(100, 'Lyon', 6),
(101, 'Lille', 6),
(102, 'Nice', 6),
(103, 'Lens', 6),
(104, 'Rennes', 6),
(105, 'Strasbourg', 6),
(106, 'Toulouse', 6),
(107, 'Montpellier', 6),
(108, 'Nantes', 6),
(109, 'Reims', 6),
(110, 'Le Havre', 6),
(111, 'Metz', 6),
(112, 'Brest', 6),
(113, 'Lorient', 6),
(114, 'Clermont', 6);

-- =============================================
-- JUGADORES DESTACADOS
-- =============================================

-- La Liga
INSERT INTO players (name, position, team_id) VALUES
('Mbappé', 'DC', 1), ('Vinícius Jr.', 'EI', 1), ('Bellingham', 'MC', 1), ('Rodrygo', 'ED', 1),
('Lewandowski', 'DC', 2), ('Lamine Yamal', 'ED', 2), ('Pedri', 'MC', 2), ('Raphinha', 'EI', 2),
('Griezmann', 'SD', 3), ('Álvaro Morata', 'DC', 3), ('Koke', 'MC', 3),
('Gerard Moreno', 'DC', 4), ('Isco', 'MC', 9), ('Iago Aspas', 'DC', 12),
('Nico Williams', 'EI', 6), ('Fekir', 'MC', 7), ('Dovbyk', 'DC', 8);

-- Premier League
INSERT INTO players (name, position, team_id) VALUES
('Haaland', 'DC', 21), ('De Bruyne', 'MC', 21), ('Foden', 'MC', 21),
('Saka', 'ED', 22), ('Ødegaard', 'MC', 22), ('Saliba', 'DF', 22),
('Salah', 'ED', 23), ('Darwin Núñez', 'DC', 23), ('Mac Allister', 'MC', 23),
('Palmer', 'MC', 26), ('Mudryk', 'EI', 26),
('Son Heung-min', 'DC', 25), ('Maddison', 'MC', 25),
('Bruno Fernandes', 'MC', 28), ('Rashford', 'EI', 28),
('Isak', 'DC', 27), ('Gordon', 'EI', 27),
('Ollie Watkins', 'DC', 24);

-- Serie A
INSERT INTO players (name, position, team_id) VALUES
('Lautaro Martínez', 'DC', 41), ('Barella', 'MC', 41), ('Çalhanoğlu', 'MC', 41),
('Leao', 'EI', 42), ('Theo Hernández', 'DF', 42), ('Pulisic', 'ED', 42),
('Vlahovic', 'DC', 43), ('Chiesa', 'ED', 43),
('Kvaratskhelia', 'EI', 44), ('Osimhen', 'DC', 44),
('Dybala', 'SD', 45), ('Pellegrini', 'MC', 45),
('Immobile', 'DC', 46), ('Lookman', 'ED', 47),
('Nico González', 'ED', 48), ('Zirkzee', 'DC', 49);

-- Bundesliga
INSERT INTO players (name, position, team_id) VALUES
('Harry Kane', 'DC', 61), ('Musiala', 'MC', 61), ('Sané', 'ED', 61),
('Wirtz', 'MC', 62), ('Xhaka', 'MC', 62), ('Boniface', 'DC', 62),
('Guirassy', 'DC', 63), ('Brandt', 'MC', 63), ('Adeyemi', 'ED', 63),
('Xavi Simons', 'MC', 64), ('Openda', 'DC', 64),
('Kolo Muani', 'DC', 65), ('Grifo', 'MC', 69),
('Undav', 'DC', 66), ('Füllkrug', 'DC', 70);

-- Primeira Liga
INSERT INTO players (name, position, team_id) VALUES
('Di María', 'ED', 79), ('João Neves', 'MC', 79), ('Neres', 'ED', 79),
('Taremi', 'DC', 80), ('Evanilson', 'DC', 80),
('Gyökeres', 'DC', 81), ('Trincão', 'ED', 81),
('Horta', 'MC', 82), ('Moutinho', 'MC', 83);

-- Ligue 1
INSERT INTO players (name, position, team_id) VALUES
('Dembélé', 'ED', 97), ('Asensio', 'MC', 97), ('Hakimi', 'DF', 97),
('Aubameyang', 'DC', 98), ('Vitinha', 'MC', 98),
('Ben Yedder', 'DC', 99), ('Golovin', 'MC', 99),
('Lacazette', 'DC', 100), ('Cherki', 'MC', 100),
('Jonathan David', 'DC', 101), ('Zhegrova', 'ED', 101),
('Terrier', 'EI', 112), ('Gouiri', 'DC', 104);

-- =============================================
-- PARTIDOS POR LIGA (10 partidos por liga = 60 total)
-- =============================================

-- 🇪🇸 La Liga
INSERT INTO matches (id, league_id, home_team_id, away_team_id, result, match_date) VALUES
(1, 1, 1, 2, '3-2', '2025-02-20'), (2, 1, 3, 1, '1-1', '2025-02-21'),
(3, 1, 2, 3, '2-1', '2025-02-22'), (4, 1, 1, 4, '4-0', '2025-02-23'),
(5, 1, 5, 2, '0-2', '2025-02-24'), (6, 1, 6, 7, '2-1', '2025-02-25'),
(7, 1, 8, 9, '3-1', '2025-03-01'), (8, 1, 10, 11, '1-0', '2025-03-02'),
(9, 1, 12, 13, '2-2', '2025-03-03'), (10, 1, 14, 15, '0-1', '2025-03-04');

-- 🏴󠁧󠁢󠁥󠁮󠁧󠁿 Premier League
INSERT INTO matches (id, league_id, home_team_id, away_team_id, result, match_date) VALUES
(11, 2, 21, 23, '2-2', '2025-02-20'), (12, 2, 22, 26, '3-1', '2025-02-21'),
(13, 2, 28, 21, '0-3', '2025-02-22'), (14, 2, 23, 22, '1-0', '2025-02-23'),
(15, 2, 26, 28, '2-2', '2025-02-24'), (16, 2, 21, 22, '4-2', '2025-02-25'),
(17, 2, 23, 28, '5-0', '2025-03-01'), (18, 2, 25, 27, '1-1', '2025-03-02'),
(19, 2, 24, 29, '3-0', '2025-03-03'), (20, 2, 30, 31, '2-1', '2025-03-04');

-- 🇮🇹 Serie A
INSERT INTO matches (id, league_id, home_team_id, away_team_id, result, match_date) VALUES
(21, 3, 41, 43, '1-0', '2025-02-20'), (22, 3, 42, 44, '2-2', '2025-02-21'),
(23, 3, 45, 41, '0-1', '2025-02-22'), (24, 3, 43, 42, '1-1', '2025-02-23'),
(25, 3, 44, 45, '3-0', '2025-02-24'), (26, 3, 41, 42, '2-1', '2025-02-25'),
(27, 3, 46, 47, '1-2', '2025-03-01'), (28, 3, 48, 49, '4-2', '2025-03-02'),
(29, 3, 50, 51, '0-0', '2025-03-03'), (30, 3, 52, 53, '1-3', '2025-03-04');

-- 🇩🇪 Bundesliga
INSERT INTO matches (id, league_id, home_team_id, away_team_id, result, match_date) VALUES
(31, 4, 61, 62, '2-1', '2025-02-20'), (32, 4, 63, 64, '3-2', '2025-02-21'),
(33, 4, 65, 61, '0-4', '2025-02-22'), (34, 4, 62, 63, '2-2', '2025-02-23'),
(35, 4, 64, 65, '1-1', '2025-02-24'), (36, 4, 61, 63, '5-2', '2025-02-25'),
(37, 4, 66, 67, '3-0', '2025-03-01'), (38, 4, 68, 69, '2-1', '2025-03-02'),
(39, 4, 70, 71, '1-1', '2025-03-03'), (40, 4, 72, 73, '0-2', '2025-03-04');

-- 🇵🇹 Primeira Liga
INSERT INTO matches (id, league_id, home_team_id, away_team_id, result, match_date) VALUES
(41, 5, 79, 80, '2-1', '2025-02-20'), (42, 5, 81, 79, '1-0', '2025-02-21'),
(43, 5, 80, 81, '1-1', '2025-02-22'), (44, 5, 82, 83, '3-2', '2025-02-23'),
(45, 5, 79, 82, '4-0', '2025-02-24'), (46, 5, 81, 80, '2-0', '2025-02-25'),
(47, 5, 84, 85, '1-1', '2025-03-01'), (48, 5, 86, 87, '0-3', '2025-03-02'),
(49, 5, 88, 89, '2-2', '2025-03-03'), (50, 5, 90, 91, '1-0', '2025-03-04');

-- 🇫🇷 Ligue 1
INSERT INTO matches (id, league_id, home_team_id, away_team_id, result, match_date) VALUES
(51, 6, 97, 98, '3-1', '2025-02-20'), (52, 6, 99, 100, '2-2', '2025-02-21'),
(53, 6, 101, 97, '0-2', '2025-02-22'), (54, 6, 98, 99, '1-0', '2025-02-23'),
(55, 6, 100, 101, '3-1', '2025-02-24'), (56, 6, 97, 99, '4-0', '2025-02-25'),
(57, 6, 102, 103, '2-1', '2025-03-01'), (58, 6, 104, 105, '1-1', '2025-03-02'),
(59, 6, 106, 107, '3-2', '2025-03-03'), (60, 6, 108, 109, '0-1', '2025-03-04');

-- =============================================
-- ESTADÍSTICAS DE PARTIDOS
-- =============================================
INSERT INTO match_stats (match_id, team_id, possession, shots, corners)
SELECT m.id, m.home_team_id, 50 + FLOOR(RANDOM()*15), 8 + FLOOR(RANDOM()*10), 3 + FLOOR(RANDOM()*7) FROM matches m;
INSERT INTO match_stats (match_id, team_id, possession, shots, corners)
SELECT m.id, m.away_team_id, 40 + FLOOR(RANDOM()*15), 5 + FLOOR(RANDOM()*10), 2 + FLOOR(RANDOM()*6) FROM matches m;

-- =============================================
-- ESTADÍSTICAS DE JUGADORES POR PARTIDO
-- =============================================
INSERT INTO player_match_stats (match_id, player_id, rating, goals, assists)
SELECT m.id, p.id, ROUND((6.0 + RANDOM()*4.0)::numeric, 1), FLOOR(RANDOM()*3), FLOOR(RANDOM()*2)
FROM matches m JOIN players p ON m.home_team_id = p.team_id LIMIT 150;
INSERT INTO player_match_stats (match_id, player_id, rating, goals, assists)
SELECT m.id, p.id, ROUND((5.5 + RANDOM()*4.0)::numeric, 1), FLOOR(RANDOM()*2), FLOOR(RANDOM()*2)
FROM matches m JOIN players p ON m.away_team_id = p.team_id LIMIT 150;
