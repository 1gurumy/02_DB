-- ** DML(Data Manipulation Language) : 데이터 조작 언어**

-- 테이블에 값을 삽입하거나(INSERT), 수정하거나(UPDATE), 삭제(DELETE)하는 구문

-- 주의 : 혼자서 COMMIT, ROLLBACK 수행하지 말 것!!!
-- 윈도우 > 설정 > 연결 > 연결 유형 > Auto-commit by default 언체크 되어있는지 확인!

-- 테스트용 테이블 생성(복사) => 생성(DDL) 시 즉시 커밋됨.
CREATE TABLE EMPLOYEE2 AS SELECT * FROM EMPLOYEE;
CREATE TABLE DEPARTMENT2 AS SELECT * FROM DEPARTMENT;

-- 복사 잘 됐는지 확인(복사 시 디폴트, 코멘트는 복사되지 않음.)
SELECT * FROM EMPLOYEE2;
SELECT * FROM DEPARTMENT2;

--------------------------------------------------------------

-- 1. INSERT 
-- : 테이블에 새로운 행을 추가하는 구문이다

----- INSERT 작성법
-- 1) INSERT INTO 테이블명 VALUESS(데이터, 데이터, 데이터...);
-- 테이블에 있는 !모든 컬럼!에 대한 값을 INSERT 할 때 사용하는 구문
-- 단, 테이블에 정해진 컬럼의 순서를 지켜서 VALUES에 값을 기입해야함.
SELECT * FROM EMPLOYEE2;

INSERT INTO EMPLOYEE2 
VALUES('900', '홍길동', '991215-1234567', 'hong_gd@or.kr',
'01011111111', 'D1', 'J7', 'S3', 4300000, 0.2, 
200, SYSDATE, NULL, 'N');

SELECT * FROM EMPLOYEE2
WHERE EMP_ID = '900';

ROLLBACK;
-- DML 수행으로는 커밋(영구저장)이 안됌. 트래젝션에 일시적으로 저장되어있을 뿐임.
-- ROLLBACK 시 트래젝션에 저장된 데이터들을 모두 삭제함.

-- 2) INSERT INTO 테이블명 (컬럼명1, 컬럼명2, 컬럼명3...)
--		VALUES (데이터1, 데이터2, 데이터3...);
-- 테이블에 내가 선택한 컬럼에 대한 값만 INSERT 할 때 사용하는 구문
-- 선택 안된 컬럼은 값이 NULL이 들어감. (DEFAULT 존재 시 DEFAULT로 설정한 값이 삽입됨.)

INSERT INTO EMPLOYEE2 (EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, 
DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY)
VALUES('900', '홍길동', '991215-1234567', 'hong_gd@or.kr',
'01011111111', 'D1', 'J7', 'S3', 4300000);

SELECT * FROM EMPLOYEE2
WHERE EMP_ID = 900;

COMMIT; -- 트래젝션에 저장되어있던 홍길동 데이터 영구저장됨.

ROLLBACK; -- ROLLBACK 수행했으나
SELECT * FROM EMPLOYEE2
WHERE EMP_ID = 900;
-- 여전히 홍길동 데이터가 조회됌. (위에서 커밋했기 때문에 롤백해도 되돌리기 안됌.)

--------------------------------------------------------------

-- INSERT 시 VALUES 대신 서브쿼리 이용하여 삽입하기

