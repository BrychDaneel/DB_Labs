#4. Добавить  факультеты КСИС и ФИТУ
INSERT INTO `Faculty`(`NAME`) VALUES ('КСИС'), ('ФИТУ');


#1. Добавить новую группу с номером 123456
INSERT INTO `GROUPS`(`NAME`,  `FACULTY_ID`) 
    SELECT '123456', `ID` FROM `Faculty` WHERE `NAME`='ФИТУ';


#2. Внести в групп 123456 студентов Иванова и Петрова
SELECT @gr_123_id:=`ID` FROM `GROUPS` WHERE `NAME`='123456';
INSERT INTO `Students`(`GROUP_ID`, `FIRST_NAME`, `LAST_NAME`) VALUES 
    (@gr_123_id, 'Иван', 'Иванов'), (@gr_123_id, 'Петр', 'Петров');


#3. Назначить студента Иванова старостой группы
SELECT @st_id:=`ID` FROM `Students` WHERE `LAST_NAME`='Иванов';
UPDATE `GROUPS` SET `HEAD_GROUP` = @st_id WHERE `NAME` = '123456';


#5. Добавить  преподавателей Васечкина и Петечкина 
#на факультеты КСИС и ФИТУ соответственно
SELECT @fk_ksis_id:=`ID` FROM `Faculty` WHERE `NAME` = 'КСИС';
INSERT INTO `Prepods`(`FIRST_NAME`, `LAST_NAME`, `FACULTY_ID`)
    VALUES ('Вася', 'Васечкин', @fk_ksis_id);

SELECT @fk_fity_id:=`ID` FROM `Faculty` WHERE `NAME` = 'ФИТУ';
INSERT INTO `Prepods`(`FIRST_NAME`, `LAST_NAME`, `FACULTY_ID`)
    VALUES ('Петя', 'Петечкин', @fk_fity_id);


#6. Назначить преподавателю Васечкину ведение предмета 
#«Введение в специальность» для группы 123456
INSERT INTO `Subjects`(`NAME`, `FACULTY_ID`)
    VALUES ('Введение в специалность', @fk_ksis_id);
INSERT INTO `TYPE_STUDY_LOAD`(`NAME`) VALUES ('Lection');
SELECT @lection:=`ID` FROM `TYPE_STUDY_LOAD` WHERE `NAME` = 'Lection';
INSERT INTO `STUDY_LOAD`(`ID`, `SUBJECT_ID`, `Type_STUDY_ID`) VALUES
    ('Введение Л', 
    (SELECT `ID` FROM `Subjects` WHERE `NAME` = 'Введение в специалность'),
    @lection);


SELECT @prep_vas_id:=`ID` FROM `Prepods`
    WHERE `LAST_NAME` = 'Васечкин';
INSERT INTO `LESSONS`( `GROUP_ID`, `PREPOD_ID`, `STUDY_ID`)
    VALUES (@gr_123_id, @prep_vas_id, 'Введение Л');


#7. Поставить Студенту Иванову по предмету «Введение в специальность» 
#оценку 10, отметить отсутствие студента Петрова на данном занятии
INSERT INTO `RATING`(`DATE`, `PREPODS_ID`, `STUDENT_ID`, `STUDY_ID`, `VAL`)
    SELECT '2017-10-10', @prep_vas_id, `ID`, 'Введение Л', 10 
    FROM `Students` WHERE `LAST_NAME`='Иванов';

INSERT INTO `RATING`(`DATE`, `PREPODS_ID`, `STUDENT_ID`, `STUDY_ID`,`IS_ABSENT`)
    SELECT '2017-10-10', @prep_vas_id, `ID`, 'Введение Л', 'Y'
    FROM `Students` WHERE `LAST_NAME`='Петров';



#8. Наполнить базу таким образом, чтобы в базе появилась информация 
#по различным предметам (минимум 4), по каждому из которых стояло бы 
#не мене 3 отметок(минимум 5 студентам )
INSERT INTO `Subjects`(`NAME`, `FACULTY_ID`)
    VALUES ('ППО', @fk_ksis_id), ('МДиСУБД', @fk_ksis_id), 
    ('МЧА', @fk_ksis_id), ('ИСП', @fk_ksis_id);

