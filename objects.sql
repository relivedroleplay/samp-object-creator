CREATE TABLE `objects` (
  `ID` int(11) NOT NULL,
  `Model` int(11) NOT NULL DEFAULT 0,
  `X` float NOT NULL DEFAULT 0,
  `Y` float NOT NULL DEFAULT 0,
  `Z` float NOT NULL DEFAULT 0,
  `RotX` float NOT NULL DEFAULT 0,
  `RotY` float NOT NULL DEFAULT 0,
  `RotZ` float NOT NULL DEFAULT 0,
  `Vw` int(11) NOT NULL DEFAULT 0,
  `Int` int(11) NOT NULL DEFAULT 0,
  `Stream` float NOT NULL DEFAULT 300,
  `Materials` varchar(32) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `MatsColor` varchar(32) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `MatsText` int(11) NOT NULL DEFAULT 0,
  `MatsTextIndex` int(11) NOT NULL DEFAULT 0,
  `Text` varchar(256) DEFAULT NULL,
  `MatsTextSize` int(11) NOT NULL DEFAULT 0,
  `MatsTextFont` varchar(32) DEFAULT NULL,
  `MatsTextFontSize` int(11) NOT NULL DEFAULT 0,
  `MatsTextBold` int(11) NOT NULL DEFAULT 0,
  `MatsTextColor` int(11) NOT NULL DEFAULT 0,
  `MatsTextBackColor` int(11) NOT NULL DEFAULT 0,
  `MatsTextAlignment` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `objects`
  ADD PRIMARY KEY (`ID`);
