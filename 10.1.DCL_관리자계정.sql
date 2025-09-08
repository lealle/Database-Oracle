/*
    <DCL : DATE CONTROL LANGUAGE>
    데이터 제어 언어
    * 계정에 시스템 권환 또는 객체 접근 권화등을 부여(GRANT)하거나 회수(REVOKE)하는 구문
    > 시스템 권환 : DB에 접근하는 권환 , 객체를 생성할 수 있는 권환 
    > 객체 접근 권환 : 특정 객체를 조작할 수 있는 권환 
    
    
    * 시스템 권환의 종류
    - CREATE SESSION : 접속할 수 있는 권환
    - CREATE TABLE: 테이블 생성 할 수 있는 권환
    - CREATE VIEW : 뷰를 생성할 수 있는 권환
    - CREATE SEQUENCE : 시퀀스를 생성할 수 있는 권환
    ... 
*/
-- 1. SAMPLE 사용자 계정 생성 
ALTER SESSION SET "_oracle_script" = true;
CREATE USER SAMPLE IDENTIFIED BY 1234;
-- 접속시 오류 접속권환 없음 

-- 2. 접속권환 부여 
GRANT CREATE SESSION TO SAMPLE;

-- 3. 테이블을 생성할 수 있는 권환 
GRANT CREATE TABLE TO SAMPLE;

-- 4. TABLESPACE 할당
ALTER USER SAMPLE QUOTA UNLIMITED ON USERS; -- 제한없이 

ALTER USER SAMPLE QUOTA 5M ON USERS; 

---------------------------------------------------------------------------
/*
    * 객체 접근 권환 종류
    특정 객체에 접근해 조작할 수 있는 권환
    
    
    권환 종류 
    SELECT      TABLE, VIEW, SEQUENCE
    INSERT      TABLE, VIEW
    UPDATE      TABLE, VIEW
    DELETE      TABLE, VIEW
    ...
    
    [표현식]
    GRANT 권환종류 ON 특정객체 TO 계정명;
    
    - GRANT 권환종류 ON 권환을 가지고 있는 USER.특정객체 TO 권환을 줄 USER;
    
    
    
*/
-- SAMPLE 계정에게 TJOEUN 계정의 EMPLOYEE을 SELECT 할 수 있는 권환 
GRANT SELECT ON TJOEUN.EMPLOYEE TO SAMPLE;


-- SAMPLE 계정에게 TJOEUN 계정의 DEPARTMENT에 INSERT 할 수 있는 권환 
GRANT INSERT ON TJOEUN.DEPARTMENT TO SAMPLE;

GRANT SELECT ON TJOEUN.DEPARTMENT TO SAMPLE;


--------------------------------------------------------------------------
/*
    * 권환 회수
    REVOKE 회수할권환 ON FROM 계정명 
*/
REVOKE SELECT ON TJOEUN.EMPLOYEE FROM SAMPLE;

REVOKE SELECT ON TJOEUN.DEPARTMENT FROM SAMPLE;
REVOKE INSERT ON TJOEUN.DEPARTMENT FROM SAMPLE;

--=========================================================================
/*
    <ROLE>
    특정 권환들을 하나의 집합으로 모아놓은것 
    
    CONNECT : CREATE, SESSION
    RESOURCE : CREATE TABLE, CREATE VIEW, CREATE SEQUENCE ....
    DBA : 시스템및 객체 관리에 대한 모든 권환을 갖고있는 롤 
    
    - 23ai 버전 에서 신규의 롤 추가
    DB_DEVELOPER_ROLE : CONNECT + RESOURCE + 기타 개발 관련 권환까지 포함 
    
    [표현식]
    GRANT CONNECT, RESOURCE TO 계정명;
    GRANT DB_DEVELOPER_ROLE TO 계정명; -- TABLE SPACE 포함 
    
*/
CREATE USER TEST1 IDENTIFIED BY 1234;
GRANT DB_DEVELOPER_ROLE TO TEST1;
ALTER USER TEST1 QUOTA UNLIMITED ON USERS; -- 제한없이 

-- 테이블 ROLE_SYS_PRIVS 에 ROLE 이 정의되어 있음
SELECT * FROM ROLE_SYS_PRIVS;

SELECT *
FROM ROLE_SYS_PRIVS
WHERE ROLE IN ('CONNECT','RESOURCE')
ORDER BY 1;

SELECT *
FROM ROLE_SYS_PRIVS
WHERE PRIVILEGE LIKE '%CONNECT%' OR PRIVILEGE LIKE '%RESOURCE%'
ORDER BY 1;


SELECT *
FROM ROLE_SYS_PRIVS
WHERE ROLE LIKE '%CONNECT%'
ORDER BY 1;

DROP USER TEST1 CASCADE;
