CREATE TABLE Members (
    MemberID VARCHAR2(32) PRIMARY KEY,
    Password VARCHAR2(64) NOT NULL,
    PhoneNumber NUMBER(16) NOT NULL,
    MemberType VARCHAR2(8) CHECK (MemberType IN ('일반', '사장')) NOT NULL,
    Email VARCHAR2(128),
    AddressProvince VARCHAR2(32) NOT NULL,
    AddressCity VARCHAR2(32) NOT NULL,
    AddressDistrict VARCHAR2(32) NOT NULL,
    AddressDetail VARCHAR2(128) NOT NULL,
    CreationDate TIMESTAMP
);

CREATE TABLE Store (
    StoreID NUMBER(9) PRIMARY KEY,
    StoreName VARCHAR2(32) NOT NULL,
    AddressProvince VARCHAR2(32) NOT NULL,
    AddressCity VARCHAR2(32) NOT NULL,
    AddressDistrict VARCHAR2(32) NOT NULL,
    AddressDetail VARCHAR2(128) NOT NULL,
    PhoneNumber NUMBER(16) NOT NULL,
    Introduction VARCHAR2(255),
    MinOrderCost NUMBER(8) NOT NULL,
    TotalReviewCount NUMBER(8) DEFAULT 0,
    TotalRating NUMBER(16) DEFAULT 0,
    AverageRating GENERATED ALWAYS AS (CASE WHEN TotalReviewCount > 0 
        THEN TotalRating / TotalReviewCount ELSE 0 END) VIRTUAL,
    CreationDate TIMESTAMP,
    CONSTRAINT CHK_AverageRating CHECK (AverageRating BETWEEN 0 AND 5)
);

CREATE TABLE Reviews (
    ReviewID NUMBER(9) PRIMARY KEY,
    Rating NUMBER(1) CHECK (Rating BETWEEN 1 AND 5) NOT NULL,
    Content VARCHAR2(255) NOT NULL,
    CreationDate TIMESTAMP,
    MemberID VARCHAR2(32),
    StoreID NUMBER(9),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE,
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID) ON DELETE CASCADE
);

CREATE TABLE Membership (
    MembershipCode NUMBER(9) PRIMARY KEY,
    Grade VARCHAR2(16) CHECK (Grade IN ('브론즈', '실버', '골드')) NOT NULL,
    CreationDate TIMESTAMP,
    ExpirationDate TIMESTAMP,
    Status NUMBER(1) CHECK (Status IN (0, 1)) NOT NULL,
    MemberID VARCHAR2(32),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE
);

CREATE TABLE Menu (
    MenuCode NUMBER(9),
    MenuName VARCHAR2(32) NOT NULL,
    Category VARCHAR2(32) NOT NULL,
    Price NUMBER(8) NOT NULL,
    CreationDate TIMESTAMP,
    StoreID NUMBER(9),
    CONSTRAINT PK_Menu PRIMARY KEY (MenuCode, StoreID),
    CONSTRAINT CHK_Price CHECK (Price >= 0),
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID) ON DELETE CASCADE
);

-- TotalReviewCount
CREATE OR REPLACE TRIGGER UpdateTotalReviewCount
AFTER INSERT ON Reviews
FOR EACH ROW
BEGIN
    UPDATE Store
    SET TotalReviewCount = TotalReviewCount + 1
    WHERE StoreID = :NEW.StoreID;
END;
/

-- UpdateTotalRating
CREATE OR REPLACE TRIGGER UpdateTotalRating
AFTER INSERT OR UPDATE ON Reviews
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE Store
        SET TotalRating = TotalRating + :NEW.Rating
        WHERE StoreID = :NEW.StoreID;
    ELSIF UPDATING THEN
        UPDATE Store
        SET TotalRating = TotalRating - :OLD.Rating + :NEW.Rating
        WHERE StoreID = :NEW.StoreID;
    END IF;
END;
/

