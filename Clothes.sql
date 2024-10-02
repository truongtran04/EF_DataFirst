-- Tạo các bảng
-- Bảng Category: Chứa thông tin về danh mục sản phẩm
CREATE TABLE Category (
    CategoryID NVARCHAR(10) PRIMARY KEY NOT NULL, -- Khóa chính cho danh mục
    CategoryName NVARCHAR(50) NOT NULL, -- Tên danh mục
    IsHidden BIT NOT NULL DEFAULT 0 -- Cờ ẩn: 0 = không ẩn, 1 = ẩn
);
GO

-- Bảng ClothingType: Chứa thông tin về loại quần áo
CREATE TABLE ClothingType (
    ClothingTypeID NVARCHAR(10) PRIMARY KEY NOT NULL, -- Khóa chính cho loại quần áo
    ClothingTypeName NVARCHAR(100) NOT NULL, -- Tên loại quần áo
    IsHidden BIT NOT NULL DEFAULT 0 -- Cờ ẩn
);
GO

-- Bảng ClothingStyle: Chứa thông tin về kiểu quần áo
CREATE TABLE ClothingStyle (
    ClothingStyleID NVARCHAR(10) PRIMARY KEY NOT NULL, -- Khóa chính cho kiểu quần áo
    ClothingStyleName NVARCHAR(100) NOT NULL, -- Tên kiểu quần áo
    ClothingTypeID NVARCHAR(10) NOT NULL, -- Khóa ngoại liên kết tới bảng ClothingType
    IsHidden BIT NOT NULL DEFAULT 0, -- Cờ ẩn
    FOREIGN KEY (ClothingTypeID) REFERENCES ClothingType(ClothingTypeID) -- Ràng buộc khóa ngoại
);
GO

-- Bảng Category_ClothingType: Liên kết giữa danh mục và loại quần áo
CREATE TABLE Category_ClothingType (
    CategoryID NVARCHAR(10) NOT NULL, -- Khóa ngoại từ bảng Category
    ClothingTypeID NVARCHAR(10) NOT NULL, -- Khóa ngoại từ bảng ClothingType
    PRIMARY KEY (CategoryID, ClothingTypeID), -- Khóa chính là cặp CategoryID và ClothingTypeID
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID) ON DELETE CASCADE, -- Ràng buộc khóa ngoại
    FOREIGN KEY (ClothingTypeID) REFERENCES ClothingType(ClothingTypeID) ON DELETE CASCADE -- Ràng buộc khóa ngoại
);
GO

-- Bảng Size: Chứa thông tin về kích cỡ sản phẩm
CREATE TABLE Size (
    SizeID NVARCHAR(10) PRIMARY KEY NOT NULL, -- Khóa chính cho kích cỡ
    SizeName NVARCHAR(50) NOT NULL, -- Tên kích cỡ
    IsHidden BIT NOT NULL DEFAULT 0 -- Cờ ẩn
);
GO

-- Bảng Color: Chứa thông tin về màu sắc sản phẩm
CREATE TABLE Color (
    ColorID NVARCHAR(10) PRIMARY KEY NOT NULL, -- Khóa chính cho màu sắc
    ColorName NVARCHAR(50) NOT NULL, -- Tên màu sắc
    IsHidden BIT NOT NULL DEFAULT 0 -- Cờ ẩn
);
GO

