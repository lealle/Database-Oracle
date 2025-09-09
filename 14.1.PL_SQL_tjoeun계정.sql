/*
    <PL/SQL>
    오라클 자체에 내장되어 있는 절차적 언어
    SQL 문장 내에서 변수의 정의, 조건처리(IF), 반복처리(LOOP, FOR, WHILE) 등을 지원하여 SQL의 단점을 보완
    다수의 SQL문을 한번에 실행 가능 (BLOCK 구조)
    
    
    * PL / SQL 구조 
      - [선언부 (DECLARE SECTION)] : DECLARE로 시작, 변수나 상수를 선언 및 초기화하는 부분 
      - 실행부 (EXECUTE SECTION) : BEGIN 으로 시작 SQL문 또는 제어문 (조건문, 반복문) 등의 로직을 기술하는 부분 
      - [예외처리부 (EXCEPTION SECTION)]) : EXCEPTION 으로 시작 예외 발생시 해결하기 위한 구문을 미리 기술해 둘 수 있는 부분
*/
-- ** 화면에 출력하려면 반드시 ON 으로 켜줘야 됨 
SET SERVEROUTPUT ON;

BEGIN 
    -- System.out.println("Hello oracle") - Java
    DBMS_OUTPUT.PUT_LINE('Hello Oralce');
END;
/

/*
    1. DECLARE 선언부
       변수나 상수를 선언하는 공간 (선언과 동시에 초기화도 가능)
       일반타입 변수, 레퍼런스 변수, ROW타입 변수 
       
       1) 일반타입 변수 선언 및 초기화
          [표현식]
          변수명 [CONSTANT] 자료형 [:= 값]
          
          - Java
          int num = 5;
          num == 5;
          
          - DB
          num := 5
          num = 5

*/


DECLARE 
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
    
