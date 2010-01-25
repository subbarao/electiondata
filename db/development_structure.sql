CREATE TABLE `contestants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3454 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `contests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `year` int(11) DEFAULT NULL,
  `house_id` int(11) DEFAULT NULL,
  `house_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `votes` int(11) DEFAULT NULL,
  `polled` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1569 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `decisions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contest_id` int(11) DEFAULT NULL,
  `party_id` int(11) DEFAULT NULL,
  `votes` int(11) DEFAULT NULL,
  `contestant_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4242 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `districts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `lng` float DEFAULT NULL,
  `distance` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

CREATE TABLE `parties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `seats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `district_id` int(11) DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `lng` float DEFAULT NULL,
  `distance` float DEFAULT NULL,
  `locality` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `phase` int(11) DEFAULT NULL,
  `election_date` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=337 DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('20090323235858');

INSERT INTO schema_migrations (version) VALUES ('20090330134336');

INSERT INTO schema_migrations (version) VALUES ('20090330141553');

INSERT INTO schema_migrations (version) VALUES ('20090411032129');

INSERT INTO schema_migrations (version) VALUES ('20100123165238');

INSERT INTO schema_migrations (version) VALUES ('20100123173507');

INSERT INTO schema_migrations (version) VALUES ('20100123174600');