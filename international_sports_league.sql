-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 21, 2025 at 01:00 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `international_sports_league`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `match_details` (IN `matchId` INT)   BEGIN
SELECT m.match_id,
th.team_name AS home_team,
ta.team_name AS away_team,
v.venue_name,
r.referee_name,
GROUP_CONCAT(sp.sponsor_name) AS sponsors
FROM league_match m
JOIN Team th ON m.home_team_id = th.team_id
JOIN Team ta ON m.away_team_id = ta.team_id
JOIN Venue v ON m.venue_id = v.venue_id
JOIN Referee r ON m.referee_id = r.referee_id
LEFT JOIN Match_Sponsor ms ON m.match_id = ms.match_id
LEFT JOIN Sponsor sp ON ms.sponsor_id = sp.sponsor_id
WHERE m.match_id = matchId
GROUP BY m.match_id, th.team_name, ta.team_name, v.venue_name, r.referee_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `player_stats` (IN `playerId` INT)   BEGIN
SELECT p.player_name,
SUM(goals) AS total_goals,
SUM(assists) AS total_assists,
SUM(fouls) AS total_fouls
FROM Player p
JOIN Statistics s ON p.player_id = s.player_id
WHERE p.player_id = playerId
GROUP BY p.player_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `team_sponsors` (IN `teamId` INT)   BEGIN
SELECT t.team_name, s.sponsor_name, SUM(ts.amount) AS total_funding
FROM Team t
JOIN Team_Sponsor ts ON t.team_id = ts.team_id
JOIN Sponsor s ON ts.sponsor_id = s.sponsor_id
WHERE t.team_id = teamId
GROUP BY t.team_name, s.sponsor_name;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `broadcast`
--

