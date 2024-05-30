INSERT INTO `config` VALUES
    ('signing_key', 'an_bad_secret_value_nhcq497y8');

INSERT INTO `priv_config` VALUES
    ('signing_key', '25lGMJ5vkUMkgtshietdk9NC');

DROP DATABASE IF EXISTS `flag`;
CREATE DATABASE `flag`;
DROP TABLE IF EXISTS `flag`.`txt`;
CREATE TABLE `flag`.`txt` (
    `contents` TEXT
);

INSERT INTO `flag`.`txt` VALUES (
    'flag{b3tter_th@n_th3_prequels}'
);
