SET SERVEROUTPUT ON;

--DECLARE
--  n_counter NUMBER := 1;
--BEGIN
--  WHILE n_counter <= 5 LOOP
--    DBMS_OUTPUT.PUT_LINE('Counter :' || n_counter );
--    n_counter := n_counter + 1;
--  END LOOP;
--END;
--
--DECLARE
--   n_counter NUMBER := 1;
--BEGIN
--   WHILE n_counter <= 5
--      LOOP
--        DBMS_OUTPUT.PUT_LINE( 'Counter : ' || n_counter );
--        n_counter := n_counter + 1;
--        EXIT WHEN n_counter = 3;
--      END LOOP;
--   END;
--
--DECLARE
--  l_counter NUMBER := 0;
--BEGIN
--  LOOP
--    l_counter := l_counter + 1;
--    IF l_counter > 3 THEN
--      EXIT;
--    END IF;
--    dbms_output.put_line( 'Inside loop: ' || l_counter )  ;
--  END LOOP;
--  -- control resumes here after EXIT
--  dbms_output.put_line( 'After loop: ' || l_counter );
--END;
--/
--DECLARE
--    l_step PLS_INTEGER :=2;
--BEGIN
--         FOR counter IN 1..5 LOOP
--         dbms_output.put_line (counter*l_step);
--
--         END LOOP;
--
--END;
--
--
--
--
----Parameterizded Cursor
--Declare 
--Cursor c_content(p_ID Number := &id, p_Status char:='N')
--Is 
--select first_name,
--      DATE_OF_BIRTH,
--      status
--      from 
--      teacher_1.student
--      where student_id=p_ID
--      And status =p_Status;
--      
--      Begin
--      for idx In c_content
--      LOOP 
--      DBMS_OUTPUT.PUT_LINE(idx.first_name||','||idx.DATE_OF_BIRTH||','||idx.status);
--      END LOOP;
--      
--      END;
--      /
--      
      
--TASK1 Create anonymous block that prints out all teachers work email address using loop and fetch.

DECLARE
  is_Work_Email     teacher_1.teacher.work_email%TYPE;
  --create a cursor 
    CURSOR cur_teacher IS
    SELECT
        work_email    
    FROM
        teacher_1.teacher;
        
BEGIN
  -- Open the cursor
    OPEN cur_teacher;
  -- Fetch and print teacher information using the custom record
    
    LOOP
        FETCH cur_teacher INTO is_Work_Email;
        EXIT WHEN cur_teacher%notfound;
        dbms_output.put_line('Work_Email : '||is_Work_Email);

    END LOOP;
--close cursor
    CLOSE cur_teacher;
END;
/

--TASK 2
-- Create anonymous block that divides 128 by 2 till number reaches 1 using while loop, print out all steps in between.
DECLARE
lv_number1 NUMBER:=128;
lv_number2 NUMBER:=2;
lv_result Number:=0;

BEGIN

WHILE(true)
LOOP
    lv_result:=lv_number1/lv_number2;
    DBMS_OUTPUT.PUT_LINE('THE NUMBERS '||lv_number1 ||'/' || lv_number2 || ' RESULT : ' || lv_result );
        lv_number1:=lv_result;
        EXIT WHEN lv_result = 1;
     END LOOP;
END;
/

DECLARE
lv_number1 NUMBER:=128;
lv_number2 NUMBER:=2;
lv_result Number:=0;

BEGIN

WHILE(lv_result != 1)
LOOP
    lv_result:=lv_number1/lv_number2;
    DBMS_OUTPUT.PUT_LINE('THE NUMBERS '||lv_number1 ||'/' || lv_number2 || ' RESULT : ' || lv_result );
    lv_number1:=lv_result;
     END LOOP;
END;
/

--TASK3
--Create anonymous block that prints out all parents names and surnames as a text using for loop.

Declare
CURSOR cur_parent 
IS SELECT FIRST_NAME,LAST_NAME FROM  teacher_1.parent order by FIRST_NAME ;
BEGIN

for idx IN cur_parent
    LOOP
    DBMS_OUTPUT.PUT_LINE('Names '||idx.FIRST_NAME ||','||idx.LAST_NAME);
    END LOOP;
END;
/