CREATE TABLE EMP_01(
	EMP_ID NUMBER,
	EMP_NAME VARCHAR2(30),
	DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_01;

SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE2
LEFT JOIN DEPARTMENT2 ON(DEPT_CODE = DEPT_ID);
-- 위 서브쿼리(SELECT) 결과를 EMP_01 테이블에 INSERT 해보기
--> SELECT 조회 결과의 데이터 타입, 컬럼 개수가
-- INSERT 하려는 테이블의 컬럼과 일치해야 함

-- 위 서브쿼리(SELECT) 결과를 EMP_01 테이블에 INSERT 해보기
INSERT INTO EMP_01(
	SELECT EMP_ID, EMP_NAME, DEPT_TITLE
	FROM EMPLOYEE2
	LEFT JOIN DEPARTMENT2 ON(DEPT_CODE = DEPT_ID)); 

-- 조회해보면 INSERT된 결과 나옴
SELECT * FROM EMP_01;

--------------------------------------------------

-- 2. UPDATE (내용을 바꾸던가 추가해서 최신화)
-- 테이블에 기록된 컬럼의 값을 수정하는 구문

-- [작성법]
/*
 * UPDATE 테이블명 
 * SET 컬럼명 = 바꿀값
 * [WHERE 컬럼명 비교연산자 비교값]; 
 * 
 * - > 전체 수정할 게 아니라면 WHERE절 작성해야함. WHERE 조건 중요!
 * 
 * */

-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9'인 부서 정보 조회해보기
SELECT * FROM DEPARTMENT2
WHERE DEPT_ID = 'D9';

-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9'인 부서의 
-- DEPT_TITLE을 '전략기획팀'으로 수정해보기
UPDATE DEPARTMENT2
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

-- UPDATE 잘 되었는지 확인
SELECT * FROM DEPARTMENT2
WHERE DEPT_ID = 'D9';
-- UPDATE가 반영되어 DEPT_TITLE이 '전략기획팀'으로 변경되었음


SELECT * FROM EMPLOYEE2;


-- EMPLOYEE2 테이블에서 BONUS를 받지 않는 사원의
-- BONUS를 0.1로 변경해보기
UPDATE EMPLOYEE2
SET BONUS = 0.1
WHERE BONUS IS NULL; -- 15개 행 수정 일어남.

SELECT EMP_NAME, BONUS FROM EMPLOYEE2;
-- BONUS 수정이 반영됬는지 확인해보기

---------------------------------------------------------------

-- * 조건절을 설정하지 않고 UPDATE 구문 실행 시
-- 모든 행의 컬럼값이 변경 *
SELECT * FROM DEPARTMENT2;

UPDATE DEPARTMENT2
SET DEPT_TITLE = '기술연구팀';
-- 조회해보면 DEPT_TITLE의 모든 컬럼값 '기술연구팀'으로 통일됨

ROLLBACK; -- 되돌리기
SELECT * FROM DEPARTMENT2; -- 되돌려진 결과가 조회됨.

----------------------------------------------------

-- * 여러 컬럼을 한 번에 수정할 시 콤마(,)로 컬럼을 구분하면 됨.
-- D9 / 총무부   ->     D0 / 전략기획팀  으로 변경
UPDATE DEPARTMENT2
SET DEPT_ID = 'D0', 
DEPT_TITLE = '전략기획팀' -- WHERE 절 직전 컬럼에는 콤마 작성 X. 작성 시 문법 오류
WHERE DEPT_ID = 'D9'
AND DEPT_TITLE = '총무부';

SELECT * FROM DEPARTMENT2;

-------------------------------------------------------------

-- * UPDATE 시에도 서브쿼리 사용 가능

-- [작성법]
-- UPDATE 테이블명
-- SET 컬럼명 = (서브쿼리)


-- EMPLOYEE2 테이블에서
-- 방명수 사원의 급여와 보너스율을 
-- 유재식 사원과 동일하게 변경해주기로 함.
-- 이를 반영하는 UPDATE문을 서브쿼리를 이용하여 작성해보기

-- 유재식의 급여 조회
SELECT SALARY FROM EMPLOYEE2
WHERE EMP_NAME = '유재식';	-- 3,400,000

-- 유재식의 보너스율 조회
SELECT BONUS FROM EMPLOYEE2
WHERE EMP_NAME = '유재식';	-- 0.2

-- 유재식의 급여와 보너스율을 조회하는 두 코드가 서브쿼리가 된다. 
-- 두 서브쿼리 이용하여 방명수 급여, 보너스 수정하기
UPDATE EMPLOYEE2
SET SALARY = (SELECT SALARY FROM EMPLOYEE2
			WHERE EMP_NAME = '유재식'),
BONUS = (SELECT BONUS FROM EMPLOYEE2
			WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';


SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE2
WHERE EMP_NAME IN('유재식', '방명수');
-- 변경 되었는지 조회해보기

--------------------------------------------------------------

-- 3. MERGE (병합)
-- 구조가 같은 두 개의 테이블을 하나로 합치는 기능
-- 테이블에서 지정하는 조건의 값이 존재하면 UPDATE
-- 없으면 INSERT됨
-- 앞에 작성한 테이블에 뒤에 작성한 테이블을 병합. ON() 괄호 안에 조건 작성. 조건이 부합하면 병합 진행

CREATE TABLE EMP_M01
AS SELECT * FROM EMPLOYEE; -- EMPLOYEE테이블 복제해서 EMP_M01 테이블 생성

CREATE TABLE EMP_M02
AS SELECT * FROM EMPLOYEE
WHERE JOB_CODE = 'J4';	-- EMPLOYEE테이블에서 JOB_CODE가 'J4'인 데이터만 복제해서 EMP_M02 테이블 생성

SELECT * FROM EMP_M01;
SELECT * FROM EMP_M02;

INSERT INTO EMP_M02
VALUES(999, '곽두원', '561016-1234567', 'kwack_dw@or.kr',
'01011112222', 'D9', 'J4', 'S1',
9000000, 0.5, NULL, SYSDATE, NULL, 'N'); -- EMP_M02 테이블에 곽두원 사원 추가

SELECT * FROM EMP_M01;	-- 23명
SELECT * FROM EMP_M02;	-- 4명(기존) + 1명(신규 곽두원 사원)

UPDATE EMP_M02 SET SALARY = 0; -- M02테이블의 모든 SALARY 컬럼 값 0으로 수정

MERGE INTO EMP_M01 USING EMP_M02 ON(EMP_M01.EMP_ID = EMP_M02.EMP_ID)
WHEN MATCHED THEN
UPDATE SET
	EMP_M01.EMP_NAME = EMP_M02.EMP_NAME,
	EMP_M01.EMP_NO = EMP_M02.EMP_NO,
	EMP_M01.EMAIL = EMP_M02.EMAIL,
	EMP_M01.PHONE = EMP_M02.PHONE,
	EMP_M01.DEPT_CODE = EMP_M02.DEPT_CODE,
	EMP_M01.JOB_CODE = EMP_M02.JOB_CODE,
	EMP_M01.SAL_LEVEL = EMP_M02.SAL_LEVEL,
	EMP_M01.SALARY = EMP_M02.SALARY,
	EMP_M01.BONUS = EMP_M02.BONUS,
	EMP_M01.MANAGER_ID = EMP_M02.MANAGER_ID,
	EMP_M01.HIRE_DATE = EMP_M02.HIRE_DATE,
	EMP_M01.ENT_DATE = EMP_M02.ENT_DATE,
	EMP_M01.ENT_YN = EMP_M02.ENT_YN
WHEN NOT MATCHED THEN
INSERT VALUES(EMP_M02.EMP_ID, EMP_M02.EMP_NAME, EMP_M02.EMP_NO, EMP_M02.EMAIL, 
	         EMP_M02.PHONE, EMP_M02.DEPT_CODE, EMP_M02.JOB_CODE, EMP_M02.SAL_LEVEL, 	  	         EMP_M02.SALARY, EMP_M02.BONUS, EMP_M02.MANAGER_ID, EMP_M02.HIRE_DATE, 
	         EMP_M02.ENT_DATE, EMP_M02.ENT_YN);


SELECT * FROM EMP_M01; -- 병합된 결과 조회해보기

---------------------------------------------------------

-- 4. DELETE
-- 테이블의 행을 삭제하는 구문

-- [작성법]
-- DELETE FROM 테이블명
-- [WHERE 조건설정];
-- WHERE절 작성은 옵션이지만, 만약 WHERE 조건을 설정하지 않으면 모든 행이 다 삭제됨!

COMMIT;

SELECT * FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동';

-- 홍길동 삭제해보기
DELETE FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동';

SELECT * FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동'; -- 삭제 됬는지 확인

ROLLBACK; -- 마지막 커밋 시점까지 돌아감

SELECT * FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동'; -- 롤백 수행 시 홍길동 조회 결과 다시 나옴.

DELETE FROM EMPLOYEE2; -- WHERE 작성 안했음 =>> 모든 행 삭제

SELECT * FROM EMPLOYEE2; -- 위 코드 수행 후 해당 코드 조회 시 모두 삭제 된 결과 조회댐.

ROLLBACK;

SELECT * FROM EMPLOYEE2; -- 롤백 수행하고 해당 코드 조회 시 모든 행 다시 되돌아옴.

-- DELETE 문에서도 서브쿼리 사용 가능!
DELETE FROM EMPLOYEE2 
WHERE EMP_ID IN (
	SELECT EMP_ID
	FROM EMPLOYEE2
	WHERE SALARY >= 3000000
	);

ROLLBACK;

-------------------------------------------------------------

-- 5. TRUNCATE (DML 아니고 DDL임.)
-- 테이블의 전체 행을 삭제하는 DDL이다.
-- DELETE보다 수행속도가 더 빠름.
-- DDL이기 때문에 수행 이후 ROLLBACK을 통해 복구할 수 없다.

-- TRUNCATE 테스트용 테이블 생성
CREATE TABLE EMPLOYEE3
AS SELECT * FROM EMPLOYEE2;	-- EMPLOYEE2 테이블에 있는 내용 그대로 복사해서 EMPLOYEE3 테이블 생성

-- 생성되었는지 확인
SELECT * FROM EMPLOYEE3;

-- TRUNCATE로 EMPLOYEE3의 모든 행 삭제해보기
TRUNCATE TABLE EMPLOYEE3;	

SELECT * FROM EMPLOYEE3; -- 조회 시 삭제 된 거 확인 가능

ROLLBACK;

-- 롤백 후 복구 확인 (복구 안됨을 확인!)
SELECT * FROM EMPLOYEE3;

-- DELETE : ex) 컴퓨터에서 휴지통으로 삭제
-- TRUNCATE : ex) 컴퓨터에서 완전 삭제(SHIFT누른채 삭제) => 복구 불가


