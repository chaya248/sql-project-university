go
create database universitych collate hebrew_100_ci_as
go
use  universitych
go

--טבלת תלמידים
create table student(
student_id int identity(1,1),
first_name varchar(10) not null,
last_name varchar(10) not null,
study_group varchar(20) not null,
email varchar(50) null,
address varchar(20) not null
constraint pk_student primary key (student_id)
)
--טבלת מרצים
create table lecturers (
    lecturer_id int identity(1,1),
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    field_specialization varchar(50) not null,
    email varchar(50) null,
    learning_room int not null,
    constraint pk_lecturers primary key (lecturer_id)
	)
--טבלת קורסים
create table courses (
    course_id int identity(1,1),
    name_course varchar(40) not null,
    lecturer_id int not null,
    study_group varchar(20) not null,
    semester varchar(10) not null,
    number_places_course int not null,
    constraint pk_courses primary key (course_id),
    constraint fk_courses_lecturers foreign key (lecturer_id) references lecturers(lecturer_id)
)
--טבלת הרשמה לקורס
create table enrollment (
    enrollment_id int identity(1,1),
    student_id int not null,
    course_id int not null,
    registration_date date null,
    final_grade int null,
    constraint pk_enrollment primary key (enrollment_id),
    constraint fk_enrollment_student foreign key (student_id) references student(student_id),
    constraint fk_enrollment_courses foreign key (course_id) references courses(course_id)
);
--חוגי לימוד
create table circles(
circle_id int identity(1,1),
name_study_group varchar(20) not null,
constraint pk_circles primary key (circle_id)
)

select * from [dbo].[student]
select * from [dbo].[lecturers]
select * from [dbo].[courses]
select * from [dbo].[enrollment]
select * from [dbo].[circles]
--הכנסת נתונים לטבלת סטודנטים
insert into [dbo].[student]([first_name],[last_name],[study_group],[email],[address])
values('אברהם','כהן','פיזיקה','a050265864@gmail.com','הרצל'),
('יצחק','לוי','פסיכולוגיה',null,'יגאל אלון'),
('יעקב','ישראלי','אסטרונומיה','mosh123456@gmail.com','חיים ויצמן'),
('משה','בן דוד','מערכות מידע','hhh11112223@gmail.com','יהודה הלוי'),
('אהרון','גולן','מדעי המחשב','0525896864@gmail.com','מונטיפיורי'),
('יוסף','פרץ','ביולוגיה','yosef0524654554@gmail.com','שלמה המלך'),
('דוד','בוזגלו','פסיכולוגיה','david050265864@gmail.com','עוזיאל');

truncate table student
--הכנסת נתונים לטבלת מרצים
insert into [dbo].[lecturers]([first_name], [last_name], [field_specialization], [email], [learning_room])
values
('מיכאל', 'מזרחי', 'פסיכולוגיה', 'm12358@gmail.com', 213),
('אורי', 'בן חיים', 'פיזיקה', 'aor128@gmail.com', 212),
('יונתן', 'גולן', 'אסטרונומיה', 'yon66666@gmail.com', 229),
('אריאל', 'וולף', 'ביולוגיה', null, 219),
('יובל', 'רוזן', 'מדעי המחשב', 'yyy358@gmail.com', 223),
('שמואל', 'וויס', 'מדעים', 'shsh55558@gmail.com', 205),
('אליעזר', 'רפאלי', 'פיזיקה', null, 237)

truncate table lecturers

--הכנסת נתונים לטבלת קורסים
insert into [dbo].[courses]([name_course], [lecturer_id], [study_group], [semester], [number_places_course])
values
('מבוא לפסיכולוגיה', 1, 'פסיכולוגיה', 'חורף', 50),
('ניתוח מערכות', 2, 'מערכות מידע', 'חורף', 55),
('חקר החלל והיקום', 3, 'אסטרונומיה', 'קיץ', 60),
('אנטומיה ופיזיולוגיה', 4, 'ביולוגיה', 'חורף', 50),
('מבני נתונים', 5, 'מדעי המחשב', 'קיץ', 45),
('מדעי הטבע', 6, 'מדעים', 'קיץ', 50),
('אלקטרומגנטיות', 7, 'פיזיקה', 'קיץ', 60);

