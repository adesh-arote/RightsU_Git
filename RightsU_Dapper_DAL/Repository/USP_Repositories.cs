using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Dapper;
using RightsU_Dapper.DAL.Infrastructure;
using RightsU_Dapper.Entity;
using System.Threading.Tasks;
//using RightsU_Entities;
//using System.Data.Entity.Core.Objects;
//using System.Data.Entity.Infrastructure;


namespace RightsU_Dapper.DAL.Repository
{
    /// <summary>
    /// This class creates an instance of DBContext and calls database stored procedures
    /// </summary>
    ///
    public class USP_Repositories : ProcRepository
    {
        //private readonly DBConnection dbConnection;
        //public MainRepository()
        //{
        //    this.dbConnection = new DBConnection();
        //}
        public string USP_MODULE_RIGHTS(Nullable<int> module_Code, Nullable<int> security_Group_Code, Nullable<int> users_Code)
        {
            var param = new DynamicParameters();

            param.Add("@Module_Code", module_Code);
            param.Add("@Security_Group_Code", security_Group_Code);
            param.Add("@Users_Code", users_Code);

            string Result = base.ExecuteScalar("USP_MODULE_RIGHTS", param);
            return Result;

        }
        public IEnumerable<string> USP_Validate_Talent_Master(Nullable<int> talent_Code, string selected_Role_Code)
        {
            var param = new DynamicParameters();

            param.Add("@Talent_Code", talent_Code);
            param.Add("@Selected_Role_Code", selected_Role_Code);
            IEnumerable<string> Result = base.ExecuteSQLProcedure<string>("USP_Validate_Talent_Master", param);
            return Result;
        }
        public IEnumerable<USP_List_Country_Result> USP_List_Country(Nullable<int> sysLanguageCode)
        {
            var param = new DynamicParameters();
            param.Add("@SysLanguageCode", sysLanguageCode);
            //IEnumerable<USP_List_Country_Result> Result = base.ExecuteSQLProcedure<USP_List_Country_Result>("USP_List_Country", param);
            return base.ExecuteSQLProcedure<USP_List_Country_Result>("USP_List_Country", param);
            // return Result;
            //var sysLanguageCodeParameter = sysLanguageCode.HasValue ?
            //    new ObjectParameter("SysLanguageCode", sysLanguageCode) :
            //    new ObjectParameter("SysLanguageCode", typeof(int));

            //return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<USP_List_Country_Result>("USP_List_Country", sysLanguageCodeParameter);
        }
        public IEnumerable<USP_Uploaded_File_Error_List_Result> USP_Uploaded_File_Error_List(Nullable<int> file_Code)
        {
            var param = new DynamicParameters();
            param.Add("@Upload_Detail_Code", file_Code);
            return base.ExecuteSQLProcedure<USP_Uploaded_File_Error_List_Result>("USP_Uploaded_File_Error_List", param);
        }
        public IEnumerable<USP_GET_TITLE_DATA_Result> USP_GET_TITLE_DATA(string searchTitle, Nullable<int> deal_Type_Code)
        {
            //RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            var param = new DynamicParameters();
            param.Add("@SearchTitle", searchTitle);
            param.Add("@Deal_Type_Code", deal_Type_Code);
            return base.ExecuteSQLProcedure<USP_GET_TITLE_DATA_Result>("USP_GET_TITLE_DATA", param);
        }
        public IEnumerable<USP_Validate_Episode_Result> USP_Validate_Episode(string title_with_Episode, string Program_Type)
        {
            var param = new DynamicParameters();
            param.Add("@SearchTitle", title_with_Episode);
            param.Add("@Deal_Type_Code", Program_Type);
            return base.ExecuteSQLProcedure<USP_Validate_Episode_Result>("USP_GET_TITLE_DATA", param);
        }
        //public virtual int USP_UpdateContentHouseID(Nullable<int> BV_HouseId_Data_Code, Nullable<int> MappedDealTitleCode)
        //{
        //    var param = new DynamicParameters();
        //    param.Add("@BV_HouseId_Data_Code", BV_HouseId_Data_Code);
        //    param.Add("@MappedDealTitleCode", MappedDealTitleCode);
        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("USP_UpdateContentHouseID", BV_HouseId_Data_CodeParameter, MappedDealTitleCodeParameter);
        //    return base.ExecuteSQLProcedure<USP_UpdateContentHouseID_Result>("USP_UpdateContentHouseID", param);
        //}

    }
}
