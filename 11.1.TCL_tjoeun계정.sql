/*
    < TCL : TRANSACTION CONTROL LANGUAGE >
    트랜잭션 제어언어
    
    * 트랜잭션 
      - 데이터베이스의 논리적 연산단위 
      - 데이터의 변경사항(DML)들을 하나의 트랜잭션에 묶어서 처리
        DML문 한개를 수행 할 때 트랜잭션이 존재하면 해당 트랜잭션에 같이 묶어서 처리
                         트랜잭션이 없다면 트랙잭션을 만들어서 묶어서 처리
    
       COMMIT 하기 전까지의 변경사항을 하나의 트랜잭션에 담게 됨 
    - 트랜잭션의 대상이 되는 SQL : INSERT, UPDATE, DELETE
    
    
    > COMMIT : 트랜잭션 종료 처리 후 확정
                한 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영시키겠다는 의미(그 후에 트랜잭션은 사라짐)
    > ROLLBACK : 트랜잭션 취소
                한 트랜잭션에 담겨있는 변경사항들을 삭제(취소) 한 후 마지막 COMMIT 시점으로
    > SAVEPOINT : 임시저장 
                현재 시점에 해당 포인트명으로 임시저장점을 정의해두는것
                ROLLBACK 진행시 전체 변경사항들을 다 삭제하는게 아니라 일부만 롤백 가능 
       
*/

SELECT * 
FROM ROLE_SYS_PRIVS
WHERE ROLE IN ('RESOURCE','CONNECTION');

SELECT * 
FROM EMP_01;

-- 사번이 301인 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID = 301;

-- 사번이 218인 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID = 218;

ROLLBACK; -- 트랜잭션에 들어있던 301번과 218번의 삭제가 취소됨 (트랜잭션이 사라짐)
-- 삭제한  정보 다시 돌아옴

SELECT * 
FROM EMP_01;

----------------------------------------------------------------------------------------
-- 사번이 200번인 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID = 200;


SELECT * 
FROM EMP_01
ORDER BY EMP_ID;


INSERT INTO EMP_01
VALUES (400,'김자격','총무부');

COMMIT;

ROLLBACK; -- COMMIT 이후에는 롤백해도 아무것도 바뀌지않은모습 

--------------------------------------------------------------
-- 217, 216, 214 사원지움

DELETE FROM EMP_01
WHERE EMP_ID IN (217,216,214);

SAVEPOINT SP;

SELECT * 
FROM EMP_01
ORDER BY EMP_ID;

INSERT INTO EMP_01
VALUES(401,'박세종','인사관리부');

ROLLBACK TO SP; -- SP 전 DELETE는 유지 SP후의 INSERT 는 취소당함 

COMMIT ;


SELECT * 
FROM EMP_01
ORDER BY EMP_ID;

-----------------------------------------------------
/*
    * 자동 COMMIT 되는 경우
        - 정상 종료
        - DCL DDL 명령문이 수행된 경우(이후 자동으로 COMMIT)
        
    * 자동 ROLLBACK 되는 경우
        - 비정상 종료
        - 전원이 꺼짐. EX)정전, 컴퓨터 DOWN 
    
*/
-- 사번이 301, 400 번 삭제
DELETE FROM EMP_01
WHERE EMP_ID IN (301,400);

DELETE FROM EMP_01
WHERE EMP_ID IN (300);

-- DDL 문
CREATE TABLE TEST1 (
    TID NUMBER
); -- 트랜잭션 모든 내용 자동 COMMIT

SELECT * 
FROM EMP_01
ORDER BY EMP_ID;

ROLLBACK; --소용없음
-- 해도 DDL 이후 자동 COMMIT 되어 삭제가 유지됨 

-- ROLLBACK 할때 어디까지 ROLLBACK 할것인지 신중하게 하기  







































