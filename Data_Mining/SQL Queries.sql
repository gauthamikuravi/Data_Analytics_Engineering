DROP TABLE DEPARTMENT CASCADE CONSTRAINTS;
DROP TABLE EMP_DEPT CASCADE CONSTRAINTS;
DROP TABLE EMP_room CASCADE CONSTRAINTS;
DROP TABLE EMPLOYEE CASCADE CONSTRAINTS;
DROP TABLE MAIL_ID CASCADE CONSTRAINTS;
DROP TABLE building CASCADE CONSTRAINTS;
DROP TABLE room CASCADE CONSTRAINTS;
DROP TABLE measurement CASCADE CONSTRAINTS;
DROP TABLE phone_number CASCADE CONSTRAINTS;

CREATE TABLE department (
   dept_no NUMBER NOT NULL,
   dept_name VARCHAR2(50 CHAR) NOT NULL,
    web_address  VARCHAR2(50 CHAR),
    main_phno  NUMBER,
    email    VARCHAR2(50 CHAR),
    street_number NUMBER, 
    street_name VARCHAR2(50 CHAR), 
    city VARCHAR2(50 CHAR), 
    zip_code NUMBER,
    state_D VARCHAR2(50 CHAR),
    PRIMARY KEY(dept_no)
);
CREATE TABLE employee (	
    employee_id  NUMBER NOT NULL, 
	emp_name VARCHAR2(50 CHAR) NOT NULL,  
	yob NUMBER, 
	street_no VARCHAR2(50 CHAR), 
	street_name VARCHAR2(50 CHAR), 
	city  VARCHAR2(50 CHAR), 
	zipcode VARCHAR2(50 CHAR), 
	state VARCHAR2(50 CHAR), 
    CONSTRAINT employee1_pk PRIMARY KEY (employee_id)
);
CREATE TABLE emp_dept ( 
    dept_no  NUMBER NOT NULL, 
    employee_id NUMBER NOT NULL, 
    PRIMARY KEY (dept_no, employee_id),
    FOREIGN KEY (dept_no)
    REFERENCES department(dept_no), 
    FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
);
CREATE TABLE mail_id ( 
    employee_id NUMBER NOT NULL, 
    mail_id VARCHAR2(50 CHAR),
    PRIMARY KEY (employee_id,mail_id),
    FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
);  
CREATE TABLE building (
    building_id NUMBER,
    bname  VARCHAR2(50 CHAR) NOT NULL,
    no_of_floors NUMBER,
    no_of_rooms  NUMBER,
    street_number NUMBER, 
    street_name VARCHAR2(50 CHAR), 
    city VARCHAR2(50 CHAR), 
    zip_code NUMBER,
    state_D VARCHAR2(50 CHAR),
    PRIMARY KEY(building_id)
);
CREATE TABLE room (
    building_id NUMBER,
    room_no NUMBER,
    area NUMBER,
    rtype VARCHAR2(10),
    check (rtype in ('lab', 'conference', 'class')),
    PRIMARY KEY(building_id,room_no),
    FOREIGN KEY (building_id) REFERENCES building (building_id)
);
CREATE TABLE emp_room ( 
    building_id NUMBER,
    room_no NUMBER,
    employee_id NUMBER NOT NULL, 
    PRIMARY KEY (building_id,room_no,employee_id),
    FOREIGN KEY (building_id,room_no)
    REFERENCES room(building_id,room_no), 
    FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
);
CREATE TABLE measurement (
    building_id NUMBER,
    room_no NUMERIC,
    rec_sound NUMERIC,
    rec_temp NUMERIC,
    rec_light NUMERIC,
    rec_date VARCHAR2(50 CHAR),
    rec_time  VARCHAR2(50 CHAR),
    PRIMARY KEY(building_id,room_no,rec_date,rec_time),
    FOREIGN KEY (building_id,room_no) REFERENCES room(building_id,room_no)
);
CREATE TABLE phone_number ( 
    building_id NUMBER,
    room_no NUMBER,
    phone_no NUMBER,
    PRIMARY KEY ( building_id,room_no,phone_no),
    FOREIGN KEY (building_id,room_no)
    REFERENCES room(building_id,room_no)
);    
INSERT INTO DEPARTMENT
VALUES(1234,'MATH','www.google.com',123345788, 'abc@gh.com', 11104,'cavalier', 'Fairfax',22030,'Virginia');
INSERT INTO DEPARTMENT
VALUES(9023,'stat','www.goe.com',1200012388, 'zac@xd.com', 12359,'shenandoah', 'Edison',29030,'California');
INSERT INTO DEPARTMENT
VALUES(6234,'physics','www.phyle.com',78902345788, 'zxsf@gh.com', 32212,'charter', 'herndon',22033,'Maine');
INSERT INTO DEPARTMENT
VALUES(2023,'public health','www.phic.com',4563245678, 'tee@xd.com', 65543,'asford', 'Reston',29045,'New Hampshire');



