using RightsU_Dapper.DAL.Repository;
using RightsU_Dapper.Entity.Master_Entities;
using RightsU_Dapper.Entity.StoredProcedure_Entities;
using RightsU_Dapper.Entity.System_Setting_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.BLL.Services
{
    public class Payment_Term_Service
    {
        Payment_Terms_Repository objPayment_Term_Repository = new Payment_Terms_Repository();
        public Payment_Term_Service()
        {
            this.objPayment_Term_Repository = new Payment_Terms_Repository();
        }
        public Payment_Term GetByID(int? ID, Type[] RelationList = null)
        {
            return objPayment_Term_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Payment_Term> GetAll()
        {
            return objPayment_Term_Repository.GetAll();
        }
        public void AddEntity(Payment_Term obj)
        {
            objPayment_Term_Repository.Add(obj);
        }
        public void UpdateEntity(Payment_Term obj)
        {
            objPayment_Term_Repository.Update(obj);
        }
        public void DeleteEntity(Payment_Term obj)
        {
            objPayment_Term_Repository.Delete(obj);
        }
        public IEnumerable<Payment_Term> SearchFor(object param)
        {
            return objPayment_Term_Repository.SearchFor(param);
        }
    }
    public class Royalty_Recoupment_Service
    {
        Royalty_Recoupment_Repository objRoyalty_Recoupment_Repository = new Royalty_Recoupment_Repository();
        public Royalty_Recoupment_Service()
        {
            this.objRoyalty_Recoupment_Repository = new Royalty_Recoupment_Repository();
        }
        public Royalty_Recoupment GetByID(int? ID, Type[] RelationList = null)
        {
            return objRoyalty_Recoupment_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Royalty_Recoupment> GetAll()
        {
            return objRoyalty_Recoupment_Repository.GetAll();
        }
        public void AddEntity(Royalty_Recoupment obj)
        {
            objRoyalty_Recoupment_Repository.Add(obj);
        }
        public void UpdateEntity(Royalty_Recoupment obj)
        {
            objRoyalty_Recoupment_Repository.Update(obj);
        }
        public void DeleteEntity(Royalty_Recoupment obj)
        {
            objRoyalty_Recoupment_Repository.Delete(obj);
        }
        public IEnumerable<Royalty_Recoupment> SearchFor(object param)
        {
            return objRoyalty_Recoupment_Repository.SearchFor(param);
        }
    }
    public class Royalty_Recoupment_Details_Service
    {
        Royalty_Recoupment_Details_Repository objRoyalty_Recoupment_Details_Repository = new Royalty_Recoupment_Details_Repository();
        public Royalty_Recoupment_Details_Service()
        {
            this.objRoyalty_Recoupment_Details_Repository = new Royalty_Recoupment_Details_Repository();
        }
        public Royalty_Recoupment_Details GetByID(int? ID, Type[] RelationList = null)
        {
            return objRoyalty_Recoupment_Details_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Royalty_Recoupment_Details> GetAll()
        {
            return objRoyalty_Recoupment_Details_Repository.GetAll();
        }
        public void AddEntity(Royalty_Recoupment_Details obj)
        {
            objRoyalty_Recoupment_Details_Repository.Add(obj);
        }
        public void UpdateEntity(Royalty_Recoupment_Details obj)
        {
            objRoyalty_Recoupment_Details_Repository.Update(obj);
        }
        public void DeleteEntity(Royalty_Recoupment_Details obj)
        {
            objRoyalty_Recoupment_Details_Repository.Delete(obj);
        }
        public IEnumerable<Royalty_Recoupment_Details> SearchFor(object param)
        {
            return objRoyalty_Recoupment_Details_Repository.SearchFor(param);
        }
    }
    public class User_Service
    {
        User_Repository objUser_Repository = new User_Repository();
        public User_Service()
        {
            this.objUser_Repository = new User_Repository();
        }
        public User GetByID(int? ID, Type[] RelationList = null)
        {
            return objUser_Repository.Get(ID, RelationList);
        }
        public IEnumerable<User> GetAll()
        {
            return objUser_Repository.GetAll();
        }
        public void AddEntity(User obj)
        {
            objUser_Repository.Add(obj);
        }
        public void UpdateEntity(User obj)
        {
            objUser_Repository.Update(obj);
        }
        public void DeleteEntity(User obj)
        {
            objUser_Repository.Delete(obj);
        }
        public IEnumerable<User> SearchFor(object param)
        {
            return objUser_Repository.SearchFor(param);
        }
    }
    public class Users_Exclusive_Rights_Service
    {
        Users_Exclusion_Rights_Repository objUsers_Exclusion_Rights_Repository = new Users_Exclusion_Rights_Repository();
        public Users_Exclusive_Rights_Service()
        {
            this.objUsers_Exclusion_Rights_Repository = new Users_Exclusion_Rights_Repository();
        }
        public Users_Exclusion_Rights GetByID(int? ID, Type[] RelationList = null)
        {
            return objUsers_Exclusion_Rights_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Users_Exclusion_Rights> GetAll()
        {
            return objUsers_Exclusion_Rights_Repository.GetAll();
        }
        public void AddEntity(Users_Exclusion_Rights obj)
        {
            objUsers_Exclusion_Rights_Repository.Add(obj);
        }
        public void UpdateEntity(Users_Exclusion_Rights obj)
        {
            objUsers_Exclusion_Rights_Repository.Update(obj);
        }
        public void DeleteEntity(Users_Exclusion_Rights obj)
        {
            objUsers_Exclusion_Rights_Repository.Delete(obj);
        }
        public IEnumerable<Users_Exclusion_Rights> SearchFor(object param)
        {
            return objUsers_Exclusion_Rights_Repository.SearchFor(param);
        }
    }
    public class Business_Unit_Service
    {
        Business_Unit_Repository objBusiness_Unit_Repository = new Business_Unit_Repository();
        public Business_Unit_Service()
        {
            this.objBusiness_Unit_Repository = new Business_Unit_Repository();
        }
        public Business_Unit GetByID(int? ID, Type[] RelationList = null)
        {
            return objBusiness_Unit_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Business_Unit> GetAll()
        {
            return objBusiness_Unit_Repository.GetAll();
        }
        public void AddEntity(Business_Unit obj)
        {
            objBusiness_Unit_Repository.Add(obj);
        }
        public void UpdateEntity(Business_Unit obj)
        {
            objBusiness_Unit_Repository.Update(obj);
        }
        public void DeleteEntity(Business_Unit obj)
        {
            objBusiness_Unit_Repository.Delete(obj);
        }
        public IEnumerable<Business_Unit> SearchFor(object param)
        {
            return objBusiness_Unit_Repository.SearchFor(param);
        }
    }
    public class Users_Password_Detail_Service
    {
        Users_Password_Detail_Repository objUsers_Password_Detail_Repository = new Users_Password_Detail_Repository();
        public Users_Password_Detail_Service()
        {
            this.objUsers_Password_Detail_Repository = new Users_Password_Detail_Repository();
        }
        public Users_Password_Detail GetByID(int? ID, Type[] RelationList = null)
        {
            return objUsers_Password_Detail_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Users_Password_Detail> GetAll()
        {
            return objUsers_Password_Detail_Repository.GetAll();
        }
        public void AddEntity(Users_Password_Detail obj)
        {
            objUsers_Password_Detail_Repository.Add(obj);
        }
        public void UpdateEntity(Users_Password_Detail obj)
        {
            objUsers_Password_Detail_Repository.Update(obj);
        }
        public void DeleteEntity(Users_Password_Detail obj)
        {
            objUsers_Password_Detail_Repository.Delete(obj);
        }
        public IEnumerable<Users_Password_Detail> SearchFor(object param)
        {
            return objUsers_Password_Detail_Repository.SearchFor(param);
        }
    }
    public class SAP_WBS_Service
    {
        SAP_WBS_Repository objSAP_WBS_Repository = new SAP_WBS_Repository();
        public SAP_WBS_Service()
        {
            this.objSAP_WBS_Repository = new SAP_WBS_Repository();
        }
        public SAP_WBS GetByID(int? ID, Type[] RelationList = null)
        {
            return objSAP_WBS_Repository.Get(ID, RelationList);
        }
        public IEnumerable<SAP_WBS> GetAll()
        {
            return objSAP_WBS_Repository.GetAll();
        }
        public void AddEntity(SAP_WBS obj)
        {
            objSAP_WBS_Repository.Add(obj);
        }
        public void UpdateEntity(SAP_WBS obj)
        {
            objSAP_WBS_Repository.Update(obj);
        }
        public void DeleteEntity(SAP_WBS obj)
        {
            objSAP_WBS_Repository.Delete(obj);
        }
        public IEnumerable<SAP_WBS> SearchFor(object param)
        {
            return objSAP_WBS_Repository.SearchFor(param);
        }
    }
    public class BVException_Service
    {
        BVException_Repository objBVException_Repository = new BVException_Repository();
        public BVException_Service()
        {
            this.objBVException_Repository = new BVException_Repository();
        }
        public BVException GetByID(int? ID, Type[] RelationList = null)
        {
            return objBVException_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BVException> GetAll(Type[] RelationList = null)
        {
            return objBVException_Repository.GetAll(RelationList);
        }
        public void AddEntity(BVException obj)
        {
            objBVException_Repository.Add(obj);
        }
        public void UpdateEntity(BVException obj)
        {
            objBVException_Repository.Update(obj);
        }
        public void DeleteEntity(BVException obj)
        {
            objBVException_Repository.Delete(obj);
        }
        public IEnumerable<BVException> SearchFor(object param)
        {
            return objBVException_Repository.SearchFor(param);
        }
    }

    public class System_Language_Service
    {
        System_Language_Repository objSystem_Language_Repository = new System_Language_Repository();
        public System_Language_Service()
        {
            this.objSystem_Language_Repository = new System_Language_Repository();
        }
        public System_Language GetByID(int? ID, Type[] RelationList = null)
        {
            return objSystem_Language_Repository.Get(ID, RelationList);
        }
        public IEnumerable<System_Language> GetAll(Type[] RelationList = null)
        {
            return objSystem_Language_Repository.GetAll(RelationList);
        }
        public void AddEntity(System_Language obj)
        {
            objSystem_Language_Repository.Add(obj);
        }
        public void UpdateEntity(System_Language obj)
        {
            objSystem_Language_Repository.Update(obj);
        }
        public void DeleteEntity(System_Language obj)
        {
            objSystem_Language_Repository.Delete(obj);
        }
        public IEnumerable<System_Language> SearchFor(object param)
        {
            return objSystem_Language_Repository.SearchFor(param);
        }
    }

    public class System_Module_Message_Service
    {
        System_Module_Message_Repository objSystem_Module_Message_Repository = new System_Module_Message_Repository();
        public System_Module_Message_Service()
        {
            this.objSystem_Module_Message_Repository = new System_Module_Message_Repository();
        }
        public System_Module_Message GetByID(int? ID, Type[] RelationList = null)
        {
            return objSystem_Module_Message_Repository.Get(ID, RelationList);
        }
        public IEnumerable<System_Module_Message> GetAll(Type[] RelationList = null)
        {
            return objSystem_Module_Message_Repository.GetAll(RelationList);
        }
        public void AddEntity(System_Module_Message obj)
        {
            objSystem_Module_Message_Repository.Add(obj);
        }
        public void UpdateEntity(System_Module_Message obj)
        {
            objSystem_Module_Message_Repository.Update(obj);
        }
        public void DeleteEntity(System_Module_Message obj)
        {
            objSystem_Module_Message_Repository.Delete(obj);
        }
        public IEnumerable<System_Module_Message> SearchFor(object param)
        {
            return objSystem_Module_Message_Repository.SearchFor(param);
        }
    }
    public class System_Module_Service
    {
        System_Module_Repository objSystem_Module_Repository = new System_Module_Repository();
        public System_Module_Service()
        {
            this.objSystem_Module_Repository = new System_Module_Repository();
        }
        public System_Module GetByID(int? ID, Type[] RelationList = null)
        {
            return objSystem_Module_Repository.Get(ID, RelationList);
        }
        public IEnumerable<System_Module> GetAll(Type[] RelationList = null)
        {
            return objSystem_Module_Repository.GetAll(RelationList);
        }
        public void AddEntity(System_Module obj)
        {
            objSystem_Module_Repository.Add(obj);
        }
        public void UpdateEntity(System_Module obj)
        {
            objSystem_Module_Repository.Update(obj);
        }
        public void DeleteEntity(System_Module obj)
        {
            objSystem_Module_Repository.Delete(obj);
        }
        public IEnumerable<System_Module> SearchFor(object param)
        {
            return objSystem_Module_Repository.SearchFor(param);
        }
    }
    public class USP_GetSystem_Language_Message_ByModule_Service
    {
        USP_GetSystem_Language_Message_ByModule_Repository objUSP_Repository = new USP_GetSystem_Language_Message_ByModule_Repository();

        public USP_GetSystem_Language_Message_ByModule_Service()
        {
            this.objUSP_Repository = new USP_GetSystem_Language_Message_ByModule_Repository();
        }
        public IEnumerable<USP_GetSystem_Language_Message_ByModule_Result> USP_GetSystem_Language_Message_ByModule(Nullable<int> module_Code, string form_ID, Nullable<int> system_Language_Code)
        {
            return objUSP_Repository.USP_GetSystem_Language_Message_ByModule(module_Code, form_ID, system_Language_Code);
        }
    }
    public class Workflow_Module_Service
    {
        Workflow_Module_Repository objWorkflow_Module_Repository = new Workflow_Module_Repository();
        public Workflow_Module_Service()
        {
            this.objWorkflow_Module_Repository = new Workflow_Module_Repository();
        }
        public Workflow_Module GetByID(int? ID, Type[] RelationList = null)
        {
            return objWorkflow_Module_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Workflow_Module> GetAll(Type[] RelationList = null)
        {
            return objWorkflow_Module_Repository.GetAll(RelationList);
        }
        public void AddEntity(Workflow_Module obj)
        {
            objWorkflow_Module_Repository.Add(obj);
        }
        public void UpdateEntity(Workflow_Module obj)
        {
            objWorkflow_Module_Repository.Update(obj);
        }
        public void DeleteEntity(Workflow_Module obj)
        {
            objWorkflow_Module_Repository.Delete(obj);
        }
        public IEnumerable<Workflow_Module> SearchFor(object param)
        {
            return objWorkflow_Module_Repository.SearchFor(param);
        }
    }
    public class Workflow_Service
    {
        Workflow_Repository objWorkflow_Repository = new Workflow_Repository();
        public Workflow_Service()
        {
            this.objWorkflow_Repository = new Workflow_Repository();
        }
        public Workflow GetByID(int? ID, Type[] RelationList = null)
        {
            return objWorkflow_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Workflow> GetAll(Type[] RelationList = null)
        {
            return objWorkflow_Repository.GetAll(RelationList);
        }
        public void AddEntity(Workflow obj)
        {
            objWorkflow_Repository.Add(obj);
        }
        public void UpdateEntity(Workflow obj)
        {
            objWorkflow_Repository.Update(obj);
        }
        public void DeleteEntity(Workflow obj)
        {
            objWorkflow_Repository.Delete(obj);
        }
        public IEnumerable<Workflow> SearchFor(object param)
        {
            return objWorkflow_Repository.SearchFor(param);
        }
    }
    public class Workflow_Role_Service
    {
        Workflow_Role_Repository objWorkflow_Role_Repository = new Workflow_Role_Repository();
        public Workflow_Role_Service()
        {
            this.objWorkflow_Role_Repository = new Workflow_Role_Repository();
        }
        public Workflow_Role GetByID(int? ID, Type[] RelationList = null)
        {
            return objWorkflow_Role_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Workflow_Role> GetAll(Type[] RelationList = null)
        {
            return objWorkflow_Role_Repository.GetAll(RelationList);
        }
        public void AddEntity(Workflow_Role obj)
        {
            objWorkflow_Role_Repository.Add(obj);
        }
        public void UpdateEntity(Workflow_Role obj)
        {
            objWorkflow_Role_Repository.Update(obj);
        }
        public void DeleteEntity(Workflow_Role obj)
        {
            objWorkflow_Role_Repository.Delete(obj);
        }
        public IEnumerable<Workflow_Role> SearchFor(object param)
        {
            return objWorkflow_Role_Repository.SearchFor(param);
        }
    }
    public class Workflow_Module_Role_Service
    {
        Workflow_Module_Role_Repository objWorkflow_Module_Role_Repository = new Workflow_Module_Role_Repository();
        public Workflow_Module_Role_Service()
        {
            this.objWorkflow_Module_Role_Repository = new Workflow_Module_Role_Repository();
        }
        public Workflow_Module_Role GetByID(int? ID, Type[] RelationList = null)
        {
            return objWorkflow_Module_Role_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Workflow_Module_Role> GetAll(Type[] RelationList = null)
        {
            return objWorkflow_Module_Role_Repository.GetAll(RelationList);
        }
        public void AddEntity(Workflow_Module_Role obj)
        {
            objWorkflow_Module_Role_Repository.Add(obj);
        }
        public void UpdateEntity(Workflow_Module_Role obj)
        {
            objWorkflow_Module_Role_Repository.Update(obj);
        }
        public void DeleteEntity(Workflow_Module_Role obj)
        {
            objWorkflow_Module_Role_Repository.Delete(obj);
        }
        public IEnumerable<Workflow_Module_Role> SearchFor(object param)
        {
            return objWorkflow_Module_Role_Repository.SearchFor(param);
        }
    }
    public class Users_Business_Unit_Service
    {
        Users_Business_Unit_Repository objUsers_Business_Unit_Repository = new Users_Business_Unit_Repository();
        public Users_Business_Unit_Service()
        {
            this.objUsers_Business_Unit_Repository = new Users_Business_Unit_Repository();
        }
        public Users_Business_Unit GetByID(int? ID, Type[] RelationList = null)
        {
            return objUsers_Business_Unit_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Users_Business_Unit> GetAll(Type[] RelationList = null)
        {
            return objUsers_Business_Unit_Repository.GetAll(RelationList);
        }
        public void AddEntity(Users_Business_Unit obj)
        {
            objUsers_Business_Unit_Repository.Add(obj);
        }
        public void UpdateEntity(Users_Business_Unit obj)
        {
            objUsers_Business_Unit_Repository.Update(obj);
        }
        public void DeleteEntity(Users_Business_Unit obj)
        {
            objUsers_Business_Unit_Repository.Delete(obj);
        }
        public IEnumerable<Users_Business_Unit> SearchFor(object param)
        {
            return objUsers_Business_Unit_Repository.SearchFor(param);
        }
    }
    public class BV_HouseId_Data_Service
    {
        BV_HouseId_Data_Repository objBV_HouseId_Data_Repository = new BV_HouseId_Data_Repository();
        public BV_HouseId_Data_Service()
        {
            this.objBV_HouseId_Data_Repository = new BV_HouseId_Data_Repository();
        }
        public BV_HouseId_Data GetByID(int? ID, Type[] RelationList = null)
        {
            return objBV_HouseId_Data_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BV_HouseId_Data> GetAll(Type[] RelationList = null)
        {
            return objBV_HouseId_Data_Repository.GetAll(RelationList);
        }
        public void AddEntity(BV_HouseId_Data obj)
        {
            objBV_HouseId_Data_Repository.Add(obj);
        }
        public void UpdateEntity(BV_HouseId_Data obj)
        {
            objBV_HouseId_Data_Repository.Update(obj);
        }
        public void DeleteEntity(BV_HouseId_Data obj)
        {
            objBV_HouseId_Data_Repository.Delete(obj);
        }
        public IEnumerable<BV_HouseId_Data> SearchFor(object param)
        {
            return objBV_HouseId_Data_Repository.SearchFor(param);
        }
    }
    public class USP_Validate_Episode_Service
    {
        USP_Validate_Episode_Repository objUSP_Repository = new USP_Validate_Episode_Repository();

        public USP_Validate_Episode_Service()
        {
            this.objUSP_Repository = new USP_Validate_Episode_Repository();
        }
        public IEnumerable<USP_Validate_Episode_Result> USP_Validate_Episode(string title_with_Episode, string Program_Type)
        {
            return objUSP_Repository.USP_Validate_Episode(title_with_Episode, Program_Type);
        }
    }
    public class USP_UpdateContentHouseID_Service
    {
        USP_UpdateContentHouseID_Repository objUSP_UpdateContentHouseID_Repository = new USP_UpdateContentHouseID_Repository();

        public USP_UpdateContentHouseID_Service()
        {
            this.objUSP_UpdateContentHouseID_Repository = new USP_UpdateContentHouseID_Repository();
        }
        public void USP_UpdateContentHouseID(Nullable<int> BV_HouseId_Data_Code, Nullable<int> MappedDealTitleCode)
        {
            objUSP_UpdateContentHouseID_Repository.USP_UpdateContentHouseID(BV_HouseId_Data_Code, MappedDealTitleCode);
        }
    }
    public class BMS_Log_Service
    {
        BMS_Log_Repository objBMS_Log_Repository = new BMS_Log_Repository();
        public BMS_Log_Service()
        {
            this.objBMS_Log_Repository = new BMS_Log_Repository();
        }
        public BMS_Log GetByID(int? ID, Type[] RelationList = null)
        {
            return objBMS_Log_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BMS_Log> GetAll(Type[] RelationList = null)
        {
            return objBMS_Log_Repository.GetAll(RelationList);
        }
        public void AddEntity(BMS_Log obj)
        {
            objBMS_Log_Repository.Add(obj);
        }
        public void UpdateEntity(BMS_Log obj)
        {
            objBMS_Log_Repository.Update(obj);
        }
        public void DeleteEntity(BMS_Log obj)
        {
            objBMS_Log_Repository.Delete(obj);
        }
    }

    public class USP_List_BMS_log_Service
    {
        USP_List_BMS_log_Repository objUSP_Repository = new USP_List_BMS_log_Repository();

        public USP_List_BMS_log_Service()
        {
            this.objUSP_Repository = new USP_List_BMS_log_Repository();
        }
        public IEnumerable<USP_List_BMS_log_Result> USP_List_BMS_log(string strSearch, Nullable<int> pageNo, string isPaging, Nullable<int> pageSize, out int recordCount)
        {
            return objUSP_Repository.USP_List_BMS_log(strSearch, pageNo, isPaging, pageSize, out recordCount);
        }
    }
    public class BMS_All_Masters_Service
    {
        BMS_All_Masters_Repository objBMS_All_Masters_Repository = new BMS_All_Masters_Repository();
        public BMS_All_Masters_Service()
        {
            this.objBMS_All_Masters_Repository = new BMS_All_Masters_Repository();
        }
        public BMS_All_Masters GetByID(int? ID, Type[] RelationList = null)
        {
            return objBMS_All_Masters_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BMS_All_Masters> GetAll(Type[] RelationList = null)
        {
            return objBMS_All_Masters_Repository.GetAll(RelationList);
        }
        public void AddEntity(BMS_All_Masters obj)
        {
            objBMS_All_Masters_Repository.Add(obj);
        }
        public void UpdateEntity(BMS_All_Masters obj)
        {
            objBMS_All_Masters_Repository.Update(obj);
        }
        public void DeleteEntity(BMS_All_Masters obj)
        {
            objBMS_All_Masters_Repository.Delete(obj);
        }
    }
    public class USP_List_Amort_Rule_Service
    {
        USP_List_Amort_Rule_Repository objUSP_Repository = new USP_List_Amort_Rule_Repository();

        public USP_List_Amort_Rule_Service()
        {
            this.objUSP_Repository = new USP_List_Amort_Rule_Repository();
        }
        public IEnumerable<USP_List_Amort_Rule_Result> USP_List_Amort_Rule(string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, out int recordCount, Nullable<int> user_Code, string moduleCode)
        {
            return objUSP_Repository.USP_List_Amort_Rule(strSearch, pageNo, orderByCndition, isPaging, pageSize, out recordCount, user_Code, moduleCode);
        }
    }
    public class Amort_Rule_Service
    {
        Amort_Rule_Repository objAmort_Rule_Repository = new Amort_Rule_Repository();
        public Amort_Rule_Service()
        {
            this.objAmort_Rule_Repository = new Amort_Rule_Repository();
        }
        public Amort_Rule GetByID(int? ID, Type[] RelationList = null)
        {
            return objAmort_Rule_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Amort_Rule> GetAll(Type[] RelationList = null)
        {
            return objAmort_Rule_Repository.GetAll(RelationList);
        }
        public void AddEntity(Amort_Rule obj)
        {
            objAmort_Rule_Repository.Add(obj);
        }
        public void UpdateEntity(Amort_Rule obj)
        {
            objAmort_Rule_Repository.Update(obj);
        }
        public void DeleteEntity(Amort_Rule obj)
        {
            objAmort_Rule_Repository.Delete(obj);
        }
    }
    public class USPBindJobAndExecute_Service
    {
        USPBindJobAndExecute_Repository objUSP_Repository = new USPBindJobAndExecute_Repository();

        public USPBindJobAndExecute_Service()
        {
            this.objUSP_Repository = new USPBindJobAndExecute_Repository();
        }
        public IEnumerable<USPBindJobAndExecute_Result> USPBindJobAndExecute(string type, string jobName)
        {
            return objUSP_Repository.USPBindJobAndExecute(type, jobName);
        }
    }
    public class USPRUBVMappingList_Service
    {
        USPRUBVMappingList_Repository objUSP_Repository = new USPRUBVMappingList_Repository();

        public USPRUBVMappingList_Service()
        {
            this.objUSP_Repository = new USPRUBVMappingList_Repository();
        }
        public IEnumerable<USPRUBVMappingList_Result> USPRUBVMappingList(string dropdownOption, string tabselect, Nullable<int> pageNo, Nullable<int> pageSize, out int recordCount)
        {
            return objUSP_Repository.USPRUBVMappingList(dropdownOption, tabselect, pageNo, pageSize, out recordCount);
        }
    }
    public class BMS_Asset_Service
    {
        BMS_Asset_Repository objBMS_Asset_Repository = new BMS_Asset_Repository();
        public BMS_Asset_Service()
        {
            this.objBMS_Asset_Repository = new BMS_Asset_Repository();
        }
        public BMS_Asset GetByID(int? ID, Type[] RelationList = null)
        {
            return objBMS_Asset_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BMS_Asset> GetAll(Type[] RelationList = null)
        {
            return objBMS_Asset_Repository.GetAll(RelationList);
        }
        public void AddEntity(BMS_Asset obj)
        {
            objBMS_Asset_Repository.Add(obj);
        }
        public void UpdateEntity(BMS_Asset obj)
        {
            objBMS_Asset_Repository.Update(obj);
        }
        public void DeleteEntity(BMS_Asset obj)
        {
            objBMS_Asset_Repository.Delete(obj);
        }
    }
    public class BMS_Deal_Content_Service
    {
        BMS_Deal_Content_Repository objBMS_Deal_Content_Repository = new BMS_Deal_Content_Repository();
        public BMS_Deal_Content_Service()
        {
            this.objBMS_Deal_Content_Repository = new BMS_Deal_Content_Repository();
        }
        public BMS_Deal_Content GetByID(int? ID, Type[] RelationList = null)
        {
            return objBMS_Deal_Content_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BMS_Deal_Content> GetAll(Type[] RelationList = null)
        {
            return objBMS_Deal_Content_Repository.GetAll(RelationList);
        }
        public void AddEntity(BMS_Deal_Content obj)
        {
            objBMS_Deal_Content_Repository.Add(obj);
        }
        public void UpdateEntity(BMS_Deal_Content obj)
        {
            objBMS_Deal_Content_Repository.Update(obj);
        }
        public void DeleteEntity(BMS_Deal_Content obj)
        {
            objBMS_Deal_Content_Repository.Delete(obj);
        }
    }
    public class BMS_Deal_Content_Rights_Service
    {
        BMS_Deal_Content_Rights_Repository objBMS_Deal_Content_Rights_Repository = new BMS_Deal_Content_Rights_Repository();
        public BMS_Deal_Content_Rights_Service()
        {
            this.objBMS_Deal_Content_Rights_Repository = new BMS_Deal_Content_Rights_Repository();
        }
        public BMS_Deal_Content_Rights GetByID(int? ID, Type[] RelationList = null)
        {
            return objBMS_Deal_Content_Rights_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BMS_Deal_Content_Rights> GetAll(Type[] RelationList = null)
        {
            return objBMS_Deal_Content_Rights_Repository.GetAll(RelationList);
        }
        public void AddEntity(BMS_Deal_Content_Rights obj)
        {
            objBMS_Deal_Content_Rights_Repository.Add(obj);
        }
        public void UpdateEntity(BMS_Deal_Content_Rights obj)
        {
            objBMS_Deal_Content_Rights_Repository.Update(obj);
        }
        public void DeleteEntity(BMS_Deal_Content_Rights obj)
        {
            objBMS_Deal_Content_Rights_Repository.Delete(obj);
        }
    }
    public class BMS_Deal_Service
    {
        BMS_Deal_Repository objBMS_Deal_Repository = new BMS_Deal_Repository();
        public BMS_Deal_Service()
        {
            this.objBMS_Deal_Repository = new BMS_Deal_Repository();
        }
        public BMS_Deal GetByID(int? ID, Type[] RelationList = null)
        {
            return objBMS_Deal_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BMS_Deal> GetAll(Type[] RelationList = null)
        {
            return objBMS_Deal_Repository.GetAll(RelationList);
        }
        public void AddEntity(BMS_Deal obj)
        {
            objBMS_Deal_Repository.Add(obj);
        }
        public void UpdateEntity(BMS_Deal obj)
        {
            objBMS_Deal_Repository.Update(obj);
        }
        public void DeleteEntity(BMS_Deal obj)
        {
            objBMS_Deal_Repository.Delete(obj);
        }
    }
    public class Music_Language_Service
    {
        Music_Language_Repository objMusic_Language_Repository = new Music_Language_Repository();
        public Music_Language_Service()
        {
            this.objMusic_Language_Repository = new Music_Language_Repository();
        }
        public Music_Language GetByID(int? ID, Type[] RelationList = null)
        {
            return objMusic_Language_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Music_Language> GetAll(Type[] RelationList = null)
        {
            return objMusic_Language_Repository.GetAll(RelationList);
        }
        public void AddEntity(Music_Language obj)
        {
            objMusic_Language_Repository.Add(obj);
        }
        public void UpdateEntity(Music_Language obj)
        {
            objMusic_Language_Repository.Update(obj);
        }
        public void DeleteEntity(Music_Language obj)
        {
            objMusic_Language_Repository.Delete(obj);
        }
    }
}




