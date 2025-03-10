-- 함수 : 컬럼의 값을 읽어서 연산을 한 결과를 반환

-- 단일 행 함수 : N개의 값을 읽어서 연산 후 N개의 결과를 반환

-- 그룹 함수 : N개의 값을 읽어서 연산 후 1개의 결과를 반환(합계, 평균, 최대, 최소 등)

-- 함수는 SELECT 문의
-- SELECT절, WHERE절, ORDER BY절, GROUP BY절, HAVING절 사용 가능

---------------------------단일 행 함수--------------------------------

-- LENGTH(컬럼명 | 문자열) : 길이(글자수) 반환
SELECT EMAIL, LENGTH(EMAIL)	
FROM EMPLOYEE;
-- 12개 값을 넣어 12개 값을 반환받음

SELECT EMAIL, LENGTH('가나다라마바사')	
FROM EMPLOYEE; -- 23개의 값 전달하여 23번 반환(출력)

-------------------------------------------

-- INSTR(컬럼명 | 문자열, '찾을 문자열' [, 찾기 시작할 위치 [, 순번]])
-- 지정한 위치부터 지정한 순번째로 검색되는 문자의 위치를 반환

-- AABAACAABBAA

-- 문자열을 앞에서부터 검색하여 첫번째 B의 위치 조회
SELECT INSTR('AABAACAABBAA', 'B')
FROM DUAL;

-- 문자열을 5번째 문자부터 검색하여 첫번째 B의 위치 조회. => 6번째부터 카운트
SELECT INSTR('AABAACAABBAA', 'B', 5) FROM DUAL; -- 9

-- 문자열을 5번째 문자부터 검색해서 두번째 B의 위치 조회
SELECT INSTR('AABAACAABBAA', 'B', 5, 2) FROM DUAL; -- 10

-- EMPLOYEE 테이블에서 사원명, 이메일, 이메일 중 '@' 위치 조회
SELECT EMP_NAME, EMAIL, INSTR(EMAIL, '@')
FROM EMPLOYEE;

---------------------------------------------------------

-- SUBSTR('문자열' | 컬럼명, 잘라내기 시작할 위치 [, 잘라낼 길이])
-- 컬럼이나 문자열에서 지정한 위치부터 지정된 길이만큼 문자열을 잘라내서 반환
-- 잘라낼 길이 생략 시 문자열 끝까지 잘라냄

-- EMPLOYEE 테이블에서 사원명, 이메일 중 아이디(@이전에 쓰여져 있는 부분)만 조회
-- sun_di@or.kr -> sun_di
SELECT EMP_NAME, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') -1 ) 아이디
FROM EMPLOYEE;

------------------------------------------------------

-- TRIM( [[옵션] '문자열' | 컬럼명 FROM ] ) -- 옵션을 작성하지 않을 경우 TRIM('문자열' | 컬럼명)
-- 주어진 컬럼이나 문자열의 앞, 뒤, 양쪽에 있는 지정된 문자를 제거
--> 문자열의 양쪽 공백 제거에 많이 사용됨.

-- 옵션: LEADING(앞쪽), TRAILING(뒤쪽), BOTH(양쪽, 기본값) -- 옵션을 작성하지 않을 경우 BOTH가 기본값
SELECT TRIM('				H E L L O				')	--옵션을 작성하지 않았기 때문에 기본값 BOTH 적용
FROM DUAL;

SELECT TRIM(BOTH '#' FROM '####안녕####') 
FROM DUAL;

--------------------------------------------------------

-- 숫자 관련 함수

-- ABS(숫자 | 컬럼명) : 절대값
SELECT ABS(10), ABS(-10) FROM DUAL;

SELECT '절대값 같음' FROM DUAL
WHERE ABS(10) = ABS(-10);	-- WHERE절에서도 함수 작성 가능

-- MOD(숫자 | 컬럼명, 숫자 | 컬럼명) : 나머지 값 반환