truncate table courses
--הכנסת נתונים לטבלת הרשמה לקורס
insert into [dbo].[enrollment]([student_id], [course_id], [registration_date], [final_grade])
values
(1, 1, '2025-11-01', 95),  
(2, 1, '2025-11-01', 95), 
(3, 2, '2025-05-01', 92),  
(4, 3, '2025-11-01', 90),  
(5, 4, '2025-05-01', 90),  
(6, 5, '2025-05-01', 95),  
(7, 6, '2025-05-01', 98);

truncate table enrollment
--הכנסת נתונים לטבלת חוג לימוד
insert into [dbo].[circles]([name_study_group])
values
('פסיכולוגיה קלינית'),
('פיתוח מערכות מידע'),
('אסטרונומיה תיאורטית'),
('ביוטכנולוגיה'),
('פיתוח תוכנה'),
('מדעי כדור הארץ'),
('פיזיקת גרעין');

truncate table circles

  --פרוצדורה
  alter procedure dbo.pr_new_studente(@first_name varchar(10),@last_name varchar(10),@study_group varchar(20),@email varchar(50),@address varchar(20))
  as  
  begin
begin try
if charindex('@', @email) = 0
begin
select 'you can only enter an email that has @'
end
if(select email from student where email=@email) is not null --בודק אם המייל קיים
begin
select 'this student exists in the system'--הסטודנט קיים
end
else
begin
insert into student(first_name,last_name,study_group,email,address)
values(@first_name,@last_name,@study_group,@email,@address) --אם לא קיים הוא מכניס נתונים
select 'another student was added to the system' --הפרטים הותקנו
end
end try
begin catch
select error_message() as errormessage ,'the email entered is invalid.'
end catch
end
go
exec dbo.pr_new_studente @first_name=null,@last_name='גולד',@study_group='פיזיקה',@email='ari055577775@gmail.com',@address='הארי טרומן' --סטודנט חדש

delete from student
where first_name = 'ארי' and last_name = 'גולד';

--פונקציה
alter function dbo.fn_final_grade_course()--בודק את הממוצע קבלה לאוניברסיטה
returns decimal(5,2)
as
begin
 declare @avg_grade decimal(5,2)
 set @avg_grade=(
              select avg(final_grade)
              from enrollment 
             
             )
return @avg_grade
end
go
select dbo.fn_final_grade_course() as avg_grade
--פונקציה
create function dbo.fn_newlecturers_id()--בודק את המרצה הכי חדש
--המרצה עם ה-  הכי גבוה   _id 
returns int
as
begin 
declare @new_lecturer int
select @new_lecturer=(select top 1 l.lecturer_id from lecturers l
                       where l.lecturer_id=(select max(l.lecturer_id)
					   from lecturers l))
return @new_lecturer
end
go

select dbo.fn_newlecturers_id() as new_lecturer

--פרוצדורה שמשתמשת בפונקציה
create function dbo.fn_register_courses(@student_id int,@course_id int)
returns varchar(10)
as
begin
declare @registered varchar(10)--משתנה
if exists(select student_id,course_id from enrollment where student_id=@student_id and course_id=@course_id)--בודק אם הסטודנט רשום לקורס
begin
set @registered='true'--אם רשום מחזיר נכון
end
else
begin
set @registered='false'--אם לא רשום מחזיר טעות
end
return @registered
end
alter procedure dbo.pr_registration_checke(@student_id int,@course_id int)
as
begin
declare @registered varchar(10)--משתנה
set @registered=dbo.fn_register_courses(@student_id,@course_id)--קריאה לפונקציה כדי לדעת אם הסטודנט רשום
if dbo.fn_register_courses(2,2)='true'--אם רשום חיובי
begin 
print 'the student is registered in the system'--רשום
end
else
begin--אם לא הוא מכניס נתונים חדשים
insert into enrollment(student_id,course_id,registration_date)
values(@student_id,@course_id,getdate())
print 'the student is not registered in the system'
end
end

--פרוצדורה שמשתמשת בפרוצדורה
alter procedure dbo.pr_student_names(@student_id int)
as
begin
declare @namestudent varchar(10)--משתנה שם סטודנט
select @namestudent=first_name +' '+last_name from student--שרשור של השם פרטי והשם משפחה
where student_id=@student_id
print 'full name student'+' '+':'+' '+@namestudent--השם המלא\השלם של התלמיד
end
exec dbo.pr_student_names @student_id=1

