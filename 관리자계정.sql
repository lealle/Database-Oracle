--// 한줄 주석 ctrl + /
/*
    여러줄 주석 alt + shift + c 
*/

--  실행 단축키 : 한줄 실행(; 있는데까지) -> 커서 그 줄에 놓고 ctrl + enter 
--              여러행 실행 -> 실행하고 싶은 줄을 블럭으로 잡고 ctrl + enter 
--              혹은 위에 있는 시작 버튼 실행 


-- 사용자 계정 조회
--select * from dba_users;
 
-- 사용자 생성  (관리자 계정에서만 생성가능)
-- 계정명 대소문자를 가리지 않음 
-- create user 계정명 identified by 비밀번호; 
--create user user1 identified by '1234';
create user c##user1 identified by 1234; // 오라클 12 버전부터 일반사용자는 c## 으로 시작하는 이름을 가져야 함 
 // ''은 오류 그냥 숫자나 "" 로 감싸주어야함 

-- c## 을 회피하는 방법 
-- 
alter SESSION set "_oracle_script" = true;
create user user1 identified by 1234; 
create user tjoeun identified by 1234; 

-- 권한생성 
-- [표현법] - grant 권한1, 권한2, ... to 계정명
-- 
grant CONNECT, RESOURCE TO tjoeun;
grant CREATE SESSION to tjoeun;
-- 용량에 제한없이 테이블스테이스 할당하는 경우
alter user tjoeun default TABLESPACE users quota UNLIMITED ON users;

-- 특정 용량만큼 테이블스테이스 할당하는 경우
--alter user tjoeun default TABLESPACE users quota 30M ON users;

-- 일반적으로 사용자를 생성하려면 
/*
alter SESSION set "_oracle_script" = true;
create user tjoeun identified by 1234; 
grant CONNECT, RESOURCE TO tjoeun;
alter user tjoeun default TABLESPACE users quota UNLIMITED ON users;
*/





-- 로그인 권한
GRANT CREATE SESSION TO tjoeun;

-- 객체 생성 권한
GRANT CREATE TABLE TO tjoeun;
GRANT CREATE VIEW TO tjoeun;
GRANT CREATE SEQUENCE TO tjoeun;
GRANT CREATE PROCEDURE TO tjoeun;

-- 테이블스페이스 할당
ALTER USER tjoeun DEFAULT TABLESPACE users;
ALTER USER tjoeun TEMPORARY TABLESPACE temp;
ALTER USER tjoeun QUOTA UNLIMITED ON users;




