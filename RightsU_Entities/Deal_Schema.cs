using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public class Deal_Schema
    {
        public Deal_Schema()
        {
            this.List_Rights = new List<USP_List_Rights_Result>();
            this.List_Pushback = new List<USP_List_Rights_Result>();
            this.List_Ancillary = new List<USP_List_Acq_Ancillary_Result>();
            this.List_Sports = new List<USP_List_Rights_Result>();
            this.Title_List = new List<Title_List>();
            this.Module_Rights_List = new List<int>();
        }


        public int Deal_Code { get; set; }
        public int Deal_Type_Code { get; set; }
        public string Agreement_No { get; set; }
        public string Version { get; set; }
        public Nullable<System.DateTime> Agreement_Date { get; set; }
        public string Deal_Desc { get; set; }
        public string Year_Type { get; set; }
        public string Status { get; set; }      //Please replace Deal_Tag to this property
        public string Mode { get; set; }
        public int PageNo { get; set; }
        public bool IncludeSubDeals { get; set; }
        public string Deal_Type_Condition { get; set; }
        public int Master_Deal_Movie_Code { get; set; }
        public int[] Arr_Title_Codes { get; set; }
        public string General_Search_Title_Codes { get; set; }
        public int Module_Code { get; set; }
        public string Title_Icon_Path { get; set; }
        public string Title_Icon_Tooltip { get; set; }

        //For Search Criteria
        public string Rights_Titles { get; set; }
        public string Pushback_Titles { get; set; }
        public string Run_Titles { get; set; }
        public string Ancillary_Titles { get; set; }
        public string Sports_Titles { get; set; }
        public string Content_Search_Titles { get; set; } 
        public string Deal_Type_Text { get; set; }
        public string Title_Image_Path { get; set; }


        public string Rights_View { get; set; }
        public string Pushback_View { get; set; }
        public string Sports_View { get; set; }
        public string Approver_Remark { get; set; }
        public string EWA_Remark { get; set; }
        //Added By Adesh

        public string Page_From { get; set; }
        public int Deal_Tag_Code { get; set; }
        public string Deal_Workflow_Flag { get; set; }
        public string Deal_Workflow_Status { get; set; }
        //End

        public List<USP_List_Rights_Result> List_Rights { get; set; }
        public List<USP_List_Rights_Result> List_Sports { get; set; }
        public List<USP_List_Rights_Result> List_Pushback { get; set; }
        public List<USP_List_Acq_Ancillary_Result> List_Ancillary { get; set; }
        public List<Title_List> Title_List { get; set; }
        public List<int> Module_Rights_List { get; set; }
        public object List_Deal_Tag { get; set; }
        
        public int General_PageNo { get; set; }
        public int General_PageSize { get; set; }
        public int Rights_PageNo { get; set; }
        public int Rights_PageSize { get; set; }
        public int Pushback_PageNo { get; set; }
        public int Pushback_PageSize { get; set; }
        public int Run_PageNo { get; set; }
        public int Run_PageSize { get; set; }
        public int Ancillary_PageNo { get; set; }
        public int Ancillary_PageSize { get; set; }
        public int Cost_PageNo { get; set; }
        public int Cost_PageSize { get; set; }
        public int Budget_PageNo { get; set; }
        public int Budget_PageSize { get; set; }
        public int Content_PageNo { get; set; }
        public int Content_PageSize { get; set; }
        public int Record_Locking_Code { get; set; }

        public string Pushback_Text { get; set; }
        public string Rights_Region { get; set; }
       // public string Rights_Title { get; set; }
        public string Rights_Platform { get; set; }
        public string Rights_Exclusive { get; set; }
        public string Pushback_Region { get; set; }
        public string Pushback_Title { get; set; }
        public string Pushback_Platform { get; set; }
        public string Pushback_Exclusive { get; set; }
        public string Rights_Is_Exclusive { get; set; }   //Added by sayali for holdback validation

    }
}
