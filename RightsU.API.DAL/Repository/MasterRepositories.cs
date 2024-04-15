﻿using Dapper;
using RightsU.API.Entities;
using RightsU.API.Entities.ReturnClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.DAL
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

        public string GetUserName(int Id)
        {
            string UserName = string.Empty;

            User objUser = Get(Id);
            if (objUser != null)
            {
                UserName = objUser.First_Name + " " + objUser.Last_Name;
            }
            return UserName;
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

        public List<Extended_Columns_Value> GetScalarDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Extended_Columns_Value>(strSQL).ToList();
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
        public LanguageReturn GetLanguage_List(string order, Int32 page, string search_value, Int32 size, string sort, string Date_GT, string Date_LT, Int32 id)
        {
            LanguageReturn objLanguageReturn = new LanguageReturn();

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
            objLanguageReturn.content = base.ExecuteSQLProcedure<Language>("USPAPI_Language_List", param).ToList();
            objLanguageReturn.paging.total = param.Get<Int64>("@RecordCount");
            return objLanguageReturn;
        }
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
        public Program GetById(Int32? Id)
        {
            var obj = new { Program_Code = Id.Value };
            var entity = base.GetById<Program>(obj);

            return entity;
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
            ObjProgramReturn.content = base.ExecuteSQLProcedure<Program>("USPAPI_Program_List", param).ToList();
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

            return base.GetById<Country, CountryLanguage, Language>(obj);
        }
        public IEnumerable<Country> GetAll()
        {
            return base.GetAll<Country, CountryLanguage, Language>();
        }

        public void Add(Country entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Country entity)
        {
            Country oldObj = Get(entity.Country_Code.Value);
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

    public class CountryLanguageDetailsRepositories : MainRepository<CountryLanguage>
    {
        public void Delete(CountryLanguage entity)
        {
            base.DeleteEntity(entity);
        }
    }
    #endregion

    #region -------- Talent -----------
    public class TalentRepositories : MainRepository<Talent>
    {
        public Talent Get(int Id)
        {
            var obj = new { Talent_Code = Id };

            return base.GetById<Talent, Talent_Role>(obj);
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
            ObjTalentReturn.content = base.ExecuteSQLProcedure<Talent>("USPAPI_Talent_List", param).ToList();
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
            var entity = base.ExecuteSQLProcedure<Role>("USPAPI_Role_List", param).ToList();
            entity.ForEach(i =>
            {
                if (!string.IsNullOrEmpty(i.AssetType))
                {
                    var arrAssetValue = i.AssetType.Split(new char[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
                    if (arrAssetValue.Length > 0)
                    {
                        i.deal_type = new Deal_Type() { Deal_Type_Code = Convert.ToInt32(arrAssetValue[0]), Deal_Type_Name = arrAssetValue[1] };
                    }
                }
            });
            ObjRoleReturn.content = entity;
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
    public class VersionRepositories : MainRepository<RightsU.API.Entities.Version>
    {
        public RightsU.API.Entities.Version Get(int Id)
        {
            var obj = new { Version_Code = Id };

            return base.GetById<RightsU.API.Entities.Version>(obj);
        }
        public IEnumerable<RightsU.API.Entities.Version> GetAll()
        {
            return base.GetAll<RightsU.API.Entities.Version>();
        }
        public void Add(RightsU.API.Entities.Version entity)
        {
            base.AddEntity(entity);
        }
        public void Update(RightsU.API.Entities.Version entity)
        {
            RightsU.API.Entities.Version oldObj = Get(entity.Version_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(RightsU.API.Entities.Version entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<RightsU.API.Entities.Version> SearchFor(object param)
        {
            return base.SearchForEntity<RightsU.API.Entities.Version>(param);
        }

        public IEnumerable<RightsU.API.Entities.Version> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<RightsU.API.Entities.Version>(strSQL);
        }
    }
    #endregion

    #region -------- DealType -----------
    public class DealTypeRepositories : MainRepository<Deal_Type>
    {
        public IEnumerable<Deal_Type> GetAll()
        {
            return base.GetAll<Deal_Type>();
        }
        
    }
    #endregion

    #region -------- ChannelCategory -----------
    public class ChannelCategoryRepositories : MainRepository<Channel_Category>
    {
        public Channel_Category Get(int Id)
        {
            var obj = new { Channel_Category_Code = Id };

            return base.GetById<Channel_Category>(obj);
        }

        public IEnumerable<Channel_Category> GetAll()
        {
            return base.GetAll<Channel_Category>();
        }

        public void Add(Channel_Category entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Channel_Category entity)
        {
            Channel_Category oldObj = Get(entity.Channel_Category_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Channel_Category entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Channel_Category> SearchFor(object param)
        {
            return base.SearchForEntity<Channel_Category>(param);
        }

        public IEnumerable<Channel_Category> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Channel_Category>(strSQL);
        }
    }
    #endregion

    #region -------- Platform -----------
    public class PlatformRepositories : MainRepository<Platform>
    {

        public Platform Get(int Id)
        {
            var obj = new { Platform_Code = Id };

            return base.GetById<Platform>(obj);
        }

        public IEnumerable<Platform> GetAll()
        {
            return base.GetAll<Platform>();
        }

    }
    #endregion

    #region -------- Business Unit -----------
    public class BusinessUnitRepositories : MainRepository<Business_Unit>
    {
        public Business_Unit Get(int Id)
        {
            var obj = new { Business_Unit_Code = Id };

            return base.GetById<Business_Unit>(obj);
        }
        public IEnumerable<Business_Unit> GetAll()
        {
            return base.GetAll<Business_Unit>();
        }
        public void Add(Business_Unit entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Business_Unit entity)
        {
            Business_Unit oldObj = Get(entity.Business_Unit_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Business_Unit entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Business_Unit> SearchFor(object param)
        {
            return base.SearchForEntity<Business_Unit>(param);
        }

        public IEnumerable<Business_Unit> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Business_Unit>(strSQL);
        }
        public BusinessUnitReturn GetBusinessUnit_List(string order, Int32 page, string search_value, Int32 size, string sort, Int32 id)
        {
            BusinessUnitReturn objBusinessUnitReturn = new BusinessUnitReturn();

            var param = new DynamicParameters();
            param.Add("@order", order);
            param.Add("@page", page);
            param.Add("@search_value", search_value);
            param.Add("@size", size);
            param.Add("@sort", sort);
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            objBusinessUnitReturn.content = base.ExecuteSQLProcedure<Business_Unit>("USPAPI_BusinessUnit_List", param).ToList();
            objBusinessUnitReturn.paging.total = param.Get<Int64>("@RecordCount");
            return objBusinessUnitReturn;
        }
    }
    #endregion

    #region -------- Sub License -----------
    public class SubLicenseRepositories : MainRepository<Business_Unit>
    {
        public SubLicenseReturn GetSub_License(string order, Int32 page, string search_value, Int32 size, string sort, Int32 id)
        {
            SubLicenseReturn objSubLicenseReturn = new SubLicenseReturn();
            var param = new DynamicParameters();
            param.Add("@order", order);
            param.Add("@page", page);
            param.Add("@search_value", search_value);
            param.Add("@size", size);
            param.Add("@sort", sort);
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            objSubLicenseReturn.content = base.ExecuteSQLProcedure<Sub_License>("USPAPI_Sub_License", param).ToList();
            objSubLicenseReturn.paging.total = param.Get<Int64>("@RecordCount");
            return objSubLicenseReturn;
        }
    }
    #endregion

    #region -------- Entity -----------
    public class EntityRepositories : MainRepository<Entity>
    {
        public Entity Get(int Id)
        {
            var obj = new { Entity_Code = Id };

            return base.GetById<Entity>(obj);
        }
        public IEnumerable<Entity> GetAll()
        {
            return base.GetAll<Entity>();
        }
        public void Add(Entity entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Entity entity)
        {
            Entity oldObj = Get(entity.Entity_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Entity entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Entity> SearchFor(object param)
        {
            return base.SearchForEntity<Entity>(param);
        }

        public IEnumerable<Entity> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Entity>(strSQL);
        }
        public EntityReturn GetEntity_List(string order, Int32 page, string search_value, Int32 size, string sort, string Date_GT, string Date_LT, Int32 id)
        {
            EntityReturn ObjEntityReturn = new EntityReturn();

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
            ObjEntityReturn.content = base.ExecuteSQLProcedure<Entity>("USPAPI_Entity_List", param).ToList();
            ObjEntityReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjEntityReturn;

        }
    }
    #endregion

    #region -------- Deal Tag -----------
    public class DealTagRepositories : MainRepository<Deal_Tag>
    {
        public DealTagReturn GetDealTag_List(string order, Int32 page, string search_value, Int32 size, string sort, Int32 id)
        {
            DealTagReturn objDealTagReturn = new DealTagReturn();
            var param = new DynamicParameters();
            param.Add("@order", order);
            param.Add("@page", page);
            param.Add("@search_value", search_value);
            param.Add("@size", size);
            param.Add("@sort", sort);
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            objDealTagReturn.content = base.ExecuteSQLProcedure<Deal_Tag>("USPAPI_Deal_Tag", param).ToList();
            objDealTagReturn.paging.total = param.Get<Int64>("@RecordCount");
            return objDealTagReturn;
        }
    }
    #endregion

    #region -------- Milestone Type -----------
    public class MilestoneTypeRepositories : MainRepository<Milestone_Type>
    {
        public MilestoneTypeReturn GetMilestoneType_List(string order, Int32 page, string search_value, Int32 size, string sort, Int32 id)
        {
            MilestoneTypeReturn objMilestoneTypeReturn = new MilestoneTypeReturn();

            var param = new DynamicParameters();
            param.Add("@order", order);
            param.Add("@page", page);
            param.Add("@search_value", search_value);
            param.Add("@size", size);
            param.Add("@sort", sort);
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            objMilestoneTypeReturn.content = base.ExecuteSQLProcedure<Milestone_Type>("USPAPI_MilestoneType_List", param).ToList();
            objMilestoneTypeReturn.paging.total = param.Get<Int64>("@RecordCount");
            return objMilestoneTypeReturn;
        }
    }
    #endregion

    #region -------- ROFR -----------
    public class ROFRRepositories : MainRepository<ROFR>
    {
        public ROFRReturn GetROFR_List(string order, Int32 page, string search_value, Int32 size, string sort, Int32 id)
        {
            ROFRReturn objROFRReturn = new ROFRReturn();

            var param = new DynamicParameters();
            param.Add("@order", order);
            param.Add("@page", page);
            param.Add("@search_value", search_value);
            param.Add("@size", size);
            param.Add("@sort", sort);
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            objROFRReturn.content = base.ExecuteSQLProcedure<ROFR>("USPAPI_ROFR_List", param).ToList();
            objROFRReturn.paging.total = param.Get<Int64>("@RecordCount");
            return objROFRReturn;
        }
    }
    #endregion

    #region -------- PromoterRemark -----------
    public class PromoterRemarkRepositories : MainRepository<PromoterRemark>
    {
        public PromoterRemark Get(int Id)
        {
            var obj = new { Promoter_Remarks_Code = Id };

            return base.GetById<PromoterRemark>(obj);
        }

        public PromoterRemark GetById(Int32? Id)
        {
            var obj = new { Promoter_Remarks_Code = Id.Value };
            var entity = base.GetById<PromoterRemark>(obj);

            return entity;
        }
        public IEnumerable<PromoterRemark> GetAll()
        {
            return base.GetAll<PromoterRemark>();
        }
        public IEnumerable<PromoterRemark> SearchFor(object param)
        {
            return base.SearchForEntity<PromoterRemark>(param);
        }

        public void Add(PromoterRemark entity)
        {
            base.AddEntity(entity);
        }
        public void Update(PromoterRemark entity)
        {
            PromoterRemark oldObj = Get(entity.Promoter_Remarks_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
    }
    #endregion

    #region -------- Vendor -----------
    public class VendorRepositories : MainRepository<Vendor>
    {
        public Vendor Get(int Id)
        {
            var obj = new { Vendor_Code = Id };

            return base.GetById<Vendor>(obj);
        }
        public IEnumerable<Vendor> GetAll()
        {
            return base.GetAll<Vendor>();
        }
        public void Add(Vendor entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Vendor entity)
        {
            Vendor oldObj = Get(entity.Vendor_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Vendor entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Vendor> SearchFor(object param)
        {
            return base.SearchForEntity<Vendor>(param);
        }

        public IEnumerable<Vendor> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Vendor>(strSQL);
        }
    }
    #endregion

    #region -------- Party -----------
    public class PartyRepositories : MainRepository<Party>
    {
        public Party Get(int Id)
        {
            var obj = new { Vendor_Code = Id };

            var entity = base.GetById<Party, Party_Category, Vendor_Country, Country, Vendor_Role, Role, Vendor_Contacts>(obj);
            if (entity != null)
            {
                if (entity.party_group == null && (entity.Party_Group_Code != null || entity.Party_Group_Code > 0))
                {
                    entity.party_group = new Party_GroupRepositories().Get(entity.Party_Group_Code.Value);
                }
            }

            return entity;
        }
        public IEnumerable<Party> GetAll()
        {
            var entity = base.GetAll<Party, Party_Category, Vendor_Country, Country, Vendor_Role, Role, Vendor_Contacts>();

            entity.ToList().ForEach(i =>
            {
                if (i.party_group == null && (i.Party_Group_Code != null || i.Party_Group_Code > 0))
                {
                    i.party_group = new Party_GroupRepositories().Get(i.Party_Group_Code.Value);
                }
            });

            return entity;
        }
        public void Add(Party entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Party entity)
        {
            Party oldObj = Get(entity.Vendor_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Party entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Party> SearchFor(object param)
        {
            var entity = base.SearchForEntity<Party, Party_Category, Vendor_Country, Country, Vendor_Role, Role, Vendor_Contacts>(param);

            entity.ToList().ForEach(i =>
            {
                if (i.party_group == null && (i.Party_Group_Code != null || i.Party_Group_Code > 0))
                {
                    i.party_group = new Party_GroupRepositories().Get(i.Party_Group_Code.Value);
                }
            });

            return entity;
        }

        public IEnumerable<Party> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Party>(strSQL);
        }
    }
    #endregion

    #region -------- Vendor_Role -----------
    public class Vendor_RoleRepositories : MainRepository<Vendor_Role>
    {
        public Vendor_Role Get(int Id)
        {
            var obj = new { Vendor_Role_Code = Id };

            return base.GetById<Vendor_Role>(obj);
        }
        public IEnumerable<Vendor_Role> GetAll()
        {
            return base.GetAll<Vendor_Role>();
        }
        public void Add(Vendor_Role entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Vendor_Role entity)
        {
            Vendor_Role oldObj = Get(entity.Vendor_Role_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Vendor_Role entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Vendor_Role> SearchFor(object param)
        {
            return base.SearchForEntity<Vendor_Role>(param);
        }

        public IEnumerable<Vendor_Role> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Vendor_Role>(strSQL);
        }
    }
    #endregion

    #region -------- Vendor_Contacts -----------
    public class Vendor_ContactsRepositories : MainRepository<Vendor_Contacts>
    {
        public Vendor_Contacts Get(int Id)
        {
            var obj = new { Vendor_Contacts_Code = Id };

            return base.GetById<Vendor_Contacts>(obj);
        }
        public IEnumerable<Vendor_Contacts> GetAll()
        {
            return base.GetAll<Vendor_Contacts>();
        }
        public void Add(Vendor_Contacts entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Vendor_Contacts entity)
        {
            Vendor_Contacts oldObj = Get(entity.Vendor_Contacts_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Vendor_Contacts entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Vendor_Contacts> SearchFor(object param)
        {
            return base.SearchForEntity<Vendor_Contacts>(param);
        }

        public IEnumerable<Vendor_Contacts> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Vendor_Contacts>(strSQL);
        }
    }
    #endregion

    #region -------- Vendor_Country -----------
    public class Vendor_CountryRepositories : MainRepository<Vendor_Country>
    {
        public Vendor_Country Get(int Id)
        {
            var obj = new { Vendor_Country_Code = Id };

            return base.GetById<Vendor_Country>(obj);
        }
        public IEnumerable<Vendor_Country> GetAll()
        {
            return base.GetAll<Vendor_Country>();
        }
        public void Add(Vendor_Country entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Vendor_Country entity)
        {
            Vendor_Country oldObj = Get(entity.Vendor_Country_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Vendor_Country entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Vendor_Country> SearchFor(object param)
        {
            return base.SearchForEntity<Vendor_Country>(param);
        }

        public IEnumerable<Vendor_Country> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Vendor_Country>(strSQL);
        }
    }
    #endregion

    #region -------- Party_Group -----------
    public class Party_GroupRepositories : MainRepository<Party_Group>
    {
        public Party_Group Get(int Id)
        {
            var obj = new { Party_Group_Code = Id };

            return base.GetById<Party_Group>(obj);
        }
        public IEnumerable<Party_Group> GetAll()
        {
            return base.GetAll<Party_Group>();
        }
        public void Add(Party_Group entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Party_Group entity)
        {
            Party_Group oldObj = Get(entity.Party_Group_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Party_Group entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Party_Group> SearchFor(object param)
        {
            return base.SearchForEntity<Party_Group>(param);
        }

        public IEnumerable<Party_Group> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Party_Group>(strSQL);
        }
    }
    #endregion

    #region -------- Error_Code_Master -----------
    public class Error_Code_MasterRepositories : MainRepository<Error_Code_Master>
    {
        public Error_Code_Master Get(int Id)
        {
            var obj = new { Error_Code = Id };

            return base.GetById<Error_Code_Master>(obj);
        }
        public IEnumerable<Error_Code_Master> GetAll()
        {
            return base.GetAll<Error_Code_Master>();
        }
        public void Add(Error_Code_Master entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Error_Code_Master entity)
        {
            Error_Code_Master oldObj = Get(entity.Error_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Error_Code_Master entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Error_Code_Master> SearchFor(object param)
        {
            return base.SearchForEntity<Error_Code_Master>(param);
        }

        public IEnumerable<Error_Code_Master> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Error_Code_Master>(strSQL);
        }
    }
    #endregion

    #region -------- Territory -----------
    public class TerritoryRepositories : MainRepository<Territory>
    {
        public Territory Get(int Id)
        {
            var obj = new { Territory_Code = Id };

            return base.GetById<Territory, Territory_Details>(obj);
        }
        public IEnumerable<Territory> GetAll()
        {
            return base.GetAll<Territory, Territory_Details>();
        }
        public void Add(Territory entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Territory entity)
        {
            Territory oldObj = Get(entity.Territory_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Territory entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Territory> SearchFor(object param)
        {
            return base.SearchForEntity<Territory>(param);
        }

        public IEnumerable<Territory> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Territory>(strSQL);
        }
    }

    public class TerritoryDetailsRepositories : MainRepository<Territory_Details>
    {
        public void Delete(Territory_Details entity)
        {
            base.DeleteEntity(entity);
        }
    }

    #endregion

    #region -------- Category -----------
    public class CategoryRepositories : MainRepository<Category>
    {
        public Category Get(int Id)
        {
            var obj = new { Category_Code = Id };

            return base.GetById<Category>(obj);
        }

        public Category GetById(Int32? Id)
        {
            var obj = new { Category_Code = Id.Value };
            var entity = base.GetById<Category>(obj);

            return entity;
        }
        public IEnumerable<Category> GetAll()
        {
            return base.GetAll<Category>();
        }

        public IEnumerable<Category> SearchFor(object param)
        {
            return base.SearchForEntity<Category>(param);
        }

        public void Add(Category entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Category entity)
        {
            Category oldObj = Get(entity.Category_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
    }
    #endregion

    #region -------- RightRule -----------
    public class RightRuleRepositories : MainRepository<RightRule>
    {
        public RightRule Get(int Id)
        {
            var obj = new { Right_Rule_Code = Id };

            return base.GetById<RightRule>(obj);
        }
        public IEnumerable<RightRule> GetAllByQuery(string query)
        {
            return base.ExecuteSQLStmt<RightRule>(query);
        }
        public RightRule GetById(int Id)
        {
            var obj = new { Right_Rule_Code = Id };

            return base.GetById<RightRule>(obj);
        }
        public IEnumerable<RightRule> GetAll()
        {
            return base.GetAll<RightRule>();
        }

        public IEnumerable<RightRule> SearchFor(object param)
        {
            return base.SearchForEntity<RightRule>(param);
        }
        public void Add(RightRule entity)
        {
            base.AddEntity(entity);
        }
        public void Update(RightRule entity)
        {
            RightRule oldObj = Get(entity.Right_Rule_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

    }
    #endregion

    #region -------- LanguageGroup -----------
    public class LanguageGroupRepositories : MainRepository<LanguageGroup>
    {
        public LanguageGroup Get(int Id)
        {
            var obj = new { Language_Group_Code = Id };

            return base.GetById<LanguageGroup>(obj);
        }
        public IEnumerable<LanguageGroup> GetAllByQuery(string query)
        {
            return base.ExecuteSQLStmt<LanguageGroup>(query);
        }
        public LanguageGroup GetById(int Id)
        {
            var obj = new { Language_Group_Code = Id };

            return base.GetById<LanguageGroup, LanguageGroupDetails, Language>(obj);
        }
        public IEnumerable<LanguageGroup> GetAll()
        {
            return base.GetAll<LanguageGroup, LanguageGroupDetails, Language>();
        }

        public IEnumerable<LanguageGroup> SearchFor(object param)
        {
            return base.SearchForEntity<LanguageGroup>(param);
        }

        public void Add(LanguageGroup entity)
        {
            base.AddEntity(entity);
        }

        public void Update(LanguageGroup entity)
        {
            LanguageGroup oldObj = Get(entity.Language_Group_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(LanguageGroup entity)
        {
            base.DeleteEntity(entity);
        }
    }

    public class LanguageGroupDetailsRepositories : MainRepository<LanguageGroupDetails>
    {
        public void Delete(LanguageGroupDetails entity)
        {
            base.DeleteEntity(entity);
        }
    }
    #endregion

    #region -------- Currency -----------
    public class CurrencyRepositories : MainRepository<Currency>
    {
        public IEnumerable<Currency> GetAll()
        {
            return base.GetAll<Currency, CurrencyExchangeRate>();
        }
        public IEnumerable<Currency> GetAllByQuery(string query)
        {
            return base.ExecuteSQLStmt<Currency>(query);
        }

        public Currency Get(int Id)
        {
            var obj = new { Currency_Code = Id };

            return base.GetById<Currency>(obj);
        }

        public Currency GetById(int Id)
        {
            var obj = new { Currency_Code = Id };

            return base.GetById<Currency, CurrencyExchangeRate>(obj);
        }

        public IEnumerable<Currency> SearchFor(object param)
        {
            return base.SearchForEntity<Currency>(param);
        }

        public void Add(Currency entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Currency entity)
        {
            Currency oldObj = Get(entity.Currency_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Currency entity)
        {
            base.DeleteEntity(entity);
        }
    }

    public class CurrencyExchangeReturnRepositories : MainRepository<CurrencyExchangeRate>
    {
        public void Delete(CurrencyExchangeRate entity)
        {
            base.DeleteEntity(entity);
        }
    }
    #endregion

    #region -------- Promoter Group -----------
    public class PromoterGroupRepositories : MainRepository<PromoterGroup>
    {
        public PromoterGroup Get(int Id)
        {
            var obj = new { Promoter_Group_Code = Id };

            return base.GetById<PromoterGroup>(obj);
        }
        public IEnumerable<PromoterGroup> GetAllByQuery(string query)
        {
            return base.ExecuteSQLStmt<PromoterGroup>(query);
        }
        public PromoterGroup GetById(int Id)
        {
            var obj = new { Promoter_Group_Code = Id };

            return base.GetById<PromoterGroup>(obj);
        }
        public IEnumerable<PromoterGroup> GetAll()
        {
            return base.GetAll<PromoterGroup>();
        }
        public IEnumerable<PromoterGroup> SearchFor(object param)
        {
            return base.SearchForEntity<PromoterGroup>(param);
        }
        public void Add(PromoterGroup entity)
        {
            base.AddEntity(entity);
        }
        public void Update(PromoterGroup entity)
        {
            PromoterGroup oldObj = Get(entity.Promoter_Group_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
    }
    #endregion

    #region -------- Channel -----------
    public class ChannelRepositories : MainRepository<Channel>
    {
        public Channel Get(int Id)
        {
            var obj = new { Channel_Code = Id };

            return base.GetById<Channel>(obj);
        }
        public IEnumerable<Channel> GetAllByQuery(string query)
        {
            return base.ExecuteSQLStmt<Channel>(query);
        }
        public Channel GetById(int Id)
        {
            var obj = new { Channel_Code = Id };

            return base.GetById<Channel, Entity, ChannelTerritory>(obj);
        }
        public IEnumerable<Channel> GetAll()
        {
            return base.GetAll<Channel, Entity, ChannelTerritory>();
        }
        public IEnumerable<Channel> SearchFor(object param)
        {
            return base.SearchForEntity<Channel>(param);
        }
        public void Add(Channel entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Channel entity)
        {
            Channel oldObj = Get(entity.Channel_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
    }

    public class ChannelCountryDetailsRepositories : MainRepository<ChannelTerritory>
    {
        public void Delete(ChannelTerritory entity)
        {
            base.DeleteEntity(entity);
        }
    }
    #endregion

    #region -------- PaymentTerms -----------
    public class PaymentTermsRepositories : MainRepository<Payment_Terms>
    {
        public Payment_Terms Get(int Id)
        {
            var obj = new { Payment_Terms_Code = Id };

            return base.GetById<Payment_Terms>(obj);
        }
        public IEnumerable<Payment_Terms> GetAll()
        {
            return base.GetAll<Payment_Terms>();
        }
        public void Add(Payment_Terms entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Payment_Terms entity)
        {
            Payment_Terms oldObj = Get(entity.Payment_Terms_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Payment_Terms entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Payment_Terms> SearchFor(object param)
        {
            return base.SearchForEntity<Payment_Terms>(param);
        }

        public IEnumerable<Payment_Terms> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Payment_Terms>(strSQL);
        }
    }
    #endregion

    #region -------- Cost Type -----------
    public class CostTypeRepositories : MainRepository<Cost_Type>
    {
        public Cost_Type Get(int Id)
        {
            var obj = new { Cost_Type_Code = Id };

            return base.GetById<Cost_Type>(obj);
        }
        public IEnumerable<Cost_Type> GetAll()
        {
            return base.GetAll<Cost_Type>();
        }
        public void Add(Cost_Type entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Cost_Type entity)
        {
            Cost_Type oldObj = Get(entity.Cost_Type_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Cost_Type entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Cost_Type> SearchFor(object param)
        {
            return base.SearchForEntity<Cost_Type>(param);
        }

        public IEnumerable<Cost_Type> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Cost_Type>(strSQL);
        }
    }
    #endregion

    #region -------- Deal Segment  -----------
    public class DealSegmentRepositories : MainRepository<Deal_Segment>
    {
        public Deal_Segment Get(int Id)
        {
            var obj = new { Deal_Segment_Code = Id };

            return base.GetById<Deal_Segment>(obj);
        }
        public IEnumerable<Deal_Segment> GetAll()
        {
            return base.GetAll<Deal_Segment>();
        }

        public void Add(Deal_Segment entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Deal_Segment entity)
        {
            Deal_Segment oldObj = Get(entity.Deal_Segment_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public IEnumerable<Deal_Segment> SearchFor(object param)
        {
            return base.SearchForEntity<Deal_Segment>(param);
        }
    }
    #endregion

    #region -------- Revenue Vertical -----------
    public class RevenueVerticalRepositories : MainRepository<Revenue_Vertical>
    {
        public Revenue_Vertical Get(int Id)
        {
            var obj = new { Revenue_Vertical_Code = Id };

            return base.GetById<Revenue_Vertical>(obj);
        }
        public IEnumerable<Revenue_Vertical> GetAll()
        {
            return base.GetAll<Revenue_Vertical>();
        }

        public void Add(Revenue_Vertical entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Revenue_Vertical entity)
        {
            Revenue_Vertical oldObj = Get(entity.Revenue_Vertical_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public IEnumerable<Revenue_Vertical> SearchFor(object param)
        {
            return base.SearchForEntity<Revenue_Vertical>(param);
        }
    }
    #endregion


    #region -------- Assign Work Flow --------
    public class AssignWorkFlowRepositories : MainRepository<Workflow_Module>
  
    {
        public Workflow_Module Get(int Id)
        {
            var obj = new { Workflow_Module_Code = Id };

            return base.GetById<Workflow_Module, Workflow, Business_Unit, System_Module>(obj);
        }
        public IEnumerable<Workflow_Module> GetAll()
        {
            return base.GetAll<Workflow_Module, Workflow , Business_Unit, System_Module>();
        }
    }


    #endregion


}