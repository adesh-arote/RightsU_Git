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
    }
}

