USE employees;

SELECT * FROM employees;

DROP PROCEDURE IF EXISTS ifProc2;

DELIMITER $$
CREATE PROCEDURE ifProc2() -- DELIMITER가 아닌 단순 PROCEDURE 선언
BEGIN
	DECLARE hireDATE DATE; -- 단순 변수 선언
    DECLARE curDATE DATE;
    DECLARE days INT;
    
    SELECT hire_date INTO hireDATE -- 직업 번호가 10001인 사람의 취업일 가져오기, INTO 문을 사용해서 변수 hireDATE에 입력하였다.
	FROM employees.employees
    WHERE emp_no = '10001';
    
    SET curDATE = CURRENT_DATE(); -- 현재 날짜
    SET days = DATEDIFF(curDATE, hireDATE); -- 날짜 비교
    
    IF (days / 365) >= 5 THEN -- 5년이 지났다면
		SELECT CONCAT('입사한지 ', days, '일이나 지났습니다. 축하합니다~!') AS '메세지'; -- 결국 문자열 합치기 + 출력, 아직 메세지는 사용하지 않았다.
	ELSE 
		SELECT '입사한지 ' + days + '일 밖에 안되었네요. 열심히 일하세요.' AS '메세지'; -- 문자열 합치기, 단순 출력
	END IF; -- 조건문 종료 선언
END $$
DELIMITER ;

CALL ifProc2();


DROP PROCEDURE IF EXISTS ifProc3;

DELIMITER $$
CREATE PROCEDURE ifProc3()
BEGIN
	DECLARE point INT; -- Variable 임을 인지.
    DECLARE credit CHAR(1);
    SET point = 77; -- 값 설정은 SET!
    
    IF point >= 90 THEN
		SET credit = 'A';
	ELSEIF point >= 80 THEN
		SET credit = 'B';
	ELSEIF point >= 70 THEN
		SET credit = 'C';
	ELSEIF point >= 60 THEN
		SET credit = 'D';
	ELSE 
		SET credit = 'F';
	END IF;
    SELECT CONCAT ('취득 점수 ==> ', point, ' 학점 ==> ', credit); -- SELECT CONCAT('취득 점수 ==>', point), CONCAT('학점 ==>', credit)으로 대체 가능하다.
END $$
DELIMITER ;
CALL ifProc3();

DROP PROCEDURE IF EXISTS caseProc;

DELIMITER $$
CREATE PROCEDURE caseProc()
BEGIN
	DECLARE point INT;
    DECLARE credit CHAR(1);
    SET point = 77;
    
    CASE -- General Language의 Case와는 다르다! 사실 상 조건문 if와 동일하게 사용한다.
		WHEN point >= 90 THEN
			SET credit = 'A';
		WHEN point >= 80 THEN
			SET credit = 'B';
		WHEN point >= 70 THEN
			SET credit = 'C';
		WHEN point >= '60' THEN
			SET credit = 'D';
		ELSE 
			SET credit = 'F';
	END CASE;
    SELECT CONCAT ('취득점수 ==> ', point, '학점 ==> ', credit);
END $$
DELIMITER ;
CALL caseProc();

