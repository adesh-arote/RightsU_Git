//using EntityFrameworkExtras.EF6;
//using RightsU_DAL;
//using RightsU_Entities;
using RightsU_Dapper.Entity;
using RightsU_Dapper.BLL.Services;
using RightsU_Dapper.DAL.Repository;
using System;
using System.Collections.Generic;
//using System.Data.Entity.Core.Objects;

namespace RightsU_Dapper.BLL.Services
{
    /// <summary>
    /// Calls Stored Procedure _test
    /// </summary>
    /// <param name="Acq_Deal_Code"></param>
    /// <returns></returns>
    public class USP_Service
    {
      USP_Repositories objUSP_Repository = new USP_Repositories();
        public virtual string USP_MODULE_RIGHTS(Nullable<int> module_Code, Nullable<int> security_Group_Code, Nullable<int> users_Code)
        {
            return objUSP_Repository.USP_MODULE_RIGHTS(module_Code, security_Group_Code, users_Code);
        }
        public IEnumerable<string> USP_Validate_Talent_Master(Nullable<int> talent_Code, string selected_Role_Code)
        {
            return objUSP_Repository.USP_Validate_Talent_Master(talent_Code, selected_Role_Code);
        }
        public IEnumerable<USP_List_Country_Result> USP_List_Country(Nullable<int> sysLanguageCode)
        {
            //RightsU_NeoEntities objContext = new RightsU_NeoEntities(conStr);
            return objUSP_Repository.USP_List_Country(sysLanguageCode);
        }
        public IEnumerable<USP_Uploaded_File_Error_List_Result> USP_Uploaded_File_Error_List(Nullable<int> file_Code)
        {
            //USP_DAL objUSPDAL = new USP_DAL(conStr);
            return objUSP_Repository.USP_Uploaded_File_Error_List(file_Code);
        }
        public virtual IEnumerable<USP_GET_TITLE_DATA_Result> USP_GET_TITLE_DATA(string searchTitle, Nullable<int> deal_Type_Code)
        {
            //USP_DAL objUSPDAL = new USP_DAL(conStr);
            return objUSP_Repository.USP_GET_TITLE_DATA(searchTitle, deal_Type_Code);
        }
        //public virtual IEnumerable<USPRUBVMappingList_Result> USPRUBVMappingList(string dropdownOption, string tabselect, Nullable<int> pageNo, Nullable<int> pageSize, ObjectParameter recordCount)
        //{
        //    //USP_DAL objUSPDAL = new USP_DAL(conStr);
        //    return objUSP_Repository.USPRUBVMappingList(dropdownOption, tabselect, pageNo, pageSize, recordCount);
        //}
        public IEnumerable<USP_Validate_Episode_Result> USP_Validate_Episode(string title_with_Episode, string Program_Type)
        {
            //USP_DAL objUSPDAL = new USP_DAL(conStr);
            return objUSP_Repository.USP_Validate_Episode(title_with_Episode, Program_Type);
        }
        public IEnumerable<USP_Get_Platform_Tree_Hierarchy_Result> USP_Get_Platform_Tree_Hierarchy(string platformCodes, string search_Platform_Name)
        {
            return objUSP_Repository.USP_Get_Platform_Tree_Hierarchy(platformCodes, search_Platform_Name);
        }
        public IEnumerable<USP_Music_Exception_Handling_Result> USP_Music_Exception_Handling(string isAired, Nullable<int> pageNo, out int recordCount, string isPaging, Nullable<int> pageSize, string musicTrackCode, string musicLabelCode, string channelCode, string contentCode, string episodeFrom, string episodeTo, string initialResponse, string exceptionStatus, Nullable<int> userCode, string commonSearch, Nullable<System.DateTime> startDate, Nullable<System.DateTime> endDate)
        {
            return objUSP_Repository.USP_Music_Exception_Handling(isAired, pageNo,out recordCount, isPaging, pageSize, musicTrackCode, musicLabelCode, channelCode, contentCode, episodeFrom, episodeTo, initialResponse, exceptionStatus, userCode, commonSearch, startDate, endDate);
        }
        public virtual IEnumerable<USP_Music_Exception_Dashboard_Result> USP_Music_Exception_Dashboard(string isAired, string musicTrackCode, string musicLabelCode, string channelCode, string contentCode, string episodeFrom, string episodeTo, string initialResponse, string exceptionStatus, Nullable<int> userCode, string commonSearch, Nullable<System.DateTime> startDate, Nullable<System.DateTime> endDate)
        {
            return objUSP_Repository.USP_Music_Exception_Dashboard(isAired, musicTrackCode, musicLabelCode, channelCode, contentCode, episodeFrom, episodeTo, initialResponse, exceptionStatus, userCode, commonSearch, startDate, endDate);
        }
        public IEnumerable<USP_List_Status_History_Result> USP_List_Status_History(Nullable<int> record_Code, Nullable<int> module_Code)
        {
            return objUSP_Repository.USP_List_Status_History(record_Code, module_Code);
        }
        public IEnumerable<string> USP_Assign_Workflow(Nullable<int> record_Code, Nullable<int> module_Code, Nullable<int> login_User, string remarks_Approval)
        {
            return objUSP_Repository.USP_Assign_Workflow(record_Code, module_Code, login_User, remarks_Approval);
        }

