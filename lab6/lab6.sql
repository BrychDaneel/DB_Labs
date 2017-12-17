#1.1. Определить количество прошедших занятий
SELECT COUNT(DISTINCT `DATE`) as 'Колмичество занятий'
    FROM `RATING`;


#1.2.  Вывести 10 лучших студентов по средней оценке

/*CREATE TEMPORARY TABLE tmp_top as
(SELECT st.`ID` as id, st.`FIRST_NAME` as first_name, 
#    st.`LAST_NAME` as last_name, AVG(rt.`VAL`) as avg_val
        FROM `RATING` as rt
        INNER JOIN `Students` as st ON st.`ID` = rt.`STUDENT_ID`
        GROUP BY rt.`STUDENT_ID`
        ORDER BY AVG(rt.`VAL`)  DESC);

CREATE TEMPORARY TABLE tmp_top2 as 
    (SELECT * FROM tmp_top);*/

SELECT rt1.first_name as 'Имя', rt1.last_name as 'Фамилия', 
rt1.avg_val as 'Средний балл'
    FROM
        (SELECT st.`ID` as id, st.`FIRST_NAME` as first_name, 
        st.`LAST_NAME` as last_name, AVG(rt.`VAL`) as avg_val
            FROM `RATING` as rt
            INNER JOIN `Students` as st ON st.`ID` = rt.`STUDENT_ID`
            GROUP BY rt.`STUDENT_ID`
        ) as rt1

    WHERE
        4 > (SELECT COUNT(*)
            FROM
            (SELECT st.`ID` as id, st.`FIRST_NAME` as first_name, 
            st.`LAST_NAME` as last_name, AVG(rt.`VAL`) as avg_val
                FROM `RATING` as rt
                INNER JOIN `Students` as st ON st.`ID` = rt.`STUDENT_ID`
                GROUP BY rt.`STUDENT_ID`
            ) as rt2
            WHERE
                (rt1.avg_val < rt2.avg_val
                OR (rt1.avg_val = rt2.avg_val AND rt1.last_name > rt2.last_name)
                OR (rt1.avg_val = rt2.avg_val AND rt1.last_name = rt2.last_name
                    AND rt1.first_name > rt2.first_name)
                OR (rt1.avg_val = rt2.avg_val AND rt1.last_name = rt2.last_name
                    AND rt1.first_name = rt2.first_name OR rt1.id > rt2.id))
        )
    ORDER BY rt1.avg_val DESC;

#1.3. Получить количество предметов и типов занятий по которым стоят оценки
SELECT COUNT(DISTINCT sl.`SUBJECT_ID`) AS 'Предметы с оценками',
    COUNT(DISTINCT sl.`Type_STUDY_ID`) AS 'Типы с оценками'
    FROM `RATING` as rt
    INNER JOIN `STUDY_LOAD` as sl ON sl.`ID` = rt.`STUDY_ID`
    WHERE rt.`VAL` IS NOT NULL;


#1.4. Вывести список преподавателей отсортированный по количеству оценок,
#которые они поставили
SELECT pr.`FIRST_NAME` as 'Имя', pr.`LAST_NAME` as 'Фамилия',
    COUNT(rt.`VAL`) as 'Количество оценок'
    FROM `RATING` as rt
    RIGHT JOIN `Prepods` as pr ON pr.`ID` = rt.`PREPODS_ID`
    GROUP BY pr.`FIRST_NAME`, pr.`LAST_NAME`
    ORDER BY COUNT(rt.`VAL`) DESC;


#1.5. Вывести фамилии студентов у которых нет ни одной оценки
SELECT st.`FIRST_NAME` as 'Имя', st.`LAST_NAME` as 'Фамилия'
    FROM `Students` as st
    WHERE 0 =
    (SELECT COUNT(rt.`VAL`) FROM `RATING` as rt 
        WHERE rt.`STUDENT_ID` = st.`ID`);


#1.6. Вывести информацию о студенте средняя оценка которого максимальна

/*SELECT st.`FIRST_NAME` as 'Имя', st.`LAST_NAME` as 'Фамилия', 
    AVG(rt.`VAL`) as 'Средний балл'
    FROM `RATING` as rt
    INNER JOIN `Students` as st ON st.`ID` = rt.`STUDENT_ID`
    GROUP BY rt.`STUDENT_ID`
    ORDER BY AVG(rt.`VAL`)  DESC
    LIMIT 1;*/

/*SELECT st.`FIRST_NAME` as 'Имя', st.`LAST_NAME` as 'Фамилия',
    AVG(rt.`VAL`) as 'Средний балл'
    FROM `RATING` as rt
    INNER JOIN `Students` as st ON st.`ID` = rt.`STUDENT_ID`
    GROUP BY rt.`STUDENT_ID`
    HAVING 0.01 > ABS(AVG(rt.`VAL`) -
        (SELECT MAX(avg_table.avg_rt) FROM (
            SELECT AVG(rt2.`VAL`) as avg_rt
                FROM `RATING` as rt2
                GROUP BY rt2.`STUDENT_ID`) as avg_table));*/

SELECT rt1.first_name as 'Имя', rt1.last_name as 'Фамилия', 
rt1.avg_val as 'Средний балл'
    FROM
        (SELECT st.`ID` as id, st.`FIRST_NAME` as first_name, 
        st.`LAST_NAME` as last_name, AVG(rt.`VAL`) as avg_val
            FROM `RATING` as rt
            INNER JOIN `Students` as st ON st.`ID` = rt.`STUDENT_ID`
            GROUP BY rt.`STUDENT_ID`
        ) as rt1

    WHERE
        2 > (SELECT COUNT(*)
            FROM
            (SELECT st.`ID` as id, st.`FIRST_NAME` as first_name, 
            st.`LAST_NAME` as last_name, AVG(rt.`VAL`) as avg_val
                FROM `RATING` as rt
                INNER JOIN `Students` as st ON st.`ID` = rt.`STUDENT_ID`
                GROUP BY rt.`STUDENT_ID`
            ) as rt2
            WHERE
                (rt1.avg_val < rt2.avg_val
                OR (rt1.avg_val = rt2.avg_val AND rt1.last_name > rt2.last_name)
                OR (rt1.avg_val = rt2.avg_val AND rt1.last_name = rt2.last_name
                    AND rt1.first_name > rt2.first_name)
                OR (rt1.avg_val = rt2.avg_val AND rt1.last_name = rt2.last_name
                    AND rt1.first_name = rt2.first_name OR rt1.id > rt2.id))
        )
    ORDER BY rt1.avg_val DESC;
