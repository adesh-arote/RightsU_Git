﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RightsU_Entities;
using System.Data.Entity.Core.Objects;
using System.Data.Entity.Infrastructure;


namespace RightsU_DAL
{
    /// <summary>
    /// This class creates an instance of DBContext and calls database stored procedures
    /// </summary>
    public class USP_DAL
    {
        private string _conStr;
        public string conStr
        {
            get { return _conStr; }
            set { _conStr = value; }
        }

        public USP_DAL(string strConString)
        {
            conStr = strConString;
        }

        #region Sps for List Pages
        public virtual ObjectResult<USP_List_Acq_Ancillary_Result> USP_List_Acq_Ancillary(Nullable<int> acq_Deal_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Acq_Ancillary(acq_Deal_Code);
        }

        public virtual ObjectResult<USP_List_Acq_Result> USP_List_Acq(string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, Nullable<int> user_Code, string exactMatch, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Acq(strSearch, pageNo, orderByCndition, isPaging, pageSize, recordCount, user_Code, exactMatch );
        }

        public ObjectResult<USP_List_Syn_Result> USP_List_Syn(string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, ObjectParameter recordCount, Nullable<int> user_Code, string ExactMatch)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Syn(strSearch, pageNo, orderByCndition, isPaging, pageSize, recordCount, user_Code, ExactMatch);
        }
        public virtual ObjectResult<USP_List_Acq_Deal_Status_Result> USP_List_Acq_Deal_Status(Nullable<int> acq_Deal_Code, string debug)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Acq_Deal_Status(acq_Deal_Code, debug);
        }
        #endregion

        public ObjectResult<USP_Get_Territory_ForDDL_Result> USP_Get_Territory_ForDDL(string IsThetrical)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Territory_ForDDL(IsThetrical);
        }

        public ObjectResult<USP_Get_Platform_Tree_Hierarchy_Result> USP_Get_Platform_Tree_Hierarchy(string platformCodes, string search_Platform_Name,string IS_Sport_Right)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Platform_Tree_Hierarchy(platformCodes, search_Platform_Name, IS_Sport_Right);

        }
        public ObjectResult<USP_Get_Promoter_Group_Tree_Hierarchy_Result> USP_Get_Promoter_Group_Tree_Hierarchy(string promoter_GroupCodes, string search_Promoter_Group_Name)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Promoter_Group_Tree_Hierarchy(promoter_GroupCodes, search_Promoter_Group_Name);

        }

        public ObjectResult<USP_Generate_Deal_Type_Year_Result> USP_Generate_Deal_Type_Year
            (string yearDefinition, Nullable<System.DateTime> stDt, Nullable<System.DateTime> enDt)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Generate_Deal_Type_Year(yearDefinition, stDt, enDt);
        }

        public ObjectResult<USP_Ancillary_Validate_Result> USP_Ancillary_Validate(Nullable<int> acq_Deal_Code, Nullable<int> acq_Deal_Ancillary_Code, Nullable<int> ancillary_Type_code, string title_Code, string ancillary_Platform_Code, string ancillary_Platform_Medium_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Ancillary_Validate(acq_Deal_Code, acq_Deal_Ancillary_Code, ancillary_Type_code, title_Code, ancillary_Platform_Code, ancillary_Platform_Medium_Code);
        }

        public IEnumerable<USP_Ancillary_Validate_Udt> USP_Ancillary_Validate_Udt(
            List<Deal_Ancillary_Title_UDT> lstAncillary_Title,
            List<Deal_Ancillary_Platform_UDT> lstAncillary_Platform,
            List<Deal_Ancillary_Platform_Medium_UDT> lstAncillary_Platform_Medium, int Ancillary_Type_code, string Catch_Up_From, int Acq_Deal_Ancillary_Code, int Acq_Deal_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Ancillary_Validate_Udt(lstAncillary_Title, lstAncillary_Platform, lstAncillary_Platform_Medium, Ancillary_Type_code, Catch_Up_From, Acq_Deal_Ancillary_Code, Acq_Deal_Code);
        }

        public IEnumerable<USP_Validate_Rights_Duplication_UDT> USP_Validate_Rights_Duplication_UDT(
            List<Deal_Rights_UDT> LstDeal_Rights_UDT,
            List<Deal_Rights_Title_UDT> LstDeal_Rights_Title_UDT,
            List<Deal_Rights_Platform_UDT> LstDeal_Rights_Platform_UDT,
            List<Deal_Rights_Territory_UDT> LstDeal_Rights_Territory_UDT,
            List<Deal_Rights_Subtitling_UDT> LstDeal_Rights_Subtitling_UDT,
            List<Deal_Rights_Dubbing_UDT> LstDeal_Rights_Dubbing_UDT,
            string CallFrom
            )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Rights_Duplication_UDT(
                LstDeal_Rights_UDT, LstDeal_Rights_Title_UDT, LstDeal_Rights_Platform_UDT, LstDeal_Rights_Territory_UDT, LstDeal_Rights_Subtitling_UDT, LstDeal_Rights_Dubbing_UDT, CallFrom
                );
        }

        public IEnumerable<USP_Validate_Rev_HB_Duplication_UDT_Acq> USP_Validate_Rev_HB_Duplication_UDT(
            List<Deal_Rights_UDT> LstDeal_Rights_UDT,
            List<Deal_Rights_Title_UDT> LstDeal_Rights_Title_UDT,
            List<Deal_Rights_Platform_UDT> LstDeal_Rights_Platform_UDT,
            List<Deal_Rights_Territory_UDT> LstDeal_Rights_Territory_UDT,
            List<Deal_Rights_Subtitling_UDT> LstDeal_Rights_Subtitling_UDT,
            List<Deal_Rights_Dubbing_UDT> LstDeal_Rights_Dubbing_UDT
            //string CallFrom
            )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Rev_HB_Duplication_UDT(
                LstDeal_Rights_UDT, LstDeal_Rights_Title_UDT, LstDeal_Rights_Platform_UDT, LstDeal_Rights_Territory_UDT, LstDeal_Rights_Subtitling_UDT, LstDeal_Rights_Dubbing_UDT/*, CallFrom*/
                );
        }

        public IEnumerable<USP_Get_Data_Restriction_Remark_UDT> USP_Get_Data_Restriction_Remark_UDT(
            List<Deal_Rights_UDT> LstDeal_Rights_UDT,
            List<Deal_Rights_Title_UDT> LstDeal_Rights_Title_UDT,
            List<Deal_Rights_Platform_UDT> LstDeal_Rights_Platform_UDT,
            List<Deal_Rights_Territory_UDT> LstDeal_Rights_Territory_UDT,
            List<Deal_Rights_Subtitling_UDT> LstDeal_Rights_Subtitling_UDT,
            List<Deal_Rights_Dubbing_UDT> LstDeal_Rights_Dubbing_UDT
            )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Data_Restriction_Remark_UDT(
                LstDeal_Rights_UDT, LstDeal_Rights_Title_UDT, LstDeal_Rights_Platform_UDT, LstDeal_Rights_Territory_UDT, LstDeal_Rights_Subtitling_UDT, LstDeal_Rights_Dubbing_UDT);
        }
        public IEnumerable<USP_CheckHoldbackForSyn_UDT> USP_CheckHoldbackForSyn_UDT(
          List<Deal_Rights_UDT> LstDeal_Rights_UDT,
          List<Deal_Rights_Title_UDT> LstDeal_Rights_Title_UDT,
          List<Deal_Rights_Platform_UDT> LstDeal_Rights_Platform_UDT,
          List<Deal_Rights_Territory_UDT> LstDeal_Rights_Territory_UDT,
          List<Deal_Rights_Subtitling_UDT> LstDeal_Rights_Subtitling_UDT,
          List<Deal_Rights_Dubbing_UDT> LstDeal_Rights_Dubbing_UDT
          )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_CheckHoldbackForSyn_UDT(
                LstDeal_Rights_UDT, LstDeal_Rights_Title_UDT, LstDeal_Rights_Platform_UDT, LstDeal_Rights_Territory_UDT, LstDeal_Rights_Subtitling_UDT, LstDeal_Rights_Dubbing_UDT);
        }

        public IEnumerable<USP_Validate_Show_Episode_UDT> USP_Validate_Show_Episode_UDT(
            List<Deal_Rights_Title_UDT> LstDeal_Rights_Title_UDT
            )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Show_Episode_UDT(
                LstDeal_Rights_Title_UDT
                );
        }
        public IEnumerable<USP_Validate_Title_Talent_UDT> USP_Validate_Title_Talent_UDT(
            List<Title_Talent_Role_UDT> Lst_Title_Talent_Role_UDT
            , string CallFrom
            )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Title_Talent_UDT(
                Lst_Title_Talent_Role_UDT, CallFrom
                );
        }

        public ObjectResult<USP_Get_Acq_Rights_Details_Codes_Result> USP_Get_Acq_Rights_Details_Codes_Result(string title_Code, Nullable<int> deal_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Acq_Rights_Details_Codes(title_Code, deal_Code);
        }

        public virtual ObjectResult<USP_List_Rights_Result> USP_List_Rights(string right_Type, string view_Type, Nullable<int> deal_Code, string deal_Movie_Codes, string region_Code, string platform_Code, string IsExclusive, ObjectParameter pageNo, Nullable<int> pageSize, ObjectParameter totalRecord, string searchText)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Rights(right_Type, view_Type, deal_Code, deal_Movie_Codes, region_Code, platform_Code, IsExclusive, pageNo, pageSize, totalRecord, searchText);
        }

        public virtual ObjectResult<USP_GET_DATA_FOR_APPROVED_TITLES_Result> USP_GET_DATA_FOR_APPROVED_TITLES(string title_Codes, string platform_Codes, string platform_Type, string region_Type, string subtitling_Type, string dubbing_Type, Nullable<int> syn_Deal_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GET_DATA_FOR_APPROVED_TITLES(title_Codes, platform_Codes, platform_Type, region_Type, subtitling_Type, dubbing_Type, syn_Deal_Code);
        }
        public virtual ObjectResult<USP_VALIDATE_TITLES_FOR_YEARWISE_RUN_Result> USP_VALIDATE_TITLES_FOR_YEARWISE_RUN(string tITLE_CODES, Nullable<int> dEAL_CODE)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_VALIDATE_TITLES_FOR_YEARWISE_RUN(tITLE_CODES, dEAL_CODE);
        }

        public ObjectResult<string> USP_Assign_Workflow(Nullable<int> record_Code, Nullable<int> module_Code, Nullable<int> login_User, string remarks_Approval)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Assign_Workflow(record_Code, module_Code, login_User, remarks_Approval);
        }

        public ObjectResult<string> USP_Process_Workflow(Nullable<int> record_Code, Nullable<int> module_Code, Nullable<int> login_User, string user_Action, string remarks)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Process_Workflow(record_Code, module_Code, login_User, user_Action, remarks);
        }

        public ObjectResult<string> USP_Check_Workflow(Nullable<int> record_Code, Nullable<int> module_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Check_Workflow(module_Code, record_Code);
        }

        public ObjectResult<int> USP_Get_Creator_Group_Code_AfterReject(Nullable<int> record_Code, Nullable<int> module_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Creator_Group_Code_AfterReject(module_Code, record_Code);
        }

        public virtual ObjectResult<USP_Validate_Run_Result> USP_Validate_Run(string tITLE_CODE, string rUN_TYPE, string iSYEARWISE, string iSRULERIGHT, string iSCHANNELWISE, string cHANNEL_CODES, Nullable<int> aCQ_DEAL_RUN_CODE, Nullable<int> aCQ_DEAL_CODE)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Run(tITLE_CODE, rUN_TYPE, iSYEARWISE, iSRULERIGHT, iSCHANNELWISE, cHANNEL_CODES, aCQ_DEAL_RUN_CODE, aCQ_DEAL_CODE);

        }

        public virtual ObjectResult<string> USP_Validate_RIGHT_FOR_RUN(Nullable<int> aCQ_DEAL_CODE)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_RIGHT_FOR_RUN(aCQ_DEAL_CODE);
        }

        public virtual ObjectResult<USP_GET_TITLE_FOR_RUN_Result> USP_GET_TITLE_FOR_RUN(Nullable<int> aCQ_DEAL_CODE)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GET_TITLE_FOR_RUN(aCQ_DEAL_CODE);
        }

        public virtual ObjectResult<USP_Validate_YEARWISE_RIGHT_FOR_RUN_Result> USP_Validate_YEARWISE_RIGHT_FOR_RUN(Nullable<int> aCQ_DEAL_CODE, Nullable<int> aCQ_DEAL_RUN_CODE, string tITLE_CODE, Nullable<System.DateTime> mIN_YEARWISE_START_DATE, Nullable<System.DateTime> mAX_YEARWISE_END_DATE)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_YEARWISE_RIGHT_FOR_RUN(aCQ_DEAL_CODE, aCQ_DEAL_RUN_CODE, tITLE_CODE, mIN_YEARWISE_START_DATE, mAX_YEARWISE_END_DATE);
        }

        public virtual ObjectResult<USP_List_Status_History_Result> USP_List_Status_History(Nullable<int> record_Code, Nullable<int> module_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Status_History(record_Code, module_Code);
        }

        #region Rollback USP
        public virtual ObjectResult<USP_RollBack_Acq_Deal_Result> USP_RollBack_Acq_Deal(Nullable<int> acq_Deal_Code, Nullable<int> user_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_RollBack_Acq_Deal(acq_Deal_Code, user_Code);
        }

        public virtual ObjectResult<USP_RollBack_Syn_Deal_Result> USP_RollBack_Syn_Deal(Nullable<int> syn_Deal_Code, Nullable<int> user_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_RollBack_Syn_Deal(syn_Deal_Code, user_Code);
        }
        #endregion

        public virtual ObjectResult<USP_Add_ACQ_Milestone_Result> USP_Add_ACQ_Milestone(Nullable<int> acq_Deal_Code, string debug)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Add_ACQ_Milestone(acq_Deal_Code, debug);
        }

        public virtual ObjectResult<USP_Schedule_AsRun_Report_Result> USP_Schedule_AsRun_Report(string title, Nullable<int> episodeFrom, Nullable<int> episodeTo, string isShowAll, string startDate = "", string endDate = "", string channel = "", Nullable<bool> excludeExpiredDeal = true, string runType = "")
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Schedule_AsRun_Report(title, episodeFrom, episodeTo, isShowAll, startDate, endDate, channel, excludeExpiredDeal, runType);
        }
        public virtual ObjectResult<string> USP_DELETE_Deal(Nullable<int> acq_Deal_Code, string debug)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_DELETE_Deal(acq_Deal_Code, debug);
        }
        public virtual ObjectResult<USP_Schedule_ShowDetails_Sche_Report_Result> USP_Schedule_ShowDetails_Sche_Report(string dMCode, Nullable<int> title_Code, Nullable<int> deal_Code, Nullable<int> episode, string deal_Type, string startDate, string endDate, string channel, Nullable<bool> excludeExpiredDeal, string runType)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Schedule_ShowDetails_Sche_Report(dMCode, title_Code, deal_Code, episode, deal_Type, startDate, endDate, channel, excludeExpiredDeal, runType);
        }
        public virtual int USP_AT_Acq_Deal(Nullable<int> acq_Deal_Code, ObjectParameter is_Error)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_AT_Acq_Deal(acq_Deal_Code, is_Error);
        }

        public virtual int USP_Edit_Without_Approval(Nullable<int> acq_Deal_Code, string mode, Nullable<int> user_Code, string remarks)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Edit_Without_Approval(acq_Deal_Code, mode, user_Code, remarks);
        }

        public virtual int USP_Insert_Module_Status_History(Nullable<int> module_Code, Nullable<int> record_Code, string user_Action, Nullable<int> login_User, string remarks)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Insert_Module_Status_History(module_Code, record_Code, user_Action, login_User, remarks);
        }

        public virtual ObjectResult<USP_Get_Dashboard_Detail_Result> USP_Get_Dashboard_Detail(string dashboardType, string searchFor, Nullable<int> user_Code, Nullable<int> dashboardDays)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Dashboard_Detail(dashboardType, searchFor, user_Code, dashboardDays);
        }
        public virtual ObjectResult<USP_Get_IPR_Dashboard_Details_Result> USP_Get_IPR_Dashboard_Detail(string dashboardType, string searchFor, Nullable<int> user_Code, Nullable<int> dashboardDays)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_IPR_Dashboard_Detail(dashboardType, searchFor, user_Code, dashboardDays);
        }

        public virtual ObjectResult<string> USP_Get_Title_Language(string title_Codes)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Title_Language(title_Codes);
        }

        public virtual ObjectResult<USP_Select_Mass_Territory_Update_Result> USP_Select_Mass_Territory_Update(string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, string dealFor, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Select_Mass_Territory_Update(strSearch, pageNo, orderByCndition, isPaging, pageSize, dealFor, recordCount);
        }


        public virtual int USP_Update_Mass_Territory_Update(string acqDealMassCodes, string dealFor)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Update_Mass_Territory_Update(acqDealMassCodes, dealFor);
        }

        public ObjectResult<USP_List_Sports_Result> USP_Sports_List_Result(Nullable<int> acq_Deal_Code, string view_Type, string title_Codes, string deal_Movie_Codes)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Sports(acq_Deal_Code, view_Type, title_Codes, deal_Movie_Codes);
        }
        public ObjectResult<USP_Search_Run_Shows_Result> USP_Search_Run_Shows(string searchCriteria, string data_For_flag, string selectedDealMovieCodes, string selectedChannelNames, string selectedTitleCodes, string unCheck_Run_Shows_Code, Nullable<int> run_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Search_Run_Shows(searchCriteria, data_For_flag, selectedDealMovieCodes, selectedChannelNames, selectedTitleCodes, unCheck_Run_Shows_Code, run_Code);
        }
        public virtual ObjectResult<USP_List_Syn_Deal_Status_Result> USP_List_Syn_Deal_Status(Nullable<int> syn_Deal_Code, string debug)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Syn_Deal_Status(syn_Deal_Code, debug);
        }

        public virtual ObjectResult<string> USP_DELETE_Syn_DEAL(Nullable<int> syn_Deal_Code, string debug)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_DELETE_Syn_DEAL(syn_Deal_Code, debug);
        }

        public virtual ObjectResult<USP_Syn_List_Runs_Result> USP_Syn_List_Runs(Nullable<int> deal_Code, string title_Codes)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Syn_List_Runs(deal_Code, title_Codes);
        }

        public virtual ObjectResult<USP_VALIDATE_SYN_TITLES_Result> USP_VALIDATE_SYN_TITLES(string tITLE_CODES, Nullable<int> dEAL_CODE)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_VALIDATE_SYN_TITLES(tITLE_CODES, dEAL_CODE);
        }

        public virtual ObjectResult<string> USP_Validate_RIGHT_FOR_SYN_RUN(Nullable<int> sYN_DEAL_CODE)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_RIGHT_FOR_SYN_RUN(sYN_DEAL_CODE);
        }

        public virtual ObjectResult<USP_Validate_SYN_YEARWISE_RIGHT_FOR_RUN_Result> USP_Validate_SYN_YEARWISE_RIGHT_FOR_RUN(Nullable<int> sYN_DEAL_CODE, Nullable<int> sYN_DEAL_RUN_CODE, string tITLE_CODE, Nullable<System.DateTime> mIN_YEARWISE_START_DATE, Nullable<System.DateTime> mAX_YEARWISE_END_DATE)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_SYN_YEARWISE_RIGHT_FOR_RUN(sYN_DEAL_CODE, sYN_DEAL_RUN_CODE, tITLE_CODE, mIN_YEARWISE_START_DATE, mAX_YEARWISE_END_DATE);
        }

        public virtual ObjectResult<USP_Validate_Duplicate_Syn_Run_Result> USP_Validate_Duplicate_Syn_Run(string tITLE_CODE, string pLATFORM_CODE, Nullable<int> sYN_DEAL_RUN_CODE, Nullable<int> sYN_DEAL_CODE)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Duplicate_Syn_Run(tITLE_CODE, pLATFORM_CODE, sYN_DEAL_RUN_CODE, sYN_DEAL_CODE);
        }

        public virtual ObjectResult<StatusMessage> USP_Validate_General_Delete_For_Title(Nullable<int> syn_Deal_Code, Nullable<int> title_Code, Nullable<int> episode_From, Nullable<int> episode_To, string checkFor)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_General_Delete_For_Title(syn_Deal_Code, title_Code, episode_From, episode_To, checkFor);
        }

        public virtual ObjectResult<Nullable<int>> USP_Check_Acq_Deal_Status_For_Syn(Nullable<int> syn_Deal_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Check_Acq_Deal_Status_For_Syn(syn_Deal_Code);
        }

        public virtual int USP_Invoke_Validation_Job()
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Invoke_Validation_Job();
        }

        public virtual ObjectResult<USP_Get_Syn_Rights_Errors_Result> USP_Get_Syn_Rights_Errors(Nullable<int> code, string call_From)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Syn_Rights_Errors(code, call_From);
        }

        public virtual int USP_Reprocess_Rights(Nullable<int> code, string call_From)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Reprocess_Rights(code, call_From);
        }

        public IEnumerable<string> USP_Validate_Platform_Run_UDT(
            List<Deal_Rights_Title_UDT> LstDeal_Rights_Title_UDT,
            List<Deal_Rights_Platform_UDT> LstDeal_Rights_Platform_UDT,
            int Deal_Rights_Code,
            int Deal_Code,
            string CallFrom
            )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Platform_Run_UDT(
                LstDeal_Rights_Title_UDT, LstDeal_Rights_Platform_UDT, Deal_Rights_Code, Deal_Code, CallFrom);
        }

        public virtual ObjectResult<USP_Populate_Titles_Result> USP_Populate_Titles(Nullable<int> deal_Code, Nullable<int> deal_Type_Code, Nullable<int> master_Deal_Movie_Code, string selected_Title_Codes, string callFrom)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Populate_Titles(deal_Code, deal_Type_Code, master_Deal_Movie_Code, selected_Title_Codes, callFrom);
        }

        public virtual ObjectResult<string> USP_Acq_Copy_Right_For_Sub_Deal(Nullable<int> acq_Deal_Code, Nullable<int> master_Deal_Movie_Code, Nullable<int> user_Code, string selected_Title_Codes)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Acq_Copy_Right_For_Sub_Deal(acq_Deal_Code, master_Deal_Movie_Code, user_Code, selected_Title_Codes);
        }
        //public IEnumerable<string> USP_Syn_Acq_Mapping_UDT(
        //  List<Deal_Rights_UDT> LstDeal_Rights_UDT,
        //  List<Deal_Rights_Title_UDT> LstDeal_Rights_Title_UDT,
        //  List<Deal_Rights_Platform_UDT> LstDeal_Rights_Platform_UDT,
        //  List<Deal_Rights_Territory_UDT> LstDeal_Rights_Territory_UDT,
        //  List<Deal_Rights_Subtitling_UDT> LstDeal_Rights_Subtitling_UDT,
        //  List<Deal_Rights_Dubbing_UDT> LstDeal_Rights_Dubbing_UDT
        //  )
        //{
        //    RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
        //    return objContext.USP_Syn_Acq_Mapping_UDT(
        //        LstDeal_Rights_UDT, LstDeal_Rights_Title_UDT, LstDeal_Rights_Platform_UDT, LstDeal_Rights_Territory_UDT, LstDeal_Rights_Subtitling_UDT, LstDeal_Rights_Dubbing_UDT
        //        );
        //}
        public virtual ObjectResult<string> USP_Syn_Acq_Mapping(Nullable<int> syn_Deal_Code, string debug)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Syn_Acq_Mapping(syn_Deal_Code, debug);
        }

        public virtual ObjectResult<USP_List_IPR_Result> USP_List_IPR(string tabName, string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, ObjectParameter recordCount, Nullable<int> user_Code, Nullable<int> module_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_IPR(tabName, strSearch, pageNo, orderByCndition, isPaging, pageSize, recordCount, user_Code, module_Code);
        }

        public virtual ObjectResult<USP_Get_IPR_Class_Tree_Hierarchy_Result> USP_Get_IPR_Class_Tree_Hierarchy(string iPR_ClassCodes)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_IPR_Class_Tree_Hierarchy(iPR_ClassCodes);
        }

        public virtual ObjectResult<USP_List_IPR_Status_History_Result> USP_List_IPR_Status_History(Nullable<int> iPR_Rep_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_IPR_Status_History(iPR_Rep_Code);
        }

        public ObjectResult<USP_Login_Details_Report_Result> USP_Login_Details_Report(string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Login_Details_Report(strSearch, pageNo, orderByCndition, isPaging, pageSize, recordCount);
        }
        public IEnumerable<string> USP_Validate_Talent_Master(Nullable<int> talent_Code, string selected_Role_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Talent_Master(talent_Code, selected_Role_Code);
        }

        public virtual ObjectResult<USP_Populate_Master_Deal_Titles_Result> USP_Populate_Master_Deal_Titles(Nullable<int> acq_Deal_Movie_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Populate_Master_Deal_Titles(acq_Deal_Movie_Code);
        }
        public virtual ObjectResult<string> USP_Get_Mapping_Countries(Nullable<int> acq_Deal_Right_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Mapping_Countries(acq_Deal_Right_Code);
        }
        public virtual ObjectResult<USP_Validate_Episode_Result> USP_Validate_Episode(string title_with_Episode, string Program_Type)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Episode(title_with_Episode, Program_Type);
        }
        public virtual IEnumerable<string> USP_Acq_Deal_Clone_UDT(int New_Acq_Deal_Code, int Previous_Acq_Deal_Code, int User_Code, List<Deal_Rights_Title_UDT> LstDeal_Rights_Title_UDT)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Acq_Deal_Clone_UDT(New_Acq_Deal_Code, Previous_Acq_Deal_Code, User_Code, LstDeal_Rights_Title_UDT);
        }
        public virtual IEnumerable<string> USP_Syn_Deal_Clone_UDT(int New_Syn_Deal_Code, int Previous_Syn_Deal_Code, int User_Code, List<Deal_Rights_Title_UDT> LstDeal_Rights_Title_UDT)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Syn_Deal_Clone_UDT(New_Syn_Deal_Code, Previous_Syn_Deal_Code, User_Code, LstDeal_Rights_Title_UDT);
        }
        public int Upadte_Delete_EF(string sql)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.Upadte_Delete_EF(sql);
        }
        public int Get_Select_CountSql_EF(string sql)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.Get_Select_CountSql_EF(sql);
        }
        public virtual ObjectResult<USP_List_Cost_Colors_Result> USP_List_Cost_Colors(Nullable<int> acq_Deal_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Cost_Colors(acq_Deal_Code);
        }
        public virtual ObjectResult<string> USP_Update_Syn_Acq_Mapping(Nullable<int> acq_Deal_Code, string acq_Deal_Rights_Code, string map_Syn_Deal_Rights_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Update_Syn_Acq_Mapping(acq_Deal_Code, acq_Deal_Rights_Code, map_Syn_Deal_Rights_Code);
        }
        public virtual ObjectResult<string> USP_Validate_Cost_Duplication_Colors(string dealType, string titleCodes, Nullable<int> cost_Type_Code, Nullable<int> acq_Deal_Cost_Code, Nullable<int> acq_Deal_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Cost_Duplication_Colors(dealType, titleCodes, cost_Type_Code, acq_Deal_Cost_Code, acq_Deal_Code);
        }
        public virtual ObjectResult<USP_Validate_Close_Movie__Scheduled_Run_Result> USP_Validate_Close_Movie__Scheduled_Run(Nullable<int> acq_Deal_Movie_Code, Nullable<int> title_Code, string deal_Movie_Close_Date, Nullable<int> episode_From, Nullable<int> episode_To)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Close_Movie__Scheduled_Run(acq_Deal_Movie_Code, title_Code, deal_Movie_Close_Date, episode_From, episode_To);
        }
        public virtual ObjectResult<USP_Get_Mapping_SubTitling_Dubbing_Languages_Result> USP_Get_Mapping_SubTitling_Dubbing_Languages(string syn_Deal_Rights_Codes, string selected_SubTitling_Language_Codes, string selected_Dubbing_Language_Codes)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Mapping_SubTitling_Dubbing_Languages(syn_Deal_Rights_Codes, selected_SubTitling_Language_Codes, selected_Dubbing_Language_Codes);
        }
        public virtual ObjectResult<string> USP_Validate_Rights_Duplication_Country_Lang(string selected_Territory_Codes, string selected_SubTitling_LangGroup_Codes, string selected_Dubbing_LangGroup_Codes, string callFrom)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Rights_Duplication_Country_Lang(selected_Territory_Codes, selected_SubTitling_LangGroup_Codes, selected_Dubbing_LangGroup_Codes, callFrom);
        }

        public virtual ObjectResult<USP_List_Acq_Budget_Result> USP_List_Acq_Budget(Nullable<int> acq_Deal_Code, string title_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Acq_Budget(acq_Deal_Code, title_Code);
        }

        public virtual ObjectResult<USP_Uploaded_File_List_Result> USP_Uploaded_File_List(string strSearch, Nullable<int> pageNo, ObjectParameter recordCount, string isPaging, Nullable<int> pageSize)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Uploaded_File_List(strSearch, pageNo, recordCount, isPaging, pageSize);
        }

        public virtual ObjectResult<USP_Uploaded_File_Error_List_Result> USP_Uploaded_File_Error_List(Nullable<int> file_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Uploaded_File_Error_List(file_Code);
        }
        public virtual ObjectResult<USP_Audit_Log_Report_for_Territory_and_Language_Group_Result> USP_Audit_Log_Report_for_Territory_and_Language_Group(string search_Key, string log)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Audit_Log_Report_for_Territory_and_Language_Group(search_Key, log);
        }
        public virtual ObjectResult<USP_Acq_List_Runs_Result> USP_Acq_List_Runs(Nullable<int> deal_Code, string title_Codes, string channel_Codes, string acq_Deal_Run_Codes)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Acq_List_Runs(deal_Code, title_Codes, channel_Codes, acq_Deal_Run_Codes);
        }
        public virtual ObjectResult<USP_Bind_Title_Result> USP_Bind_Title(Nullable<int> deal_Code, Nullable<int> deal_Type_Code, string deal_Type)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Bind_Title(deal_Code, deal_Type_Code, deal_Type);
        }
        public virtual ObjectResult<USP_GetMenu_Result> USP_GetMenu(string securityGroupCode, string isSuperAdmin, Nullable<int> users_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GetMenu(securityGroupCode, isSuperAdmin, users_Code);
        }
        public virtual int usp_GetUserEMail_Body(string user_Name, string first_Name, string last_Name, string pass_Word, string isLDAP_Required, string site_Address, string system_Name, string status, string cur_email_id)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.usp_GetUserEMail_Body(user_Name, first_Name, last_Name, pass_Word, isLDAP_Required, site_Address, system_Name, status, cur_email_id);
        }

        public virtual ObjectResult<USP_Get_Talent_Name_Result> USP_Get_Talent_Name()
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Talent_Name();
        }

        public virtual ObjectResult<USP_Title_List_Result> USP_Title_List(Nullable<int> dealTypeCode, string titleName, string originalTitleName, Nullable<int> bUCode, Nullable<int> pageNo, ObjectParameter recordCount, string isPaging, Nullable<int> pageSize, string AdvanceSearch, string ExactMatch)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Title_List(dealTypeCode, titleName, originalTitleName, bUCode, pageNo, recordCount, isPaging, pageSize, AdvanceSearch, ExactMatch);
        }

        public virtual ObjectResult<USP_Bind_Extend_Column_Grid_Result> USP_Bind_Extend_Column_Grid(Nullable<int> title_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Bind_Extend_Column_Grid(title_Code);
        }

        public virtual ObjectResult<USP_List_Approval_Acq_Syn_Result> USP_List_Approval_Acq_Syn(string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, ObjectParameter recordCount, Nullable<int> user_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Approval_Acq_Syn(strSearch, pageNo, orderByCndition, isPaging, pageSize, recordCount, user_Code);
        }

        public virtual ObjectResult<string> USP_MODULE_RIGHTS(Nullable<int> module_Code, Nullable<int> security_Group_Code, Nullable<int> users_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_MODULE_RIGHTS(module_Code, security_Group_Code, users_Code);
        }

        public virtual ObjectResult<Nullable<int>> USP_ValidateWithDeal(string territory_Code, string country_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_ValidateWithDeal(territory_Code, country_Code);
        }

        public virtual ObjectResult<USP_Close_Deal_Movie_Result> USP_Close_Deal_Movie(Nullable<int> acq_Deal_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Close_Deal_Movie(acq_Deal_Code);
        }

        public virtual ObjectResult<string> USP_Get_Deal_DealWorkFlowStatus(Nullable<int> acq_Deal_Code, string deal_Workflow_Status, Nullable<int> user_Code, string deal_Type)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Deal_DealWorkFlowStatus(acq_Deal_Code, deal_Workflow_Status, user_Code, deal_Type);
        }

        public virtual ObjectResult<USP_Get_BV_Schedule_MinMaxDate_BasedOn_RightCode_Result> USP_Get_BV_Schedule_MinMaxDate_BasedOn_RightCode(Nullable<int> deal_Movie_Rights_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_BV_Schedule_MinMaxDate_BasedOn_RightCode(deal_Movie_Rights_Code);
        }
        public virtual int usp_Schedule_RUN_SAVE_Process(Nullable<int> aCQ_DEAL_RUN_CODE, Nullable<int> title_Code, Nullable<int> aCQ_DEAL_MOVIE_CODE)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.usp_Schedule_RUN_SAVE_Process(aCQ_DEAL_RUN_CODE, title_Code, aCQ_DEAL_MOVIE_CODE);
        }
        public IEnumerable<USP_Validate_Run_UDT> USP_Validate_Run_Udt(
          List<Deal_Run_Title_UDT> LstDeal_Run_Title_UDT,
            List<Deal_Run_Yearwise_Run_UDT> LstDeal_Run_Yearwise_Run_UDT,
            List<Deal_Run_Channel_UDT> LstDeal_Run_Channel_UDT,
            int acq_Deal_Code
            )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Run_Udt(LstDeal_Run_Title_UDT, LstDeal_Run_Yearwise_Run_UDT, LstDeal_Run_Channel_UDT, acq_Deal_Code);
        }
        public virtual ObjectResult<USP_GET_TITLE_FOR_SYN_RUN_Result> USP_GET_TITLE_FOR_SYN_RUN(Nullable<int> sYN_DEAL_CODE)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GET_TITLE_FOR_SYN_RUN(sYN_DEAL_CODE);
        }
        public virtual ObjectResult<USP_GET_DATA_FOR_APPROVED_TITLES_FOR_SYN_PUSHBACK_Result> USP_GET_DATA_FOR_APPROVED_TITLES_FOR_SYN_PUSHBACK(string title_Codes, string platform_Codes, string platform_Type, string region_Type, string subtitling_Type, string dubbing_Type, Nullable<int> syn_Deal_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GET_DATA_FOR_APPROVED_TITLES_FOR_SYN_PUSHBACK(title_Codes, platform_Codes, platform_Type, region_Type, subtitling_Type, dubbing_Type, syn_Deal_Code);
        }

        public virtual ObjectResult<Nullable<int>> USP_Validate_Syn_Right_Title_With_Acq_On_Edit(Nullable<int> rCode, Nullable<int> tCode, Nullable<int> episode_From, Nullable<int> episode_To)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Syn_Right_Title_With_Acq_On_Edit(rCode, tCode, episode_From, episode_To);
        }

        public virtual ObjectResult<USP_List_Platform_Group_Result> USP_List_Platform_Group(string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Platform_Group(strSearch, pageNo, orderByCndition, isPaging, pageSize, recordCount);
        }

        public virtual ObjectResult<USP_GET_TITLE_DATA_Result> USP_GET_TITLE_DATA(string searchTitle, Nullable<int> deal_Type_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GET_TITLE_DATA(searchTitle, deal_Type_Code);
        }

        public virtual ObjectResult<USP_Bind_Title_Platform_Tree_Report_Result> USP_Bind_Title_Platform_Tree_Report(Nullable<int> business_Unit_Code, string search_Platform_Hiearachy)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Bind_Title_Platform_Tree_Report(business_Unit_Code, search_Platform_Hiearachy);
        }

        public virtual ObjectResult<USP_Get_Title_WBS_Data_Result> USP_Get_Title_WBS_Data(Nullable<int> acq_Deal_Code, string callForMilestone)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Title_WBS_Data(acq_Deal_Code, callForMilestone);
        }

        public virtual ObjectResult<USP_List_BV_WBS_Result> USP_List_BV_WBS(string is_Process, string wBS_Code, Nullable<long> file_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_BV_WBS(is_Process, wBS_Code, file_Code);
        }

        public virtual ObjectResult<USP_SAP_Export_Detail_Result> USP_SAP_Export_Detail(Nullable<int> file_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_SAP_Export_Detail(file_Code);
        }

        public virtual ObjectResult<USP_Uploaded_File_Detail_Result> USP_Uploaded_File_Detail(Nullable<int> file_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Uploaded_File_Detail(file_Code);
        }

        public virtual ObjectResult<USP_List_IPR_Opp_Result> USP_List_IPR_Opp(string ipr_For, string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, ObjectParameter recordCount, Nullable<int> user_Code, Nullable<int> module_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_IPR_Opp(ipr_For, strSearch, pageNo, orderByCndition, isPaging, pageSize, recordCount, user_Code, module_Code);
        }

        public virtual ObjectResult<USP_List_IPR_Opp_Status_History_Result> USP_List_IPR_Opp_Status_History(Nullable<int> iPR_Opp_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_IPR_Opp_Status_History(iPR_Opp_Code);
        }

        public virtual ObjectResult<string> USP_Get_Platform_Code_For_Syn_Run(Nullable<int> syn_Deal_Code, string title_Codes, string codeType)
        {

            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Platform_Code_For_Syn_Run(syn_Deal_Code, title_Codes, codeType);
        }

        public IEnumerable<USP_Insert_Title_Import_UDT> USP_Insert_Title_Import_UDT(
          List<Title_Import_UDT> LstTitle_Import_UDT, int User_Code
            )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Insert_Title_Import_UDT(LstTitle_Import_UDT, User_Code);
        }
        public IEnumerable<USP_DM_Title_PI> USP_DM_Title_PI(
         List<Title_Import_UDT> LstTitle_Import_UDT, int User_Code
           )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_DM_Title_PI(LstTitle_Import_UDT, User_Code);
        }

        public IEnumerable<USP_Title_Import_Utility_PI> USP_Title_Import_Utility_PI(
        List<Title_Import_Utility_UDT> LstTitle_Import_Utility_UDT, string CallFor, int User_Code, int DM_Master_Import_Code
          )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Title_Import_Utility_PI(LstTitle_Import_Utility_UDT, CallFor, User_Code, DM_Master_Import_Code);
        }


        public virtual ObjectResult<USP_Get_Termination_Title_Data_Result> USP_Get_Termination_Title_Data(Nullable<int> deal_Code, string type)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Termination_Title_Data(deal_Code, type);
        }

        public IEnumerable<USP_Acq_Termination_UDT> USP_Acq_Termination_UDT(
            List<Termination_Deals_UDT> lstTermination_Deals_UDT, int loginUserCode, string syn_Error_Body, string isValidateError
            )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Acq_Termination_UDT(lstTermination_Deals_UDT, loginUserCode, syn_Error_Body, isValidateError);
        }

        public IEnumerable<USP_Syn_Termination_UDT> USP_Syn_Termination_UDT(
            List<Termination_Deals_UDT> lstTermination_Deals_UDT, int loginUserCode
            )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Syn_Termination_UDT(lstTermination_Deals_UDT, loginUserCode);
        }
        public virtual ObjectResult<USP_List_Music_Title_Result> USP_List_Music_Title(string musicTitleName, Nullable<int> sysLanguageCode, Nullable<int> pageNo, ObjectParameter recordCount, string isPaging, Nullable<int> pageSize, string starCastCode, string languageCode, string albumCode, string genresCode, string musicLabelCode, string yearOfRelease, string singerCode, string composerCode, string lyricistCode, string musicNameText, string themeCode, string musicTag, string publicDomain, string ExactMatch)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Music_Title(musicTitleName, sysLanguageCode, pageNo, recordCount, isPaging, pageSize, starCastCode, languageCode, albumCode, genresCode, musicLabelCode, yearOfRelease, singerCode, composerCode, lyricistCode, musicNameText, themeCode, musicTag, publicDomain, ExactMatch);
        }
        //public virtual ObjectResult<USP_Get_Title_Avail_Language_Data_Result> USP_Get_Title_Avail_Language_Data(string mode, Nullable<int> userCode, string strCriteria, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, ObjectParameter recordCount, string visibility, string Report_Name, string Right_Level)
        //{
        //    RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
        //    return objContext.USP_Get_Title_Avail_Language_Data(mode, userCode, strCriteria, pageNo, orderByCndition, isPaging, pageSize, recordCount, visibility, Report_Name, Right_Level);
        //}
        //public virtual ObjectResult<USP_Get_Title_Avail_Language_Data_Show_Result> USP_Get_Title_Avail_Language_Data_Show(string mode, Nullable<int> userCode, string strCriteria, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, ObjectParameter recordCount, string visibility, string Report_Name, string Right_Level)
        //{
        //    RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
        //    return objContext.USP_Get_Title_Avail_Language_Data_Show(mode, userCode, strCriteria, pageNo, orderByCndition, isPaging, pageSize, recordCount, visibility, Report_Name, Right_Level);
        //}
        public IEnumerable<USP_DM_Music_Title_PI> USP_DM_Music_Title_PI(
          List<Music_Title_Import_UDT> lstMusic_Title_Import_UDT, int User_Code
            )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_DM_Music_Title_PI(lstMusic_Title_Import_UDT, User_Code);
        }
        public IEnumerable<USP_Insert_Music_Title_Import_UDT> USP_Insert_Music_Title_Import_UDT(
         List<Music_Title_Import_UDT> lstMusic_Title_Import_UDT, int User_Code
           )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Insert_Music_Title_Import_UDT(lstMusic_Title_Import_UDT, User_Code);
        }
        public IEnumerable<USP_Title_Content_Version_PI> USP_Title_Content_Version_PI(
         List<Title_Content_Version_UDT> lstMusic_Title_Content_Import_UDT, string User_Code
           )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Title_Content_Version_PI(lstMusic_Title_Content_Import_UDT, User_Code);
        }
        public virtual ObjectResult<USP_List_Amort_Rule_Result> USP_List_Amort_Rule(string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, ObjectParameter recordCount, Nullable<int> user_Code, string moduleCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Amort_Rule(strSearch, pageNo, orderByCndition, isPaging, pageSize, recordCount, user_Code, moduleCode);
        }

        public virtual ObjectResult<string> USP_Validate_Termination(Nullable<int> deal_Code, string type)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Termination(deal_Code, type);
        }
        public virtual ObjectResult<USP_Title_Deal_Info_Result> USP_Title_Deal_Info(Nullable<int> title_Code, Nullable<int> user_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Title_Deal_Info(title_Code, user_Code);
        }

        public virtual ObjectResult<USP_List_Assign_Music_Result> USP_List_Assign_Music(Nullable<int> acq_Deal_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Assign_Music(acq_Deal_Code);
        }

        public virtual ObjectResult<USP_Populate_Music_Result> USP_Populate_Music(Nullable<int> acq_Deal_Movie_Code, string search_Text, Nullable<int> deal_Type_Code, string link_Show, string mode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Populate_Music(acq_Deal_Movie_Code, search_Text, deal_Type_Code, link_Show, mode);
        }

        public IEnumerable<USP_Validate_And_Save_Assigned_Music_UDT> USP_Validate_And_Save_Assigned_Music_UDT(
           int dealTypeCode, int loginUserCode, string linkShow, string action,
           List<Assign_Music_UDT> lstAssign_Music_UDT
           )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_And_Save_Assigned_Music_UDT(dealTypeCode, loginUserCode, linkShow, action, lstAssign_Music_UDT);
        }
        public virtual void USP_SendMail_Page_Crashed(string user_Name, string site_Address, string entity_Name, string controller_Name, string action_Name, string view_Name, string error_Desc, string error_Type, string iP_Address, string fromMailId, string toMailId)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            objContext.USP_SendMail_Page_Crashed(user_Name, site_Address, entity_Name, controller_Name, action_Name, view_Name, error_Desc, error_Type, iP_Address, fromMailId, toMailId);
        }

        public IEnumerable<USP_Import_Title_Content_UDT> USP_Import_Title_Content_UDT(
          List<Title_Content_UDT> lstTitle_Content_UDT, int Deal_Code
          )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Import_Title_Content_UDT(lstTitle_Content_UDT, Deal_Code);
        }

        public virtual ObjectResult<USP_Get_Dashboard_Data_Result> USP_Get_Dashboard_Data(string dataFor, string businessUnitCodes)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Dashboard_Data(dataFor, businessUnitCodes);
        }

        public virtual ObjectResult<USP_Get_Acq_PreReq_Result> USP_Get_Acq_PreReq(string data_For, string call_From, Nullable<int> loginUserCode, Nullable<int> acq_Deal_Code, Nullable<int> deal_Type_Code, Nullable<int> businessUnitCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Acq_PreReq(data_For, call_From, loginUserCode, acq_Deal_Code, deal_Type_Code, businessUnitCode);
        }

        public virtual ObjectResult<USP_Get_Acq_PreReq_Result> USP_Get_Syn_PreReq(string data_For, string call_From, Nullable<int> loginUserCode, Nullable<int> syn_Deal_Code, Nullable<int> deal_Type_Code, Nullable<int> businessUnitCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Syn_PreReq(data_For, call_From, loginUserCode, syn_Deal_Code, deal_Type_Code, businessUnitCode);
        }

        public virtual ObjectResult<USP_Get_Title_PreReq_Result> USP_Get_Title_PreReq(string data_For, Nullable<int> deal_Type_Code, Nullable<int> business_Unit_Code, string search_String)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Title_PreReq(data_For, deal_Type_Code, business_Unit_Code, search_String);
        }

        public virtual ObjectResult<USP_List_Acq_PaymentTerms_Result> USP_List_Acq_PaymentTerms(Nullable<int> acq_Deal_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Acq_PaymentTerms(acq_Deal_Code);
        }

        public virtual ObjectResult<USP_Get_Login_Details_Result> USP_Get_Login_Details(string Data_For, Nullable<int> Entity_Code, Nullable<int> user_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Login_Details(Data_For, Entity_Code, user_Code);
        }
        public virtual ObjectResult<USP_Get_Acq_PreReq_Result> USP_Syn_Rights_PreReq(Nullable<int> syn_Deal_Code, Nullable<int> deal_Type_Code, string data_For, string call_From, string country_Territory_Codes, string sub_Lang_Codes, string dub_Lang_Codes)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Syn_Rights_PreReq(syn_Deal_Code, deal_Type_Code, data_For, call_From, country_Territory_Codes, sub_Lang_Codes, dub_Lang_Codes);
        }
        public virtual ObjectResult<USP_Get_Acq_PreReq_Result> USP_Acq_Rights_PreReq(Nullable<int> acq_Deal_Code, string data_For, Nullable<int> deal_Type_Code, string is_Syn_Acq_Mapp)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Acq_Rights_PreReq(acq_Deal_Code, data_For, deal_Type_Code, is_Syn_Acq_Mapp);
        }
        public virtual ObjectResult<USP_Integration_Generate_XML_Result> USP_Integration_Generate_XML(string module_Name, Nullable<int> deal_Type_Code, Nullable<int> bU_Code, Nullable<int> title_Lang_Code, string channel_Codes, string foreign_System_Name)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Integration_Generate_XML(module_Name, deal_Type_Code, bU_Code, title_Lang_Code, channel_Codes, foreign_System_Name);
        }
        public virtual ObjectResult<USP_Integration_Response_Result> USP_Integration_Response(string error_Details, string is_Error, string module_Name, string strXml)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Integration_Response(error_Details, is_Error, module_Name, strXml);
        }

        public IEnumerable<USP_Bulk_Update> USP_Bulk_Update(List<Rights_Bulk_Update_UDT> LstRights_Bulk_Update_UDT, int Login_User_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Bulk_Update(LstRights_Bulk_Update_UDT, Login_User_Code);
        }
        public IEnumerable<USP_Acq_Bulk_Update> USP_Acq_Bulk_Update(List<Rights_Bulk_Update_UDT> LstRights_Bulk_Update_UDT, int Login_User_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Acq_Bulk_Update(LstRights_Bulk_Update_UDT, Login_User_Code);
        }

        public IEnumerable<USP_Acq_Bulk_Update_Validation> USP_Acq_Bulk_Update_Validation(List<Rights_Bulk_Update_UDT> LstRights_Bulk_Update_UDT)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Acq_Bulk_Update_Validation(LstRights_Bulk_Update_UDT);
        }

        public virtual ObjectResult<USP_SendMail_AskExpert_Result> USP_SendMail_AskExpert(Nullable<int> user_Code, string subject, string query, string fromMailId, string toMailId)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_SendMail_AskExpert(user_Code, subject, query, fromMailId, toMailId);
        }

        public virtual ObjectResult<USP_Check_HoldBack_Result> USP_Check_HoldBack(Nullable<long> title_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Check_HoldBack(title_Code);
        }

        public virtual ObjectResult<Nullable<int>> USP_Save_TitleRelease(Nullable<long> title_Code, string release_Type, string release_Date, string platform_Code, string territory_Code, string country_Code, string world_Code, Nullable<long> title_Release_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Save_TitleRelease(title_Code, release_Type, release_Date, platform_Code, territory_Code, country_Code, world_Code, title_Release_Code);
        }

        public virtual int USP_Validate_Title_Release(string release_Type, string release_Date, Nullable<long> title_Code, string country_Code, string territory_Code, ObjectParameter result)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Title_Release(release_Type, release_Date, title_Code, country_Code, territory_Code, result);
        }

        public virtual ObjectResult<Nullable<int>> USP_CheckIfTitleReleaseDateExist(string title_Code, string holdback_Country_Code, string holdback_Code)
        {
            //var title_CodeParameter = title_Code != null ?
            //    new ObjectParameter("Title_Code", title_Code) :
            //    new ObjectParameter("Title_Code", typeof(string));

            //var holdback_Country_CodeParameter = holdback_Country_Code != null ?
            //    new ObjectParameter("Holdback_Country_Code", holdback_Country_Code) :
            //    new ObjectParameter("Holdback_Country_Code", typeof(string));

            //var holdback_CodeParameter = holdback_Code != null ?
            //    new ObjectParameter("Holdback_Code", holdback_Code) :
            //    new ObjectParameter("Holdback_Code", typeof(string));

            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_CheckIfTitleReleaseDateExist(title_Code, holdback_Country_Code, holdback_Code);

            //return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Nullable<int>>("USP_CheckIfTitleReleaseDateExist", title_CodeParameter, holdback_Country_CodeParameter, holdback_CodeParameter);
        }
        public virtual ObjectResult<USP_ValidateIfHoldbackExist_Result> USP_ValidateIfHoldbackExist(Nullable<long> syn_Deal_Rights_Code, string title_Code, string region_Code, string platform_Code, string subTitling_Code, string dubbing_Lang_Code, string region_Type, string sub_Lang_Type, string dubbing_Lang_Type, string right_Start_Date, string right_End_Date, string right_Type, string is_Title_Language_Right)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_ValidateIfHoldbackExist(syn_Deal_Rights_Code, title_Code, region_Code, platform_Code, subTitling_Code, dubbing_Lang_Code, region_Type, sub_Lang_Type, dubbing_Lang_Type, right_Start_Date, right_End_Date, right_Type, is_Title_Language_Right);
        }
        public virtual ObjectResult<USP_Syn_Bulk_Populate_Result> USP_Syn_Bulk_Populate(string right_Codes, string type, string changeFor)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Syn_Bulk_Populate(right_Codes, type, changeFor);
        }

        public virtual ObjectResult<string> USP_GetSynRightStatus(Nullable<int> rightCode, Nullable<int> dealCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GetSynRightStatus(rightCode, dealCode);
        }

        public virtual ObjectResult<USP_List_Content_Result> USP_List_Content(string searchText, Nullable<int> episodeFrom, Nullable<int> episodeTo)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Content(searchText, episodeFrom, episodeTo);
        }

        public virtual ObjectResult<USP_List_MusicTrack_Result> USP_List_MusicTrack(string searchText)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_MusicTrack(searchText);
        }

        public virtual ObjectResult<USP_GetContentMetadata_Result> USP_GetContentMetadata(Nullable<long> title_Content_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GetContentMetadata(title_Content_Code);
        }

        public virtual ObjectResult<USP_GetContentsMusicData_Result> USP_GetContentsMusicData(Nullable<long> title_Content_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GetContentsMusicData(title_Content_Code);
        }

        public virtual ObjectResult<USP_GetContentsRightData_Result> USP_GetContentsRightData(Nullable<long> title_Content_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GetContentsRightData(title_Content_Code);
        }

        public virtual ObjectResult<USP_GetContentsAiringData_Result> USP_GetContentsAiringData(Nullable<long> title_Content_Code, string start_Date, string end_Date, string version_ID, string channel_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GetContentsAiringData(title_Content_Code, start_Date, end_Date, version_ID, channel_Code);
        }

        public virtual ObjectResult<USP_GetContentsVersionData_Result> USP_GetContentsVersionData(Nullable<long> title_Content_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GetContentsVersionData(title_Content_Code);
        }

        public virtual ObjectResult<USP_PopulateContent_Result> USP_PopulateContent(string searchPrefix)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_PopulateContent(searchPrefix);
        }

        public virtual ObjectResult<USP_GetContentsStatusHistoryData_Result> USP_GetContentsStatusHistoryData(Nullable<long> title_Content_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GetContentsStatusHistoryData(title_Content_Code);
        }
        public virtual ObjectResult<USP_GetRunDefinitonForContent_Result> USP_GetRunDefinitonForContent(Nullable<int> title_Content_Code, string type, Nullable<int> channel_Code, string start_Date, string end_Date, string deal_Type, string is_active)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GetRunDefinitonForContent(title_Content_Code, type, channel_Code, start_Date, end_Date, deal_Type, is_active);
        }
        public virtual ObjectResult<USP_GetContentRestrictionRemarks_Result> USP_GetContentRestrictionRemarks(Nullable<long> titleContentCode, string musicTitleCodes)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GetContentRestrictionRemarks(titleContentCode, musicTitleCodes);
        }
        public virtual ObjectResult<USP_Music_Exception_Handling_Result> USP_Music_Exception_Handling(string isAired, Nullable<int> pageNo, ObjectParameter recordCount, string isPaging, Nullable<int> pageSize, string musicTrackCode, string musicLabelCode, string channelCode, string contentCode, string episodeFrom, string episodeTo, string initialResponse, string exceptionStatus, Nullable<int> userCode, string commonSearch, Nullable<System.DateTime> startDate, Nullable<System.DateTime> endDate)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Music_Exception_Handling(isAired, pageNo, recordCount, isPaging, pageSize, musicTrackCode, musicLabelCode, channelCode, contentCode, episodeFrom, episodeTo, initialResponse, exceptionStatus, userCode, commonSearch, startDate, endDate);
        }

        public virtual int USP_Music_Schedule_Process(Nullable<long> titleCode, Nullable<int> episodeNo, Nullable<long> bV_Schedule_Transaction_Code, Nullable<long> musicScheduleTransactionCode, string callFrom)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Music_Schedule_Process(titleCode, episodeNo, bV_Schedule_Transaction_Code, musicScheduleTransactionCode, callFrom);
        }
        public IEnumerable<USP_Content_Music_Link_Bulk_Insert_UDT> USP_Content_Music_Link_Bulk_Insert_UDT(
       List<Content_Music_Link_UDT> LstContent_Music_Link_UDT, int UserCode
       )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Content_Music_Link_Bulk_Insert_UDT(LstContent_Music_Link_UDT, UserCode);
        }

        public virtual ObjectResult<USP_Music_Exception_Dashboard_Result> USP_Music_Exception_Dashboard(string isAired, string musicTrackCode, string musicLabelCode, string channelCode, string contentCode, string episodeFrom, string episodeTo, string initialResponse, string exceptionStatus, Nullable<int> userCode, string commonSearch, Nullable<System.DateTime> startDate, Nullable<System.DateTime> endDate)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Music_Exception_Dashboard(isAired, musicTrackCode, musicLabelCode, channelCode, contentCode, episodeFrom, episodeTo, initialResponse, exceptionStatus, userCode, commonSearch, startDate, endDate);
        }

        public virtual ObjectResult<USP_Get_Music_Reports_PreReq_Result> USP_Get_Music_Reports_PreReq()
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Music_Reports_PreReq();
        }

        public virtual ObjectResult<USP_List_Country_Result> USP_List_Country(Nullable<int> sysLanguageCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Country(sysLanguageCode);
        }

        public virtual ObjectResult<USP_List_BMS_log_Result> USP_List_BMS_log(string strSearch, Nullable<int> pageNo, string isPaging, Nullable<int> pageSize, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_BMS_log(strSearch, pageNo, isPaging, pageSize, recordCount);
        }

        public virtual ObjectResult<USP_Export_Table_To_Excel_Result> USP_Export_Table_To_Excel(Nullable<int> Module_Code, ObjectParameter column_Count, string Sort_Column, string Sort_Order)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Export_Table_To_Excel(Module_Code, column_Count, Sort_Column, Sort_Order);
        }

        public IEnumerable<USP_DM_Music_Title_PII> USP_DM_Music_Title_PII(
         List<DM_Import_UDT> lstDM_Import_UDT, int? DM_Master_Import_Code, int? Users_Code
           )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_DM_Music_Title_PII(lstDM_Import_UDT, DM_Master_Import_Code, Users_Code);
        }
        public IEnumerable<USP_DM_Music_Title_PIII> USP_DM_Music_Title_PIII(
         int? DM_Master_Import_Code
           )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_DM_Music_Title_PIII(DM_Master_Import_Code);
        }
        public virtual ObjectResult<USP_Get_Release_Content_List_Result> USP_Get_Release_Content_List(Nullable<int> acq_Deal_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Release_Content_List(acq_Deal_Code);
        }
        public IEnumerable<USP_DM_Title_PII> USP_DM_Title_PII(
        List<DM_Import_UDT> lstDM_Import_UDT, int? DM_Master_Import_Code, int? Users_Code
          )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_DM_Title_PII(lstDM_Import_UDT, DM_Master_Import_Code, Users_Code);
        }
        public IEnumerable<USP_Title_Import_Utility_PII> USP_Title_Import_Utility_PII(
       List<DM_Import_UDT> lstDM_Import_UDT, int? DM_Master_Import_Code, int? Users_Code
         )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Title_Import_Utility_PII(lstDM_Import_UDT, DM_Master_Import_Code, Users_Code);
        }
        public IEnumerable<USP_DM_Title_PIII> USP_DM_Title_PIII(
         int? DM_Master_Import_Code
           )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_DM_Title_PIII(DM_Master_Import_Code);
        }
        public virtual ObjectResult<USP_List_DM_Master_Import_Result> USP_List_DM_Master_Import(string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, ObjectParameter recordCount, Nullable<int> user_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_DM_Master_Import(strSearch, pageNo, orderByCndition, isPaging, pageSize, recordCount, user_Code);
        }
        public virtual ObjectResult<USP_Title_Import_RCData_Result> USP_Title_Import_RCData(string keyword, string tabName, string roles)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Title_Import_RCData(keyword, tabName, roles);
        }
        public virtual int USP_Lock_Refresh_Release_Record(Nullable<int> record_Code, Nullable<int> module_Code, Nullable<int> user_Code, string iP_Address, ObjectParameter record_Locking_Code, ObjectParameter message, string action)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Lock_Refresh_Release_Record(record_Code, module_Code, user_Code, iP_Address, record_Locking_Code, message, action);
        }
        public virtual ObjectResult<USP_Music_Title_Contents_Result> USP_Music_Title_Contents(Nullable<int> Music_Title_Code, string GenericSearch, ObjectParameter RecordCount, string IsPaging, Nullable<int> PageSize, Nullable<int> PageNo)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Music_Title_Contents(Music_Title_Code, GenericSearch, RecordCount, IsPaging, PageSize, PageNo);
        }

        public virtual ObjectResult<string> USP_Generate_Title_Content(Nullable<int> acq_Deal_Code, string title_Codes, Nullable<int> user_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Generate_Title_Content(acq_Deal_Code, title_Codes, user_Code);
        }
        public virtual void USP_UpdateContentHouseID(Nullable<int> BV_HouseId_Data_Code, Nullable<int> MappedDealTitleCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            objContext.USP_UpdateContentHouseID(BV_HouseId_Data_Code, MappedDealTitleCode);
        }

        public virtual ObjectResult<USP_List_Deal_Title_Content_Result> USP_List_Deal_Title_Content(string title_Codes, Nullable<int> acq_Deal_Code, Nullable<int> pageNo, string isPaging, Nullable<int> pageSize, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Deal_Title_Content(title_Codes, acq_Deal_Code, pageNo, isPaging, pageSize, recordCount);
        }
        public virtual ObjectResult<USP_Get_Security_Group_Tree_Hierarchy_Result> USP_Get_Security_Group_Tree_Hierarchy(string moduleCodes, string search_Module_Name)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Security_Group_Tree_Hierarchy(moduleCodes, search_Module_Name);
        }

        public IEnumerable<USP_Multi_Music_Schedule_Process> USP_Multi_Music_Schedule_Process(
      List<Music_Content_Assignment_UDT> LstMusic_Content_Assignment_UDT
      )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Multi_Music_Schedule_Process(LstMusic_Content_Assignment_UDT);
        }

        public virtual ObjectResult<string> USP_Validate_Rollback(Nullable<int> deal_Code, string type)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_Rollback(deal_Code, type);
        }

        public virtual void USP_BV_Title_Mapping_Shows(string BV_HouseId_Data_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            objContext.USP_BV_Title_Mapping_Shows(BV_HouseId_Data_Code);
        }
        public virtual ObjectResult<USP_List_Territory_Result> USP_List_Territory(Nullable<int> sysLanguageCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Territory(sysLanguageCode);
        }

        public virtual ObjectResult<USP_List_Music_Deal_Result> USP_List_Music_Deal(string searchText, string agreement_No, Nullable<System.DateTime> startDate, Nullable<System.DateTime> endDate, string deal_Type_Code, string status_Code, Nullable<int> business_Unit_Code, Nullable<int> deal_Tag_Code, string workflow_Status, string vendor_Codes, string show_Type_Code, string title_Code, string music_Label_Codes, string isAdvance_Search, Nullable<int> user_Code, ObjectParameter pageNo, Nullable<int> pageSize, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Music_Deal(searchText, agreement_No, startDate, endDate, deal_Type_Code, status_Code, business_Unit_Code, deal_Tag_Code,  workflow_Status, vendor_Codes, show_Type_Code, title_Code, music_Label_Codes, isAdvance_Search, user_Code, pageNo, pageSize, recordCount);
        }

        public virtual ObjectResult<USP_Music_Deal_Link_Show_Result> USP_Music_Deal_Link_Show(string channel_Code, string title_Name, string mode, Nullable<int> music_Deal_Code, string selectedTitleCodes)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);

            return objContext.USP_Music_Deal_Link_Show(channel_Code, title_Name, mode, music_Deal_Code, selectedTitleCodes);
        }

        public virtual int USP_RollBack_Music_Deal(Nullable<int> music_Deal_Code, Nullable<int> user_Code, ObjectParameter errorMessage)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_RollBack_Music_Deal(music_Deal_Code, user_Code, errorMessage);
        }
        public virtual ObjectResult<USP_Get_Title_Content_Data_Result> USP_Get_Title_Content_Data(string data_For)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Title_Content_Data(data_For);
        }
        public virtual ObjectResult<USP_Acq_Deal_Rights_Holdback_Validation_Result> USP_Acq_Deal_Rights_Holdback_Validation(string acq_Deal_Right_Code, string platform_Code, string territoryCountry_Code, string Title_Code, Nullable<int> deal_Type_Code, string isTitleLangRight, string languageCode_Dub, string languageCode_Sub, string is_Exclusive)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Acq_Deal_Rights_Holdback_Validation(acq_Deal_Right_Code, platform_Code, territoryCountry_Code, Title_Code, deal_Type_Code, isTitleLangRight, languageCode_Dub, languageCode_Sub, is_Exclusive);
        }
        public virtual ObjectResult<USP_Syn_Deal_Rights_Holdback_Validation_Result> USP_Syn_Deal_Rights_Holdback_Validation(string syn_Deal_Right_Code, string platform_Code, string territoryCountry_Code, string Title_Code, Nullable<int> deal_Type_Code, string isTitleLangRight, string languageCode_Dub, string languageCode_Sub, string is_Exclusive)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Syn_Deal_Rights_Holdback_Validation(syn_Deal_Right_Code, platform_Code, territoryCountry_Code, Title_Code, deal_Type_Code, isTitleLangRight, languageCode_Dub, languageCode_Sub, is_Exclusive);
        }
        public virtual ObjectResult<USP_Acq_Deal_Rights_Holdback_Release_Result> USP_Acq_Deal_Rights_Holdback_Release(string AcqDealRightHoldbackCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Acq_Deal_Rights_Holdback_Release(AcqDealRightHoldbackCode);
        }
        public virtual ObjectResult<USP_Get_Content_Cost_Result> USP_Get_Content_Cost(Nullable<int> Title_Code, Nullable<int> Episode_No, string cost_type_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Content_Cost(Title_Code, Episode_No, cost_type_Code);
        }
        public virtual ObjectResult<USP_Get_Avail_Titles_Result> USP_Get_Avail_Titles(string txtSearch, string bU_Code, string availType, string titleNoInCodes)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Avail_Titles(txtSearch, bU_Code, availType, titleNoInCodes);
        }

        public virtual ObjectResult<USP_Deal_Rights_Template_Result> USP_Deal_Rights_Template(Nullable<int> deal_Code, string deal_Movie_Codes, Nullable<int> user_Code, string agreement_Date)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Deal_Rights_Template(deal_Code, deal_Movie_Codes, user_Code, agreement_Date);
        }

        public virtual ObjectResult<USP_GetSystem_Language_Message_ByModule_Result> USP_GetSystem_Language_Message_ByModule(Nullable<int> module_ID, string form_ID, Nullable<int> system_Language_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GetSystem_Language_Message_ByModule(module_ID, form_ID, system_Language_Code);
        }
        public virtual ObjectResult<USP_Music_Deal_Schedule_Validation_Result> USP_Music_Deal_Schedule_Validation(int Music_Deal_Code, string Channel_Codes, string Start_Date, string End_Date, string Title_Codes, string LinkshowType)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Music_Deal_Schedule_Validation(Music_Deal_Code, Channel_Codes, Start_Date, End_Date, Title_Codes, LinkshowType);
        }

        public virtual ObjectResult<USP_Get_Provisional_Deal_Title_Result> USP_Get_Provisional_Deal_Title(Nullable<int> Deal_Type_Code, string SearchString)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Provisional_Deal_Title(Deal_Type_Code, SearchString);
        }
        public virtual ObjectResult<USP_List_Provisional_Deal_Result> USP_List_Provisional_Deal(string searchText, string agreement_No, Nullable<System.DateTime> startDate, Nullable<System.DateTime> endDate, Nullable<int> deal_Type_Code, Nullable<int> business_Unit_Code, string vendor_Codes, string title_Codes, string isAdvance_Search, Nullable<int> user_Code, ObjectParameter pageNo, Nullable<int> pageSize, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Provisional_Deal(searchText, agreement_No, startDate, endDate, deal_Type_Code, business_Unit_Code, vendor_Codes, title_Codes, isAdvance_Search, user_Code, pageNo, pageSize, recordCount);
        }
        public virtual ObjectResult<USP_Integration_SDM_Generate_XML_Result> USP_Integration_SDM_Generate_XML(string module_Name, Nullable<System.DateTime> date_Since)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Integration_SDM_Generate_XML(module_Name, date_Since);
        }
        public virtual ObjectResult<USP_Validate_SDM_Title_Result> USP_Validate_SDM_Title(string validateXML)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Validate_SDM_Title(validateXML);
        }
        public void USP_INSERT_SAP_WBS_UDT(List<SAP_WBS_DATA_UDT> lst_SAP_WBS_DATA_UDT, List<Upload_File_Data_UDT> lst_Upload_File_Data_UDT, string Is_ERROR)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            objContext.USP_INSERT_SAP_WBS_UDT(lst_SAP_WBS_DATA_UDT, lst_Upload_File_Data_UDT, Is_ERROR);
        }

        public virtual ObjectResult<USP_Get_Acq_Syn_Status_Result> USP_Get_Acq_Syn_Status(Nullable<int> deal_Code, string type, Nullable<int> userCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Acq_Syn_Status(deal_Code, type, userCode);
        }
        public IEnumerable<USP_Content_Music_PI> USP_Content_Music_PI(
          List<Content_Music_Link_UDT> lstContent_Music_Link_UDT, int User_Code
            )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Content_Music_PI(lstContent_Music_Link_UDT, User_Code);
        }
        public IEnumerable<USP_Content_Music_PII> USP_Content_Music_PII(
         List<DM_Import_UDT> lstDM_Import_UDT, int? DM_Master_Import_Code, int? Users_Code
           )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Content_Music_PII(lstDM_Import_UDT, DM_Master_Import_Code, Users_Code);
        }
        public IEnumerable<USP_Content_Music_PIII> USP_Content_Music_PIII(
         int? DM_Master_Import_Code
           )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Content_Music_PIII(DM_Master_Import_Code);
        }
        public virtual ObjectResult<USP_GetMinMaxEpisode_Result> USP_GetMinMaxEpisode(Nullable<int> dealCode, string dealType)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GetMinMaxEpisode(dealCode, dealType);
        }

        public virtual int USP_DeleteContentMapping(Nullable<int> dealCode, string dealType)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_DeleteContentMapping(dealCode, dealType);
        }
        public virtual ObjectResult<string> USP_Get_ParentOrChild_Details_Promoter(string promoter_Group_Codes, string Type)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_ParentOrChild_Details_Promoter(promoter_Group_Codes, Type);
        }
        public ObjectResult<USP_Get_Music_Platform_Tree_Hierarchy_Result> USP_Get_Music_Platform_Tree_Hierarchy(string musicPlatformCodes, string search_Music_Platform_Name)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Music_Platform_Tree_Hierarchy(musicPlatformCodes, search_Music_Platform_Name);

        }
        public ObjectResult<USP_List_Content_Version_Result> USP_List_Content_Version(Nullable<int> title_Content_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Content_Version(title_Content_Code);

        }
        public ObjectResult<USP_List_Title_Content_ExportToXml_Result> USP_List_Title_Content_ExportToXml(string title_Content_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Title_Content_ExportToXml(title_Content_Code);
        }
        public ObjectResult<string> USP_GetPromoterCodes(string title_Code, string platform_Code, string country_Code, string subtitle_Code, string dubbing_Code, string title_Language, Nullable<int> deal_Type_Code, string period_Type, string start_Date, string end_Date)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_GetPromoterCodes(title_Code, platform_Code, country_Code, subtitle_Code, dubbing_Code, title_Language, deal_Type_Code, period_Type, start_Date, end_Date);
        }
        public ObjectResult<USP_Get_Title_Availability_LanguageWise_Filter_Result> USP_Get_Title_Availability_LanguageWise_Filter(string title_Code, string platform_Code, string country_Code, string subtit_Language_Code, string dubbing_Language_Code, string mustHavePlatform, string dubbing_Subtitling, string mustHaveRegion, string region_Exclusion, string title_Language_Code, Nullable<int> callFrom, string is_IFTA_Cluster, string subtitling_Group_Code, string subtitling_MustHave, string subtitling_Exclusion, string dubbing_Group_Code, string dubbing_MustHave, string dubbing_Exclusion, string platform_Group_Code, string mustHave_Platform, string territory_Code, string bU_Code, string subLicense_Code, string restrictionRemarks, string othersRemarks, string include_Metadata, string is_Digital, string exclusivity, string promoter_Code, string mustHave_Promoter)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Title_Availability_LanguageWise_Filter(title_Code, platform_Code, country_Code, subtit_Language_Code, dubbing_Language_Code, mustHavePlatform, dubbing_Subtitling, mustHaveRegion, region_Exclusion, title_Language_Code, callFrom, is_IFTA_Cluster, subtitling_Group_Code, subtitling_MustHave, subtitling_Exclusion, dubbing_Group_Code, dubbing_MustHave, dubbing_Exclusion, platform_Group_Code, mustHave_Platform, territory_Code, bU_Code, subLicense_Code, restrictionRemarks, othersRemarks, include_Metadata, is_Digital, exclusivity, promoter_Code, mustHave_Promoter);
        }
        public virtual ObjectResult<string> USP_Check_Autopush_Ammend_Acq(Nullable<int> acqDealCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Check_Autopush_Ammend_Acq(acqDealCode);
        }
        public virtual ObjectResult<string> USP_Check_Autopush_Ammend_Syn(Nullable<int> synDealCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Check_Autopush_Ammend_Syn(synDealCode);
        }
        public virtual ObjectResult<string> USP_Get_PlatformCodes_For_Ancillary(string title_Codes, string platform_Codes, string platform_Type, Nullable<int> acq_Deal_Code, string call_From_Rights, Nullable<int> deal_Rights_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_PlatformCodes_For_Ancillary(title_Codes, platform_Codes, platform_Type, acq_Deal_Code, call_From_Rights, deal_Rights_Code);
        }
        public IEnumerable<USP_Get_Title_Avail_Language_Data> USP_Get_Title_Avail_Language_Data(
        List<Avail_Report_Schedule_UDT> lstAvail_Report_Schedule_UDT, int UserCode, string Mode, string StrCriteria, int PageNo, string OrderByCndition, string IsPaging, int PageSize
           )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Title_Avail_Language_Data(lstAvail_Report_Schedule_UDT, UserCode, Mode, StrCriteria, PageNo, OrderByCndition, IsPaging, PageSize);
        }
        public IEnumerable<USP_Get_Title_Avail_Language_Data_Show> USP_Get_Title_Avail_Language_Data_Show(
       List<Avail_Report_Schedule_UDT> lstAvail_Report_Schedule_UDT, int UserCode, string Mode, string StrCriteria, int PageNo, string OrderByCndition, string IsPaging, int PageSize
          )
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Title_Avail_Language_Data_Show(lstAvail_Report_Schedule_UDT, UserCode, Mode, StrCriteria, PageNo, OrderByCndition, IsPaging, PageSize);
        }
        public virtual ObjectResult<USP_Get_BUWise_Title_Result> USP_Get_BUWise_Title(Nullable<int> buCode, string searchKey)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_BUWise_Title(buCode, searchKey);
        }

        public virtual ObjectResult<string> USP_Syn_Rights_Autopush_Delete_Validation(Nullable<int> synDealRightsCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Syn_Rights_Autopush_Delete_Validation(synDealRightsCode);
        }
        public virtual ObjectResult<USPPopulateTitleForMapping_Result> USPPopulateTitleForMapping(string searchKey)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPPopulateTitleForMapping(searchKey);
        }
        public virtual ObjectResult<USPVWTitleList_Result> USPVWTitleList(string searchString, string contentType)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPVWTitleList(searchString, contentType);
        }
        public virtual ObjectResult<USPGetTitleCode_Result> USPGetTitleCode(string titleName)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPGetTitleCode(titleName);
        }
        public virtual ObjectResult<USPGetTitleEpisodes_Result> USPGetTitleEpisodes(Nullable<int> titleCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPGetTitleEpisodes(titleCode);
        }
        public virtual ObjectResult<USPMHRequisitionList_Result> USPMHRequisitionList(string productionHouseCode, string musicLabel, Nullable<int> mHRequestTypeCode, string fromDate, string toDate, string statusCode, string titleCode, string businessUnitCode, string dealTypeCode, Nullable<int> pageNo, Nullable<int> pageSize, string usersCode, string requestId, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPMHRequisitionList(productionHouseCode, musicLabel, mHRequestTypeCode, fromDate, toDate, statusCode, titleCode, businessUnitCode, dealTypeCode, pageNo, pageSize, usersCode, requestId, recordCount);
        }
        public virtual ObjectResult<USPValidateMHRequestConsumption_Result> USPValidateMHRequestConsumption(Nullable<int> mHRequestCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPValidateMHRequestConsumption(mHRequestCode);
        }

        public virtual ObjectResult<USPMHCueSheetList_Result> USPMHCueSheetList(Nullable<int> productionHouseCode, string mHUploadStatus, Nullable<int> pageNo, Nullable<int> pageSize, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPMHCueSheetList(productionHouseCode, mHUploadStatus, pageNo, pageSize, recordCount);
        }
        public virtual ObjectResult<USPMHStatusHistoryList_Result> USPMHStatusHistoryList(Nullable<int> mHRequestTypeCode, string titleName, Nullable<int> mHRequestStatusCode, string requestID, string fromDate, string toDate, Nullable<int> pageNo, Nullable<int> pageSize, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPMHStatusHistoryList(mHRequestTypeCode, titleName, mHRequestStatusCode, requestID, fromDate, toDate, pageNo, pageSize, recordCount);
        }
        public virtual ObjectResult<string> USPMHGetErrorList(string list)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPMHGetErrorList(list);
        }
        public virtual ObjectResult<USPMHMusicTitleAlbumSearch_Result> USPMHMusicTitleAlbumSearch(string keyword, string type)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPMHMusicTitleAlbumSearch(keyword, type);
        }
        public virtual ObjectResult<USPRUBVMappingList_Result> USPRUBVMappingList(string dropdownOption, string tabselect, Nullable<int> pageNo, Nullable<int> pageSize, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPRUBVMappingList(dropdownOption, tabselect, pageNo, pageSize, recordCount);
        }
        public virtual ObjectResult<USPMHGetChartPopupList_Result> USPMHGetChartPopupList(string mHRequestCode, string prodHouseCode, string statusCode, string callFor, Nullable<int> pageNo, Nullable<int> pageSize, string dealTypeCode, string businessUnitCode, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPMHGetChartPopupList(mHRequestCode, prodHouseCode, statusCode, callFor, pageNo, pageSize, dealTypeCode, businessUnitCode, recordCount);
        }
        public virtual ObjectResult<USPBindJobAndExecute_Result> USPBindJobAndExecute(string type, string jobName)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPBindJobAndExecute(type, jobName);
        }

        public virtual ObjectResult<USP_List_Title_Milestone_Result> USP_List_Title_Milestone(Nullable<int> pageNo, ObjectParameter recordCount, string pagingRequired, Nullable<int> pageSize, Nullable<int> titleCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Title_Milestone(pageNo, recordCount,  pagingRequired, pageSize,  titleCode);
        }
        public virtual ObjectResult<string> USPMHGetMaxVendorCodes(string lastRequiredDate, string dealTypeCode, string businessUnitCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPMHGetMaxVendorCodes(lastRequiredDate, dealTypeCode, businessUnitCode);
        }

        public virtual ObjectResult<string> USPMHMailNotification(Nullable<int> mHRequestCode, Nullable<int> mHRequestTypeCode, Nullable<int> mHCueSheetCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPMHMailNotification(mHRequestCode, mHRequestTypeCode, mHCueSheetCode);
        }
        public virtual ObjectResult<USPMHRequistionTrackList_Result> USPMHRequistionTrackList(Nullable<int> mHRequestCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPMHRequistionTrackList(mHRequestCode);
        }
        public virtual ObjectResult<USPTATList_Result> USPTATList(Nullable<int> pageNo, Nullable<int> pageSize, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPTATList(pageNo, pageSize, recordCount);
        }
        public virtual ObjectResult<USPTATSLAList_Result> USPTATSLAList(Nullable<int> tATSLACode, string action)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPTATSLAList(tATSLACode, action);
        }
        public void USPSaveSLAMatrixUDT(List<TATSLAUDT> lst_TATSLAUDT, int UserCode)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            objContext.USPSaveSLAMatrixUDT(lst_TATSLAUDT, UserCode);
        }
        public virtual ObjectResult<USP_List_Acq_Linear_Title_Status_Result> USP_List_Acq_Linear_Title_Status(Nullable<int> acq_Deal_Code)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_Acq_Linear_Title_Status(acq_Deal_Code);
        }
        public virtual ObjectResult<USP_List_TitleBulkImport_Result> USP_List_TitleBulkImport(Nullable<int> dM_Master_Import_Code, string titleName, string titleType, string titleLanguage, string keyStarCast, string status, string errorMsg, string director, string musicLabel, string searchCriteria, Nullable<int> pageNo, Nullable<int> pageSize, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_TitleBulkImport(dM_Master_Import_Code, titleName, titleType, titleLanguage, keyStarCast, status, errorMsg, director, musicLabel, searchCriteria, pageNo, pageSize, recordCount);
        }
        public virtual ObjectResult<USP_List_ContentBulkImport_Result> USP_List_ContentBulkImport(Nullable<int> dM_Master_Import_Code, string searchCriteria, string contentName, string musicTrackName, string status, string errorMsg, string episodeNos, Nullable<int> pageNo, Nullable<int> pageSize, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_ContentBulkImport(dM_Master_Import_Code, searchCriteria, contentName, musicTrackName, status, errorMsg, episodeNos, pageNo, pageSize, recordCount);
        }
        public virtual ObjectResult<USP_List_MusicTrackBulkImport_Result> USP_List_MusicTrackBulkImport(Nullable<int> dM_Master_Import_Code, string searchCriteria, string musicTrack, string movieAlbum, string musicLabel, string titleLanguage, string starCast, string singer, string status, string errorMsg, string musicAlbumType, string genres, Nullable<int> pageNo, Nullable<int> pageSize, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_List_MusicTrackBulkImport(dM_Master_Import_Code, searchCriteria, musicTrack, movieAlbum, musicLabel, titleLanguage, starCast, singer, status,errorMsg, musicAlbumType, genres, pageNo, pageSize, recordCount);
        }
        public virtual ObjectResult<USPExportToExcelBulkImport_Result> USPExportToExcelBulkImport(Nullable<int> dM_Master_Import_Code, string searchCriteria, string file_Type)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPExportToExcelBulkImport(dM_Master_Import_Code, searchCriteria, file_Type);
        }
        public virtual ObjectResult<string> USP_Acq_Deal_Right_Clone(Nullable<int> new_Acq_Deal_Code, Nullable<int> acq_Deal_Rights_Code, Nullable<int> acq_Deal_Rights_Title_Code, Nullable<int> title_Code, string is_Program)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Acq_Deal_Right_Clone(new_Acq_Deal_Code, acq_Deal_Rights_Code, acq_Deal_Rights_Title_Code, title_Code, is_Program);
        }
        public virtual ObjectResult<USPListResolveConflict_Result> USPListResolveConflict(string dM_Master_Import_Code, Nullable<int> code, string fileType, Nullable<int> pageNo, Nullable<int> pageSize, ObjectParameter recordCount)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPListResolveConflict(dM_Master_Import_Code, code, fileType, pageNo, pageSize, recordCount);
        }
        public virtual ObjectResult<USPGetAiredNotAiredDates_Result> USPGetAiredNotAiredDates()
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USPGetAiredNotAiredDates();
        }
        public virtual ObjectResult<USP_Get_User_Security_Group_Tree_Hierarchy_Result> USP_Get_User_Security_Group_Tree_Hierarchy(string moduleCodes, string search_Module_Name)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_User_Security_Group_Tree_Hierarchy(moduleCodes, search_Module_Name);
        }

        public virtual ObjectResult<string> USP_Syn_Deal_Right_Clone(Nullable<int> new_Syn_Deal_Code, Nullable<int> Syn_Deal_Rights_Code, Nullable<int> Syn_Deal_Rights_Title_Code, Nullable<int> title_Code, string is_Program)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Syn_Deal_Right_Clone(new_Syn_Deal_Code, Syn_Deal_Rights_Code, Syn_Deal_Rights_Title_Code, title_Code, is_Program);
        }

        public virtual ObjectResult<string> USP_Get_ExcelSrNo(Nullable<int> dM_Master_Import_Code, string keyword, string callFor)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_ExcelSrNo(dM_Master_Import_Code, keyword, callFor);
        }

        public virtual ObjectResult<USP_Get_Title_Import_Utility_AdvSearch_Result> USP_Get_Title_Import_Utility_AdvSearch(Nullable<int> dM_Master_Import_Code, string callFor)
        {
            RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objContext.USP_Get_Title_Import_Utility_AdvSearch(dM_Master_Import_Code, callFor);
        }

    }
}
