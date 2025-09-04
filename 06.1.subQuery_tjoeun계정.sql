/*
    <서브쿼리(SUBQUERY)>
    - 하나의 SQL 문 안에 포함된 또다른 SELECT문 
    - 메인 SQL문을 보조하기위한 쿼리문 
*/
-- 간단한 서브쿼리 예1
-- 박정보 사원과 같은 부서에 속한 사원들 조회
--1) 부서정보 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

--2) 박정보의 부서 조회
    SELECT DEPT_CODE
    FROM EMPLOYEE 
    WHERE EMP_NAME = '박정보';

-- 2->1 순서로 
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (    
    SELECT DEPT_CODE
    FROM EMPLOYEE 
    WHERE EMP_NAME = '박정보'
);

-- 간단한 서브쿼리 예2
-- 전 직원의 평균급여보다 더 많은 급여를 받는 사원들의 사번 사원명 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= (    
    SELECT AVG(SALARY)
    FROM EMPLOYEE 
);

----------------------------------------------
/*
    * 서브쿼리의 구분
      서브쿼리를 수행한 결고값이 몇행 몇열이냐에 따라 구분
      
      - 단일행 서브쿼리 : 서브쿼리를 수행한 결과 값이 오로지 1개일때 (1행 1열)
      - 다중행 서브쿼리 : 서브쿼리를 수행한 결과 값이 여러행일때 (N행 1열)
      - 다중열 서브쿼리 : 서브쿼리를 수행한 결과 값이 여러열일때 (1행 N열)
      - 다중행 다중열 서브쿼리 : 서브쿼리를 수행한 결과 값 (N행 M열)

      >> 서브쿼리의 종류가 무엇이냐에 따라 서브쿼리 앞에 붙는 연산자가 달라짐 
*/

/*
    1. 단일행 서브쿼리(SINGLE ROW QUERY)
    - 서브쿼리를 수행한 결과 값이 오로지 1개일때 (1행 1열)
      일반 비교 연산자 사용가능
      =, !=, >, < ...
*/
-- 1) 전직원의 평균급여보다 급여를 더 적게 받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (    
    SELECT AVG(SALARY)
    FROM EMPLOYEE 
);

--2) 최저급여를 받는 사원의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY = (    
    SELECT MIN(SALARY)
    FROM EMPLOYEE 
);

-- 3) 박정보 사원의 급여보다 더 많이 받는 사원들의 사번, 사원명, 부서코드 ,급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (    
    SELECT SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME ='박정보'
);

-- 4) 3) 번 JOIN절 일때 경우
-- JOIN 구문도 똑같이!

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE E1, DEPARTMENT
WHERE SALARY > (    
    SELECT SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME ='박정보'
)AND DEPT_CODE = DEPT_ID;

-- >> ANSI 구문

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE E1
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE SALARY > (    
    SELECT SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME ='박정보'
);

--5) 왕정보사원과 같은 부서원들의 사번, 사원명, 전화번호, 입사일, 부서명 조회 (단 왕정보는 제외)
-- 오라클
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE E1, DEPARTMENT
WHERE DEPT_CODE = (    
    SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME ='왕정보'
)AND DEPT_CODE = DEPT_ID AND EMP_NAME != '왕정보';

-- >> ANSI 구문

SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE E1
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_CODE = (    
    SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME ='왕정보'
) AND EMP_NAME != '왕정보';

-- GROUP BY
-- 6) 부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE E1
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (    
    SELECT MAX(SUM (SALARY))
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
) ;

----------------------------------------------------------------------------------
/*
    2. 다중핼 서브쿼리 (MULTI ROW SUBQUERY)
    서브쿼리를 수행한 결과 값이 여러행일때 (N행 1열)
    
    - IN 서브 쿼리 : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면 
    - > ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 클 경우
                    (여러개의 결과값 중에서 가장 작은값보다 클 경우)
    - < ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 작을 경우
                    (여러개의 결과값 중에서 가장 큰값보다 작을 경우)
    - > ALL : 서브쿼리의 값들중 가장 큰값보다 더 큰값을 얻어올 때
                    
    * 비교대상 > ANY (값1, 값2, ....)
      비교대상 > 값1 OR 비교대상 > 값2 ....
*/

-- 1) 조정연 또는 전지연 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE E1
WHERE JOB_CODE IN (    
    SELECT JOB_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME ='조정연' OR EMP_NAME ='전지연' -- IN으로 해도 됨
);

