CREATE Procedure [dbo].[USPLogSQLSteps](@RequestMethod varchar(200), @RequestId varchar(50), @TimeTaken float, @RequestContent varchar(max), @UserId int, @AuthenticationKey varchar(200))
As
Begin
	   Declare @Method varchar(20)='SQL SP', @ApplicationId int = 1, @IsSuccess int = 1, @UserAgent varchar(10) = 'SQL',@ServerName varchar(20) ='192.168.0.115', @ClientIpAddress varchar(50)
    
	   insert into RUSQLLog([ApplicationId],[RequestId], [UserId], [RequestUri], [RequestMethod], [Method], [IsSuccess], [TimeTaken], [RequestContent], [RequestLength],
       [RequestDateTime],[ResponseContent],[ResponseLength],[ResponseDateTime],[HttpStatusCode],[HttpStatusDescription],[AuthenticationKey],[UserAgent],[ServerName],[ClientIpAddress])
	   values(@ApplicationId,@RequestId, @UserId,'',@RequestMethod,@Method, @IsSuccess, @TimeTaken, @RequestContent, 
	   LEN(@RequestContent),getdate(),'',0,getdate(),0,'', @AuthenticationKey, @UserAgent, @ServerName, @ClientIpAddress)
End