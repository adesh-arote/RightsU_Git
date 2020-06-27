using RightsU_DAL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_BLL
{
    public class Music_Deal_Service : BusinessLogic<Music_Deal>
    {
        private readonly Music_Deal_Repository objRepository;

        //public Music_Deal_Service()
        //{
        //    this.objRepository = new Music_Deal_Repository(DBConnection.Connection_Str);
        //}
        public Music_Deal_Service(string Connection_Str)
        {
            this.objRepository = new Music_Deal_Repository(Connection_Str);
        }

        public IQueryable<Music_Deal> SearchFor(Expression<Func<Music_Deal, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public bool Save(Music_Deal objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Music_Deal objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Music_Deal objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public Music_Deal GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public override bool Validate(Music_Deal objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Music_Deal objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Deal objToValidate, out dynamic resultSet)
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

    public class Music_Platform_Service
    {
        private readonly Music_Platform_Repository objRepository;

        //public Music_Deal_Service()
        //{
        //    this.objRepository = new Music_Deal_Repository(DBConnection.Connection_Str);
        //}
        public Music_Platform_Service(string Connection_Str)
        {
            this.objRepository = new Music_Platform_Repository(Connection_Str);
        }

        public IQueryable<Music_Platform> SearchFor(Expression<Func<Music_Platform, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Platform GetById(int id)
        {
            return objRepository.GetById(id);
        }
    }

 

    public class Music_Deal_Channel_Service : BusinessLogic<Music_Deal_Channel>
    {
        private readonly Music_Deal_Channel_Repository objRepository;

        //public Music_Deal_Channel_Service()
        //{
        //    this.objRepository = new Music_Deal_Channel_Repository(DBConnection.Connection_Str);
        //}
        public Music_Deal_Channel_Service(string Connection_Str)
        {
            this.objRepository = new Music_Deal_Channel_Repository(Connection_Str);
        }

        public IQueryable<Music_Deal_Channel> SearchFor(Expression<Func<Music_Deal_Channel, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Deal_Channel GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public override bool Validate(Music_Deal_Channel objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Music_Deal_Channel objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Deal_Channel objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Music_Deal_Country_Service : BusinessLogic<Music_Deal_Country>
    {
        private readonly Music_Deal_Country_Repository objRepository;

        //public Music_Deal_Country_Service()
        //{
        //    this.objRepository = new Music_Deal_Country_Repository(DBConnection.Connection_Str);
        //}
        public Music_Deal_Country_Service(string Connection_Str)
        {
            this.objRepository = new Music_Deal_Country_Repository(Connection_Str);
        }

        public IQueryable<Music_Deal_Country> SearchFor(Expression<Func<Music_Deal_Country, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Deal_Country GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public override bool Validate(Music_Deal_Country objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Music_Deal_Country objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Deal_Country objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Music_Deal_Language_Service : BusinessLogic<Music_Deal_Language>
    {
        private readonly Music_Deal_Language_Repository objRepository;

        //public Music_Deal_Language_Service()
        //{
        //    this.objRepository = new Music_Deal_Language_Repository(DBConnection.Connection_Str);
        //}
        public Music_Deal_Language_Service(string Connection_Str)
        {
            this.objRepository = new Music_Deal_Language_Repository(Connection_Str);
        }
        public IQueryable<Music_Deal_Language> SearchFor(Expression<Func<Music_Deal_Language, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Deal_Language GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public override bool Validate(Music_Deal_Language objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Music_Deal_Language objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Deal_Language objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Music_Deal_LinkShow_Service : BusinessLogic<Music_Deal_LinkShow>
    {
        private readonly Music_Deal_LinkShow_Repository objRepository;

        //public Music_Deal_LinkShow_Service()
        //{
        //    this.objRepository = new Music_Deal_LinkShow_Repository(DBConnection.Connection_Str);
        //}
        public Music_Deal_LinkShow_Service(string Connection_Str)
        {
            this.objRepository = new Music_Deal_LinkShow_Repository(Connection_Str);
        }
        public IQueryable<Music_Deal_LinkShow> SearchFor(Expression<Func<Music_Deal_LinkShow, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Deal_LinkShow GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public override bool Validate(Music_Deal_LinkShow objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Music_Deal_LinkShow objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Deal_LinkShow objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Music_Deal_Vendor_Service : BusinessLogic<Music_Deal_Vendor>
    {
        private readonly Music_Deal_Vendor_Repository objRepository;

        //public Music_Deal_Vendor_Service()
        //{
        //    this.objRepository = new Music_Deal_Vendor_Repository(DBConnection.Connection_Str);
        //}
        public Music_Deal_Vendor_Service(string Connection_Str)
        {
            this.objRepository = new Music_Deal_Vendor_Repository(Connection_Str);
        }
        public IQueryable<Music_Deal_Vendor> SearchFor(Expression<Func<Music_Deal_Vendor, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Deal_Vendor GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public override bool Validate(Music_Deal_Vendor objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Music_Deal_Vendor objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Deal_Vendor objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
}