INSERT INTO employee 
VALUES(273456,'SAI',1996, 11104,'cavalier', 'Fairfax',22030,'Virginia');
INSERT INTO employee 
VALUES(233456,'KESH',1992, 10234,'RANDIUS', 'Edison',56030,'New Jersey');
INSERT INTO employee 
VALUES(270456,'pranavi',1996, 11204,'charter', 'Fairfax',22030,'Virginia');
INSERT INTO employee 
VALUES(272456,'sudha',1996, 12104,'caer', 'jCity',22030,'Virginia');

INSERT INTO emp_dept
VALUES(1234,233456);
INSERT INTO emp_dept
VALUES(1234,272456);
INSERT INTO emp_dept
VALUES(9023,270456);
INSERT INTO emp_dept
VALUES(9023,273456);

INSERT INTO mail_id 
VALUES(272456,'sudha@gmail.com, pranavi@gmail.com');

INSERT INTO building 
VALUES(3012,'NYUGEN',3,20, 11104,'cavalier', 'Fairfax',22030,'Virginia');
INSERT INTO building
VALUES(1056,'Johnson',5,27,65543,'asford', 'Reston',29045,'New Hampshire');

INSERT INTO room
VALUES(3012,312,456,'lab');
INSERT INTO room
VALUES(1056,105,534,'class');

INSERT INTO emp_room
VALUES(3012,312,270456);
INSERT INTO emp_room
VALUES(1056,105,233456);

INSERT INTO measurement
VALUES(3012,312,22,34,74,'2019-01-01', '03:05');
INSERT INTO measurement
VALUES(3012,312,22,45,67,'2018-05-03', '17:05');
INSERT INTO measurement
VALUES(1056,105,22,85,67,'2019-02-02', '14:05');
INSERT INTO measurement
VALUES(1056,105,22,44,45,'2019-01-01', '23:05');


INSERT INTO phone_number
VALUES(3012,312,4123325678);
INSERT INTO phone_number
VALUES(1056,105,4129906754);

-- Question1
Select phone_no , bname
FROM building b,phone_number P
WHERE b.building_id = p.building_id;

-- Question2
Select bname
from building
where no_of_floors > 4;

--question 3
select employee_id
from emp_room e, room r
where e.room_no = r.room_no
and r.rtype = 'lab';

--question 4
select AVG(rec_temp) temp, count(room_no) room_count
FROM measurement GROUP BY room_no;


--question 4
select count(employee_id), dept_name
FROM department d,emp_dept ed
where d.dept_no = ed.dept_no
GROUP BY dept_name;

--question 5
select t.r from
 (select room_no r, AVG(rec_light) l, count(room_no) c
     FROM measurement 
     GROUP BY room_no order by l desc) t   
    where ROWNUM = 1;
 


-- check subquery
select AVG(rec_light) light, count(room_no) room_count,room_no
FROM measurement 
GROUP BY room_no;


