/*
    * DDL (Data Definition Language) : 데이터 정의 언어
    오라클에서 제공하는 객체를 만들고 (CREATE)
    구조를 변경하고 (ALTER)
    구조 자체를 삭제(DROP)
    -> 하는 언어 DDL 
    즉 실제 데이터 값이 아닌 구조 자체를 정의하는 언어 
    주로 DB관리자, 설계자가 사용함 

    오라클에서 객체(구조) : 
    테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE), 인덱스(INDEX), 
    패키지(PACKAGE), 트리거(TRIGGER), 프로시져(PROCEDURE), 
    함수(FUNCTION), 동의어(SYNONYM), 사용자(USER)
    
*/
--=============================================================================================
/*
    <CREATE>
    객체를 생성하는 구문

*/
--=============================================================================================
/*
    1. 테이블 생성 
    - 테이블 : 행(ROW), 열(COLUM)로 구성되는 가장 기본적인 데이터베이스 객체
              모든 데이터들은 테이블을 통해 저장됨
              (DBMS 용어 중 하나로, 데이터를 일종의 표 형태로 표현한 것)
              
    (표현식)
    REATE TABLE 테이블명(
    컬럼명 자료형(크기),
    컬럼명 자료형(크기),
    컬럼명 자료형(크기),
    ...
    
    )
    
       * 자료형
       - 문자 (CHAR(바이트크기)|VARCHAR2(바이트크기)) -> 반드시 크기지정 해야됨
        > CHAR : 최대 2000BYTE 까지 지정 가능
                 고정길이(지정한 크기보다 더 작은값이 들어와도 공백으로 채워서 처음지정한 크기만큼 고정)
                 고정된 데이터를 넣을 때 사용
        > VARCHAR : 최대 4000BYTE 까지 지정 가능
                 가변길이(담긴 값에 따라 공간의 크기가 맞춰짐)
                 몇글자가 들어올지 모를 경우 사용
        - 숫자(NUMBER)
        - 날짜(DATE)         
              
*/
-- 회원 정보를 담는 테이블 MEMBER 생성 
CREATE TABLE MEMBER (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PW VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EAMIL VARCHAR2(50),
    MEM_DATE DATE
);

----------------------------------
/*
    2. 컬럼에 주석 달기(설명)

    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용'
    
    >> 잘못 작성하였을 경우 수정후 다시 실행하면 됨(덮어쓰기 가능)
*/

COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PW IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.GENDER IS '성별(남,여)';
COMMENT ON COLUMN MEMBER.PHONE IS '전화번호';
COMMENT ON COLUMN MEMBER.EAMIL IS '이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';

-- 테이블에 데이터를 추가시키는 구문 
-- INSERT INTO 테이블명 VALUES();

INSERT INTO MEMBER VALUES(1,'user1','pass01','김민준','남','010-1234-5678','kim@naver.com','2025.09.04');
-- date / - 다 가능 
INSERT INTO MEMBER VALUES(001,'LEALLE','1234','이정민','남','010-1234-5678','EMAIL','2025.09.04');