-- Bảng Clothes: Chứa thông tin về sản phẩm quần áo
CREATE TABLE Clothes (
    ClothesID NVARCHAR(20) PRIMARY KEY NOT NULL, -- ID tùy biến cho sản phẩm
    ClothesName NVARCHAR(100) NOT NULL, -- Tên sản phẩm, hỗ trợ tiếng Việt
    Price DECIMAL(10, 2) NOT NULL, -- Giá sản phẩm
    PriceSale DECIMAL(10, 2) DEFAULT NULL, -- Giá giảm, có thể để NULL
    Description NVARCHAR(MAX), -- Mô tả sản phẩm
    Fabric NVARCHAR(MAX), -- Loại vải
    UserInstructions NVARCHAR(MAX), -- Hướng dẫn sử dụng
    CreatedAt DATETIME DEFAULT GETDATE(), -- Thời gian tạo
    UpdatedAt DATETIME DEFAULT GETDATE(), -- Thời gian cập nhật
    CategoryID NVARCHAR(10) NOT NULL, -- Khóa ngoại tới bảng Category
    ClothingTypeID NVARCHAR(10) NOT NULL, -- Khóa ngoại tới bảng ClothingType
    ClothingStyleID NVARCHAR(10) NOT NULL, -- Khóa ngoại tới bảng ClothingStyle
    IsDeleted BIT DEFAULT 0, -- Cờ xác định sản phẩm bị ẩn (1 là đã ẩn, 0 là còn hiển thị)
    
    -- Ràng buộc khóa ngoại
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID), -- Ràng buộc khóa ngoại tới Category
    FOREIGN KEY (ClothingTypeID) REFERENCES ClothingType(ClothingTypeID), -- Ràng buộc khóa ngoại tới ClothingType
    FOREIGN KEY (ClothingStyleID) REFERENCES ClothingStyle(ClothingStyleID) -- Ràng buộc khóa ngoại tới ClothingStyle
);
GO

-- Bảng Clothes_Color_Size: Lưu trữ số lượng tồn kho cho từng kết hợp màu sắc và kích cỡ
CREATE TABLE Clothes_Color_Size (
    ClothesID NVARCHAR(20) NOT NULL, -- Khóa ngoại tới bảng Clothes
    ColorID NVARCHAR(10) NOT NULL, -- Khóa ngoại tới bảng Color
    SizeID NVARCHAR(10) NOT NULL, -- Khóa ngoại tới bảng Size
    Quantity INT NOT NULL, -- Số lượng tồn kho
    PRIMARY KEY (ClothesID, ColorID, SizeID), -- Khóa chính là kết hợp cả 3 cột
    FOREIGN KEY (ClothesID) REFERENCES Clothes(ClothesID), -- Ràng buộc khóa ngoại tới Clothes
    FOREIGN KEY (ColorID) REFERENCES Color(ColorID), -- Ràng buộc khóa ngoại tới Color
    FOREIGN KEY (SizeID) REFERENCES Size(SizeID) -- Ràng buộc khóa ngoại tới Size
);
GO

-- Bảng Image: Lưu trữ các hình ảnh về quần áo và màu sắc tương ứng
CREATE TABLE Image (
    ImageID NVARCHAR(30) PRIMARY KEY NOT NULL, -- ID tùy biến cho mỗi ảnh
    ImageName VARCHAR(100) NOT NULL, -- Tên gợi nhớ cho bộ ảnh
    MainImage VARCHAR(255) NOT NULL, -- Ảnh chính của sản phẩm
    SecondaryImage1 VARCHAR(255) NULL, -- Ảnh phụ thứ nhất
    SecondaryImage2 VARCHAR(255) NULL, -- Ảnh phụ thứ hai
    SecondaryImage3 VARCHAR(255) NULL, -- Ảnh phụ thứ ba
    ClothesID NVARCHAR(20) NOT NULL, -- Khóa ngoại liên kết tới bảng Clothes
    ColorID NVARCHAR(10) NOT NULL, -- Khóa ngoại liên kết tới bảng Color
    IsHidden BIT NOT NULL DEFAULT 0, -- Cờ ẩn
    FOREIGN KEY (ClothesID) REFERENCES Clothes(ClothesID), -- Ràng buộc khóa ngoại tới Clothes
    FOREIGN KEY (ColorID) REFERENCES Color(ColorID), -- Ràng buộc khóa ngoại tới Color
    UNIQUE (ClothesID, ColorID) -- Đảm bảo mỗi sản phẩm với một màu chỉ có một bộ ảnh
);
GO

