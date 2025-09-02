/*
    <함수 FUNCTION>
    전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
    
    -단일행 함수 : N개 값을 읽어들여 N개의 결과값 반환(매 행마다 함수 실행)
    -그룹 함수 : N개 값을 읽어들여 1개의 결과값 반환 (그룹별로 함수 실행)
    
    
    >> SELECT 절에 단일행 함수와 그룹함수를 함께 사용 불가

    >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절

*/
-----------------------단일행 함수-----------------------------
--============================================================

--                    <문자처리 함수>
--============================================================
/*
    * LENGTH /LENGTHB => NUMBER로 반환 
    
    LENGTH (컬럼|'문자열') : 해당 문자열의 글자수 반환 
    LENGTHB (컬럼|'문자열') : 해당 문자열의 BYTE수 반환 
        - 한글 : XE버전일 때 => 한글자당 3BYTE(김, ㄱ, ㅠ) -> 한글자에 해당
                EE 버전일 때 => 1글자당 2BYTE(김, ㄱ, ㅠ)
        - 그외 1글자당 1BYTE
    
*/
SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL;
-- 3글자, 9바이트

SELECT LENGTH('ORACLE'), LENGTHB('ORACLE') -- 대소문자 상관없음
FROM DUAL;
// 6글자 6바이트

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME), EMAIL,LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

--------------------------------------------------------------------------
/*
    * INSTR : 문자열로부터 특정문자의 시작위치(INDEX)를 찾아 반환(반환형 : NUMBER)
        -ORACLE 에서는 INDEX 1부터 시작, 찾을 문자가 없으면 0 반환 
        
      INSTR(컬럼|'문자열', '찾고자하는 문자', '[찾을 위치의 시작값, [순번] ] )
      - 찾을 위치의 시작값
        > 1 : 앞에서부터 찾기 (기본값)
        > -1 : 뒤에서부터 찾기
        > `
*/

SELECT INSTR('JAVASCRIPTJAVAORACLE','A') FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',1) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',3) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',-1) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',1,3) FROM DUAL; --앞에서부터 3번째 것 
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',-1,3) FROM DUAL; --앞에서부터 3번째 것 


-- EMPLOYEE 테이블에서 EMAL 의 '_' 의 INDEX 번호와 '@' 의 INDEX번호
SELECT EMAIL, INSTR(EMAIL, '_') "_위치", INSTR(EMAIL, '@') "@위치"
FROM EMPLOYEE;

----------------------------------------------------
/*
    * SUBSTR : 문자열에서 특정 문자열을 추출하여 반환 (반환형 : CHARACTER)
    
      SYBSTR('문자열',POSITION, [LENGTH])
      - POSITION: 문자열을 추출할 시작위치 INDEX번호 
      - LENGTH : 추출할 문자의 개수 (생략시 맨 마지막까지 추출)
    
*/

SELECT SUBSTR('ORACLEHTMLCSS',7) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS',7,4) FROM DUAL;  -- HTML
SELECT SUBSTR('ORACLEHTMLCSS',1,6) FROM DUAL; -- ORACLE
SELECT SUBSTR('ORACLEHTMLCSS',-7,4) FROM DUAL; -- HTML
SELECT SUBSTR('ORACLEHTMLCSS',-3,3) FROM DUAL; -- CSS
SELECT SUBSTR('ORACLEHTMLCSS',-3) FROM DUAL; -- CSS
SELECT SUBSTR('ORACLEHTMLCSS',7,4) FROM DUAL; -- HTML

-- EMPLOYEE 테이블에서 주민번호의 성별만 추출하여 주민번호, 사원명, 성별을 조회

SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO,8,1) AS 성별
FROM EMPLOYEE;


-- GPT 가 알려준 더 좋은 쿼리문 
SELECT EMP_NO, 
       EMP_NAME,
       CASE SUBSTR(EMP_NO, 8, 1)
            WHEN '1' THEN '남자'
            WHEN '3' THEN '남자'
            WHEN '2' THEN '여자'
            WHEN '4' THEN '여자'
            ELSE '기타'
       END AS 성별
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 여자사원들만 추출하여 사원번호, 사원명, 성별을 조회

