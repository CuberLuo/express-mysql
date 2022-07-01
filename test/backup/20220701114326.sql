/*
MySQL Backup
Database: 202003_ljt_mis
Backup Time: 2022-07-01 11:43:26
*/

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `202003_ljt_mis`.`ljt_administrator`;
DROP TABLE IF EXISTS `202003_ljt_mis`.`ljt_class`;
DROP TABLE IF EXISTS `202003_ljt_mis`.`ljt_class_course`;
DROP TABLE IF EXISTS `202003_ljt_mis`.`ljt_course`;
DROP TABLE IF EXISTS `202003_ljt_mis`.`ljt_major`;
DROP TABLE IF EXISTS `202003_ljt_mis`.`ljt_stu_score`;
DROP TABLE IF EXISTS `202003_ljt_mis`.`ljt_student`;
DROP TABLE IF EXISTS `202003_ljt_mis`.`ljt_teach_course`;
DROP TABLE IF EXISTS `202003_ljt_mis`.`ljt_teacher`;
DROP VIEW IF EXISTS `202003_ljt_mis`.`ljt_average_score`;
DROP VIEW IF EXISTS `202003_ljt_mis`.`ljt_student_list`;
DROP PROCEDURE IF EXISTS `202003_ljt_mis`.`getCoursesByTno`;
DROP PROCEDURE IF EXISTS `202003_ljt_mis`.`getTeachersByCno`;
CREATE TABLE `ljt_administrator` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` char(10) NOT NULL,
  `password` char(128) NOT NULL,
  `salt` char(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
CREATE TABLE `ljt_class` (
  `Mno` char(4) NOT NULL,
  `Clno` char(10) NOT NULL,
  `Clname` char(50) NOT NULL,
  PRIMARY KEY (`Clno`),
  KEY `FK_Mno` (`Mno`),
  CONSTRAINT `FK_Mno` FOREIGN KEY (`Mno`) REFERENCES `ljt_major` (`Mno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