-- 2) 대리D6 직급임에도 과장D5직급의 급여들 중 최소 급여보다 많이 받는 사원의 사번, 사원명, 직급, 급여

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE E
WHERE SALARY > ANY  (    
    SELECT SALARY
    FROM EMPLOYEE E1
    WHERE JOB_CODE= 'J6'
)AND JOB_CODE= 'J5';

SELECT *
FROM EMPLOYEE E1
WHERE JOB_CODE= 'J6';


-- 3) 차장J4 직급임에도 과장J5직급의 급여보다 적게 받는 사원의 사번, 사원명, 직급, 급여

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE E
WHERE SALARY < ANY  (    
    SELECT SALARY
    FROM EMPLOYEE E1
    WHERE JOB_CODE= 'J5'
)AND JOB_CODE= 'J4';

-- 4) 과장 직급임에도 차장직급의 사원들의 모든 급여보다 더 많이 받는 사원들의 사번, 사원명, 직급, 급여 조회
-- ALL : 서브쿼리의 값들중 가장 큰값보다 더 큰값을 얻어올 때
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE E
WHERE SALARY > ALL (    
    SELECT SALARY
    FROM EMPLOYEE E1
    WHERE JOB_CODE= 'J4'
)AND JOB_CODE= 'J3';

---------------------------------------------------------------------------
/*
    3. 다중열 서브쿼리
       서브쿼리를 수행한 결과값이 여러열일 때(1행 여러열)
*/
--1) 장정보 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사원명, 부서코드, 직급코드, 입사일 조회
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE E
WHERE (DEPT_CODE, JOB_CODE) = (    
    SELECT DEPT_CODE, JOB_CODE
    FROM EMPLOYEE E1
    WHERE EMP_NAME = '장정보'
);

--2) 지정보 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사원명, 부서코드, 직급코드, 입사일 조회
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE, MANAGER_ID
FROM EMPLOYEE E
WHERE (MANAGER_ID, JOB_CODE) = (    
    SELECT MANAGER_ID, JOB_CODE
    FROM EMPLOYEE E1
    WHERE EMP_NAME = '지정보')
    ;
---------------------------------------------------------------------------------------
/*
    4. 다중행 다중열 서브쿼리
    - 서브쿼리를 수행한 결과 값 (N행 M열)

*/
-- 1. 각 직급별 최소급여 금액을 받는 사원의 사번, 사원명 ,직급코드, 급여조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE E
WHERE (JOB_CODE, SALARY) IN (    
    SELECT JOB_CODE, MIN(SALARY)
    FROM EMPLOYEE E1
    GROUP BY JOB_CODE
);

SELECT JOB_CODE, MIN(SALARY)
    FROM EMPLOYEE E1
    GROUP BY JOB_CODE;


-- 2. 각 부서별 최고급여 금액을 받는 사원의 사번, 사원명 ,직급코드, 급여조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE E
WHERE (DEPT_CODE, SALARY) IN (    
    SELECT DEPT_CODE, MAX(SALARY)
    FROM EMPLOYEE E1
    GROUP BY DEPT_CODE
);


----------------------------------------------------------------------------------
/*
    5. 인라인 뷰 (INLINE VIEW)
    FROM절에 서브쿼리를 작성
    
    서브쿼리를 수행할 결과를 마치 테이블처럼 사용
*/
-- 사원들의 사번, 사원명, 보너스를 포함한 연봉(별칭부여), 부서코드 조회
SELECT EMP_ID, EMP_NAME, (1+NVL(BONUS,0))*SALARY*12 "연봉(보너스 포함)",DEPT_CODE
FROM EMPLOYEE E
WHERE (1+NVL(BONUS,0))*SALARY*12  >= 40000000;

-- WHERE 절에 별칭으로 사용하고 싶으면 INLINE VIEW 사용 
SELECT * 
FROM (
    SELECT EMP_ID, EMP_NAME, (1+NVL(BONUS,0))*SALARY*12 "연봉",DEPT_CODE
    FROM EMPLOYEE E 
) -- 테이블처럼 사용 
WHERE 연봉 >= 40000000;


