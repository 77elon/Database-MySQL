
SELECT U.userID, U.userName, SUM(price * amount) AS '총구매액',
	CASE
		WHEN (SUM(price * amount) >= 1500) THEN '최우수고객'
		WHEN (SUM(price * amount) >= 1000) THEN '우수고객'
		WHEN (SUM(price * amount) >= 1 ) THEN '일반고객'
		ELSE '유령고객'
	END AS '고객등급'
FROM buyTbl B
	RIGHT OUTER JOIN userTbl U
	ON B.userID = U.userID
GROUP BY U.userID, U.userName
ORDER BY sum(price * amount) DESC;

-- --------------------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS cursorProc;
DELIMITER $$
CREATE PROCEDURE cursorProc()
BEGIN
	DECLARE userHeight INT; -- 고객의 키
	DECLARE cnt INT DEFAULT 0; -- 고객의 인원수(읽은 행의 수)	
	DECLARE totalHeight INT DEFAULT 0; -- 키의 합계
	DECLARE endOfRow BOOLEAN DEFAULT FALSE; -- 행의 끝 여부(기본은 FALSE)

	DECLARE userCursor CURSOR FOR -- 커서 선언
		SELECT height FROM userTbl;
	DECLARE CONTINUE HANDLER -- 행의 끝이면 endOfRow 변수에 TRUE 대입
		FOR NOT FOUND SET endOfRow = TRUE;

	OPEN userCursor; -- 커서 열기

	cursor_loop: LOOP
		FETCH userCursor INTO userHeight; -- 고객의 키 1개 대입
        IF endOfRow THEN -- 더 이상 읽을 행이 없으면 LOOP 종료
			LEAVE cursor_loop;
		END IF;

		SET cnt = cnt + 1;
		SET totalHeight = totalHeight + userHeight;
	END LOOP cursor_loop;

	-- 고객의 평균 키 출력
	SELECT CONCAT('고객 키의 평균 ==> ', (totalHeight/cnt));

	CLOSE userCursor; -- 커서 닫기
END $$
DELIMITER ;

CALL cursorProc();
-- ----------------------------------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS testDB;
USE testDB;
DROP TABLE IF EXISTS userTBL;
CREATE TABLE userTBL
( 
	userID char(8) NOT NULL PRIMARY KEY,
	userName varchar(10) NOT NULL,
	birthYear int NOT NULL,
	addr char(2) NOT NULL
);

INSERT INTO userTBL VALUES ('YJS', '유재석', 1972, '서울');
INSERT INTO userTBL VALUES ('KHD', '강호동', 1970, '경북');
INSERT INTO userTBL VALUES ('KKJ', '김국진', 1965, '서울');
INSERT INTO userTBL VALUES ('KYM', '김용만', 1967, '서울');
INSERT INTO userTBL VALUES ('KJD', '김제동', 1974, '경남');
SELECT * FROM userTBL;
SHOW INDEX FROM userTBL;

ALTER TABLE userTBL DROP PRIMARY KEY;
ALTER TABLE userTBL ADD CONSTRAINT pk_userName PRIMARY KEY (userName);
SELECT * FROM userTBL;

SHOW INDEX FROM userTBL;
-- ----------------------------------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS testDB;
USE testDB;
DROP TABLE IF EXISTS clusterTBL;

CREATE TABLE clusterTBL
( 
	userID char(8),
	userName varchar(10)
);

INSERT INTO clusterTBL VALUES ('YJS', '유재석');
INSERT INTO clusterTBL VALUES ('KHD', '강호동');
INSERT INTO clusterTBL VALUES ('KKJ', '김국진');
INSERT INTO clusterTBL VALUES ('KYM', '김용만');
INSERT INTO clusterTBL VALUES ('KJD', '김제동');
INSERT INTO clusterTBL VALUES ('NHS', '남희석');
INSERT INTO clusterTBL VALUES ('SDY', '신동엽');
INSERT INTO clusterTBL VALUES ('LHJ', '이휘재');
INSERT INTO clusterTBL VALUES ('LKK', '이경규');
INSERT INTO clusterTBL VALUES ('PSH', '박수홍');
SELECT * FROM clusterTBL;

SHOW INDEX FROM clusterTBL;
-- ----------------------------------------------------------------------------------------------------------
-- 생략
CREATE DATABASE IF NOT EXISTS testDB;
USE testDB;
DROP TABLE IF EXISTS secondaryTBL;

CREATE TABLE secondaryTBL
( 
	userID char(8) UNIQUE,
	userName varchar(10)
);