INSERT INTO `STUDY_LOAD`(`ID`, `SUBJECT_ID`, `Type_STUDY_ID`) VALUES
    ('ППО Л', (SELECT `ID` FROM `Subjects` WHERE `NAME` = 'ППО'), @lection),
    ('МДиСУБД Л', (SELECT `ID` FROM `Subjects` WHERE `NAME` = 'МДиСУБД'), @lection),
    ('МЧА Л', (SELECT `ID` FROM `Subjects` WHERE `NAME` = 'МЧА'), @lection),
    ('ИСП Л', (SELECT `ID` FROM `Subjects` WHERE `NAME` = 'ИСП'), @lection);

INSERT INTO `Students`(`GROUP_ID`, `FIRST_NAME`, `LAST_NAME`) VALUES 
    (@gr_123_id, 'Денис', 'Денисов'), (@gr_123_id, 'Олег', 'Олегов'),
    (@gr_123_id, 'Саша', 'Смирнов'), (@gr_123_id, 'Коля', 'Колянов');


SELECT @prep_pet_id:=`ID` FROM `Prepods` WHERE `LAST_NAME` = 'Петечкин';

INSERT INTO `LESSONS`( `GROUP_ID`, `PREPOD_ID`, `STUDY_ID`) VALUES
    (@gr_123_id, @prep_vas_id, 'ППО Л'), (@gr_123_id, @prep_vas_id, 'МДиСУБД Л'), 
    (@gr_123_id, @prep_pet_id, 'МЧА Л'), (@gr_123_id, @prep_pet_id, 'ИСП Л');


SELECT @ivan_id:=`ID` FROM `Students` WHERE `LAST_NAME` = 'Иванов';
SELECT @petrov_id:=`ID` FROM `Students` WHERE `LAST_NAME` = 'Петров';
SELECT @denis_id:=`ID` FROM `Students` WHERE `LAST_NAME` = 'Денисов';
SELECT @oleg_id:=`ID` FROM `Students` WHERE `LAST_NAME` = 'Олегов';
SELECT @sasha_id:=`ID` FROM `Students` WHERE `LAST_NAME` = 'Смирнов';


