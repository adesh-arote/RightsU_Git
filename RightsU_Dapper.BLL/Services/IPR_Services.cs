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
}