INSERT INTO MEMBER VALUES(2,'user2','pass02','이서연','여','010-1234-5678',null,sysdate);
INSERT INTO MEMBER VALUES(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

------------------------------------------------------------------------------------------------------------------
/*
    <제약 조건 CONSTRAINTS>
    - 원하는 데이터값(유효한 형식의 값)만 유지하기 위해  특정 컬럼에 설정하는 제약
    - 데이터에 결함이 없는 상태, 즉 데이터가 정확하고 유효하게 유지된 상태
    1) 개체 무결성 제약 조건 : NOT NULL, UNIQUE, PRIMARY KEY 조건 위배
    2) 참조 무결성 제약 조건 : FOREIGN KEY(외래키) 조건 위배

    * 종류 : NOT NULL, UNIQUE, PRIMARY KEY, CHECK(조건), FOREIGN KEY 
    
    * 제약조건을 부여하는 방식
    1) 컬럼 레벨 방식 : 컬럼명 자료형 옆에 기술 
    2) 테이블 레벨 방식 : 모든 컬럼들을 나열한 수 마지막에 기술 
    PRIMARY KEY - NOT NULL & UNIQUE
*/

/*
    * NOT NULL 제약조건 
    : 해당 컬럼에 반드시 값이 존재 존재해야만 할 경우 
    (즉, 해당 컬럼에 절대 NULL이 들어와서는 안되는 조건)
    
    삽입 / 수정 시  NULL값을 허용하지 않도록 제한 
    
    ** 주의사항 : 오로지 컬럼레벨 방식 밖에 안됨 

*/
-- 컬럼 레벨 방식 
CREATE TABLE MEMBER_NOTNULL(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EAMIL VARCHAR2(50),
    MEM_DATE DATE
);

INSERT INTO MEMBER_NOTNULL VALUES(1,'user1','pass01','임지아','여',null,null, null);
INSERT INTO MEMBER_NOTNULL VALUES(2,'user2',null,'백승민','남',null,'abc@google.com', null);
-- NOT NULL 제약조건 위반으로 오류 발생 

INSERT INTO MEMBER_NOTNULL VALUES(1,'user1','pas02','백승민','남',null,'abc@google.com', null);
-- id 가 중복되어도 잘 추가됨

------------------------------------------------------------------------------------------------------
/*
    *UNIQUE 제약 조건
    해당 컬럼에 중복된 값이 들어가서는 안 되는 경우
    컬럼값에 중복값을 제한하는 제약조건 
    삽입 / 수정 시 기존에 있는 데이터 중 중복값이 있을 경우 오류 발생 

*/
-- 컬럼 레벨 방식 


CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EAMIL VARCHAR2(50)
);

INSERT INTO MEM_UNIQUE VALUES(1,'user01','pass01','임지아','여',null,null);



-- 테이블 레벨 방식 
CREATE TABLE MEM_UNIQUE2(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EAMIL VARCHAR2(50),
    UNIQUE (MEM_ID)
);


CREATE TABLE MEM_UNIQUE3(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EAMIL VARCHAR2(50),
    UNIQUE (MEM_ID),
    UNIQUE (MEM_NO)
);


CREATE TABLE MEM_UNIQUE4(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EAMIL VARCHAR2(50),
    UNIQUE (MEM_ID , MEM_NO)
);
-- 이렇게 넣으면 조합으로 들어감 

-- EX) 1, ID1  - 2, ID1 이거 같지않은거임 잘 추가됨 -> 쌍으로 조합으로 들어가기 때문에 

-- MEM_UNIQUE2 => MEM_ID 에 UNIQUE
-- MEM_UNIQUE3 => MEM_ID, MEM_NO 에 UNIQUE
-- MEM_UNIQUE4 => (MEM_ID, MEM_NO) 쌍에 UNIQUE


-- MEM_UNIQUE2 => MEM_ID 에 UNIQUE
INSERT INTO MEM_UNIQUE2 VALUES(1, 'user01', 'pass01','강하영',null, null, null);
INSERT INTO MEM_UNIQUE2 VALUES(2, 'user01', 'pass02','백승민',null, null, null);
-- 고유한 제약 조건 
-- UNIQUE 제약조건 위배 되므로 INSERT 실패 


-- MEM_UNIQUE3 => MEM_ID, MEM_NO 에 UNIQUE
INSERT INTO MEM_UNIQUE3 VALUES(1, 'user01', 'pass01','강하영',null, null, null);
INSERT INTO MEM_UNIQUE3 VALUES(2, 'user01', 'pass02','백승민',null, null, null);
-- UNIQUE 제약조건 위배 되므로 INSERT 실패 - MEM_ID
INSERT INTO MEM_UNIQUE3 VALUES(1, 'user02', 'pass02','백승민',null, null, null);
-- UNIQUE 제약조건 위배 되므로 INSERT 실패 - MEM_NO 

-- MEM_UNIQUE4 => (MEM_ID, MEM_NO) 쌍에 UNIQUE
INSERT INTO MEM_UNIQUE4 VALUES(1, 'user01', 'pass01','강하영',null, null, null);
INSERT INTO MEM_UNIQUE4 VALUES(2, 'user01', 'pass02','백승민',null, null, null);
-- 둘다 잘 추가된 모습 쌍으로 UNIQUE 이기 때문에 

INSERT INTO MEM_UNIQUE4 VALUES(2, 'user02', 'pass01','이시우',null, null, null);
-- 잘 추가된 모습 
INSERT INTO MEM_UNIQUE4 VALUES(2, 'user02', 'pass01','백강철',null, null, null);
-- 오류

