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
    public class MHRequest_Service : BusinessLogic<MHRequest>
    {
        private readonly MHRequest_Repository objRepository;

        public MHRequest_Service(string Connection_Str)
        {
            this.objRepository = new MHRequest_Repository(Connection_Str);
        }
        public IQueryable<MHRequest> SearchFor(Expression<Func<MHRequest, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public MHRequest GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(MHRequest objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(MHRequest objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(MHRequest objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(MHRequest objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(MHRequest objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(MHRequest objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        private bool ValidateDuplicate(MHRequest objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class MHRequestDetails_Service : BusinessLogic<MHRequestDetail>
    {
        private readonly MHRequestDetail_Repository objRepository;
        
        public MHRequestDetails_Service(string Connection_Str)
        {
            this.objRepository = new MHRequestDetail_Repository(Connection_Str);
        }
        public IQueryable<MHRequestDetail> SearchFor(Expression<Func<MHRequestDetail, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public MHRequestDetail GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(MHRequestDetail objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(MHRequestDetail objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(MHRequestDetail objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(MHRequestDetail objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(MHRequestDetail objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(MHRequestDetail objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        private bool ValidateDuplicate(MHRequestDetail objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class MHCueSheet_Service : BusinessLogic<MHCueSheet>
    {
        private readonly MHCueSheet_Repository objRepository;

        public MHCueSheet_Service(string Connection_Str)
        {
            this.objRepository = new MHCueSheet_Repository(Connection_Str);
        }
        public IQueryable<MHCueSheet> SearchFor(Expression<Func<MHCueSheet, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public MHCueSheet GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(MHCueSheet objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(MHCueSheet objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(MHCueSheet objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(MHCueSheet objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(MHCueSheet objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(MHCueSheet objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(MHCueSheet objToValidate, out dynamic resultSet)
        { 
            resultSet = "";
            return true;
        }
    }

    public class MHCueSheetSong_Service : BusinessLogic<MHCueSheetSong>
    {
        private readonly MHCueSheetSongs_Repository objRepository;

        public MHCueSheetSong_Service(string Connection_Str)
        {
            this.objRepository = new MHCueSheetSongs_Repository(Connection_Str);
        }
        public IQueryable<MHCueSheetSong> SearchFor(Expression<Func<MHCueSheetSong, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public MHCueSheetSong GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(MHCueSheetSong objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(MHCueSheetSong objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(MHCueSheetSong objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(MHCueSheetSong objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(MHCueSheetSong objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(MHCueSheetSong objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }
    public class MHRequestStatu_Service : BusinessLogic<MHRequestStatu>
    {
        private readonly MHRequestStatu_Repository objRepository;

        public MHRequestStatu_Service(string Connection_Str)
        {
            this.objRepository = new MHRequestStatu_Repository(Connection_Str);
        }
        public IQueryable<MHRequestStatu> SearchFor(Expression<Func<MHRequestStatu, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public MHRequestStatu GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(MHRequestStatu objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(MHRequestStatu objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(MHRequestStatu objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(MHRequestStatu objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(MHRequestStatu objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(MHRequestStatu objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }

     public class MHUser_Service : BusinessLogic<MHUser>
    {
        private readonly MHUser_Repository objRepository;

        public MHUser_Service(string Connection_Str)
        {
            this.objRepository = new MHUser_Repository(Connection_Str);
        }
        public IQueryable<MHUser> SearchFor(Expression<Func<MHUser, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public MHUser GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public override bool Validate(MHUser objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(MHUser objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(MHUser objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }

}

