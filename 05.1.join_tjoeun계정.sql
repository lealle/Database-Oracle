/*
    <JOIN>
    2개 이상의 테이블에서 데이터를 조회하고자 할 때 사용
    조회결과는 하나의 결과물(RESULT SET)로 나옴
    
    관계형데이터베이스는 최소한의 데이터로 각각 테이블에 담고 있음 
    (중복을 최소화하기 위해 최대한 나누어서 관리)

    => 관계형 데이터베이스에서 SQL 문을 이용한테이블간의 "관계"를 맺는 방법

    JOIN은 크게 "오라클전용구문"과 "ANSI구문" (ANSI == 미국국립표준협회)
    
    ------------------------------------------------------------------------------
                             [JOIN 용어 정리]
    ------------------------------------------------------------------------------
         오라클 전용 구문             |             ANSI 구문     
    ------------------------------------------------------------------------------
            등가조인                 |               내부조인
          (EQUAL JOIN)              |    (INNER JOIN) => JOIN USING/ON       
                                    |              자연조인
                                    |    (NATURAL JOIN) => JOIN USING 
    ------------------------------------------------------------------------------
            포괄조인                 |             왼쪽 외부 조인
            (LEFT OUTER)            |         (LEFT OUTER JOIN)
            (RIGHT OUTER)           |             오른쪽 외부 조인
                                    |         (RIGHT OUTER JOIN) 
                                    |             전체 외부 조인
                                    |         (FULL OUTER JOIN)
    ------------------------------------------------------------------------------
            자체조인                 |               
          (SELF JOIN)               |                JOIN ON       
            비등가조인               |              
        (NON EQUAL JOIN)            |              
    ------------------------------------------------------------------------------
            카테시안 곱              |                교차 조인
        (CARTESIAN PRODUCT)         |            (CROSS JOIN)
    ------------------------------------------------------------------------------
    
    카테시안 곱 빼고는 다 배울 예정 
    
*/

-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회하고자 할때 
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;


SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

SELECT JOB_CODE, JOB_NAME
FROM JOB;

-----------------------------------------------------------------------------------
/*
    1. 등가조인(EQUAL JOIN) / 내부조인(INNER JOIN)
    연결시키는 컬럼의 값이 "일치하는 행들만" 조인되며 조회(일치하는 값이 없는 행은 조회에서 제외)
    
*/

/*
    오라클 전용 구문
    FROM 절에 조회하고자 하는 테이블들을 나열 (, 구문자로)
    WHERE 절에 매칭시킬 컬럼 (연결고리)에 대한 조건을 제시 

*/

--     1) 연결할 두 컬럼명이 다른 경우 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT;
-- 행당 23개씩 207개 나옴 
-- 다 매칭시켜서 나옴 

-- JOIN시 반드시 WHERE 절에 매칭되는 컬럼명을 써준다
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
-- DEPT_CODE NULL 인거는 제외 총 23명중 21명 출력 
-- 조건에 맞지않은 값은 나오지 않음 NULL값 조건에 없기에 출력 X 

--     2) 연결할 두 컬럼명이 같은 경우 
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE JOB_CODE = JOB_CODE;
-- 모호하게 지정된 열

-- 해결방법 1) 테이블명을 이용하는 방법 
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 해결방법 2) 테이블명을 별칭을 부여하여 이용하는 방법 
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;
-- 오라클에서만 사용 

/*
    >> ANSI 구문 
    FROM 절에 기준이 되는 테이블을 하나 기술
    JOIN 절에 같이 조회하고자하는 테이블 기술 + 매칭시킬 컬럼에 대한 조건도 기술
        > JOIN USING, JOIN ON 사용 
*/
--     1) 연결할 두 컬럼명이 다른 경우 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE;



--     2) 연결할 두 컬럼명이 같은 경우 
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB ON JOB_CODE = JOB_CODE; -- 오류 
-- 모호하게 지정된 열 (누굴 지정하는지 모름)

-- 해결방법1) 테이블명 또는 별칭을 이용하는 방법 
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE); -- 오류 

-- 해결방법2) USING 사용 구문을 사용하는 방법 (두 컬럼명이 일치할 때만 사용 가능)
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);
-- () 안쳐주면 오류 () 쳐줘야함 

-- [참고 사항]
-- NATURAL JOIN : 공통된 컬럼을 자동으로 매칭시켜줌
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE 
NATURAL JOIN JOB; 
-- NATURAL 조인을 사용한 경우는 별로없 보통 USING ON 사용 

