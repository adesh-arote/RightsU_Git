using Dapper;
using RightsU.Audit.DAL.Infrastructure;
using RightsU.Audit.Entities.MasterEntities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.Audit.DAL.Repository
{
    public class ProcedureRepositories : ProcRepository
    {
        //public IEnumerable<USPInsertLog> USPInsertLog(string ApplicationName, string RequestId, string User, string RequestUri, string RequestMethod, string Method, string IsSuccess, string TimeTaken, string RequestContent, string RequestLength, string RequestDateTime, string ResponseContent, string ResponseLength, string ResponseDateTime, string HttpStatusCode, string HttpStatusDescription, string AuthenticationKey, string UserAgent, string ServerName, string ClientIpAddress)
        //{
        //    var param = new DynamicParameters();
        //    param.Add("@ApplicationName", ApplicationName);
        //    param.Add("@RequestId", RequestId);
        //    param.Add("@UserId", User);
        //    param.Add("@RequestUri", RequestUri);
        //    param.Add("@RequestMethod", RequestMethod);
        //    param.Add("@Method", Method);
        //    param.Add("@IsSuccess", IsSuccess);
        //    param.Add("@TimeTaken", TimeTaken);
        //    param.Add("@RequestContent", RequestContent);
        //    param.Add("@RequestLength", RequestLength);
        //    param.Add("@RequestDateTime", RequestDateTime);
        //    param.Add("@ResponseContent", ResponseContent);
        //    param.Add("@ResponseLength ", ResponseLength);
        //    param.Add("@ResponseDateTime ", ResponseDateTime);
        //    param.Add("@HttpStatusCode", HttpStatusCode);
        //    param.Add("@HttpStatusDescription", HttpStatusDescription);
        //    param.Add("@AuthenticationKey", AuthenticationKey);
        //    param.Add("@UserAgent", UserAgent);
        //    param.Add("@ServerName", ServerName);
        //    param.Add("@ClientIpAddress", ClientIpAddress);



        //    return base.ExecuteSQLProcedure<USPInsertLog>("USPInsertLog", param);
        //}



        //public IEnumerable<USPLGGetLog> USPLGGetLog(string ApplicationId, string MethodName, string RequestFromDate, string RequestToDate, string ResponseFromDate, string ResponseToDate, string User, string size, string from)
        //{
        //    var param = new DynamicParameters();

        //    param.Add("@ApplicationId", ApplicationId);

        //    string MType = "";
        //    string[] m;
        //    m = MethodName.Split(',');

        //    foreach (string str in m)
        //    {
        //        if (str != "")
        //            MType = MType + "'" + str.Trim() + "',";
        //    }
        //    MType = MType.TrimEnd(new Char[] { ',' });

        //    param.Add("@MethodName", MType);
        //    param.Add("@RequestFromDate", RequestFromDate);
        //    param.Add("@RequestToDate", RequestToDate);
        //    param.Add("@ResponseFromDate", ResponseFromDate);
        //    param.Add("@ResponseToDate", ResponseToDate);
        //    param.Add("@User", User);
        //    param.Add("@size", size);
        //    param.Add("@from", from);

        //    return ExecuteSQLProcedure<USPLGGetLog>("USPLGGetLog", param);
        //}


        //public IEnumerable<USPGetMasters> USPGetMasters()
        //{
        //    var param = new DynamicParameters();


        //    return base.ExecuteSQLProcedure<USPGetMasters>("USPGetMasters", param);
        //}

        public Int32 InsertAuditLog(Int32 moduleCode,Int32 intCode,string logData,string actionBy,Int32 actionOn,string actionType)
        {
            Int32 Audit_Log_Code = 0;
            var param = new DynamicParameters();
            param.Add("@moduleCode", moduleCode);
            param.Add("@intCode", intCode);
            param.Add("@logData", logData);
            param.Add("@actionBy", actionBy);
            param.Add("@actionOn", actionOn);
            param.Add("@actionType", actionType);

            var identity = base.ExecuteScalar("USP_Insert_AuditLog", param);
            Audit_Log_Code = Convert.ToInt32(identity);
            return Audit_Log_Code;
        }

        public AuditLogReturn GetAuditLogList(string order, string sort, Int32 size, Int32 page, Int32 requestFrom, Int32 requestTo, Int32 moduleCode, string searchValue, string user, string userAction, string includePrevAuditVesion)
        {
            AuditLogReturn ObjAuditLogReturn = new AuditLogReturn();

            var param = new DynamicParameters();
            param.Add("@order", order);
            param.Add("@page", page);
            param.Add("@search_value", searchValue);
            param.Add("@size", size);
            param.Add("@sort", sort);
            param.Add("@requestFrom", requestFrom);
            param.Add("@requestTo", requestTo);
            param.Add("@moduleCode", moduleCode);
            param.Add("@user", user);
            param.Add("@userAction", userAction);
            param.Add("@includePrevAuditVesion", includePrevAuditVesion);
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            ObjAuditLogReturn.auditData = base.ExecuteSQLProcedure<string>("USP_AuditLog_List", param).ToList();
            ObjAuditLogReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjAuditLogReturn;
        }
    }
}