SELECT EMP_NAME, EMP_ID, SUBSTR(EMP_NO,8,1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN ('2','4');


-- EMPLOYEE 테이블에서 남자사원들만 추출하여 사원번호, 사원명, 성별을 조회

SELECT EMP_NAME, EMP_ID, SUBSTR(EMP_NO,8,1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN ('1','3')
--ORDER BY EMP_NAME;
ORDER BY 1;


-- EMPLOYEE 테이블에서 EMAIL에서 아이디만 추출하여  사원명, 이메일, 아이디(@이전까지 추출)을 조회

SELECT EMP_NAME, EMAIL , SUBSTR(EMAIL ,1,INSTR(EMAIL, '@')-1) 아이디
FROM EMPLOYEE;

-------------------------------------------------------------
/*
    *  LPAD / RPAD : 문자열을 조회할 때 통일감있게 조회하고자 할때 (반환형 : CHAR )
    
       LPAD / RPAD ('문자열', 최종적으로반환할문자의길이, [덧붙이고자하는 문자] )
       문자열에 덧붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N 길이만큼의 문자열 반환
       
    
*/

-- 20길이 중 EMAIL 컬럼값은 오른쪽 정렬하고 나머지 부분은 공백을 채움

SELECT EMP_NAME, LPAD(EMAIL,20) -- 20글자 오른쪽 정렬 (공백포함)
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL,20,'#') -- 20글자 오른쪽 정렬 (공백에 #넣으시오)
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL,20) -- 20글자 왼쪽 정렬 (공백포함)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번, 사원명 ,주민번호 출력 (123456-1******의 형식으로 출력)
 -- 우선 주민번호 추출 -> 주민번호 뒤에 * 붙여주기 
SELECT EMP_ID, EMP_NAME, RPAD(SUBSTR(EMP_NO,1,8),14,'*') 주민번호
FROM EMPLOYEE;

-- 고정적으로 동일하다면 이런방식이 더 좋을 수 있음 
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO,1,8)||'******'주민번호
FROM EMPLOYEE;

--------------------------------------------------------------
/*
    * LTRIM / RTRIM : 문자열에서 특정문자를 제거한 나머지 반환(반환형 : CHARACTER)
    * TRIM : 문자열의 앞/뒤 양쪽에 지정한 문자들을 제거한 나머지 반환 
    
      LTRIM / RTRIM('문자열',[제거하고자하는 문자] )
      TRIM([LEADING|TRAILING|BOTH] 제거하고자하는문자들 FROM '문자열' ) => 제거하고자하는 문자는 1개만 가능 
      > 제거하고자하는 문자 없을시 기본값 공백제거         
      둘은 순서가 반대 
    
*/

SELECT LTRIM('     TJOEUN     ') || '컴퓨터아카데미' FROM DUAL;
SELECT LTRIM('JAVAJAVASCRIPT','JAVA') FROM DUAL;
SELECT LTRIM('JAVAJAVASCRIPT','JAV') FROM DUAL; -- 결과 위와 같음 (단어가 아닌 글자 하나하나)
SELECT LTRIM('BACBAACFABCD','ABC') FROM DUAL;  -- ABC 있는거 다 제거후 없는 F 나오면 스탑 
SELECT LTRIM('283980KLSDK323','0123456789') FROM DUAL; -- 왼쪽의 숫자 다 제거된 모습 


SELECT RTRIM('     TJOEUN     ') || '컴퓨터아카데미' FROM DUAL; -- 오른쪽 공백 제거 
SELECT RTRIM('BACBAACFABCB','ABC') FROM DUAL;  -- 오른쪽부터 ABC 있는거 다 제거후 없는 F 나오면 스탑 
SELECT RTRIM('283980KLSDK323','0123456789') FROM DUAL; -- 오른쪽의 숫자 다 제거된 모습 

