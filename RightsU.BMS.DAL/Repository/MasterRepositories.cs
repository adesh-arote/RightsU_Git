using Dapper;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL
{
    #region -------- User -----------
    public class UserRepositories : MainRepository<User>
    {
        public User Get(int Id)
        {
            var obj = new { Users_Code = Id };

            return base.GetById<User, Users_Password_Detail>(obj);
        }
        public IEnumerable<User> GetAll()
        {
            return base.GetAll<User>();
        }
        public void Update(User entity)
        {
            User oldObj = Get(entity.Users_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public IEnumerable<User> SearchFor(object param)
        {
            return base.SearchForEntity<User, Users_Password_Detail>(param);
        }

        public IEnumerable<User> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<User>(strSQL);
        }
    }
    #endregion

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

    #region -----------------Service Log-----------
    public class ServiceLogRepositories : MainRepository<ServiceLog>
    {
        public void Add(ServiceLog entity)
        {
            base.AddEntity(entity);
        }
        public ServiceLog Get(int Id)
        {
            var obj = new { ServiceLogID = Id };

            return base.GetById<ServiceLog>(obj);
        }
        public IEnumerable<ServiceLog> GetAll()
        {
            return base.GetAll<ServiceLog>();
        }
        public void Update(ServiceLog entity)
        {
            ServiceLog oldObj = Get(entity.ServiceLogID.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public IEnumerable<ServiceLog> SearchFor(object param)
        {
            return base.SearchForEntity<ServiceLog>(param);
        }
    }
    #endregion

    #region -------- Logged In Users  -----------
    public class LoggedInUsersRepository : MainRepository<LoggedInUsers>
    {
        public LoggedInUsers Get(int Id)
        {
            var obj = new { Users_Code = Id };

            return base.GetById<LoggedInUsers>(obj);
        }
        public void Add(LoggedInUsers entity)
        {
            base.AddEntity(entity);
        }
        public void Update(LoggedInUsers entity)
        {
            LoggedInUsers oldObj = Get(entity.LoggedInUsersCode ?? 0);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(LoggedInUsers entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<LoggedInUsers> GetAll()
        {
            return base.GetAll<LoggedInUsers>();
        }
        public IEnumerable<LoggedInUsers> SearchFor(object param)
        {
            return base.SearchForEntity<LoggedInUsers>(param);
        }
    }
    #endregion

    #region -------- System_Module -----------
    public class System_Module_Repositories : MainRepository<System_Module>
    {
        public IEnumerable<System_Module> SearchFor(object param)
        {
            return base.SearchForEntity<System_Module>(param);
        }
        public IEnumerable<System_Module> GetAll()
        {
            return base.GetAll<System_Module>();
        }
        public List<System_Module> USP_GetModule(Int32 Security_Group_Code, Int32 Users_Code)
        {
            List<System_Module> ObjModule = new List<System_Module>();

            var param = new DynamicParameters();
            param.Add("@SecurityGroupCode", Security_Group_Code);
            param.Add("@IsSuperAdmin", "Y");
            param.Add("@Users_Code", Users_Code);
            ObjModule = base.ExecuteSQLProcedure<System_Module>("USP_GetMenu", param).ToList();
            return ObjModule;
        }
    }
    #endregion

    #region -------- Role -----------
    public class RoleRepositories : MainRepository<Role>
    {
        public RoleReturn GetRole_List(string order, Int32 page, string search_value, Int32 size, string sort, Int32 id)
        {
            RoleReturn ObjRoleReturn = new RoleReturn();

            var param = new DynamicParameters();
            param.Add("@order", order);
            param.Add("@page", page);
            param.Add("@search_value", search_value);
            param.Add("@size", size);
            param.Add("@sort", sort);
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            ObjRoleReturn.assets = base.ExecuteSQLProcedure<Role>("USPAPI_Role_List", param).ToList();
            ObjRoleReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjRoleReturn;
        }
    }
    #endregion

    #region -------- DealType -----------
    public class DealTypeRepositories : MainRepository<dealType>
    {
        public Deal_TypeReturn GetDealType_List(string order, Int32 page, string search_value, Int32 size, string sort, string Date_GT, string Date_LT, Int32 id)
        {
            Deal_TypeReturn ObjDealTypeReturn = new Deal_TypeReturn();

            var param = new DynamicParameters();
            param.Add("@order", order);
            param.Add("@page", page);
            param.Add("@search_value", search_value);
            param.Add("@size", size);
            param.Add("@sort", sort);
            param.Add("@date_gt", Date_GT);
            param.Add("@date_lt", Date_LT);
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            ObjDealTypeReturn.assets = base.ExecuteSQLProcedure<dealType>("[USPAPI_Deal_Type]", param).ToList();
            ObjDealTypeReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjDealTypeReturn;
        }
    }
    #endregion

    #region -------- ChannelCategory -----------
    public class ChannelCategoryRepositories : MainRepository<channelCategory>
    {
        public Channel_CategoryReturn GetChannelCategory_List(string order, Int32 page, string search_value, Int32 size, string sort, string Date_GT, string Date_LT, Int32 id)
        {
            Channel_CategoryReturn ObjChannelCategoryReturn = new Channel_CategoryReturn();

            var param = new DynamicParameters();
            param.Add("@order", order);
            param.Add("@page", page);
            param.Add("@search_value", search_value);
            param.Add("@size", size);
            param.Add("@sort", sort);
            param.Add("@date_gt", Date_GT);
            param.Add("@date_lt", Date_LT);
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            ObjChannelCategoryReturn.assets = base.ExecuteSQLProcedure<channelCategory>("[USPAPI_Channel_Category]", param).ToList();
            ObjChannelCategoryReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjChannelCategoryReturn;
        }
    }
    #endregion

    #region -------- Platform -----------
    public class PlatformRepositories : MainRepository<platforms>
    {
        public PlatformReturn GetPlatform_List(string order, Int32 page, string search_value, Int32 size, string sort, string Date_GT, string Date_LT, Int32 id)
        {
            PlatformReturn ObjPlatformReturn = new PlatformReturn();

            var param = new DynamicParameters();
            param.Add("@order", order);
            param.Add("@page", page);
            param.Add("@search_value", search_value);
            param.Add("@size", size);
            param.Add("@sort", sort);
            param.Add("@date_gt", Date_GT);
            param.Add("@date_lt", Date_LT);
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            ObjPlatformReturn.assets = base.ExecuteSQLProcedure<platforms>("[USPAPI_Platform]", param).ToList();
            ObjPlatformReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjPlatformReturn;
        }
    }
    #endregion
}
