
-- Declare and set variables for loop
Declare
@StartDate datetime,
@EndDate datetime,
@Date datetime
 
Set @StartDate = '1950-01-01 00:00:00.000'
Set @EndDate = '2050-12-31 00:00:00.000'
Set @Date = @StartDate
 
-- Loop through dates
WHILE @Date <=@EndDate
BEGIN
   
    -- Insert record in dimension table
    INSERT Into Student.Calender
    (
    DateID,
    Date,
	Day_Number,
	Week_Day,
    Week_Number,
    [Month_Name],
    Month_Number,
	[Year] 
	)
    SELECT
    CAST(CAST(DATEPART(YEAR,@Date) AS varchar(4)) + CASE WHEN CAST(DATEPART(MONTH,@Date) AS varchar(2)) <10 THEN '0'+CAST(DATEPART(MONTH,@Date) AS varchar(2)) ELSE CAST(DATEPART(MONTH,@Date) AS varchar(2)) END + CASE WHEN CAST(CAST(DATEPART(DD,@Date) AS varchar(2)) AS INT) < 10 THEN '0'+CAST(DATEPART(DD,@Date) AS varchar(2))  ELSE CAST(DATEPART(DD,@Date) AS varchar(2)) END AS INT), 
    @Date, -- See links for 105 explanation
	DATEPART(DD,@Date),
	DATENAME(WEEKDAY,@Date),
	DATEPART(wk, @Date),
	DATENAME(mm, @Date),
	DATEPART(mm, @Date),
	Year(@Date)
 
    -- Goto next day
    Set @Date = DATEADD(DD,1,@Date)
END


SELECT * FROM Student.Calender