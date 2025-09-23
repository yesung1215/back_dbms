-- 13) 유저 중 이태희를 태희로 이름 변경
UPDATE TBL_BUYER
SET BUYER_NAME = '태희'
WHERE BUYER_NAME = '이태희'; 

-- 14) 신상품 '나이키', '에어맥스 95', 가격 179000원, 재고 200개를 TBL_PRODUCT 테이블에 추가
-- 15) BUYER_NAME이 '철수'인 사람의 핸드폰 번호를 '010-0000-0000'으로 변경
-- 16) PRODUCT_NAME이 '후드티'인 상품의 가격을 310000으로 인상
-- 19) '짱구'가 주문한 상품의 이름과 가격을 조회
SELECT PRODUCT_NAME, PRODUCT_PRICE 
FROM TBL_PRODUCT
WHERE ID IN (
	SELECT PRODUCT_ID 
	FROM TBL_ORDER
	WHERE BUYER_ID = (
		SELECT ID
		FROM TBL_BUYER
		WHERE BUYER_NAME = '짱구'
	)
);

-- 20) 각 구매자별로 주문한 상품의 총 개수를 조회 (구매자 이름, 주문 건수)
SELECT TBB.BUYER_NAME AS "구매자 이름", TBO.ORDER_COUNT AS "주문 건수"
FROM(
	SELECT BUYER_ID, COUNT(PRODUCT_ID) AS ORDER_COUNT
	FROM TBL_ORDER
	GROUP BY BUYER_ID
) TBO
JOIN TBL_BUYER TBB
ON TBO.BUYER_ID = TBB.ID;

-- 21) 가장 많이 주문된 상품 3개의 이름과 주문 횟수를 내림차순으로 조회
SELECT TBP.PRODUCT_NAME AS "상품 이름", TBO.COUNT_ORDER AS "주문 횟수"
FROM(
	SELECT PRODUCT_ID, COUNT(PRODUCT_ID) COUNT_ORDER
	FROM TBL_ORDER
	GROUP BY PRODUCT_ID
	ORDER BY COUNT(PRODUCT_ID) DESC
	FETCH FIRST 3 ROWS ONLY
) TBO
JOIN TBL_PRODUCT TBP
ON TBO.PRODUCT_ID = TBP.ID;


-- 22) 여성 구매자들이 주문한 상품들의 평균 가격을 조회
SELECT ROUND(AVG(TBP.PRODUCT_PRICE)) || '원' AS "여성 구매자들의 주문한 상품의 평균 가격"
FROM(
	SELECT *
	FROM TBL_ORDER
	WHERE BUYER_ID IN (
		SELECT ID
		FROM TBL_BUYER 
		WHERE BUYER_GENDER = '여'
	)
) TBO
JOIN TBL_PRODUCT TBP
ON TBO.PRODUCT_ID = TBP.ID;


-- 23) 나이가 30세 이상인 남성 구매자들의 이름과 주소를 조회
SELECT BUYER_NAME, BUYER_ADDRESS 
FROM TBL_BUYER
WHERE ID IN (
	SELECT DISTINCT BUYER_ID
	FROM TBL_ORDER
	WHERE BUYER_ID IN (
		SELECT ID
		FROM TBL_BUYER
		WHERE BUYER_AGE >= 30
			AND BUYER_GENDER = '남'
	)
);

-- 24) 재고가 100개 이하인 상품 목록을 브랜드명과 함께 조회
SELECT *
FROM TBL_PRODUCT
WHERE PRODUCT_STOCK <= 100;

-- 25) '서울시 강북구'에 사는 구매자들의 이름과 핸드폰 번호를 조회
SELECT BUYER_NAME, BUYER_PHONE 
FROM TBL_BUYER
WHERE ID IN (
	SELECT DISTINCT BUYER_ID
	FROM TBL_ORDER
	WHERE BUYER_ID IN (
		SELECT ID 
		FROM TBL_BUYER
		WHERE BUYER_ADDRESS = '서울시 강북구'
	)
);

-- 26) 주문 상태가 '배송중'인 주문 내역과 해당 주문자의 이름, 상품명을 조회
-- 27) '훈이' 구매자가 주문한 상품들의 총 가격 합계 조회
SELECT SUM(PRODUCT_PRICE) || '원' AS "훈이가 구매한 주문 상품 가격의 합"
FROM(
	SELECT *
	FROM TBL_ORDER
	WHERE BUYER_ID = (
		SELECT ID
		FROM TBL_BUYER
		WHERE BUYER_NAME = '훈이'
	)
) TBO
JOIN TBL_PRODUCT TBP
ON TBO.PRODUCT_ID = TBP.ID;

