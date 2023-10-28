using Dapper;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL
{
    #region -------- System Parameter -----------
    public class SystemParametersRepositories : MainRepository<System_Parameter_New>
    {
        public IEnumerable<System_Parameter_New> SearchFor(object param)
        {
            return base.SearchForEntity<System_Parameter_New>(param);
        }
        public IEnumerable<System_Parameter_New> GetAll()
        {
            return base.GetAll<System_Parameter_New>();
        }
    }
    #endregion

    #region -------- BMS_Log -----------
    public class BMS_Log_Repositories : MainRepository<BMS_Log>
    {
        public IEnumerable<BMS_Log> SearchFor(object param)
        {
            return base.SearchForEntity<BMS_Log>(param);
        }
        public IEnumerable<BMS_Log> GetAll()
        {
            return base.GetAll<BMS_Log>();
        }

        public Int32 InsertBMSLog(BMS_Log objParam)
        {
            Int32 BMS_Log_Code = 0;
            var param = new DynamicParameters();
            param.Add("@moduleName", objParam.Module_Name);
            param.Add("@methodType", objParam.Method_Type);
            param.Add("@requestTime", objParam.Request_Time);
            param.Add("@responseTime", objParam.Response_Time);
            param.Add("@requestXML", objParam.Request_Xml);
            param.Add("@responseXML", objParam.Response_Xml);
            param.Add("@recordStatus", objParam.Record_Status);
            param.Add("@errorDescription", objParam.Error_Description);
            var identity = base.ExecuteScalar("USP_BMS_Insert_Log", param);
            BMS_Log_Code = Convert.ToInt32(identity);
            return BMS_Log_Code;
        }
    }
    #endregion
}