alter procedure dbo.pr_presentation_changes(@student_id int,@new_address varchar(20))
as
begin
exec dbo.pr_student_names @student_id=1--מזמן את הפרוצדורה הראשונה

update student--מעדכן פרטים חדשים אצל הסטודנט
set @new_address=@new_address--כתובת חדשה
where student_id=@student_id
print 'the new address'+' '+':'+' '+@new_address--הכתובת החדשה
end
exec dbo.pr_presentation_changes @student_id=1,@new_address='דרך הרצל'--מריץ את הפרוצדורה + הכתובת החדשה

-- מטבלה שמשתמשת בפונקציה select 
alter function dbo.lecturers_count(@field_specialization varchar(50)) 
returns table
as
return
(
    select l.lecturer_id,l.first_name + ' ' + l.last_name as lecturer_name, l.field_specialization,count(*) as count_students_course 
	--שולפים קוד מרצה,שם פרטי ומשפחה של המרצה בו"ז,שם הקורס,ממוצע הסטודנטים שנרשמו,
    from lecturers l
    inner join courses c on l.lecturer_id = c.lecturer_id
    left join enrollment e on c.course_id = e.course_id
	join student s on e.student_id=s.student_id
    where l.field_specialization = @field_specialization
    group by l.lecturer_id, l.first_name, l.last_name, l.field_specialization
)
go
select * from dbo.lecturers_count('פיזיקה')--המרצה שיש לו הכי הרבה תלמידים בקורסים

--view
alter view v_namee
as--שולף שמות של סטודנטים וקורסים ומציג אותם
select s.first_name as student_firstname,
       s.last_name as student_lastname, 
	   c.name_course as student_namecourse,
	   e.final_grade as course_finalgrade
	   from student s
	   join enrollment e on e.student_id=s.student_id
	   join courses c on e.course_id=c.course_id
	   select * from v_namee
--view
create view v_student_city
--מחזיר את השמות של הסטודנטים ואת הכתובת שלהם
as
select first_name as studentfirstname,
       last_name as studentlastname,
	   address as studentaddress
 from student
 select * from v_student_city

 --trigger
alter table student
add updating_dates datetime;--מוסיף עמודה בטבלת סטודנט,עמודה שמעדכנת תלמיד ואת התאריך העכשווי שהתעדכן

 alter trigger tr_updatingdate
 on student
 after update--עדכון
as
begin
update student
set updating_dates=getdate()--תאריך עכשווי
from student s
inner join inserted i on s.student_id=i.student_id
end

exec sp_helptext 'tr_updatingdate'--מריץ מה שכתבתי בטריגר


--הפסקת הטריגר
--disable trigger tr_updatingdate on student;

-- עדכון הנתונים בטבלה
update student
set first_name = 'רוני'
where student_id = 1

select student_id, first_name, last_name, updating_dates
from student
where student_id = 1

-- הפעלת הטריגר מחדש
--enable trigger tr_updatingdate on student;

------------------------additions-------------------------
--union
--שמות של תלמידים ומרצים ומייל בו"ז
select first_name,last_name, email from student
union
select first_name,last_name, email from lecturers
order by first_name desc
--ציון עובר ושם הקורס
select convert(varchar,final_grade) as grade_name_course from enrollment
union
select name_course from courses

--except
--קורס שאין לו נרשמים
select name_course from courses c
except
select c.name_course from  courses c
right join enrollment e on c.course_id=e.course_id

--intersect
--סמסטרים שקיימים גם בפיזיקה וגם באסרונומיה
select semester from courses where study_group='פיזיקה'
intersect
select semester from courses where study_group='אסטרונומיה'

--while
declare @letters varchar(1)
print ':כדי להכניס סטודנט חדש ניתן להשתמש בסימנים הנ"ל'
set @letters='A-a'
while(@letters<='z-z')
begin
print @letters
set @letters= char(ascii(@letters)+1) 
--ascii לכל אות יש מספר שמחליף אותו ע"י שימוש במילה הזאת
--char מחזיר את המספרים חזרה לאותיות
--כך התוצאה היא אותיות וסמלים 
end

--cross apply
--טבלה של מרצים וקורסים בו"ז
select * from lecturers l
cross apply(select * from courses c
where c.lecturer_id=l.lecturer_id
)d

--outer apply
--טבלה של תלמידים והרשמה לקורס בו"ז
select * from enrollment e
outer apply(select * from student s
where s.student_id=e.student_id
)d