CREATE TABLE employee (	
    employee_id  NUMBER NOT NULL, 
	emp_name VARCHAR2(50 CHAR) NOT NULL,  
	yob NUMBER, 
	street_no VARCHAR2(50 CHAR), 
	street_name VARCHAR2(50 CHAR), 
	city  VARCHAR2(50 CHAR), 
	zipcode VARCHAR2(50 CHAR), 
	state VARCHAR2(50 CHAR), 
    CONSTRAINT employee1_pk PRIMARY KEY (employee_id)
);
CREATE TABLE building (
    building_id NUMBER,
    bname  VARCHAR2(50 CHAR) NOT NULL,
    no_of_floors NUMBER,
    no_of_rooms  NUMBER,
    street_number NUMBER, 
    street_name VARCHAR2(50 CHAR), 
    city VARCHAR2(50 CHAR), 
    zip_code NUMBER,
    state_D VARCHAR2(50 CHAR),
    PRIMARY KEY(building_id)
);

CREATE TABLE room (
    building_id NUMBER not null,
    room_no NUMBER not null,
    area NUMBER,
    conference VARCHAR2(10) not null,
    labt VARCHAR2(10)not null,
    officef VARCHAR2(10)not null,
    check((conference = '1'  AND (labt = '0' OR officef = '0')) OR
          (conference = '0'  AND (labt = '1' OR officef = '0')) OR
         (conference = '0'  AND (labt = '0' OR officef = '1'))  OR
          (conference = '0'  AND (labt = '1' OR officef = '1'))),
    PRIMARY KEY(building_id,room_no),
    FOREIGN KEY (building_id) REFERENCES building (building_id)
);
CREATE TABLE emp_room ( 
    building_id NUMBER not null,
    room_no NUMBER not null,
    employee_id NUMBER NOT NULL, 
    PRIMARY KEY (building_id,room_no,employee_id),
    FOREIGN KEY (building_id,room_no)
    REFERENCES room(building_id,room_no), 
    FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
);

INSERT INTO employee 
VALUES(273456,'SAI',1996, 11104,'cavalier', 'Fairfax',22030,'Virginia');
INSERT INTO employee 
VALUES(233456,'KESH',1992, 10234,'RANDIUS', 'Edison',56030,'New Jersey');
INSERT INTO employee 
VALUES(270456,'pranavi',1996, 11204,'charter', 'Fairfax',22030,'Virginia');
INSERT INTO employee 
VALUES(272456,'sudha',1996, 12104,'caer', 'jCity',22030,'Virginia');

INSERT INTO building 
VALUES(3012,'NYUGEN',3,20, 11104,'cavalier', 'Fairfax',22030,'Virginia');
INSERT INTO building
VALUES(1056,'Johnson',5,27,65543,'asford', 'Reston',29045,'New Hampshire');
INSERT INTO building 
VALUES(3013,'hub',3,20, 11104,'cavalier', 'Fairfax',22030,'Virginia');
INSERT INTO building
VALUES(1057,'fenwick',5,27,65543,'asford', 'Reston',29045,'New Hampshire');


INSERT INTO room
VALUES(3012,312,456,'1','0','0');
INSERT INTO room
VALUES(1056,105,534,'0','0','1');
INSERT INTO room
VALUES(3013,312,456,'0','1','0');
INSERT INTO room
VALUES(1057,105,534,'0','1','1');


INSERT INTO emp_room
VALUES(3012,312,270456);
INSERT INTO emp_room
VALUES(1056,105,233456);
INSERT INTO emp_room
VALUES(3013,312,272456);
INSERT INTO emp_room
VALUES(1057,105,273456);



INSERT INTO phone_number 
VALUES(3012,312,4123325678);
INSERT INTO phone_number
VALUES(1056,105,4129906094);
INSERT INTO phone_number 
VALUES(3013,312,4003325678);
INSERT INTO phone_number 
VALUES(1057,105,4129900754);
INSERT INTO phone_number 
VALUES(3014,312,4120025678);
INSERT INTO phone_number
VALUES(1056,108,4129906344);
INSERT INTO phone_number
VALUES(3015,312,4129906345);
INSERT INTO phone_number
VALUES(1057,108,7129906344);

INSERT INTO phone_number
VALUES(3012,312,4123325678);
INSERT INTO phone_number
VALUES(1056,105,4129906094);
INSERT INTO phone_number
VALUES(3013,312,4003325678);
INSERT INTO phone_number
VALUES(1057,105,4129900754);
INSERT INTO phone_number
VALUES(1056,108,4120025678);
INSERT INTO phone_number
VALUES(1057,108,4129906344);