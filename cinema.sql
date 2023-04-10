DROP DATABASE IF EXISTS cinema_db;

CREATE DATABASE cinema_db;

USE cinema_db;


-- CREATON DES TABLES
CREATE TABLE `users`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(255) NOT NULL,
    `first_name` VARCHAR(255) NOT NULL,
    `last_name` VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `deleted_at` TIMESTAMP NOT NULL,
    `is_admin` BOOLEAN DEFAULT false
);

CREATE TABLE `categories`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `slug` VARCHAR(255) NOT NULL,
    `label` VARCHAR(255) NOT NULL
);

CREATE TABLE `movies`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `slug` VARCHAR(255) NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `category_id` BIGINT UNSIGNED NOT NULL,
    `duration` SMALLINT NOT NULL
);

CREATE TABLE `cinemas`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `slug` VARCHAR(255) NOT NULL,
    `label` VARCHAR(255) NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `postal_code` VARCHAR(255) NOT NULL,
    `city` VARCHAR(255) NOT NULL,
    `phone_number` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL
);

CREATE TABLE `rooms`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `slug` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `capacity` MEDIUMINT NOT NULL,
    `equipments` JSON NOT NULL,
    `cinema_id` BIGINT UNSIGNED NOT NULL
);

CREATE TABLE `sessions`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `slug` VARCHAR(255) NOT NULL,
    `movie_id` BIGINT UNSIGNED NOT NULL,
    `room_id` BIGINT UNSIGNED NOT NULL,
    `begin_at` DATETIME NOT NULL
);
    
CREATE TABLE `price_types`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `label` VARCHAR(255) NOT NULL,
    `price` FLOAT NOT NULL
);

CREATE TABLE `reservations`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `order_ref` VARCHAR(100) NOT NULL,
    `session_id` BIGINT UNSIGNED NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `price_id` BIGINT UNSIGNED NOT NULL 
);

CREATE TABLE `roles`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `label` VARCHAR(255) NOT NULL,
    `type` ENUM('Admin', 'Customer' ) NOT NULL
);

CREATE TABLE `cinemas_users`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `cinema_id` BIGINT UNSIGNED NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `role_id` BIGINT UNSIGNED NOT NULL
);


-- MODIFICATIONS DES CONTRAINTES
ALTER TABLE
    `movies` ADD UNIQUE `movies_slug_unique`(`slug`);
ALTER TABLE
    `cinemas` ADD UNIQUE `cinemas_slug_unique`(`slug`);
ALTER TABLE
    `sessions` ADD UNIQUE `sessions_slug_unique`(`slug`);
ALTER TABLE
    `users` ADD UNIQUE `users_email_unique`(`email`);
ALTER TABLE
    `categories` ADD UNIQUE `categories_slug_unique`(`slug`);
ALTER TABLE
    `rooms` ADD UNIQUE `rooms_slug_unique`(`slug`);
ALTER TABLE
    `reservations` ADD CONSTRAINT `reservations_session_id_foreign` FOREIGN KEY(`session_id`) REFERENCES `sessions`(`id`);
ALTER TABLE
    `reservations` ADD CONSTRAINT `reservations_price_id_foreign` FOREIGN KEY(`price_id`) REFERENCES `price_types`(`id`);
ALTER TABLE
    `reservations` ADD CONSTRAINT `reservations_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `users`(`id`);
ALTER TABLE
    `rooms` ADD CONSTRAINT `rooms_cinema_id_foreign` FOREIGN KEY(`cinema_id`) REFERENCES `cinemas`(`id`);
ALTER TABLE
    `sessions` ADD CONSTRAINT `sessions_room_id_foreign` FOREIGN KEY(`room_id`) REFERENCES `rooms`(`id`);
ALTER TABLE
    `sessions` ADD CONSTRAINT `sessions_movie_id_foreign` FOREIGN KEY(`movie_id`) REFERENCES `movies`(`id`);
ALTER TABLE
    `cinemas_users` ADD CONSTRAINT `cinemas_users_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `users`(`id`);
ALTER TABLE
    `cinemas_users` ADD CONSTRAINT `cinemas_users_role_id_foreign` FOREIGN KEY(`role_id`) REFERENCES `roles`(`id`);
ALTER TABLE
    `movies` ADD CONSTRAINT `movies_category_id_foreign` FOREIGN KEY(`category_id`) REFERENCES `categories`(`id`);
ALTER TABLE
    `cinemas_users` ADD CONSTRAINT `cinemas_users_cinema_id_foreign` FOREIGN KEY(`cinema_id`) REFERENCES `cinemas`(`id`);