CREATE TABLE `broadcast` (
  `broadcast_id` int(11) NOT NULL,
  `match_id` int(11) NOT NULL,
  `broadcaster_id` int(11) NOT NULL,
  `revenue` decimal(12,2) NOT NULL,
  `broadcasting_rights_cost` decimal(12,2) NOT NULL,
  `broadcaster_revenue_split` decimal(2,2) NOT NULL,
  `venue_revenue_split` decimal(2,2) NOT NULL,
  `league_revenue_split` decimal(2,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `broadcast`
--

INSERT INTO `broadcast` (`broadcast_id`, `match_id`, `broadcaster_id`, `revenue`, `broadcasting_rights_cost`, `broadcaster_revenue_split`, `venue_revenue_split`, `league_revenue_split`) VALUES
(1, 1, 1, 500000.50, 1000000.00, 0.99, 0.99, 0.99),
(2, 2, 3, 500000.50, 1000000.00, 0.99, 0.99, 0.99),
(3, 1, 2, 500000.50, 1000000.00, 0.99, 0.99, 0.99),
(4, 2, 5, 500000.50, 1000000.00, 0.99, 0.99, 0.99);

-- --------------------------------------------------------

--
-- Table structure for table `broadcaster`
--

CREATE TABLE `broadcaster` (
  `broadcaster_id` int(11) NOT NULL,
  `broadcaster_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `broadcaster`
--

INSERT INTO `broadcaster` (`broadcaster_id`, `broadcaster_name`) VALUES
(1, 'Supersport'),
(2, 'Sky Sports'),
(3, 'ESPN'),
(4, 'Fox Sport'),
(5, 'BBC Sport'),
(6, 'ABC Sports');

-- --------------------------------------------------------

--
-- Table structure for table `contract`
--

CREATE TABLE `contract` (
  `contract_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `team_id` int(11) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `salary` decimal(12,2) DEFAULT NULL,
  `bonus` decimal(12,2) DEFAULT NULL,
  `performance_clause` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contract`
--

INSERT INTO `contract` (`contract_id`, `player_id`, `team_id`, `start_date`, `end_date`, `salary`, `bonus`, `performance_clause`) VALUES
(1, 1, 1, '2023-01-01', '2024-12-31', 50000.00, 5000.00, '10 goals = extra bonus'),
(2, 5, 2, '2025-01-01', '2026-12-31', 60000.00, 8000.00, '15 goals = bonus'),
(3, 2, 3, '2023-06-01', '2025-05-31', 45000.00, 4000.00, 'Assist leader bonus'),
(4, 3, 4, '2024-01-01', '2026-01-01', 55000.00, 6000.00, 'Clean sheets bonus'),
(5, 4, 5, '2023-02-01', '2024-12-01', 70000.00, 10000.00, 'Top scorer bonus');

-- --------------------------------------------------------

--
-- Table structure for table `fan`
--

CREATE TABLE `fan` (
  `fan_id` int(11) NOT NULL,
  `fan_name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fan`
--

INSERT INTO `fan` (`fan_id`, `fan_name`, `email`) VALUES
(1, 'Alice Johnson', 'alice@google.com'),
(2, 'Bob Williams', 'bob@yahoo.com'),
(3, 'Charlie Brown', 'charlie@google.com');

-- --------------------------------------------------------

--
-- Table structure for table `league_match`
--

CREATE TABLE `league_match` (
  `match_id` int(11) NOT NULL,
  `home_team_id` int(11) DEFAULT NULL,
  `away_team_id` int(11) DEFAULT NULL,
  `venue_id` int(11) DEFAULT NULL,
  `referee_id` int(11) DEFAULT NULL,
  `match_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `league_match`
--

INSERT INTO `league_match` (`match_id`, `home_team_id`, `away_team_id`, `venue_id`, `referee_id`, `match_date`) VALUES
(1, 1, 2, 1, 1, '2024-07-10'),
(2, 3, 4, 3, 2, '2024-07-15'),
(3, 2, 4, 2, 3, '2024-08-05'),
(4, 1, 3, 1, 4, '2024-09-01');

--
-- Triggers `league_match`
--
DELIMITER $$
CREATE TRIGGER `prevent_double_booking` BEFORE INSERT ON `league_match` FOR EACH ROW BEGIN
IF EXISTS (SELECT 1 FROM league_match
WHERE venue_id = NEW.venue_id
AND match_date = NEW.match_date) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Venue already booked on this date!';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `match_sponsor`
--

CREATE TABLE `match_sponsor` (
  `match_sponsor_id` int(11) NOT NULL,
  `match_id` int(11) NOT NULL,
  `sponsor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `match_sponsor`
--

INSERT INTO `match_sponsor` (`match_sponsor_id`, `match_id`, `sponsor_id`) VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `player`
--

CREATE TABLE `player` (
  `player_id` int(11) NOT NULL,
  `player_name` varchar(255) NOT NULL,
  `player_position` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player`
--

INSERT INTO `player` (`player_id`, `player_name`, `player_position`) VALUES
(1, 'John Smith', 'Forward'),
(2, 'Carlos Ruiz', 'Midfielder'),
(3, 'Michael Johnson', 'Defender'),
(4, 'Takumi Ito', 'Forward'),
(5, 'Daniel Brown', 'Goalkeeper'),
(6, 'Lionel Messi', 'Midfielder'),
(7, 'Christiano Rolando', 'Stricker');

-- --------------------------------------------------------

--
-- Table structure for table `referee`
--

CREATE TABLE `referee` (
  `referee_id` int(11) NOT NULL,
  `referee_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `referee`
--

INSERT INTO `referee` (`referee_id`, `referee_name`) VALUES
(1, 'Mark Taylor'),
(2, 'Hiroshi Sato'),
(3, 'David Gomez'),
(4, 'Alex White');

-- --------------------------------------------------------

--
-- Table structure for table `sponsor`
--

CREATE TABLE `sponsor` (
  `sponsor_id` int(11) NOT NULL,
  `sponsor_name` varchar(255) NOT NULL,
  `sponsor_industry` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sponsor`
--

INSERT INTO `sponsor` (`sponsor_id`, `sponsor_name`, `sponsor_industry`) VALUES
(1, 'Nike', 'Sportswear'),
(2, 'Coca-Cola', 'Beverages'),
(3, 'Sony', 'Electronics');

-- --------------------------------------------------------

--
-- Table structure for table `statistics`
--

CREATE TABLE `statistics` (
  `stat_id` int(11) NOT NULL,
  `match_id` int(11) DEFAULT NULL,
  `player_id` int(11) DEFAULT NULL,
  `goals` int(11) DEFAULT 0,
  `assists` int(11) DEFAULT 0,
  `fouls` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `statistics`
--

INSERT INTO `statistics` (`stat_id`, `match_id`, `player_id`, `goals`, `assists`, `fouls`) VALUES
(1, 1, 1, 2, 1, 0),
(2, 1, 2, 0, 2, 1),
(3, 2, 4, 3, 0, 0),
(4, 2, 3, 0, 1, 2),
(5, 3, 2, 1, 1, 0),
(6, 3, 4, 2, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `team`
--

CREATE TABLE `team` (
  `team_id` int(11) NOT NULL,
  `team_name` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `team`
--

INSERT INTO `team` (`team_id`, `team_name`, `country`) VALUES
(1, 'Orlando Pirates', 'South Africa'),
(2, 'Mamelodi Sundowns', 'South Africa'),
(3, 'Kaizar Cheifs', 'South Africa'),
(4, 'Real Madrid', 'Spain'),
(5, 'Maimi FC', 'USA'),
(6, 'PSG', 'France'),
(7, 'Manchester United', 'England'),
(8, 'Liverpool', 'England'),
(9, 'Manchester City', 'England');

-- --------------------------------------------------------

--
-- Table structure for table `team_sponsor`
--

CREATE TABLE `team_sponsor` (
  `team_sponsor_id` int(11) NOT NULL,
  `team_id` int(11) NOT NULL,
  `sponsor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `team_sponsor`
--

INSERT INTO `team_sponsor` (`team_sponsor_id`, `team_id`, `sponsor_id`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 1),
(4, 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `ticket`
--

CREATE TABLE `ticket` (
  `ticket_id` int(11) NOT NULL,
  `fan_id` int(11) DEFAULT NULL,
  `match_id` int(11) DEFAULT NULL,
  `seat_number` varchar(10) DEFAULT NULL,
  `price` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ticket`
--

INSERT INTO `ticket` (`ticket_id`, `fan_id`, `match_id`, `seat_number`, `price`) VALUES
(1, 1, 1, 'A12', 50.00),
(2, 2, 1, 'B05', 60.00),
(3, 3, 2, 'C15', 45.00),
(4, 1, 3, 'D20', 70.00);

-- --------------------------------------------------------

--
-- Table structure for table `venue`
--

CREATE TABLE `venue` (
  `venue_id` int(11) NOT NULL,
  `venue_name` varchar(255) NOT NULL,
  `venue_country` varchar(255) NOT NULL,
  `venue_city` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `venue`
--

INSERT INTO `venue` (`venue_id`, `venue_name`, `venue_country`, `venue_city`) VALUES
(1, 'Cape Town Stadium', 'South Africa', 'Cape Town'),
(2, 'Camp Nou', 'Spain', 'Madrid'),
(3, 'Yankee Stadium', 'USA', 'Ney York'),
(4, 'Tokyo Dome', 'Japan', 'Suzuka');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `broadcast`
--
ALTER TABLE `broadcast`
  ADD PRIMARY KEY (`broadcast_id`),
  ADD KEY `broadcaster_id` (`broadcaster_id`),
  ADD KEY `match_ibfk_1` (`match_id`);

--
-- Indexes for table `broadcaster`
--
ALTER TABLE `broadcaster`
  ADD PRIMARY KEY (`broadcaster_id`);

--
-- Indexes for table `contract`
--
ALTER TABLE `contract`
  ADD PRIMARY KEY (`contract_id`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `team_id` (`team_id`);

--
-- Indexes for table `fan`
--
ALTER TABLE `fan`
  ADD PRIMARY KEY (`fan_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `league_match`
--
ALTER TABLE `league_match`
  ADD PRIMARY KEY (`match_id`),
  ADD KEY `home_team_id` (`home_team_id`),
  ADD KEY `away_team_id` (`away_team_id`),
  ADD KEY `venue_id` (`venue_id`),
  ADD KEY `referee_id` (`referee_id`);

--
-- Indexes for table `match_sponsor`
--
ALTER TABLE `match_sponsor`
  ADD PRIMARY KEY (`match_sponsor_id`),
  ADD KEY `match_id` (`match_id`),
  ADD KEY `sponsor_id` (`sponsor_id`);

--
-- Indexes for table `player`
--
ALTER TABLE `player`
  ADD PRIMARY KEY (`player_id`);

--
-- Indexes for table `referee`
--
ALTER TABLE `referee`
  ADD PRIMARY KEY (`referee_id`);

--
-- Indexes for table `sponsor`
--
ALTER TABLE `sponsor`
  ADD PRIMARY KEY (`sponsor_id`);

--
-- Indexes for table `statistics`
--
ALTER TABLE `statistics`
  ADD PRIMARY KEY (`stat_id`),
  ADD KEY `match_id` (`match_id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `team`
--
ALTER TABLE `team`
  ADD PRIMARY KEY (`team_id`);

--
-- Indexes for table `team_sponsor`
--
ALTER TABLE `team_sponsor`
  ADD PRIMARY KEY (`team_sponsor_id`),
  ADD KEY `team_id` (`team_id`),
  ADD KEY `sponsor_id` (`sponsor_id`);

--
-- Indexes for table `ticket`
--
ALTER TABLE `ticket`
  ADD PRIMARY KEY (`ticket_id`),
  ADD KEY `fan_id` (`fan_id`),
  ADD KEY `match_id` (`match_id`);

--
-- Indexes for table `venue`
--
ALTER TABLE `venue`
  ADD PRIMARY KEY (`venue_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `broadcast`
--
ALTER TABLE `broadcast`
  MODIFY `broadcast_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `broadcaster`
--
ALTER TABLE `broadcaster`
  MODIFY `broadcaster_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `contract`
--
ALTER TABLE `contract`
  MODIFY `contract_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `fan`
--
ALTER TABLE `fan`
  MODIFY `fan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `league_match`
--
ALTER TABLE `league_match`
  MODIFY `match_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `match_sponsor`
--
ALTER TABLE `match_sponsor`
  MODIFY `match_sponsor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `player`
--
ALTER TABLE `player`
  MODIFY `player_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `referee`
--
ALTER TABLE `referee`
  MODIFY `referee_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `sponsor`
--
ALTER TABLE `sponsor`
  MODIFY `sponsor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `statistics`
--
ALTER TABLE `statistics`
  MODIFY `stat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `team`
--
ALTER TABLE `team`
  MODIFY `team_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `team_sponsor`
--
ALTER TABLE `team_sponsor`
  MODIFY `team_sponsor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `ticket`
--
ALTER TABLE `ticket`
  MODIFY `ticket_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `venue`
--
ALTER TABLE `venue`
  MODIFY `venue_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `broadcast`
--
ALTER TABLE `broadcast`
  ADD CONSTRAINT `broadcast_ibfk_1` FOREIGN KEY (`broadcaster_id`) REFERENCES `broadcaster` (`broadcaster_id`),
  ADD CONSTRAINT `match_ibfk_1` FOREIGN KEY (`match_id`) REFERENCES `league_match` (`match_id`);

--
-- Constraints for table `contract`
--
ALTER TABLE `contract`
  ADD CONSTRAINT `contract_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `player` (`player_id`),
  ADD CONSTRAINT `contract_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`);

--
-- Constraints for table `league_match`
--
ALTER TABLE `league_match`
  ADD CONSTRAINT `league_match_ibfk_1` FOREIGN KEY (`home_team_id`) REFERENCES `team` (`team_id`),
  ADD CONSTRAINT `league_match_ibfk_2` FOREIGN KEY (`away_team_id`) REFERENCES `team` (`team_id`),
  ADD CONSTRAINT `league_match_ibfk_3` FOREIGN KEY (`venue_id`) REFERENCES `venue` (`venue_id`),
  ADD CONSTRAINT `league_match_ibfk_4` FOREIGN KEY (`referee_id`) REFERENCES `referee` (`referee_id`);

--
-- Constraints for table `match_sponsor`
--
ALTER TABLE `match_sponsor`
  ADD CONSTRAINT `match_sponsor_ibfk_1` FOREIGN KEY (`match_id`) REFERENCES `league_match` (`match_id`),
  ADD CONSTRAINT `match_sponsor_ibfk_2` FOREIGN KEY (`sponsor_id`) REFERENCES `sponsor` (`sponsor_id`);

--
-- Constraints for table `statistics`
--
ALTER TABLE `statistics`
  ADD CONSTRAINT `statistics_ibfk_1` FOREIGN KEY (`match_id`) REFERENCES `league_match` (`match_id`),
  ADD CONSTRAINT `statistics_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `player` (`player_id`);

--
-- Constraints for table `team_sponsor`
--
ALTER TABLE `team_sponsor`
  ADD CONSTRAINT `team_sponsor_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`),
  ADD CONSTRAINT `team_sponsor_ibfk_2` FOREIGN KEY (`sponsor_id`) REFERENCES `sponsor` (`sponsor_id`);

--
-- Constraints for table `ticket`
--
ALTER TABLE `ticket`
  ADD CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`fan_id`) REFERENCES `fan` (`fan_id`),
  ADD CONSTRAINT `ticket_ibfk_2` FOREIGN KEY (`match_id`) REFERENCES `league_match` (`match_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