-- Tạo các trigger để tự động tạo ID cho bảng
-- Trigger cho bảng Category: Tự động tạo ID mới và tránh trùng lặp
CREATE TRIGGER trgInsteadOfInsert_Category
ON Category
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @CurrentMaxID NVARCHAR(10);
    SELECT @CurrentMaxID = ISNULL(MAX(CategoryID), 'CAT000') FROM Category;

    DECLARE @NextID INT;
    SET @NextID = CAST(SUBSTRING(@CurrentMaxID, 4, 3) AS INT) + 1;

    DECLARE @NewCategories TABLE (CategoryID NVARCHAR(10), CategoryName NVARCHAR(50), IsHidden BIT);

    INSERT INTO @NewCategories (CategoryID, CategoryName, IsHidden)
    SELECT 
        'CAT' + RIGHT('000' + CAST(@NextID + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS NVARCHAR(3)), 3),
        CategoryName,
        IsHidden
    FROM inserted;

    INSERT INTO Category (CategoryID, CategoryName, IsHidden)
    SELECT CategoryID, CategoryName, IsHidden FROM @NewCategories;
END;
GO

-- Trigger cho bảng ClothingType: Tự động tạo ID mới và tránh trùng lặp
CREATE TRIGGER trgInsteadOfInsert_ClothingType
ON ClothingType
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @CurrentMaxID NVARCHAR(10);
    SELECT @CurrentMaxID = ISNULL(MAX(ClothingTypeID), 'CT000') FROM ClothingType;

    DECLARE @NextID INT;
    SET @NextID = CAST(SUBSTRING(@CurrentMaxID, 3, 3) AS INT) + 1;

    DECLARE @NewClothingTypes TABLE (ClothingTypeID NVARCHAR(10), ClothingTypeName NVARCHAR(100), IsHidden BIT);

    INSERT INTO @NewClothingTypes (ClothingTypeID, ClothingTypeName, IsHidden)
    SELECT 
        'CT' + RIGHT('000' + CAST(@NextID + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS NVARCHAR(3)), 3),
        ClothingTypeName,
        IsHidden
    FROM inserted;

    INSERT INTO ClothingType (ClothingTypeID, ClothingTypeName, IsHidden)
    SELECT ClothingTypeID, ClothingTypeName, IsHidden FROM @NewClothingTypes;
END;
GO

-- Trigger cho bảng ClothingStyle: Tự động tạo ID mới và tránh trùng lặp
CREATE TRIGGER trgInsteadOfInsert_ClothingStyle
ON ClothingStyle
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @CurrentMaxID NVARCHAR(10);
    SELECT @CurrentMaxID = ISNULL(MAX(ClothingStyleID), 'CS000') FROM ClothingStyle;

    DECLARE @NextID INT;
    SET @NextID = CAST(SUBSTRING(@CurrentMaxID, 3, 3) AS INT) + 1;

    DECLARE @NewClothingStyles TABLE (ClothingStyleID NVARCHAR(10), ClothingStyleName NVARCHAR(100), ClothingTypeID NVARCHAR(10), IsHidden BIT);

    INSERT INTO @NewClothingStyles (ClothingStyleID, ClothingStyleName, ClothingTypeID, IsHidden)
    SELECT 
        'CS' + RIGHT('000' + CAST(@NextID + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS NVARCHAR(3)), 3),
        ClothingStyleName,
        ClothingTypeID,
        IsHidden
    FROM inserted;

    INSERT INTO ClothingStyle (ClothingStyleID, ClothingStyleName, ClothingTypeID, IsHidden)
    SELECT ClothingStyleID, ClothingStyleName, ClothingTypeID, IsHidden FROM @NewClothingStyles;
END;
GO

