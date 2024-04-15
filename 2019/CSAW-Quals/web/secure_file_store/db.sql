CREATE TABLE `User` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `privs` smallint(6) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `User` (`id`, `username`, `password`, `privs`) VALUES
(1, 'admin', '$2y$10$H38hS7IMk1MzSg/usdBvjuRucRGkEKrc/tJhJQOD7249oRpNqWc5O', 15);

ALTER TABLE `User`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
