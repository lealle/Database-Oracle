/*
    <GROUP BY>
    그룹기준을 제시할 수 있는 구문(해당 그룹기준별로 여러 그룹을 묶을 수 있음)
    여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용 

*/
-- 전 사원을 하나의 그룹으로 묶어서 총급여의 합 
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 각 부서별 총 급여합
SELECT DEPT_CODE , SUM(SALARY), CEIL(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;


-- 각 부서별 총 사원수
SELECT DEPT_CODE , COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;


-- 각 부서별
SELECT DEPT_CODE , COUNT(*), SUM(SALARY), CEIL(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 직급별 사원수, 급여의 합과 평균 
SELECT JOB_CODE , COUNT(*), SUM(SALARY), CEIL(AVG(SALARY))
FROM EMPLOYEE
GROUP BY JOB_CODE;


-- 각 직급별 사원수, 보너스를 받는 사원수, 급여의 합과 평균 , 최저급여, 최고급여 조회
SELECT JOB_CODE ,COUNT(*), COUNT(BONUS), SUM(SALARY), CEIL(AVG(SALARY)), MIN(SALARY),MAX(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 남여별 사원수
-- DECODE() 함수 오라클에서만 사용하는 함수
SELECT DECODE(SUBSTR(EMP_NO,8,1),1,'남','2','여',3,'남','4','여') 성별,COUNT(*)
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,8,1) ;

-- 모든 DB 다 사용 
SELECT CASE WHEN SUBSTR(EMP_NO,8,1) = '1' THEN '남'
            WHEN SUBSTR(EMP_NO,8,1) = '2' THEN '여'
            WHEN SUBSTR(EMP_NO,8,1) = '3' THEN '남'
            WHEN SUBSTR(EMP_NO,8,1) = '4' THEN '여'
            ELSE '여'
    END,
    COUNT(*)
FROM EMPLOYEE
GROUP BY CASE WHEN SUBSTR(EMP_NO,8,1) = '1' THEN '남'
            WHEN SUBSTR(EMP_NO,8,1) = '2' THEN '여'
            WHEN SUBSTR(EMP_NO,8,1) = '3' THEN '남'
            WHEN SUBSTR(EMP_NO,8,1) = '4' THEN '여'
            ELSE '여'
    END;       
-- 밑보다 위가 좀 더 간편하게 사용 가능 오라클의 장점 

-- GROUP BY 절에 여러 컬럼 기술 가능 
SELECT DEPT_CODE, JOB_CODE ,COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE,JOB_CODE
ORDER BY DEPT_CODE,JOB_CODE;
-- 2개의 조합으로 이루어짐 


----------------------------------------------------------------------------------
/*
    * <HAVING절>
    그룹에 대한 조건을 제시할 때 사용되는 구문(주로 그룹함수식을 가지고 조건을 제시할 때 사용)
*/
-- 각 부서별 급여 조회(부서코드, 평균급여)
SELECT DEPT_CODE,CEIL(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- **GROUP BY 절에는 WHERE 절 쓸 수없음 -> HAVING 절을 써야함 

-- 각 부서별 급여가 3백만원 이상인 부서들만 조회(부서코드, 평균급여)
SELECT DEPT_CODE,CEIL(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000
ORDER BY DEPT_CODE;

/*
    <SELECT문 실행 순서>
    FROM
    WHERE
    GROUP BY
    HAVING
    SELECT
    DISTINCT
    ORDER BY

    FROM
    IN : 조인 조건 확인
    JOIN
    WHERE
    GROUP BY
    HAVING
    SELECT
    DISTINCT
    

*/

-- 1. 
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY EMPLOYEE
HAVING SUM(SALARY) >= 10000000;

--2
SELECT DEPT_CODE, COUNT(BONUS) 
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

------------------------------------------------------------------------------------------------------
/*
    <집계함수>
    그룹별 산출된 결과값에 중간집계를 계산해주는 함수
    
    ROLLUP, CUBE
    => GROUP BY 절에 기술하는 함수 
    
    - ROLLUP(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간집계를 내는 함수
    - CUBE(컬럼1, 컬럼2) : 컬럼1을 가지고 중간집계를 내고, 컬럼2를 가지고도 중간집계를 냄
    
    
*/
-- 각 직급별 급여함
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE; 

-- 마지막 행에 전체 총 급여합까지 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY JOB_CODE; 

-- 마지막 행에 전체 총 급여합까지 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY JOB_CODE; 
-- 컬럼1개일떄는 차이 없음 

-- 그룹 기준의 컬럼이 하나일 때는 CUBE, ROLLUP 차이가 없음 
SELECT JOB_CODE, DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE,DEPT_CODE)
ORDER BY JOB_CODE; 


SELECT JOB_CODE,DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE,DEPT_CODE)
ORDER BY JOB_CODE; 

-- 둘다 중간집계 J1 ~ J7 까지는 있고 전체 집계도 있음
-- 차이점은 2번째 컬럼 D 에 대해서도 집계가 있는가
-- CUBE 는 있고 ROLLUP은 없음 

-- CUBE, ROLLUP 의 차이점을 보려면 그룹기준의 컬럼이 2개는 있어야함
    -- ROLLUP(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간집계를 내는 함수
    -- CUBE(컬럼1, 컬럼2) : 컬럼1을 가지고 중간집계를 내고, 컬럼2를 가지고도 중간집계를 냄
    
---------------------------------------------------------------------------------------------------
/*
    <집합연산자>
    여러개의 쿼리문을 가지고 하나의 쿼리문을 만드는 연산자 ]
    
    - UNION : OR | 합집합 (두 쿼리문을 수행한 결과값을 더한 후 중복되는 값은 한번만 더해지도록 하는 집합)
    - INTERSECT : AND | 교집합 (두 쿼리문을 수행한 결과값에 중복된 값만)
    - UNION ALL : 합집합 + 교집합(중복되는 값은 2번 표현됨)
    - MINUS : 차집합 (선행결과값에서 후행결과값을 뺀 나머지)
    
    
*/
------------------------------- 1. UNION --------------------------------------------
-- 부서코드가 D5 인 사원 또는 급여가 300만원 초과인 사원들 조회
SELECT DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY >3000000;


SELECT DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION --합집합
SELECT DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >3000000;

-- UNION 보다는 OR 로도 가능해서 OR 를 많이 씀 

------------------------------- 2. INTERSECT --------------------------------------------

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >3000000;


SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY >3000000;
-- AND 절로도 가능

------------------------------- 3. UNION ALL --------------------------------------------

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >3000000;

------------------------------- 4. MINUS --------------------------------------------
-- 부서코드가 D5 인 사원 또는 급여가 300만원 이하인 사원들 조회

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >=3000000;


SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY <= 3000000
-- AND 로도 가능 


