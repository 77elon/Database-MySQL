CREATE SCHEMA THEATER;

USE THEATER;

CREATE TABLE 극장 (
극장번호 INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
극장이름 VARCHAR(4) NOT NULL,
위치 VARCHAR(4) NOT NULL
);

INSERT INTO 극장 VALUES (NULL, '롯데', '잠실');
INSERT INTO 극장 VALUES (NULL, '메가', '강남');
INSERT INTO 극장 VALUES (NULL, '대한', '잠실');

SELECT * FROM 극장;

CREATE TABLE 상영관(
극장번호 INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
상영관번호 INT NOT NULL,
영화제목 VARCHAR(10),
가격 INT,
좌석수 INT,
FOREIGN KEY (극장번호) REFERENCES 극장(극장번호),
CHECK (가격 < 20000 AND 상영관번호 BETWEEN 1 AND 10)
);

INSERT INTO 상영관 VALUES (NULL, 1, '어려운 영화', 15000, 48);
INSERT INTO 상영관 VALUES (NULL, 1, '멋진 영화', 7500, 120);
INSERT INTO 상영관 VALUES (NULL, 2, '재밌는 영화', 8000, 110);

SELECT * FROM 상영관;

CREATE TABLE 고객(
고객번호 INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
이름 VARCHAR(4)  NOT NULL,
주소 VARCHAR(4)  NOT NULL 
);
INSERT INTO 고객 VALUES (3, '홍길동', '강남');
INSERT INTO 고객 VALUES (4, '김철수', '잠실');
INSERT INTO 고객 VALUES (9, '박영희', '강남');

SELECT * FROM 고객;

CREATE TABLE 예약(
극장번호 INT NOT NULL,
예약번호 INT UNIQUE NOT NULL PRIMARY KEY,
고객번호 INT NOT NULL,
좌석번호 INT NOT NULL UNIQUE,
날짜 DATE NOT NULL,
FOREIGN KEY (극장번호) REFERENCES 극장(극장번호),
FOREIGN KEY (고객번호) REFERENCES 고객(고객번호)
);

INSERT INTO 예약 VALUES (3, 2, 3, 15, 20140901);
INSERT INTO 예약 VALUES (3, 1, 4, 16, 20140901);
INSERT INTO 예약 VALUES (1, 3, 9, 48, 20140901);


DELETE FROM	예약;
DROP TABLE 예약;

SELECT * FROM 예약;

SELECT 극장이름 AS 이름, 위치  -- 1번
FROM 극장;

SELECT * 
FROM 극장
WHERE 극장.위치 = '잠실';

SELECT *
FROM 고객
WHERE 고객.주소 = '잠실'
ORDER BY 이름 ASC;

SELECT 극장번호, 상영관번호, 영화제목
FROM 상영관
WHERE 가격 <= 8000;

SELECT *
FROM 고객
WHERE 고객.주소 IN (SELECT 위치
									  FROM 극장)
ORDER BY 주소 ASC;

SELECT COUNT(*) AS '극장의 수' -- 2번
FROM 극장;

SELECT AVG(가격) AS '상영되는 영화의 평균 가격'
FROM 상영관;

SELECT 영화제목 -- 3번
FROM 상영관
WHERE 극장번호 IN (SELECT 극장번호
									 FROM 극장
									 WHERE 극장이름 = '대한');

SELECT 이름
FROM 고객 JOIN 예약 ON 고객.고객번호 = 예약.고객번호
WHERE 극장번호 IN (SELECT 극장번호
									 FROM 극장
                                     WHERE 극장이름 = '대한');

SELECT SUM(가격) AS '대한 극장의 전체 수입'
FROM 예약 JOIN 상영관 ON 예약.극장번호 = 상영관.극장번호
WHERE 상영관.극장번호 IN (SELECT 극장번호
									 FROM 극장
                                     WHERE 극장.극장이름 ='대한');
									
SELECT SUM(가격) AS '대한 극장의 전체 수입' -- ambiguous error
FROM 예약 JOIN 상영관 ON 예약.극장번호 = 상영관.극장번호
WHERE 예약.극장번호 IN (SELECT 극장번호
									 FROM 극장
                                     WHERE 극장.극장이름 ='대한');                                    

SELECT 극장이름, COUNT(상영관번호) AS '극장별 상영관의 수' -- 4번
FROM 상영관 JOIN 극장
GROUP BY 극장이름;

SELECT *
FROM 극장 JOIN 상영관 ON 극장.극장번호 = 상영관.극장번호
WHERE 극장.위치='잠실';

SELECT 극장이름, COUNT(극장이름) AS '극장별 관람 고객의 수'
FROM 예약 JOIN 극장 ON 예약.극장번호 = 극장.극장번호
WHERE 예약.날짜='2014-09-01'
GROUP BY 극장이름;


UPDATE 상영관 SET 가격 = 가격 * 1.1; -- 5번
SELECT * FROM 상영관
ORDER BY 영화제목;

ALTER TABLE 예약 MODIFY COLUMN 날짜 DATE;