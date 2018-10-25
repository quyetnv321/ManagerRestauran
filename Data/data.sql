GO
CREATE DATABASE ManageRestaurant ON  PRIMARY 
( Name = N'QuanLyQuanCafe', FILEName = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\ManageRestaurant.mdf' , SIZE = 2304KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( Name = N'QuanLyQuanCafe_log', FILEName = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\ManageRestaurantQuanLyQuanCafe_log.LDF' , SIZE = 576KB , MAXSIZE = 2048GB , FILEGROWTH = 10%);

GO
USE ManageRestaurant;

GO
CREATE TABLE Account(
	UserName nvarchar(100) NOT NULL,
	DisplayName nvarchar(100) NOT NULL DEFAULT (N'cac'),
	PassWord nvarchar(1000) NOT NULL  DEFAULT ((0)),
	Type int NOT NULL DEFAULT ((0)),
	Id int IdENTITY(1,1) PRIMARY KEY
)
GO
 CREATE TABLE TableFood(
	Id int IdENTITY(1,1) PRIMARY KEY,
	Name nvarchar(100) NOT NULL DEFAULT (N'Bàn chưa có tên'),
	Status nvarchar(100) NOT NULL DEFAULT (N'Trống'),
	FOREIGN KEY(Id)
	REFERENCES TableFood (Id)
)
GO
CREATE TABLE FoodCategory(
	Id int IdENTITY(1,1) PRIMARY KEY ,
	Name nvarchar(100) NOT NULL DEFAULT (N'Chưa đặt tên'),
)

GO
CREATE TABLE Bill(
	Id int IdENTITY(1,1) PRIMARY KEY,
	DateCheckIn date NOT NULL DEFAULT (getdate()),
	DateCheckOut date NULL,
	IdTable int NOT NULL,
	Status int NOT NULL DEFAULT ((0)),
	Discount int NULL,
	totalPrice float NULL
)
GO
CREATE TABLE Food(
	Id int IdENTITY(1,1) PRIMARY KEY,
	Name nvarchar(100) NOT NULL,
	IdCategory int NOT NULL,
	Price float NOT NULL DEFAULT ((0)),
	FOREIGN KEY(IdCategory)
	REFERENCES FoodCategory(Id)
)
GO
CREATE TABLE BillInfo(
	Id int IdENTITY(1,1) PRIMARY KEY,
	IdBill int NOT NULL,
	IdFood int NOT NULL,
	count int NOT NULL DEFAULT ((0)),
	FOREIGN KEY(IdFood)
	REFERENCES Food (Id),
	FOREIGN KEY(IdBill)
	REFERENCES Bill (Id)
)
GO
INSERT Account (UserName, DisplayName, PassWord, Type) VALUES (N'Admin', N'Admin', N'1962026656160185351301320480154111117132155', 1)
INSERT Account (UserName, DisplayName, PassWord, Type) VALUES (N'staff', N'staff', N'1962026656160185351301320480154111117132155', 0)
INSERT Account (UserName, DisplayName, PassWord, Type) VALUES (N'Lapvu', N'Lapvu', N'1962026656160185351301320480154111117132155', 0)
GO
INSERT Food ( Name, IdCategory, Price) VALUES (N'Mực một nắng nước sa tế', 1, 120000)
INSERT Food ( Name, IdCategory, Price) VALUES (N'Nghêu hấp xả', 1, 50000)
INSERT Food ( Name, IdCategory, Price) VALUES (N'Dú dê nướng sữa', 2, 60000)
INSERT Food ( Name, IdCategory, Price) VALUES (N'Heo rừng nướng muối ớt', 3, 75000)
INSERT Food ( Name, IdCategory, Price) VALUES (N'Cơm chiên mushi', 4, 999999)
INSERT Food ( Name, IdCategory, Price) VALUES (N'7Up', 5, 15000)
INSERT Food ( Name, IdCategory, Price) VALUES (N'Cafe', 5, 12000)

GO
INSERT FoodCategory (Name) VALUES (N'Hải sản')
INSERT FoodCategory (Name) VALUES (N'Nông sản')
INSERT FoodCategory (Name) VALUES (N'Lâm sản')
INSERT FoodCategory (Name) VALUES (N'Sản sản')
INSERT FoodCategory (Name) VALUES (N'Nước')

GO
INSERT TableFood (name, status) VALUES (N'Bàn 0', N'Trống')
INSERT TableFood (name, status) VALUES (N'Bàn 1', N'Trống')
INSERT TableFood (name, status) VALUES (N'Bàn 2', N'Trống')
INSERT TableFood (name, status) VALUES (N'Bàn 3', N'Trống')
INSERT TableFood (name, status) VALUES (N'Bàn 4', N'Trống')
INSERT TableFood (name, status) VALUES (N'Bàn 5', N'Trống')
INSERT TableFood (name, status) VALUES (N'Bàn 6', N'Trống')
INSERT TableFood (name, status) VALUES (N'Bàn 7', N'Trống')
INSERT TableFood (name, status) VALUES (N'Bàn 8', N'Trống')
INSERT TableFood (name, status) VALUES (N'Bàn 9', N'Trống')
INSERT TableFood (name, status) VALUES (N'Bàn 10', N'Trống')