SELECT EMP_NAME, 연봉, DEPT_CODE, PHONE
FROM (
    SELECT EMP_ID, EMP_NAME, (1+NVL(BONUS,0))*SALARY*12 "연봉",DEPT_CODE
    FROM EMPLOYEE E 
) -- 테이블처럼 사용 
WHERE 연봉 >= 40000000; -- 오류 FROM 뒤 테이블에는 PHONE 라는 컬럼이 없어서

-- >> 인라인뷰는 주로 TOP-N 분석(상위 몇위만 가져오기) 
-- (1위부터 5위까지 가져오시오)

-- 전 직원 중 급여가 가장 높은 상위 5명만 조회
--  *ROWNUM : 오라클에서 제공해주는 컬럼. 조회된 순서대로 1부터 순번을 부여해주는 컬럼 

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE ;

SELECT EMP_NAME, 연봉
FROM (
    SELECT EMP_ID, EMP_NAME, (1+NVL(BONUS,0))*SALARY*12 "연봉",DEPT_CODE
    FROM EMPLOYEE E 
    ORDER BY (1+NVL(BONUS,0))*SALARY*12 DESC
)
WHERE ROWNUM <= 5; 



SELECT ROWNUM, EMP_ID, EMP_NAME, (1+NVL(BONUS,0))*SALARY*12 "연봉",DEPT_CODE
    FROM EMPLOYEE E 
    ORDER BY (1+NVL(BONUS,0))*SALARY*12 DESC;
-- 순서 뒤죽박죽 
-- 수행순서 : FROM -> SELECT -> ORDER 순서기에

-- 원하는 수행순서 : FROM -> ORDER -> ROWNUM
SELECT ROWNUM, E.*
FROM (
    SELECT EMP_NAME, (1+NVL(BONUS,0))*SALARY*12 "연봉"
    FROM EMPLOYEE E 
    ORDER BY (1+NVL(BONUS,0))*SALARY*12 DESC
) E
WHERE ROWNUM <= 5; 

-- 가장 최근에 입사한 사원 5명의 사원명 급여 입사일 조회

SELECT E.*
FROM (
    SELECT EMP_NAME, SALARY ,HIRE_DATE
    FROM EMPLOYEE E 
    ORDER BY HIRE_DATE DESC
) E
WHERE ROWNUM <= 5; 

-- 각 부서별 평균급여가 높은 3개의 부서의 부서코드, 평균급여 조회
SELECT E.*
FROM (
    SELECT DEPT_CODE, CEIL(AVG(SALARY))
    FROM EMPLOYEE E 
    GROUP BY DEPT_CODE
    ORDER BY AVG(SALARY) DESC
) E
WHERE ROWNUM <= 3; 

----------------------------------------------------------------------------------------------------------
/*
    6. WITH 
        서브쿼리에 이름을 붙여주고 인라인뷰로 사용시 서브쿼리의 이름으로 FROM절에 기술
        한번의 SQL 문장에서만 유효
        
         장점  
        - 같은 서브쿼리가 여러번 사용될 경우 중복 작성을 피할 수 있음
        - 실행속도도 빨라짐
        - 가독성이 좋아짐
        
        
*/

WITH TOPN_SAL AS (SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
    FROM EMPLOYEE E 
    GROUP BY DEPT_CODE
    ORDER BY AVG(SALARY) DESC)


SELECT DEPT_CODE, 평균급여
FROM TOPN_SAL
WHERE ROWNUM <=3;

SELECT *
FROM TOPN_SAL
WHERE ROWNUM <=3;
-- SQL 하나만 사용가능 이건 오류처리 
-- 이런 단점으로 보편적으로 VIEW 사용 WITH는 사용되지 않는편 

-----------------------------------------------------------------------------------------------------------------------------
/*
    <순위 매기는 함수>
    RANK() OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
    : SELECT 절에서만 사용 
    
    - RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산 
    EX) 공동1위가 2명이면 그 다음 순위는 3위
    - DENSE_RANK() OVER(정렬기준) : 동일한 순위 이후의 등수는 무조건 1증가한 등수 
    EX) 공동1위가 2명이면 그 다음 순위는 2위
    
*/
-- 급여가 높은 순서대로 순위를 매겨서 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
-- 공동 19위 2명 그뒤 순위는 21위

-- 급여가 상위 5위인 사원명 급여 순위 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

SELECT *
FROM (
    SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
    FROM EMPLOYEE
) 
WHERE 순위 <= 3; 
-- RANK 윈도우 함수라서  WHERE 절에 넣지 못함 서브쿼리나 WITH 써서 해결해야함 

