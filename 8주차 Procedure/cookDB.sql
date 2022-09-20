DROP DATABASE IF EXISTS cookDB; -- 만약 cookDB가 존재하면 우선 삭제한다.
CREATE DATABASE cookDB;

USE cookDB;
CREATE TABLE userTbl -- 회원 테이블
( userID  	CHAR(8) NOT NULL PRIMARY KEY, -- 사용자 아이디(PK)
  userName    	VARCHAR(10) NOT NULL, -- 이름
  birthYear   INT NOT NULL,  -- 출생년도
  addr	  	CHAR(2) NOT NULL, -- 지역(경기,서울,경남 식으로 2글자만입력)
  mobile1	CHAR(3), -- 휴대폰의 국번(011, 016, 017, 018, 019, 010 등)
  mobile2	CHAR(8), -- 휴대폰의 나머지 전화번호(하이픈제외)
  height    	SMALLINT,  -- 키
  mDate    	DATE  -- 회원 가입일
);
CREATE TABLE buyTbl -- 회원 구매 테이블
(  num 		INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK)
   userID  	CHAR(8) NOT NULL, -- 아이디(FK)
   prodName 	CHAR(6) NOT NULL, --  물품명
   groupName 	CHAR(4)  , -- 분류
   price     	INT  NOT NULL, -- 단가
   amount    	SMALLINT  NOT NULL, -- 수량
   FOREIGN KEY (userID) REFERENCES userTbl(userID)
);

INSERT INTO userTbl VALUES('YJS', '유재석', 1972, '서울', '010', '11111111', 178, '2008-8-8');
INSERT INTO userTbl VALUES('KHD', '강호동', 1970, '경북', '011', '22222222', 182, '2007-7-7');
INSERT INTO userTbl VALUES('KKJ', '김국진', 1965, '서울', '019', '33333333', 171, '2009-9-9');
INSERT INTO userTbl VALUES('KYM', '김용만', 1967, '서울', '010', '44444444', 177, '2015-5-5');
INSERT INTO userTbl VALUES('KJD', '김제동', 1974, '경남', NULL , NULL      , 173, '2013-3-3');
INSERT INTO userTbl VALUES('NHS', '남희석', 1971, '충남', '016', '66666666', 180, '2017-4-4');
INSERT INTO userTbl VALUES('SDY', '신동엽', 1971, '경기', NULL , NULL      , 176, '2008-10-10');
INSERT INTO userTbl VALUES('LHJ', '이휘재', 1972, '경기', '011', '88888888', 180, '2006-4-4');
INSERT INTO userTbl VALUES('LKK', '이경규', 1960, '경남', '018', '99999999', 170, '2004-12-12');
INSERT INTO userTbl VALUES('PSH', '박수홍', 1970, '서울', '010', '00000000', 183, '2012-5-5');

INSERT INTO buyTbl VALUES(NULL, 'KHD', '운동화', NULL   , 30,   2);
INSERT INTO buyTbl VALUES(NULL, 'KHD', '노트북', '전자', 1000, 1);
INSERT INTO buyTbl VALUES(NULL, 'KYM', '모니터', '전자', 200,  1);
INSERT INTO buyTbl VALUES(NULL, 'PSH', '모니터', '전자', 200,  5);
INSERT INTO buyTbl VALUES(NULL, 'KHD', '청바지', '의류', 50,   3);
INSERT INTO buyTbl VALUES(NULL, 'PSH', '메모리', '전자', 80,  10);
INSERT INTO buyTbl VALUES(NULL, 'KJD', '책'    , '서적', 15,   5);
INSERT INTO buyTbl VALUES(NULL, 'LHJ', '책'    , '서적', 15,   2);
INSERT INTO buyTbl VALUES(NULL, 'LHJ', '청바지', '의류', 50,   1);
INSERT INTO buyTbl VALUES(NULL, 'PSH', '운동화', NULL   , 30,   2);
INSERT INTO buyTbl VALUES(NULL, 'LHJ', '책'    , '서적', 15,   1);
INSERT INTO buyTbl VALUES(NULL, 'PSH', '운동화', NULL   , 30,   2);

SELECT * FROM userTbl;
SELECT * FROM buyTbl;

DROP PROCEDURE IF EXISTS Calc_Proc;

DELIMITER $$
CREATE PROCEDURE Calc_Proc()
BEGIN
	SELECT userTbl.userID, userTbl.userName, SUM(price * amount) AS '총 구매액',
	CASE -- how to if?, 조건문에서 Column의 Description으로는 비교 할 수 없다.
		WHEN (SUM(price * amount) >= 1500) THEN '최우수고객'
		WHEN(SUM(price * amount) >= 1000) THEN '우수고객'
		WHEN(SUM(price * amount) >= 1) THEN '일반고객'
		ELSE '유령고객'
    END AS '고객등급'
    FROM userTbl LEFT OUTER JOIN buyTbl ON userTbl.userID = buyTbl.userID -- LEFT인 이유? buyTbl의 Result 기반으로는 NULL을 출력할 수 없다.
    GROUP BY userID
    ORDER BY SUM(price * amount) DESC;
END $$
DELIMITER ;

CALL Calc_Proc();

DROP PROCEDURE IF EXISTS Sol1;
DROP PROCEDURE IF EXISTS Sol2;
DROP PROCEDURE IF EXISTS Sol3;
DROP PROCEDURE IF EXISTS Sol4;
DROP PROCEDURE IF EXISTS Sol5;