-- Members 데이터 삽입
INSERT INTO Members (MemberID, Password, PhoneNumber, MemberType, Email, AddressProvince, AddressCity, AddressDistrict, AddressDetail, CreationDate)
VALUES ('Member2', 'pass456', '9876543210', '일반', 'member2@email.com', 'Seoul', 'Mapo', 'Hongdae', '789-012', SYSTIMESTAMP);
INSERT INTO Members (MemberID, Password, PhoneNumber, MemberType, Email, AddressProvince, AddressCity, AddressDistrict, AddressDetail, CreationDate)
VALUES ('Member3', 'pass789', '6543210987', '일반', 'member3@email.com', 'Busan', 'Haeundae', 'Beach', '456-789', SYSTIMESTAMP);
INSERT INTO Members (MemberID, Password, PhoneNumber, MemberType, Email, AddressProvince, AddressCity, AddressDistrict, AddressDetail, CreationDate)
VALUES ('StoreOwner1', 'ownerpass123', '1231231234', '사장', 'owner1@email.com', 'Incheon', 'Bupyeong', 'Central', '321-654', SYSTIMESTAMP);
INSERT INTO Members (MemberID, Password, PhoneNumber, MemberType, Email, AddressProvince, AddressCity, AddressDistrict, AddressDetail, CreationDate)
VALUES ('StoreOwner2', 'ownerpass456', '5675675678', '사장', 'owner2@email.com', 'Daejeon', 'Yuseong', 'Techno', '987-654', SYSTIMESTAMP);
INSERT INTO Members (MemberID, Password, PhoneNumber, MemberType, Email, AddressProvince, AddressCity, AddressDistrict, AddressDetail, CreationDate)
VALUES ('Member4', 'pass999', '9998887777', '일반', 'member4@email.com', 'Gyeonggi', 'Suwon', 'City', '222-333', SYSTIMESTAMP);

INSERT INTO Members (MemberID, Password, PhoneNumber, MemberType, Email, AddressProvince, AddressCity, AddressDistrict, AddressDetail, CreationDate)
VALUES ('Member5', 'pass789', '6543210987', '일반', 'member5@email.com', 'Seoul', 'Yeongdeungpo', 'City', '119-012', SYSTIMESTAMP);
INSERT INTO Members (MemberID, Password, PhoneNumber, MemberType, Email, AddressProvince, AddressCity, AddressDistrict, AddressDetail, CreationDate)
VALUES ('Member6', 'pass999', '9998887777', '일반', 'member6@email.com', 'Busan', 'Gwanganli', 'Beach', '906-789', SYSTIMESTAMP);
INSERT INTO Members (MemberID, Password, PhoneNumber, MemberType, Email, AddressProvince, AddressCity, AddressDistrict, AddressDetail, CreationDate)
VALUES ('StoreOwner3', 'ownerpass123', '1231231234', '사장', 'owner3@email.com', 'Incheon', 'Bupyeong', 'Triple', '891-654', SYSTIMESTAMP);
INSERT INTO Members (MemberID, Password, PhoneNumber, MemberType, Email, AddressProvince, AddressCity, AddressDistrict, AddressDetail, CreationDate)
VALUES ('StoreOwner4', 'ownerpass456', '5675675678', '사장', 'owner4@email.com', 'Jeollado', 'Yeosu', 'Beach', '117-654', SYSTIMESTAMP);
INSERT INTO Members (MemberID, Password, PhoneNumber, MemberType, Email, AddressProvince, AddressCity, AddressDistrict, AddressDetail, CreationDate)
VALUES ('Member7', 'pass123', '1112223334', '일반', 'member7@email.com', 'Gyeonggi', 'Paju', 'Guemrung', '112-123', SYSTIMESTAMP);