-- EMPLOYEE 테이블에서 사원의 월급을 100만으로 나눴을 때 나머지를 조회
SELECT EMP_NAME, SALARY, MOD(SALARY, 1000000)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번이 짝수인 사원의 사번, 이름 조회
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE MOD(EMP_ID, 2) = 0;

-- EMPLOYEE 테이블에서 사번이 홀수인 사원의 사번, 이름 조회
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE MOD(EMP_ID, 2) <> 0;

-- ROUND(숫자 | 컬럼명 [, 소수점 위치]) : 반올림

SELECT ROUND(123.456) FROM DUAL; -- 123, 소수점 첫번째 자리에서 반올림

SELECT ROUND(123.456, 1) FROM DUAL; 
-- 123.5,  소수점 둘 째 자리에서 반올림(소수점 첫번째 자리까지 표기)

-- CEIL(숫자 | 컬럼명) : 소수점 첫째 자리에서 올림
-- FLOOR(숫자 | 컬럼명) : 소수점 첫째 자리에서 내림
SELECT CEIL(123.1), FLOOR(123.9) FROM DUAL;

-- TRUNC(숫자 | 컬럼명 [, 위치]) : 특정 위치 아래를 절삭
SELECT TRUNC(123.456) FROM DUAL; -- 123, 소수점 아래를 절삭
SELECT TRUNC(123.456, 1) FROM DUAL; -- 123.4, 소수점 첫째자리 아래 절삭
SELECT TRUNC(123.456, -1) FROM DUAL; -- 120, 10의 자리 아래 절삭

---------------------------------------------------------------

-- 날짜(DATE) 관련 함수

-- SYSDATE : 시스템에 현재 시간(년, 월, 일, 시, 분, 초)을 반환
SELECT SYSDATE FROM DUAL; -- 2025-03-10 12:11:08.000

-- SYSTIMESTAMP : SYSDATE + MS 단위 추가 
SELECT SYSTIMESTAMP FROM DUAL; -- 2025-03-10 12:12:18.736 +0900
-- +0900 => UTC(세계표준시간)가 9시간 빠른 시간 => 한국 표준시간은 UTC + 9

-- MONTHS_BETWEEN(날짜, 날짜) : 두 날짜의 개월 수 차이 반환
SELECT ABS(ROUND(MONTHS_BETWEEN(SYSDATE, '2025-07-22'), 3)) "남은 수강 기간(개월)"
FROM DUAL; -- 4.371

-- EMPLOYEE 테이블에서 
-- 사원의 이름, 입사일, 근무한 개월 수, 근무 년차 조회
SELECT EMP_NAME, HIRE_DATE, 
CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무한 개월수", 
CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) || '년차' "근무 년차"
FROM EMPLOYEE;

-- || : 연결 연산자(문자열 이어쓰기)

-- ADD_MONTHS(날짜, 숫자) : 날짜에 숫자 만큼의 개월 수를 더함(음수도 가능)
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL; -- 오늘 날짜에 4개월 더한 값 조회
SELECT ADD_MONTHS(SYSDATE, -1) FROM DUAL; -- 오늘 날짜에 1개월 뺀 값 조회

-- LAST_DAY(날짜) : 해당 달의 마지막 날짜를 구함
SELECT LAST_DAY(SYSDATE) "이번 달 마지막 날짜" FROM DUAL;
SELECT LAST_DAY('2020-02-01') FROM DUAL; --2020-02월의 마지막 날짜

-- EXTRACT : 년, 월, 일 정보를 추출하여 리턴(반환)
-- EXTRACT(YEAR FROM 날짜): 해당 날짜의 년도만 추출
-- EXTRACT(MONTH FROM 날짜): 해당 날짜의 월만 추출
-- EXTRACT(DAY FROM 날짜): 해당 날짜의 일만 추출

-- EMPLOYEE 테이블에서
-- 각 사원의 이름, 입사일 조회(입사년도, 월, 일)
-- 2000년 10월 10일 
SELECT EMP_NAME, 
EXTRACT(YEAR FROM HIRE_DATE) || '년' ||
EXTRACT(MONTH FROM HIRE_DATE) || '월' ||
EXTRACT(DAY FROM HIRE_DATE) || '일' AS 입사일 -- 쌍따옴표 안에 작성해도 됨. "입사일"
FROM EMPLOYEE;

