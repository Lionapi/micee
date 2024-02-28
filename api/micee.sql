SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

DROP DATABASE `micee`;
CREATE DATABASE IF NOT EXISTS `micee`;
USE `micee`;

CREATE TABLE IF NOT EXISTS `usersdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `xmlcontent` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT IGNORE INTO `usersdata` (`id`, `name`, `xmlcontent`) VALUES (1, 'admin', "<?xml version='1.0' encoding='UTF-8'?>\\r\\n<utilisateur>\\r\\n<IdUser>1</IdUser>\\r\\n<Nom>Admin</Nom>\\r\\n<Prenom>Admin</Prenom>\\r\\n<Login>Admin</Login>\\r\\n<Motdepasse>VwXjIVpwYXoktL7PNl3RjQ==</Motdepasse>\\r\\n<Adresse>Admin Street</Adresse>\\r\\n<Tel>PhoneNumber(isoCode: IsoCode.FR, countryCode: 33, nsn: 629600023)</Tel>\\r\\n<Email>admin@gmail.com</Email>\\r\\n<Statut>\\r\\n<Admin>1</Admin>\\r\\n<Entreprise>\\r\\n<Ste>0</Ste>\\r\\n<Fonction>0</Fonction>\\r\\n<Siret>0</Siret>\\r\\n</Entreprise>\\r\\n<Particulier>\\r\\n<Psr>0</Psr>\\r\\n<Precaire>0</Precaire>\\r\\n<Classique>0</Classique>\\r\\n</Particulier>\\r\\n</Statut>\\r\\n<Dossiers>\\r\\n<Doc>\\r\\n<IdDoc>0</IdDoc>\\r\\n<Msg>.|.</Msg>\\r\\n<StatutDoc>\\r\\n<Encours>0</Encours>\\r\\n<Complement>0</Complement>\\r\\n<Instruction>0</Instruction>\\r\\n<Decision>0</Decision>\\r\\n</StatutDoc>\\r\\n<AnaTech>0</AnaTech>\\r\\n<AnaAdmin>0</AnaAdmin>\\r\\n<ComTech>0</ComTech>\\r\\n<ComAdmin>0</ComAdmin>\\r\\n<Prime>0</Prime>\\r\\n<Synthese>0</Synthese>\\r\\n</Doc>\\r\\n</Dossiers>\\r\\n<Datenaiss>0000-00-00 00:00:00</Datenaiss>\\r\\n<Livetime>0000-00-00 00:00:00</Livetime>\\r\\n<Creation>0000-00-00 00:00:00</Creation>\\r\\n<Is2kfactor>0</Is2kfactor>\\r\\n<IdRef>0</IdRef>\\r\\n</utilisateur>");