-- 기본값 BOTH (양쪽의 문자들을 제거) 
SELECT TRIM(BOTH 'A' FROM 'AAAADKS51DAAA') FROM DUAL; -- 양쪽 A 제거  
SELECT TRIM('A' FROM 'AAAADKS51DAAA') FROM DUAL; -- 양쪽 A 제거  같음 기본값이기에
SELECT TRIM(LEADING 'A' FROM 'AAAADKS51DAAA') FROM DUAL; -- 왼쪽 A 제거  -> LTRIM 
SELECT TRIM(TRAILING 'A' FROM 'AAAADKS51DAAA') FROM DUAL; -- 오른쪽 A 제거 -> RTRIM

--------------------------------------------------------------
/*
    * LOWER / UPPER / INITCAP : 문자열을 대소문자로 반환 및 단어의 첫글자만 대문자로 변환 
    
    * LOWER / UPPER / INITCAP ('문자열')
      소문자  / 대문자 / 
*/
SELECT LOWER('Java Javascript Oracle') 
    ,UPPER('Java Javascript Oracle') 
    ,INITCAP('java javascript oracle') FROM DUAL;

------------------------------------------------------------------------------------
/*
    * CONCAT : 문자열 2개를 전달받아 하나로 합쳐진 결과 반환 
    
     CONCAT('문자열','문자열')
*/
SELECT CONCAT('Oracle','오라클') FROM DUAL;
SELECT 'Oracle' || '오라클' FROM DUAL; -- 이렇게 써도 되고 이게 더 편함

SELECT CONCAT('Oracle','오라클','02-123-1231', '강남구') FROM DUAL; 
-- 됨 하지만 낮은버전은 안될수 있어 보편적으로 위의 방식 사용 

-------------------------------------------------------
/*
    * REPLACE : 기존문자열을 새로운 문자열로 바꿈
    
      REPLACE('문자열', '기존문자열', '바꿀문자열')
*/
SELECT REPLACE('ORACLE 공부중','ORACLE','오라클') FROM DUAL;

-- EMPLOYEE 테이블에서 사원명, 이메일, 이메일변경 'aie.or.kr' -> 'tjoeun.co.kr'
SELECT EMP_NAME, EMAIL, REPLACE(EMAIL,'aie.or.kr','tjoeun.co.kr') 변경한이메일
FROM EMPLOYEE;

--======================================================================
--                        <숫자처리 함수>
--======================================================================
/*
    * ABS : 숫자의 절대값
    
    ABS(NUMBER)
*/

SELECT ABS(-10) FROM DUAL;
SELECT ABS(-3.14) FROM DUAL;

-------------------------------------------------------------------------------------------------
/*
    * MOD : 두 수를 나눈 나머지값 
    
      MOD(NUMBER, NUMBER)
*/
SELECT MOD(10,3) FROM DUAL;
SELECT MOD(10.9,2) FROM DUAL; -- 잘 사용안함 

---------------------------------------------------------------------------------------------------------
/*
    * ROUND : 반올림한 결과
    
      ROUND(NUMBER, [위치])
        - 위치 생략시 위치는 0 (즉, 정수로 반올림)
      
*/
SELECT ROUND(123.456) FROM DUAL;
SELECT ROUND(123.456, 1) FROM DUAL;
SELECT ROUND(123.456, 2) FROM DUAL;
SELECT ROUND(123.456, 3) FROM DUAL;

SELECT ROUND(4123.456, -2) FROM DUAL; -- 위로 올라감 

---------------------------------------------------------------------
/*
    * CEIL : 무조건 올림
    
      CEIL(NUMBER)
*/

SELECT CEIL(123.456) FROM DUAL;
SELECT CEIL(-123.456) FROM DUAL;
SELECT CEIL(4.1) FROM DUAL;
SELECT CEIL(-4.1) FROM DUAL;

------------------------------------------------------------------------
/*
    * FLOOR : 무조건 내림
    
      FLOOR(NUMBER)
*/

SELECT FLOOR(123.456) 
    ,FLOOR(-123.456) 
    ,FLOOR(4.1) 
    ,FLOOR(-4.1) FROM DUAL;


------------------------------------------------------------------------
/*
    * TRUNC : 위치지정 가능한 버림처리 함수
    
      TRUNC(NUMBER, [위치])
*/

SELECT TRUNC(123.456) 
    ,TRUNC(-123.456)
    ,TRUNC(123.456 , 1) 
    ,TRUNC(123.456 , -1) 
    ,TRUNC(-123.456 , -2)
    ,TRUNC(4.1 ) 
    ,TRUNC(-4.1) FROM DUAL;