------------------------------------------------------------
-- 형변환 함수
-- 문자열(CHAR), 숫자(NAMBER), 날짜(DATE) 끼리 형변환 가능

-- 1. 문자열로 변환
-- TO_CHAR(날짜, [포맷]) : 날짜형 데이터를 문자형 데이터롤 변경
-- TO_CHAR(숫자, [포맷]) : 숫자형 데이터를 문자형 데이터로 변경

-- 숫자 -> 문자 변환 시 사용하는 포맷 패턴
-- 9 : 숫자 한칸을 의미, 여러 개 작성 시 오른쪽 정렬
-- 0 : 숫자 한칸을 의미, 여러 개 작성 시 오른쪽 정렬. 만약 빈칸이 있다면 빈칸을 0으로 채움
-- L : 현재 DB에 설정된 나라의 화폐 기호

SELECT TO_CHAR(1234, '99999') FROM DUAL; -- ' 1234' 
SELECT TO_CHAR(1234, '00000') FROM DUAL; -- '01234'
SELECT TO_CHAR(1234) FROM DUAL; -- '1234'

SELECT TO_CHAR(1000000, '9,999,999') || '원' FROM DUAL;
SELECT TO_CHAR(1000000, 'L9,999,999') || '원' FROM DUAL; -- '\(원화표시)1,000,000'

-- 날짜를 -> 문자로 변환할 때 사용하는 포맷 패턴
-- YYYY : 년도 / YY : 년도(짧게 뒷부분만 표시)
-- MM : 월
-- DD : 일
-- AM/PM : 오전/오후 
-- HH : 시간 / HH24 : 24시간 표기법
-- MI : 분 / SS : 초
-- DAY : 요일(전체) / DY : 요일(요일명만 표시)

-- 2025/03/10 12:45:35 월요일
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS DAY') 오늘날짜 FROM DUAL;

-- 3/10 (월)
SELECT TO_CHAR(SYSDATE, 'MM/DD (DY)') FROM DUAL;

-- 2025년 3월 10일 (월)
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" (DY)') FROM DUAL;
-- 날짜를 문자로 변환할 때 사용하는 포맷 패턴 외의 문자를 입력하면 문자도 패턴으로 인식됨.
--> "" 쌍따옴표를 이용해서 단순한 문자로 인식시키면 해결됨

---------------------------------------------------------------

-- 2. 날짜로 형변환 TO_DATE

-- TO_DATE(문자형 데이터, [포맷]) : 문자형 -> 날짜로 변경
-- TO_DATE(숫자형 데이터, [포맷]) : 숫자형 -> 날짜로 변경
--> 지정된 포맷으로 날짜를 인식함

SELECT TO_DATE('2025-03-10') FROM DUAL; -- 2025-03-10 00:00:00.000, 문자형을 날짜형으로
SELECT TO_DATE(20250310) FROM DUAL; -- 2025-03-10 00:00:00.000, 
 
SELECT TO_DATE('250310 140730') FROM DUAL;
 -- SQL Error [1861] [22008]: ORA-01861: 리터럴이 형식 문자열과 일치하지 않음
--> 패턴을 적용해서 작성된 문자열의 각 문자가 어떤 날짜 형식인지 인식 시켜야함.
SELECT TO_DATE('250310 140730', 'YYMMDD HH24MISS') FROM DUAL;
-- 2025-03-10 14:07:30.000

-- Y 패턴 : 현재 세기(21세기 == 20XX년 == 2000년대)
-- R 패턴 : 1세기 기준으로 절반(50년) 이상인 경우는 이전세기(1900년대)를 나타냄
--										 절반(50년) 미만인 경우 현재 세기(2000년대)를 나타냄
SELECT TO_DATE('800505', 'YYMMDD') FROM DUAL; -- 2080-05-05 00:00:00.000
SELECT TO_DATE('800505', 'RRMMDD') FROM DUAL; -- 1980-05-05 00:00:00.000 --???????????????
SELECT TO_DATE('490505', 'RRMMDD') FROM DUAL; -- 2049-05-05 00:00:00.000