INSERT INTO `RATING`(`DATE`, `PREPODS_ID`, `STUDENT_ID`, 
    `STUDY_ID`,`IS_ABSENT`, `VAL`) VALUES
    ('2017-09-12', @prep_vas_id, @ivan_id, 'ППО Л', 'N', 5),
    ('2017-09-13', @prep_vas_id, @ivan_id, 'ППО Л', 'N', 7),
    ('2017-09-14', @prep_vas_id, @ivan_id, 'ППО Л', 'Y', NULL),

    ('2017-09-12', @prep_vas_id, @petrov_id, 'ППО Л', 'N', 9),
    ('2017-09-13', @prep_vas_id, @petrov_id, 'ППО Л', 'N', 7),
    ('2017-09-14', @prep_vas_id, @petrov_id, 'ППО Л', 'N', 8),

    ('2017-09-12', @prep_vas_id, @denis_id, 'ППО Л', 'N', 6),
    ('2017-09-13', @prep_vas_id, @denis_id, 'ППО Л', 'N', 4),
    ('2017-09-14', @prep_vas_id, @denis_id, 'ППО Л', 'N', 6),

    ('2017-09-12', @prep_vas_id, @oleg_id, 'ППО Л', 'N', 8),
    ('2017-09-13', @prep_vas_id, @oleg_id, 'ППО Л', 'Y', NULL),
    ('2017-09-14', @prep_vas_id, @oleg_id, 'ППО Л', 'N', 3),

    ('2017-09-12', @prep_vas_id, @sasha_id, 'ППО Л', 'N', 5),
    ('2017-09-13', @prep_vas_id, @sasha_id, 'ППО Л', 'N', 5),
    ('2017-09-14', @prep_pet_id, @sasha_id, 'ППО Л', 'N', 5),


    ('2017-09-12', @prep_vas_id, @ivan_id, 'МДиСУБД Л', 'N', 6),
    ('2017-09-13', @prep_vas_id, @ivan_id, 'МДиСУБД Л', 'N', 4),
    ('2017-09-14', @prep_vas_id, @ivan_id, 'МДиСУБД Л', 'Y', NULL),

    ('2017-09-12', @prep_vas_id, @petrov_id, 'МДиСУБД Л', 'N', 2),
    ('2017-09-13', @prep_vas_id, @petrov_id, 'МДиСУБД Л', 'N', 4),
    ('2017-09-14', @prep_vas_id, @petrov_id, 'МДиСУБД Л', 'N', 6),

    ('2017-09-12', @prep_vas_id, @denis_id, 'МДиСУБД Л', 'N', 7),
    ('2017-09-13', @prep_vas_id, @denis_id, 'МДиСУБД Л', 'N', 3),
    ('2017-09-14', @prep_vas_id, @denis_id, 'МДиСУБД Л', 'N', 7),

    ('2017-09-12', @prep_vas_id, @oleg_id, 'МДиСУБД Л', 'N', 2),
    ('2017-09-13', @prep_vas_id, @oleg_id, 'МДиСУБД Л', 'Y', NULL),
    ('2017-09-14', @prep_vas_id, @oleg_id, 'МДиСУБД Л', 'N', 8),

    ('2017-09-12', @prep_vas_id, @sasha_id, 'МДиСУБД Л', 'N', 3),
    ('2017-09-13', @prep_vas_id, @sasha_id, 'МДиСУБД Л', 'N', 6),
    ('2017-09-14', @prep_vas_id, @sasha_id, 'МДиСУБД Л', 'N', 4),


    ('2017-09-12', @prep_pet_id, @ivan_id, 'МЧА Л', 'N', 6),
    ('2017-09-13', @prep_pet_id, @ivan_id, 'МЧА Л', 'N', 7),
    ('2017-09-14', @prep_pet_id, @ivan_id, 'МЧА Л', 'Y', NULL),

    ('2017-09-12', @prep_pet_id, @petrov_id, 'МЧА Л', 'N', 3),
    ('2017-09-13', @prep_pet_id, @petrov_id, 'МЧА Л', 'N', 6),
    ('2017-09-14', @prep_pet_id, @petrov_id, 'МЧА Л', 'N', 4),

    ('2017-09-12', @prep_pet_id, @denis_id, 'МЧА Л', 'N', 7),
    ('2017-09-13', @prep_pet_id, @denis_id, 'МЧА Л', 'N', 9),
    ('2017-09-14', @prep_pet_id, @denis_id, 'МЧА Л', 'N', 6),

    ('2017-09-12', @prep_pet_id, @oleg_id, 'МЧА Л', 'N', 5),
    ('2017-09-13', @prep_pet_id, @oleg_id, 'МЧА Л', 'Y', NULL),
    ('2017-09-14', @prep_pet_id, @oleg_id, 'МЧА Л', 'N', 7),

    ('2017-09-12', @prep_pet_id, @sasha_id, 'МЧА Л', 'N', 4),
    ('2017-09-13', @prep_pet_id, @sasha_id, 'МЧА Л', 'N', 7),
    ('2017-09-14', @prep_pet_id, @sasha_id, 'МЧА Л', 'N', 3),


    ('2017-09-12', @prep_pet_id, @ivan_id, 'ИСП Л', 'N', 5),
    ('2017-09-13', @prep_pet_id, @ivan_id, 'ИСП Л', 'N', 3),
    ('2017-09-14', @prep_pet_id, @ivan_id, 'ИСП Л', 'Y', NULL),

    ('2017-09-12', @prep_pet_id, @petrov_id, 'ИСП Л', 'N', 8),
    ('2017-09-13', @prep_pet_id, @petrov_id, 'ИСП Л', 'N', 7),
    ('2017-09-14', @prep_pet_id, @petrov_id, 'ИСП Л', 'N', 4),

    ('2017-09-12', @prep_pet_id, @denis_id, 'ИСП Л', 'N', 8),
    ('2017-09-13', @prep_pet_id, @denis_id, 'ИСП Л', 'N', 4),
    ('2017-09-14', @prep_pet_id, @denis_id, 'ИСП Л', 'N', 3),

    ('2017-09-12', @prep_pet_id, @oleg_id, 'ИСП Л', 'N', 8),
    ('2017-09-13', @prep_pet_id, @oleg_id, 'ИСП Л', 'Y', NULL),
    ('2017-09-14', @prep_pet_id, @oleg_id, 'ИСП Л', 'N', 4),

    ('2017-09-12', @prep_pet_id, @sasha_id, 'ИСП Л', 'N', 9),
    ('2017-09-13', @prep_pet_id, @sasha_id, 'ИСП Л', 'N', 4),
    ('2017-09-14', @prep_pet_id, @sasha_id, 'ИСП Л', 'N', 9);


#9. Очистить базу
/*
DELETE FROM `LESSONS`;
DELETE FROM `RATING`;
DELETE FROM `STUDY_LOAD`;
DELETE FROM `TYPE_STUDY_LOAD`;
DELETE FROM `Subjects`;
DELETE FROM `Prepods`;
UPDATE `GROUPS` SET `HEAD_GROUP` = NULL;
DELETE FROM `Students`;
DELETE FROM `GROUPS`;
DELETE FROM `Faculty`;
*/