------------------------------------------------------------------------
/*
    * 제약조건 부여시 제약조건명까지 지어주는 방법

    >> 컬럼 레벨 방식
    CREATE TABLE 테이블명( 
        컬럼명 자료형 [CONSTRAINT 제약조건명] 제약조건,
        컬럼명 자료형 ,
        컬럼명 자료형 ,
        ...
    );
    
    
    >> 테이블 레벨 방식
    CREATE TABLE 테이블명( 
        컬럼명 자료형 ,
        컬럼명 자료형 ,
        컬럼명 자료형 ,
        ...
        [CONSTRAINT 제약조건명] 제약조건 (컬럼)
    );
    
    
*/

CREATE TABLE MEM_UNIQUE5(
    MEM_NO NUMBER CONSTRAINT MEMNO_NN NOT NULL,
    MEM_ID VARCHAR2(20) CONSTRAINT MEMID_NN NOT NULL,
    MEM_PW VARCHAR2(20) CONSTRAINT MEMPWD_NN NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEMNAME_NN NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EAMIL VARCHAR2(50),
    CONSTRAINT MEMID_UQ UNIQUE (MEM_ID)
);

INSERT INTO MEM_UNIQUE5 VALUES(1, 'user01', 'pass01','배지민',null, null, null);
INSERT INTO MEM_UNIQUE5 VALUES(2, 'user01', 'pass02','강하영',null, null, null);
-- 고유한 제약 조건(DDL.MEMID_UQ)이 테이블 DDL.MEM_UNIQUE5 열(MEM_ID)에서 위반되었습니다. -> 이름을 잘 지을시 어떤 제약조건을 위반했구나 잘 확인할 수 있음 
INSERT INTO MEM_UNIQUE5 VALUES(3, 'user03', 'pass03','김하윤','ㄴ', null, null);
-- 성별에 ㄴ 들어간 상태 
-- 성별이 남, 여  둘 중 하나만 유효한 데이터로 하고 싶음

----------------------------------------------------------------------------------------------
/*
    * CHECK(조건식) 제약조건 
      해당 컬럼의 들어올 수 있는 값에 대한 조건을 제시해 둘 수 있다.
      해당 조건에 만족하는 데이터값만 입력하도록 할 수 있다.
*/


CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
--    GENDER CHAR(3) CHECK (GENDER IN ('남','여')), 컬럼 레벨 방식 
    PHONE VARCHAR2(13),
    EAMIL VARCHAR2(50),
    UNIQUE (MEM_ID),
    CHECK(GENDER IN ('남','여')) -- 테이블 레벨 방식 
);

INSERT INTO MEM_CHECK VALUES(1, 'user01', 'pass01','배지민','여', null, null);
INSERT INTO MEM_CHECK VALUES(2, 'user02', 'pass02','한유준','ㄴ', null, null);
-- 체크 제약조건 위배 
INSERT INTO MEM_CHECK VALUES(3, 'user03', 'pass03','한유준',NULL, null, null);
-- NULL 값은 NOT NULL 안해서 유효한 값 

------------------------------------------------------------------
/*
    * PRIMARY KEY(기본키) 제약조건
    테이블에서 키 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건(식별자 역할)
    EX) 회원번호, 학번, 사원번호, 주문번호, 예약번호, 운송장번호
    
    -PRIMARY KEY 제약조건을 부여하면 그 컬럼에 자동으로 NOT NULL + UNIQUE 제약조건을 의미
    >> 대체적으로 검색, 삭제, 수정 등에 기본키의 컬럼값을 이용함 
    
    ** 주의사항 : 한 테이블당 오로지 1개만 설정가능
    
*/



CREATE TABLE MEM_PRIKEY(
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY, -- 컬럼 레벨 방식 
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR(20) NOT NULL,
    MEM_NAME VARCHAR(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    PHONE VARCHAR(13),
    EMAIL VARCHAR(50)
    -- PRIMARY KEY(MEM_NO) -- 테이블 레벨 방식  
    -- CONSTRAINT MEMNO_PK PRIMARY KEY (MEM_NO) -- 테이블 레벨 방식 제약조건 이름 부여 
);

INSERT INTO MEM_PRIKEY VALUES(1, 'user01', 'pass01','배지민','여', null, null);
INSERT INTO MEM_PRIKEY VALUES(1, 'user02', 'pass02','한유준','남', null, null); 
-- PRIMARY KEY 위반 - 고유한 제약조건  
INSERT INTO MEM_PRIKEY VALUES(2, 'user02', 'pass02','한유준',NULL, null, null);

--------------------------------------------------------------------------------
/*
    * 복합키
    : 기본키에 2개 이상의 컬럼을 묶어서 사용 
    
    - 복합키의 사용 예(한 회원이 어떤 상품을 찜했는지 데이터를 보관하는 테이블)
      회원번호, 상품
        1.      A
        1.      B
        1.      A(중복 찜은 하나만 해도 됨 굳이 할 필요없음) -- 부적합 
        2.      A
        2.      B
        2.      B -- 부적합 
        이런경우 복합키 사용 
*/  
CREATE TABLE TB_LIKE(
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(10),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO, PRODUCT_NAME)
);

