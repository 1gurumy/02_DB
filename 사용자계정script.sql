-- DB에서의 한 줄 주석

/*
 * DB에서의 범위 주석
 * 
 * 
 * */

-- 선택한 SQL을 수행하려면 : 내가 수행하고자 하는 구문에 커서 두고 CTRL + ENTER
-- 전체 SQL을 수행하려면 : 전체 구문을 활성화(Ctrl + a)시킨 채로 alt + x

-- 12c 버전 이전 문법 허용해주는 구문
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- 계정을 생성하는 구문 (username : kh / password : kh1234)
CREATE USER kh IDENTIFIED BY kh1234;

-- 사용자 계정에 권한을 부여하는 구문
GRANT RESOURCE, CONNECT TO kh;
-- RESOURCE : 테이블이나 인덱스 같은 DB 객체를 생성할 권한
-- CONNECT : DB에 연결하고 로그인 할 수 있는 권한


-- 객체가 생성될 수 있는 공간 할당량을 무제한으로 지정하는 구문
ALTER USER kh DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM ;