CREATE TABLE `ljt_class_course` (
  `Clno` char(10) NOT NULL,
  `Cno` char(12) NOT NULL,
  `ScoreYear` char(9) NOT NULL,
  KEY `ClCo_Clno` (`Clno`),
  KEY `ClCo_Cno` (`Cno`),
  CONSTRAINT `ClCo_Clno` FOREIGN KEY (`Clno`) REFERENCES `ljt_class` (`Clno`),
  CONSTRAINT `ClCo_Cno` FOREIGN KEY (`Cno`) REFERENCES `ljt_course` (`Cno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
CREATE TABLE `ljt_course` (
  `Cno` char(12) NOT NULL,
  `Cname` char(20) NOT NULL,
  `CTerm` char(1) NOT NULL,
  `Chour` int NOT NULL,
  `Cway` char(2) NOT NULL,
  `Ccredit` float NOT NULL,
  PRIMARY KEY (`Cno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
CREATE TABLE `ljt_major` (
  `Mno` char(4) NOT NULL,
  `Mname` char(50) NOT NULL,
  PRIMARY KEY (`Mno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
CREATE TABLE `ljt_stu_score` (
  `Sno` char(12) NOT NULL,
  `Cno` char(12) NOT NULL,
  `Score` char(3) NOT NULL,
  `ScoreYear` char(9) NOT NULL,
  PRIMARY KEY (`Sno`,`Cno`,`ScoreYear`),
  KEY `Score_Cno` (`Cno`),
  KEY `score_index` (`Score`),
  CONSTRAINT `Score_Cno` FOREIGN KEY (`Cno`) REFERENCES `ljt_course` (`Cno`),
  CONSTRAINT `Score_Sno` FOREIGN KEY (`Sno`) REFERENCES `ljt_student` (`Sno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
CREATE TABLE `ljt_student` (
  `Sno` char(12) NOT NULL,
  `Sname` char(20) NOT NULL,
  `Ssex` char(1) NOT NULL,
  `Sage` int NOT NULL,
  `Scredit` float NOT NULL,
  `Sregion` char(10) NOT NULL,
  `Mno` char(4) NOT NULL,
  `Clno` char(10) NOT NULL,
  PRIMARY KEY (`Sno`),
  KEY `STU_FK_Mno` (`Mno`),
  KEY `STU_FK_Clno` (`Clno`),
  CONSTRAINT `STU_FK_Clno` FOREIGN KEY (`Clno`) REFERENCES `ljt_class` (`Clno`),
  CONSTRAINT `STU_FK_Mno` FOREIGN KEY (`Mno`) REFERENCES `ljt_major` (`Mno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
CREATE TABLE `ljt_teach_course` (
  `Tno` char(12) DEFAULT NULL,
  `Cno` char(12) DEFAULT NULL,
  KEY `Teach_Tno` (`Tno`),
  KEY `Teach_Cno` (`Cno`),
  CONSTRAINT `Teach_Cno` FOREIGN KEY (`Cno`) REFERENCES `ljt_course` (`Cno`),
  CONSTRAINT `Teach_Tno` FOREIGN KEY (`Tno`) REFERENCES `ljt_teacher` (`Tno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
CREATE TABLE `ljt_teacher` (
  `Tno` char(12) NOT NULL,
  `Tname` char(20) NOT NULL,
  `Tsex` char(1) NOT NULL,
  `Tage` int NOT NULL,
  `Tlevel` char(10) NOT NULL,
  `Tphone` char(11) NOT NULL,
  PRIMARY KEY (`Tno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ljt_average_score` AS select `ljt_stu_score`.`Cno` AS `Cno`,avg(`ljt_stu_score`.`Score`) AS `AVG_SCORE`,`ljt_stu_score`.`ScoreYear` AS `ScoreYear` from `ljt_stu_score` group by `ljt_stu_score`.`Cno`,`ljt_stu_score`.`ScoreYear`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ljt_student_list` AS select `s`.`Sno` AS `Sno`,`s`.`Sname` AS `Sname`,`s`.`Ssex` AS `Ssex`,`s`.`Sage` AS `Sage`,`s`.`Scredit` AS `Scredit`,`s`.`Sregion` AS `Sregion`,`m`.`Mname` AS `Smajor`,`c`.`Clname` AS `SClass` from ((`ljt_student` `s` join `ljt_class` `c`) join `ljt_major` `m`) where ((`s`.`Mno` = `m`.`Mno`) and (`s`.`Clno` = `c`.`Clno`));
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCoursesByTno`(in Query_Tno char(12))
BEGIN
	SELECT Cno,Cname,CTerm,Chour,Cway,Ccredit
	FROM ljt_course WHERE Cno IN
	(
	SELECT Cno FROM ljt_teach_course 
	WHERE Tno=Query_Tno
	);
END;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTeachersByCno`(in Query_Cno char(12))
BEGIN
	SELECT Tname FROM ljt_teacher WHERE Tno IN
	(
	SELECT DISTINCT Tno FROM ljt_teach_course 
	WHERE Cno=Query_Cno
	);
END;
BEGIN;
LOCK TABLES `202003_ljt_mis`.`ljt_administrator` WRITE;
DELETE FROM `202003_ljt_mis`.`ljt_administrator`;
INSERT INTO `202003_ljt_mis`.`ljt_administrator` (`id`,`username`,`password`,`salt`) VALUES (1, 'admin', '51126d5c6da3976d4ec04d4b0c838610cb3eb0dbc4c703f2db98d0c1b927f031', '6cQXvCOk28YvaxjxQkxhPFGozvffdwEs'),(3, 'admin2', 'b13f49982c25e817e7fe28aa877e63e1bba0a21ad56e69fb38930499cc9b7543', 'MZVLLBdraDXE7CxeJjw1oCjHVp7AsQfh');
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `202003_ljt_mis`.`ljt_class` WRITE;
DELETE FROM `202003_ljt_mis`.`ljt_class`;
INSERT INTO `202003_ljt_mis`.`ljt_class` (`Mno`,`Clno`,`Clname`) VALUES ('M010', '2020001001', '计算机科学与技术2001班'),('M010', '2020001002', '计算机科学与技术2002班'),('M019', '2020001901', '国际经济与贸易2001班'),('M019', '2020001902', '国际经济与贸易2002班'),('M019', '2020001903', '国际经济与贸易2003班'),('M334', '2020033401', '软件工程(中外合作办学)2001班'),('M334', '2020033402', '软件工程(中外合作办学)2002班'),('M334', '2020033403', '软件工程(中外合作办学)2003班');
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `202003_ljt_mis`.`ljt_class_course` WRITE;
DELETE FROM `202003_ljt_mis`.`ljt_class_course`;
INSERT INTO `202003_ljt_mis`.`ljt_class_course` (`Clno`,`Cno`,`ScoreYear`) VALUES ('2020001001', 'C985800', '21to22'),('2020001901', 'C657619', '21to22'),('2020001001', 'C733789', '20to21'),('2020001001', 'C757480', '20to21'),('2020001901', 'C860262', '20to21'),('2020001001', 'C499545', '21to22'),('2020001001', 'C443690', '20to21');
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `202003_ljt_mis`.`ljt_course` WRITE;
DELETE FROM `202003_ljt_mis`.`ljt_course`;
INSERT INTO `202003_ljt_mis`.`ljt_course` (`Cno`,`Cname`,`CTerm`,`Chour`,`Cway`,`Ccredit`) VALUES ('C273696', 'WTO与中国经济', '3', 64, '考试', 2),('C291893', '博弈论', '3', 48, '考查', 3),('C413871', '金融建模与量化投资', '1', 64, '考试', 5),('C443690', '数字逻辑电路课程设计', '2', 64, '考试', 2),('C468355', '游戏程序设计', '2', 48, '考查', 5),('C499545', '数据库原理及应用', '2', 48, '考试', 5),('C547090', '数字图像处理', '3', 64, '考查', 5),('C549170', '单片机原理及应用', '3', 48, '考试', 3),('C562815', '国际贸易原理', '1', 48, '考试', 3),('C629068', '离散数学', '2', 64, '考查', 3),('C657619', '外贸函电', '2', 48, '考试', 4),('C674946', '金融风险管理', '2', 48, '考查', 6),('C731392', '国际贸易理论与实务C', '2', 48, '考查', 5),('C733789', '.NET技术', '2', 32, '考试', 5),('C757480', '人工智能导论', '2', 64, '考查', 2),('C770058', '编程，数据结构和算法', '2', 48, '考试', 4),('C785611', '微机接口技术', '2', 64, '考试', 5),('C860262', '国际商法（英）', '2', 48, '考查', 3),('C944302', '自动控制原理', '3', 48, '考试', 3),('C985800', '程序设计基础C', '3', 48, '考查', 2);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `202003_ljt_mis`.`ljt_major` WRITE;
DELETE FROM `202003_ljt_mis`.`ljt_major`;
INSERT INTO `202003_ljt_mis`.`ljt_major` (`Mno`,`Mname`) VALUES ('M010', '计算机科学与技术'),('M019', '国际经济与贸易'),('M028', '广告学'),('M033', '法学'),('M055', '日语'),('M056', '播音与主持艺术'),('M058', '汉语言文学'),('M065', '金融学'),('M111', '数字媒体技术'),('M130', '网络工程'),('M331', '翻译'),('M333', '物联网工程'),('M334', '软件工程(中外合作办学)'),('M515', '制药工程(绿色制药)'),('M562', '数据科学与大数据技术');
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `202003_ljt_mis`.`ljt_stu_score` WRITE;
DELETE FROM `202003_ljt_mis`.`ljt_stu_score`;
INSERT INTO `202003_ljt_mis`.`ljt_stu_score` (`Sno`,`Cno`,`Score`,`ScoreYear`) VALUES ('202000100104', 'C985800', '55', '21to22'),('202000190110', 'C657619', '55', '21to22'),('202000100103', 'C985800', '58', '21to22'),('202000100103', 'C733789', '59', '20to21'),('202000100103', 'C757480', '60', '20to21'),('202000100104', 'C757480', '70', '20to21'),('202000190110', 'C860262', '70', '20to21'),('202000190233', 'C657619', '72', '20to21'),('202000100104', 'C499545', '80', '21to22'),('202000100103', 'C443690', '81', '20to21'),('202000100104', 'C443690', '83', '20to21'),('202000100104', 'C733789', '88', '20to21'),('202000100202', 'C785611', '88', '21to22'),('202000100103', 'C499545', '90', '21to22'),('202000100201', 'C468355', '99', '21to22');
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `202003_ljt_mis`.`ljt_student` WRITE;
DELETE FROM `202003_ljt_mis`.`ljt_student`;
INSERT INTO `202003_ljt_mis`.`ljt_student` (`Sno`,`Sname`,`Ssex`,`Sage`,`Scredit`,`Sregion`,`Mno`,`Clno`) VALUES ('202000100103', '胡胜红', '女', 20, 9, '浙江', 'M010', '2020001001'),('202000100104', '杨慧美', '女', 21, 14, '浙江', 'M010', '2020001001'),('202000100201', '汪炫明', '男', 20, 5, '安徽', 'M010', '2020001002'),('202000100202', '郭天睿', '男', 22, 5, '江苏', 'M010', '2020001002'),('202000190110', '何芃芃', '女', 20, 3, '上海', 'M019', '2020001901'),('202000190111', '毛梦兰', '女', 19, 0, '上海', 'M019', '2020001901'),('202000190230', '方虹玉', '女', 20, 0, '浙江', 'M019', '2020001902'),('202000190233', '赵德元', '男', 20, 4, '江苏', 'M019', '2020001902');
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `202003_ljt_mis`.`ljt_teach_course` WRITE;
DELETE FROM `202003_ljt_mis`.`ljt_teach_course`;
INSERT INTO `202003_ljt_mis`.`ljt_teach_course` (`Tno`,`Cno`) VALUES ('14472', 'C443690'),('23703', 'C443690'),('45976', 'C499545'),('14472', 'C731392'),('10995', 'C757480'),('49219', 'C985800'),('37077', 'C985800'),('18148', 'C770058'),('45976', 'C657619'),('20722', 'C733789'),('37077', 'C860262'),('45976', 'C860262'),('38061', 'C468355');
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `202003_ljt_mis`.`ljt_teacher` WRITE;
DELETE FROM `202003_ljt_mis`.`ljt_teacher`;
INSERT INTO `202003_ljt_mis`.`ljt_teacher` (`Tno`,`Tname`,`Tsex`,`Tage`,`Tlevel`,`Tphone`) VALUES ('10995', '贾刚', '女', 34, '副教授', '13161206453'),('13210', '逢子悦', '男', 41, '副教授', '13964507501'),('14472', '沈秀英', '男', 50, '教授', '18348205169'),('14503', '雷杰', '男', 59, '副教授', '17060648582'),('14813', '熊静', '女', 31, '助教', '18600188655'),('18148', '谢秀英', '女', 46, '教授', '17235677206'),('20722', '何桂英', '男', 35, '副教授', '18157878818'),('22477', '龙涛', '男', 34, '教授', '17972612804'),('22583', '姜平', '男', 55, '教授', '14314204032'),('23703', '钱芳', '女', 39, '教授', '18408615167'),('26891', '武艳', '男', 56, '助教', '16132492114'),('29252', '丁秀兰', '男', 50, '副教授', '14133014344'),('30906', '吕军', '男', 31, '讲师', '15270911605'),('33569', '任超', '女', 37, '副教授', '13665964320'),('36127', '吕娜', '女', 55, '教授', '17393446392'),('37077', '沈娜', '女', 34, '副教授', '17676150998'),('38061', '唐勇', '男', 42, '副教授', '13336560578'),('45976', '邵敏', '女', 36, '助教', '17682433260'),('47855', '张洋', '男', 48, '助教', '15497089213'),('48472', '黎娟', '男', 32, '副教授', '14418477950'),('49219', '余勇', '女', 36, '助教', '19039573893');
UNLOCK TABLES;
COMMIT;
CREATE DEFINER = `root`@`localhost` TRIGGER `T1` AFTER INSERT ON `ljt_stu_score` FOR EACH ROW BEGIN
	if new.Score<0 OR new.Score>100 then
		DELETE FROM ljt_stu_score WHERE Score=new.Score;
	end if;
END;;
CREATE DEFINER = `root`@`localhost` TRIGGER `T2` AFTER INSERT ON `ljt_stu_score` FOR EACH ROW BEGIN
	if new.Score>=60 AND new.Score<=100 then
		UPDATE ljt_student 
		SET Scredit=Scredit+(SELECT Ccredit FROM ljt_course WHERE Cno=new.Cno)
		WHERE Sno=new.Sno;
	end if;
END;;