BEGIN
    EID := 700;
    ENAME := '배정남';
    
    DBMS_OUTPUT.PUT_LINE(EID);
    DBMS_OUTPUT.PUT_LINE('이름 : '|| ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : '|| PI);
    
END;
/






DECLARE 
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
    
BEGIN
    EID := &번호;
    ENAME := '&이름';
    
    DBMS_OUTPUT.PUT_LINE(EID);
    DBMS_OUTPUT.PUT_LINE('이름 : '|| ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : '|| PI);
    
    
END;
/
/*
    2) 레퍼런스 변수 
    어떤 테이블의 어떤 컬럼의 데이터타입을 참조하여 그 타입으로 지정
    
    [표현법]
    변수명 테이블명.컬럼명&TYPE;
    
*/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    
BEGIN
    EID := 400; --CHAR이지만 값이 들어가는 모습 대체취소 라는 단어 출력 (숫자타입으로 변경하여 넣은것) 
--    EID := '400'; --애도 값이 들어가는 모습 
    ENAME := '유하늘';
    SAL := 3000000;
    DBMS_OUTPUT.PUT_LINE('EID : '||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' ||ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL : '||SAL);
    
    
END;
/

/*

*/


DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    
BEGIN
    -- 사번이 200번인 사원의 사번, 사원명, 급여 조회하여각 변수에 대입 
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('EID : '||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' ||ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL : '||SAL);
END;
/

-- 문제
/*
    레퍼런스타입변수로 EID, ENAME,JCODE, SAL, DTITLE를 선언하고 
    각 자료형 EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY) 
    , DEPARTMENT(DEPT_TITLE)을 참조하도록 설정하시오
    
    사용자가 입력 사번의 사번, 사원명, 직급코드, 급여, 부서명 조회한 후 각 변수에 담아 출력 
*/


DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
       
BEGIN
    -- 사용자가 입력한 사번의  사번, 사원명, 급여 조회하여각 변수에 대입 
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID, ENAME, JCODE, SAL, DTITLE
    FROM EMPLOYEE E, DEPARTMENT D
    WHERE EMP_ID = &사번 AND DEPT_ID = DEPT_CODE;

    DBMS_OUTPUT.PUT_LINE('EID : '||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' ||ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE : ' ||JCODE);
    DBMS_OUTPUT.PUT_LINE('SAL : '||SAL);
    DBMS_OUTPUT.PUT_LINE('DTITLE : ' ||DTITLE);

END;
/

/*
    3) ROW 타입 변수 
       테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수

      [표현법]
      변수명 테이블명%ROWTYPE
*/


DECLARE
    E EMPLOYEE%ROWTYPE;
    
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE ('사원명 : '|| E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE ('급여 : '|| E.SALARY);
    DBMS_OUTPUT.PUT_LINE ('보너스 : '|| NVL(E.BONUS,0)); 
    -- NULL 이면 아예 출력안함 빈칸으로 나감 
    -- NVL 시 형식이 안맞으면 오류 발생 숫자면 숫자로 써줘야함
END;
/



DECLARE
    E EMPLOYEE%ROWTYPE;
    
BEGIN
    SELECT *
--    SELECT EMP_NAME, SALARY, BONUS -- 무조건 *을 사용
    INTO E              -- 오류 발생 E가 가지고 있는 열의 수와 달라서
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE ('사원명 : '|| E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE ('급여 : '|| E.SALARY);
    DBMS_OUTPUT.PUT_LINE ('보너스 : '|| NVL(E.BONUS,0)); 
END;
/


--===========================================================================================
/*
    2. BEGIN 실행부
    
        <조건문>
        1) 단일 IF문
           IF 조건식 THEN 실행내용 END IF; 
    
*/
-- 사번을 입력받은 후 해당 사원의 사번, 사원명, 급여, 보너스율(%) 출력 
-- 단 보너스를 받지않는 사원은 보너스율 출력전에 '보너스를 받지않는 사원입니다' 출력 

DECLARE
    E EMPLOYEE%ROWTYPE;
    
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    DBMS_OUTPUT.PUT_LINE ('사원명 : '|| E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE ('사원명 : '|| E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE ('급여 : '|| E.SALARY);
    IF 
        NVL(E.BONUS,0) = 0 THEN DBMS_OUTPUT.PUT_LINE('보너스를 받지않는 사원입니다'); 
    END IF;
    DBMS_OUTPUT.PUT_LINE ('보너스 : '|| NVL(E.BONUS,0)*100 ||'%'); 

END;
/


/*
    2) IF-ELSE 문
    IF 조건식 THEN 실행내용 
    ELSE
        실행내용
    END IF; 

*/


DECLARE
    E EMPLOYEE%ROWTYPE;
    
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    DBMS_OUTPUT.PUT_LINE ('사원명 : '|| E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE ('사원명 : '|| E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE ('급여 : '|| E.SALARY);
    IF 
        NVL(E.BONUS,0) = 0 THEN DBMS_OUTPUT.PUT_LINE('보너스를 받지않는 사원입니다'); 
    ELSE
        DBMS_OUTPUT.PUT_LINE ('보너스 : '|| NVL(E.BONUS,0)*100 ||'%'); 
    END IF;

END;
/

-- 문제
/*
    레퍼런스 변수 : EID, ENAME, DTITLE, NCODE
    참조컬럼 : EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    일반 변수 : TEAM(소속)
    
    실행 : 사용자가 입력한 사번의 사번, 이름, 부서명, 근무국가코드를 변수에 대입
          단) NCODE값이 KO일 경우 => TEAM 변수에'국내팀'
            NCODE값이 KO일 아닐경우 => TEAM 변수에'해외팀'
*/


DECLARE
    TEAM VARCHAR2(20);
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE; 

BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
    WHERE EMP_ID = &사번 AND DEPT_ID = DEPT_CODE AND LOCATION_ID = LOCAL_CODE;

    DBMS_OUTPUT.PUT_LINE('EID : '||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' ||ENAME);
    DBMS_OUTPUT.PUT_LINE('DTITLE : ' ||DTITLE);
    DBMS_OUTPUT.PUT_LINE('NCODE : ' ||NCODE);
    IF NCODE = 'KO' THEN
        TEAM := '국내팀';
    ELSE
        TEAM := '해외팀';
    END IF;    
    DBMS_OUTPUT.PUT_LINE('TEAM : ' ||TEAM);

END;
/

/*
    3) IF-ELSE문
    IF 조건식1 THEN 실행내용1;
    ELSIF 조건식2 THEN 실행내용2;
    ...
    ELSE 실행내용0;
    END IF;

*/
-- 사용자로부터 점수를 입력받아 학점 출력 
-- 변수 2개 필요 (점수 학점)

DECLARE 
    SCORE NUMBER;
    GRADE CHAR(1);
    
BEGIN
    SCORE := &점수;
    
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE :='B';
    ELSIF SCORE >= 70 THEN GRADE :='C';
    ELSIF SCORE >= 60 THEN GRADE :='D';
    ELSE GRADE := 'F';
    END IF;
    
    -- 당신의 점수는 ??점이고 ,학점은 ?학점입니다.
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 '||SCORE||'이고, 학점은 '||GRADE||'입니다');
    
END;
/
    
-- 문제
/*
    사용자에게 입력받은 사번의 급여를 조회하여 SAL변수에 입력하고 
    - 500만원 이상이면 '고급;
    - 500만원 미만 300만원 이상이면 '중급;
    - 300만원 미만이면 '초급;
    
*/

DECLARE
    LEVEL VARCHAR2(10);
    SAL EMPLOYEE.SALARY%TYPE;

BEGIN
    SELECT SALARY
    INTO SAL
    FROM EMPLOYEE E
    WHERE EMP_ID = &사번 ;

    IF SAL >= 5000000 THEN
        LEVEL := '고급';
    ELSIF SAL >= 3000000 AND SAL <5000000 THEN
        LEVEL := '중급';
    ELSIF SAL < 3000000 THEN
        LEVEL := '초급';
    ELSE 
        LEVEL := '잘못된값';

    END IF;    
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 ' ||LEVEL||'입니다');

END;
/

















