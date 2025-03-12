-- TCL (Transaction Control Language) : 트랜잭션 제어 언어
-- COMMIT, ROLLBACK, SAVEPOINT

-- DML : 데이터 조작언어로 데이터의 삽입/삭제/수정
--> 트랜잭션은 DML과 관련되어 있음..

/* TRANSACTION 이란?
 * - 데이터베이스의 논리적 연산 단위
 * - 데이터 변경 사항을 묶어서 하나의 트랜잭션에 담아 처리함.
 * - 트랜잭션의 대상이 되는 데이터 변경 사항 : INSERT, UPDATE, DELETE, MERGE
 *
 * INSERT 수행 ------------------------------------------------> DB 반영 (X)
 *
 * INSERT 수행 -----> 트랜잭션에 추가 ---> COMMIT -------------> DB 반영 (O)
 *
 * INSERT 10번 수행 --> 1개 트랜잭션에 10개 추가 --> ROLLBACK --> DB 반영 (X)
 *
 *
 * 1 ) COMMIT : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 DB에 반영
 *
 * 2 ) ROLLBACK : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 삭제하고
 *                마지막 COMMIT 상태로 돌아감 (DB에 변경 내용 반영 X)
 *
 *
 * 3 ) SAVEPOINT : 메모리 버퍼(트랜잭션)에 저장 지점을 정의하여
 *                ROLLBACK 수행 시 전체 작업을 삭제하는 것이 아닌
 *                저장 지점까지만 일부 ROLLBACK
 *
 *
 * [SAVEPOINT 사용법]
 *
 * ...
 * SAVEPOINT "포인트명1";
 *
 * ...
 * SAVEPOINT "포인트명2";
 *
 * ...
 * ROLLBACK TO "포인트명1"; -- 포인트1 지점까지 데이터 변경사항 삭제
 *
 *
 * ** SAVEPOINT 지정 및 호출 시 이름에 ""(쌍따옴표) 붙여야함 !!! ***
 *
 * */

-- 새로운 데이터를 DEPARTMENT2 테이블에 INSERT해보기

SELECT * FROM DEPARTMENT2;

INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2');


-- INSERT 수행 되었는지 확인
SELECT * FROM DEPARTMENT2;

--> DB에 영구 반영된 것 처럼 보이지만
-- 실제로 아직 DB에 영구 반영된 것 아님
-- 트랜젝션에 INSERT 3개가 들어가 있는 상태일 뿐임.

--ROLLBACK 후 확인
ROLLBACK; -- 마지막 커밋 시점까지 되돌아감.

SELECT * FROM DEPARTMENT2; -- 롤백 수행 후 개발1, 개발2. 개발3 팀 롤백된 결과 확인 가능

-- COMMIT 후 ROLLBACK이 되는지 확인해보기
INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2');

-- INSERT 적용 되었는지 확인
SELECT * FROM DEPARTMENT2;

COMMIT;	-- 트랜젝션에 있던 INSERT 3 개가 DB에 영구 반영되고, 트랜젝션은 빈 상태가 됨.

ROLLBACK; -- COMMIT 수행했다면 트랜젝션이 빈 상태가 되기 때문에 ROLLBACK 되는 것이 없음.

-- COMMIT후 ROLLBACK 안된다. 이미 DB에 반영됨. 트랜젝션이 빈 상태이기 때문에 ROLLBACK 되는 것이 없음.
SELECT * FROM DEPARTMENT2; 

----------------------------------------------------------------------

-- SAVEPOINT 확인

INSERT INTO DEPARTMENT2 VALUES('T4', '개발4팀', 'L2');
SAVEPOINT "SP1"; -- SAVEPOINT 지정

INSERT INTO DEPARTMENT2 VALUES('T5', '개발5팀', 'L2');
SAVEPOINT "SP2"; -- SAVEPOINT 지정

INSERT INTO DEPARTMENT2 VALUES('T6', '개발6팀', 'L2');
SAVEPOINT "SP3"; -- SAVEPOINT 지정

SELECT * FROM DEPARTMENT2;

ROLLBACK TO "SP1"; -- 수행시

SELECT * FROM DEPARTMENT2;	-- SP1 이후의 수정사항이 모두 롤백됨. SP1이전의 수정사항(INSERT 개발4팀)은 남아있음.

ROLLBACK TO "SP2";	-- SP1지점 까지 롤백 해버려서 SP1 이후 트랜젝션에 저장되어 있던 SP2도 엎어짐.
-- ROLLBACK TO "SP1" 구문 수행 시 이후에 설정된 SP2, SP3도 삭제됨.
-- SQL Error [1086] [72000] 


INSERT INTO DEPARTMENT2 VALUES('T5', '개발5팀', 'L2');
SAVEPOINT "SP2"; -- SAVEPOINT 지정

INSERT INTO DEPARTMENT2 VALUES('T6', '개발6팀', 'L2');
SAVEPOINT "SP3"; -- SAVEPOINT 지정


SELECT * FROM DEPARTMENT2;

-- 개발팀 전체 삭제해보기
DELETE FROM DEPARTMENT2
WHERE DEPT_ID LIKE 'T%';

-- SP2 지점까지 롤백하기
ROLLBACK TO "SP2";

SELECT * FROM DEPARTMENT2;
-- 개발 6팀만 없음(트렌젝션에 SAVEPOINT SP2 지점 전에 개발 5팀, 개발4팀 있었으므로)

ROLLBACK TO "SP1";
SELECT * FROM DEPARTMENT2;
-- 개발 4팀까지만 남아있음

-- ROLLBACK 수행
ROLLBACK;	-- 마지막 커밋 시점 기준.(개발 3팀 INSERT 이후 커밋했었음.)
SELECT * FROM DEPARTMENT2; -- > 개발1, 2, 3팀까지 남음

