--Task4
--Create anonymous block that prints out first 10 rows from students table (all columns) and the names of these printed columns 
--(just once) as a header in the console output. Align the text properly if possible.

Declare
CURSOR cur_student(s_ID Number:=10)
IS 
SELECT  *  FROM  teacher_1.student where student_id<=s_ID order by student_id ;
BEGIN
    DBMS_OUTPUT.PUT_LINE('FIRST_NAME,  LAST_NAME, DATE_OF_BIRTH, SOCIAL_SECURITY_NO, EMAIL, PHONE_NO, DATE_OF_JOINING, STATUS, STUDY_CLASS, PARENT_ID, DATE_CREATED, USER_ID');

for idx IN cur_student

    LOOP
      DBMS_OUTPUT.PUT_LINE(
            idx.FIRST_NAME || ', ' ||
            idx.LAST_NAME || ', ' ||
            TO_CHAR(idx.DATE_OF_BIRTH, 'YYYY-MM-DD') || ', ' ||
            idx.SOCIAL_SECURITY_NO || ', ' ||
            idx.EMAIL || ', ' ||
            idx.PHONE_NO || ', ' ||
            TO_CHAR(idx.DATE_OF_JOINING, 'YYYY-MM-DD') || ', ' ||
            idx.STATUS || ',         ' ||
            idx.STUDY_CLASS ||' ,      ' ||
            idx.PARENT_ID || ',          ' ||
            TO_CHAR(idx.DATE_CREATED, 'YYYY-MM-DD') || '                      ' ||
                                           idx.USER_ID
        );
    END LOOP;
END;
/

--TASK5
--Create anonymous block that would print out all parents and for each parent print out all kids, print their names in the console and indent students for readability.
DECLARE
    CURSOR cur_parents IS
 SELECT parent_id, first_name, last_name FROM teacher_1.parent;
BEGIN
    -- Iterate over parents
    FOR parent_idx IN cur_parents 
    LOOP
        -- Print parent name
        DBMS_OUTPUT.PUT_LINE('Parents '||parent_idx.first_name || ' ' || parent_idx.last_name);
    
        -- Declare and open a cursor for students of this parent
        FOR student_idx IN (SELECT first_name, last_name FROM teacher_1.student WHERE parent_id = parent_idx.parent_id) 
        LOOP
            DBMS_OUTPUT.PUT_LINE('  kids  ' || student_idx.first_name || ' ' || student_idx.last_name);
        END LOOP;
    END LOOP;
END;
/

--TASK6
--To previously created solution add logic that would print out - Elementary school, Middle School, Highschool to each kid.
--

--SELECT * FROM teacher_1.student
DECLARE
    CURSOR cur_parents IS
        SELECT parent_id, first_name, last_name FROM teacher_1.parent;
BEGIN
    -- Iterate over parents
    FOR parent_idx IN cur_parents  
    LOOP
        DBMS_OUTPUT.PUT_LINE('Parents '||parent_idx.first_name || ' ' || parent_idx.last_name);
    
        FOR student_idx IN (SELECT first_name, last_name,STUDY_CLASS FROM teacher_1.student WHERE parent_id = parent_idx.parent_id)
        LOOP
                CASE WHEN student_idx.STUDY_CLASS < 4 THEN
                  DBMS_OUTPUT.PUT_LINE('Elementary school ' || student_idx.first_name || ' ' || student_idx.last_name);
                WHEN student_idx.STUDY_CLASS > 4 and student_idx.STUDY_CLASS <=7 THEN
            DBMS_OUTPUT.PUT_LINE('  Middle School  ' || student_idx.first_name || ' ' || student_idx.last_name);
                ELSE
            DBMS_OUTPUT.PUT_LINE('  Highschool  ' || student_idx.first_name || ' ' || student_idx.last_name);
                 END CASE;
        END LOOP;
    END LOOP;
END;
/

--TASK7
--Create anonymous block that would print for each student - name, surname, max, min and average grade across all courses.
--SELECT * FROM teacher_1.student_course
DECLARE
    CURSOR cur_all_students_grades IS
        SELECT  first_name, last_name ,max(sc.Final_grade) as Max_Grade,min(sc.final_grade)as Min_Grade,avg(sc.final_grade)as Avg_Grade  FROM teacher_1.student s
     left join  teacher_1.student_course sc on sc.student_id=s.student_id
     group by first_name, last_name;
     
    
