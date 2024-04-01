CREATE DATABASE csaw_chall;
USE csaw_chall;

CREATE TABLE
`users` (
  `id` int unsigned AUTO_INCREMENT,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `user_name` varchar(255) NOT NULL,
  `account_balance` float(8,6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE(`user_name`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE
  `nfts` (
    `id` int unsigned AUTO_INCREMENT,
    `nft_name` varchar(255) NOT NULL,
    `preview_loc` varchar(255) NOT NULL,
    `true_loc` varchar(255) DEFAULT NULL,
    `price` float(8, 6) DEFAULT NULL,
    `owned_by_id` int unsigned DEFAULT NULL,
    `owned_by_name` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `id-relation` FOREIGN KEY (`id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `name-relation` FOREIGN KEY (`owned_by_name`) REFERENCES `users` (`user_name`) ON DELETE CASCADE ON UPDATE CASCADE
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

INSERT INTO users VALUES (1, NOW(), "elon_musk", 1);
INSERT INTO users VALUES (2, NOW(), "mzucc", 1);
INSERT INTO users VALUES (3, NOW(), "jrogan", 1);
INSERT INTO users VALUES (4, NOW(), "ljames", 1);
INSERT INTO users VALUES (5, NOW(), "hbiden", 1);

INSERT INTO nfts VALUES (NULL, "the_password", "elon-tweet-preview.png", "984bd59ae71472153d726954c0d930c87c2f76bf5cd537703380daa832693fb9.png", 99.999999, 1, "elon_musk");
INSERT INTO nfts VALUES (NULL, "metaverse", "metaverse-nft-preview.png", "39007f69a478a87e6b532889c62b04458b16532c94b99a75872e0e3817957e54.jpg", 0.123, 2, "mzucc");
INSERT INTO nfts VALUES (NULL, "jr_experience", "joe-preview.png", "cab47b7ddd37145b80bc53a466ec1dbcb38e16e80153ec404970bd21c5f07f5c.png", 0.432, 3, "jrogan");
INSERT INTO nfts VALUES (NULL, "nyan_balls", "lebron-preview.png", "a2e37e746691a7e55a3c16df270e0cfb4525bbf75811d19e0eb358556a50b51d.png", 0.567, 4, "ljames");
INSERT INTO nfts VALUES (NULL, "landscape", "biden-preview.png", "43209ec81a4d7b82555cdaae6f2366bfc2a9871a2f3af4ea93572e0690c32828.png", 1.0, 5, "hbiden");