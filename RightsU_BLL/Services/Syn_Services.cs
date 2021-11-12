using RightsU_DAL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;


namespace RightsU_BLL
{
    public class Syn_Deal_Service : BusinessLogic<Syn_Deal>
    {
        private readonly Syn_Deal_Repository objSDR;
        //public Syn_Deal_Service()
        //{
        //    this.objSDR = new Syn_Deal_Repository(DBConnection.Connection_Str);
        //}
        public Syn_Deal_Service(string Connection_Str)
        {
            this.objSDR = new Syn_Deal_Repository(Connection_Str);
        }
        public IQueryable<Syn_Deal> SearchFor(Expression<Func<Syn_Deal, bool>> predicate)
        {
            return objSDR.SearchFor(predicate);
        }

        public Syn_Deal GetById(int id)
        {
            return objSDR.GetById(id);
        }

        public bool Save(Syn_Deal objD, out dynamic resultSet)
        {
            return base.Save(objD, objSDR, out resultSet);
        }

        public bool Update(Syn_Deal objD, out dynamic resultSet)
        {
            return base.Update(objD, objSDR, out resultSet);
        }

        public bool Delete(Syn_Deal objD, out dynamic resultSet)
        {
            return base.Delete(objD, objSDR, out resultSet);
        }

        public override bool Validate(Syn_Deal objToValidate, out dynamic resultSet)
        {
            resultSet = null;
            //if (!objToValidate.SaveGeneralOnly)
            //{
            //    USP_Service objValidateService = new USP_Service();
            //    foreach (Syn_Deal_Rights objADP in objToValidate.Syn_Deal_Rights)
            //    {
            //        if (objADP.LstDeal_Rights_UDT.Count > 0)
            //        {
            //            IEnumerable<USP_Validate_Rights_Duplication_UDT> objResult = objValidateService.USP_Validate_Rights_Duplication_UDT(
            //               objADP.LstDeal_Rights_UDT,
            //               objADP.LstDeal_Rights_Title_UDT,
            //               objADP.LstDeal_Rights_Platform_UDT,
            //               objADP.LstDeal_Rights_Territory_UDT,
            //               objADP.LstDeal_Rights_Subtitling_UDT,
            //               objADP.LstDeal_Rights_Dubbing_UDT,
            //               "SR"
            //               );

            //            resultSet = objResult;
            //            return !(objResult.Count() > 0);
            //        }
            //    }
            //}
            return true;
        }