-- Store 데이터 삽입
INSERT INTO Store (StoreID, StoreName, AddressProvince, AddressCity, AddressDistrict, AddressDetail, PhoneNumber, Introduction, MinOrderCost, CreationDate)
VALUES (2, 'Store2', 'Seoul', 'Mapo', 'Hongdae', '789-012', '1234567890', 'Welcome to Store2!', 12000, SYSTIMESTAMP);
INSERT INTO Store (StoreID, StoreName, AddressProvince, AddressCity, AddressDistrict, AddressDetail, PhoneNumber, Introduction, MinOrderCost, CreationDate)
VALUES (3, 'Store3', 'Busan', 'Haeundae', 'Beach', '456-789', '9876543210', 'Welcome to Store3!', 15000, SYSTIMESTAMP);
INSERT INTO Store (StoreID, StoreName, AddressProvince, AddressCity, AddressDistrict, AddressDetail, PhoneNumber, Introduction, MinOrderCost, CreationDate)
VALUES (4, 'Store4', 'Incheon', 'Bupyeong', 'Central', '321-654', '1112223334', 'Welcome to Store4!', 8000, SYSTIMESTAMP);
INSERT INTO Store (StoreID, StoreName, AddressProvince, AddressCity, AddressDistrict, AddressDetail, PhoneNumber, Introduction, MinOrderCost, CreationDate)
VALUES (5, 'Store5', 'Daejeon', 'Yuseong', 'Techno', '987-654', '5556667778', 'Welcome to Store5!', 10000, SYSTIMESTAMP);
INSERT INTO Store (StoreID, StoreName, AddressProvince, AddressCity, AddressDistrict, AddressDetail, PhoneNumber, Introduction, MinOrderCost, CreationDate)
VALUES (6, 'Store6', 'Gyeonggi', 'Suwon', 'City', '222-333', '9998887777', 'Welcome to Store6!', 9000, SYSTIMESTAMP);

INSERT INTO Store (StoreID, StoreName, AddressProvince, AddressCity, AddressDistrict, AddressDetail, PhoneNumber, Introduction, MinOrderCost, CreationDate)
VALUES (7, 'Store7', 'Seoul', 'Yeongdeungpo', 'City', '119-012', '1234567890', 'Welcome to Store7!', 12000, SYSTIMESTAMP);
INSERT INTO Store (StoreID, StoreName, AddressProvince, AddressCity, AddressDistrict, AddressDetail, PhoneNumber, Introduction, MinOrderCost, CreationDate)
VALUES (8, 'Store8', 'Busan', 'Gwanganli', 'Beach', '906-789', '2343443210', 'Welcome to Store8!', 15000, SYSTIMESTAMP);
INSERT INTO Store (StoreID, StoreName, AddressProvince, AddressCity, AddressDistrict, AddressDetail, PhoneNumber, Introduction, MinOrderCost, CreationDate)
VALUES (9, 'Store9', 'Incheon', 'Bupyeong', 'Triple', '891-654', '3453423334', 'Welcome to Store9!', 8000, SYSTIMESTAMP);
INSERT INTO Store (StoreID, StoreName, AddressProvince, AddressCity, AddressDistrict, AddressDetail, PhoneNumber, Introduction, MinOrderCost, CreationDate)
VALUES (10, 'Store10', 'Jeollado', 'Yeosu', 'Beach', '117-654', '9999997778', 'Welcome to Store10!', 10000, SYSTIMESTAMP);
INSERT INTO Store (StoreID, StoreName, AddressProvince, AddressCity, AddressDistrict, AddressDetail, PhoneNumber, Introduction, MinOrderCost, CreationDate)
VALUES (11, 'Store11', 'Gyeonggi', 'Paju', 'Guemrung', '112-123', '1298887777', 'Welcome to Store11!', 9000, SYSTIMESTAMP);

