using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using RightsU_DAL;
using RightsU_Entities;

namespace RightsU_BLL
{
    public class System_Module_Service : BusinessLogic<System_Module>
    {
        private readonly System_Module_Repository objRepository;
        //public System_Module_Service()
        //{
        //    this.objRepository = new System_Module_Repository(DBConnection.Connection_Str);
        //}
        public System_Module_Service(string Connection_Str)
        {
            this.objRepository = new System_Module_Repository(Connection_Str);
        }
        public IQueryable<System_Module> SearchFor(Expression<Func<System_Module, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public bool Save(System_Module objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(System_Module objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(System_Module objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public System_Module GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public override bool Validate(System_Module objToValidate, out dynamic resultSet)
        {
            resultSet = null;
            return true;
        }

        public override bool ValidateUpdate(System_Module objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(System_Module objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class System_Module_Right_Service : BusinessLogic<System_Module_Right>
    {
        private readonly System_Module_Right_Repository objRepository;
        //public System_Module_Right_Service()
        //{
        //    this.objRepository = new System_Module_Right_Repository(DBConnection.Connection_Str);
        //}
        public System_Module_Right_Service(string Connection_Str)
        {
            this.objRepository = new System_Module_Right_Repository(Connection_Str);
        }
        public IQueryable<System_Module_Right> SearchFor(Expression<Func<System_Module_Right, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public System_Module_Right GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public bool Save(System_Module_Right objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(System_Module_Right objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(System_Module_Right objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }
        public override bool Validate(System_Module_Right objToValidate, out dynamic resultSet)
        {
            resultSet = null;
            return true;
        }

        public override bool ValidateUpdate(System_Module_Right objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(System_Module_Right objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Security_Group_Service : BusinessLogic<Security_Group>
    {
        private readonly Security_Group_Repository objRepository;
        //public Security_Group_Service()
        //{
        //    this.objRepository = new Security_Group_Repository(DBConnection.Connection_Str);
        //}
        public Security_Group_Service(string Connection_Str)
        {
            this.objRepository = new Security_Group_Repository(Connection_Str);
        }
        public IQueryable<Security_Group> SearchFor(Expression<Func<Security_Group, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Security_Group GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Security_Group objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Security_Group objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Security_Group objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }
        public override bool Validate(Security_Group objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Security_Group objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Security_Group objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Security_Group objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Security_Group_Name == objToValidate.Security_Group_Name && s.Security_Group_Code != objToValidate.Security_Group_Code).Count() > 0)
            {
                resultSet = "Security group already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }

    public class Security_Group_Rel_Service : BusinessLogic<Security_Group_Rel>
    {
        private readonly Security_Group_Rel_Repository objRepository;
        //public Security_Group_Rel_Service()
        //{
        //    this.objRepository = new Security_Group_Rel_Repository(DBConnection.Connection_Str);
        //}
        public Security_Group_Rel_Service(string Connection_Str)
        {
            this.objRepository = new Security_Group_Rel_Repository(Connection_Str);
        }
        public IQueryable<Security_Group_Rel> SearchFor(Expression<Func<Security_Group_Rel, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Security_Group_Rel GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Security_Group_Rel objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Security_Group_Rel objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Security_Group_Rel objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Security_Group_Rel objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Security_Group_Rel objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Security_Group_Rel objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }
        private bool ValidateDuplicate(Security_Group_Rel objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Security_Group == objToValidate.Security_Group && s.Security_Group_Code != objToValidate.Security_Group_Code).Count() > 0)
            {
                resultSet = "Security Group already exists";
                return false;
            }
            resultSet = "";
            return true;
        }

    }

    public class System_Right_Service : BusinessLogic<System_Right>
    {
        private readonly System_Right_Repository objRepository;
        //public System_Right_Service()
        //{
        //    this.objRepository = new System_Right_Repository(DBConnection.Connection_Str);
        //}
        public System_Right_Service(string Connection_Str)
        {
            this.objRepository = new System_Right_Repository(Connection_Str);
        }
        public IQueryable<System_Right> SearchFor(Expression<Func<System_Right, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public System_Right GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(System_Right objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(System_Right objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(System_Right objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(System_Right objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(System_Right objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(System_Right objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }
        private bool ValidateDuplicate(System_Right objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Right_Name == objToValidate.Right_Name && s.Right_Code != objToValidate.Right_Code).Count() > 0)
            {
                resultSet = "Right already exists";
                return false;
            }
            resultSet = "";
            return true;
        }
    }

    public class System_Module_Message_Service : BusinessLogic<System_Module_Message>
    {
        private readonly System_Module_Message_Repository objRepository;
        //public System_Module_Message_Service()
        //{
        //    this.objRepository = new System_Module_Message_Repository(DBConnection.Connection_Str);
        //}
        public System_Module_Message_Service(string Connection_Str)
        {
            this.objRepository = new System_Module_Message_Repository(Connection_Str);
        }
        public IQueryable<System_Module_Message> SearchFor(Expression<Func<System_Module_Message, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public bool Save(System_Module_Message objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(System_Module_Message objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(System_Module_Message objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public System_Module_Message GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public override bool Validate(System_Module_Message objToValidate, out dynamic resultSet)
        {
            resultSet = null;
            return true;
        }

        public override bool ValidateUpdate(System_Module_Message objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(System_Module_Message objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

}
