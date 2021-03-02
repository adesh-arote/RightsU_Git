using Dapper;
using RightsU_Dapper.DAL.Infrastructure;
using RightsU_Dapper.Entity;
using System;
using System.Collections.Generic;
using System.Data;

namespace RightsU_Dapper.DAL.Repository
{
    public class Music_Deal_Repository : MainRepository<Music_Deal_Dapper>
    {
        public Music_Deal_Dapper Get(int? Id)
        {
            var obj = new { Music_Deal_Code = Id };

            return base.GetById<Music_Deal_Dapper>(obj);
        }
        public void Add(Music_Deal_Dapper entity)
        {
            base.AddEntity(entity);
        }
        public void Update(Music_Deal_Dapper entity)
        {
            Music_Deal_Dapper oldObj = Get(entity.Music_Deal_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Music_Deal_Dapper entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Music_Deal_Dapper> GetAll()
        {
            return base.GetAll<Music_Deal_Dapper>();
        }
        public IEnumerable<Music_Deal_Dapper> SearchFor(object param)
        {
            return base.SearchForEntity<Music_Deal_Dapper>(param);
        }
        public IEnumerable<USP_List_Music_Deal_Result> USP_List_Music_Deal(string searchText, string agreement_No, Nullable<System.DateTime> startDate, Nullable<System.DateTime> endDate, string deal_Type_Code, string status_Code, Nullable<int> business_Unit_Code, Nullable<int> deal_Tag_Code, string workflow_Status, string vendor_Codes, string show_Type_Code, string title_Code, string music_Label_Codes, string isAdvance_Search, Nullable<int> user_Code, int pageNo, Nullable<int> pageSize, out int recordCount)
        {
            var param = new DynamicParameters();

            param.Add("@SearchText", searchText);
            param.Add("@Agreement_No", agreement_No);
            param.Add("@StartDate", startDate);
            param.Add("@EndDate", endDate);
            param.Add("@Deal_Type_Code", deal_Type_Code);
            param.Add("@Status_Code", status_Code);
            param.Add("@Business_Unit_Code", business_Unit_Code);
            param.Add("@Deal_Tag_Code", deal_Tag_Code);
            param.Add("@Workflow_Status", workflow_Status);
            param.Add("@Vendor_Codes", vendor_Codes);
            param.Add("@Music_Label_Codes", music_Label_Codes);
            param.Add("@IsAdvance_Search", isAdvance_Search);
            param.Add("@Show_Type_Code", show_Type_Code);
            param.Add("@Title_Code", title_Code);
            param.Add("@User_Code", user_Code);
            param.Add("@PageNo", pageNo);
            param.Add("@PageSize", pageSize);
            param.Add("@RecordCount", dbType: DbType.Int32, direction: ParameterDirection.Output);

            IEnumerable<USP_List_Music_Deal_Result> lstUSP_List_Music_Deal_Result = base.ExecuteSQLProcedure<USP_List_Music_Deal_Result>("USP_List_Music_Deal", param);
            recordCount = param.Get<int>("@RecordCount");
            return lstUSP_List_Music_Deal_Result;
        }

        public IEnumerable<USP_Music_Deal_Link_Show_Result> USP_Music_Deal_Link_Show(string channel_Code, string title_Name, string mode, Nullable<int> music_Deal_Code, string selectedTitleCodes)
        {
            var param = new DynamicParameters();

            param.Add("@Channel_Code", channel_Code);
            param.Add("@Title_Name", title_Name);
            param.Add("@Mode", mode);
            param.Add("@Music_Deal_Code", music_Deal_Code);
            param.Add("@SelectedTitleCodes", selectedTitleCodes);

            return base.ExecuteSQLProcedure<USP_Music_Deal_Link_Show_Result>("USP_Music_Deal_Link_Show", param);

        }
        public IEnumerable<USP_Music_Deal_Schedule_Validation_Result> USP_Music_Deal_Schedule_Validation(int? Music_Deal_Code, string Channel_Codes, string Start_Date, string End_Date, string Title_Codes, string LinkshowType)
        {
            var param = new DynamicParameters();

            param.Add("@Music_Deal_Code", Music_Deal_Code);
            param.Add("@Channel_Codes", Channel_Codes);
            param.Add("@Start_Date", Start_Date);
            param.Add("@End_Date", End_Date);
            param.Add("@LinkedShowType", LinkshowType);
            param.Add("@LinkedTitleCode", Title_Codes);

            return base.ExecuteSQLProcedure<USP_Music_Deal_Schedule_Validation_Result>("USP_Music_Deal_Schedule_Validation", param);
        }

        public string USP_RollBack_Music_Deal(Nullable<int> music_Deal_Code, Nullable<int> user_Code, out string errorMessage)
        {
            var param = new DynamicParameters();

            param.Add("@Music_Deal_Code", music_Deal_Code);
            param.Add("@User_Code", user_Code);
            param.Add("@ErrorMessage", dbType: DbType.String, direction: ParameterDirection.Output);

            string Result = base.ExecuteScalar("USP_RollBack_Music_Deal", param);
            errorMessage = param.Get<string>("@ErrorMessage");
            return Result;

        }
    }

    public class Music_Deal_Platform_Repository : MainRepository<Music_Deal_Platform_Dapper>
    {
        public void DeleteAll(List<Music_Deal_Platform_Dapper> ListEntity)
        {
            base.DeleteAllEntity(ListEntity);
        }
    }
}