---func----
GO
CREATE FUNCTION fuConvertToUnsign1 ( @strInput NVARCHAR(4000) ) 
RETURNS NVARCHAR(4000) 
AS BEGIN 
IF @strInput IS NULL RETURN @strInput IF @strInput = '' RETURN @strInput DECLARE @RT NVARCHAR(4000) DECLARE @SIGN_CHARS NCHAR(136) DECLARE @UNSIGN_CHARS NCHAR (136) SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' +NCHAR(272)+ NCHAR(208) SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' DECLARE @CountER int DECLARE @CountER1 int SET @CountER = 1 WHILE (@CountER <=LEN(@strInput)) 
BEGIN SET @CountER1 = 1 WHILE (@CountER1 <=LEN(@SIGN_CHARS)+1) 
BEGIN 
	IF UNICODE(SUBSTRING(@SIGN_CHARS, @CountER1,1)) = UNICODE(SUBSTRING(@strInput,@CountER ,1) ) 
BEGIN 
	IF @CountER=1 SET @strInput = SUBSTRING(@UNSIGN_CHARS, @CountER1,1) + SUBSTRING(@strInput, @CountER+1,LEN(@strInput)-1) 
	ELSE SET @strInput = SUBSTRING(@strInput, 1, @CountER-1) +SUBSTRING(@UNSIGN_CHARS, @CountER1,1) + SUBSTRING(@strInput, @CountER+1,LEN(@strInput)- @CountER) BREAK 
END 
	SET @CountER1 = @CountER1 +1 
END 
	SET @CountER = @CountER +1 
END 
	SET @strInput = replace(@strInput,' ','-') RETURN @strInput 
END

GO
CREATE FUNCTION Fnc_GetFCbyId(@id int)
RETURNS table as
RETURN(SELECT * FROM FoodCategory WHERE id = @id)
GO
CREATE FUNCTION Fnc_GetMaxBill()
RETURNS int 
BEGIN
RETURN(SELECT MAX(id) FROM dbo.Bill);
END;
GO
CREATE FUNCTION Fnc_GetBillUnpaid(@id int)
RETURNS table as
RETURN (SELECT * FROM Bill WHERE id=@id AND status=0)
select * from TableFood

---proc---
create proc USP_UpdateTableFood
@Id int , @Status nvarchar(100)
as 
  update TableFood
  set Status = @Status where Id = @Id
GO

CREATE PROC USP_UpdateAccount
@userName NVARCHAR(100), @DisplayName NVARCHAR(100), @Password NVARCHAR(100), @newPassword NVARCHAR(100)
AS
BEGIN
	DECLARE @isRightPass INT = 0
	
	SELECT @isRightPass = COUNT(*) FROM Account WHERE UserName = @userName AND Password = @Password
	
	IF (@isRightPass = 1)
	BEGIN
		IF (@newPassword = NULL OR @newPassword = '')
		BEGIN
			UPDATE Account SET DisplayName = @DisplayName WHERE UserName = @userName
		END		
		ELSE
			UPDATE Account SET DisplayName = @DisplayName, Password = @newPassword WHERE UserName = @userName
	end
END
GO
CREATE PROC USP_Login
@userName nvarchar(100), @passWord nvarchar(100)
AS
BEGIN
	SELECT * FROM Account WHERE UserName = @userName AND PassWord = @passWord
END

GO
CREATE PROC USP_GetAccountByUserName
@userName nvarchar(100)
AS 
BEGIN
	SELECT * FROM Account WHERE UserName = @userName
END

GO
CREATE PROC USP_GetTableList
AS SELECT * FROM TableFood

GO
CREATE PROC USP_GetNumBillByDate
@checkIn date, @checkOut date
AS 
BEGIN
	SELECT COUNT(*)
	FROM Bill AS b,TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.Status = 1
	AND t.Id = b.IdTable
END

GO
CREATE PROC USP_GetListBillByDateForReport
@checkIn date, @checkOut date
AS 
BEGIN
	SELECT t.Name, b.totalPrice, DateCheckIn, DateCheckOut, discount
	FROM Bill AS b,TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.Status = 1
	AND t.Id = b.IdTable
END
GO
CREATE PROC USP_GetListBillByDateAndPage
@checkIn date, @checkOut date, @page int
AS 
BEGIN
	DECLARE @pageRows INT = 10
	DECLARE @selectRows INT = @pageRows
	DECLARE @exceptRows INT = (@page - 1) * @pageRows;
	WITH BillShow AS( SELECT b.Id, t.Name AS 'Tên bàn', b.totalPrice AS 'Tổng tiền', DateCheckIn AS 'Ngày vào', DateCheckOut AS 'Ngày ra', discount AS 'Giảm giá'
	FROM Bill AS b,TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.Status = 1
	AND t.Id = b.IdTable)
	
	SELECT TOP (@selectRows) * FROM BillShow WHERE Id NOT IN (SELECT TOP (@exceptRows) Id FROM BillShow)
