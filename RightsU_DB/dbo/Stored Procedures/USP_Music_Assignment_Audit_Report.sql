CREATE PROCEDURE [dbo]. [USP_Music_Assignment_Audit_Report]
@User_Id varchar(100),    
@Date_From varchar(50),    
@Date_To varchar(50)    
AS     
BEGIN    
   SELECT       
   convert(datetime,REPLACE(CONVERT(VARCHAR(11),CAST(CML.Inserted_On as date),106), ' ', '-'),120) AS CONTENT_DATE,       
   FORMAT(CONVERT(DATE,CML.Inserted_On,103), 'dddd') AS CONTENT_DAY,      
   U.Login_Name AS USERS_NAME, COUNT(CML.Music_Title_Code) AS Total_Count       
  FROM Content_Music_Link CML      
   INNER JOIN Users U  ON CML.Inserted_By = U.Users_Code      
  WHERE       
  (((@Date_From <> '' AND CONVERT(DATE, CML.Inserted_On,103) >= CONVERT(DATE, @Date_From,103)) OR @Date_From = '')      
   AND ((@Date_To <> '' AND CONVERT(DATE,CML.Inserted_On,103) <= CONVERT(DATE,@Date_To,103)) OR @Date_To = ''))      
   AND ((CML.Inserted_By IN((SELECT NUMBER FROM DBO.fn_Split_withdelemiter(@User_Id, ',') WHERE NUMBER <> ''))  AND @User_Id<>'')
      OR 
     @User_Id = '')  
  GROUP BY  convert(datetime,REPLACE(CONVERT(VARCHAR(11),CAST(CML.Inserted_On as date),106), ' ', '-'),120) ,  
  U.Login_Name, FORMAT(CONVERT(DATE,CML.Inserted_On,103), 'dddd')
END
GO

