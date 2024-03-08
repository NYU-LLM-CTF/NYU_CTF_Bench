<?php

$db = new SQLite3('../db/mytasks.sqlite', SQLITE3_OPEN_CREATE | SQLITE3_OPEN_READWRITE);

$db->enableExceptions(true);

$db->query('CREATE TABLE IF NOT EXISTS "task" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "title" VARCHAR,
    "created_at" DATETIME
)');

?>