END
GO
CREATE PROC USP_GetListBillByDate
@checkIn date, @checkOut date
AS 
BEGIN
	SELECT t.Name AS 'Tên bàn', b.totalPrice AS 'Tổng tiền', DateCheckIn AS 'Ngày vào', DateCheckOut AS 'Ngày ra', discount AS 'Giảm giá'
	FROM Bill AS b,TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.Status = 1
	AND t.Id = b.IdTable
END

GO
CREATE PROC USP_InsertBill
@IdTable INT
AS
BEGIN
	INSERT Bill 
	        ( DateCheckIn ,
	          DateCheckOut ,
	          IdTable ,
	          Status,
	          discount
	        )
	VALUES  ( GETDATE() ,
	          NULL ,
	          @IdTable ,
	          0,
	          0
	        )
END
GO

CREATE PROC USP_SwitchTabel
@IdTable1 INT, @IdTable2 int
AS BEGIN

	DECLARE @IdFirstBill int
	DECLARE @IdSeconrdBill INT
	
	DECLARE @isFirstTablEmty INT = 1
	DECLARE @isSecondTablEmty INT = 1
	
	
	SELECT @IdSeconrdBill = Id FROM Bill WHERE IdTable = @IdTable2 AND Status = 0
	SELECT @IdFirstBill = Id FROM Bill WHERE IdTable = @IdTable1 AND Status = 0
	
	PRINT @IdFirstBill
	PRINT @IdSeconrdBill
	PRINT '-----------'
	
	IF (@IdFirstBill IS NULL)
	BEGIN
		PRINT '0000001'
		INSERT Bill
		        ( DateCheckIn ,
		          DateCheckOut ,
		          IdTable ,
		          Status
		        )
		VALUES  ( GETDATE() ,
		          NULL ,
		          @IdTable1 ,
		          0 
		        )
		        
		SELECT @IdFirstBill = MAX(Id) FROM Bill WHERE IdTable = @IdTable1 AND Status = 0
		
	END
	
	SELECT @isFirstTablEmty = COUNT(*) FROM BillInfo WHERE IdBill = @IdFirstBill
	
	PRINT @IdFirstBill
	PRINT @IdSeconrdBill
	PRINT '-----------'
	
	IF (@IdSeconrdBill IS NULL)
	BEGIN
		PRINT '0000002'
		INSERT Bill
		        ( DateCheckIn ,
		          DateCheckOut ,
		          IdTable ,
		          Status
		        )
		VALUES  ( GETDATE() ,
		          NULL , 
		          @IdTable2 ,
		          0
		        )
		SELECT @IdSeconrdBill = MAX(Id) FROM Bill WHERE IdTable = @IdTable2 AND Status = 0
		
	END
	
	SELECT @isSecondTablEmty = COUNT(*) FROM BillInfo WHERE IdBill = @IdSeconrdBill
	
	PRINT @IdFirstBill
	PRINT @IdSeconrdBill
	PRINT '-----------'

	SELECT Id INTO IdBillInfoTable FROM BillInfo WHERE IdBill = @IdSeconrdBill
	
	UPDATE BillInfo SET IdBill = @IdSeconrdBill WHERE IdBill = @IdFirstBill
	
	UPDATE BillInfo SET IdBill = @IdFirstBill WHERE Id IN (SELECT * FROM IdBillInfoTable)
	
	DROP TABLE IdBillInfoTable
	
	IF (@isFirstTablEmty = 0)
		UPDATE TableFood SET Status = N'Trống' WHERE Id = @IdTable2
		
	IF (@isSecondTablEmty= 0)
		UPDATE TableFood SET Status = N'Trống' WHERE Id = @IdTable1
END
GO
CREATE PROC USP_InsertBillInfo
@IdBill INT, @IdFood INT, @Count INT
AS
BEGIN

	DECLARE @isExitsBillInfo INT
	DECLARE @foodCount INT = 1
	
	SELECT @isExitsBillInfo = Id, @foodCount = b.count 
	FROM BillInfo AS b 
	WHERE IdBill = @IdBill AND IdFood = @IdFood

	IF (@isExitsBillInfo > 0)
	BEGIN
		DECLARE @newCount INT = @foodCount + @Count
		IF (@newCount > 0)
			UPDATE BillInfo	SET count = @foodCount + @Count WHERE IdFood = @IdFood
		ELSE
			DELETE BillInfo WHERE IdBill = @IdBill AND IdFood = @IdFood
	END
	ELSE
	BEGIN
		INSERT	BillInfo
        ( IdBill, IdFood, count )
		VALUES  ( @IdBill,
          @IdFood,
          @Count
          )
	END
END
---view---
CREATE VIEW V_Compare3Table
AS
SELECT f.name, bi.count, f.price, f.price*bi.count AS totalPrice 
FROM BillInfo bi JOIN dbo.Food f
ON bi.idFood = f.id
JOIN Bill b
ON b.id=bi.idBill
WHERE bi.idBill = b.id AND bi.idFood = f.id AND b.status = 0


