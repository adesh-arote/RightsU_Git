using RightsU_DAL;
using RightsU_DAL.Repository;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_BLL
{
    public class Provisional_Deal_Services : BusinessLogic<Provisional_Deal>
    {
        private readonly Provisional_Deal_Repositories objRepository;

        public Provisional_Deal_Services(string Connection_Str)
        {
            this.objRepository = new Provisional_Deal_Repositories(Connection_Str);
        }
        public IQueryable<Provisional_Deal> SearchFor(Expression<Func<Provisional_Deal, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }
        public bool Save(Provisional_Deal objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(Provisional_Deal objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }
        public bool Delete(Provisional_Deal objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }
        public Provisional_Deal GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public override bool Validate(Provisional_Deal objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Provisional_Deal objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateDelete(Provisional_Deal objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            bool returnVal = true;

            if (Convert.ToDecimal(objToValidate.Version) == 1)
            {
                if (objToValidate.Deal_Workflow_Status == "A" || objToValidate.Deal_Workflow_Status == "W")
                    returnVal = false;
            }
            else
                returnVal = false;

            if (!returnVal)
                resultSet = "Cannot delete this deal";

            return returnVal;
        }

    }

}