--=====================================================================================================
--                                      <날짜처리 함수>
--=====================================================================================================
/*
    * SYSDATE : 시스템 날짜 및 시간 반환
*/

SELECT SYSDATE FROM DUAL; 
-- 보이는건 날짜지만 시간까지 다 설정되어있음 SYSDATE 엔 
-- 설정 -> 데베 -> SLS 에서 어디까지 나올지 수정 가능 

--------------------------------------------------------------------------------------------------
/*
    * MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜 사이의 개월 수 반환
    
*/
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE 근무일수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE,HIRE_DATE))||'개월차' AS 근무개월수
FROM EMPLOYEE;
-- 정수로 받고싶어 CEIL 처리 

SELECT EMP_NAME, HIRE_DATE, CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)),'개월차') AS 근무개월수
FROM EMPLOYEE;

--------------------------------------------------------------------------------------
/*
    * ADD_MONTHS(DATE, NUMBER) : 특정날짜에 해당 숫자만큼 개월수를 더해 그날짜를 반환
*/

SELECT ADD_MONTHS(SYSDATE, 1) FROM DUAL;
SELECT ADD_MONTHS(SYSDATE, 3) FROM DUAL;
SELECT ADD_MONTHS(SYSDATE, 6) FROM DUAL;

-- EMPLOYEE 테이블에서 사원명, 입사일, 정직원이된 날짜(입사일로부터 6개월 수습) 조회
SELECT EMP_NAME, HIRE_DATE 입사일, ADD_MONTHS(HIRE_DATE,6) 정직원승급일
FROM EMPLOYEE;

-----------------------------------------------------------------------------------------------------
/*
    * NEXT_DAY(DATE, 요일(문자| 숫자)) : 특정 날짜 이후에 가까운 해당 요일의 날짜를 반환 
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE, '화요일') 
    ,NEXT_DAY(SYSDATE, '월')
    ,NEXT_DAY(SYSDATE, 3)
    ,NEXT_DAY(SYSDATE, 2) AS "요일" -- 월
--    ,NEXT_DAY(SYSDATE, 'MONDAY')  언어 한국어이기에 영어로 하면 오류 발생 굳이 하고싶다 하면 언어 영어로 바꿔주면됨 
FROM DUAL;
-- 1:일 2:월 ...

-- 언어변경
--ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
--ALTER SESSION SET NLS_LANGUAGE = KOREAN;

---------------------------------------------------------------------------------------------
/*
    *LAST_DAY(DATE) : 해당 월의 마지막 날짜를 반환해주는 함수 
*/
SELECT SYSDATE, LAST_DAY(SYSDATE) FROM DUAL;

-- EMPLOYEE 테이블에서 사원명, 입사일, 입사한달의 마지막 날짜 조회
SELECT EMP_NAME, HIRE_DATE 입사일, LAST_DAY(HIRE_DATE) "입사한달의 마지막날"
FROM EMPLOYEE;


----------------------------------------------------------------------------------
/*
    * EXTRACT : 특정날짜로 부터 년도|얼|일 값을 추출하여 반환하는 함수(반환형 :NUMBER )
    
      EXTRACT(YEAR FROM DATE) : 년도 추출
      EXTRACT(MONTH FROM DATE) : 월만 추출
      EXTRACT(DAY FROM DATE) : 일만 추출
*/
SELECT EMP_NAME,
    EXTRACT(YEAR FROM HIRE_DATE) 입사년도,
    EXTRACT(MONTH FROM HIRE_DATE) 입사월,
    EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE
ORDER BY 입사년도, 입사월, 입사일;
-- 2, 3, 4 로도 가능! 

--============================================================================================
--                              <형변환 함수>
--============================================================================================
/*
    * TO_CHAR : 숫자 또는 날짜 타입의 값을 문자타입으로 변환시켜주는 함수
                반환 결과를 특정 형식에 맞춰 출력할 수도 있음 
                
      TO_CHAR(숫자|날짜, [포맷])
*/

