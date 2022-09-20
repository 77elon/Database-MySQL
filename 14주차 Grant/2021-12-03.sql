SHOW DATABASES;
USE mysql;

SHOW TABLES;


DESC user; -- Description!
SELECT * FROM user;
SELECT * FROM user order by User DESC;

USE madang;
GRANT SELECT ON Orders TO Hong WITH GRANT OPTION;
GRANT INSERT, DELETE ON Orders TO Hong;
GRANT UPDATE(orderid, saleprice) ON Orders To Hong;
GRANT UPDATE(custid, orderdate) ON Orders To Park;

SHOW GRANTS; -- FOR Current User!
SHOW GRANTS FOR Hong; -- 이전에 부여해준 권한 모두 출력
SHOW GRANTS FOR Park;

GRANT SELECT ON Orders To Park WITH GRANT OPTION; -- IN Hong Session!

SHOW GRANTS FOR Park;
REVOKE SELECT ON Orders FROM Hong; -- Default is RESTRICT과 같으며, mySQL은 RESTRICT, CASCADE가 구현되어 있지 않다.
#REVOKE SELECT ON Orders FROM Hong CASCADE; -- ERROR!

CREATE USER 'mdguest'@'%' IDENTIFIED BY '';
SELECT * FROM mysql.user WHERE User LIKE 'mdguest';

CREATE USER 'mdguest2'@'localhost' IDENTIFIED BY 'mdguest2';
SELECT * FROM mysql.user ORDER BY User DESC;

GRANT ALL ON *.* TO mdguest WITH GRANT OPTION;
FLUSH PRIVILEGES;

SHOW GRANTS FOR mdguest;

GRANT SELECT ON Customer TO mdguest WITH GRANT OPTION;

#GRANT SELECT ON Custoner, Orders TO mdguest2 WITH GRANT OPTION; -- ERROR! 두 줄로 나누어서 작성할 것!


