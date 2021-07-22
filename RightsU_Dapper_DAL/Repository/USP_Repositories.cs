using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Dapper;
using RightsU_Dapper.DAL.Infrastructure;
using RightsU_Dapper.Entity;
using System.Threading.Tasks;
using System.Data;
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
        public IEnumerable<USP_Get_Platform_Tree_Hierarchy_Result> USP_Get_Platform_Tree_Hierarchy(string platformCodes, string search_Platform_Name)
        {
            var param = new DynamicParameters();
            param.Add("@PlatformCodes", platformCodes);
            param.Add("@Search_Platform_Name", search_Platform_Name);
            return base.ExecuteSQLProcedure<USP_Get_Platform_Tree_Hierarchy_Result>("USP_Get_Platform_Tree_Hierarchy", param);
        }
        public IEnumerable<USP_Music_Exception_Handling_Result> USP_Music_Exception_Handling(string isAired, Nullable<int> pageNo, out int recordCount, string isPaging, Nullable<int> pageSize, string musicTrackCode, string musicLabelCode, string channelCode, string contentCode, string episodeFrom, string episodeTO, string initialResponse, string exceptionStatus, Nullable<int> userCode, string commonSearch, Nullable<System.DateTime> startDate, Nullable<System.DateTime> endDate)
        {
            var param = new DynamicParameters();
            param.Add("@IsAired", isAired);
            param.Add("@PageNo", pageNo);
            param.Add("@RecordCount", dbType: DbType.Int32, direction: ParameterDirection.Output);
            param.Add("@IsPaging", isPaging);
            param.Add("@PageSize", pageSize);
            param.Add("@MusicTrackCode", musicTrackCode);
            param.Add("@MusicLabelCode", musicLabelCode);
            param.Add("@ChannelCode", channelCode);
            param.Add("@ContentCode", contentCode);
            param.Add("@EpisodeFrom", episodeFrom);
            param.Add("@EpisodeTO", episodeTO);
            param.Add("@InitialResponse", initialResponse);
            param.Add("@ExceptionStatus", exceptionStatus);
            param.Add("@UserCode", userCode);
            param.Add("@CommonSearch", commonSearch);
            param.Add("@StartDate", startDate);
            param.Add("@EndDate", endDate);

            IEnumerable<USP_Music_Exception_Handling_Result> lstUSP_Music_Exception_Handling_Result = base.ExecuteSQLProcedure<USP_Music_Exception_Handling_Result>("USP_Music_Exception_Handling", param);
            recordCount = param.Get<int>("@RecordCount");
            return lstUSP_Music_Exception_Handling_Result;
        }
        public IEnumerable<USP_Music_Exception_Dashboard_Result> USP_Music_Exception_Dashboard(string isAired, string musicTrackCode, string musicLabelCode, string channelCode, string contentCode, string episodeFrom, string episodeTO, string initialResponse, string exceptionStatus, Nullable<int> userCode, string commonSearch, Nullable<System.DateTime> startDate, Nullable<System.DateTime> endDate)
        {
            var param = new DynamicParameters();
            param.Add("@IsAired", isAired);
            param.Add("@MusicTrackCode", musicTrackCode);
            param.Add("@MusicLabelCode", musicLabelCode);
            param.Add("@ChannelCode", channelCode);
            param.Add("@ContentCode", contentCode);
            param.Add("@EpisodeFrom", episodeFrom);
            param.Add("@EpisodeTO", episodeTO);
            param.Add("@InitialResponse", initialResponse);
            param.Add("@ExceptionStatus", exceptionStatus);
            param.Add("@UserCode", userCode);
            param.Add("@CommonSearch", commonSearch);
            param.Add("@StartDate", startDate);
            param.Add("@EndDate", endDate);

            return base.ExecuteSQLProcedure<USP_Music_Exception_Dashboard_Result>("USP_Music_Exception_Dashboard", param);
        }
        public IEnumerable<USP_List_Status_History_Result> USP_List_Status_History(Nullable<int> record_Code, Nullable<int> module_Code)
        {
            var param = new DynamicParameters();
            param.Add("@Record_Code", record_Code);
            param.Add("@Module_Code", module_Code);

            return base.ExecuteSQLProcedure<USP_List_Status_History_Result>("USP_List_Status_History", param);
        }
        public IEnumerable<string> USP_Assign_Workflow(Nullable<int> record_Code, Nullable<int> module_Code, Nullable<int> login_User, string remarks_Approval)
        {
            var param = new DynamicParameters();
            param.Add("@Record_Code", record_Code);
            param.Add("@Module_Code", module_Code);
            param.Add("@Login_User", login_User);
            param.Add("@Remarks_Approval", remarks_Approval);

            return base.ExecuteSQLProcedure<string>("USP_Assign_Workflow", param);
        }
        //public virtual int USP_UpdateContentHouseID(Nullable<int> BV_HouseId_Data_Code, Nullable<int> MappedDealTitleCode)
        //{
        //    var param = new DynamicParameters();
        //    param.Add("@BV_HouseId_Data_Code", BV_HouseId_Data_Code);
        //    param.Add("@MappedDealTitleCode", MappedDealTitleCode);
        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("USP_UpdateContentHouseID", BV_HouseId_Data_CodeParameter, MappedDealTitleCodeParameter);
        //    return base.ExecuteSQLProcedure<USP_UpdateContentHouseID_Result>("USP_UpdateContentHouseID", param);
        //}
        public IEnumerable<USP_Get_Title_PreReq_Result> USP_Get_Title_PreReq(string data_For, Nullable<int> deal_Type_Code, Nullable<int> business_Unit_Code, string search_String)
        {
            var param = new DynamicParameters();
            param.Add("@Data_For", data_For);
            param.Add("@Deal_Type_Code", deal_Type_Code);
            param.Add("@Business_Unit_Code", business_Unit_Code);
            param.Add("@Search_String", search_String);
            return base.ExecuteSQLProcedure<USP_Get_Title_PreReq_Result>("USP_Get_Title_PreReq", param);
        }
        public IEnumerable<USP_Get_Talent_Name_Result> USP_Get_Talent_Name()
        {
            return base.ExecuteSQLStmt<USP_Get_Talent_Name_Result>("USP_Get_Talent_Name"); 
        }
        public IEnumerable<USP_List_Music_Title_Result> USP_List_Music_Title(string musicTitleName, Nullable<int> sysLanguageCode, Nullable<int> pageNo, out int recordCount, string isPaging, Nullable<int> pageSize, string starCastCode, string languageCode, string albumCode, string genresCode, string musicLabelCode, string yearOfRelease, string singerCode, string composerCode, string lyricistCode, string musicNameText, string themeCode, string musicTag, string publicDomain, string exactMatch)
        {
            var param = new DynamicParameters();
            param.Add("@MusicTitleName", musicTitleName);
            param.Add("@SysLanguageCode", sysLanguageCode);
            param.Add("@PageNo", pageNo);
            param.Add("@RecordCount", dbType: DbType.Int32, direction: ParameterDirection.Output);
            param.Add("@IsPaging", isPaging);
            param.Add("@PageSize", pageSize);
            param.Add("@StarCastCode", starCastCode);
            param.Add("@LanguageCode", languageCode);
            param.Add("@AlbumCode", albumCode);
            param.Add("@GenresCode", genresCode);
            param.Add("@MusicLabelCode", musicLabelCode);
            param.Add("@YearOfRelease", yearOfRelease);
            param.Add("@SingerCode", singerCode);
            param.Add("@ComposerCode", composerCode);
            param.Add("@LyricistCode", lyricistCode);
            param.Add("@MusicNameText", musicNameText);
            param.Add("@ThemeCode", themeCode);
            param.Add("@MusicTag", musicTag);
            param.Add("@PublicDomain", publicDomain);
            param.Add("@ExactMatch", exactMatch);

            IEnumerable<USP_List_Music_Title_Result> lstUSP_List_Music_Title_Result = base.ExecuteSQLProcedure<USP_List_Music_Title_Result>("USP_List_Music_Title", param);
            recordCount = param.Get<int>("@RecordCount");
            return lstUSP_List_Music_Title_Result;
        }
        public IEnumerable<USP_Insert_Music_Title_Import_UDT> USP_Insert_Music_Title_Import_UDT(
        List<Music_Title_Import_UDT> lstMusic_Title_Import_UDT, int User_Code
          )
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Music_Title_Import", lstMusic_Title_Import_UDT);
            parameters.Add("@User_Code", User_Code);
            var query = "[USP_Insert_Music_Title_Import_UDT]";
            return base.ExecuteSQLProcedure<USP_Insert_Music_Title_Import_UDT>(query, parameters);
            //var proc = new USP_Insert_Music_Title_Import_UDT();
            ////proc.Music_Title_Import = lstMusic_Title_Import_UDT;
            //proc.User_Code = User_Code;
            //return base.ExecuteSQLStmt<USP_Insert_Music_Title_Import_UDT>("USP_Get_Talent_Name");
            //return this.Database.ExecuteStoredProcedure<USP_Insert_Music_Title_Import_UDT>(proc);
        }
        public IEnumerable<USP_Music_Title_Contents_Result> USP_Music_Title_Contents(Nullable<int> Music_Title_Code, string GenericSearch, out int RecordCount, string IsPaging, Nullable<int> PageSize, Nullable<int> PageNo)
        {
            var param = new DynamicParameters();
            param.Add("", Music_Title_Code);
            param.Add("", GenericSearch);
            param.Add("@RecordCount", dbType: DbType.Int32, direction: ParameterDirection.Output);
            param.Add("", IsPaging);
            param.Add("", PageSize);
            param.Add("", PageNo);

            IEnumerable<USP_Music_Title_Contents_Result> lstUSP_Music_Title_Contents = base.ExecuteSQLProcedure<USP_Music_Title_Contents_Result>("USP_Music_Title_Contents", param);
            RecordCount = param.Get<int>("@RecordCount");
            return lstUSP_Music_Title_Contents;
   
        }
    }
}