-- INSERTION DES DONNEES CONNUES BDD
INSERT INTO `price_types` (`label`, `price`) VALUES ("Plein tarif", 9.20);
INSERT INTO `price_types` (`label`, `price`) VALUES ("Etudiant", 7.60);
INSERT INTO `price_types` (`label`, `price`) VALUES ("Moins de 14 ans", 5.90);

INSERT INTO `roles`(`label`, `type`) VALUES ("Administrateur", "Admin");
INSERT INTO `roles`(`label`, `type`) VALUES ("Client", "Customer");

INSERT INTO `users` (`email`,`first_name`,`last_name`,`password`,`created_at`,`updated_at`,`deleted_at`, `is_admin`)
VALUES
  ("elementum.at@outlook.net","Alea","Ella","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2022-05-02 12:58:20","2022-12-27 05:40:18","2022-10-22 05:14:39", true),
  ("vitae.aliquet.nec@hotmail.org","Levi","Dieter","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2023-01-07 05:02:55","2023-08-10 20:37:38","2023-07-28 12:33:30", false),
  ("elit.elit.fermentum@google.ca","Wang","Len","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2022-08-19 14:55:19","2023-12-28 22:09:54","2023-10-31 04:53:12", false),
  ("sem@yahoo.com","Kai","Christen","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2022-11-05 09:40:06","2022-08-11 17:26:10","2023-10-14 20:19:08", false),
  ("non.sollicitudin@icloud.edu","Velma","Diana","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2022-08-09 06:02:26","2022-12-18 12:21:50","2024-03-08 05:53:17", false),
  ("feugiat.lorem.ipsum@aol.org","Gareth","Jillian","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2024-02-01 05:29:53","2023-04-10 09:16:02","2024-02-23 13:07:43", true),
  ("phasellus@icloud.edu","Mariam","Gray","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2022-03-14 18:41:43","2023-09-17 05:19:06","2022-06-17 07:02:21", false),
  ("non.egestas@aol.org","Blossom","Carly","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2023-09-27 12:04:50","2024-03-11 20:37:19","2022-09-15 10:47:52", false),
  ("id.ante.dictum@aol.net","Jasper","Lenore","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2022-12-03 07:09:05","2022-12-14 19:15:03","2023-01-25 19:17:25", false),
  ("dolor.sit.amet@yahoo.ca","Cathleen","Kibo","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2021-11-30 23:56:34","2022-11-28 07:13:50","2022-11-28 07:27:13", false),
  ("tincidunt.dui@aol.edu","Renee","Jolene","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2023-09-04 02:02:55","2022-10-15 21:15:13","2023-01-30 20:09:09", false),
  ("justo.faucibus.lectus@protonmail.ca","Lars","Shad","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2023-10-21 02:24:21","2023-12-21 02:15:11","2023-11-06 19:26:54", true),
  ("scelerisque.scelerisque.dui@aol.com","Olivia","Kylan","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2023-12-17 02:39:12","2023-08-30 16:00:11","2022-07-25 10:53:23", false),
  ("erat.eget@hotmail.com","Amal","Farrah","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2023-06-03 13:54:09","2022-05-19 09:13:48","2022-09-13 02:33:18", false),
  ("laoreet.lectus.quis@protonmail.net","Gareth","Declan","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2024-01-19 20:12:16","2022-10-29 05:07:44","2023-05-02 01:13:38", false),
  ("bibendum@protonmail.com","Sandra","Tamekah","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2022-06-13 02:03:40","2022-08-06 08:27:18","2023-08-10 18:00:05", false),
  ("fusce.fermentum@yahoo.edu","Callum","Alika","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2022-11-27 07:03:14","2023-07-19 05:22:06","2023-04-18 16:03:23", false),
  ("dis.parturient@aol.edu","Cairo","Chava","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2022-01-24 13:03:17","2023-12-07 00:30:30","2023-10-25 14:07:22", false),
  ("molestie.tellus@hotmail.edu","Gay","Austin","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2021-10-18 11:47:27","2023-03-05 09:30:14","2023-06-15 21:53:08", false),
  ("est.tempor@aol.ca","Griffith","Karen","$2y$10$gQEs8WDBPUWa1OpzyFtmm.hetDzWgVP5McgNHTE.bHWqneQhNoqLq","2023-08-16 11:44:04","2023-10-12 19:34:56","2023-01-07 06:33:34", false);