-- Trigger cho bảng Size: Tự động tạo ID mới và tránh trùng lặp
CREATE TRIGGER trgInsteadOfInsert_Size
ON Size
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @CurrentMaxID NVARCHAR(10);
    SELECT @CurrentMaxID = ISNULL(MAX(SizeID), 'S000') FROM Size;

    DECLARE @NextID INT;
    SET @NextID = CAST(SUBSTRING(@CurrentMaxID, 2, 3) AS INT) + 1;

    DECLARE @NewSizes TABLE (SizeID NVARCHAR(10), SizeName NVARCHAR(50), IsHidden BIT);

    INSERT INTO @NewSizes (SizeID, SizeName, IsHidden)
    SELECT 
        'S' + RIGHT('000' + CAST(@NextID + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS NVARCHAR(3)), 3),
        SizeName,
        IsHidden
    FROM inserted;

    INSERT INTO Size (SizeID, SizeName, IsHidden)
    SELECT SizeID, SizeName, IsHidden FROM @NewSizes;
END;
GO

-- Trigger cho bảng Color: Tự động tạo ID mới và tránh trùng lặp
CREATE TRIGGER trgInsteadOfInsert_Color
ON Color
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @CurrentMaxID NVARCHAR(10);
    SELECT @CurrentMaxID = ISNULL(MAX(ColorID), 'C000') FROM Color;

    DECLARE @NextID INT;
    SET @NextID = CAST(SUBSTRING(@CurrentMaxID, 2, 3) AS INT) + 1;

    DECLARE @NewColors TABLE (ColorID NVARCHAR(10), ColorName NVARCHAR(50), IsHidden BIT);

    INSERT INTO @NewColors (ColorID, ColorName, IsHidden)
    SELECT 
        'C' + RIGHT('000' + CAST(@NextID + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS NVARCHAR(3)), 3),
        ColorName,
        IsHidden
    FROM inserted;

    INSERT INTO Color (ColorID, ColorName, IsHidden)
    SELECT ColorID, ColorName, IsHidden FROM @NewColors;
END;
GO

-- Trigger cho bảng Clothes: Tự động tạo ID mới và tránh trùng lặp
CREATE TRIGGER trgInsteadOfInsert_Clothes
ON Clothes
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @NewClothes TABLE 
    (
        RowNum INT,
        ClothesID NVARCHAR(20),
        ClothesName NVARCHAR(100), 
        Price DECIMAL(10, 2), 
        PriceSale DECIMAL(10, 2), 
        Description NVARCHAR(MAX), 
        Fabric NVARCHAR(MAX), 
        UserInstructions NVARCHAR(MAX), 
        CreatedAt DATETIME, 
        UpdatedAt DATETIME, 
        CategoryID NVARCHAR(10), 
        ClothingTypeID NVARCHAR(10), 
        ClothingStyleID NVARCHAR(10), 
        IsDeleted BIT
    );

    DECLARE @ClothingStyleID NVARCHAR(10);
    DECLARE @NextID INT;
    DECLARE @NewClothesID NVARCHAR(20);

    -- Tạo một CTE để tính toán RowNum và lấy thông tin từ bảng inserted
    WITH CTE AS 
    (
        SELECT 
            ROW_NUMBER() OVER (PARTITION BY ClothingStyleID ORDER BY ClothesName) AS RowNum,
            ClothesName, Price, PriceSale, Description, Fabric, UserInstructions, GETDATE() AS CreatedAt, GETDATE() AS UpdatedAt,
            CategoryID, ClothingTypeID, ClothingStyleID, 0 AS IsDeleted
        FROM inserted
    )
    -- Chèn dữ liệu từ CTE vào bảng tạm @NewClothes
    INSERT INTO @NewClothes (RowNum, ClothesName, Price, PriceSale, Description, Fabric, UserInstructions, CreatedAt, UpdatedAt, CategoryID, ClothingTypeID, ClothingStyleID, IsDeleted)
    SELECT RowNum, ClothesName, Price, PriceSale, Description, Fabric, UserInstructions, CreatedAt, UpdatedAt, CategoryID, ClothingTypeID, ClothingStyleID, IsDeleted
    FROM CTE;

    -- Lặp qua từng ClothingStyleID để cập nhật ClothesID
    DECLARE cur CURSOR FOR SELECT DISTINCT ClothingStyleID FROM @NewClothes;
    OPEN cur;
    FETCH NEXT FROM cur INTO @ClothingStyleID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Tìm ID tối đa hiện tại cho ClothingStyleID
        SELECT @NextID = ISNULL(MAX(CAST(SUBSTRING(ClothesID, LEN(@ClothingStyleID) + 5, 3) AS INT)), 0) + 1
        FROM Clothes
        WHERE ClothesID LIKE @ClothingStyleID + '-CLT%';

        -- Cập nhật ClothesID trong bảng tạm @NewClothes với RowNum tương ứng
        UPDATE @NewClothes
        SET ClothesID = @ClothingStyleID + '-CLT' + RIGHT('000' + CAST(@NextID + RowNum - 1 AS NVARCHAR(3)), 3)
        WHERE ClothingStyleID = @ClothingStyleID;

        FETCH NEXT FROM cur INTO @ClothingStyleID;
    END

    CLOSE cur;
    DEALLOCATE cur;

    -- Chèn các bản ghi đã xử lý từ bảng tạm @NewClothes vào bảng Clothes
    INSERT INTO Clothes (ClothesID, ClothesName, Price, PriceSale, Description, Fabric, UserInstructions, CreatedAt, UpdatedAt, CategoryID, ClothingTypeID, ClothingStyleID, IsDeleted)
    SELECT ClothesID, ClothesName, Price, PriceSale, Description, Fabric, UserInstructions, CreatedAt, UpdatedAt, CategoryID, ClothingTypeID, ClothingStyleID, IsDeleted
    FROM @NewClothes;
