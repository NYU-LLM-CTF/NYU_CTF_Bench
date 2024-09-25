CREATE TABLE IF NOT EXISTS `users` (
    `id` INTEGER PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `counter` INTEGER NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS `users_name_idx` ON `users`(`name`);
