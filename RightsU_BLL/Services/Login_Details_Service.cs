using System;
using System.Linq;
using System.Linq.Expressions;
using RightsU_BLL;
using RightsU_DAL;
using RightsU_Entities;

namespace RightsU_BLL
{

    public class Login_Details_Service : BusinessLogic<Login_Details>
    {
        private readonly Login_Details_Repository objULDR;
        //public Login_Details_Service()
        //{
        //    this.objULDR = new Login_Details_Repository(DBConnection.Connection_Str);
        //}
        public Login_Details_Service(string Connection_Str)
        {
            this.objULDR = new Login_Details_Repository(Connection_Str);
        }
        public IQueryable<Login_Details> SearchFor(Expression<Func<Login_Details, bool>> predicate)
        {
            return objULDR.SearchFor(predicate);
        }

        public Login_Details GetById(int id)
        {
            return objULDR.GetById(id);
        }

        public override bool Validate(Login_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
            // throw new NotImplementedException();
        }

        public override bool ValidateUpdate(Login_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
            //throw new NotImplementedException();
        }

        public override bool ValidateDelete(Login_Details objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }
        public bool Save(Login_Details objLD, out dynamic resultSet)
        {
            return base.Save(objLD, objULDR, out resultSet);
        }
        public bool Update(Login_Details objLD, out dynamic resultSet)
        {
            return base.Update(objLD, objULDR, out resultSet);
        }
    }
}