INSERT INTO TB_LIKE VALUES(1,'A',SYSDATE);
INSERT INTO TB_LIKE VALUES(1,'B',SYSDATE);
INSERT INTO TB_LIKE VALUES(1,'A',SYSDATE); -- 복합키 오류
INSERT INTO TB_LIKE VALUES(2,'A',SYSDATE);
INSERT INTO TB_LIKE VALUES(2,'B',SYSDATE);

------------------------------------------------------------------------------------
-- 회원 등급에 대한 데이터를 보관하는 테이블 
CREATE TABLE MEM_GRADE (
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(20) NOT NULL
);

INSERT INTO MEM_GRADE VALUES(10,'일반회원');
INSERT INTO MEM_GRADE VALUES(20,'우수회원');
INSERT INTO MEM_GRADE VALUES(30,'특별회원');

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER -- 회원 등급을 보관할 컬럼
);

INSERT INTO MEM VALUES(1,'user01','pass01','박강남','남',null,10);
INSERT INTO MEM VALUES(2,'user02','pass02','유희영','여',null,null);
INSERT INTO MEM VALUES(3,'user03','pass02','송나들','남',null,50);
-- 유효 회원등급이 아님에서 insert 됨

----------------------------------------------------------------------------------
/*
    * FOREIGN KEY (외래키) 제약조건
    다른 테이블에 존재하는 값만 들어와야되는 특정 컬럼에 부여하는 제약조건 
    --> 다른 테이블을 참조한다는 표현 
    --> 주로 FOREIGN KEY 제약조건에 의해 테이블 간의 관계가 형성됨
    
    >> 컬럼 레벨 방식
    -- 컬럼명 자료형 REFERENCES 참조할테이블명 (참조할컬럼명)
       컬럼명 자료형 [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명 [(참조할컬럼명)] 
    
    >> 테이블 레벨 방식 
    -- FOREIGN KEY (컬럼명) REFERENCES 참조할테이블명 (참조할컬럼명)
       [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명 [(참조할컬럼명)] (컬럼명)
       
       ==> 참조할 컬럴명을 생략시 참조할 테이블의 PRIMARY KEY 로 지정된 컬럼으로 매칭 
    
*/


CREATE TABLE MEM2(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE) -- 컬럼 레벨 방식 PRIMARY 키면 생략 가능 
/*    테이블 레벨 방식 
    GRADE_ID NUMBER,
    FOREIGN KEY (GRADE_ID) 
*/
);
INSERT INTO MEM2 VALUES(1,'user01','pass01','배정남','남',null,NULL);
INSERT INTO MEM2 VALUES(2,'user02','pass02','여정운','여',null,30);
INSERT INTO MEM2 VALUES(3,'user03','pass02','김똥개','남',null,70);
-- MEME_GRADE 부모 테이블 --------------------<- MEM2 자식 테이블 
--> 이때 부모테이블 데이터 값을 삭제할때 문제가 발생 
/*
    - 자식 테이블이 부모의 데이터값을 사용하지 않고 있으면 삭제 가능
    - 자식 테이블이 부모의 데이터값을 사용하고 있을 때 문제 발생 -> 삭제 불가
    
*/

-- MEM_GRADE 테이블에서 30번 삭제 
-- 삭제시 : DELETE FROM 테이블명 WHERE 조건 --> 조건에 맞는 행만 삭제 
-- DELETE FROM 테이블명  --> 테이블 안의 모든 데이터 삭제 
DELETE FROM MEM_GRADE WHERE GRADE_CODE = 10; -- 삭제
DELETE FROM MEM_GRADE WHERE GRADE_CODE = 30; -- 무결성 제약조건 -> 자식 레코드 발견 -> 오류