-- 28) 상품별 기대 매출 조회
-- 29) '유리' 구매자의 주문 내역 중 가장 최근 주문한 상품의 이름과 주문일자를 조회
SELECT TBP.PRODUCT_NAME, TBO.ORDER_START_DATE
FROM (
	SELECT *
	FROM TBL_ORDER
	WHERE BUYER_ID = (
		SELECT ID
		FROM TBL_BUYER
		WHERE BUYER_NAME = '유리'
	)
) TBO 
JOIN TBL_PRODUCT TBP
ON TBO.PRODUCT_ID = TBP.ID
ORDER BY TBO.ORDER_START_DATE;

-- 30) 구매자별로 주문 완료 일자가 가장 빠른 주문 내역을 조회
SELECT BUYER_ID, MIN(ORDER_START_DATE)
FROM TBL_ORDER
GROUP BY BUYER_ID;

-- 31) '스웨이드' 브랜드의 모든 상품 주문 건수를 조회
SELECT COUNT(ID) AS "스웨이드 브랜드의 주문 건수"
FROM TBL_ORDER
WHERE PRODUCT_ID = (
	SELECT ID
	FROM TBL_PRODUCT
	WHERE PRODUCT_BRAND = '스웨이드'
);

-- 32) '봉미선' 구매자가 주문한 상품들 중 가격이 5만원 이상인 상품의 이름과 가격을 조회
SELECT TBP.PRODUCT_NAME, TBP.PRODUCT_PRICE 
FROM(
	SELECT *
	FROM TBL_ORDER
	WHERE BUYER_ID = (
		SELECT ID
		FROM TBL_BUYER
		WHERE BUYER_NAME = '봉미선'
	)
) TBO
JOIN TBL_PRODUCT TBP 
ON TBO.PRODUCT_ID = TBP.ID
WHERE TBP.PRODUCT_PRICE >= 50000;

-- 33) '수지' 구매자의 주소를 '서울시 송파구'로 수정
-- 34) 주문 상태가 '배송중'인 주문을 '배송완료'로 변경
-- 35) 25세 이하인 구매자의 이름, 나이, 구매한 상품명 조회
-- 36) 특정 상품(예: '볼캡')의 재고 수량을 0으로 변경
-- 37) '아이더' 브랜드 상품을 주문한 구매자들의 이름과 연락처를 조회
-- 38) '맹구' 구매자가 주문한 상품들의 가격 총합을 계산
-- 39) 상품 할인 중 모든 30% 할인가격 조회
-- 40) 구매자별로 주문한 상품 개수를 조회
-- 41) '짱구' 구매자가 주문한 상품 중 가격이 가장 비싼 상품을 조회
SELECT *
FROM TBL_PRODUCT
WHERE ID IN (
	SELECT PRODUCT_ID 
	FROM TBL_ORDER
	WHERE BUYER_ID = (
		SELECT ID 
		FROM TBL_BUYER
		WHERE BUYER_NAME = '짱구'
	)
)
ORDER BY PRODUCT_PRICE DESC
FETCH FIRST 1 ROWS ONLY;

-- 42) '철수'와 '훈이'가 주문한 상품들을 조회하되 중복 없이 출력
-- 43) '강북구'에 사는 여성 구매자들의 주문 내역을 조회
-- 44) 구매자 이름과 그가 주문한 상품 이름, 주문 상태를 함께 출력
-- 45) 모든 상품의 평균 가격을 구하고, 평균 이상 가격인 상품들을 조회
SELECT *
FROM TBL_PRODUCT
WHERE PRODUCT_PRICE >= (
	SELECT AVG(PRODUCT_PRICE)
	FROM TBL_PRODUCT 
);	

-- 46) '스파오' 브랜드 상품의 재고를 50개 이하인 경우 재고를 100개로 수정


-- 보류
-- 17) BUYER_NAME이 '맹구'인 구매자의 정보를 TBL_BUYER에서 삭제 (단, 주문 이력이 있을 경우 삭제되지 않음)
-- 18) PRODUCT_NAME이 '텀블러'인 상품을 TBL_PRODUCT 테이블에서 삭제