WITH TOPN_SAL AS (
    SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
    FROM EMPLOYEE
) 
SELECT *
FROM TOPN_SAL
WHERE 순위 <=5;



SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
-- 공동 19위 2명 그뒤 순위는 20위


---------------------------------------------------------------------------------------------------------
-- SUBQUERY_연습문제
-- 1. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회    
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E,DEPARTMENT D, JOB J
WHERE SUBSTR(EMP_NO,1,1) = 7 AND EMP_NAME LIKE '전%' AND
DEPT_ID = DEPT_CODE AND E.JOB_CODE = J.JOB_CODE;

-- 2. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회
SELECT EMP_ID, EMP_NAME, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RR')) 나이, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E,DEPARTMENT D, JOB J
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RR')) = (
    SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RR')))
    FROM EMPLOYEE
)
AND DEPT_ID = DEPT_CODE AND E.JOB_CODE = J.JOB_CODE;

-- 3. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE EMP_NAME LIKE '%하%'  AND E.JOB_CODE = J.JOB_CODE;

-- 4. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE E,DEPARTMENT D, JOB J
WHERE DEPT_CODE IN ('D5','D6')AND
DEPT_ID = DEPT_CODE AND E.JOB_CODE = J.JOB_CODE;

-- 5. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME 
FROM EMPLOYEE E,LOCATION L, DEPARTMENT D
WHERE BONUS IS NOT NULL 
AND DEPT_ID = DEPT_CODE AND LOCAL_CODE = LOCATION_ID;

-- 6. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME 
FROM EMPLOYEE E,LOCATION L,JOB J, DEPARTMENT D
WHERE DEPT_ID(+) = DEPT_CODE AND LOCAL_CODE(+) = LOCATION_ID AND J.JOB_CODE(+) = E.JOB_CODE;

-- 7. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE E,LOCATION L, DEPARTMENT D, NATIONAL N
WHERE DEPT_ID(+) = DEPT_CODE AND LOCAL_CODE(+) = LOCATION_ID AND L.NATIONAL_CODE= N.NATIONAL_CODE 
AND NATIONAL_NAME IN ('한국','일본');

-- 8. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE E
WHERE DEPT_CODE = (    
    SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '하정연'
);

-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회 (NVL 이용)
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E,JOB J
WHERE J.JOB_CODE(+) = E.JOB_CODE AND NVL(BONUS,0) =0 AND E.JOB_CODE IN ('J4','J7');


-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
SELECT ENT_YN, COUNT(*)
FROM EMPLOYEE E1
GROUP BY ENT_YN;

-- 안함 11. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회
SELECT *
FROM (
    SELECT EMP_ID, EMP_NAME,DEPT_TITLE, JOB_NAME, HIRE_DATE, RANK() OVER(ORDER BY(1+NVL(BONUS,0))*12*SALARY ) "순위"
    FROM EMPLOYEE E, DEPARTMENT D, JOB J
    WHERE E.JOB_CODE = J.JOB_CODE AND DEPT_CODE = DEPT_ID
) E
WHERE ROWNUM <= 5; 



-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--	12-1. JOIN과 HAVING 사용                
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE E1
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (    
    SELECT (SUM(SALARY)*0.2)
    FROM EMPLOYEE
) 
;


--	안함 12-2. 인라인 뷰 사용      
SELECT *
FROM (
SELECT DEPT_TITLE, SUM(SALARY) 부서별급여
FROM EMPLOYEE E1
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (    
    SELECT (SUM(SALARY)*0.2)
    FROM EMPLOYEE
) 

)
;




--	안함 12-3. WITH 사용
WITH TOPN_SAL AS (SELECT DEPT_TITLE, SUM(SALARY) 부서별급여
FROM EMPLOYEE E1
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (    
    SELECT (SUM(SALARY)*0.2)
    FROM EMPLOYEE
))
SELECT *
FROM TOPN_SAL;




-- 13. 부서명별 급여 합계 조회(NULL도 조회되도록)
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE E1
LEFT JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
GROUP BY DEPT_TITLE;



-- 안함 14. WITH를 이용하여 급여합과 급여평균 조회
WITH TOPN_SAL AS (
SELECT DEPT_CODE, SALARY 급여
FROM EMPLOYEE
)
SELECT CEIL(AVG(급여)), SUM(급여)
FROM TOPN_SAL;














