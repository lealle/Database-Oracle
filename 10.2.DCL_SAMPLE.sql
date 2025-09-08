CREATE TABLE TEST(
    test_id number,
    test_name varchar2(20)
);
-- 테이블 만들 수 있는 권환이 없어서 생성안됨 
-- 권환을 받으면 생성 가능 

INSERT INTO TEST VALUES(1,'이하늘');
-- 용자 SAMPLE에게는 USERS 테이블스페이스에 대한 할당량이 부족합니다.
-- SAMPLE 계정 테이블은 생성되지만 INSERT는 안됨 위의 권환이 없기 때문에 


SELECT * 
FROM TJOEUN.EMPLOYEE;
-- 권환 부여전 권환이 없어 접근 불가 


INSERT INTO TJOEUN.DEPARTMENT 
VALUES ('D0', '회계부','L2');
COMMIT;
-- COMMIT 해야 보임 

SELECT * 
FROM TJOEUN.DEPARTMENT;