        public override bool ValidateUpdate(Syn_Deal objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Syn_Deal objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Syn_Deal_Movie_Service : BusinessLogic<Syn_Deal_Movie>
    {
        private readonly Syn_Deal_Movie_Repository objSDMR;
        //public Syn_Deal_Movie_Service()
        //{
        //    this.objSDMR = new Syn_Deal_Movie_Repository(DBConnection.Connection_Str);
        //}
        public Syn_Deal_Movie_Service(string Connection_Str)
        {
            this.objSDMR = new Syn_Deal_Movie_Repository(Connection_Str);
        }
        public IQueryable<Syn_Deal_Movie> SearchFor(Expression<Func<Syn_Deal_Movie, bool>> predicate)
        {
            return objSDMR.SearchFor(predicate);
        }

        public Syn_Deal_Movie GetById(int id)
        {
            return objSDMR.GetById(id);
        }


        public override bool Validate(Syn_Deal_Movie objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Syn_Deal_Movie objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Syn_Deal_Movie objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }


    public class Syn_Deal_Rights_Service : BusinessLogic<Syn_Deal_Rights>
    {
        private readonly Syn_Deal_Rights_Repository objSDRR;
        //public Syn_Deal_Rights_Service()
        //{
        //    this.objSDRR = new Syn_Deal_Rights_Repository(DBConnection.Connection_Str);
        //}
        public Syn_Deal_Rights_Service(string Connection_Str)
        {
            this.objSDRR = new Syn_Deal_Rights_Repository(Connection_Str);
        }
        public IQueryable<Syn_Deal_Rights> SearchFor(Expression<Func<Syn_Deal_Rights, bool>> predicate)
        {
            return objSDRR.SearchFor(predicate);
        }

        public Syn_Deal_Rights GetById(int id)
        {
            return objSDRR.GetById(id);
        }

        public bool Save(Syn_Deal_Rights objSDR, out dynamic resultSet)
        {
            return base.Save(objSDR, objSDRR, out resultSet);
        }

        public bool Update(Syn_Deal_Rights objSDR, out dynamic resultSet)
        {
            return base.Update(objSDR, objSDRR, out resultSet);
        }

        public bool Delete(Syn_Deal_Rights objSDR, out dynamic resultSet)
        {
            return base.Delete(objSDR, objSDRR, out resultSet);
        }

        public override bool Validate(Syn_Deal_Rights objToValidate, out dynamic resultSet)
        {
            //USP_Service objValidateService = new USP_Service();
            resultSet = "";
            //IEnumerable<USP_Validate_Rights_Duplication_UDT> objResult = objValidateService.USP_Validate_Rights_Duplication_UDT(
            //   objToValidate.LstDeal_Rights_UDT,
            //   objToValidate.LstDeal_Rights_Title_UDT,
            //   objToValidate.LstDeal_Rights_Platform_UDT,
            //   objToValidate.LstDeal_Rights_Territory_UDT,
            //   objToValidate.LstDeal_Rights_Subtitling_UDT,
            //   objToValidate.LstDeal_Rights_Dubbing_UDT
            //   , "SR");
            //resultSet = objResult;
            //return !(objResult.Count() > 0);
            return true;
        }

        public override bool ValidateUpdate(Syn_Deal_Rights objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Syn_Deal_Rights objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Syn_Deal_Rights_Title_Service : BusinessLogic<Syn_Deal_Rights_Title>
    {
        private readonly Syn_Deal_Rights_Title_Repository objRepository;
        //public Syn_Deal_Rights_Title_Service()
        //{
        //    this.objRepository = new Syn_Deal_Rights_Title_Repository(DBConnection.Connection_Str);
        //}
        public Syn_Deal_Rights_Title_Service(string Connection_Str)
        {
            this.objRepository = new Syn_Deal_Rights_Title_Repository(Connection_Str);
        }
        public IQueryable<Syn_Deal_Rights_Title> SearchFor(Expression<Func<Syn_Deal_Rights_Title, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Syn_Deal_Rights_Title GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public bool Save(Syn_Deal_Rights_Title objADA, out dynamic resultSet)
        {
            return base.Save(objADA, objRepository, out resultSet);
        }
        public bool Delete(Syn_Deal_Rights_Title objADA, out dynamic resultSet)
        {
            return base.Delete(objADA, objRepository, out resultSet);
        }

        public override bool Validate(Syn_Deal_Rights_Title objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUpdate(Syn_Deal_Rights_Title objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateDelete(Syn_Deal_Rights_Title objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }
    }

    public class Syn_Deal_Ancillary_Service : BusinessLogic<Syn_Deal_Ancillary>
    {
        private readonly Syn_Deal_Ancillary_Repository objADAR;
        //public Syn_Deal_Ancillary_Service()
        //{
        //    this.objADAR = new Syn_Deal_Ancillary_Repository(DBConnection.Connection_Str);
        //}
        public Syn_Deal_Ancillary_Service(string Connection_Str)
        {
            this.objADAR = new Syn_Deal_Ancillary_Repository(Connection_Str);
        }
        public IQueryable<Syn_Deal_Ancillary> SearchFor(Expression<Func<Syn_Deal_Ancillary, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Syn_Deal_Ancillary GetById(int id)
        {
            return objADAR.GetById(id);
        }

        public bool Save(Syn_Deal_Ancillary objADA, out dynamic resultSet)
        {
            return base.Save(objADA, objADAR, out resultSet);
        }

        public bool Update(Syn_Deal_Ancillary objADA, out dynamic resultSet)
        {
            return base.Update(objADA, objADAR, out resultSet);
        }

        public bool Delete(Syn_Deal_Ancillary objADA, out dynamic resultSet)
        {
            return base.Delete(objADA, objADAR, out resultSet);
        }

        public override bool Validate(Syn_Deal_Ancillary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Syn_Deal_Ancillary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Syn_Deal_Ancillary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Syn_Deal_Revenue_Service : BusinessLogic<Syn_Deal_Revenue>
    {
        private readonly Syn_Deal_Revenue_Repository objADAR;
        //public Syn_Deal_Revenue_Service()
        //{
        //    this.objADAR = new Syn_Deal_Revenue_Repository(DBConnection.Connection_Str);
        //}
        public Syn_Deal_Revenue_Service(string Connection_Str)
        {
            this.objADAR = new Syn_Deal_Revenue_Repository(Connection_Str);
        }
        public IQueryable<Syn_Deal_Revenue> SearchFor(Expression<Func<Syn_Deal_Revenue, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Syn_Deal_Revenue GetById(int id)
        {
            return objADAR.GetById(id);
        }

        public bool Save(Syn_Deal_Revenue objADA, out dynamic resultSet)
        {
            return base.Save(objADA, objADAR, out resultSet);
        }

        public bool Update(Syn_Deal_Revenue objADA, out dynamic resultSet)
        {
            return base.Update(objADA, objADAR, out resultSet);
        }

        public bool Delete(Syn_Deal_Revenue objADA, out dynamic resultSet)
        {
            return base.Delete(objADA, objADAR, out resultSet);
        }

        public override bool Validate(Syn_Deal_Revenue objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Syn_Deal_Revenue objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Syn_Deal_Revenue objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }

    public class Syn_Deal_Run_Service : BusinessLogic<Syn_Deal_Run>
    {
        private readonly Syn_Deal_Run_Repository objSDR;
        //public Syn_Deal_Run_Service()
        //{
        //    this.objSDR = new Syn_Deal_Run_Repository(DBConnection.Connection_Str);
        //}
        public Syn_Deal_Run_Service(string Connection_Str)
        {
            this.objSDR = new Syn_Deal_Run_Repository(Connection_Str);
        }
        public IQueryable<Syn_Deal_Run> SearchFor(Expression<Func<Syn_Deal_Run, bool>> predicate)
        {
            return objSDR.SearchFor(predicate);
        }

        public Syn_Deal_Run GetById(int id)
        {
            return objSDR.GetById(id);
        }

        public bool Save(Syn_Deal_Run objADA, out dynamic resultSet)
        {
            return base.Save(objADA, objSDR, out resultSet);
        }

        public bool Update(Syn_Deal_Run objADA, out dynamic resultSet)
        {
            return base.Update(objADA, objSDR, out resultSet);
        }

        public bool Delete(Syn_Deal_Run objADA, out dynamic resultSet)
        {
            return base.Delete(objADA, objSDR, out resultSet);
        }

        public override bool Validate(Syn_Deal_Run objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Syn_Deal_Run objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Syn_Deal_Run objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }
    public class Syn_Deal_Material_Service : BusinessLogic<Syn_Deal_Material>
    {
        private readonly Syn_Deal_Material_Repository objADMR;
        //public Syn_Deal_Material_Service()
        //{
        //    this.objADMR = new Syn_Deal_Material_Repository(DBConnection.Connection_Str);
        //}
        public Syn_Deal_Material_Service(string Connection_Str)
        {
            this.objADMR = new Syn_Deal_Material_Repository(Connection_Str);
        }
        public IQueryable<Syn_Deal_Material> SearchFor(Expression<Func<Syn_Deal_Material, bool>> predicate)
        {
            return objADMR.SearchFor(predicate);
        }

        public Syn_Deal_Material GetById(int id)
        {
            return objADMR.GetById(id);
        }

        public bool Save(Syn_Deal_Material objADM, out dynamic resultSet)
        {
            return base.Save(objADM, objADMR, out resultSet);
        }

        public bool Update(Syn_Deal_Material objADM, out dynamic resultSet)
        {
            return base.Update(objADM, objADMR, out resultSet);
        }

        public bool Delete(Syn_Deal_Material objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objADMR, out resultSet);
        }

        public override bool Validate(Syn_Deal_Material objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Syn_Deal_Material objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Syn_Deal_Material objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Syn_Deal_Attachment_Service : BusinessLogic<Syn_Deal_Attachment>
    {
        private readonly Syn_Deal_Attachment_Repository objADAR;
        //public Syn_Deal_Attachment_Service()
        //{
        //    this.objADAR = new Syn_Deal_Attachment_Repository(DBConnection.Connection_Str);
        //}
        public Syn_Deal_Attachment_Service(string Connection_Str)
        {
            this.objADAR = new Syn_Deal_Attachment_Repository(Connection_Str);
        }
        public IQueryable<Syn_Deal_Attachment> SearchFor(Expression<Func<Syn_Deal_Attachment, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Syn_Deal_Attachment GetById(int id)
        {
            return objADAR.GetById(id);
        }

        public bool Save(Syn_Deal_Attachment objADM, out dynamic resultSet)
        {
            return base.Save(objADM, objADAR, out resultSet);
        }

        public bool Update(Syn_Deal_Attachment objADM, out dynamic resultSet)
        {
            return base.Update(objADM, objADAR, out resultSet);
        }

        public bool Delete(Syn_Deal_Attachment objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objADAR, out resultSet);
        }

        public override bool Validate(Syn_Deal_Attachment objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Syn_Deal_Attachment objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Syn_Deal_Attachment objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Syn_Deal_Payment_Terms_Service : BusinessLogic<Syn_Deal_Payment_Terms>
    {
        private readonly Syn_Deal_Payment_Terms_Repository objADPTR;
        //public Syn_Deal_Payment_Terms_Service()
        //{
        //    this.objADPTR = new Syn_Deal_Payment_Terms_Repository(DBConnection.Connection_Str);
        //}
        public Syn_Deal_Payment_Terms_Service(string Connection_Str)
        {
            this.objADPTR = new Syn_Deal_Payment_Terms_Repository(Connection_Str);
        }
        public IQueryable<Syn_Deal_Payment_Terms> SearchFor(Expression<Func<Syn_Deal_Payment_Terms, bool>> predicate)
        {
            return objADPTR.SearchFor(predicate);
        }

        public Syn_Deal_Payment_Terms GetById(int id)
        {
            return objADPTR.GetById(id);
        }

        public bool Save(Syn_Deal_Payment_Terms objADM, out dynamic resultSet)
        {
            return base.Save(objADM, objADPTR, out resultSet);
        }

        public bool Update(Syn_Deal_Payment_Terms objADM, out dynamic resultSet)
        {
            return base.Update(objADM, objADPTR, out resultSet);
        }

        public bool Delete(Syn_Deal_Payment_Terms objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objADPTR, out resultSet);
        }

        public override bool Validate(Syn_Deal_Payment_Terms objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Syn_Deal_Payment_Terms objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Syn_Deal_Payment_Terms objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Syn_Acq_Mapping_Service : BusinessLogic<Syn_Acq_Mapping>
    {
        private readonly Syn_Acq_Mapping_Repository objSDMR;
        //public Syn_Acq_Mapping_Service()
        //{
        //    this.objSDMR = new Syn_Acq_Mapping_Repository(DBConnection.Connection_Str);
        //}
        public Syn_Acq_Mapping_Service(string Connection_Str)
        {
            this.objSDMR = new Syn_Acq_Mapping_Repository(Connection_Str);
        }
        public IQueryable<Syn_Acq_Mapping> SearchFor(Expression<Func<Syn_Acq_Mapping, bool>> predicate)
        {
            return objSDMR.SearchFor(predicate);
        }

        public Syn_Acq_Mapping GetById(int id)
        {
            return objSDMR.GetById(id);
        }


        public override bool Validate(Syn_Acq_Mapping objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Syn_Acq_Mapping objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Syn_Acq_Mapping objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public bool Save(Syn_Acq_Mapping objADM, out dynamic resultSet)
        {
            return base.Save(objADM, objSDMR, out resultSet);
        }

        public bool Update(Syn_Acq_Mapping objADM, out dynamic resultSet)
        {
            return base.Update(objADM, objSDMR, out resultSet);
        }

        public bool Delete(Syn_Acq_Mapping objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objSDMR, out resultSet);
        }
    }


}