/*
---- 공통된 컬럼이 없을때는 WHERE 절 없을때 처럼 나온다 
--SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
--FROM EMPLOYEE
--NATURAL JOIN DEPARTMENT;
*/

-- 3) 추가적인 조건도 제시 가능 
-- 직급이 대리인 사원의 사번, 이름, 직급명, 급여를 조회
-- 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND JOB_NAME = '대리';

-- ANSI 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E 
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리';

------------------------------------------  실습 문제  -------------------------------------------
-- 1. 부서가 인사관리부인 사원들의 사번, 이름,  부서명, 보너스 조회
--  >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, BONUS
FROM EMPLOYEE E, DEPARTMENT D
WHERE DEPT_CODE = DEPT_ID AND DEPT_TITLE ='인사관리부';


--  >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, BONUS
FROM EMPLOYEE E
JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE ='인사관리부';

-- 2. DEPARTMENT과 LOCATION을 참고하여 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회
--  >> 오라클 전용 구문
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM LOCATION L, DEPARTMENT D
WHERE LOCAL_CODE = LOCATION_ID;


--  >> ANSI 구문
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM LOCATION L
JOIN DEPARTMENT D ON LOCAL_CODE = LOCATION_ID;

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
--  >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, BONUS
FROM EMPLOYEE E, DEPARTMENT D
WHERE DEPT_CODE = DEPT_ID AND BONUS IS NOT NULL;


--  >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, BONUS
FROM EMPLOYEE E
JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID
WHERE BONUS IS NOT NULL;

-- 4. 부서가 총무부가 아닌 사원들의 사원명, 급여, 부서명 조회
--  >> 오라클 전용 구문
SELECT EMP_NAME 사원명,SALARY 급여, DEPT_TITLE 부서명
FROM EMPLOYEE E, DEPARTMENT D
WHERE DEPT_CODE = DEPT_ID AND DEPT_TITLE != '총무부';


--  >> ANSI 구문
SELECT EMP_NAME 사원명, SALARY 급여, DEPT_TITLE 부서명
FROM EMPLOYEE E
JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE != '총무부';

--------------------------------------------------------------------------------------
/*
    2. 포괄조인 / 외부조인(OUTER JOIN)
      두 테이블간의 JOIN 시 일치하지 않는 행도 포함시켜서 조회
      단 반드시 LEFT / RIGHT 를 지정해야됨(기준 테이블 지정)
*/
-- 사원명, 부서명, 급여, 연봉
SELECT EMP_NAME, DEPT_TITLE, SALARY, 12*(1+NVL(BONUS,0))*SALARY 연봉
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- 부서배치가 안된 사원 2명에 대한 정보는 안나옴 
-- 부서에 배정된 사원이 없는 부서도 조회가 안됨 

-- 1) LEFT [OUTER] JOIN : 두 테이블 중 왼편에 기술된 테이블을 기준으로 JOIN
-- >> ANSI 구문 
SELECT EMP_NAME, DEPT_TITLE, SALARY, 12*(1+NVL(BONUS,0))*SALARY 연봉
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- 23명 호출 EMPLOYEE 기준 

-- >> 오라클 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, 12*(1+NVL(BONUS,0))*SALARY 연봉
FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE = DEPT_ID(+);
-- 기준으로 삼고자하는 테이블의 반대편 테이블에 컬럼 뒤에 (+) 를 붙임 

-- 2) RIGHT [OUTER] JOIN : 두 테이블 중 오른편에 기술된 테이블을 기준으로 JOIN
-- >> ANSI 구문 
SELECT EMP_NAME, DEPT_TITLE, SALARY, 12*(1+NVL(BONUS,0))*SALARY 연봉
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- 24 호출 3개의 부서원이 없는 부서 호출됨 

-- >> 오라클 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, 12*(1+NVL(BONUS,0))*SALARY 연봉
FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE(+) = DEPT_ID;
-- 기준으로 삼고자하는 테이블의 반대편 테이블에 컬럼 뒤에 (+) 를 붙임 

-- 2) FULL [OUTER] JOIN : 두 테이블이 가진 모든 행 조회(오라클 구문으로는 안됨)
-- >> ANSI 구문 

SELECT EMP_NAME, DEPT_TITLE, SALARY, 12*(1+NVL(BONUS,0))*SALARY 연봉
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- 총 26 부서없는직원2명  3개의 부서원이 없는 부서 호출됨 
-- 오라클로는 할 수 없음! 

