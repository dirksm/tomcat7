CREATE TABLE IF NOT EXISTS `users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '', 
  `username` VARCHAR(50) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL COMMENT '',
  `password` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL COMMENT '',
  `first_name` VARCHAR(50) NOT NULL COMMENT '',
  `last_name` VARCHAR(50) NOT NULL COMMENT '',
  `email` VARCHAR(100) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL COMMENT '',
  `activated` TINYINT(1) NOT NULL DEFAULT '1' COMMENT '',
  `new_password_key` VARCHAR(50) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NULL DEFAULT NULL COMMENT '',
  `new_password_requested` DATETIME NULL DEFAULT NULL COMMENT '',
  `last_login` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
  `created` DATETIME DEFAULT NULL,
  `modified` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`)  COMMENT 'User Table')
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;

DROP TRIGGER IF EXISTS `USERS_CREATE_TIMESTAMP`;
DELIMITER //
CREATE TRIGGER `USERS_CREATE_TIMESTAMP` BEFORE INSERT ON `users`
 FOR EACH ROW SET NEW.CREATED = NOW()
//
DELIMITER ;
DROP TRIGGER IF EXISTS `USERS_UPDATE_TIMESTAMP`;
DELIMITER //
CREATE TRIGGER `USERS_UPDATE_TIMESTAMP` BEFORE UPDATE ON `users`
 FOR EACH ROW SET NEW.MODIFIED = NOW()
//
DELIMITER ;


CREATE TABLE IF NOT EXISTS `user_types` (
  `user_type_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `title` VARCHAR(255) NOT NULL COMMENT '',
  PRIMARY KEY (`user_type_id`)  COMMENT '')
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8;

INSERT INTO `user_types` (`user_type_id`, `title`) VALUES
(1, 'superadmin'),
(2, 'admin'),
(3, 'trainer'),
(4, 'client'),
(5, 'instructor'),
(6, 'attendees'),
(7, 'staff'),
(8, 'manager');


CREATE TABLE IF NOT EXISTS `user_user_type_xref` (
  `user_id` INT NOT NULL COMMENT '',
  `user_type_id` INT NOT NULL COMMENT '',
  PRIMARY KEY (`user_id`, `user_type_id`)  COMMENT '',
  INDEX `fk_user_type_id_idx` (`user_type_id` ASC)  COMMENT '',
  CONSTRAINT `fk_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_type_id`
    FOREIGN KEY (`user_type_id`)
    REFERENCES `user_types` (`user_type_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Maps user to user type';

CREATE TABLE IF NOT EXISTS `user_photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` longblob NOT NULL,
  `fileName` varchar(128) NOT NULL,
  `contentType` varchar(128) NOT NULL,
  `crc64` varchar(128) NOT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8;

DROP TRIGGER IF EXISTS `USER_PHOTOS_CREATE_TIMESTAMP`;
DELIMITER //
CREATE TRIGGER `USER_PHOTOS_CREATE_TIMESTAMP` BEFORE INSERT ON `user_photos`
 FOR EACH ROW SET NEW.CREATED = NOW()
//
DELIMITER ;

CREATE TABLE IF NOT EXISTS `user_profiles` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `user_id` INT(11) NOT NULL COMMENT '',
  `photo` INT(11) COMMENT '',
  `coverphoto` INT(11) COMMENT '',
  `address` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL COMMENT '',
  `description` TEXT CHARACTER SET 'utf8' COLLATE 'utf8_bin' NULL DEFAULT NULL COMMENT '',
  `website` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NULL DEFAULT NULL COMMENT '',
  PRIMARY KEY (`id`)  COMMENT '',
  INDEX `user_id` (`user_id` ASC)  COMMENT '',
  CONSTRAINT `user_profiles_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_user_profiles_photo_id`
    FOREIGN KEY (`photo`)
    REFERENCES `user_photos` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_profiles_coverphoto_id`
    FOREIGN KEY (`coverphoto`)
    REFERENCES `user_photos` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;
