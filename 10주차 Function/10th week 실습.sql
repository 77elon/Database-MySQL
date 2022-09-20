--  예제의 프로시저를 함수 형식으로 변경

DROP FUNCTION IF EXISTS customerLevel;

DELIMITER $$
SET GLOBAL log_bin_trust_function_creators = 1;
CREATE FUNCTION customerLevel (sum INT)
RETURNS VARCHAR(20)
BEGIN
	DECLARE grade VARCHAR(20);
		CASE
			WHEN (sum >= 1500) THEN SET grade = '최우수고객';
			WHEN (sum >= 1000) THEN SET grade = '우수고객';
			WHEN (sum >= 1 ) THEN SET grade = '일반고객';
            ELSE SET grade = '유령고객';
		END CASE;
	RETURN(grade);
END $$
DELIMITER ;

SELECT U.userID, U.userName, SUM(price * amount) as '총구매액', 
	customerLevel(SUM(price * amount)) 	as '고객등급' 
	FROM buyTbl B RIGHT OUTER JOIN userTbl U ON B.userID = U.userID
	GROUP BY U.userID, U.userName
	ORDER BY SUM(price * amount) DESC;
    
-- -------------------------------------------------------------------------------------------------------------

USE madang;
DROP PROCEDURE IF EXISTS interest;

delimiter $$
CREATE PROCEDURE interest()
BEGIN
	DECLARE myinterest INTEGER DEFAULT 0;
    DECLARE Price INT;
    DECLARE profit INT DEFAULT 0;
    DECLARE endOfRow BOOLEAN DEFAULT FALSE;
    
	DECLARE userCuror CURSOR FOR -- 커서 선언
		SELECT saleprice FROM Orders;
	DECLARE CONTINUE HANDLER -- 행의 끝이면 endOfRow 변수에 TRUE 대입
		FOR NOT FOUND SET endOfRow = TRUE;

	OPEN userCuror; -- 커서 열기

	cursor_loop: LOOP
		FETCH userCuror INTO Price; -- 고객의 키 1개 대입
        IF endOfRow THEN -- 더 이상 읽을 행이 없으면 LOOP 종료
			LEAVE cursor_loop;
		END IF;

		IF Price >= 30000 THEN
			SET profit = profit + (Price / 10);
		ELSE 
			SET profit = profit + (Price / 20);
        END IF;
        
	END LOOP cursor_loop;
    
    SELECT CONCAT('총 영업이익 ==> ', profit);
    
	CLOSE userCuror; -- 커서 닫기
END $$
DELIMITER ;
    
CALL interest();

-- -----------------------------------------------------------------------------------------------------------
USE madang;
SELECT name FROM Customer WHERE name LIKE '박세리';

CREATE UNIQUE INDEX customer_Name ON Customer (name);
SHOW INDEX FROM Customer;

SELECT name FROM Customer WHERE name LIKE '박세리';
DROP INDEX `customer_Name` ON Customer;  


