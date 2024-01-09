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

            return base.GetById<Extended_Columns, Extended_Group_Config>(obj);
        }
        public IEnumerable<Extended_Columns> GetAll()
        {
            return base.GetAll<Extended_Columns, Extended_Group_Config>();
        }
        public void Update(Extended_Columns entity)
        {
            Extended_Columns oldObj = Get(entity.columns_id.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public IEnumerable<Extended_Columns> SearchFor(object param)
        {
            return base.SearchForEntity<Extended_Columns, Extended_Group_Config>(param);
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

            return base.GetById<Extended_Columns_Value>(obj);
        }
        public IEnumerable<Extended_Columns_Value> GetAll()
        {
            return base.GetAll<Extended_Columns_Value>();
        }
        public void Update(Extended_Columns_Value entity)
        {
            Extended_Columns_Value oldObj = Get(entity.Columns_Value_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public IEnumerable<Extended_Columns_Value> SearchFor(object param)
        {
            return base.SearchForEntity<Extended_Columns_Value>(param);
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

            return base.GetById<Map_Extended_Columns, Extended_Columns, Map_Extended_Columns_Details>(obj);
        }
        public IEnumerable<Map_Extended_Columns> GetAll()
        {
            return base.GetAll<Map_Extended_Columns, Extended_Columns, Map_Extended_Columns_Details>();
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
            return base.SearchForEntity<Map_Extended_Columns, Extended_Columns, Map_Extended_Columns_Details>(param);
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

    #region -------- Language -----------
    public class LanguageRepositories : MainRepository<Language>
    {
        public Language Get(int Id)
        {
            var obj = new { Language_Code = Id };

            return base.GetById<Language>(obj);
        }
        public IEnumerable<Language> GetAll()
        {
            return base.GetAll<Language>();
        }
        public void Add(Language entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Language entity)
        {
            Language oldObj = Get(entity.Language_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Language entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Language> SearchFor(object param)
        {
            return base.SearchForEntity<Language>(param);
        }

        public IEnumerable<Language> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Language>(strSQL);
        }
    }
    #endregion

    #region -------- Program -----------
    public class ProgramRepositories : MainRepository<Program>
    {
        public Program Get(int Id)
        {
            var obj = new { Program_Code = Id };

            return base.GetById<Program>(obj);
        }
        public IEnumerable<Program> GetAll()
        {
            return base.GetAll<Program>();
        }
        public void Add(Program entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Program entity)
        {
            Program oldObj = Get(entity.Program_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Program entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Program> SearchFor(object param)
        {
            return base.SearchForEntity<Program>(param);
        }

        public IEnumerable<Program> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Program>(strSQL);
        }

        public ProgramReturn GetProgram_List(string order, Int32 page, string search_value, Int32 size, string sort, string Date_GT, string Date_LT, Int32 id)
        {
            ProgramReturn ObjProgramReturn = new ProgramReturn();

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
            ObjProgramReturn.content = base.ExecuteSQLProcedure<Program_List>("USPAPI_Program_List", param).ToList();
            ObjProgramReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjProgramReturn;
        }
    }
    #endregion

    #region -------- Country -----------
    public class CountryRepositories : MainRepository<Country>
    {
        public Country Get(int Id)
        {
            var obj = new { Country_Code = Id };

            return base.GetById<Country>(obj);
        }
        public IEnumerable<Country> GetAll()
        {
            return base.GetAll<Country>();
        }
        public void Add(Country entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Country entity)
        {
            Country oldObj = Get(entity.country_id.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Country entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Country> SearchFor(object param)
        {
            return base.SearchForEntity<Country>(param);
        }

        public IEnumerable<Country> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Country>(strSQL);
        }
    }
    #endregion

    #region -------- Talent -----------
    public class TalentRepositories : MainRepository<Talent>
    {
        public Talent Get(int Id)
        {
            var obj = new { Talent_Code = Id };

            return base.GetById<Talent,Talent_Role>(obj);
        }
        public IEnumerable<Talent> GetAll()
        {
            return base.GetAll<Talent, Talent_Role>();
        }
        public void Add(Talent entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Talent entity)
        {
            Talent oldObj = Get(entity.Talent_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Talent entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Talent> SearchFor(object param)
        {
            return base.SearchForEntity<Talent>(param);
        }

        public IEnumerable<Talent> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Talent>(strSQL);
        }

        public TalentReturn GetTalent_List(string order, Int32 page, string search_value, Int32 size, string sort, string Date_GT, string Date_LT, Int32 id)
        {
            TalentReturn ObjTalentReturn = new TalentReturn();

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
            ObjTalentReturn.content = base.ExecuteSQLProcedure<Talent_List>("USPAPI_Talent_List", param).ToList();
            ObjTalentReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjTalentReturn;
        }
        public Talent_Validations Talent_Validation(string InputValue, string InputType)
        {
            var param = new DynamicParameters();

            param.Add("@InputValue", InputValue);
            param.Add("@InputType", InputType);
            return base.ExecuteSQLProcedure<Talent_Validations>("USPAPI_Talent_Validations", param).FirstOrDefault();
        }
    }
    #endregion

    #region -------- Talent_Role -----------
    public class Talent_RoleRepositories : MainRepository<Talent_Role>
    {
        public Talent_Role Get(int Id)
        {
            var obj = new { Talent_Role_Code = Id };

            return base.GetById<Talent_Role>(obj);
        }
        public IEnumerable<Talent_Role> GetAll()
        {
            return base.GetAll<Talent_Role>();
        }
        public void Add(Talent_Role entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Talent_Role entity)
        {
            Talent_Role oldObj = Get(entity.Talent_Role_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Talent_Role entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Talent_Role> SearchFor(object param)
        {
            return base.SearchForEntity<Talent_Role>(param);
        }

        public IEnumerable<Talent_Role> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Talent_Role>(strSQL);
        }
    }
    #endregion

    #region -------- Role -----------
    public class RoleRepositories : MainRepository<Role>
    {
        public Role Get(int Id)
        {
            var obj = new { Role_Code = Id };

            return base.GetById<Role>(obj);
        }
        public IEnumerable<Role> GetAll()
        {
            return base.GetAll<Role>();
        }
        public void Add(Role entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Role entity)
        {
            Role oldObj = Get(entity.Role_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Role entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Role> SearchFor(object param)
        {
            return base.SearchForEntity<Role>(param);
        }

        public IEnumerable<Role> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Role>(strSQL);
        }

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
            ObjRoleReturn.content = base.ExecuteSQLProcedure<Role>("USPAPI_Role_List", param).ToList();
            ObjRoleReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjRoleReturn;
        }
    }
    #endregion

    #region -------- Deal_Type -----------
    public class Deal_TypeRepositories : MainRepository<Deal_Type>
    {
        public Deal_Type Get(int Id)
        {
            var obj = new { Deal_Type_Code = Id };

            return base.GetById<Deal_Type>(obj);
        }
        public IEnumerable<Deal_Type> GetAll()
        {
            return base.GetAll<Deal_Type>();
        }
        public void Add(Deal_Type entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Deal_Type entity)
        {
            Deal_Type oldObj = Get(entity.Deal_Type_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Deal_Type entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Deal_Type> SearchFor(object param)
        {
            return base.SearchForEntity<Deal_Type>(param);
        }

        public IEnumerable<Deal_Type> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Deal_Type>(strSQL);
        }
    }
    #endregion

    #region -------- Genres -----------
    public class GenresRepositories : MainRepository<Genres>
    {
        public Genres Get(int Id)
        {
            var obj = new { Genres_Code = Id };

            return base.GetById<Genres>(obj);
        }
        public IEnumerable<Genres> GetAll()
        {
            return base.GetAll<Genres>();
        }
        public Genres GetById(Int32? Id)
        {
            var obj = new { Genres_Code = Id.Value };
            var entity = base.GetById<Genres>(obj);

            return entity;
        }
        public void Add(Genres entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Genres entity)
        {
            Genres oldObj = Get(entity.Genres_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Genres entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Genres> SearchFor(object param)
        {
            return base.SearchForEntity<Genres>(param);
        }

        public IEnumerable<Genres> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Genres>(strSQL);
        }

        public GenreReturn GetGenre_List(string order, Int32 page, string search_value, Int32 size, string sort, string Date_GT, string Date_LT, Int32 id)
        {
            GenreReturn ObjGenreReturn = new GenreReturn();

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
            ObjGenreReturn.content = base.ExecuteSQLProcedure<Genres>("USPAPI_Genres_List", param).ToList();
            ObjGenreReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjGenreReturn;
        }
    }
    #endregion

    #region -------- Banner -----------
    public class BannerRepositories : MainRepository<Banner>
    {
        public Banner Get(int Id)
        {
            var obj = new { Banner_Code = Id };

            return base.GetById<Banner>(obj);
        }
        public IEnumerable<Banner> GetAll()
        {
            return base.GetAll<Banner>();
        }
        public void Add(Banner entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Banner entity)
        {
            Banner oldObj = Get(entity.Banner_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Banner entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Banner> SearchFor(object param)
        {
            return base.SearchForEntity<Banner>(param);
        }

        public IEnumerable<Banner> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Banner>(strSQL);
        }
    }
    #endregion

    #region -------- AL_Lab -----------
    public class AL_LabRepositories : MainRepository<AL_Lab>
    {
        public AL_Lab Get(int Id)
        {
            var obj = new { AL_Lab_Code = Id };

            return base.GetById<AL_Lab>(obj);
        }
        public IEnumerable<AL_Lab> GetAll()
        {
            return base.GetAll<AL_Lab>();
        }
        public void Add(AL_Lab entity)
        {
            base.AddEntity(entity);
        }
        public void Update(AL_Lab entity)
        {
            AL_Lab oldObj = Get(entity.AL_Lab_id.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(AL_Lab entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<AL_Lab> SearchFor(object param)
        {
            return base.SearchForEntity<AL_Lab>(param);
        }

        public IEnumerable<AL_Lab> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<AL_Lab>(strSQL);
        }
    }
    #endregion

    #region -------- Version -----------
    public class VersionRepositories : MainRepository<RightsU.BMS.Entities.Master_Entities.Version>
    {
        public RightsU.BMS.Entities.Master_Entities.Version Get(int Id)
        {
            var obj = new { Version_Code = Id };

            return base.GetById<RightsU.BMS.Entities.Master_Entities.Version>(obj);
        }
        public IEnumerable<RightsU.BMS.Entities.Master_Entities.Version> GetAll()
        {
            return base.GetAll<RightsU.BMS.Entities.Master_Entities.Version>();
        }
        public void Add(RightsU.BMS.Entities.Master_Entities.Version entity)
        {
            base.AddEntity(entity);
        }
        public void Update(RightsU.BMS.Entities.Master_Entities.Version entity)
        {
            RightsU.BMS.Entities.Master_Entities.Version oldObj = Get(entity.Version_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(RightsU.BMS.Entities.Master_Entities.Version entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<RightsU.BMS.Entities.Master_Entities.Version> SearchFor(object param)
        {
            return base.SearchForEntity<RightsU.BMS.Entities.Master_Entities.Version>(param);
        }

        public IEnumerable<RightsU.BMS.Entities.Master_Entities.Version> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<RightsU.BMS.Entities.Master_Entities.Version>(strSQL);
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
            ObjDealTypeReturn.content = base.ExecuteSQLProcedure<dealType>("[USPAPI_Deal_Type]", param).ToList();
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
            ObjChannelCategoryReturn.content = base.ExecuteSQLProcedure<channelCategory>("[USPAPI_Channel_Category]", param).ToList();
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
            ObjPlatformReturn.content = base.ExecuteSQLProcedure<platforms>("[USPAPI_Platform]", param).ToList();
            ObjPlatformReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjPlatformReturn;
        }
    }
    #endregion
}
