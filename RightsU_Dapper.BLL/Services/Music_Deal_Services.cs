using RightsU_Dapper.DAL.Repository;
using RightsU_Dapper.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.BLL.Services
{
    public class Music_Deal_Services
    {
        public IEnumerable<USP_List_Music_Deal_Result> USP_List_Music_Deal(string searchText, string agreement_No, Nullable<System.DateTime> startDate, Nullable<System.DateTime> endDate, string deal_Type_Code, string status_Code, Nullable<int> business_Unit_Code, Nullable<int> deal_Tag_Code, string workflow_Status, string vendor_Codes, string show_Type_Code, string title_Code, string music_Label_Codes, string isAdvance_Search, Nullable<int> user_Code,int  pageNo, Nullable<int> pageSize,out int  recordCount)
        {
            Music_Deal_Repositories<USP_List_Music_Deal_Result> objMusic_Deal_Repositories = new Music_Deal_Repositories<USP_List_Music_Deal_Result>();
            return objMusic_Deal_Repositories.USP_List_Music_Deal(searchText, agreement_No, startDate, endDate, deal_Type_Code, status_Code, business_Unit_Code, deal_Tag_Code, workflow_Status, vendor_Codes, show_Type_Code, title_Code, music_Label_Codes, isAdvance_Search, user_Code, pageNo, pageSize, out recordCount);
        }
    }
}