-- Reviews 데이터 삽입
INSERT INTO Reviews (ReviewID, Rating, Content, CreationDate, MemberID, StoreID)
VALUES (2, 5, 'Excellent service!', SYSTIMESTAMP, 'Member2', 2);
INSERT INTO Reviews (ReviewID, Rating, Content, CreationDate, MemberID, StoreID)
VALUES (3, 3, 'Pasta Yummy!!!!', SYSTIMESTAMP, 'Member3', 3);
INSERT INTO Reviews (ReviewID, Rating, Content, CreationDate, MemberID, StoreID)
VALUES (4, 4, 'Great place to hang out!', SYSTIMESTAMP, 'Member4', 4);
INSERT INTO Reviews (ReviewID, Rating, Content, CreationDate, MemberID, StoreID)
VALUES (5, 2, 'Disappointed with the food quality.', SYSTIMESTAMP, 'Member2', 5);
INSERT INTO Reviews (ReviewID, Rating, Content, CreationDate, MemberID, StoreID)
VALUES (6, 5, 'Amazing food and friendly staff!', SYSTIMESTAMP, 'Member3', 6);

INSERT INTO Reviews (ReviewID, Rating, Content, CreationDate, MemberID, StoreID)
VALUES (7, 4, 'JJAJANG GOOD!', SYSTIMESTAMP, 'Member5', 7);
INSERT INTO Reviews (ReviewID, Rating, Content, CreationDate, MemberID, StoreID)
VALUES (8, 2, 'Not satisfied with the service.', SYSTIMESTAMP, 'Member6', 8);
INSERT INTO Reviews (ReviewID, Rating, Content, CreationDate, MemberID, StoreID)
VALUES (9, 5, 'Fantastic food and atmosphere!', SYSTIMESTAMP, 'Member7', 9);
INSERT INTO Reviews (ReviewID, Rating, Content, CreationDate, MemberID, StoreID)
VALUES (10, 3, 'Average place, could be better.', SYSTIMESTAMP, 'Member5', 10);
INSERT INTO Reviews (ReviewID, Rating, Content, CreationDate, MemberID, StoreID)
VALUES (11, 5, 'Love the menu variety!', SYSTIMESTAMP, 'Member6', 11);

-- Membership 데이터 삽입
INSERT INTO Membership (MembershipCode, Grade, CreationDate, ExpirationDate, Status, MemberID)
VALUES (1000, '브론즈', SYSTIMESTAMP, NULL, 1, 'Member2');
INSERT INTO Membership (MembershipCode, Grade, CreationDate, ExpirationDate, Status, MemberID)
VALUES (1001, '실버', SYSTIMESTAMP, NULL, 1, 'Member3');
INSERT INTO Membership (MembershipCode, Grade, CreationDate, ExpirationDate, Status, MemberID)
VALUES (1002, '골드', SYSTIMESTAMP, SYSTIMESTAMP, 0, 'Member4');
INSERT INTO Membership (MembershipCode, Grade, CreationDate, ExpirationDate, Status, MemberID)
VALUES (1003, '브론즈', SYSTIMESTAMP, NULL, 1, 'StoreOwner1');
INSERT INTO Membership (MembershipCode, Grade, CreationDate, ExpirationDate, Status, MemberID)
VALUES (1004, '골드', SYSTIMESTAMP, NULL, 1, 'StoreOwner2');

INSERT INTO Membership (MembershipCode, Grade, CreationDate, ExpirationDate, Status, MemberID)
VALUES (106, '브론즈', SYSTIMESTAMP, NULL, 1, 'Member5');
INSERT INTO Membership (MembershipCode, Grade, CreationDate, ExpirationDate, Status, MemberID)
VALUES (107, '실버', SYSTIMESTAMP, NULL, 0, 'Member6');
INSERT INTO Membership (MembershipCode, Grade, CreationDate, ExpirationDate, Status, MemberID)
VALUES (108, '골드', SYSTIMESTAMP, NULL, 1, 'Member7');
INSERT INTO Membership (MembershipCode, Grade, CreationDate, ExpirationDate, Status, MemberID)
VALUES (109, '브론즈', SYSTIMESTAMP, NULL, 0, 'StoreOwner3');
INSERT INTO Membership (MembershipCode, Grade, CreationDate, ExpirationDate, Status, MemberID)
VALUES (110, '골드', SYSTIMESTAMP, NULL, 1, 'StoreOwner4');