END;
GO

-- Trigger cho bảng Image: Tự động tạo ID mới và tránh trùng lặp
CREATE TRIGGER trgInsteadOfInsert_Image
ON Image
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @NewImages TABLE 
    (
        ImageID NVARCHAR(30),
        ImageName VARCHAR(100), 
        MainImage VARCHAR(255), 
        SecondaryImage1 VARCHAR(255), 
        SecondaryImage2 VARCHAR(255), 
        SecondaryImage3 VARCHAR(255), 
        ClothesID NVARCHAR(20), 
        ColorID NVARCHAR(10), 
        IsHidden BIT
    );

    -- Lấy dữ liệu từ bảng inserted và chèn vào bảng tạm @NewImages
    INSERT INTO @NewImages (ImageName, MainImage, SecondaryImage1, SecondaryImage2, SecondaryImage3, ClothesID, ColorID, IsHidden)
    SELECT 
        ImageName, MainImage, SecondaryImage1, SecondaryImage2, SecondaryImage3, ClothesID, ColorID, IsHidden
    FROM inserted;

    -- Cập nhật ImageID cho các bản ghi mới
    DECLARE @ClothesID NVARCHAR(20);
    DECLARE @ColorID NVARCHAR(10);
    DECLARE @NextID INT;
    DECLARE @ImageID NVARCHAR(30);

    DECLARE cur CURSOR FOR SELECT DISTINCT ClothesID, ColorID FROM @NewImages;
    OPEN cur;
    FETCH NEXT FROM cur INTO @ClothesID, @ColorID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Tìm ID tối đa hiện tại cho ClothesID và ColorID
        SELECT @NextID = ISNULL(MAX(CAST(SUBSTRING(ImageID, LEN(@ClothesID) + LEN(@ColorID) + 5, 3) AS INT)), 0) + 1
        FROM Image
        WHERE ImageID LIKE @ClothesID + '-' + @ColorID + '-IMG%';

        -- Cập nhật ImageID trong bảng tạm @NewImages
        UPDATE n
        SET ImageID = @ClothesID + '-' + @ColorID + '-IMG' + RIGHT('000' + CAST(@NextID AS NVARCHAR(3)), 3)
        FROM @NewImages n
        WHERE n.ClothesID = @ClothesID AND n.ColorID = @ColorID;

        FETCH NEXT FROM cur INTO @ClothesID, @ColorID;
    END

    CLOSE cur;
    DEALLOCATE cur;

    -- Chèn các bản ghi đã xử lý từ bảng tạm @NewImages vào bảng Image
    INSERT INTO Image (ImageID, ImageName, MainImage, SecondaryImage1, SecondaryImage2, SecondaryImage3, ClothesID, ColorID, IsHidden)
    SELECT ImageID, ImageName, MainImage, SecondaryImage1, SecondaryImage2, SecondaryImage3, ClothesID, ColorID, IsHidden
    FROM @NewImages;