BEGIN
    -- Iterate over students
    FOR student_idx IN cur_all_students_grades LOOP
        -- Print student's name and surname
  DBMS_OUTPUT.PUT_LINE('Student: ' || student_idx.first_name || ' ' || student_idx.last_name || 
                             ' MAX_GRADE: ' || student_idx.Max_Grade || 
                             ' MIN_GRADE: ' || student_idx.Min_Grade || 
                             ' AVG_GRADE: ' || student_idx.Avg_Grade);   
    END LOOP;
END;
/

--TASK 8 Create anonymous block with courses table record type, print out all courses one by one in console.

--SELECT * FROM teacher_1.course
DECLARE

    -- Declare a cursor
    CURSOR cur_courses IS
        SELECT course_id, name, description
        FROM teacher_1.course;
    student_rec cur_courses%ROWTYPE;

BEGIN
    -- Open the cursor
    OPEN cur_courses;

    -- Fetch and print course information
    LOOP
        FETCH cur_courses INTO student_rec;
        -- EXIT CONDITION
        EXIT WHEN cur_courses%NOTFOUND;
        -- Print course details
        DBMS_OUTPUT.PUT_LINE('Course ID: ' || student_rec.course_id || ', Course Name: ' || student_rec.name || ', Description: ' || student_rec.description);
    END LOOP;

    -- Close the cursor
    CLOSE cur_courses;
END;
/



--Alternative way
DECLARE
    TYPE rec_course IS RECORD (
        course_id   teacher_1.course.course_id%TYPE,
        course_name teacher_1.course.name%TYPE,
        course_description teacher_1.course.description%TYPE
    );
    
--declare course Record
    course_rec rec_course;

    -- Declare a cursor
    CURSOR cur_courses IS
        SELECT course_id, name, description
        FROM teacher_1.course;
BEGIN
    -- Open the cursor
    OPEN cur_courses;

    -- Fetch and print course information using the custom record
    LOOP
        FETCH cur_courses INTO course_rec;
        --EXIT CONDITION
        EXIT WHEN cur_courses%NOTFOUND;
        -- Print course details
        DBMS_OUTPUT.PUT_LINE('Course ID: ' || course_rec.course_id || ', Course Name: ' || course_rec.course_name || ', DESCRIPTION: ' || course_rec.course_description);
    END LOOP;
    -- Close the cursor
    CLOSE cur_courses;
END;
/

--TASK9
--Create anonymous block with cursor and cursor based record, print out class number, lowest grade in each class and students name+surname combined.


--     select *from  teacher_1.student_grade;
--     select * from teacher_1.student;
--      SELECT s.STUDY_CLASS, MIN(sg.TEST_GRADE) AS lowest_grade, CONCAT(s.FIRST_NAME,  s.LAST_NAME) AS student_name
--        FROM teacher_1.student_grade sg
--        JOIN teacher_1.student s ON sg.STUDENT_ID = s.STUDENT_ID
--        GROUP BY s.STUDY_CLASS, s.first_name, s.last_name;
    

DECLARE
    -- Declare a cursor to fetch class number, lowest grade, and student name+surname combined
    CURSOR cur_student IS
        SELECT s.STUDY_CLASS as class_number, 
               MIN(sg.final_GRADE) AS lowest_grade, 
               CONCAT(s.first_name, s.last_name) AS student_name
        FROM teacher_1.student_course sg
        JOIN teacher_1.student s ON sg.student_id = s.student_id
        GROUP BY s.STUDY_CLASS, s.first_name, s.last_name, s.student_id;

    -- Declare a record type to hold cursor-based record
    student_rec cur_student%ROWTYPE; 

BEGIN
    -- Open the cursor
    OPEN cur_student;

    -- Fetch and print class information
    LOOP
        -- Fetch the next record into the student_rec variable
        FETCH cur_student INTO student_rec;
        
        -- Exit the loop if there are no more records
        EXIT WHEN cur_student%NOTFOUND;
        
        -- Print class number, lowest grade, and student name
        DBMS_OUTPUT.PUT_LINE('Class Number: ' || student_rec.class_number || ', Lowest Grade: ' || student_rec.lowest_grade || ', Student Name: ' || student_rec.student_name);
    END LOOP;

    -- Close the cursor
    CLOSE cur_student;
