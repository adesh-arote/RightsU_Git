using Dapper;
using RightsU_Dapper.DAL.Infrastructure;
using RightsU_Dapper.Entity;
using System;
using System.Collections.Generic;
using System.Data;

namespace RightsU_Dapper.DAL.Repository
{
    public class Music_Deal_Repositories<T> : MainRepository<T>
    {
        public IEnumerable<USP_List_Music_Deal_Result> USP_List_Music_Deal(string searchText, string agreement_No, Nullable<System.DateTime> startDate, Nullable<System.DateTime> endDate, string deal_Type_Code, string status_Code, Nullable<int> business_Unit_Code, Nullable<int> deal_Tag_Code, string workflow_Status, string vendor_Codes, string show_Type_Code, string title_Code, string music_Label_Codes, string isAdvance_Search, Nullable<int> user_Code, int pageNo, Nullable<int> pageSize,out int recordCount)
        {
            var param = new DynamicParameters();

            param.Add("@SearchText", searchText);
            param.Add("@Agreement_No", agreement_No);
            param.Add("@StartDate", startDate);
            param.Add("@EndDate",endDate);
            param.Add("@Deal_Type_Code",deal_Type_Code);
            param.Add("@Status_Code",status_Code);
            param.Add("@Business_Unit_Code",business_Unit_Code);
            param.Add("@Deal_Tag_Code",deal_Tag_Code);
            param.Add("@Workflow_Status",workflow_Status);
            param.Add("@Vendor_Codes",vendor_Codes);
            param.Add("@Music_Label_Codes",music_Label_Codes);
            param.Add("@IsAdvance_Search",isAdvance_Search);
            param.Add("@Show_Type_Code",show_Type_Code);
            param.Add("@Title_Code",title_Code);
            param.Add("@User_Code",user_Code);
            param.Add("@PageNo",pageNo);
            param.Add("@PageSize",pageSize);
            param.Add("@RecordCount", dbType: DbType.Int32, direction: ParameterDirection.Output);

            IEnumerable<USP_List_Music_Deal_Result> lstUSP_List_Music_Deal_Result = base.ExecuteSQLProcedure<USP_List_Music_Deal_Result>("USP_List_Music_Deal", param); 
            recordCount = param.Get<int>("@RecordCount");
            return lstUSP_List_Music_Deal_Result;
        }
    }

}