INSERT INTO `categories` (id, label, slug) VALUES (1, 'Comédie', 'comedie');
INSERT INTO `categories` (id, label, slug) VALUES (2, 'Thriller', 'thriller');
INSERT INTO `categories` (id, label, slug) VALUES (3, 'Drame', 'drame');
INSERT INTO `categories` (id, label, slug) VALUES (4, 'Documentaire', 'documentaire');
INSERT INTO `categories` (id, label, slug) VALUES (5, 'Action', 'action');

INSERT INTO movies (id, title, slug, category_id, duration) VALUES (1, 'Red Balloon, The (Ballon rouge, Le)', 'le-ballon-rouge', 1, 139);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (2, 'Brothers: The Return', 'brothers-the-retun', 3, 75);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (3, 'Dracula', 'dracula', 2, 219);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (4, 'Wild Child', 'wild-child', 3, 170);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (5, 'Landscape Suicide', 'landscape-suicide', 1, 106);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (6, 'Bulworth', 'bulworth', 4, 112);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (7, 'Free the Nipple', 'free-the-nipple', 1, 69);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (8, 'She Gods of Shark Reef', 'she-gods-of-shark-reef', 5, 207);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (9, 'Stand, The', 'the-stand', 1, 162);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (10, 'Jobs', 'jobs', 2, 89);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (11, 'Justice League: War', 'justice-league-war', 2, 108);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (12, 'Company Man', 'company-man', 5, 167);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (13, 'Suture', 'suture', 4, 217);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (14, 'Little Miss Broadway', 'little-miss-broadway', 1, 202);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (15, 'Capturing the Friedmans', 'capturing-the-friedmans', 4, 153);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (16, 'Secret Life of Girls, The', 'the-secret-life-of-girls', 4, 104);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (17, 'Beyond the Fear', 'beyond-the-fear', 1, 123);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (18, 'Sons and Lovers', 'sons-and-lovers', 4, 117);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (19, 'Waking Madison ', 'waking-madison', 4, 97);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (20, 'Z', 'z-the-movie', 5, 170);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (21, 'Mississippi Mermaid (Sirène du Mississipi, La)', 'la-sirene-du-mississipi', 1, 65);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (22, 'Killing Words (Palabras encadenadas)', 'killing-words', 2, 82);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (23, 'Dirty Work', 'dirty-work', 4, 114);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (24, 'Global Metal', 'global-metal', 2, 69);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (25, 'Black Friday', 'black-friday', 4, 113);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (26, 'Payment Deferred', 'payment-deferred', 1, 127);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (27, 'Full Metal Jacket', 'full-metal-jacket', 3, 192);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (28, 'Police Academy: Mission to Moscow', 'police-academie-moscou', 1, 138);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (29, 'How to Eat Fried Worms', 'how-to-eat-fried-worms', 2, 128);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (30, 'My Side of the Mountain', 'my-side-of-the-mountain', 5, 214);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (31, 'British Intelligence', 'british-intelligence', 4, 93);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (32, 'Pekka ja Pätkä puistotäteinä', 'pekka-ja-patka', 4, 72);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (33, 'Jonathan Livingston Seagull', 'jonathan-livingstone', 1, 184);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (34, 'Turbo: A Power Rangers Movie', 'power-rangers-movie', 2, 204);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (35, 'Whom the Gods Wish to Destroy (Nibelungen, Teil 1: Siegfried, Die)', 'whom-the-gods-with-destroy', 2, 188);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (36, 'War Wagon, The', 'the-war-wagon', 3, 103);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (37, 'Princess Raccoon (Operetta tanuki goten)', 'princess-raccoon', 3, 123);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (38, 'Ricky Gervais Live 4: Science', 'ricky-gervais-live', 1, 89);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (39, 'Airheads', 'airheads', 1, 97);
INSERT INTO movies (id, title, slug, category_id, duration) VALUES (40, 'Wonderful Days (a.k.a. Sky Blue)', 'wonderful-days', 3, 209);

INSERT INTO cinemas (id, slug, label, address, postal_code, city, phone_number, email) VALUES (1, "cgr-de-troyes", "CGR De Troyes", '12 rue de la gare', '10000', 'TROYES', '03827916293', 'hbaldoni0@google.it');
INSERT INTO cinemas (id, slug, label, address, postal_code, city, phone_number, email) VALUES (2, "kinepolis-metz", "Kinépolis de Metz", 'ZAC des maronniers', "57000", 'METZ', '04808441897', 'lsehorsch1@about.me');
INSERT INTO cinemas (id, slug, label, address, postal_code, city, phone_number, email) VALUES (3,"multiplex-orleans", "Multiplex d'Orléans", '5 avenue de la République', '45000', 'ORLEANS', '09008501591', 'kfridaye2@mail.fr');

INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (1, "salle-python", "Salle Python", 316, '[{ "3d" : true, "Dolby": false}]', 1);
INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (2, "salle-ruby", "Salle Ruby", 288, '[{ "3d" : true, "Dolby": true}]', 2);
INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (3, "salle-c", "Salle C", 371, '[{ "3d" : false, "Dolby": false}]', 3);
INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (4, "salle-kotlin", "Salle Kotlin", 127, '[{ "3d" : true, "Dolby": false}]', 2);
INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (5, "salle-java", "salle Java", 184, '[{ "3d" : true, "Dolby": true}]', 1);
INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (6, "salle-ts", "Salle TS", 261, '[{ "3d" : true, "Dolby": false}]', 3);
INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (7, "salle-sharp", "Salle Sharp", 38, '[{ "3d" : true, "Dolby": true}]', 3);
INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (8, "salle-sass", "Salle Sass", 11, '[{ "3d" : true, "Dolby": false}]', 1);
INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (9, "salle-tailwind", "Salle Tailwind", 336, '[{ "3d" : true, "Dolby": true}]', 2);
INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (10, "salle-bs", "Salle BS", 83, '[{ "3d" : true, "Dolby": false}]', 3);
INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (11, "salle-figma", "Salle Figma", 204, '[{ "3d" : true, "Dolby": false}]', 3);
INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (12, "salle-xd", "Salle XD", 378, '[{ "3d" : true, "Dolby": false}]', 1);
INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (13, "salle-gem", "Salle GEM", 142, '[{ "3d" : false, "Dolby": false}]', 2);
INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (14, "salle-studi", "Salle Studi", 112, '[{ "3d" : true, "Dolby": true}]', 1);
INSERT INTO rooms (id, slug, name, capacity, equipments, cinema_id) VALUES (15, "salle-last", "Salle Last", 393, '[{ "3d" : true, "Dolby": false}]', 2);

INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (1, 'Gg324PU6f-3RQm', 33, 2, '2023-02-25 22:35:35');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (2, 'ZinHRSB1v-Swhx', 20, 5, '2022-11-14 21:56:01');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (3, '5KT9Tk7UM-Vpw6', 18, 1, '2022-08-14 08:34:32');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (4, 'FkqUDUr9Y-VE7G', 26, 12, '2023-03-09 14:10:53');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (5, '4T4k14ZWi-ngV2', 14, 7, '2022-06-15 09:12:55');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (6, 'r5XvPaReW-wvMG', 31, 14, '2023-01-19 14:02:07');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (7, 'VIQSK5vdL-jV1P', 25, 1, '2022-05-12 05:53:16');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (8, 'GDhgG6Nrr-yrrx', 8, 3, '2022-12-04 23:50:50');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (9, 'zadxzqUDB-o21N', 22, 11, '2023-02-05 22:07:08');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (10, 'YOuxjRkqv-9KSX', 28, 10, '2022-12-11 12:01:27');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (11, 'EfI1zbgd4-aJjr', 21, 14, '2023-01-20 10:32:59');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (12, 'icVqgcpib-RPdo', 13, 3, '2023-03-29 15:37:59');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (13, 'siD5anEbw-iy7c', 2, 4, '2022-06-09 03:47:27');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (14, 'iw5ptPLJU-OTSo', 37, 3, '2022-04-10 04:55:54');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (15, 'mzh8XeQZ1-ejYA', 24, 7, '2023-03-23 10:47:53');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (16, 'QTT7fL1E6-Lemx', 23, 15, '2022-05-03 22:43:21');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (17, 'F4k1fEYyW-Z3O3', 22, 4, '2023-01-31 05:59:04');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (18, '4wZs0VV54-z1UV', 23, 11, '2022-05-18 23:14:57');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (19, 'eaV1dsbfE-BaYg', 14, 1, '2022-11-07 01:33:17');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (20, 'KqhfhwMh6-INOy', 35, 1, '2023-02-21 23:40:18');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (21, 'hIdfSNSnZ-5hc5', 7, 7, '2022-09-15 09:33:18');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (22, '4QynEerQs-njtY', 15, 12, '2022-09-01 08:06:14');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (23, '8sWfxZDrp-w5q2', 31, 8, '2022-08-14 11:22:03');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (24, 'TITrmFXzq-aOkJ', 36, 15, '2022-07-23 14:39:51');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (25, 'uUsS90zlu-FU4z', 13, 5, '2022-10-06 08:22:54');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (26, 'Lyc2Y0ssb-GRuN', 31, 10, '2022-07-06 00:33:05');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (27, 'fAr45N4gb-UYQS', 8, 3, '2023-03-01 16:16:22');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (28, 'rC6xGjUCb-5S5e', 12, 5, '2023-03-21 23:38:33');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (29, 'bQgoqOfdL-kHdg', 11, 8, '2023-01-23 02:00:08');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (30, 'jNupdtapn-R6uq', 30, 15, '2022-06-15 21:03:54');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (31, 'sUUQhhD6j-unjc', 24, 9, '2022-11-14 01:21:39');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (32, 'y65eIQmGO-xUXA', 1, 5, '2022-10-17 20:24:36');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (33, '6bzvTsD2l-jUeX', 36, 1, '2022-04-22 02:22:55');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (34, 'MNMH9wHqj-GijK', 37, 12, '2022-06-28 11:42:58');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (35, 'ImXdaQNdc-RsIr', 38, 15, '2022-05-26 19:41:27');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (36, 'lOznkRMx7-rfoy', 36, 3, '2023-01-02 04:50:13');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (37, '4Gz9IcA0k-nQhA', 40, 8, '2022-04-10 17:23:15');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (38, 'KKFcFHk8I-AvKL', 2, 9, '2023-04-05 11:50:44');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (39, 'CTsLji1zi-uPna', 39, 10, '2022-10-28 04:41:20');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (40, 'aQXALxLJw-DXiN', 30, 9, '2023-03-14 03:23:30');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (41, '23tIwDKHG-N0Yu', 39, 8, '2022-05-23 04:04:51');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (42, 'JRqtK7SC6-Dedg', 8, 1, '2022-06-30 16:28:01');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (43, '1DaoU2y1Y-iqZF', 33, 4, '2023-03-21 17:39:15');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (44, '7quOI4Ovu-AisS', 37, 9, '2022-04-21 04:23:34');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (45, '1BUkj2jAw-8c3z', 30, 13, '2022-07-27 16:29:12');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (46, 'm3ZySR9L7-XbF8', 30, 4, '2022-09-14 03:07:22');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (47, 'kh6yM4OGJ-RZQg', 39, 15, '2022-05-06 03:33:26');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (48, 'gLO0S3uGO-BT6c', 26, 10, '2023-03-17 04:09:02');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (49, 'NsjGh8H9J-G2UB', 32, 10, '2023-01-11 22:39:12');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (50, 'Qg7WjtppL-5EHM', 23, 15, '2022-05-26 21:54:25');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (51, 'pxlYl7dQi-cnFi', 4, 1, '2022-12-12 14:48:39');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (52, 'rRIbgwTMo-9eRo', 31, 2, '2022-07-06 08:04:52');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (53, 'cAI5h5eTJ-IX87', 15, 4, '2022-10-26 00:14:50');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (54, 'WZbjxVZIm-tz0P', 9, 5, '2022-08-25 12:05:23');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (55, 'vtGMc69ht-1Wsx', 39, 2, '2022-04-13 05:32:57');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (56, 'CJb3F4d3p-tWMT', 7, 10, '2022-07-29 21:02:30');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (57, 'hXeTxrDZm-IL83', 35, 2, '2023-03-14 02:35:13');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (58, 'gY4EPH60E-pVkO', 22, 13, '2023-02-09 16:52:56');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (59, 'MUli84qLM-m4DA', 32, 6, '2023-04-07 20:41:20');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (60, '4BPNMTZ2Z-qz9B', 19, 12, '2022-08-11 18:23:23');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (61, '7i4qflVFX-7mQh', 2, 13, '2022-12-19 17:41:37');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (62, 'Uc0o6RDVE-jJWX', 22, 7, '2023-03-06 18:08:49');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (63, '3LRPipAYE-OEN9', 40, 9, '2022-05-25 17:57:21');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (64, 'zhFOQYtO6-KvQH', 4, 11, '2022-05-07 10:41:04');
INSERT INTO sessions (id, slug, movie_id, room_id, begin_at) VALUES (65, 't0hAtUCh1-hty5', 12, 15, '2022-07-28 19:28:18');

INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (1, '1ZeHDyQiZ-046', 31, 12, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (2, 'XLEjgRI6U-864', 20, 8, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (3, 'xpGWgeFHy-327', 62, 13, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (4, 'GmIWkQQTx-691', 57, 12, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (5, 'dZoL1mqhm-886', 34, 10, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (6, 'NFdQNNihM-803', 58, 5, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (7, 'KHg8DnX42-973', 40, 14, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (8, 'B7OpB77nz-624', 20, 12, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (9, 'ZPomrSslc-930', 33, 9, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (10, '4m6rujUCZ-037', 39, 10, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (11, 'CCldxCPOU-072', 59, 12, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (12, 'b4jCyOssQ-598', 54, 9, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (13, 'YeyzET58T-767', 23, 6, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (14, 'Wg6GvS2Lw-350', 62, 7, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (15, 'XEav24uj1-796', 48, 4, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (16, '2ePZJI9EX-193', 18, 4, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (17, 'UaOVSyS10-491', 8, 1, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (18, 'wcdlJgH0N-246', 32, 3, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (19, '904kOdmht-762', 58, 5, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (20, 'P4kWGkTuf-046', 57, 9, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (21, 'loN3BqjPX-266', 36, 13, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (22, 'x02QfnIFn-560', 46, 6, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (23, 'xgGPD4wB3-017', 17, 9, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (24, 'uWub4JuOJ-140', 1, 2, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (25, 'KbZa4AbOr-265', 43, 6, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (26, 'KggVXn3U4-848', 38, 14, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (27, 'WcICq0gpH-977', 36, 8, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (28, '5oHQZVvvO-113', 39, 1, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (29, 'UMNypkBWm-343', 54, 11, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (30, 'whyxYLD36-443', 40, 14, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (31, 'AOWR2uLqh-247', 38, 11, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (32, 'j1RVRwduc-650', 59, 7, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (33, 'T7QXQumg6-591', 12, 6, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (34, 'RR3CPydZq-042', 9, 8, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (35, 'CXYgqbjWV-568', 12, 4, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (36, 'FGEIxdrrV-513', 54, 12, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (37, 'EYADR6Pk7-500', 51, 14, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (38, '2PW5IREBD-001', 11, 4, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (39, 'ODWkLnsA1-998', 18, 12, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (40, 'bHb5dVOeN-100', 36, 11, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (41, '0gwUTS9pR-973', 46, 9, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (42, 'JuAQcvqx5-195', 50, 12, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (43, 'n5cwj1Glk-196', 21, 2, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (44, '9mKacd97S-082', 49, 8, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (45, '59YyIZT2W-004', 3, 7, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (46, 'U778FwltX-039', 43, 5, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (47, 'kQ3oeWpKv-774', 63, 7, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (48, 'pI0B40d3z-010', 32, 5, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (49, 'GpJdtQg7U-118', 38, 13, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (50, 'mqdaXYFpI-306', 44, 6, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (51, 'oKm5WF46C-185', 27, 2, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (52, '2kIBZ6BaR-628', 35, 3, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (53, 'UhU5C4pEv-239', 61, 9, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (54, 'CdrU2xFfN-092', 56, 7, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (55, 'PgmPYwM89-353', 1, 6, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (56, 'Papt04dvg-116', 65, 11, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (57, 'v5S5AceYw-642', 35, 14, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (58, 'gXX5i8hrc-663', 63, 2, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (59, 'iQWBNf3zo-966', 3, 6, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (60, 'RNnyaffKl-085', 36, 14, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (61, 'AzfUSDrPQ-152', 37, 9, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (62, 'aQrK7Ksf9-936', 24, 2, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (63, '3hICt59re-083', 55, 12, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (64, 'vxw1yztj8-264', 43, 2, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (65, 'NKSOIA1Pk-710', 39, 3, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (66, '7p6thJZA3-749', 23, 6, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (67, 'OSWnaFSK7-042', 4, 10, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (68, 'MVGjYmoJ0-076', 44, 11, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (69, 'yUWR9lviI-821', 5, 14, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (70, 'qscXmpQaO-848', 50, 11, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (71, 'Y0ZdFsJlM-952', 19, 2, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (72, 'dpEeVAEyI-055', 20, 9, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (73, 'ItE9DGaYR-845', 23, 13, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (74, 'tPOFKicGX-505', 48, 11, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (75, 'qoxyTDQgW-109', 53, 9, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (76, 'aDqR4ADC4-040', 55, 8, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (77, 'FUh460Gzn-138', 28, 4, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (78, 'akqQ6w59v-477', 58, 7, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (79, 'oP8nuBn1y-399', 56, 8, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (80, 'i5w9l1ggx-534', 40, 14, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (81, '7jAoqlc1Z-345', 19, 13, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (82, 'CssGSlGa4-717', 31, 5, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (83, 'qXd2gf0KJ-527', 42, 10, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (84, '50zoLoHnP-775', 59, 6, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (85, 'Xd3qdrE4a-028', 43, 11, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (86, 'o3yKCukCK-738', 16, 4, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (87, 'YrXYcDx6y-986', 56, 12, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (88, 'nnhxXtO1m-462', 32, 4, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (89, 'yCSQP7HwI-379', 31, 7, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (90, 'PQD88qXX7-548', 16, 12, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (91, 'NIbw5LDEx-157', 62, 6, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (92, 'prv6d5ST1-587', 45, 5, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (93, 'x6f0cBvZH-582', 60, 1, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (94, 'UaGY2d3o0-881', 40, 9, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (95, 'xQPUpWN1o-389', 2, 2, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (96, 'vTxF5gpkt-214', 44, 10, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (97, 'sSGhBjKYC-935', 41, 9, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (98, 'l7EDDaf3F-514', 4, 9, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (99, 'QllzG5rps-713', 42, 5, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (100, 'rx0sVLsTD-216', 55, 6, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (101, 'ztXPE8nER-968', 58, 11, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (102, 'sf3VxKzWU-783', 62, 2, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (103, 'trgCyLskf-136', 31, 8, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (104, 'gwfa1w73V-331', 29, 8, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (105, 'XefFlMYkB-193', 6, 4, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (106, 'ttg9nA4Cu-749', 29, 13, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (107, 'DDne8hYR9-512', 52, 9, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (108, 'RyjoVCCmI-134', 59, 11, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (109, 'fTvmTFBFm-250', 55, 11, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (110, 'CnYnrdNIM-723', 29, 7, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (111, 'gZi9as101-576', 56, 9, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (112, 'boDRK9Nkd-229', 24, 8, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (113, 'XF5ZBNqGG-490', 50, 3, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (114, 'uD1omVapR-688', 12, 6, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (115, 'QO8VAZhv4-865', 10, 11, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (116, '7k3XpMmuV-741', 40, 1, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (117, 'SPNz7GDgx-762', 52, 4, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (118, 'VM9muFVxV-691', 39, 14, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (119, 'MMJoCWcte-810', 19, 3, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (120, 'ygMkf5etV-165', 16, 2, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (121, 'uqddqFGyZ-401', 62, 3, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (122, 'zk4aMxtDb-907', 48, 2, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (123, 'F6qfyrIu3-351', 61, 1, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (124, 'ITw8pEY2P-047', 7, 8, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (125, 'oydZl4FIm-714', 55, 1, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (126, 'klqfiXkvM-568', 24, 5, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (127, 'lOEr1F6vU-691', 15, 1, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (128, 'Q0lSXBpjb-259', 18, 6, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (129, 'oyGGp5kzn-722', 65, 5, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (130, 'I8D9l1dCi-512', 36, 13, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (131, 'Dy30CT4gX-133', 56, 1, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (132, 'GFcE2Yqeu-981', 23, 10, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (133, 'FuoiDHRWR-908', 33, 12, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (134, 'YxcXzQYOp-347', 8, 4, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (135, 'R2sgNz9KM-970', 29, 10, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (136, 'dhQh6wN9y-810', 5, 7, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (137, 'lqG37diCT-574', 47, 13, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (138, 'jAzYeUAD8-290', 24, 1, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (139, 'Z69kSzKRe-445', 47, 2, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (140, 'EjI8s2xFB-318', 7, 10, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (141, '3XAaGRlc7-367', 29, 11, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (142, 'BRS8mYQ6M-378', 53, 5, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (143, 'D84BRg8fx-230', 36, 7, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (144, 'BpcGiPZQJ-476', 21, 7, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (145, 'FZpwGwcrv-107', 8, 13, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (146, 'CFRMyqQLH-736', 39, 4, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (147, 'VqKelbzGV-474', 33, 14, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (148, 'rJ8jQ0uvp-623', 6, 6, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (149, 'Oc51pGETU-779', 1, 8, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (150, 'jZgtQCDQg-425', 26, 2, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (151, 'SdhIcAyAX-952', 59, 10, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (152, 't3R5nWeXz-518', 27, 6, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (153, '1ImVN43h5-731', 56, 4, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (154, 'bWN3xdt1a-169', 7, 5, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (155, 'LbWjSFPDu-956', 19, 13, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (156, 'UenYTJokP-103', 36, 11, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (157, 'j7e6xrfVD-780', 1, 2, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (158, '7DfrvANu5-011', 64, 9, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (159, 'ltZMiCJ2v-322', 1, 8, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (160, 'Oa1m8hDVp-368', 3, 10, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (161, 'CKEhmPGAJ-810', 30, 10, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (162, 'NXXhzqXPp-193', 37, 4, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (163, 'occv0jifa-649', 1, 14, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (164, 'k8VMyIXbF-707', 49, 4, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (165, 'T7XaZUbF5-551', 1, 13, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (166, 'EztLQ9DQ2-368', 37, 7, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (167, '3BSskzxkd-733', 43, 11, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (168, '8fyDkZZV8-184', 54, 14, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (169, 'lQzJINVuv-177', 58, 4, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (170, 'TdtoBPaY3-407', 53, 5, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (171, 'OgjkLPPue-694', 14, 14, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (172, 'mUqnYzzCm-689', 32, 1, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (173, 'FARqqG6SS-478', 44, 10, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (174, 'ogH0TPF9Y-232', 60, 2, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (175, 'SrUfaN1yj-118', 59, 11, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (176, '2a6B9lwnk-061', 46, 6, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (177, 'v6ooaeXrn-715', 49, 9, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (178, 'wqoIE4Rxr-449', 5, 7, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (179, 'znfIZa9fR-711', 50, 6, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (180, 'xQyt2IM0M-128', 51, 10, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (181, '84DF6QHMp-779', 3, 6, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (182, 'XXj24Lg7d-787', 50, 10, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (183, 'frKhKttCp-893', 16, 7, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (184, 'QQVkYUnmD-738', 53, 3, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (185, 'DstUnW7u1-206', 41, 9, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (186, 'Y4D8FHAC8-772', 65, 12, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (187, 'yMSQO9LX8-604', 41, 10, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (188, '8wYGpJOaS-173', 17, 12, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (189, 'WepEandIE-409', 8, 9, 1);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (190, 'ahkxJ0H0y-717', 1, 6, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (191, 'Hf1SDpSKa-836', 38, 8, 2);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (192, '2RzDIE5Op-196', 11, 13, 3);
INSERT INTO reservations (id, order_ref, session_id, user_id, price_id) VALUES (193, '5MLD4KSVO-139', 56, 5, 2);

INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (1, 3, 4, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (2, 3, 10, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (3, 2, 7, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (4, 2, 7, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (5, 1, 8, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (6, 1, 2, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (7, 3, 1, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (8, 3, 4, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (9, 3, 12, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (10, 3, 1, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (11, 1, 5, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (12, 3, 4, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (13, 2, 9, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (14, 2, 10, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (15, 1, 6, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (16, 3, 2, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (17, 3, 2, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (18, 2, 12, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (19, 3, 13, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (20, 3, 11, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (21, 1, 1, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (22, 3, 10, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (23, 1, 14, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (24, 1, 8, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (25, 3, 8, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (26, 1, 6, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (27, 1, 11, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (28, 2, 8, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (29, 1, 11, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (30, 2, 6, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (31, 3, 11, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (32, 1, 7, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (33, 2, 6, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (34, 1, 1, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (35, 2, 5, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (36, 3, 13, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (37, 1, 8, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (38, 3, 3, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (39, 3, 7, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (40, 1, 3, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (41, 3, 7, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (42, 3, 8, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (43, 1, 10, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (44, 3, 11, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (45, 2, 6, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (46, 3, 14, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (47, 1, 13, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (48, 1, 10, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (49, 3, 13, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (50, 1, 3, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (51, 2, 12, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (52, 2, 14, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (53, 1, 8, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (54, 2, 6, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (55, 1, 10, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (56, 1, 14, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (57, 2, 3, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (58, 3, 2, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (59, 3, 3, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (60, 2, 11, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (61, 2, 2, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (62, 2, 7, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (63, 1, 13, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (64, 2, 13, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (65, 1, 9, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (66, 1, 12, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (67, 1, 10, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (68, 1, 1, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (69, 2, 11, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (70, 3, 5, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (71, 3, 11, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (72, 2, 6, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (73, 1, 6, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (74, 3, 12, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (75, 3, 9, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (76, 1, 3, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (77, 3, 12, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (78, 1, 5, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (79, 1, 2, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (80, 3, 10, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (81, 3, 12, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (82, 2, 3, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (83, 3, 12, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (84, 3, 6, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (85, 1, 4, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (86, 1, 2, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (87, 1, 12, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (88, 2, 5, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (89, 2, 5, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (90, 3, 9, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (91, 1, 10, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (92, 3, 11, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (93, 1, 11, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (94, 3, 11, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (95, 3, 3, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (96, 1, 11, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (97, 2, 3, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (98, 3, 14, 2);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (99, 2, 10, 1);
INSERT INTO cinemas_users (id, cinema_id, user_id, role_id) VALUES (100, 1, 8, 1);

-- POUR EXPORTER LA DATABASE AVEC MYSQLDUMP :
-- mysqldump -u root -p cinema > cinema.sql
-- POUR IMPORTER LA DATABASE AVEC MYSQLDUMP :
-- mysqldump -u root -p cinema < cinema.sql