END;
/

--TASK10
DECLARE
    -- Define an associative array type to store neighborhoods and their populations
    TYPE vilnius_populType IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(60);

    -- Declare a variable of the associative array type
    vilnius vilnius_populType;

    -- Variables for looping
    neighbo VARCHAR2(60);
    popl VARCHAR2(60);
BEGIN
    -- Populate the associative array with neighborhood names and their populations
vilnius('	Verkiai') := '39697';

vilnius('Pašilaiiai') := '25674';

vilnius('Fabijoniškes') := '36644';

vilnius('	Antakalnis?') := '36604';

vilnius('	Antakalnis') := '47410';

vilnius('	Antakalnis') := '31175';

vilnius('	Antakalnis') := '32164';

vilnius('	Antakalnis') := '24749';

vilnius('	Antakalnis Vilnia') := '32775';

vilnius('	Antakalnis') := '33457';

    -- Get the first key in the associative array
    neighbo := vilnius.FIRST;

    -- Iterate through the associative array using a WHILE loop
    WHILE neighbo IS NOT NULL LOOP
        -- Get the population for the current neighborhood
        popl := vilnius(neighbo); 
        -- Print out the formatted output for the current neighborhood and its population
        DBMS_OUTPUT.PUT_LINE('Neighborhood: ' || neighbo || ', Population: ' || popl);
        -- Get the next key in the associative array
        neighbo := vilnius.NEXT(neighbo);
    END LOOP;
END;
/



--TASK11
--Create anonymous block that prints out all student average grades. Use cursor and fetch functionality. Format output reasonably.

DECLARE
    student_id teacher_1.student.student_id%TYPE;
    avg_grade NUMBER;  
    -- Declare a cursor to fetch student IDs
    CURSOR cur_students IS
        SELECT s.student_id, ROUND(AVG(sg.TEST_grade), 2) AS average_grade
        FROM teacher_1.student s
        JOIN teacher_1.student_grade sg ON s.student_id = sg.student_id
        GROUP BY s.student_id;
BEGIN
    -- Open the cursor to fetch student IDs
    OPEN cur_students;
    -- Fetch and process each student's average grade
    LOOP
        FETCH cur_students INTO student_id, avg_grade;
        EXIT WHEN cur_students%NOTFOUND;    
        -- Print the student ID and average grade
        DBMS_OUTPUT.PUT_LINE('Student ID: ' || student_id || ', Average Grade: ' || avg_grade);
    END LOOP;
    -- Close the cursor
    CLOSE cur_students;
END;
/

--TASK12
--Create nested table based on courses. Fill this nested table with values and afterwards print out table's content (courses).
--SELECT * FROM teacher_1.course
DECLARE
    -- Define a nested table type for courses
    TYPE course_list IS TABLE OF VARCHAR2(50);
    
    -- Declare a variable of the nested table type
    courses course_list := course_list();
BEGIN
    -- Fill the nested table with values
    courses.EXTEND(3); -- Extend the nested table to hold 3 elements
    courses(1) := 'ENGLISH';
    courses(2) := 'LATVIAN';
    courses(3) := 'SQL';
    
    -- Print out the content of the nested table (courses)
    FOR idx IN 1..courses.LAST 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Course ' || idx || ': ' || courses(idx));
    END LOOP;
END;
/





DECLARE
    -- Define a nested table type based on the structure of the COURSE_INFO table
    TYPE course_list IS TABLE OF teacher_1.course%ROWTYPE;

    -- Declare a variable of the nested table type
    course_info_list course_list := course_list();
BEGIN
    -- Fetch data from the COURSE_INFO table and populate the nested table
    SELECT * BULK COLLECT INTO course_info_list
    FROM teacher_1.course;

    -- Print out the content of the nested table
    FOR i IN course_info_list.FIRST..course_info_list.LAST 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Course ' || i || ': ' || course_info_list(i).course_id || ', ' || course_info_list(i).name);
    END LOOP;
END;
/