-- 부모테이블로부터 무조건 삭제가 안되는 삭제 제한 옵션이 걸려있음 

INSERT INTO MEM_GRADE VALUES(10,'일반회원');

--------------------------------------------------------------------------------------
/*
    * 자식테이블 생성시 외래키 제약조건 부여할 때 삭제옵션 지정가능 
    - 삭제 옵션 : 부모테이블의 데이터 삭제 시 그 데이터를 사용하고 있는 자식테이블의 값을 어떻게 처리할 지에 대한 옵션

    > ON DELETE RESTRICTED(기본값) : 삭제제한 옵션. 자식테이블을 사용하고 있으면 부모테이블의 데이터는 삭제 안됨
    > ON DELETE SET NULL : 부모 데이터 삭제시 자식테이블의 값을 NULL로 변경하고 부모테이블 삭제.
    > ON DELECTE CASCADE : 부모 데이터 삭제시 자식테이블의 값(행)도 같이 삭제
    
*/

DROP TABLE MEM;
DROP TABLE MEM2;
DROP TABLE MEM_UNIQUE;
DROP TABLE MEM_UNIQUE5;

CREATE TABLE MEM_GRADE (
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(20) NOT NULL
);

INSERT INTO MEM_GRADE VALUES(10,'일반회원');
INSERT INTO MEM_GRADE VALUES(20,'우수회원');
INSERT INTO MEM_GRADE VALUES(30,'특별회원');


CREATE TABLE MEM2(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE SET NULL-- 컬럼 레벨 방식 PRIMARY 키면 생략 가능 
);
INSERT INTO MEM2 VALUES(1,'user01','pass01','배정남','남',null,10);
INSERT INTO MEM2 VALUES(2,'user02','pass02','여정운','여',null,20);
INSERT INTO MEM2 VALUES(3,'user03','pass03','김똥개','남',null,30);
INSERT INTO MEM2 VALUES(4,'user04','pass04','이똥개','남',null,10);

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
--삭제됨 ->  자식 GRADE _ID 10이었던것 NULL값으로 변경됨 

INSERT INTO MEM_GRADE VALUES(10,'일반회원');


CREATE TABLE MEM3(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE CASCADE-- 컬럼 레벨 방식 PRIMARY 키면 생략 가능 
);


INSERT INTO MEM3 VALUES(1,'user01','pass01','배정남','남',null,10);
INSERT INTO MEM3 VALUES(2,'user02','pass02','여정운','여',null,20);
INSERT INTO MEM3 VALUES(3,'user03','pass03','김똥개','남',null,30);
INSERT INTO MEM3 VALUES(4,'user04','pass04','이똥개','남',null,10);


DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
--삭제됨 ->  자식 GRADE _ID 10이었던것도 삭제

-------------------------------------------------------------------
/*
    <DEFAULT 기본값>
    컬럼을 선정하지 INSERT시 NULL ㅣㅇ아닌 기본값을 INSERT 할 때
    
    컬럼명 자료형 DEFAULT 기본값 [제약조건]
    --> 제약조건보다 앞에 기술 
    

*/



CREATE TABLE MEMBER2(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_NAME VARCHAR2(20) NOT NULL,
    HOBBY VARCHAR2(20) DEFAULT '없음',
    MEM_DATE DATE DEFAULT SYSDATE
);
INSERT INTO MEMBER2 VALUES(1,'나원경','운동','21/11/15');
INSERT INTO MEMBER2 VALUES(2,'나원경',NULL,NULL);
INSERT INTO MEMBER2 VALUES(3,'나원경',DEFAULT,DEFAULT);
INSERT INTO MEMBER2 (MEM_NO, MEM_NAME) VALUES (4,'임차빈');

--=======================TJOEUN 계정===========================================
/*
    <SUBQUERY를 이용한 테이블 생성>
    테이블을 복사하는 개념
    
    CREATE TABLE 테이블명
    AS 서브쿼리;

*/
-- EMPLOYEE 테이블을 복제한 새로운 테이블 생성

CREATE TABLE EMPLOYEE_COPY
AS (
SELECT *
FROM EMPLOYEE
);
-- 컬럼, 데이터 값 등은 복사
-- 제약조건 같은 경우 NOT NULL만 복사됨
-- DEFAULT, COMMNET는 복사 안됨 

