-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : lun. 06 juin 2022 à 18:44
-- Version du serveur :  10.4.14-MariaDB
-- Version de PHP : 7.2.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `sebastoviandes`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `changePasswd` (IN `id` INT, IN `passwd` VARCHAR(50))  BEGIN
	UPDATE utilisateurs SET utilisateurs.MotDePasse = SHA(passwd) WHERE utilisateurs.ID_Utilisateur = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findProduit` (IN `filtre` VARCHAR(50))  BEGIN
	SELECT produits.ID_Produit, produits.Libelle, produits.Prix, produits.Unite, produits.Lien_Photo, typeproduits.Libelle AS Type
    FROM produits
    INNER JOIN typeproduits ON produits.typeproduit = typeproduits.ID_TypeProduit
    WHERE produits.LCASELib LIKE CONCAT('%',filtre,'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertProduit` (IN `lib` VARCHAR(50), IN `lienPic` VARCHAR(50), IN `tarif` FLOAT, IN `unite` VARCHAR(50), IN `type` INT, IN `userUnit` VARCHAR(50), IN `gram` INT)  BEGIN
	DECLARE maxID INT;
    INSERT INTO affichageuser(affichageuser.UniteUser,affichageuser.Grammage) VALUES (userUnit,gram);
    SELECT MAX(ID_AffichageUser) INTO maxID FROM affichageuser;
	INSERT INTO produits (produits.Libelle,produits.Lien_Photo,produits.Prix,produits.Unite, produits.ID_AffichageUser, produits.typeproduit, produits.LCASElib)
    VALUES (lib,lienPic,tarif,unite,maxID,type,LCASE(lib));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUser` (IN `name` VARCHAR(50), IN `prename` VARCHAR(50), IN `mail` VARCHAR(50), IN `num` VARCHAR(50), IN `passwd` VARCHAR(50), IN `adm` BOOLEAN)  BEGIN
	INSERT INTO utilisateurs (utilisateurs.Nom, utilisateurs.Prenom, utilisateurs.Email, utilisateurs.NumTel, utilisateurs.MotDePasse, utilisateurs.isAdmin)
    VALUES (name,prename,mail,num,SHA(passwd),adm);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `setEchellons` (IN `lib` VARCHAR(50), IN `val` INT)  BEGIN
	DECLARE maxID INT;
    SELECT MAX(produits.ID_Produit) INTO maxID FROM produits;
	INSERT INTO echellons (echellons.Libelle, echellons.Valeur, echellons.ID_Produit) VALUES (lib,val,maxID);
END$$

--
-- Fonctions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `verifyUser` (`username` VARCHAR(50), `passwd` VARCHAR(50)) RETURNS INT(11) BEGIN
	DECLARE nbSess INT;
    SELECT COUNT(*) INTO nbSess FROM utilisateurs WHERE (utilisateurs.Email = username OR utilisateurs.NumTel = username) AND utilisateurs.MotDePasse = SHA(passwd);
    RETURN nbSess;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `affichageuser`
--

CREATE TABLE `affichageuser` (
  `ID_AffichageUser` int(11) NOT NULL,
  `UniteUser` varchar(50) COLLATE utf8_bin NOT NULL,
  `Grammage` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Déchargement des données de la table `affichageuser`
--

INSERT INTO `affichageuser` (`ID_AffichageUser`, `UniteUser`, `Grammage`) VALUES
(1, 'pce', 100),
(2, 'pce', 250),
(3, 'pce', 150),
(4, 'pce', 100),
(5, 'g', NULL),
(8, 'pce', 7500),
(9, 'pce', 200),
(10, 'pce', 200),
(11, 'pce', 200),
(12, 'pce', 200),
(13, 'pce', 150),
(14, 'pce', 150),
(15, 'pce', 150),
(16, 'pce', 100),
(17, 'pce', 150),
(18, 'pce', 200),
(19, 'pce', 350),
(21, 'pce', 150),
(22, 'g', NULL),
(23, 'g', NULL),
(24, 'pce', 650),
(26, 'pce', 1000),
(27, 'pce', 200),
(28, 'pce', 150),
(29, 'pce', 1550),
(30, 'pce', 1550),
(31, 'g', 0),
(32, 'pce', 200),
(33, 'pce', 125),
(34, 'pce', 100),
(35, 'pce', 125),
(36, 'pce', 125),
(37, 'pce', 150),
(38, 'pce', 250),
(39, 'pce', 425),
(40, 'pce', 250),
(41, 'pce', 175),
(42, 'pce', 225),
(43, 'pce', 325),
(44, 'pce', 425),
(45, 'pce', 250),
(46, 'pce', 175),
(47, 'g', 0),
(49, 'g', 0),
(50, 'g', 0);

-- --------------------------------------------------------

--
-- Structure de la table `commander`
--

CREATE TABLE `commander` (
  `ID_Commandes` int(11) NOT NULL,
  `ID_Produit` int(11) NOT NULL,
  `Quantite` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Déchargement des données de la table `commander`
--

INSERT INTO `commander` (`ID_Commandes`, `ID_Produit`, `Quantite`) VALUES
(25, 20, 6),
(25, 21, 2),
(27, 20, 6),
(27, 21, 2);

-- --------------------------------------------------------

--
-- Structure de la table `commandes`
--

CREATE TABLE `commandes` (
  `ID_Commandes` int(11) NOT NULL,
  `Date_Passee` date NOT NULL,
  `Date_Recup` date DEFAULT NULL,
  `Recuperee` tinyint(1) NOT NULL,
  `ID_Utilisateur` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Déchargement des données de la table `commandes`
--

INSERT INTO `commandes` (`ID_Commandes`, `Date_Passee`, `Date_Recup`, `Recuperee`, `ID_Utilisateur`) VALUES
(25, '2022-05-30', '2022-05-30', 1, 1),
(27, '2022-05-30', '2022-05-30', 1, 1);

--
-- Déclencheurs `commandes`
--
DELIMITER $$
CREATE TRIGGER `delRowsCommandes` BEFORE DELETE ON `commandes` FOR EACH ROW BEGIN
	DELETE FROM commander WHERE ID_Commandes = old.ID_Commandes;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `echellons`
--

CREATE TABLE `echellons` (
  `ID_Echellon` int(11) NOT NULL,
  `Libelle` varchar(50) COLLATE utf8_bin NOT NULL,
  `Ordre` int(11) NOT NULL,
  `Valeur` int(11) NOT NULL,
  `ID_Produit` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Déchargement des données de la table `echellons`
--

INSERT INTO `echellons` (`ID_Echellon`, `Libelle`, `Ordre`, `Valeur`, `ID_Produit`) VALUES
(16, '1 pers', 0, 1, 19),
(17, '2 pers', 0, 2, 19),
(18, '3 pers', 0, 3, 19),
(19, '1 pers', 0, 2, 20),
(20, '2 pers', 0, 4, 20),
(21, '3 pers', 0, 6, 20),
(22, '1 pers', 0, 1, 21),
(23, '2 pers', 0, 2, 21),
(24, '3 pers', 0, 3, 21),
(25, '1 pers', 0, 1, 22),
(26, '2 pers', 0, 2, 22),
(27, '3 pers', 0, 3, 22),
(28, '1 pers', 0, 1, 23),
(29, '2 pers', 0, 2, 23),
(30, '3 pers', 0, 3, 23),
(34, '1 pers', 0, 1, 25),
(35, '2 pers', 0, 2, 25),
(36, '3 pers', 0, 3, 25),
(37, '1 pers', 0, 100, 26),
(38, '2 pers', 0, 200, 26),
(39, '3 pers', 0, 300, 26),
(40, '1 pers', 0, 100, 27),
(41, '2 pers', 0, 200, 27),
(42, '3 pers', 0, 300, 27),
(43, '1 pers', 0, 1, 31),
(44, '2 pers', 0, 2, 31),
(45, '3 pers', 0, 3, 31),
(46, '1 pers', 0, 1, 32),
(47, '2 pers', 0, 2, 32),
(48, '3 pers', 0, 3, 32),
(49, '1 pers', 0, 1, 36),
(50, '2 pers', 0, 2, 36),
(51, '3 pers', 0, 3, 36),
(52, '1 pers', 0, 2, 37),
(53, '2 pers', 0, 4, 37),
(54, '3 pers', 0, 6, 37),
(55, '1 pers', 0, 2, 38),
(56, '2 pers', 0, 4, 38),
(57, '3 pers', 0, 6, 38),
(58, '1 pers', 0, 1, 39),
(59, '2 pers', 0, 2, 39),
(60, '3 pers', 0, 3, 39),
(61, '1 pers', 0, 1, 40),
(62, '2 pers', 0, 2, 40),
(63, '3 pers', 0, 3, 40),
(64, '1 pers', 0, 1, 41),
(65, '2 pers', 0, 2, 41),
(66, '3 pers', 0, 3, 41),
(67, '1 pers', 0, 1, 42),
(68, '2 pers', 0, 2, 42),
(69, '3 pers', 0, 3, 42),
(70, '1 pers', 0, 1, 44),
(71, '2 pers', 0, 2, 44),
(72, '3 pers', 0, 3, 44),
(73, '1 pers', 0, 1, 45),
(74, '2 pers', 0, 2, 45),
(75, '3 pers', 0, 3, 45),
(76, '1 pers', 0, 1, 46),
(77, '2 pers', 0, 2, 46),
(78, '3 pers', 0, 3, 46),
(79, '1 pers', 0, 1, 47),
(80, '2 pers', 0, 2, 47),
(81, '3 pers', 0, 3, 47),
(82, '1 pers', 0, 1, 48),
(83, '2 pers', 0, 2, 48),
(84, '3 pers', 0, 3, 48),
(85, '1 pers', 0, 1, 49),
(86, '2 pers', 0, 2, 49),
(87, '3 pers', 0, 3, 49),
(88, '1 pers', 0, 1, 50),
(89, '2 pers', 0, 2, 50),
(90, '3 pers', 0, 3, 50);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `getcommandes`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `getcommandes` (
`ID_Commandes` int(11)
,`Date_Passee` date
,`Date_Recup` date
,`Libelle` varchar(50)
,`Quantite` varchar(61)
,`Client` varchar(101)
,`NumTel` char(10)
,`Email` varchar(50)
,`prixCalcule` double(19,2)
);

-- --------------------------------------------------------

--
-- Structure de la table `produits`
--

CREATE TABLE `produits` (
  `ID_Produit` int(11) NOT NULL,
  `Libelle` varchar(50) COLLATE utf8_bin NOT NULL,
  `Prix` float NOT NULL,
  `Unite` varchar(50) COLLATE utf8_bin NOT NULL,
  `Lien_Photo` varchar(50) COLLATE utf8_bin NOT NULL,
  `typeproduit` int(11) DEFAULT NULL,
  `ID_AffichageUser` int(11) DEFAULT NULL,
  `LCASELib` varchar(50) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Déchargement des données de la table `produits`
--

INSERT INTO `produits` (`ID_Produit`, `Libelle`, `Prix`, `Unite`, `Lien_Photo`, `typeproduit`, `ID_AffichageUser`, `LCASELib`) VALUES
(19, 'Tranche de gigot', 20.95, 'kg', '1654257852199.JPG', 4, 15, 'tranche de gigot'),
(20, 'Selle d\'agneau sans os', 23.95, 'kg', '2b02e1124e8241d9c34359daa90ed0e6.JPG', 4, 16, 'selle d\'agneau sans os'),
(21, 'Côte d\'agneau', 18.95, 'kg', 'c5dedeeab98cec06a22e9a9863bd0136.JPG', 4, 17, 'côte d\'agneau'),
(22, 'Chope d\'agneau', 18.95, 'kg', '5be5196cac7d1fa57fe50aec549a74f3.JPG', 4, 18, 'chope d\'agneau'),
(23, 'Becquet d\'agneau', 17.95, 'kg', '98bec652f345cff9fc56cd781db8e320.JPG', 4, 19, 'becquet d\'agneau'),
(25, 'Collier d\'agneau', 12.9, 'kg', '74407aa05bcf8a6bf62309ebae3eee69.JPG', 4, 21, 'collier d\'agneau'),
(26, 'Financière', 12.9, 'kg', '9575f91f185d6c13728eaf729184c449.JPG', 3, 22, 'financière'),
(27, 'Civet de porcelet', 8.9, 'kg', 'b1b9245ef466016839559390dd5b60af.JPG', 6, 23, 'civet de porcelet'),
(28, 'Filet Mignon de porc', 14.9, 'kg', '7f44adb0a2df9ad851ff5631c95ab969.JPG', 6, 24, 'filet mignon de porc'),
(30, 'Rôti de porc Noix d\'épaule', 8.95, 'kg', 'c54235d6b081c1ade956e9789150c64b.JPG', 6, 26, 'rôti de porc noix d\'épaule'),
(31, 'Côte de porc filet', 7.95, 'kg', '986676facbc81bd9acd6f31db5b420b0.JPG', 6, 27, 'côte de porc filet'),
(32, 'Côte de porc échine', 7.95, 'kg', '9d9ad61168ba52e2ffe960c802520569.JPG', 6, 28, 'côte de porc échine'),
(33, 'Filet de veau entier', 25.9, 'kg', 'efd96509c31f2bac75b2107ac22eda6e.JPG', 3, 29, 'filet de veau entier'),
(34, 'Filet de veau en tranches', 29.9, 'kg', 'efd96509c31f2bac75b2107ac22eda6e.JPG', 3, 30, 'filet de veau en tranches'),
(35, 'Blanquette de veau Epaule', 16.95, 'kg', '975d7f6a649d1cae64cf2807faa0660c.JPG', 3, 31, 'blanquette de veau epaule'),
(36, 'Côte de Veau', 18.9, 'kg', '2c57ca3b0b04ed3283867ceda071f69f.JPG', 3, 32, 'côte de veau'),
(37, 'Tournedos milanais', 15.9, 'kg', '34f7f5c735c02c3fd16f1a84052d2212.JPG', 4, 33, 'tournedos milanais'),
(38, 'Boulette Keufté (Menthe et Coriandre)', 12.95, 'kg', '4ba494aab02c22ae18bfa4333c10a16b.JPG', 4, 34, 'boulette keufté (menthe et coriandre)'),
(39, 'Cordon bleu Jambon fromage', 1.95, 'pce', '283d8e06d37ac5947d84220097761db5.JPG', 11, 35, 'cordon bleu jambon fromage'),
(40, 'Cordon bleu tomate mozza', 2.4, 'pce', '283d8e06d37ac5947d84220097761db5.JPG', 11, 36, 'cordon bleu tomate mozza'),
(41, 'Escalope de poulet panée', 1.5, 'pce', '5a6a000343e258b9f3873d1f70e74bf5.JPG', 8, 37, 'escalope de poulet panée'),
(42, 'Escalope panée', 23.9, 'kg', 'e1b8400a2142969e09a7778f2b4a306e.JPG', 3, 38, 'escalope panée'),
(43, 'Magret de canard', 19.9, 'kg', 'ffe118bee3f4014c8414b9a4e9b75e96.JPG', 12, 39, 'magret de canard'),
(44, 'Cuisse de Lapin', 17.9, 'kg', 'da348b183323a9195eb86555174fc528.JPG', 9, 40, 'cuisse de lapin'),
(45, 'Escalope de dinde', 14.9, 'kg', 'c4310652b027d4cbbdc211d171d1338a.JPG', 7, 41, 'escalope de dinde'),
(46, 'Escalope de poulet', 16.9, 'kg', 'b933c777c3ee3daffd6ca4e9074ab3d9.JPG', 8, 42, 'escalope de poulet'),
(47, 'Cuisses de poulet', 14.95, 'kg', '49ad50afd380c93491747bfd40206072.JPG', 8, 43, 'cuisses de poulet'),
(48, 'Cuisse de poulet Blanche', 4.95, 'kg', '4944b3366f6035848bdbaa0ff99ea37e.JPG', 8, 44, 'cuisse de poulet blanche'),
(49, 'Cuisse de pintade', 14.9, 'kg', '4e1c605a1ffed9dba06b39a5dccb8a74.JPG', 13, 45, 'cuisse de pintade'),
(50, 'Saucisse ménage', 14.95, 'kg', '9aa7bc28112d1ed806df9849c30fe109.JPG', 6, 46, 'saucisse ménage'),
(51, 'Chair à saucisse', 11.5, 'kg', '4d24b88699882fac9f80ed63959180d0.JPG', 6, 47, 'chair à saucisse'),
(53, 'Giroud', 2, 'kg', '1654008125048.JPG', 3, 49, 'giroud'),
(54, 'Giroud', 2, 'kg', '1654008179189.JPG', 3, 50, 'giroud');

--
-- Déclencheurs `produits`
--
DELIMITER $$
CREATE TRIGGER `manageProduits` AFTER DELETE ON `produits` FOR EACH ROW BEGIN
	DELETE FROM affichageuser WHERE affichageuser.ID_AffichageUser = old.ID_AffichageUser;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `manageProduitsBefore` BEFORE DELETE ON `produits` FOR EACH ROW BEGIN
	DELETE FROM echellons WHERE echellons.ID_Produit = old.ID_Produit;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `typeproduits`
--

CREATE TABLE `typeproduits` (
  `ID_TypeProduit` int(11) NOT NULL,
  `Libelle` varchar(50) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Déchargement des données de la table `typeproduits`
--

INSERT INTO `typeproduits` (`ID_TypeProduit`, `Libelle`) VALUES
(3, 'Veau'),
(4, 'Agneau'),
(5, 'Boeuf'),
(6, 'Porc'),
(7, 'Dinde'),
(8, 'Poulet'),
(9, 'Lapin'),
(10, 'Charcuterie'),
(11, 'Préparés'),
(12, 'Canard'),
(13, 'Pintade');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

CREATE TABLE `utilisateurs` (
  `ID_Utilisateur` int(11) NOT NULL,
  `Nom` varchar(50) COLLATE utf8_bin NOT NULL,
  `Prenom` varchar(50) COLLATE utf8_bin NOT NULL,
  `NumTel` char(10) COLLATE utf8_bin NOT NULL,
  `MotDePasse` varchar(100) COLLATE utf8_bin NOT NULL,
  `Email` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `isAdmin` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Déchargement des données de la table `utilisateurs`
--

INSERT INTO `utilisateurs` (`ID_Utilisateur`, `Nom`, `Prenom`, `NumTel`, `MotDePasse`, `Email`, `isAdmin`) VALUES
(1, 'Giroud', 'Lucas', '0782332034', 'd033e22ae348aeb5660fc2140aec35850c4da997', 'giroudlucas01@gmail.com', 1),
(15, 'Giroud', 'Christophe', '0621749778', 'd033e22ae348aeb5660fc2140aec35850c4da997', 'chgiroud@hotmail.com', 1),
(16, 'SERPE', 'Martine', '0624431639', 'a53d78141205358c3f29239a2abfdee5a9ae70c6', 'roussel.13004@gmail.com', 0);

-- --------------------------------------------------------

--
-- Structure de la vue `getcommandes`
--
DROP TABLE IF EXISTS `getcommandes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `getcommandes`  AS  select `commandes`.`ID_Commandes` AS `ID_Commandes`,`commandes`.`Date_Passee` AS `Date_Passee`,`commandes`.`Date_Recup` AS `Date_Recup`,`produits`.`Libelle` AS `Libelle`,ifnull(concat(`commander`.`Quantite`,`affichageuser`.`UniteUser`),concat(`commander`.`Quantite`,right(`produits`.`Unite`,1))) AS `Quantite`,concat(`utilisateurs`.`Nom`,' ',`utilisateurs`.`Prenom`) AS `Client`,`utilisateurs`.`NumTel` AS `NumTel`,`utilisateurs`.`Email` AS `Email`,round(`produits`.`Prix` / 1000 * ifnull(`commander`.`Quantite` * `affichageuser`.`Grammage`,`commander`.`Quantite`),2) AS `prixCalcule` from ((((`commandes` join `commander` on(`commandes`.`ID_Commandes` = `commander`.`ID_Commandes`)) join `utilisateurs` on(`commandes`.`ID_Utilisateur` = `utilisateurs`.`ID_Utilisateur`)) join `produits` on(`produits`.`ID_Produit` = `commander`.`ID_Produit`)) left join `affichageuser` on(`affichageuser`.`ID_AffichageUser` = `produits`.`ID_AffichageUser`)) where `commandes`.`Recuperee` = 0 ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `affichageuser`
--
ALTER TABLE `affichageuser`
  ADD PRIMARY KEY (`ID_AffichageUser`);

