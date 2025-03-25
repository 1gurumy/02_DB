ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER kh_shop IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE TO kh_shop;

ALTER USER kh_shop DEFAULT 
TABLESPACE USERS QUOTA UNLIMITED ON USERS;

-- 쇼핑몰 DB 연습문제
-- 컬럼 별칭 작성할 것

/*
1. 카테고리 테이블 (CATEGORIES)
카테고리 ID (CATEGORY_ID) - NUMBER [PK]
카테고리 이름 (CATEGORY_NAME) - VARCHAR2(100) [UNIQUE]
*/
CREATE TABLE CATEGORIES(
	CATEGORY_ID NUMBER PRIMARY KEY,
	CATEGORY_NAME VARCHAR2(100) UNIQUE
);

SELECT * FROM CATEGORIES;

/*
 2. 상품 정보 테이블 (PRODUCTS)
상품 코드 (PRODUCT_ID) - NUMBER [PK]
상품 이름 (PRODUCT_NAME) - VARCHAR2(100) [NOT NULL]
카테고리 (CATEGORY) - NUMBER [FK - CATEGORIES(CATEGORY_ID)]
가격 (PRICE) - NUMBER [DEFAULT 0]
재고량 (STOCK_QUANTITY) NUMBER [DEFAULT 0]
*/

CREATE TABLE PRODUCTS(
	PRODUCT_ID NUMBER PRIMARY KEY,
	PRODUCT_NAME VARCHAR2(100) NOT NULL,	
	CATEGORY NUMBER REFERENCES CATEGORIES(CATEGORY_ID), -- CATEGORY_ID가 기본키니까 컬럼명까지 입력 안해줘도 되겠지. 근데 왜 그렇게 하면 에러나냐?????????????????
	PRICE NUMBER DEFAULT 0,
	STOCK_QUANTITY NUMBER DEFAULT 0
);

/*
3. 고객 정보 테이블 (CUSTOMERS)
고객 ID (CUSTOMER_ID) - NUMBER [PK]
이름 (NAME) - VARCHAR2(20) [NOT NULL]
성별 (GENDER) - CHAR(3) [CHECK 남, 여]
주소 (ADDRESS) - VARCHAR2(100)
전화번호 (PHONE) - VARCHAR2(30)
 * */
CREATE TABLE CUSTOMERS(
	CUSTOMER_ID NUMBER PRIMARY KEY,
	NAME VARCHAR2(20), -- NOT NULL은 컬럼에서 설정 못함
	GENDER CHAR(3) CHECK (GENDER IN('남', '여')),
	ADDRESS VARCHAR2(100),
	PHONE VARCHAR2(30)
);

/*
4. 주문 정보 테이블 (ORDERS)
주문 번호 (ORDER_ID) - NUMBER [PK]
주문일 (ORDER_DATE) - DATE [DEFAULT SYSDATE]
처리상태 (STATUS) - CHAR(1) [CHECK ('Y', 'N') DEFAULT 'N']
고객 ID (CUSTOMER_ID) - NUMBER [FK - CUSTOMERS(CUSTOMER_ID) ON DELETE
CASCADE]
*/

CREATE TABLE ORDERS(
	ORDER_ID NUMBER PRIMARY KEY,
	ORDER_DATE DATE DEFAULT SYSDATE,
	STATUS CHAR(1) DEFAULT 'N' CHECK(STATUS IN('Y', 'N')) ,
	CUSTOMER_ID NUMBER REFERENCES CUSTOMERS ON DELETE CASCADE
);
 
/*
5. 주문 상세 정보 테이블 (ORDER_DETAILS)
주문 상세 ID (ORDER_DETAIL_ID) - NUMBER [PK]
주문 번호 (ORDER_ID) NUMBER - [FK - ORDERS(ORDER_ID) ON DELETE CASCADE]
상품 코드 (PRODUCT_ID) NUMBER - [FK - PRODUCTS(PRODUCT_ID) ON DELETE SET NULL]
수량 (QUANTITY) NUMBER
가격 (PRICE_PER_UNIT) NUMBER
*/

CREATE TABLE ORDER_DETAILS(
	ORDER_DETAIL_ID NUMBER PRIMARY KEY,
	ORDER_ID NUMBER REFERENCES ORDERS ON DELETE CASCADE,
	PRODUCT_ID NUMBER REFERENCES PRODUCTS ON DELETE SET NULL,
	QUANTITY NUMBER,
	PRICE_PER_UNIT NUMBER
);

-- CATEGORIES 테이블 샘플 데이터
SELECT * FROM CATEGORIES;
SELECT * FROM PRODUCTS;
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;
SELECT * FROM ORDER_DETAILS;

INSERT INTO CATEGORIES VALUES(1, '스마트폰');
INSERT INTO CATEGORIES VALUES(2, 'TV');
INSERT INTO CATEGORIES VALUES(3, 'Gaming');