-------------------------------- 숫자 타입 -> 문자 타입 --------------------------------------------
/*
    9: 해당 자리의 숫자를 의미
      - 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표시 
    0: 해당 자리의 숫자를 의미
      - 값이 없을 경우 0으로 표시하면 숫자의 길이를 고정적으로 표시할 때 주로 사용 
    FM: 해당 자리값이 없을 경우 자리차지하지 않음 

*/

SELECT TO_CHAR(1234) 
    ,TO_CHAR(1234,'99999')AS "1" -- 6칸 확보, 왼쪽정렬, 빈카공백 
    ,TO_CHAR(1234,'00000') AS "2" -- 6칸 확보, 왼쪽정렬, 빈카 0으로 채움  
    ,TO_CHAR(1234,'L99999') AS "3" -- L 로컬(LOCAL)의 화폐단위(빈칸공백) -> 오른쪽 정렬  
    ,TO_CHAR(1234,'99,999') AS "4" 
    ,TO_CHAR(SYSDATE) AS "0"
FROM DUAL;

SELECT EMP_NAME
    , TO_CHAR(SALARY, 'L99,999,999') 월급
    , TO_CHAR(SALARY*12, 'L999,999,999') 연봉
FROM EMPLOYEE
ORDER BY 3 DESC;

--FM 해당 자리값 없을시 공백 
SELECT TO_CHAR(1234) 
    ,TO_CHAR(123.456,'FM99990.999')AS "1" -- 0. 1자리는 무조건 출력 소수점은 3자리까지 
    ,TO_CHAR(1234.45,'FM9990.999')AS "2"
    ,TO_CHAR(0.1000,'FM9990.999')AS "3" -- 0.1 -> 1번째 자리는 무조건 출력하게 0 사용
    ,TO_CHAR(0.1000,'FM99999.999')AS "4" -- .1 -> 출력 
FROM DUAL;

SELECT TO_CHAR(123.456,'999990.999') "1" -- 3칸 공백  
    ,TO_CHAR(123.45,'9990.999')"2" --소수점 이하자리 0으로 표현
    ,TO_CHAR(0.1000,'9990.999') "3" -- 0.100
    ,TO_CHAR(0.1000,'9999.999') "4" --  .100
FROM DUAL;

---------------------------------날짜 타입 -> 문자 타입--------------------------------------
-- 시간
SELECT TO_CHAR(SYSDATE, 'AM') "KOREA" -- AM,PM : 오전인지 오후인지
    ,TO_CHAR(SYSDATE, 'PM', 'NLS_DATE_LANGUAGE = AMERICAN') "AMERICA" -- ALTER SESSION 말고 이렇게 바꿔도 됨 
    ,TO_CHAR(SYSDATE, 'AM') "KOREA"
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') "1" -- 시분초 HH: 12시간 형식 
    ,TO_CHAR(SYSDATE, 'HH24:MI:SS') "2"-- HH24: 24시간 형식 
    ,TO_CHAR(SYSDATE, 'HH:MI:SS') "3" -- 오전 오후 알수없음  
FROM DUAL;

-- 날짜
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY') "1" -- 년월일 요일 
    ,TO_CHAR(SYSDATE, 'YYYY-MM-DD DY') "2"--  DY : 월 DAY : 월요일 --> 요일이 나오냐 안나오냐 차이 
    ,TO_CHAR(SYSDATE, 'YYYY-MM-DD DY AM HH:MI:SS') "3" -- 
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'MON, YYYY') FROM DUAL; -- LOCAL KOREAN ~월 로 출력 

-- 2025년 09월 01일 월요일 출력 
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" DAY') 현재 
FROM DUAL;

-- 간단하게 이렇게 출력 가능 
SELECT TO_CHAR(SYSDATE, 'DL') 현재 
FROM DUAL;

-- EMPLOYEE 테이블에서 입사일의 출력형식을 25-09-01 형식으로 조회
SELECT EMP_NAME, HIRE_DATE, TO_CHAR(HIRE_DATE,'YY-MM-DD')
FROM EMPLOYEE;

SELECT EMP_NAME, TO_CHAR(HIRE_DATE,'DL')
FROM EMPLOYEE;