INSERT INTO secondaryTBL VALUES ('YJS', '유재석');
INSERT INTO secondaryTBL VALUES ('KHD', '강호동');
INSERT INTO secondaryTBL VALUES ('KKJ', '김국진');
INSERT INTO secondaryTBL VALUES ('KYM', '김용만');
INSERT INTO secondaryTBL VALUES ('KJD', '김제동');
INSERT INTO secondaryTBL VALUES ('NHS', '남희석');
INSERT INTO secondaryTBL VALUES ('SDY', '신동엽');
INSERT INTO secondaryTBL VALUES ('LHJ', '이휘재');
INSERT INTO secondaryTBL VALUES ('LKK', '이경규');
INSERT INTO secondaryTBL VALUES ('PSH', '박수홍');

SELECT * FROM secondaryTBL;

SHOW INDEX FROM secondaryTBL;
-- ----------------------------------------------------------------------------------------------------------
-- index
USE cookDB;
DROP TABLE IF EXISTS TBL1;
CREATE TABLE TBL1( 
	a INT PRIMARY KEY,
	b INT,
	c INT
);

SHOW INDEX FROM TBL1;
-- ----------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS TBL2;
CREATE TABLE TBL2
( 
	a INT PRIMARY KEY,
	b INT UNIQUE,
	c INT UNIQUE,
	d INT
);
SHOW INDEX FROM TBL2;
-- ----------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS TBL3;
CREATE TABLE TBL3
( 
	a INT UNIQUE,
	b INT UNIQUE,
	c INT UNIQUE,
	d INT
);
SHOW INDEX FROM TBL3;
-- ----------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS TBL5;
CREATE TABLE TBL5
( 
	a INT UNIQUE NOT NULL,
	b INT UNIQUE,
	c INT UNIQUE,
	d INT PRIMARY KEY
);
SHOW INDEX FROM TBL5;
-- ----------------------------------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS testDB;
USE testDB;
DROP TABLE IF EXISTS userTBL;
CREATE TABLE userTBL
( 
	userID char(8) NOT NULL PRIMARY KEY,
	userName varchar(10) NOT NULL,
	birthYear int NOT NULL,
	addr char(2) NOT NULL
);

INSERT INTO userTBL VALUES ('YJS', '유재석', 1972, '서울');
INSERT INTO userTBL VALUES ('KHD', '강호동', 1970, '경북');
INSERT INTO userTBL VALUES ('KKJ', '김국진', 1965, '서울');
INSERT INTO userTBL VALUES ('KYM', '김용만', 1967, '서울');
INSERT INTO userTBL VALUES ('KJD', '김제동', 1974, '경남');
SELECT * FROM userTBL; -- 왜 오름차순 정렬이 되는가?
SHOW INDEX FROM userTBL;

ALTER TABLE userTBL DROP PRIMARY KEY;
ALTER TABLE userTBL
ADD CONSTRAINT pk_userName PRIMARY KEY (userName);
SELECT * FROM userTBL;

SHOW INDEX FROM userTBL;
-- ----------------------------------------------------------------------------------------------------------
CREATE [UNIQUE | FULLTEXT | SPATIAL] INDEX index_name
	[index_type]
	ON TBL_userName (index_col_userName, )
	[index_option]
	[algorithm_option | lock_option]

index_col_userName:
	col_userName [(length)] [ASC | DESC]

index_type:
	USING {BTREE | HASH}

index_option:
	KEY_BLOCK_SIZE [=] value
	| index_type
	| WITH PARSER parser_userName
	| COMMENT 'string'

algorithm_option:
	ALGORITHM [=] {DEFAULT | INPLACE | COPY}
lock_option:
	LOCK [=] {DEFAULT | NONE | SHARED | EXCLUSIVE} 
-- ----------------------------------------------------------------------------------------------------------
DROP INdex_name ON TBL_userName
	[algorithm_option | lock_option]

algorithm_option:
	ALGORITHM [=] {DEFAULT | INPLACE|COPY}

lock_option:
LOCK [=] {DEFAULT | NONE | SHARED | EXCLUSIVE}

# DROP INDEX 인덱스이름 ON 테이블이름;
DROP INDEX `PRIMARY` ON TBL1;  # 이거 오류남
-- ----------------------------------------------------------------------------------------------------------
USE cookDB;
SELECT * FROM userTbl;
SHOW INDEX FROM userTbl;

CREATE UNIQUE INDEX idx_userTbl_birtyYear    # 오류생성
	ON userTbl (birthYear);

# 이름 열에 고유 보조 인덱스 생성 시 오류 제거
CREATE UNIQUE INDEX idx_userTbl_userName ON userTbl (userName);
SHOW INDEX FROM userTbl;