-- EMPLOYEE 테이블에서 각 직원이 태어난 생년월일을 조회하기
-- 사원이름, 생년월일(1965년 10월 08일)
SELECT * FROM EMPLOYEE;
-- EMP_NO (주민번호) : 621231-1985634

-- 1) 주민번호에서 '-' 앞글자까지 추출
SELECT EMP_NAME, 
SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') - 1) AS 생년월일
FROM EMPLOYEE;
-- 621231

-- 2) 추출한 생년월일을 TO_DATE 타입으로 변경 -> R 패턴을 이용하여 1990년도로 변경
SELECT EMP_NAME, 
TO_DATE(SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') - 1), 'RRMMDD') AS 생년월일
FROM EMPLOYEE;
-- 1962-12-31 00:00:00.000

-- 3) TO_CHAR를 이용해서 날짜를 문자열로 변환 -> 1962년 12월 31일
SELECT EMP_NAME, 
TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') - 1), 'RRMMDD'), 'YYYY"년" MM"월" DD"일"') AS 생년월일
FROM EMPLOYEE;
-- 1962년 12월 31일

---------------------------------------------------------

-- 숫자 형변환 
-- TO_NUMBER(문자데이터, [포맷]) : 문자형 데이터만 숫자 데이터로 변경 가능

SELECT '1,000,000' + 500000 FROM DUAL;
-- SQL Error [1722] [42000]: ORA-01722: 수치가 부적합합니다
-- ,콤마 때문에 문자열로 인식되어 자동형변환 안됌.

SELECT TO_NUMBER('1,000,000', '9,999,999') + 500000 FROM DUAL;
-- 1,500,000

-- NULL 처리 함수
-- NVL(컬럼명, 컬럼값이 NULL일 때 바꿀 값) : NULL인 컬럼값을 다른 값을 변경할 때 쓰는 함수이다
SELECT * FROM EMPLOYEE;

-- NULL과 산술 연산을 진행하면 결과는 무조건 NULL이다.
SELECT EMP_NAME, SALARY, NVL(BONUS, 0), SALARY * BONUS
FROM EMPLOYEE;
SELECT EMP_NAME, SALARY, NVL(BONUS, 0), SALARY * NVL(BONUS, 0)
FROM EMPLOYEE;

-- NVL2(컬럼명, 바꿀값1, 바꿀값2)
-- 해당 컬럼의 값이 있으면 바꿀값1로 변경,
-- 해당 컬럼의 값이 NULL이면 바꿀값2로 변경
-- EMPLOYEE 테이블에서 보너스를 받으면 'O', 안받으면 'X'로 조회하기
SELECT EMP_NAME, NVL2(BONUS, 'O', 'X') "보너스 수령"
FROM EMPLOYEE;
-- NVL은 시험문제에 자주 나오므로 꼭 외우기!

---------------------------------------------------------

-- 선택 함수
-- : 여러가지 경우에 따라 알맞은 결과를 선택할 수 있게 하는 함수

-- DECODE(계산식 | 컬럼명, 조건값1, 선택값1, 조건값2, 선택값2, ... , 아무것도 일치하지 않을 때)
-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과 값 반환(출력)

-- 직원의 성별 구하기
SELECT EMP_NO FROM EMPLOYEE;

SELECT EMP_NAME, DECODE( SUBSTR(EMP_NO, 8, 1), '1', '남성', '2', '여성') 성별
FROM EMPLOYEE;

-- 직원의 급여를 인상하려고 한다
-- 직급 코드가 J7인 직원은 20% 인상
-- 직급 코드가 J6인 직원은 15% 인상
-- 직급 코드가 H5인 직원은 10% 인상
-- 그 외 직급은 5% 인상.
-- 이름, 직급코드, 급여, 인상률, 인상된 급여를 조회


SELECT EMP_NAME, JOB_CODE, SALARY, 
DECODE(JOB_CODE, 'J7', '20%',
								 'J6', '15%',
								 'J5', '10%',
									      '5%') 인상률, 