-- 년도
/*
    YY : 현재세기가 앞에 붙는다
    RR : 50년을 기준으로 50보다 작으면 현재세기, 크거나 같으면 이전세기가 붙는다
    
*/

/*
예제)
    RR 
    050101 -> 2005
    780101 -> 1978
    
    YY
    050101 -> 2005
    780101 -> 2078
*/

SELECT TO_CHAR(SYSDATE, 'YYYY')
    ,TO_CHAR(SYSDATE, 'RRRR')
    ,TO_CHAR(SYSDATE, 'YY')
    ,TO_CHAR(SYSDATE, 'RR')
    ,TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;

-- 월 
SELECT TO_CHAR(SYSDATE, 'MM') --
    ,TO_CHAR(SYSDATE, 'MON') -- SEP
    ,TO_CHAR(SYSDATE, 'MONTH') -- SEPTEMBER
    ,TO_CHAR(SYSDATE, 'RM')
FROM DUAL;
-- 한글이라서 똑같은것 영문으로 하면 약간 다르게 나옴 
-- 언어변경
--ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
--ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- 일 , 요일  
SELECT TO_CHAR(SYSDATE, 'DDD') -- 365 중 몇일
    ,TO_CHAR(SYSDATE, 'DD') -- 월기준 몇일 
    ,TO_CHAR(SYSDATE, 'D') -- 주기준 몇일(일1, 월2, ...)
    ,TO_CHAR(SYSDATE, 'DAY') -- 
    ,TO_CHAR(SYSDATE, 'DY') -- 
    
FROM DUAL;

------------------------------------------숫자 또는 문자 타입 -> 날짜 타입 ------------------------------------------------
/*
    * TO_DATE : 숫자 또는 문자타입을 날짜타입으로 변환 
    
      TO_DATE(슷지|문자, [포맷])
      
*/

SELECT TO_DATE(20100901) 
    ,TO_DATE(100901) "1"
--    ,TO_DATE(010901) 숫자 앞에 0이 붙이면 없다고 간주하여서 5자리로 인식 
    ,TO_DATE('010901') "2" -- 이럴땐 문자표시 해줘야한다
FROM DUAL;


SELECT TO_DATE('041028 103000', 'YYMMDD HHMISS')  FROM DUAL;
--SELECT TO_DATE('041028 143000', 'YYMMDD HHMISS')  FROM DUAL; -- 오류 오전 오후로 
SELECT TO_DATE('041028 143000', 'YYMMDD HH24MISS')  FROM DUAL;

SELECT TO_DATE('041028 103000', 'YY-MM-DD HH:MI:SS')  FROM DUAL; -- 표시한대로 안나오고 / 로 나옴 
SELECT TO_CHAR(TO_DATE('041028 103000', 'YYMMDD HHMISS'),'YY-MM-DD HH:MI:SS')  FROM DUAL; -- 이런식으로 포맷 바꿔서 하면 됨 
-- 아니면 환경설정에서 바꿔도 됨 

-- 이제 시간 안써서 환경설정에서 시간뻄
SELECT TO_DATE('040725','YYMMDD') FROM DUAL; -- 현재세기
SELECT TO_DATE('970725','YYMMDD') FROM DUAL; -- 현재세기
SELECT TO_CHAR(TO_DATE('970725','YYMMDD'),'YYYY-MM-DD') FROM DUAL; -- 현재세기

SELECT TO_DATE('040725','RRMMDD') FROM DUAL; -- 현재세기
SELECT TO_DATE('970725','RRMMDD') FROM DUAL; -- 이전세기
SELECT TO_CHAR(TO_DATE('970725','RRMMDD'),'RRRR-MM-DD') FROM DUAL; -- 이전세기

SELECT TO_CHAR(TO_DATE('97/07/25','YY/MM/DD'),'RRRR-MM-DD') FROM DUAL; -- 현재세기
-- YY 로 받으면 그냥 YY 임 이후 RR 처리한다고 달라지지않음 

--------------------------------문자타입 -> 숫자타입----------------------------------------------------
/*
    * TO_NUMBER : 문자 타입의 데이터를 숫자타입으로 변환 
    
      TO_NUMBER(문자, [포맷])
*/
SELECT TO_NUMBER('0123401234') FROM DUAL;

