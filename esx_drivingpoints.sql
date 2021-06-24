CREATE TABLE `esx_drivingpoints` (
  `identifier` varchar(80) NOT NULL,
  `points` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `esx_drivingpoints`
  ADD PRIMARY KEY (`identifier`);
COMMIT;