DECODE(JOB_CODE, 'J7', SALARY * 1.2,
								 'J6', SALARY * 1.15,
								 'J5', SALARY * 1.1,
									SALARY * 1.05) "인상된 급여"
FROM EMPLOYEE;

-- CASE WHEN 조건식 THEN 결과값
--		  WHEN 조건식 THEN 결과값
-- 			ELSE 결과값
-- END

-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과값을 반환
-- 조건은 범위값 가능

-- EMPLOYEE 테이블에서
-- 급여가 500만원 이상이면 '대'
-- 급여가 300만원 이상 500만원 미만이면 '중'
-- 급여가 300만원 미만이면 '소'로 조회
-- 사원 이름, 급여, 급여 받는 정도 조회하기
SELECT EMP_NAME, SALARY, 
CASE WHEN SALARY >= 5000000 THEN '대' -- IF
	   WHEN SALARY >= 3000000 THEN '중' -- ELSE IF
		 ELSE '소' -- ELSE
END "급여 받는 정도"
FROM EMPLOYEE;

----------------------------------------------------

-- 그룹 함수------------------------------------------
-- 하나 이상의 행을 그룹으로 묶어 연산하여 총합, 평균 등의
-- 하나의 결과 행으로 반환하는 함수

-- SUM(숫자가 기록된 컬럼명) : 합계
-- 모든 직원의 급여 합 조회해보기
SELECT SUM(SALARY) FROM EMPLOYEE; -- 70,096,240

-- AVG(숫자가 기록된 컬럼명) : 평균
-- 전 직원 급여 평균 조회해보기
SELECT ROUND(AVG(SALARY)) FROM EMPLOYEE; -- 3,047,663

-- 부서코드가 'D9'인 사원들의 급여 합, 평균 조회해보기
-- 부서코드가 'D9'인 사원들 - WHERE
-- 사원들의 급여 합, 평균 조회 - SELECT

/*3*/SELECT SUM(SALARY), ROUND(AVG(SALARY))
/*1*/FROM EMPLOYEE
/*2*/WHERE DEPT_CODE = 'D9'; -- DEPT_CODE가 'D9'인 사원들 '중'에 => 추린 것


-- MIN(컬럼명) : 최소값
-- MAX(컬럼명) : 최대값
--> 타입 제한 없음(숫자 : 대/소, 날짜 : 과거/미래, 문자열 : 문자 순서)

-- 급여 최소값, 가장 빠른 입사일, 알파벳 순서가 가장 빠른 이메일을 조회하기
SELECT MIN(SALARY), MIN(HIRE_DATE), MIN(EMAIL)
FROM EMPLOYEE;


-- 급여 최대값, 가장 최근 입사일, 알파벳 순서가 가장 느린 이메일 조회
SELECT MAX(SALARY), MAX(HIRE_DATE), MAX(EMAIL)
FROM EMPLOYEE;


-- EMPLOYEE 테이블에서 
-- 급여를 가장 많이 받는 사원의 
-- 이름, 급여, 직급 코드를 조회해라
SELECT EMP_NAME, SALARY, JOB_CODE
FROM EMPLOYEE
WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);

/*SELECT EMP_NAME, SALARY, JOB_CODE
FROM EMPLOYEE
WHERE SALARY  -> 그룹 함수
*/
-- ( MAX(SALARY) FROM EMPLOYEE) -> 서브쿼리

-- 서브쿼리 + 그룹함수를 같이 이용해야 하는 문제이다.
SELECT MAX(SALARY) FROM EMPLOYEE; -- 800만원

-- COUNT() : 행 개수를 헤어려서 반환
-- COUN(컬럼명) : NULL을 제외한 실제 값이 기록된 행 개수를 리턴
-- COUNT(*) : NULL을 포함한 전체 행 개수를 리턴
-- COUNT([DISTINCT] 컬럼명) : 중복을 제거한 행 개수를 리턴

SELECT COUNT(DISTINCT JOB_CODE) FROM EMPLOYEE;