SELECT '1000000' + '550000' FROM DUAL; -- 자동형변환 후 연산처리 
SELECT '1,000,000' + '550000' FROM DUAL; -- 자동형변환오류 -> 숫자이외 특수기호가 있으면 안됨 
SELECT TO_NUMBER('1,000,000','9,999,999') + TO_NUMBER('550,000','999,999') FROM DUAL; -- 형태를 알고있으면 형변환 이런식으로 가능 

--============================================================================================
--                              <NULL처리 함수>
--============================================================================================
/*
    * NVL(컬럼, 해당컬럼값이 NULL일때 반환할 값)
*/
SELECT EMP_NAME, NVL(BONUS,0) 
FROM EMPLOYEE;

-- 전사원의 이름, 보너스 포함 연봉
SELECT EMP_NAME, (SALARY +NVL(BONUS,0)*SALARY)*12 연봉
FROM EMPLOYEE
ORDER BY 2 DESC;

-- 전사원의 사원명, 부서코드조회(만약 부서코드가 NULL이면 부서없음 으로 출력
SELECT EMP_NAME, NVL(DEPT_CODE,'부서없음')
FROM EMPLOYEE;

---------------------------------------------------------------------------------------------
/*
    * NVL2(컬럼, 반환값1, 반환값2)
      - 컬럼값이 존재하면 반환값1, 존재하지않다면 반환값2 출력 
      YES OR NO 
*/
-- EMPLOYEE 에서 사원명, 급여, 보너스, 성과금(보너스를 받는사람은 50%, 보너스를 못받는사람은 10%)
SELECT EMP_NAME, SALARY, BONUS, SALARY*NVL2(BONUS, 0.5, 0.1)
FROM EMPLOYEE;

-- 전사원의 사원명, 부서코드조회(만약 부서코드가 NULL이면 부서없음 으로 있으면 부서있음 출력
SELECT EMP_NAME, NVL2(DEPT_CODE,'부서있음','부서없음')
FROM EMPLOYEE;

---------------------------------------------------------------------------------------------
/*
    * NULLIF(비교대상1, 비교대상2)
      - 2개의 값이 일치하면 NULL 반환
      - 2개의 값이 다르면 비교대상1 값을 반환

*/
SELECT NULLIF('123', '123') 
    ,NULLIF('1234', '123') FROM DUAL;



--============================================================================================
--                              <선택 함수>
--============================================================================================
/*  
    * DECODE(비교하고자하는 대상(컬럼|산술연산|함수식), 비교값1, 결과값1, 비교값2, 결과값2, ... , DEFAULT값 )
      비교값1 -> 결과값1, 비교값2 -> 결과값2, ...  
      SWITCH(비교대상) (
        CASE 비교값1:
            결과값1;
        CASE 비교값1:
            결과값1;
            ...
      ) 
      코드에서 스위치구문과 같다. (데베는 스위치 구문이 없다.) 
*/

-- EMPLOYEE 테이블에서 사번, 사원명, 주민번호, 성별 
SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO,8,1),1,'남',2,'여',3,'남',4,'여')||'자' 성별 
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번, 사원명, 직급코드, 각 직급별로 인상한 급여 조회
    -- J7인 사원은 급여를 10% 인상
    -- J9인 사원은 급여를 15% 인상 
    -- J5인 사원은 급여를 20% 인상 
    -- 이외 모든 사원은 급여를 5% 인상 
    
SELECT EMP_ID, EMP_NAME, JOB_CODE, 
    DECODE(JOB_CODE
        ,'J7',SALARY*1.1
        ,'J9',SALARY*1.15
        ,'J5',SALARY*1.2
        , SALARY*1.05) "인상된 급여" 
    , SALARY 이전급여
FROM EMPLOYEE;

---------------------------------------------------------------
/*
    * CASE WHEN THEN 
      THEN
      
      CASE WHEN 조건식1 THEN 결과값1
           WHEN 조건식2 THEN 결과값2
           ...
           ELSE 결과값N
      END
      
      * 프로그램 IF - ELSE 와 동일
    
*/
-- EMPLOYEE 테이블에서 사원명, 급여, 급여에 따른 등급 
    -- 고급 : 5백만원 이상 인 사원
    -- 중급 : 5백만원 미만 3백만원 이상 인 사원
    -- 초급 : 3백만원 미만 인 사원
    
