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

        public List<USPAPI_GetModuleRights> USPAPI_GetModuleRights(Int32 Security_Group_Code)
        {
            List<USPAPI_GetModuleRights> ObjModule = new List<USPAPI_GetModuleRights>();

            var param = new DynamicParameters();
            param.Add("@SecurityGroupCode", Security_Group_Code);
            ObjModule = base.ExecuteSQLProcedure<USPAPI_GetModuleRights>("USPAPI_GetModuleRights", param).ToList();
            return ObjModule;
        }
    }
    #endregion

    #region -------- Extended_Columns -----------
    public class Extended_ColumnsRepositories : MainRepository<Extended_Columns>
    {
        public Extended_Columns Get(int Id)
        {
            var obj = new { Columns_Code = Id };

            return base.GetById<Extended_Columns, Extended_Group_Config, Extended_Columns_Value, Map_Extended_Columns>(obj);
        }
        public IEnumerable<Extended_Columns> GetAll()
        {
            return base.GetAll<Extended_Columns, Extended_Group_Config, Extended_Columns_Value, Map_Extended_Columns>();
        }
        public void Update(Extended_Columns entity)
        {
            Extended_Columns oldObj = Get(entity.Columns_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public IEnumerable<Extended_Columns> SearchFor(object param)
        {
            return base.SearchForEntity<Extended_Columns, Extended_Group_Config, Extended_Columns_Value, Map_Extended_Columns>(param);
        }

        public IEnumerable<Extended_Columns> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Extended_Columns>(strSQL);
        }
    }
    #endregion

    #region -------- Extended_Columns_Value -----------
    public class Extended_Columns_ValueRepositories : MainRepository<Extended_Columns_Value>
    {
        public Extended_Columns_Value Get(int Id)
        {
            var obj = new { Columns_Value_Code = Id };

            return base.GetById<Extended_Columns_Value, Map_Extended_Columns_Details, Map_Extended_Columns>(obj);
        }
        public IEnumerable<Extended_Columns_Value> GetAll()
        {
            return base.GetAll<Extended_Columns_Value, Map_Extended_Columns_Details, Map_Extended_Columns>();
        }
        public void Update(Extended_Columns_Value entity)
        {
            Extended_Columns_Value oldObj = Get(entity.Columns_Value_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public IEnumerable<Extended_Columns_Value> SearchFor(object param)
        {
            return base.SearchForEntity<Extended_Columns_Value, Map_Extended_Columns_Details, Map_Extended_Columns>(param);
        }

        public IEnumerable<Extended_Columns_Value> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Extended_Columns_Value>(strSQL);
        }
    }
    #endregion

    #region -------- Map_Extended_Columns -----------
    public class Map_Extended_ColumnsRepositories : MainRepository<Map_Extended_Columns>
    {
        public Map_Extended_Columns Get(int Id)
        {
            var obj = new { Map_Extended_Columns_Code = Id };

            return base.GetById<Map_Extended_Columns, Extended_Columns, Extended_Columns_Value, Map_Extended_Columns_Details>(obj);
        }
        public IEnumerable<Map_Extended_Columns> GetAll()
        {
            return base.GetAll<Map_Extended_Columns, Extended_Columns, Extended_Columns_Value, Map_Extended_Columns_Details>();
        }
        public void Add(Map_Extended_Columns entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Map_Extended_Columns entity)
        {
            Map_Extended_Columns oldObj = Get(entity.Map_Extended_Columns_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Map_Extended_Columns entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Map_Extended_Columns> SearchFor(object param)
        {
            return base.SearchForEntity<Map_Extended_Columns, Extended_Columns, Extended_Columns_Value, Map_Extended_Columns_Details>(param);
        }

        public IEnumerable<Map_Extended_Columns> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Map_Extended_Columns>(strSQL);
        }
    }
    #endregion

    #region -------- Map_Extended_Columns_Details -----------
    public class Map_Extended_Columns_DetailsRepositories : MainRepository<Map_Extended_Columns_Details>
    {
        public Map_Extended_Columns_Details Get(int Id)
        {
            var obj = new { Map_Extended_Columns_Details_Code = Id };

            return base.GetById<Map_Extended_Columns_Details, Map_Extended_Columns>(obj);
        }
        public IEnumerable<Map_Extended_Columns_Details> GetAll()
        {
            return base.GetAll<Map_Extended_Columns_Details, Map_Extended_Columns>();
        }
        public void Add(Map_Extended_Columns_Details entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Map_Extended_Columns_Details entity)
        {
            Map_Extended_Columns_Details oldObj = Get(entity.Map_Extended_Columns_Details_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Map_Extended_Columns_Details entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Map_Extended_Columns_Details> SearchFor(object param)
        {
            return base.SearchForEntity<Map_Extended_Columns_Details, Map_Extended_Columns>(param);
        }

        public IEnumerable<Map_Extended_Columns_Details> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Map_Extended_Columns_Details>(strSQL);
        }
    }
    #endregion
}
