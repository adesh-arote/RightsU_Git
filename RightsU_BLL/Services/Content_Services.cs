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
    public class Title_Content_Service : BusinessLogic<Title_Content>
    {
        private readonly Title_Content_Repository objRepository;
        //public Title_Content_Service()
        //{
        //    this.objRepository = new Title_Content_Repository(DBConnection.Connection_Str);
        //}
        public Title_Content_Service(string Connection_Str)
        {
            this.objRepository = new Title_Content_Repository(Connection_Str);
        }
        public IQueryable<Title_Content> SearchFor(Expression<Func<Title_Content, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Title_Content GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Title_Content objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Title_Content objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Title_Content objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Title_Content objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Title_Content objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Title_Content objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Title_Content_Version_Service : BusinessLogic<Title_Content_Version>
    {
        private readonly Title_Content_Version_Repository objRepository;
        //public Title_Content_Version_Service()
        //{
        //    this.objRepository = new Title_Content_Version_Repository(DBConnection.Connection_Str);
        //}
        public Title_Content_Version_Service(string Connection_Str)
        {
            this.objRepository = new Title_Content_Version_Repository(Connection_Str);
        }
        public IQueryable<Title_Content_Version> SearchFor(Expression<Func<Title_Content_Version, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Title_Content_Version GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Title_Content_Version objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Title_Content_Version objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Title_Content_Version objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Title_Content_Version objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Title_Content_Version objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Title_Content_Version objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Title_Content_Version objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            int count = this.SearchFor(w => w.Version_Code == objToValidate.Version_Code && w.Title_Content_Code == objToValidate.Title_Content_Code && w.Title_Content_Version_Code != objToValidate.Title_Content_Version_Code).Count();
            if(count > 0)
            {
                resultSet = "Version already exists";
                return false;
            }

            return true;
        }
    }
    public class Title_Content_Mapping_Service : BusinessLogic<Title_Content_Mapping>
    {
        private readonly Title_Content_Mapping_Repository objRepository;
        //public Title_Content_Mapping_Service()
        //{
        //    this.objRepository = new Title_Content_Mapping_Repository(DBConnection.Connection_Str);
        //}
        public Title_Content_Mapping_Service(string Connection_Str)
        {
            this.objRepository = new Title_Content_Mapping_Repository(Connection_Str);
        }
        public IQueryable<Title_Content_Mapping> SearchFor(Expression<Func<Title_Content_Mapping, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Title_Content_Mapping GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Title_Content_Mapping objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Title_Content_Mapping objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Title_Content_Mapping objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Title_Content_Mapping objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Title_Content_Mapping objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Title_Content_Mapping objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Content_Music_Link_Service : BusinessLogic<Content_Music_Link>
    {
        private readonly Content_Music_Link_Repository objRepository;
        //public Content_Music_Link_Service()
        //{
        //    this.objRepository = new Content_Music_Link_Repository(DBConnection.Connection_Str);
        //}
        public Content_Music_Link_Service(string Connection_Str)
        {
            this.objRepository = new Content_Music_Link_Repository(Connection_Str);
        }
        public IQueryable<Content_Music_Link> SearchFor(Expression<Func<Content_Music_Link, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Content_Music_Link GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Content_Music_Link objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Content_Music_Link objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Content_Music_Link objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Content_Music_Link objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Content_Music_Link objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Content_Music_Link objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Content_Status_History_Service : BusinessLogic<Content_Status_History>
    {
        private readonly Content_Status_History_Repository objRepository;
        //public Content_Status_History_Service()
        //{
        //    this.objRepository = new Content_Status_History_Repository(DBConnection.Connection_Str);
        //}
        public Content_Status_History_Service(string Connection_Str)
        {
            this.objRepository = new Content_Status_History_Repository(Connection_Str);
        }
        public IQueryable<Content_Status_History> SearchFor(Expression<Func<Content_Status_History, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Content_Status_History GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Content_Status_History objIPRR, out dynamic resultSet)
        {
            return base.Save(objIPRR, objRepository, out resultSet);
        }

        public bool Update(Content_Status_History objIPRR, out dynamic resultSet)
        {
            return base.Update(objIPRR, objRepository, out resultSet);
        }

        public bool Delete(Content_Status_History objIPRR, out dynamic resultSet)
        {
            return base.Delete(objIPRR, objRepository, out resultSet);
        }

        public override bool Validate(Content_Status_History objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Content_Status_History objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Content_Status_History objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Music_Override_Reason_Service : BusinessLogic<Music_Override_Reason>
    {
        private readonly Music_Override_Reason_Repository objRepository;

        //public Music_Override_Reason_Service()
        //{
        //    this.objRepository = new Music_Override_Reason_Repository(DBConnection.Connection_Str);
        //}
        public Music_Override_Reason_Service(string Connection_Str)
        {
            this.objRepository = new Music_Override_Reason_Repository(Connection_Str);
        }
        public IQueryable<Music_Override_Reason> SearchFor(Expression<Func<Music_Override_Reason, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Override_Reason GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Music_Override_Reason objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Music_Override_Reason objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Music_Override_Reason objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Override_Reason objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Music_Schedule_Exception_Service : BusinessLogic<Music_Schedule_Exception>
    {
        private readonly Music_Schedule_Exception_Repository objRepository;

        //public Music_Schedule_Exception_Service()
        //{
        //    this.objRepository = new Music_Schedule_Exception_Repository(DBConnection.Connection_Str);
        //}
        public Music_Schedule_Exception_Service(string Connection_Str)
        {
            this.objRepository = new Music_Schedule_Exception_Repository(Connection_Str);
        }
        public IQueryable<Music_Schedule_Exception> SearchFor(Expression<Func<Music_Schedule_Exception, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Schedule_Exception GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Music_Schedule_Exception objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Music_Schedule_Exception objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Music_Schedule_Exception objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Schedule_Exception objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Music_Schedule_Transaction_Service : BusinessLogic<Music_Schedule_Transaction>
    {
        private readonly Music_Schedule_Transaction_Repository objRepository;

        //public Music_Schedule_Transaction_Service()
        //{
        //    this.objRepository = new Music_Schedule_Transaction_Repository(DBConnection.Connection_Str);
        //}
        public Music_Schedule_Transaction_Service(string Connection_Str)
        {
            this.objRepository = new Music_Schedule_Transaction_Repository(Connection_Str);
        }
        public IQueryable<Music_Schedule_Transaction> SearchFor(Expression<Func<Music_Schedule_Transaction, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Schedule_Transaction GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Music_Schedule_Transaction objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Music_Schedule_Transaction objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Music_Schedule_Transaction objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Schedule_Transaction objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Title_Content_Version_Details_Service : BusinessLogic<Title_Content_Version_Details>
    {
        private readonly Title_Content_Version_Details_Repository objRepository;
        public Title_Content_Version_Details_Service(string Connection_Str)
        {
            this.objRepository = new Title_Content_Version_Details_Repository(Connection_Str);
        }
        public IQueryable<Title_Content_Version_Details> SearchFor(Expression<Func<Title_Content_Version_Details, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Title_Content_Version_Details GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Title_Content_Version_Details objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Title_Content_Version_Details objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Title_Content_Version_Details objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Title_Content_Version_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Title_Content_Version_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Title_Content_Version_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Title_Content_Material_Service : BusinessLogic<Title_Content_Material>
    {
        private readonly Title_Content_Material_Repository objRepository;
        public Title_Content_Material_Service(string Connection_Str)
        {
            this.objRepository = new Title_Content_Material_Repository(Connection_Str);
        }
        public IQueryable<Title_Content_Material> SearchFor(Expression<Func<Title_Content_Material, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Title_Content_Material GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Title_Content_Material objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Title_Content_Material objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Title_Content_Material objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Title_Content_Material objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Title_Content_Material objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Title_Content_Material objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Title_Content_Material objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            int count = this.SearchFor(w => w.Title_Content_Code == objToValidate.Title_Content_Code && w.Material_Medium_Code == objToValidate.Material_Medium_Code && w.Title_Content_Matreial_Code != objToValidate.Title_Content_Matreial_Code).Count();
            if (count > 0)
            {
                resultSet = "Material already exists";
                return false;
            }

            return true;
        }
    }
}