-- 데이터는 필요없고, 구조만 복사하고자 할 때
CREATE TABLE EMPLOYEE_COPY2
AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE 1=0; 
-- 다 거짓이라 구조만 복사해옴 

-- 기존 테이블의 구조에 없는 칼럼을 만들때
CREATE TABLE EMPLOTEE_COPY3
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 연봉
FROM EMPLOYEE; 
-- 서브쿼리 SELECT절에 산술식 또는 함수식 기술된 경우 반드시 별칭 지정해야됨 
-- 없는 컬럼은 별칭 넣어줘서 어떤컬럼인지 알려야함

---------------------------------------------------------------------------------------------------------------------------
/*
    * 테이블을 다 생성한 후에 제약조건 추가 
    ALTER TABLE 테이블명 변경한 내용;
    ADD | MODIFY 
    
    - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY (컬럼명);
    - FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY (컬럼명) REFERENCES 참조할테이블명 [(참조할컬럼명)];
    - UNIQUE : ALTER TABLE 테이블명 ADD UNIQUE (컬럼명);
    - CHECK : ALTER TABLE 테이블명 ADD CHECK (컬럼에 대한 조건식);
    - NOT NULL : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;
    - DEFAULT : ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT 값;
*/
-- EMPLOYEE_COPY 테이블에 PRIMARY KEY 추가
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(EMP_NO);
-- EMPLOYEE_COPY 테이블에 DEPT_CODE에 FOREIGN KEY 추가(DEPARTMENT (DEPT_ID))
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY (DEPT_CODE) REFERENCES DEPARTMENT (DEPT_ID);
-- EMPLOYEE_COPY 테이블에 JOB_CODE에 FOREIGN KEY 추가(JOB (JOB_CODE))
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY (JOB_CODE) REFERENCES JOB (JOB_CODE);

-- DEPARTMENT 테이블에 LOCATION_ID에 FOREIGN KEY 추가(LOCATION (LOCAL_CODE)) (LOCATION 테이블)
ALTER TABLE DEPARTMENT ADD FOREIGN KEY (LOCATION_ID) REFERENCES LOCATION (LOCAL_CODE);

-- EMPLOYEE_COPY 테이블에 DEFAULT 값 N 넣기 
ALTER TABLE EMPLOYEE_COPY MODIFY ENT_YN DEFAULT 'N';

-- EMPLOYEE_COPY 테이블에 COMMENT 넣기
COMMENT ON COLUMN EMPLOYEE_COPY.EMP_NO IS '직원주민번호';
COMMENT ON COLUMN EMPLOYEE_COPY.EMP_ID IS '직원번호';
COMMENT ON COLUMN EMPLOYEE_COPY.EMP_NAME IS '직원이름';
-- EMPLOYEE_COPY 테이블에 UNIQUE 추가

-- EMPLOYEE_COPY 테이블에 CHECK 추가


--07.DDL 실습문제
--도서관리 프로그램을 만들기 위한 테이블들 만들기
--이때, 제약조건에 이름을 부여할 것.
--       각 컬럼에 주석달기
--
--1. 출판사들에 대한 데이터를 담기위한 출판사 테이블(TB_PUBLISHER)
--   컬럼  :  PUB_NO(출판사번호) NUMBER -- 기본키(PUBLISHER_PK) 
--	PUB_NAME(출판사명) VARCHAR2(50) -- NOT NULL(PUBLISHER_NN)
--	PHONE(출판사전화번호) VARCHAR2(13) - 제약조건 없음
--
--   - 3개 정도의 샘플 데이터 추가하기
CREATE TABLE TB_PUBLISHER(
    PUB_NO NUMBER CONSTRAINT PUBLISHER_PK PRIMARY KEY,
    PUB_NAME VARCHAR2(50) NOT NULL,
    PHONE VARCHAR2(13)
);
COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사번호';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사명';
COMMENT ON COLUMN TB_PUBLISHER.PHONE IS '출판사전화번호';


INSERT INTO TB_PUBLISHER VALUES(1,'JAVA','010-1234-4567');
INSERT INTO TB_PUBLISHER VALUES(2,'HTML','010-1234-1231');
INSERT INTO TB_PUBLISHER VALUES(3,'DATABASE','010-1234-7890');