-- Menu 데이터 삽입
INSERT INTO Menu (MenuCode, MenuName, Category, Price, CreationDate, StoreID)
VALUES (101, 'Bibimbap', 'Korean', 12000, SYSTIMESTAMP, 2);
INSERT INTO Menu (MenuCode, MenuName, Category, Price, CreationDate, StoreID)
VALUES (102, 'Seafood Pasta', 'Italian', 8000, SYSTIMESTAMP, 3);
INSERT INTO Menu (MenuCode, MenuName, Category, Price, CreationDate, StoreID)
VALUES (103, 'Kimchi Fried Rice', 'Korean', 8000, SYSTIMESTAMP, 4);
INSERT INTO Menu (MenuCode, MenuName, Category, Price, CreationDate, StoreID)
VALUES (104, 'Sushi Combo', 'Japanese', 10000, SYSTIMESTAMP, 5);
INSERT INTO Menu (MenuCode, MenuName, Category, Price, CreationDate, StoreID)
VALUES (105, 'Chicken Curry', 'Indian', 9000, SYSTIMESTAMP, 6);

INSERT INTO Menu (MenuCode, MenuName, Category, Price, CreationDate, StoreID)
VALUES (106, 'JJAJANG', 'Chinese', 9000, SYSTIMESTAMP, 7);
INSERT INTO Menu (MenuCode, MenuName, Category, Price, CreationDate, StoreID)
VALUES (102, 'JJAMBBONG', 'Chinese', 10000, SYSTIMESTAMP, 7);
INSERT INTO Menu (MenuCode, MenuName, Category, Price, CreationDate, StoreID)
VALUES (108, 'Spicy Ramen', 'Japanese', 8500, SYSTIMESTAMP, 8);
INSERT INTO Menu (MenuCode, MenuName, Category, Price, CreationDate, StoreID)
VALUES (104, 'Normal Ramen', 'Japanese', 10000, SYSTIMESTAMP, 8);
INSERT INTO Menu (MenuCode, MenuName, Category, Price, CreationDate, StoreID)
VALUES (105, 'Sushi', 'Japanese', 9000, SYSTIMESTAMP, 8);

-- 조회
SELECT * FROM Members ORDER BY MemberID ASC;
SELECT * FROM Store ORDER BY StoreID ASC;
SELECT * FROM Reviews ORDER BY ReviewID ASC;
SELECT * FROM Membership ORDER BY MembershipCode ASC;
SELECT * FROM Menu ORDER BY StoreID ASC;

-- 검색
-- 1)
SELECT * 
FROM Membership 
WHERE ExpirationDate IS NULL AND Status = 0;

-- 2)
SELECT * 
FROM Membership 
WHERE Grade = '골드' AND Status = 1;

-- 3)
SELECT MenuCode, MenuName 
FROM Menu 
WHERE Price <= 10000;

-- 4)
SELECT s.StoreID, s.StoreName, s.AddressProvince
FROM Store s
JOIN (
    SELECT StoreID
    FROM Menu
    GROUP BY StoreID
    HAVING COUNT(*) >= 2
) m ON s.StoreID = m.StoreID;

-- 5)
SELECT m.MenuName
FROM Menu m
JOIN Store s ON m.StoreID = s.StoreID
WHERE s.AddressProvince = 'Seoul';

-- 6)
SELECT MemberID
FROM Members
WHERE MemberType = '사장';

-- 7)
SELECT Introduction
FROM Store
WHERE MinOrderCost >= 14000;

-- 8)
SELECT AddressProvince, AddressCity, AddressDistrict, AddressDetail
FROM Store
WHERE AddressProvince = 'Gyeonggi';

