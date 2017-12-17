#1.1 Построить запрос, формирующий вывод всех данных обо всех преподавателях.
SELECT * FROM `Prepods`;


#1.2. Построить запрос, формирующий вывод фамилии и имени студентов, 
#обучающихся в первой группе отсортированные в алфавитном порядке по фамилии,
SELECT `LAST_NAME`, `FIRST_NAME` FROM `Students`
    WHERE `GROUP_ID` IN (SELECT `ID` FROM `GROUPS` WHERE `NAME` = '123456')
    ORDER BY `LAST_NAME`, `FIRST_NAME`;


#1.3. Вывести данные о студентах, фамилии которых начинаются на букву О
SELECT * FROM `Students` WHERE `LAST_NAME` LIKE 'О%';


#2.1. Вывести все оценки, которые поставил преподаватель 
#Проволоцкий В.Е. в октябре 2016 года.
SELECT * FROM `RATING` WHERE 
    `PREPODS_ID` in (SELECT `ID` FROM `Prepods` WHERE `LAST_NAME` = 'Васечкин')
    AND YEAR(`DATE`) = 2017 AND MONTH(`DATE`) = 10;


#2.2. Вывести всех студентах которые отсутствовали на лекциях.
SELECT DISTINCT `LAST_NAME`, `FIRST_NAME` 
    FROM `Students` as st 
    INNER JOIN `RATING` as rt ON st.`ID` = rt.`STUDENT_ID`
    INNER JOIN `STUDY_LOAD` as sl ON sl.`ID` = rt.`STUDY_ID`
    INNER JOIN `TYPE_STUDY_LOAD` as tsl ON tsl.`ID` = sl.`Type_STUDY_ID`
    WHERE rt.`IS_ABSENT` = 'Y' AND tsl.`NAME` = 'Lection';


#2.3. Вывести информацию о полученной оценке с указанием наименования 
#факультета, группы фио студента и преподавателя оценки и даты выставления
SELECT fk.`NAME` as 'Факультет', gr.`NAME` as 'Группа',
    st.`FIRST_NAME` as 'Имя Ученика', st.`LAST_NAME`  as 'Фаиилия Ученика',
    pr.`FIRST_NAME` as 'Имя Преподователя',
    pr.`LAST_NAME`  as 'Фамилия Преподователя',
    rt.`DATE` as 'Дата', rt.`VAL` as 'Оценка'
    FROM `RATING` as rt 
    INNER JOIN `Students` as st ON st.`ID` = rt.`STUDENT_ID`
    INNER JOIN `Prepods` as pr ON pr.`ID` = rt.`PREPODS_ID`
    INNER JOIN `GROUPS` as gr ON gr.`ID` = st.`GROUP_ID`
    INNER JOIN `Faculty` as fk ON fk.`ID` = gr.`FACULTY_ID`
    WHERE rt.VAL IS NOT NULL;


#2.4. Вывести информацию о занятиях во время которых оценки выставлялись не 
#основными(включенными в план ) преподавателями
SELECT rt.`DATE` as 'Дата', gr.`NAME` as 'Группа',
    sb.`NAME` as 'Предмет', tsl.`NAME` as 'Тип',
    pr2.`LAST_NAME` as 'Должен вести', pr1.`LAST_NAME` as 'Фактически вел'
    FROM `RATING` as rt
    INNER JOIN `Students` as st ON st.`ID` = rt.`STUDENT_ID`
    INNER JOIN `LESSONS` as ls
    ON ls.`STUDY_ID` = rt.`STUDY_ID` AND ls.`GROUP_ID` = st.`GROUP_ID`

    INNER JOIN `GROUPS` as gr ON gr.`ID` = st.`GROUP_ID`
    INNER JOIN `Prepods` as pr1 ON pr1.`ID` = rt.`PREPODS_ID`
    INNER JOIN `Prepods` as pr2 ON pr2.`ID` = ls.`PREPOD_ID`
    INNER JOIN `STUDY_LOAD` as sl ON sl.`ID` = rt.`STUDY_ID`
    INNER JOIN `TYPE_STUDY_LOAD` as tsl ON tsl.`ID` = sl.`Type_STUDY_ID`
    INNER JOIN `Subjects` as sb ON sb.`ID` = sl.`SUBJECT_ID`
    WHERE rt.`PREPODS_ID` <> ls.`PREPOD_ID`;

#2.5. Вывести отсортированный по фамилиям (прямом в порядке) список 
#преподавателей и номера групп, в которых они ставили оценки.
SELECT DISTINCT 
    pr.`FIRST_NAME` as 'Имя Преподователя',
    pr.`LAST_NAME`  as 'Фамилия Преподователя',
    gr.`NAME` as 'Группа'
    FROM `RATING` as rt
    INNER JOIN `Prepods` as pr ON pr.`ID` = rt.`PREPODS_ID`
    INNER JOIN `Students` as st ON st.`ID` = rt.`STUDENT_ID`
    INNER JOIN `GROUPS` as gr ON gr.`ID` = st.`GROUP_ID`
    ORDER BY pr.`LAST_NAME`;

#2.6. Вывести отсортированный по фамилиям (прямом в порядке) список всех 
#преподавателей и номера групп, в которых они ставили оценки.

SELECT DISTINCT 
    pr.`FIRST_NAME` as 'Имя Преподователя',
    pr.`LAST_NAME`  as 'Фамилия Преподователя',
    gr.`NAME` as 'Группа'
    FROM `RATING` as rt
    RIGHT JOIN `Prepods` as pr ON pr.`ID` = rt.`PREPODS_ID`
    LEFT JOIN `Students` as st ON st.`ID` = rt.`STUDENT_ID`
    LEFT JOIN `GROUPS` as gr ON gr.`ID` = st.`GROUP_ID`
    ORDER BY pr.`LAST_NAME`;

#2.7. Вывести коды и названия факультетов в которых нет групп
SELECT fk.`ID` as 'ID', fk.`NAME` as 'Название'
    FROM `Faculty` as fk
    WHERE 0  =
    (SELECT COUNT(*) FROM `GROUPS` as gr WHERE gr.`FACULTY_ID` = fk.`ID`);