--
--
--2. 도서들에 대한 데이터를 담기위한 도서 테이블(TB_BOOK)
--   컬럼  :  BK_NO (도서번호) NUMBER -- 기본키(BOOK_PK)
--	BK_TITLE (도서명) VARCHAR2(50) -- NOT NULL(BOOK_NN_TITLE)
--	BK_AUTHOR(저자명) VARCHAR2(20) -- NOT NULL(BOOK_NN_AUTHOR)
--	BK_PRICE(가격) NUMBER
--	BK_PUB_NO(출판사번호) NUMBER -- 외래키(BOOK_FK) (TB_PUBLISHER 테이블을 참조하도록)
--			         이때 참조하고 있는 부모데이터 삭제 시 자식 데이터도 삭제 되도록 옵션 지정
--   - 5개 정도의 샘플 데이터 추가하기
--

CREATE TABLE TB_BOOK(
    BK_NO NUMBER PRIMARY KEY,
    BK_TITLE VARCHAR2(50) CONSTRAINT BOOK_NN_TITLE NOT NULL,
    BK_AUTHOR VARCHAR2(20) CONSTRAINT BOOK_NN_AUTHOR NOT NULL,
    BK_PRICE NUMBER,
    BK_PUB_NO NUMBER CONSTRAINT BOOK_FK REFERENCES TB_PUBLISHER ON DELETE SET NULL
);
COMMENT ON COLUMN TB_BOOK.BK_NO IS '도서번호';
COMMENT ON COLUMN TB_BOOK.BK_TITLE IS '도서명';
COMMENT ON COLUMN TB_BOOK.BK_AUTHOR IS '저자명';
COMMENT ON COLUMN TB_BOOK.BK_PRICE IS '가격';
COMMENT ON COLUMN TB_BOOK.BK_PUB_NO IS '출판사번호';

INSERT INTO TB_BOOK VALUES(1,'JAVA_SPRING','김스프',20000,1);
INSERT INTO TB_BOOK VALUES(2,'JAVA_SCRIPT','김스크',22000,1);
INSERT INTO TB_BOOK VALUES(3,'REACT','김예지',15000,2);
INSERT INTO TB_BOOK VALUES(4,'ORACLE','이수근',23000,3);
INSERT INTO TB_BOOK VALUES(5,'PROGRESS','전진영',25000,3);

--
--3. 회원에 대한 데이터를 담기위한 회원 테이블 (TB_MEMBER)
--   컬럼명 : MEMBER_NO(회원번호) NUMBER -- 기본키(MEMBER_PK)
--   MEMBER_ID(아이디) VARCHAR2(30) -- 중복금지(MEMBER_UQ)
--   MEMBER_PWD(비밀번호)  VARCHAR2(30) -- NOT NULL(MEMBER_NN_PWD)
--   MEMBER_NAME(회원명) VARCHAR2(20) -- NOT NULL(MEMBER_NN_NAME)
--   GENDER(성별)  CHAR(1)-- 'M' 또는 'F'로 입력되도록 제한(MEMBER_CK_GEN)
--   ADDRESS(주소) VARCHAR2(70)
--   PHONE(연락처) VARCHAR2(13)
--   STATUS(탈퇴여부) CHAR(1) - 기본값으로 'N' 으로 지정, 그리고 'Y' 혹은 'N'으로만 입력되도록 제약조건(MEMBER_CK_STA)
--   ENROLL_DATE(가입일) DATE -- 기본값으로 SYSDATE, NOT NULL 제약조건(MEMBER_NN_EN)
--
--   - 5개 정도의 샘플 데이터 추가하기
CREATE TABLE TB_MEMBER(
    MEMBER_NO NUMBER CONSTRAINT MEMBER_PK PRIMARY KEY,
    MEMBER_ID VARCHAR2(30) CONSTRAINT MEMBER_UQ UNIQUE,
    MEMBER_PWD VARCHAR2(30) CONSTRAINT MEMBER_NN_PWD NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_NN_NAME NOT NULL,
    GENDER CHAR(1)CONSTRAINT MEMBER_CK_GEN CHECK (GENDER IN ('M','F')),
    ADDRESS VARCHAR2(70),
    PHONE VARCHAR2(13),
    STATUS CHAR(1) DEFAULT 'N' CHECK (STATUS IN ('Y','N')) ,
    ENROLL_DATE DATE DEFAULT SYSDATE CONSTRAINT MEMBER_NN_EN NOT NULL 
);
COMMENT ON COLUMN TB_MEMBER.MEMBER_NO IS '회원번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_ID IS '아이디';
COMMENT ON COLUMN TB_MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_NAME IS '회원명';
COMMENT ON COLUMN TB_MEMBER.GENDER IS '성별';
COMMENT ON COLUMN TB_MEMBER.ADDRESS IS '주소';
COMMENT ON COLUMN TB_MEMBER.PHONE IS '연락처';
COMMENT ON COLUMN TB_MEMBER.STATUS IS '탈퇴여부';
COMMENT ON COLUMN TB_MEMBER.ENROLL_DATE IS '가입일';