--
-- Index pour la table `commander`
--
ALTER TABLE `commander`
  ADD PRIMARY KEY (`ID_Commandes`,`ID_Produit`),
  ADD KEY `Commander_Produits0_FK` (`ID_Produit`);

--
-- Index pour la table `commandes`
--
ALTER TABLE `commandes`
  ADD PRIMARY KEY (`ID_Commandes`),
  ADD KEY `Commandes_Utilisateurs_FK` (`ID_Utilisateur`);

--
-- Index pour la table `echellons`
--
ALTER TABLE `echellons`
  ADD PRIMARY KEY (`ID_Echellon`),
  ADD KEY `ID_Produit` (`ID_Produit`);

--
-- Index pour la table `produits`
--
ALTER TABLE `produits`
  ADD PRIMARY KEY (`ID_Produit`),
  ADD KEY `typeproduit` (`typeproduit`),
  ADD KEY `ID_AffichageUser` (`ID_AffichageUser`);

--
-- Index pour la table `typeproduits`
--
ALTER TABLE `typeproduits`
  ADD PRIMARY KEY (`ID_TypeProduit`);

--
-- Index pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  ADD PRIMARY KEY (`ID_Utilisateur`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `affichageuser`
--
ALTER TABLE `affichageuser`
  MODIFY `ID_AffichageUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT pour la table `commandes`
--
ALTER TABLE `commandes`
  MODIFY `ID_Commandes` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT pour la table `echellons`
--
ALTER TABLE `echellons`
  MODIFY `ID_Echellon` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT pour la table `produits`
--
ALTER TABLE `produits`
  MODIFY `ID_Produit` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT pour la table `typeproduits`
--
ALTER TABLE `typeproduits`
  MODIFY `ID_TypeProduit` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  MODIFY `ID_Utilisateur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `commander`
--
ALTER TABLE `commander`
  ADD CONSTRAINT `Commander_Commandes_FK` FOREIGN KEY (`ID_Commandes`) REFERENCES `commandes` (`ID_Commandes`),
  ADD CONSTRAINT `Commander_Produits0_FK` FOREIGN KEY (`ID_Produit`) REFERENCES `produits` (`ID_Produit`);

--
-- Contraintes pour la table `commandes`
--
ALTER TABLE `commandes`
  ADD CONSTRAINT `Commandes_Utilisateurs_FK` FOREIGN KEY (`ID_Utilisateur`) REFERENCES `utilisateurs` (`ID_Utilisateur`);

--
-- Contraintes pour la table `echellons`
--
ALTER TABLE `echellons`
  ADD CONSTRAINT `echellons_ibfk_1` FOREIGN KEY (`ID_Produit`) REFERENCES `produits` (`ID_Produit`);

--
-- Contraintes pour la table `produits`
--
ALTER TABLE `produits`
  ADD CONSTRAINT `produits_ibfk_1` FOREIGN KEY (`typeproduit`) REFERENCES `typeproduits` (`ID_TypeProduit`),
  ADD CONSTRAINT `produits_ibfk_2` FOREIGN KEY (`ID_AffichageUser`) REFERENCES `affichageuser` (`ID_AffichageUser`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