-------------------------------------------------------------------------------------------
/*
    3. 비등기 조언(NON EQUAL JOIN)
       매칭시킬 컬럼에 대한 조건 작성시 '=' (등호)를 사용하지 않는 JOIN문
       ANSI 구문으로는 JOIN ON으로만 가능 
*/
-- >> 오라클 전용 구문 
-- 사원명, 급여, 급여레벨 조회
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE
--WHERE SALARY >=MIN_SAL AND SALARY <= MAX_SAL;
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- >> ANSI 구문 
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE 
JOIN SAL_GRADE ON SALARY
--WHERE SALARY >=MIN_SAL AND SALARY <= MAX_SAL;
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;


SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE 
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);
-- 단축시키면

---------------------------------------------------------------------------------------
/*
    4. 자체조인(SELF JOIN)
      같은 테이블을 다시 한번 조인하는 경우 
      
*/
-- 전체사원의 사번, 사원명, 부서코드 
--              사수사번,사수명,사수의부서코드
-- >> 오라클 전용구문
-- 사수가 있는 사원만 조회
-- 다 어디에 있는 컬럼인지 별칭을 이용하여 지정 
SELECT E1.EMP_ID, E1.EMP_NAME, E1.DEPT_CODE, E2.EMP_ID, E2.EMP_NAME, E2.DEPT_CODE 
FROM EMPLOYEE E1, EMPLOYEE E2
WHERE E1.MANAGER_ID IS NOT NULL AND 
E2.EMP_ID = E1.MANAGER_ID;

-- 사수가 있는 사원만 조회 (NULL 포함)
SELECT E1.EMP_ID, E1.EMP_NAME, E1.DEPT_CODE, E2.EMP_ID, E2.EMP_NAME, E2.DEPT_CODE 
FROM EMPLOYEE E1, EMPLOYEE E2
WHERE  E1.MANAGER_ID = E2.EMP_ID(+);

-- >> ANSI 구문

-- 사수가 있는 사원만 조회 (NULL 포함)
SELECT E1.EMP_ID, E1.EMP_NAME, E1.DEPT_CODE, E2.EMP_ID, E2.EMP_NAME, E2.DEPT_CODE 
FROM EMPLOYEE E1
LEFT JOIN EMPLOYEE E2 ON (E1.MANAGER_ID = E2.EMP_ID);

--------------------------------------------------------------------------------------
/*
    <다중 JOIN>
    2개 이상의 테이블을 가지고 JOIN할 때 
*/
-- 전사원의 사번, 사원명, 부서명, 직급명 조회
-- >> 오라클 전형
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE DEPT_CODE = DEPT_ID(+) AND E.JOB_CODE = J.JOB_CODE(+);
-- 전사원이기에 (+) 추가 (+) 없으시 해당컬럼이 NULL일시 제외

-- >> ANSI 전형
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID
LEFT JOIN JOB J USING (JOB_CODE);

-- 사원들의 사원명, 부서명, 지역명 조회 - 부서명은 널제외
-- >> 오라클 전형
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE DEPT_CODE = DEPT_ID AND LOCATION_ID= LOCAL_CODE(+);

-- >> ANSI 전형
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID
LEFT JOIN LOCATION L ON LOCATION_ID= LOCAL_CODE;


------------------------------------------  실습 문제  -------------------------------------------
-- 1. 사번, 사원명, 부서명, 지역명, 국가명 조회(EMPLOYEE, DEPARTMENT, LOCATION, NATIONAL 조인)
--  >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE DEPT_CODE = DEPT_ID(+) AND LOCATION_ID= LOCAL_CODE(+) AND L.NATIONAL_CODE = N.NATIONAL_CODE(+);

--  >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID
LEFT JOIN LOCATION L ON LOCATION_ID= LOCAL_CODE
LEFT JOIN NATIONAL N USING (NATIONAL_CODE);

-- 2. 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회 (모든 테이블 다 조인)
--  >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, JOB J, SAL_GRADE SG
WHERE DEPT_CODE = DEPT_ID(+) AND LOCATION_ID= LOCAL_CODE(+) AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
AND E.JOB_CODE = J.JOB_CODE
AND SALARY BETWEEN MIN_SAL AND MAX_SAL;

--  >> ANSI 구문

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
FROM EMPLOYEE E 
LEFT JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID
LEFT JOIN LOCATION L ON LOCATION_ID= LOCAL_CODE
LEFT JOIN NATIONAL N USING (NATIONAL_CODE)
LEFT JOIN JOB J USING (JOB_CODE)
LEFT JOIN SAL_GRADE SG ON SALARY BETWEEN MIN_SAL AND MAX_SAL;








