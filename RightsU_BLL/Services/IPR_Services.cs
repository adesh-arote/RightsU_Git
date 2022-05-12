using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RightsU_DAL;
using System.Linq.Expressions;
using RightsU_Entities;

namespace RightsU_BLL
{
    public class IPR_TYPE_Service : BusinessLogic<IPR_TYPE>
    {
        private readonly IPR_TYPE_Repository objIPRTR;
        //public IPR_TYPE_Service()
        //{
        //    this.objIPRTR = new IPR_TYPE_Repository(DBConnection.Connection_Str);
        //}
        public IPR_TYPE_Service(string Connection_Str)
        {
            this.objIPRTR = new IPR_TYPE_Repository(Connection_Str);
        }
        public IQueryable<IPR_TYPE> SearchFor(Expression<Func<IPR_TYPE, bool>> predicate)
        {
            return objIPRTR.SearchFor(predicate);
        }

        public IPR_TYPE GetById(int id)
        {
            return objIPRTR.GetById(id);
        }

        public override bool Validate(IPR_TYPE objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUpdate(IPR_TYPE objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateDelete(IPR_TYPE objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }
    }
    public class IPR_APP_STATUS_Service : BusinessLogic<IPR_APP_STATUS>
    {
        private readonly IPR_APP_STATUS_Repository objIPRASR;
        //public IPR_APP_STATUS_Service()
        //{
        //    this.objIPRASR = new IPR_APP_STATUS_Repository(DBConnection.Connection_Str);
        //}
        public IPR_APP_STATUS_Service(string Connection_Str)
        {
            this.objIPRASR = new IPR_APP_STATUS_Repository(Connection_Str);
        }
        public IQueryable<IPR_APP_STATUS> SearchFor(Expression<Func<IPR_APP_STATUS, bool>> predicate)
        {
            return objIPRASR.SearchFor(predicate);
        }

        public IPR_APP_STATUS GetById(int id)
        {
            return objIPRASR.GetById(id);
        }

        public override bool Validate(IPR_APP_STATUS objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUpdate(IPR_APP_STATUS objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateDelete(IPR_APP_STATUS objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }
    }
    public class IPR_CLASS_Service : BusinessLogic<IPR_CLASS>
    {
        private readonly IPR_CLASS_Repository objIPRCR;
        //public IPR_CLASS_Service()
        //{
        //    this.objIPRCR = new IPR_CLASS_Repository(DBConnection.Connection_Str);
        //}
        public IPR_CLASS_Service(string Connection_Str)
        {
            this.objIPRCR = new IPR_CLASS_Repository(Connection_Str);
        }
        public IQueryable<IPR_CLASS> SearchFor(Expression<Func<IPR_CLASS, bool>> predicate)
        {
            return objIPRCR.SearchFor(predicate);
        }

        public IPR_CLASS GetById(int id)
        {
            return objIPRCR.GetById(id);
        }

        public override bool Validate(IPR_CLASS objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUpdate(IPR_CLASS objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateDelete(IPR_CLASS objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }
    }


    public class IPR_Country_Service : BusinessLogic<IPR_Country>
    {
        private readonly IPR_Country_Repository objRepository;
        //public IPR_Country_Service()
        //{
        //    this.objRepository = new IPR_Country_Repository(DBConnection.Connection_Str);
        //}
        public IPR_Country_Service(string Connection_Str)
        {
            this.objRepository = new IPR_Country_Repository(Connection_Str);
        }
        public IQueryable<IPR_Country> SearchFor(Expression<Func<IPR_Country, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public IPR_Country GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(IPR_Country objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(IPR_Country objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(IPR_Country objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(IPR_Country objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(IPR_Country objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(IPR_Country objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(IPR_Country objToValidate, out dynamic resultSet)
        {
            if (objToValidate.EntityState != State.Deleted)
            {
                int duplicateRecordCount = SearchFor(s => s.IPR_Country_Name.ToUpper() == objToValidate.IPR_Country_Name.ToUpper() &&
                    s.IPR_Country_Code != objToValidate.IPR_Country_Code).Count();

                if (duplicateRecordCount > 0)
                {
                    resultSet = "IPR Country Name already exists";
                    return false;
                }
            }

            resultSet = "";
            return true;
        }
    }




    public class IPR_ENTITY_Service : BusinessLogic<IPR_ENTITY>
    {
        private readonly IPR_ENTITY_Repository objIPRER;
        //public IPR_ENTITY_Service()
        //{
        //    this.objIPRER = new IPR_ENTITY_Repository(DBConnection.Connection_Str);
        //}
        public IPR_ENTITY_Service(string Connection_Str)
        {
            this.objIPRER = new IPR_ENTITY_Repository(Connection_Str);
        }
        public IQueryable<IPR_ENTITY> SearchFor(Expression<Func<IPR_ENTITY, bool>> predicate)
        {
            return objIPRER.SearchFor(predicate);
        }

        public IPR_ENTITY GetById(int id)
        {
            return objIPRER.GetById(id);
        }

        public override bool Validate(IPR_ENTITY objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUpdate(IPR_ENTITY objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateDelete(IPR_ENTITY objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }
    }
    public class IPR_REP_Service : BusinessLogic<IPR_REP>
    {
        private readonly IPR_REP_Repository objIPRRR;
        //public IPR_REP_Service()
        //{
        //    this.objIPRRR = new IPR_REP_Repository(DBConnection.Connection_Str);
        //}
        public IPR_REP_Service(string Connection_Str)
        {
            this.objIPRRR = new IPR_REP_Repository(Connection_Str);
        }
        public IQueryable<IPR_REP> SearchFor(Expression<Func<IPR_REP, bool>> predicate)
        {
            return objIPRRR.SearchFor(predicate);
        }

        public IPR_REP GetById(int id)
        {
            return objIPRRR.GetById(id);
        }

        public bool Save(IPR_REP objIPRR, out dynamic resultSet)
        {
            return base.Save(objIPRR, objIPRRR, out resultSet);
        }

        public bool Update(IPR_REP objIPRR, out dynamic resultSet)
        {
            return base.Update(objIPRR, objIPRRR, out resultSet);
        }

        public bool Delete(IPR_REP objIPRR, out dynamic resultSet)
        {
            return base.Delete(objIPRR, objIPRRR, out resultSet);
        }

        public override bool Validate(IPR_REP objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(IPR_REP objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(IPR_REP objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class IPR_REP_Class_Service : BusinessLogic<IPR_REP_CLASS>
    {
        private readonly IPR_REP_CLass_Repository objIPRRR;
        //public IPR_REP_Service()
        //{
        //    this.objIPRRR = new IPR_REP_Repository(DBConnection.Connection_Str);
        //}
        public IPR_REP_Class_Service(string Connection_Str)
        {
            this.objIPRRR = new IPR_REP_CLass_Repository(Connection_Str);
        }
        public IQueryable<IPR_REP_CLASS> SearchFor(Expression<Func<IPR_REP_CLASS, bool>> predicate)
        {
            return objIPRRR.SearchFor(predicate);
        }

        public IPR_REP_CLASS GetById(int id)
        {
            return objIPRRR.GetById(id);
        }

        public bool Save(IPR_REP_CLASS objIPRR, out dynamic resultSet)
        {
            return base.Save(objIPRR, objIPRRR, out resultSet);
        }

        public bool Update(IPR_REP_CLASS objIPRR, out dynamic resultSet)
        {
            return base.Update(objIPRR, objIPRRR, out resultSet);
        }

        public bool Delete(IPR_REP_CLASS objIPRR, out dynamic resultSet)
        {
            return base.Delete(objIPRR, objIPRRR, out resultSet);
        }

        public override bool Validate(IPR_REP_CLASS objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(IPR_REP_CLASS objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(IPR_REP_CLASS objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class IPR_Opp_Service : BusinessLogic<IPR_Opp>
    {
        private readonly IPR_Opp_Repository objRepository;
        //public IPR_Opp_Service()
        //{
        //    this.objRepository = new IPR_Opp_Repository(DBConnection.Connection_Str);
        //}
        public IPR_Opp_Service(string Connection_Str)
        {
            this.objRepository = new IPR_Opp_Repository(Connection_Str);
        }
        public IQueryable<IPR_Opp> SearchFor(Expression<Func<IPR_Opp, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public IPR_Opp GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(IPR_Opp objIPR_Opp, out dynamic resultSet)
        {
            return base.Save(objIPR_Opp, objRepository, out resultSet);
        }

        public bool Update(IPR_Opp objIPR_Opp, out dynamic resultSet)
        {
            return base.Update(objIPR_Opp, objRepository, out resultSet);
        }

        public bool Delete(IPR_Opp objIPR_Opp, out dynamic resultSet)
        {
            return base.Delete(objIPR_Opp, objRepository, out resultSet);
        }

        public override bool Validate(IPR_Opp objToValidate, out dynamic resultSet)
        {
            return ValidateDupliacte(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(IPR_Opp objToValidate, out dynamic resultSet)
        {
            return ValidateDupliacte(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(IPR_Opp objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDupliacte(IPR_Opp objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            int count = this.SearchFor(s => s.IPR_For.ToUpper() == objToValidate.IPR_For.ToUpper() && s.Opp_No.ToUpper() == objToValidate.Opp_No.ToUpper()
                && s.IPR_Opp_Code != objToValidate.IPR_Opp_Code).Count();
            if (count > 0)
            {
                resultSet = "Opposition number cannot be duplicate";
                return false;
            }

            return true;
        }
    }
    public class IPR_Opp_Status_Service : BusinessLogic<IPR_Opp_Status>
    {
        private readonly IPR_Opp_Status_Repository objRepository;
        //public IPR_Opp_Status_Service()
        //{
        //    this.objRepository = new IPR_Opp_Status_Repository(DBConnection.Connection_Str);
        //}
        public IPR_Opp_Status_Service(string Connection_Str)
        {
            this.objRepository = new IPR_Opp_Status_Repository(Connection_Str);
        }
        public IQueryable<IPR_Opp_Status> SearchFor(Expression<Func<IPR_Opp_Status, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public IPR_Opp_Status GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public override bool Validate(IPR_Opp_Status objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(IPR_Opp_Status objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(IPR_Opp_Status objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
}