-- 9)
SELECT MemberID
FROM Reviews
WHERE Rating = 5;

-- 10)
SELECT DISTINCT m.MenuName, r.Content
FROM Menu m
JOIN Store s ON m.StoreID = s.StoreID
JOIN Reviews r ON s.StoreID = r.StoreID
WHERE m.Category = 'Italian';

-- 입력
-- 1)
INSERT INTO Members (MemberID, Password, PhoneNumber, MemberType, Email, AddressProvince, AddressCity, AddressDistrict, AddressDetail, CreationDate)
VALUES ('NewMember', 'newpass123', '9876543210', '일반', 'newmember@email.com', 'Seoul', 'Gangnam', 'Apgujeong', '123-456', SYSTIMESTAMP);

-- 2)
INSERT INTO Store (StoreID, StoreName, AddressProvince, AddressCity, AddressDistrict, AddressDetail, PhoneNumber, Introduction, MinOrderCost, CreationDate)
VALUES (12, 'NewStore', 'Seoul', 'Gangnam', 'Nonhyeon', '789-012', '1234567890', 'Welcome to NewStore!', 12000, SYSTIMESTAMP);

-- 3)
INSERT INTO Reviews (ReviewID, Rating, Content, CreationDate, MemberID, StoreID)
VALUES (99, 4, 'A new positive review!', SYSTIMESTAMP, 'NewMember', 12);

-- 4)
INSERT INTO Menu (MenuCode, MenuName, Category, Price, CreationDate, StoreID)
VALUES (999, 'Vegetarian Pizza', 'Italian', 11000, SYSTIMESTAMP, 2);

-- 5)
INSERT INTO Membership (MembershipCode, Grade, CreationDate, ExpirationDate, Status, MemberID)
VALUES (1005, '실버', SYSTIMESTAMP, NULL, 1, 'Member5');

-- 조회
SELECT * FROM Members ORDER BY MemberID ASC;
SELECT * FROM Store ORDER BY StoreID ASC;
SELECT * FROM Reviews ORDER BY ReviewID ASC;
SELECT * FROM Membership ORDER BY MembershipCode ASC;
SELECT * FROM Menu ORDER BY StoreID ASC;

-- 수정
-- 1)
UPDATE Members
SET Email = 'realreal@emaile.com'
WHERE MemberID = 'NewMember';

-- 2)
UPDATE Store
SET Introduction = 'New Introduction', MinOrderCost = 15000
WHERE StoreID = 2;

-- 3)
UPDATE Reviews
SET Content = 'hihihi!!!'
WHERE ReviewID = 2;

-- 4)
UPDATE Menu
SET Price = 5000
WHERE MenuCode = 107 AND StoreID = 2;

-- 5)
UPDATE Membership
SET Grade = '골드'
WHERE MembershipCode = 107;

-- 조회
SELECT * FROM Members ORDER BY MemberID ASC;
SELECT * FROM Store ORDER BY StoreID ASC;
SELECT * FROM Reviews ORDER BY ReviewID ASC;
SELECT * FROM Membership ORDER BY MembershipCode ASC;
SELECT * FROM Menu ORDER BY StoreID ASC;

-- 삭제
-- 1)
DELETE FROM Members
WHERE MemberID = 'Member3';

-- 2)
DELETE FROM Store
WHERE StoreID = 3;

-- 3)
DELETE FROM Reviews
WHERE ReviewID = 3;

-- 4)
DELETE FROM Menu
WHERE MenuCode = 103 AND StoreID = 4;

-- 5)
DELETE FROM Membership
WHERE MembershipCode = 1002;

-- 조회
SELECT * FROM Members ORDER BY MemberID ASC;
SELECT * FROM Store ORDER BY StoreID ASC;
SELECT * FROM Reviews ORDER BY ReviewID ASC;
SELECT * FROM Membership ORDER BY MembershipCode ASC;
SELECT * FROM Menu ORDER BY StoreID ASC;
