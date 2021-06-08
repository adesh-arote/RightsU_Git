using RightsU_Dapper.Entity;
using RightsU_Dapper_DAL.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.BLL.Services
{
    public class IPR_Country_Service
    {
        IPR_Country_Repository objIPR_Country_Repository = new IPR_Country_Repository();
        public IPR_Country_Service()
        {
            this.objIPR_Country_Repository = new IPR_Country_Repository();
        }
        public IPR_Country GetByID(int? ID, Type[] RelationList = null)
        {
            return objIPR_Country_Repository.Get(ID, RelationList);
        }
        public IEnumerable<IPR_Country> GetAll(Type[] RelationList = null)
        {
            return objIPR_Country_Repository.GetAll(RelationList);
        }
        public void AddEntity(IPR_Country obj)
        {
            objIPR_Country_Repository.Add(obj);
        }
        public void UpdateEntity(IPR_Country obj)
        {
            objIPR_Country_Repository.Update(obj);
        }
        public void DeleteEntity(IPR_Country obj)
        {
            objIPR_Country_Repository.Delete(obj);
        }
        public bool Validate(IPR_Country objToValidate, out string resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }
        private bool ValidateDuplicate(IPR_Country objToValidate, out string resultSet)
        {
                int duplicateRecordCount = GetAll().Where(s => s.IPR_Country_Name.ToUpper() == objToValidate.IPR_Country_Name.ToUpper() &&
                    s.IPR_Country_Code != objToValidate.IPR_Country_Code).Count();

                if (duplicateRecordCount > 0)
                {
                    resultSet = "IPR Country Name already exists";
                    return false;
                }

            resultSet = "";
            return true;
        }
    }
    public class IPR_Opp_Service
    {
        IPR_Opp_Repository objIPR_Opp_Repository = new IPR_Opp_Repository();
        public IPR_Opp_Service()
        {
            this.objIPR_Opp_Repository = new IPR_Opp_Repository();
        }
        public IPR_Opp GetByID(int? ID, Type[] RelationList = null)
        {
            return objIPR_Opp_Repository.Get(ID, RelationList);
        }
        public IEnumerable<IPR_Opp> GetAll(Type[] RelationList = null)
        {
            return objIPR_Opp_Repository.GetAll(RelationList);
        }
        public void AddEntity(IPR_Opp obj)
        {
            objIPR_Opp_Repository.Add(obj);
        }
        public void UpdateEntity(IPR_Opp obj)
        {
            objIPR_Opp_Repository.Update(obj);
        }
        public void DeleteEntity(IPR_Opp obj)
        {
            objIPR_Opp_Repository.Delete(obj);
        }
    }
    public class IPR_APP_STATUS_Service
    {
        IPR_APP_STATUS_Repository objIPR_APP_STATUS_Repository = new IPR_APP_STATUS_Repository();
        public IPR_APP_STATUS_Service()
        {
            this.objIPR_APP_STATUS_Repository = new IPR_APP_STATUS_Repository();
        }
        public IPR_APP_STATUS GetByID(int? ID, Type[] RelationList = null)
        {
            return objIPR_APP_STATUS_Repository.Get(ID, RelationList);
        }
        public IEnumerable<IPR_APP_STATUS> GetAll(Type[] RelationList = null)
        {
            return objIPR_APP_STATUS_Repository.GetAll(RelationList);
        }
        public void AddEntity(IPR_APP_STATUS obj)
        {
            objIPR_APP_STATUS_Repository.Add(obj);
        }
        public void UpdateEntity(IPR_APP_STATUS obj)
        {
            objIPR_APP_STATUS_Repository.Update(obj);
        }
        public void DeleteEntity(IPR_APP_STATUS obj)
        {
            objIPR_APP_STATUS_Repository.Delete(obj);
        }
    }
    public class IPR_ENTITY_Service
    {
        IPR_ENTITY_Repository objIPR_ENTITY_Repository = new IPR_ENTITY_Repository();
        public IPR_ENTITY_Service()
        {
            this.objIPR_ENTITY_Repository = new IPR_ENTITY_Repository();
        }
        public IPR_ENTITY GetByID(int? ID, Type[] RelationList = null)
        {
            return objIPR_ENTITY_Repository.Get(ID, RelationList);
        }
        public IEnumerable<IPR_ENTITY> GetAll(Type[] RelationList = null)
        {
            return objIPR_ENTITY_Repository.GetAll(RelationList);
        }
        public void AddEntity(IPR_ENTITY obj)
        {
            objIPR_ENTITY_Repository.Add(obj);
        }
        public void UpdateEntity(IPR_ENTITY obj)
        {
            objIPR_ENTITY_Repository.Update(obj);
        }
        public void DeleteEntity(IPR_ENTITY obj)
        {
            objIPR_ENTITY_Repository.Delete(obj);
        }
    }
    public class IPR_Opp_Status_Service
    {
        IPR_Opp_Status_Repository objIPR_Opp_Status_Repository = new IPR_Opp_Status_Repository();
        public IPR_Opp_Status_Service()
        {
            this.objIPR_Opp_Status_Repository = new IPR_Opp_Status_Repository();
        }
        public IPR_Opp_Status GetByID(int? ID, Type[] RelationList = null)
        {
            return objIPR_Opp_Status_Repository.Get(ID, RelationList);
        }
        public IEnumerable<IPR_Opp_Status> GetAll(Type[] RelationList = null)
        {
            return objIPR_Opp_Status_Repository.GetAll(RelationList);
        }
        public void AddEntity(IPR_Opp_Status obj)
        {
            objIPR_Opp_Status_Repository.Add(obj);
        }
        public void UpdateEntity(IPR_Opp_Status obj)
        {
            objIPR_Opp_Status_Repository.Update(obj);
        }
        public void DeleteEntity(IPR_Opp_Status obj)
        {
            objIPR_Opp_Status_Repository.Delete(obj);
        }
    }
    public class IPR_TYPE_Service
    {
        IPR_TYPE_Repository objIPR_TYPE_Repository = new IPR_TYPE_Repository();
        public IPR_TYPE_Service()
        {
            this.objIPR_TYPE_Repository = new IPR_TYPE_Repository();
        }
        public IPR_TYPE GetByID(int? ID, Type[] RelationList = null)
        {
            return objIPR_TYPE_Repository.Get(ID, RelationList);
        }
        public IEnumerable<IPR_TYPE> GetAll(Type[] RelationList = null)
        {
            return objIPR_TYPE_Repository.GetAll(RelationList);
        }
        public void AddEntity(IPR_TYPE obj)
        {
            objIPR_TYPE_Repository.Add(obj);
        }
        public void UpdateEntity(IPR_TYPE obj)
        {
            objIPR_TYPE_Repository.Update(obj);
        }
        public void DeleteEntity(IPR_TYPE obj)
        {
            objIPR_TYPE_Repository.Delete(obj);
        }
    }
    public class USP_List_IPR_Service
    {
        USP_List_IPR_Result_Repository objUSP_Repository = new USP_List_IPR_Result_Repository();

        public USP_List_IPR_Service()
        {
            this.objUSP_Repository = new USP_List_IPR_Result_Repository();
        }
        public IEnumerable<USP_List_IPR_Result> USP_List_IPR(string tabName, string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, out int recordCount, Nullable<int> user_Code, Nullable<int> module_Code)
        {
            return objUSP_Repository.USP_List_IPR(tabName, strSearch, pageNo, orderByCndition, isPaging, pageSize, out recordCount, user_Code, module_Code);
        }
    }
    public class USP_List_IPR_Opp_Service
    {
        USP_List_IPR_Opp_Result_Repository objUSP_Repository = new USP_List_IPR_Opp_Result_Repository();

        public USP_List_IPR_Opp_Service()
        {
            this.objUSP_Repository = new USP_List_IPR_Opp_Result_Repository();
        }
        public IEnumerable<USP_List_IPR_Opp_Result> USP_List_IPR_Opp(string ipr_For, string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, out int recordCount, Nullable<int> user_Code, Nullable<int> module_Code)
        {
            return objUSP_Repository.USP_List_IPR_Opp(ipr_For, strSearch, pageNo, orderByCndition, isPaging, pageSize, out recordCount, user_Code, module_Code);
        }
    }
    public class IPR_REP_Service
    {
        IPR_REP_Repository objIPR_REP_Repository = new IPR_REP_Repository();
        public IPR_REP_Service()
        {
            this.objIPR_REP_Repository = new IPR_REP_Repository();
        }
        public IPR_REP GetByID(int? ID, Type[] RelationList = null)
        {
            return objIPR_REP_Repository.Get(ID, RelationList);
        }
        public IEnumerable<IPR_REP> GetAll(Type[] RelationList = null)
        {
            return objIPR_REP_Repository.GetAll(RelationList);
        }
        public void AddEntity(IPR_REP obj)
        {
            objIPR_REP_Repository.Add(obj);
        }
        public void UpdateEntity(IPR_REP obj)
        {
            objIPR_REP_Repository.Update(obj);
        }
        public void DeleteEntity(IPR_REP obj)
        {
            objIPR_REP_Repository.Delete(obj);
        }
    }
}