INSERT INTO TB_MEMBER 
(MEMBER_NO, MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GENDER, ADDRESS, PHONE, STATUS, ENROLL_DATE)
VALUES (1, 'hong123', 'pw1234', '홍길동', 'M', '서울시 강남구', '010-1111-2222', 'Y', SYSDATE);

INSERT INTO TB_MEMBER 
(MEMBER_NO, MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GENDER, ADDRESS, PHONE, STATUS, ENROLL_DATE)
VALUES (2, 'kim456', 'pw4567', '김철수', 'M', '부산시 해운대구', '010-3333-4444', 'N', SYSDATE);

INSERT INTO TB_MEMBER 
(MEMBER_NO, MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GENDER, ADDRESS, PHONE, STATUS, ENROLL_DATE)
VALUES (3, 'lee789', 'pw7890', '이영희', 'F', '대구시 달서구', '010-5555-6666', 'Y', SYSDATE);

INSERT INTO TB_MEMBER 
(MEMBER_NO, MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GENDER, ADDRESS, PHONE, STATUS, ENROLL_DATE)
VALUES (4, 'park111', 'pw1111', '박민수', 'M', '인천시 연수구', '010-7777-8888', 'N', SYSDATE);

INSERT INTO TB_MEMBER 
(MEMBER_NO, MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GENDER, ADDRESS, PHONE, STATUS, ENROLL_DATE)
VALUES (5, 'choi222', 'pw2222', '최수정', 'F', '광주시 북구', '010-9999-0000', 'Y', SYSDATE);


--
--4. 어떤 회원이 어떤 도서를 대여했는지에 대한 대여목록 테이블(TB_RENT)
--   컬럼  :  RENT_NO(대여번호) NUMBER -- 기본키(RENT_PK)
--	RENT_MEM_NO(대여회원번호) NUMBER -- 외래키(RENT_FK_MEM) TB_MEMBER와 참조하도록
--			이때 부모 데이터 삭제시 자식 데이터 값이 NULL이 되도록 옵션 설정
--	RENT_BOOK_NO(대여도서번호) NUMBER -- 외래키(RENT_FK_BOOK) TB_BOOK와 참조하도록
--			이때 부모 데이터 삭제시 자식 데이터 값이 NULL값이 되도록 옵션 설정
--	RENT_DATE(대여일) DATE -- 기본값 SYSDATE
--
--   - 3개 정도 샘플데이터 추가하기


CREATE TABLE TB_RENT(
    RENT_NO NUMBER CONSTRAINT RENT_PK PRIMARY KEY,
    RENT_MEM_NO NUMBER CONSTRAINT RENT_FK_MEM REFERENCES TB_MEMBER ON DELETE SET NULL,
    RENT_BOOK_NO NUMBER CONSTRAINT RENT_FK_BOOK REFERENCES TB_BOOK ON DELETE SET NULL UNIQUE,
    RENT_DATE DATE DEFAULT SYSDATE
);
-- 책은 여러개 빌려줄수 없기에 UNIQUE 들어가는것이 맞을거같음 
COMMENT ON COLUMN TB_RENT.RENT_NO IS '대여번호';
COMMENT ON COLUMN TB_RENT.RENT_MEM_NO IS '대여회원번호';
COMMENT ON COLUMN TB_RENT.RENT_BOOK_NO IS '대여도서번호';
COMMENT ON COLUMN TB_RENT.RENT_DATE IS '대여일';

INSERT INTO TB_RENT VALUES(1,1 , 1, DEFAULT);
INSERT INTO TB_RENT VALUES(2,1 , 2, DEFAULT);
INSERT INTO TB_RENT VALUES(3,3 , 3, DEFAULT);