#1. 음수와 양수를 구분하여 출력하는 프로그램을 작성하시오 인자 myData = -1
#2. 1번 코드를 CASE ... END CASE 문으로 작성하시오 단, 0이 입력되는 경우를 감안할 것.
#3. WHILE 문을 사용하여 12,345부터 67,890까지의 숫자 중 1234의 배수 합계를 출력하도록 작성하시오.

DELIMITER $$
CREATE PROCEDURE Sol1(IN myData INT)
BEGIN 
	IF (myData > 0) THEN 
		SELECT '양수입니다.' AS '결과';
	ELSEIF (myData < 0) THEN
		SELECT '음수입니다.' AS '결과';
	END IF;
END $$
DELIMITER ;

CALL Sol1(-1);

DELIMITER $$
CREATE PROCEDURE Sol2(IN myData INT)
BEGIN 
	CASE 
		WHEN (myData > 0) THEN
			SELECT '양수입니다.' AS '결과';
		WHEN (myData < 0) THEN
			SELECT '음수입니다.' AS '결과';
		ELSE 
			SELECT '0입니다.' AS '결과';
	END CASE;
END $$
DELIMITER ;
CALL Sol2(-1);

DELIMITER $$
CREATE PROCEDURE Sol3()
BEGIN 
	DECLARE i INT;
    DECLARE result INT;
    SET i = 12345;
    SET result = 0;
    
    calc_iter1: WHILE(i < 67890) DO
		SET i = i + 1;
		IF(i % 1234 = 0) THEN
            SET result = result + i;
		#ELSE
			#ITERATE calc_iter1;
		END IF;
        IF(result > 1832490) THEN
			SELECT  '계산이 잘못되었습니다.' AS 'result';
            LEAVE calc_iter1;
		END IF;
	END WHILE;
    
    SELECT result;
END $$
DELIMITER ; 
CALL Sol3();

SELECT @output;
SET @output ='';
DELIMITER $$
CREATE PROCEDURE Sol4(IN myData INT, OUT output varchar(10))
BEGIN
	IF(myData > 0) THEN
        SET output = '양수입니다.';
	ELSE
		SET output = '음수입니다.';
	END IF;
END $$
DELIMITER ;
CALL Sol4(-1, @output);
SELECT CONCAT('변수 결과 값: ', @output);

DELIMITER $$
CREATE PROCEDURE Sol5(IN myData INT, OUT output VARCHAR(10))
BEGIN
	CASE
		WHEN (myData > 0) THEN
			SET output = '양수입니다';
		WHEN (myDate < 0) THEN
			SET output = '음수입니다.';
		ELSE 
			SET output = '0입니다.';
	END CASE;
END $$ 
DELIMITER ;
CALL Sol5(-1, @output);
SELECT CONCAT('변수 결과 값: ', @output);


DROP TABLE IF EXISTS guguTBL;

CREATE TABLE guguTBL (txt VARCHAR(100));

DROP PROCEDURE IF EXISTS whileProc;
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
	DECLARE str VARCHAR(100);
    DECLARE i INT;
    DECLARE k INT;
    SET i = 2;
    
    WHILE(i < 10) DO
		SET str = '';
        SET k = 1;
        WHILE(k < 10) DO
			SET str = CONCAT(str, ' ', i, 'X', k, ' = ', i * k);
            SET k = k + 1;
		END WHILE;
	SET i = i + 1;
    INSERT INTO guguTBL VALUES(str);
    END WHILE;
END $$
DELIMITER ;

CALL whileProc();
SELECT * FROM guguTBL;

DROP TABLE guguTBL_1;
CREATE TABLE guguTBL_1 (x varchar(10), y varchar(10), result VARCHAR(100));

DROP PROCEDURE IF EXISTS guguProc;
DELIMITER $$
CREATE PROCEDURE guguProc()
BEGIN
	DECLARE str VARCHAR(100);
    DECLARE i INT;
    DECLARE k INT;
    SET i = 2;
    
    WHILE(i < 10) DO
		SET str = '';
        SET k = 1;
        WHILE(k < 10) DO
			SET str = i * k;
            INSERT INTO guguTBL_1 VALUES(i, k, str);
            SET k = k + 1;
		END WHILE;
	SET i = i + 1;

    END WHILE;
END $$
DELIMITER ;

CALL guguProc();
SELECT * FROM guguTBL_1;

DROP TABLE IF EXISTS myTable;
CREATE TABLE myTable (
	id INT AUTO_INCREMENT PRIMARY KEY,
    mDATE DATETIME);
SET @curDATE = CURRENT_TIMESTAMP();

PREPARE myQuery FROM 'INSERT INTO myTable VALUES(NULL, ?)'; -- ?를 인자로 들어가는 사전 정의 기능 같은 것. 물론 Procedure로도 충분히 작성할 수 있다.!
EXECUTE myQuery USING @curDATE;
DEALLOCATE PREPARE myQuery;

SELECT * FROM myTable;

DROP PROCEDURE IF EXISTS nameProc;

DELIMITER $$
CREATE PROCEDURE nameProc(
	IN tableName VARCHAR(20))
BEGIN 
	SET @sqlquery = CONCAT('SELECT * FROM ', tableName); -- DECLARE가 아니라면, @을 추가해야한다.
    PREPARE myQuery FROM @sqlQuery;
    EXECUTE myQuery; -- CONCAT으로 작성된 Query문을 실행한다.
    DEALLOCATE PREPARE myQuery;
END $$
DELIMITER ;

CALL nameProc('userTbl');