        //public virtual void USP_UpdateContentHouseID(Nullable<int> BV_HouseId_Data_Code, Nullable<int> MappedDealTitleCode)
        //{
        //    //USP_DAL objUSPDAL = new USP_DAL(conStr);
        //    objUSP_Repository.USP_UpdateContentHouseID(BV_HouseId_Data_Code, MappedDealTitleCode);
        //}
        //public virtual void USP_BV_Title_Mapping_Shows(string BV_HouseId_Data_Code)
        //{
        //    USP_DAL objUSPDAL = new USP_DAL(conStr);
        //    objUSPDAL.USP_BV_Title_Mapping_Shows(BV_HouseId_Data_Code);
        //}
        public IEnumerable<USP_Get_Title_PreReq_Result> USP_Get_Title_PreReq(string data_For, Nullable<int> deal_Type_Code, Nullable<int> business_Unit_Code, string search_String)
        {
            return objUSP_Repository.USP_Get_Title_PreReq(data_For, deal_Type_Code, business_Unit_Code, search_String);
        }
        public IEnumerable<USP_Get_Talent_Name_Result> USP_Get_Talent_Name()
        {
            return objUSP_Repository.USP_Get_Talent_Name();
        }
        public IEnumerable<USP_List_Music_Title_Result> USP_List_Music_Title(string musicTitleName, Nullable<int> sysLanguageCode, Nullable<int> pageNo,out int recordCount, string isPaging, Nullable<int> pageSize, string starCastCode, string languageCode, string albumCode, string genresCode, string musicLabelCode, string yearOfRelease, string singerCode, string composerCode, string lyricistCode, string musicNameText, string themeCode, string musicTag, string publicDomain, string ExactMatch = "")
        {
           
            return objUSP_Repository.USP_List_Music_Title(musicTitleName, sysLanguageCode, pageNo,out recordCount, isPaging, pageSize, starCastCode, languageCode, albumCode, genresCode, musicLabelCode, yearOfRelease, singerCode, composerCode, lyricistCode, musicNameText, themeCode, musicTag, publicDomain, ExactMatch);
        }
        public IEnumerable<USP_Insert_Music_Title_Import_UDT> USP_Insert_Music_Title_Import_UDT(
        List<Music_Title_Import_UDT> lstMusic_Title_Import_UDT, int User_Code
          )
        {
            return objUSP_Repository.USP_Insert_Music_Title_Import_UDT(lstMusic_Title_Import_UDT, User_Code);
        }

        public IEnumerable<USP_Music_Title_Contents_Result> USP_Music_Title_Contents(Nullable<int> Music_Title_Code, string GenericSearch, out int RecordCount, string IsPaging, Nullable<int> PageSize, Nullable<int> PageNo)
        {
            return objUSP_Repository.USP_Music_Title_Contents(Music_Title_Code, GenericSearch,out RecordCount, IsPaging, PageSize, PageNo);
        }
    }
}