END;
GO

--Thêm dữ liệu vào bảng
-- Thêm dữ liệu vào bảng Category
INSERT INTO Category (CategoryName)
VALUES 
    (N'Nam'),
    (N'Nữ'),
    (N'Bé gái'),
    (N'Bé trai');

-- Thêm dữ liệu vào bảng ClothingType
INSERT INTO ClothingType (ClothingTypeName)
VALUES 
    (N'Áo phông/Áo thun'),
    (N'Áo polo'),
    (N'Áo sơ mi'),
    (N'Áo chống nắng'),
    (N'Canifa Active/Quần áo thể thao'),
    (N'Quần dài & Quần Jean'),
    (N'Quần soóc/Quần short'),
    (N'Quần áo nữ'),
    (N'Quần áo mặc nhà/Đồ ngủ'),
    (N'Áo khoác & Giữ nhiệt'),
    (N'Áo len'),
    (N'Váy'),
    (N'Tất/Vớ'),
    (N'Bộ quần áo');

-- Thêm dữ liệu vào bảng ClothingStyle
INSERT INTO ClothingStyle (ClothingStyleName, ClothingTypeID)
VALUES
    (N'Áo phông basic', 'CT001'),
    (N'Áo phông có hình in', 'CT001'),
    (N'Áo phông in hình bản quyền', 'CT001'),
    (N'Áo ba lỗ', 'CT001'),
    (N'Áo polo trơn', 'CT002'),
    (N'Áo polo phối màu', 'CT002'),
    (N'Áo polo có hình in', 'CT002'),
    (N'Áo sơ mi ngắn tay', 'CT003'),
    (N'Áo sơ mi dài tay', 'CT003'),
    (N'Áo kiểu', 'CT003'),
    (N'Áo chống nắng', 'CT004'),
    (N'Áo active', 'CT005'),
    (N'Quần active', 'CT005'),
    (N'Bộ quần áo active', 'CT005'),
    (N'Quần jeans', 'CT006'),
    (N'Quần khaki', 'CT006'),
    (N'Quần vải', 'CT006'),
    (N'Quần leggings', 'CT006'),
    (N'Quần gió', 'CT006'),
    (N'Quần short jeans', 'CT007'),
    (N'Quần short khaki', 'CT007'),
    (N'Quần short vải', 'CT007'),
    (N'Áo nữ', 'CT008'),
    (N'Áo hoodie', 'CT008'),
    (N'Áo khoác nữ', 'CT008'),
    (N'Áo khoác bomber', 'CT008'),
    (N'Quần nữ', 'CT008'),
    (N'Bộ mặc nhà', 'CT009'),
    (N'Quần mặc nhà', 'CT009'),
    (N'Áo mặc nhà', 'CT009'),
    (N'Pyjama', 'CT009'),
    (N'Giữ nhiệt', 'CT010'),
    (N'Áo khoác gió', 'CT010'),
    (N'Áo khoác chân bông', 'CT010'),
    (N'Áo khoác lông vũ', 'CT010'),
    (N'Blazer', 'CT010'),
    (N'Áo khoác gilet', 'CT010'),
    (N'Cardigan', 'CT010'),
    (N'Áo len', 'CT011'),
    (N'Áo len gilet', 'CT011'),
    (N'Váy liền thân', 'CT012'),
    (N'Chân váy', 'CT012');