SELECT EMP_NAME, SALARY, 
    CASE WHEN SALARY >= 5000000 THEN '고급'
         WHEN SALARY >= 3000000 THEN '중급'
         ELSE '초급'
    END AS 등급
FROM EMPLOYEE;


--============================================================================================
--                              <그룹 함수>
--============================================================================================
/*
    * SUM(컬럼(NUMBER타입) ) : 해당 컬럼값들의 합계를 구해 반환하는 함수 
*/
-- 행 10개 -> 1개  그룹함수 

-- EMPLOYEE 테이블에서 전 사원의 급여의 합 
SELECT SUM(SALARY) 급여합계
FROM EMPLOYEE;
    
-- EMPLOYEE 테이블에서 남자사원의 급여의 합 
SELECT SUM(SALARY) "남자사원의 급여합계"
FROM EMPLOYEE
WHERE DECODE(SUBSTR(EMP_NO,8,1),1,'남',3,'남','여') = '남';

SELECT SUM(SALARY) "남자사원의 급여합계"
FROM EMPLOYEE
WHERE DECODE(SUBSTR(EMP_NO,8,1),1,'남',3,'남','여') = '남';
--조건을 주기때문에 여자를 받아도 됨 

-- EMPLOYEE 부서코드가 D5인 사원의 총 급여
SELECT SUM(SALARY) "D5인 사원들의 급여합계"
FROM EMPLOYEE
WHERE DEPT_CODE ='D5';

-- EMPLOYEE 부서코드가 D5인 사원의 총 연봉(보너스 포함)의 합 조회
SELECT SUM((1 + NVL(BONUS,0))*SALARY*12) "D5인 사원들의 연봉합계"
FROM EMPLOYEE
WHERE DEPT_CODE ='D5';

-- EMPLOYEE 테이블에서 전 사원의 급여의 합 (출력 : \111,111,111)
SELECT TO_CHAR(SUM(SALARY), 'L999,999,999') "전 사원들의 급여합계"
FROM EMPLOYEE;

-------------------------------------------------------------------------------------------------
/*
    * AVG(컬럼(NUMBER타입)) : 해당 컬럼값들의 평균 
*/

-- EMPLOYEE 테이블에서 전 사원의 급여의 평균 
SELECT CEIL(AVG(SALARY)) 급여평균
FROM EMPLOYEE;
    
SELECT ROUND(AVG(SALARY),2) 급여평균
FROM EMPLOYEE;

-------------------------------------------------------------------------------------------------
/*
    * MIN(컬럼(모든타입)) : 해당 컬럼 값들 중 가장 작은값 반환
    * MAX(컬럼(모든타입)) : 해당 컬럼 값들 중 가장 큰값 반환
*/
SELECT MIN(EMP_NAME) , MIN(HIRE_DATE), MIN(SALARY)
FROM EMPLOYEE;

SELECT MAX(EMP_NAME) , MAX(HIRE_DATE), MAX(SALARY)
FROM EMPLOYEE;

-----------------------------------------------------------
/*
    * COUNT(*|컬럼|DISTINCT컬럼) : 행의 갯수 반환
    
    - COUNT(*) : 조회된 결과의 모든 행의 갯수 반환  
    - COUNT(컬럼) : 제시한 컬럼의 NULL값을 제외한 행의 갯수 반환  
    - COUNT(DISTINCT컬럼) : 해당 컬럼값에서 중복을 제거한 행의 갯수 반환  
    
*/

-- EMPOYEE 테이블에서 전체 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE;

-- EMPOYEE 테이블에서 여자 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN (2,4);

-- EMPOYEE 테이블에서 보너스를 받는 사원의 수
SELECT COUNT(BONUS)
FROM EMPLOYEE;


-- EMPOYEE 테이블에서 부서배치를 받은 사원의 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;


-- EMPOYEE 테이블에서 현재 사원이 총 몇개의 부서에 분포되어있는지 사원의 수
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;