-- Thêm dữ liệu vào bảng Size
INSERT INTO Size (SizeName)
VALUES
    (N'26'),
    (N'27'),
    (N'28'),
    (N'29'),
    (N'30'),
    (N'XS'),
    (N'S'),
    (N'M'),
    (N'L'),
    (N'XL'),
    (N'XXL'),
    (N'90'),
    (N'100'),
    (N'104'),
    (N'110'),
    (N'120'),
    (N'130'),
    (N'134'),
    (N'140'),
    (N'150'),
    (N'160');

-- Thêm dữ liệu bảng Color
INSERT INTO Color (ColorName)
VALUES
    (N'Đen'),
    (N'Tráng'),
    (N'Xám'),
    (N'Xám nhạt'),
    (N'Xanh dương'),
    (N'Xanh nước biển'),
    (N'Xanh lá cây'),
    (N'Xanh ngọc'),
    (N'Xanh lá mạ'),
    (N'Đỏ'),
    (N'Đỏ tươi'),
    (N'Đỏ đậm'),
    (N'Cam'),
    (N'Cam đất'),
    (N'Vàng'),
    (N'Vàng nhạt'),
    (N'Nâu'),
    (N'Nâu đậm'),
    (N'Hồng'),
    (N'Hồng nhạt'),
    (N'Hồng đậm'),
    (N'Tím'),
    (N'Tím nhạt'),
    (N'Tím đậm'),
    (N'Bạc'),
    (N'Vàng đồng');

--Thêm dữ liệu vào bảng Clothes
INSERT INTO Clothes (ClothesName, Price, PriceSale, Description, Fabric, UserInstructions, CategoryID, ClothingTypeID, ClothingStyleID)
VALUES 
    (N'Áo phông active nam có hình in', 399000, NULL, N'Áo phông active nam vai zaclang dáng fit vừa người với chất liệu co dãn và thành phần nguyên liệu tạo sự thoáng mát và thoải mái với các hoạt động thể thao.',
    N'87,3% nylon 12,7% spandex.', N'Giặt máy ở chế độ nhẹ, nhiệt độ thường. Không sử dụng chất tẩy. Phơi trong bóng mát. Sấy khô ở nhiệt độ thấp. Là ở nhiệt độ thấp 110 độ C. Giặt với sản phẩm cùng màu. Không là lên chi tiết trang trí.',
    'CAT001', 'CT001', 'CS001'),
	(N'Áo phông nam cotton cổ tròn dáng suông', 99000, NULL, N'Áo phông nam basic dáng regular cổ tròn.',
    N'100% cotton', N'Giặt máy ở chế độ nhẹ, nhiệt độ thường. Không sử dụng chất tẩy. Phơi trong bóng mát. Sấy khô ở nhiệt độ thấp. Là ở nhiệt độ thấp 110 độ C. Giặt với sản phẩm cùng màu. Không là lên chi tiết trang trí.',
    'CAT001', 'CT001', 'CS001'),
	(N'Áo polo nam basic dáng suông', 299000, NULL, N'Áo polo nam basic dáng regular với bảng màu đa dạng, dễ dàng lựa chọn cho nhiều đối tượng khách hàng',
    N'65% cotton 30% polyester 5% spandex.', N'Giặt máy ở chế độ nhẹ, nhiệt độ thường. Không sử dụng chất tẩy. Phơi trong bóng mát. Sấy khô ở nhiệt độ thấp. Là ở nhiệt độ thấp 110 độ C. Giặt với sản phẩm cùng màu. Không là lên chi tiết trang trí.',
    'CAT001', 'CT002', 'CS005');

-- Thêm dữ liệu vào bảng Image
INSERT INTO Image (ImageName, MainImage, SecondaryImage1, SecondaryImage2, SecondaryImage3, ClothesID, ColorID, IsHidden)
VALUES 
(N'Áo phông active nam có hình in', '1', NULL, NULL, NULL, 'CS001-CLT001', 'C001', 0);
