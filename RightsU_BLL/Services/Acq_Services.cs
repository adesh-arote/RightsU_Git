using RightsU_DAL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;

namespace RightsU_BLL
{
    /// <summary>
    /// Add Acq Service Classes Here
    /// </summary>
    public class Acq_Deal_Service : BusinessLogic<Acq_Deal>
    {
        private readonly Acq_Deal_Repository objADR;
        private string _Connection_Str = "";
        //public Acq_Deal_Service()
        //{
        //    this.objADR = new Acq_Deal_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Service(string Connection_Str)
        {
            _Connection_Str = Connection_Str;
            this.objADR = new Acq_Deal_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal> SearchFor(Expression<Func<Acq_Deal, bool>> predicate)
        {
            return objADR.SearchFor(predicate);
        }

        public Acq_Deal GetById(int id)
        {
            return objADR.GetById(id);
        }

        public bool Save(Acq_Deal objD, out dynamic resultSet)
        {
            return base.Save(objD, objADR, out resultSet);
        }

        public bool Update(Acq_Deal objD, out dynamic resultSet)
        {
            return base.Update(objD, objADR, out resultSet);
        }

        public bool Delete(Acq_Deal objD, out dynamic resultSet)
        {
            return base.Delete(objD, objADR, out resultSet);
        }

        public override bool Validate(Acq_Deal objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            if (!objToValidate.SaveGeneralOnly)
            {
                USP_Service objValidateService = new USP_Service(_Connection_Str);

                //Commented by akshay rane temporary (need to Recheck by aayush)
                /*
                List<USP_Validate_Rev_HB_Duplication_UDT_Acq> objResult = new List<USP_Validate_Rev_HB_Duplication_UDT_Acq>();
                foreach (Acq_Deal_Pushback objADP in objToValidate.Acq_Deal_Pushback)
                {
                    if (objADP.LstDeal_Pushback_UDT.Count > 0)
                    {

                        objResult.AddRange(objValidateService.USP_Validate_Rev_HB_Duplication_UDT(
                           objADP.LstDeal_Pushback_UDT,
                           objADP.LstDeal_Pushback_Title_UDT,
                           objADP.LstDeal_Pushback_Platform_UDT,
                           objADP.LstDeal_Pushback_Territory_UDT,
                           objADP.LstDeal_Pushback_Subtitling_UDT,
                           objADP.LstDeal_Pushback_Dubbing_UDT
                           //"AP"
                           ).ToList());
                    }
                }
                */

                List<USP_Validate_Rights_Duplication_UDT> objResult = new List<USP_Validate_Rights_Duplication_UDT>();
                foreach (Acq_Deal_Rights objADP in objToValidate.Acq_Deal_Rights)
                {
                    if (objADP.LstDeal_Rights_UDT.Count > 0)
                    {
                        //List<USP_Validate_Rights_Duplication_UDT> objResult = new List<USP_Validate_Rights_Duplication_UDT>();
                        objResult.AddRange(objValidateService.USP_Validate_Rights_Duplication_UDT(
                           objADP.LstDeal_Rights_UDT,
                           objADP.LstDeal_Rights_Title_UDT,
                           objADP.LstDeal_Rights_Platform_UDT,
                           objADP.LstDeal_Rights_Territory_UDT,
                           objADP.LstDeal_Rights_Subtitling_UDT,
                           objADP.LstDeal_Rights_Dubbing_UDT,
                           "AR"
                           ).ToList());

                        resultSet = objResult;
                    }
                }
                resultSet = objResult;
                return !(objResult.Count() > 0);
            }
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Movie_Service : BusinessLogic<Acq_Deal_Movie>
    {
        private readonly Acq_Deal_Movie_Repository objADMR;
        //public Acq_Deal_Movie_Service()
        //{
        //    this.objADMR = new Acq_Deal_Movie_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Movie_Service(string Connection_Str)
        {
            this.objADMR = new Acq_Deal_Movie_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Movie> SearchFor(Expression<Func<Acq_Deal_Movie, bool>> predicate)
        {
            return objADMR.SearchFor(predicate);
        }

        public Acq_Deal_Movie GetById(int id)
        {
            return objADMR.GetById(id);
        }


        public override bool Validate(Acq_Deal_Movie objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Movie objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Movie objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Rights_Perpetuity_Service : BusinessLogic<Acq_Deal_Rights>
    {
        private readonly Acq_Deal_Rights_Repository objADRR;
        private string _Connection_Str = "";
        //public Acq_Deal_Rights_Service()
        //{
        //    this.objADRR = new Acq_Deal_Rights_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Rights_Perpetuity_Service(string Connection_Str)
        {
            _Connection_Str = Connection_Str;
            this.objADRR = new Acq_Deal_Rights_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Rights> SearchFor(Expression<Func<Acq_Deal_Rights, bool>> predicate)
        {
            IQueryable<Acq_Deal_Rights> lst = objADRR.SearchFor(predicate);
            foreach (Acq_Deal_Rights objRight in lst)
            {
                objRight.Acq_Deal_Rights_Territory.Clear();
                objRight.Acq_Deal_Rights_Territory = objADRR.DataContext.USP_Select_Acq_Deal_Rights_Territory(objRight.Acq_Deal_Rights_Code).ToList();
                objRight.Acq_Deal_Rights_Subtitling.Clear();
                objRight.Acq_Deal_Rights_Subtitling = objADRR.DataContext.USP_Select_Acq_Deal_Rights_Subtitling(objRight.Acq_Deal_Rights_Code).ToList();
                objRight.Acq_Deal_Rights_Dubbing.Clear();
                objRight.Acq_Deal_Rights_Dubbing = objADRR.DataContext.USP_Select_Acq_Deal_Rights_Dubbing(objRight.Acq_Deal_Rights_Code).ToList();
            }
            return lst;
        }

        public Acq_Deal_Rights GetById(int id)
        {
            Acq_Deal_Rights objRight = objADRR.GetById(id);
            objRight.Acq_Deal_Rights_Territory.Clear();
            objRight.Acq_Deal_Rights_Territory = objADRR.DataContext.USP_Select_Acq_Deal_Rights_Territory(objRight.Acq_Deal_Rights_Code).ToList();
            objRight.Acq_Deal_Rights_Subtitling.Clear();
            objRight.Acq_Deal_Rights_Subtitling = objADRR.DataContext.USP_Select_Acq_Deal_Rights_Subtitling(objRight.Acq_Deal_Rights_Code).ToList();
            objRight.Acq_Deal_Rights_Dubbing.Clear();
            objRight.Acq_Deal_Rights_Dubbing = objADRR.DataContext.USP_Select_Acq_Deal_Rights_Dubbing(objRight.Acq_Deal_Rights_Code).ToList();
            return objRight;
            //return objADRR.GetById(id);
        }

        public bool Save(Acq_Deal_Rights objADR, out dynamic resultSet)
        {
            return base.Save(objADR, objADRR, out resultSet);
        }

        public bool Update(Acq_Deal_Rights objADR, out dynamic resultSet)
        {
            return base.Update(objADR, objADRR, out resultSet);
        }

        public bool Delete(Acq_Deal_Rights objADR, out dynamic resultSet)
        {
            return base.Delete(objADR, objADRR, out resultSet);
        }

        public override bool Validate(Acq_Deal_Rights objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Rights objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Rights objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Rights_Service : BusinessLogic<Acq_Deal_Rights>
    {
        private readonly Acq_Deal_Rights_Repository objADRR;
        private string _Connection_Str = "";
        //public Acq_Deal_Rights_Service()
        //{
        //    this.objADRR = new Acq_Deal_Rights_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Rights_Service(string Connection_Str)
        {
            _Connection_Str = Connection_Str;
            this.objADRR = new Acq_Deal_Rights_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Rights> SearchFor(Expression<Func<Acq_Deal_Rights, bool>> predicate)
        {
            IQueryable<Acq_Deal_Rights> lst = objADRR.SearchFor(predicate);
            foreach (Acq_Deal_Rights objRight in lst)
            {
                objRight.Acq_Deal_Rights_Territory.Clear();
                objRight.Acq_Deal_Rights_Territory = objADRR.DataContext.USP_Select_Acq_Deal_Rights_Territory(objRight.Acq_Deal_Rights_Code).ToList();
                objRight.Acq_Deal_Rights_Subtitling.Clear();
                objRight.Acq_Deal_Rights_Subtitling = objADRR.DataContext.USP_Select_Acq_Deal_Rights_Subtitling(objRight.Acq_Deal_Rights_Code).ToList();
                objRight.Acq_Deal_Rights_Dubbing.Clear();
                objRight.Acq_Deal_Rights_Dubbing = objADRR.DataContext.USP_Select_Acq_Deal_Rights_Dubbing(objRight.Acq_Deal_Rights_Code).ToList();
            }
            return lst;
        }

        public Acq_Deal_Rights GetById(int id)
        {
            Acq_Deal_Rights objRight = objADRR.GetById(id);
            objRight.Acq_Deal_Rights_Territory.Clear();
            objRight.Acq_Deal_Rights_Territory = objADRR.DataContext.USP_Select_Acq_Deal_Rights_Territory(objRight.Acq_Deal_Rights_Code).ToList();
            objRight.Acq_Deal_Rights_Subtitling.Clear();
            objRight.Acq_Deal_Rights_Subtitling = objADRR.DataContext.USP_Select_Acq_Deal_Rights_Subtitling(objRight.Acq_Deal_Rights_Code).ToList();
            objRight.Acq_Deal_Rights_Dubbing.Clear();
            objRight.Acq_Deal_Rights_Dubbing = objADRR.DataContext.USP_Select_Acq_Deal_Rights_Dubbing(objRight.Acq_Deal_Rights_Code).ToList();
            return objRight;
            //return objADRR.GetById(id);
        }

        public bool Save(Acq_Deal_Rights objADR, out dynamic resultSet)
        {
            return base.Save(objADR, objADRR, out resultSet);
        }

        public bool Update(Acq_Deal_Rights objADR, out dynamic resultSet)
        {
            return base.Update(objADR, objADRR, out resultSet);
        }

        public bool Delete(Acq_Deal_Rights objADR, out dynamic resultSet)
        {
            return base.Delete(objADR, objADRR, out resultSet);
        }

        public override bool Validate(Acq_Deal_Rights objToValidate, out dynamic resultSet)
        {
            USP_Service objValidateService = new USP_Service(_Connection_Str);
            resultSet = "";
            string Is_Acq_rights_delay_validation = new System_Parameter_New_Service(_Connection_Str)
                .SearchFor(x => x.Parameter_Name == "Is_Acq_rights_delay_validation")
                .FirstOrDefault().Parameter_Value;

            //if(objToValidate.Buyback_Syn_Rights_Code == null)
            //{
                if (Is_Acq_rights_delay_validation != "Y")
                {
                    IEnumerable<USP_Validate_Rights_Duplication_UDT> objResult = objValidateService.USP_Validate_Rights_Duplication_UDT(
                       objToValidate.LstDeal_Rights_UDT,
                       objToValidate.LstDeal_Rights_Title_UDT,
                       objToValidate.LstDeal_Rights_Platform_UDT,
                       objToValidate.LstDeal_Rights_Territory_UDT,
                       objToValidate.LstDeal_Rights_Subtitling_UDT,
                       objToValidate.LstDeal_Rights_Dubbing_UDT
                       , "AR");
                    resultSet = objResult;
                    return !(objResult.Count() > 0);
                }
                else
                    return true;
            //}
            //else{
            //    List<USP_Validate_Rights_Duplication_UDT> objResult = new List<USP_Validate_Rights_Duplication_UDT>();
            //    resultSet = objResult;
            //    return true;

            //}

            
        }

        public override bool ValidateUpdate(Acq_Deal_Rights objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Rights objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Rights_Territory_Service : BusinessLogic<Acq_Deal_Rights_Territory>
    {
        private readonly Acq_Deal_Rights_Territory_Repository objRepository;
        //public Acq_Deal_Rights_Territory_Service()
        //{
        //    this.objRepository = new Acq_Deal_Rights_Territory_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Rights_Territory_Service(string Connection_Str)
        {
            this.objRepository = new Acq_Deal_Rights_Territory_Repository(Connection_Str);
        }
        public Acq_Deal_Rights_Territory GetById(int id)
        {
            Acq_Deal_Rights_Territory objADRT = objRepository.GetById(id);
            return objADRT;
        }

        public IQueryable<Acq_Deal_Rights_Territory> SearchFor(Expression<Func<Acq_Deal_Rights_Territory, bool>> predicate)
        {
            IQueryable<Acq_Deal_Rights_Territory> lst = objRepository.SearchFor(predicate);
            return lst;
        }

        public override bool Validate(Acq_Deal_Rights_Territory objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Rights_Territory objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Rights_Territory objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Pushback_Service : BusinessLogic<Acq_Deal_Pushback>
    {
        private readonly Acq_Deal_Pushback_Repository objADPR;
        private string _Connection_Str = "";
        //public Acq_Deal_Pushback_Service()
        //{
        //    this.objADPR = new Acq_Deal_Pushback_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Pushback_Service(string Connection_Str)
        {
            _Connection_Str = Connection_Str;
            this.objADPR = new Acq_Deal_Pushback_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Pushback> SearchFor(Expression<Func<Acq_Deal_Pushback, bool>> predicate)
        {
            IQueryable<Acq_Deal_Pushback> lst = objADPR.SearchFor(predicate);
            foreach (Acq_Deal_Pushback objPushback in lst)
            {
                objPushback.Acq_Deal_Pushback_Territory.Clear();
                objPushback.Acq_Deal_Pushback_Territory = objADPR.DataContext.USP_Select_Acq_Deal_Pushback_Territory(objPushback.Acq_Deal_Pushback_Code).ToList();
                objPushback.Acq_Deal_Pushback_Subtitling.Clear();
                objPushback.Acq_Deal_Pushback_Subtitling = objADPR.DataContext.USP_Select_Acq_Deal_Pushback_Subtitling(objPushback.Acq_Deal_Pushback_Code).ToList();
                objPushback.Acq_Deal_Pushback_Dubbing.Clear();
                objPushback.Acq_Deal_Pushback_Dubbing = objADPR.DataContext.USP_Select_Acq_Deal_Pushback_Dubbing(objPushback.Acq_Deal_Pushback_Code).ToList();
            }
            return lst;
            //return objADPR.SearchFor(predicate);
        }

        public Acq_Deal_Pushback GetById(int id)
        {
            Acq_Deal_Pushback objPushback = objADPR.GetById(id);
            objPushback.Acq_Deal_Pushback_Territory.Clear();
            objPushback.Acq_Deal_Pushback_Territory = objADPR.DataContext.USP_Select_Acq_Deal_Pushback_Territory(objPushback.Acq_Deal_Pushback_Code).ToList();
            objPushback.Acq_Deal_Pushback_Subtitling.Clear();
            objPushback.Acq_Deal_Pushback_Subtitling = objADPR.DataContext.USP_Select_Acq_Deal_Pushback_Subtitling(objPushback.Acq_Deal_Pushback_Code).ToList();
            objPushback.Acq_Deal_Pushback_Dubbing.Clear();
            objPushback.Acq_Deal_Pushback_Dubbing = objADPR.DataContext.USP_Select_Acq_Deal_Pushback_Dubbing(objPushback.Acq_Deal_Pushback_Code).ToList();

            return objPushback;
        }

        public bool Save(Acq_Deal_Pushback objADP, out dynamic resultSet)
        {
            return base.Save(objADP, objADPR, out resultSet);
        }

        public bool Update(Acq_Deal_Pushback objADP, out dynamic resultSet)
        {
            return base.Update(objADP, objADPR, out resultSet);
        }

        public bool Delete(Acq_Deal_Pushback objADP, out dynamic resultSet)
        {
            return base.Delete(objADP, objADPR, out resultSet);
        }

        public override bool Validate(Acq_Deal_Pushback objToValidate, out dynamic resultSet)
        {
            USP_Service objValidateService = new USP_Service(_Connection_Str);
            resultSet = "";
            IEnumerable<USP_Validate_Rev_HB_Duplication_UDT_Acq> objResult = objValidateService.USP_Validate_Rev_HB_Duplication_UDT(
               objToValidate.LstDeal_Pushback_UDT,
               objToValidate.LstDeal_Pushback_Title_UDT,
               objToValidate.LstDeal_Pushback_Platform_UDT,
               objToValidate.LstDeal_Pushback_Territory_UDT,
               objToValidate.LstDeal_Pushback_Subtitling_UDT,
               objToValidate.LstDeal_Pushback_Dubbing_UDT
               //"AP"
               );

            resultSet = objResult;
            return !(objResult.Count() > 0);
        }

        public override bool ValidateUpdate(Acq_Deal_Pushback objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Pushback objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Pushback_Territory_Service : BusinessLogic<Acq_Deal_Pushback_Territory>
    {
        private readonly Acq_Deal_Pushback_Territory_Repository objRepository;
        //public Acq_Deal_Pushback_Territory_Service()
        //{
        //    this.objRepository = new Acq_Deal_Pushback_Territory_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Pushback_Territory_Service(string Connection_Str)
        {
            this.objRepository = new Acq_Deal_Pushback_Territory_Repository(Connection_Str);
        }
        public Acq_Deal_Pushback_Territory GetById(int id)
        {
            Acq_Deal_Pushback_Territory objADPT = objRepository.GetById(id);
            return objADPT;
        }

        public IQueryable<Acq_Deal_Pushback_Territory> SearchFor(Expression<Func<Acq_Deal_Pushback_Territory, bool>> predicate)
        {
            IQueryable<Acq_Deal_Pushback_Territory> lst = objRepository.SearchFor(predicate);
            return lst;
        }

        public override bool Validate(Acq_Deal_Pushback_Territory objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Pushback_Territory objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Pushback_Territory objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Ancillary_Service : BusinessLogic<Acq_Deal_Ancillary>
    {
        private readonly Acq_Deal_Ancillary_Repository objADAR;
        private string _Connection_Str = "";
        //public Acq_Deal_Ancillary_Service()
        //{
        //    this.objADAR = new Acq_Deal_Ancillary_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Ancillary_Service(string Connection_Str)
        {
            _Connection_Str = Connection_Str;
            this.objADAR = new Acq_Deal_Ancillary_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Ancillary> SearchFor(Expression<Func<Acq_Deal_Ancillary, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Acq_Deal_Ancillary GetById(int id)
        {
            return objADAR.GetById(id);
        }

        public bool Save(Acq_Deal_Ancillary objADA, out dynamic resultSet)
        {
            return base.Save(objADA, objADAR, out resultSet);
        }

        public bool Update(Acq_Deal_Ancillary objADA, out dynamic resultSet)
        {
            return base.Update(objADA, objADAR, out resultSet);
        }

        public bool Delete(Acq_Deal_Ancillary objADA, out dynamic resultSet)
        {
            return base.Delete(objADA, objADAR, out resultSet);
        }

        public override bool Validate(Acq_Deal_Ancillary objToValidate, out dynamic resultSet)
        {
            USP_Service objValidateService = new USP_Service(_Connection_Str);
            resultSet = "";
            IEnumerable<USP_Ancillary_Validate_Udt> objResult = objValidateService.USP_Ancillary_Validate_Udt(
               objToValidate.LstDeal_Ancillary_Title_UDT,
               objToValidate.LstDeal_Ancillary_Platform_UDT,
               objToValidate.LstDeal_Ancillary_Platform_Medium_UDT,
               (int)objToValidate.Ancillary_Type_code,
               objToValidate.Catch_Up_From,
               objToValidate.Acq_Deal_Ancillary_Code,
               (int)objToValidate.Acq_Deal_Code);
            int DupCount = objResult.ToList<RightsU_Entities.USP_Ancillary_Validate_Udt>().ElementAt(0).dup_Count;
            if (DupCount > 0)
                resultSet = "DUPLICATE";
            return !(DupCount > 0);
        }

        public override bool ValidateUpdate(Acq_Deal_Ancillary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Ancillary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }

    public class Acq_Deal_Run_Service : BusinessLogic<Acq_Deal_Run>
    {
        private readonly Acq_Deal_Run_Repository objADAR;
        //public Acq_Deal_Run_Service()
        //{
        //    this.objADAR = new Acq_Deal_Run_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Run_Service(string Connection_Str)
        {
            this.objADAR = new Acq_Deal_Run_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Run> SearchFor(Expression<Func<Acq_Deal_Run, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Acq_Deal_Run GetById(int id)
        {
            return objADAR.GetById(id);
        }

        public bool Save(Acq_Deal_Run objADA, out dynamic resultSet)
        {
            return base.Save(objADA, objADAR, out resultSet);
        }

        public bool Update(Acq_Deal_Run objADA, out dynamic resultSet)
        {
            return base.Update(objADA, objADAR, out resultSet);
        }

        public bool Delete(Acq_Deal_Run objADA, out dynamic resultSet)
        {
            return base.Delete(objADA, objADAR, out resultSet);
        }

        public override bool Validate(Acq_Deal_Run objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Run objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Run objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }

    public class Acq_Deal_Cost_Service : BusinessLogic<Acq_Deal_Cost>
    {
        private readonly Acq_Deal_Cost_Repository objADAR;
        //public Acq_Deal_Cost_Service()
        //{
        //    this.objADAR = new Acq_Deal_Cost_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Cost_Service(string Connection_Str)
        {
            this.objADAR = new Acq_Deal_Cost_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Cost> SearchFor(Expression<Func<Acq_Deal_Cost, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Acq_Deal_Cost GetById(int id)
        {
            return objADAR.GetById(id);
        }

        public bool Save(Acq_Deal_Cost objADA, out dynamic resultSet)
        {
            return base.Save(objADA, objADAR, out resultSet);
        }

        public bool Update(Acq_Deal_Cost objADA, out dynamic resultSet)
        {
            return base.Update(objADA, objADAR, out resultSet);
        }

        public bool Delete(Acq_Deal_Cost objADA, out dynamic resultSet)
        {
            return base.Delete(objADA, objADAR, out resultSet);
        }

        public override bool Validate(Acq_Deal_Cost objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Cost objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Cost objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }

    public class Acq_Deal_Sport_Service : BusinessLogic<Acq_Deal_Sport>
    {
        private readonly Acq_Deal_Sport_Repository objADS;
        //public Acq_Deal_Sport_Service()
        //{
        //    this.objADS = new Acq_Deal_Sport_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Sport_Service(string Connection_Str)
        {
            this.objADS = new Acq_Deal_Sport_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Sport> SearchFor(Expression<Func<Acq_Deal_Sport, bool>> predicate)
        {
            IQueryable<Acq_Deal_Sport> lst = objADS.SearchFor(predicate);
            foreach (Acq_Deal_Sport objSport in lst)
            {
                objSport.Acq_Deal_Sport_Language.Clear();
                objSport.Acq_Deal_Sport_Language = objADS.DataContext.USP_Select_Acq_Deal_Sport_Language(objSport.Acq_Deal_Sport_Code).ToList();
            }
            return lst;

            //return objADS.SearchFor(predicate);
        }

        public Acq_Deal_Sport GetById(int id)
        {
            Acq_Deal_Sport objSport = objADS.GetById(id);
            objSport.Acq_Deal_Sport_Language.Clear();
            objSport.Acq_Deal_Sport_Language = objADS.DataContext.USP_Select_Acq_Deal_Sport_Language(objSport.Acq_Deal_Sport_Code).ToList();
            return objSport;
            //return objADS.GetById(id);
        }

        public bool Save(Acq_Deal_Sport objADSR, out dynamic resultSet)
        {
            return base.Save(objADSR, objADS, out resultSet);
        }

        public bool Update(Acq_Deal_Sport objADSR, out dynamic resultSet)
        {
            return base.Update(objADSR, objADS, out resultSet);
        }

        public bool Delete(Acq_Deal_Sport objADSR, out dynamic resultSet)
        {
            return base.Delete(objADSR, objADS, out resultSet);
        }

        public override bool Validate(Acq_Deal_Sport objToValidate, out dynamic resultSet)
        {
            //USP_Service objValidateService = new USP_Service();
            //resultSet = "";
            //IEnumerable<USP_Validate_Rights_Duplication_UDT> objResult = objValidateService.USP_Validate_Rights_Duplication_UDT(
            //   objToValidate.LstDeal_Rights_UDT,
            //   objToValidate.LstDeal_Rights_Title_UDT,
            //   objToValidate.LstDeal_Rights_Platform_UDT,
            //   objToValidate.LstDeal_Rights_Territory_UDT,
            //   objToValidate.LstDeal_Rights_Subtitling_UDT,
            //   objToValidate.LstDeal_Rights_Dubbing_UDT
            //   , "AR");

            //resultSet = objResult;
            //return !(objResult.Count() > 0);

            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Sport objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Sport objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Material_Service : BusinessLogic<Acq_Deal_Material>
    {
        private readonly Acq_Deal_Material_Repository objADMR;
        //public Acq_Deal_Material_Service()
        //{
        //    this.objADMR = new Acq_Deal_Material_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Material_Service(string Connection_Str)
        {
            this.objADMR = new Acq_Deal_Material_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Material> SearchFor(Expression<Func<Acq_Deal_Material, bool>> predicate)
        {
            return objADMR.SearchFor(predicate);
        }

        public Acq_Deal_Material GetById(int id)
        {
            return objADMR.GetById(id);
        }

        public bool Save(Acq_Deal_Material objADM, out dynamic resultSet)
        {
            return base.Save(objADM, objADMR, out resultSet);
        }

        public bool Update(Acq_Deal_Material objADM, out dynamic resultSet)
        {
            return base.Update(objADM, objADMR, out resultSet);
        }

        public bool Delete(Acq_Deal_Material objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objADMR, out resultSet);
        }

        public override bool Validate(Acq_Deal_Material objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Material objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Material objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Attachment_Service : BusinessLogic<Acq_Deal_Attachment>
    {
        private readonly Acq_Deal_Attachment_Repository objADAR;
        //public Acq_Deal_Attachment_Service()
        //{
        //    this.objADAR = new Acq_Deal_Attachment_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Attachment_Service(string Connection_Str)
        {
            this.objADAR = new Acq_Deal_Attachment_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Attachment> SearchFor(Expression<Func<Acq_Deal_Attachment, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Acq_Deal_Attachment GetById(int id)
        {
            return objADAR.GetById(id);
        }

        public bool Save(Acq_Deal_Attachment objADM, out dynamic resultSet)
        {
            return base.Save(objADM, objADAR, out resultSet);
        }

        public bool Update(Acq_Deal_Attachment objADM, out dynamic resultSet)
        {
            return base.Update(objADM, objADAR, out resultSet);
        }

        public bool Delete(Acq_Deal_Attachment objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objADAR, out resultSet);
        }

        public override bool Validate(Acq_Deal_Attachment objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Attachment objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Attachment objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Payment_Terms_Service : BusinessLogic<Acq_Deal_Payment_Terms>
    {
        private readonly Acq_Deal_Payment_Terms_Repository objADPTR;
        //public Acq_Deal_Payment_Terms_Service()
        //{
        //    this.objADPTR = new Acq_Deal_Payment_Terms_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Payment_Terms_Service(string Connection_Str)
        {
            this.objADPTR = new Acq_Deal_Payment_Terms_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Payment_Terms> SearchFor(Expression<Func<Acq_Deal_Payment_Terms, bool>> predicate)
        {
            return objADPTR.SearchFor(predicate);
        }

        public Acq_Deal_Payment_Terms GetById(int id)
        {
            return objADPTR.GetById(id);
        }

        public bool Save(Acq_Deal_Payment_Terms objADM, out dynamic resultSet)
        {
            return base.Save(objADM, objADPTR, out resultSet);
        }

        public bool Update(Acq_Deal_Payment_Terms objADM, out dynamic resultSet)
        {
            return base.Update(objADM, objADPTR, out resultSet);
        }

        public bool Delete(Acq_Deal_Payment_Terms objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objADPTR, out resultSet);
        }

        public override bool Validate(Acq_Deal_Payment_Terms objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Payment_Terms objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Payment_Terms objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Mass_Territory_Update_Service : BusinessLogic<Acq_Deal_Mass_Territory_Update>
    {
        private readonly Acq_Deal_Mass_Territory_Update_Repository objADMTU;

        //public Acq_Deal_Mass_Territory_Update_Service()
        //{
        //    this.objADMTU = new Acq_Deal_Mass_Territory_Update_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Mass_Territory_Update_Service(string Connection_Str)
        {
            this.objADMTU = new Acq_Deal_Mass_Territory_Update_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Mass_Territory_Update> SearchFor(Expression<Func<Acq_Deal_Mass_Territory_Update, bool>> predicate)
        {
            return objADMTU.SearchFor(predicate);
        }

        public Acq_Deal_Mass_Territory_Update GetById(int id)
        {
            return objADMTU.GetById(id);
        }

        public bool Update(Acq_Deal_Mass_Territory_Update objD, out dynamic resultSet)
        {
            return base.Update(objD, objADMTU, out resultSet);
        }

        public override bool Validate(Acq_Deal_Mass_Territory_Update objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Mass_Territory_Update objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Mass_Territory_Update objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Mass_Territory_Update_Details_Service : BusinessLogic<Acq_Deal_Mass_Territory_Update_Details>
    {
        private readonly Acq_Deal_Mass_Territory_Update_Details_Repository objADMTUD;
        //public Acq_Deal_Mass_Territory_Update_Details_Service()
        //{
        //    this.objADMTUD = new Acq_Deal_Mass_Territory_Update_Details_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Mass_Territory_Update_Details_Service(string Connection_Str)
        {
            this.objADMTUD = new Acq_Deal_Mass_Territory_Update_Details_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Mass_Territory_Update_Details> SearchFor(Expression<Func<Acq_Deal_Mass_Territory_Update_Details, bool>> predicate)
        {
            return objADMTUD.SearchFor(predicate);
        }

        public Acq_Deal_Mass_Territory_Update_Details GetById(int id)
        {
            return objADMTUD.GetById(id);
        }

        public override bool Validate(Acq_Deal_Mass_Territory_Update_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Acq_Deal_Mass_Territory_Update_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Mass_Territory_Update_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Avail_Acq_Service : BusinessLogic<Avail_Acq>
    {
        private readonly Avail_Acq_Repository objAvail_Acq_Repository;
        //public Avail_Acq_Service()
        //{
        //    this.objAvail_Acq_Repository = new Avail_Acq_Repository(DBConnection.Connection_Str);
        //}
        public Avail_Acq_Service(string Connection_Str)
        {
            this.objAvail_Acq_Repository = new Avail_Acq_Repository(Connection_Str);
        }
        public IQueryable<Avail_Acq> SearchFor(Expression<Func<Avail_Acq, bool>> predicate)
        {
            return objAvail_Acq_Repository.SearchFor(predicate);
        }

        public Avail_Acq GetById(int id)
        {
            return objAvail_Acq_Repository.GetById(id);
        }

        public override bool Validate(Avail_Acq objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Avail_Acq objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Avail_Acq objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Sport_Ancillary_Service : BusinessLogic<Acq_Deal_Sport_Ancillary>
    {
        private readonly Acq_Deal_Sport_Ancillary_Repository objADS;
        //public Acq_Deal_Sport_Ancillary_Service()
        //{
        //    this.objADS = new Acq_Deal_Sport_Ancillary_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Sport_Ancillary_Service(string Connection_Str)
        {
            this.objADS = new Acq_Deal_Sport_Ancillary_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Sport_Ancillary> SearchFor(Expression<Func<Acq_Deal_Sport_Ancillary, bool>> predicate)
        {
            return objADS.SearchFor(predicate);
        }

        public Acq_Deal_Sport_Ancillary GetById(int id)
        {
            return objADS.GetById(id);
        }

        public bool Save(Acq_Deal_Sport_Ancillary objADSR, out dynamic resultSet)
        {
            return base.Save(objADSR, objADS, out resultSet);
        }

        public bool Update(Acq_Deal_Sport_Ancillary objADSR, out dynamic resultSet)
        {
            return base.Update(objADSR, objADS, out resultSet);
        }

        public bool Delete(Acq_Deal_Sport_Ancillary objADSR, out dynamic resultSet)
        {
            return base.Delete(objADSR, objADS, out resultSet);
        }

        public override bool Validate(Acq_Deal_Sport_Ancillary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Sport_Ancillary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Sport_Ancillary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Sport_Monetisation_Ancillary_Service : BusinessLogic<Acq_Deal_Sport_Monetisation_Ancillary>
    {
        private readonly Acq_Deal_Sport_Monetisation_Ancillary_Repository objADS;
        //public Acq_Deal_Sport_Monetisation_Ancillary_Service()
        //{
        //    this.objADS = new Acq_Deal_Sport_Monetisation_Ancillary_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Sport_Monetisation_Ancillary_Service(string Connection_Str)
        {
            this.objADS = new Acq_Deal_Sport_Monetisation_Ancillary_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Sport_Monetisation_Ancillary> SearchFor(Expression<Func<Acq_Deal_Sport_Monetisation_Ancillary, bool>> predicate)
        {
            return objADS.SearchFor(predicate);
        }

        public Acq_Deal_Sport_Monetisation_Ancillary GetById(int id)
        {
            return objADS.GetById(id);
        }

        public bool Save(Acq_Deal_Sport_Monetisation_Ancillary objADSR, out dynamic resultSet)
        {
            return base.Save(objADSR, objADS, out resultSet);
        }

        public bool Update(Acq_Deal_Sport_Monetisation_Ancillary objADSR, out dynamic resultSet)
        {
            return base.Update(objADSR, objADS, out resultSet);
        }

        public bool Delete(Acq_Deal_Sport_Monetisation_Ancillary objADSR, out dynamic resultSet)
        {
            return base.Delete(objADSR, objADS, out resultSet);
        }

        public override bool Validate(Acq_Deal_Sport_Monetisation_Ancillary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Sport_Monetisation_Ancillary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Sport_Monetisation_Ancillary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Sport_Sales_Ancillary_Service : BusinessLogic<Acq_Deal_Sport_Sales_Ancillary>
    {
        private readonly Acq_Deal_Sport_Sales_Ancillary_Repository objADS;
        //public Acq_Deal_Sport_Sales_Ancillary_Service()
        //{
        //    this.objADS = new Acq_Deal_Sport_Sales_Ancillary_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Sport_Sales_Ancillary_Service(string Connection_Str)
        {
            this.objADS = new Acq_Deal_Sport_Sales_Ancillary_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Sport_Sales_Ancillary> SearchFor(Expression<Func<Acq_Deal_Sport_Sales_Ancillary, bool>> predicate)
        {
            return objADS.SearchFor(predicate);
        }

        public Acq_Deal_Sport_Sales_Ancillary GetById(int id)
        {
            return objADS.GetById(id);
        }

        public bool Save(Acq_Deal_Sport_Sales_Ancillary objADSR, out dynamic resultSet)
        {
            return base.Save(objADSR, objADS, out resultSet);
        }

        public bool Update(Acq_Deal_Sport_Sales_Ancillary objADSR, out dynamic resultSet)
        {
            return base.Update(objADSR, objADS, out resultSet);
        }

        public bool Delete(Acq_Deal_Sport_Sales_Ancillary objADSR, out dynamic resultSet)
        {
            return base.Delete(objADSR, objADS, out resultSet);
        }

        public override bool Validate(Acq_Deal_Sport_Sales_Ancillary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Sport_Sales_Ancillary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Sport_Sales_Ancillary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Acq_Deal_Budget_Service : BusinessLogic<Acq_Deal_Budget>
    {
        private readonly Acq_Deal_Budget_Repository objADBR;
        //public Acq_Deal_Budget_Service()
        //{
        //    this.objADBR = new Acq_Deal_Budget_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Budget_Service(string Connection_Str)
        {
            this.objADBR = new Acq_Deal_Budget_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Budget> SearchFor(Expression<Func<Acq_Deal_Budget, bool>> predicate)
        {
            return objADBR.SearchFor(predicate);
        }

        public Acq_Deal_Budget GetById(int id)
        {
            return objADBR.GetById(id);
        }

        public bool Save(Acq_Deal_Budget objADA, out dynamic resultSet)
        {
            return base.Save(objADA, objADBR, out resultSet);
        }

        public bool Update(Acq_Deal_Budget objADA, out dynamic resultSet)
        {
            return base.Update(objADA, objADBR, out resultSet);
        }

        public bool Delete(Acq_Deal_Budget objADA, out dynamic resultSet)
        {
            return base.Delete(objADA, objADBR, out resultSet);
        }

        public override bool Validate(Acq_Deal_Budget objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Budget objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Budget objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }

    public class Acq_Deal_Movie_Music_Service : BusinessLogic<Acq_Deal_Movie_Music>
    {
        private readonly Acq_Deal_Movie_Music_Repository objRepository;
        //public Acq_Deal_Movie_Music_Service()
        //{
        //    this.objRepository = new Acq_Deal_Movie_Music_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Movie_Music_Service(string Connection_Str)
        {
            this.objRepository = new Acq_Deal_Movie_Music_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Movie_Music> SearchFor(Expression<Func<Acq_Deal_Movie_Music, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Acq_Deal_Movie_Music GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Acq_Deal_Movie_Music objADM, out dynamic resultSet)
        {
            return base.Save(objADM, objRepository, out resultSet);
        }

        public bool Update(Acq_Deal_Movie_Music objADM, out dynamic resultSet)
        {
            return base.Update(objADM, objRepository, out resultSet);
        }

        public bool Delete(Acq_Deal_Movie_Music objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objRepository, out resultSet);
        }

        public override bool Validate(Acq_Deal_Movie_Music objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Movie_Music objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Movie_Music objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Movie_Music_Link_Service : BusinessLogic<Acq_Deal_Movie_Music_Link>
    {
        private readonly Acq_Deal_Movie_Music_Link_Repository objRepository;
        //public Acq_Deal_Movie_Music_Link_Service()
        //{
        //    this.objRepository = new Acq_Deal_Movie_Music_Link_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Movie_Music_Link_Service(string Connection_Str)
        {
            this.objRepository = new Acq_Deal_Movie_Music_Link_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Movie_Music_Link> SearchFor(Expression<Func<Acq_Deal_Movie_Music_Link, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Acq_Deal_Movie_Music_Link GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Acq_Deal_Movie_Music_Link objADM, out dynamic resultSet)
        {
            return base.Save(objADM, objRepository, out resultSet);
        }

        public bool Update(Acq_Deal_Movie_Music_Link objADM, out dynamic resultSet)
        {
            return base.Update(objADM, objRepository, out resultSet);
        }

        public bool Delete(Acq_Deal_Movie_Music_Link objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objRepository, out resultSet);
        }

        public override bool Validate(Acq_Deal_Movie_Music_Link objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Movie_Music_Link objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Movie_Music_Link objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    /*Holback Service*/
    public class Acq_Deal_Rights_Holdback_Service : BusinessLogic<Acq_Deal_Rights_Holdback>
    {
        private readonly Acq_Deal_Rights_Holdback_Repository objADR;
        //public Acq_Deal_Rights_Holdback_Service()
        //{
        //    this.objADR = new Acq_Deal_Rights_Holdback_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Rights_Holdback_Service(string Connection_Str)
        {
            this.objADR = new Acq_Deal_Rights_Holdback_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Rights_Holdback> SearchFor(Expression<Func<Acq_Deal_Rights_Holdback, bool>> predicate)
        {
            return objADR.SearchFor(predicate);
        }

        public Acq_Deal_Rights_Holdback GetById(int id)
        {
            return objADR.GetById(id);
        }
        public override bool Validate(Acq_Deal_Rights_Holdback objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Rights_Holdback objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Rights_Holdback objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Tab_Version_Service : BusinessLogic<Acq_Deal_Tab_Version>
    {
        private readonly Acq_Deal_Tab_Version_Repository objADTVR;
        //public Acq_Deal_Tab_Version_Service()
        //{
        //    this.objADTVR = new Acq_Deal_Tab_Version_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Tab_Version_Service(string Connection_Str)
        {
            this.objADTVR = new Acq_Deal_Tab_Version_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Tab_Version> SearchFor(Expression<Func<Acq_Deal_Tab_Version, bool>> predicate)
        {
            return objADTVR.SearchFor(predicate);
        }

        public Acq_Deal_Tab_Version GetById(int id)
        {
            return objADTVR.GetById(id);
        }

        public override bool Validate(Acq_Deal_Tab_Version objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Tab_Version objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Tab_Version objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }
    public class Acq_Deal_Rights_Title_Service : BusinessLogic<Acq_Deal_Rights_Title>
    {
        private readonly Acq_Deal_Rights_Title_Repository objADAR;
        //public Acq_Deal_Rights_Title_Service()
        //{
        //    this.objADAR = new Acq_Deal_Rights_Title_Repository(DBConnection.Connection_Str);
        //}
        public Acq_Deal_Rights_Title_Service(string Connection_Str)
        {
            this.objADAR = new Acq_Deal_Rights_Title_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Rights_Title> SearchFor(Expression<Func<Acq_Deal_Rights_Title, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Acq_Deal_Rights_Title GetById(int id)
        {
            return objADAR.GetById(id);
        }

        public bool Save(Acq_Deal_Rights_Title objADA, out dynamic resultSet)
        {
            return base.Save(objADA, objADAR, out resultSet);
        }

        public bool Update(Acq_Deal_Rights_Title objADA, out dynamic resultSet)
        {
            return base.Update(objADA, objADAR, out resultSet);
        }

        public bool Delete(Acq_Deal_Rights_Title objADA, out dynamic resultSet)
        {
            return base.Delete(objADA, objADAR, out resultSet);
        }

        public override bool Validate(Acq_Deal_Rights_Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Rights_Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Rights_Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }

    public class Rights_Bulk_Update_Service : BusinessLogic<Rights_Bulk_Update>
    {
        private readonly Rights_Bulk_Update_Repository objRepository;
        //public Rights_Bulk_Update_Service()
        //{
        //    this.objRepository = new Rights_Bulk_Update_Repository(DBConnection.Connection_Str);
        //}
        public Rights_Bulk_Update_Service(string Connection_Str)
        {
            this.objRepository = new Rights_Bulk_Update_Repository(Connection_Str);
        }
        public IQueryable<Rights_Bulk_Update> SearchFor(Expression<Func<Rights_Bulk_Update, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Rights_Bulk_Update GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Rights_Bulk_Update objADM, out dynamic resultSet)
        {
            return base.Save(objADM, objRepository, out resultSet);
        }

        public bool Update(Rights_Bulk_Update objADM, out dynamic resultSet)
        {
            return base.Update(objADM, objRepository, out resultSet);
        }

        public bool Delete(Rights_Bulk_Update objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objRepository, out resultSet);
        }

        public override bool Validate(Rights_Bulk_Update objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Rights_Bulk_Update objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Rights_Bulk_Update objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Deal_Rights_Process_Service : BusinessLogic<Deal_Rights_Process>
    {
        private readonly Deal_Rights_Process_Repository objRepository;
        //public Deal_Rights_Process_Service()
        //{
        //    this.objRepository = new Deal_Rights_Process_Repository(DBConnection.Connection_Str);
        //}
        public Deal_Rights_Process_Service(string Connection_Str)
        {
            this.objRepository = new Deal_Rights_Process_Repository(Connection_Str);
        }
        public IQueryable<Deal_Rights_Process> SearchFor(Expression<Func<Deal_Rights_Process, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Deal_Rights_Process GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Deal_Rights_Process objADM, out dynamic resultSet)
        {
            return base.Save(objADM, objRepository, out resultSet);
        }

        public bool Update(Deal_Rights_Process objADM, out dynamic resultSet)
        {
            return base.Update(objADM, objRepository, out resultSet);
        }

        public bool Delete(Deal_Rights_Process objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objRepository, out resultSet);
        }

        public override bool Validate(Deal_Rights_Process objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Deal_Rights_Process objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Deal_Rights_Process objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Rights_Error_Details_Service : BusinessLogic<Acq_Deal_Rights_Error_Details>
    {
        private readonly Acq_Deal_Rights_Error_Details_Repository objRepository;

        public Acq_Deal_Rights_Error_Details_Service(string Connection_Str)
        {
            this.objRepository = new Acq_Deal_Rights_Error_Details_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Rights_Error_Details> SearchFor(Expression<Func<Acq_Deal_Rights_Error_Details, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Acq_Deal_Rights_Error_Details GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Delete(Acq_Deal_Rights_Error_Details objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objRepository, out resultSet);
        }


        public override bool Validate(Acq_Deal_Rights_Error_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Deal_Rights_Error_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Deal_Rights_Error_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Rights_Template_Service : BusinessLogic<Acq_Rights_Template>
    {
        private readonly Acq_Rights_Template_Repository objRepository;

        public Acq_Rights_Template_Service(string Connection_Str)
        {
            this.objRepository = new Acq_Rights_Template_Repository(Connection_Str);
        }
        public IQueryable<Acq_Rights_Template> SearchFor(Expression<Func<Acq_Rights_Template, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Acq_Rights_Template GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public bool Save(Acq_Rights_Template obj, out dynamic resultSet)
        {
            return base.Save(obj, objRepository, out resultSet);
        }
        public bool Update(Acq_Rights_Template obj, out dynamic resultSet)
        {
            return base.Update(obj, objRepository, out resultSet);
        }
        public bool Delete(Acq_Rights_Template objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objRepository, out resultSet);
        }


        public override bool Validate(Acq_Rights_Template objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Acq_Rights_Template objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Acq_Rights_Template objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Supplementary_Service : BusinessLogic<Acq_Deal_Supplementary>
    {
        private readonly Acq_Deal_Supplementary_Repository objRepository;

        public Acq_Deal_Supplementary_Service(string Connection_Str)
        {
            this.objRepository = new Acq_Deal_Supplementary_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Supplementary> SearchFor(Expression<Func<Acq_Deal_Supplementary, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }
        public Acq_Deal_Supplementary GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public bool Save(Acq_Deal_Supplementary obj, out dynamic resultSet)
        {
            return base.Save(obj, objRepository, out resultSet);
        }
        public bool Update(Acq_Deal_Supplementary obj, out dynamic resultSet)
        {
            return base.Update(obj, objRepository, out resultSet);
        }
        public bool Delete(Acq_Deal_Supplementary objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objRepository, out resultSet);
        }
        public override bool Validate(Acq_Deal_Supplementary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Acq_Deal_Supplementary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateDelete(Acq_Deal_Supplementary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Acq_Deal_Digital_Service : BusinessLogic<Acq_Deal_Digital>
    {
        private readonly Acq_Deal_Digital_Repository objRepository;

        public Acq_Deal_Digital_Service(string Connection_Str)
        {
            this.objRepository = new Acq_Deal_Digital_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Digital> SearchFor(Expression<Func<Acq_Deal_Digital, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }
        public Acq_Deal_Digital GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public bool Save(Acq_Deal_Digital obj, out dynamic resultSet)
        {
            return base.Save(obj, objRepository, out resultSet);
        }
        public bool Update(Acq_Deal_Digital obj, out dynamic resultSet)
        {
            return base.Update(obj, objRepository, out resultSet);
        }
        public bool Delete(Acq_Deal_Digital objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objRepository, out resultSet);
        }
        public override bool Validate(Acq_Deal_Digital objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Acq_Deal_Digital objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateDelete(Acq_Deal_Digital objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Acq_Amendement_History_Service : BusinessLogic<Acq_Amendement_History>
    {
        private readonly Acq_Amendement_History_Repository objRepository;

        public Acq_Amendement_History_Service(string Connection_Str)
        {
            this.objRepository = new Acq_Amendement_History_Repository(Connection_Str);
        }
        public IQueryable<Acq_Amendement_History> SearchFor(Expression<Func<Acq_Amendement_History, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }
        public Acq_Amendement_History GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public bool Save(Acq_Amendement_History obj, out dynamic resultSet)
        {
            return base.Save(obj, objRepository, out resultSet);
        }
        public bool Update(Acq_Amendement_History obj, out dynamic resultSet)
        {
            return base.Update(obj, objRepository, out resultSet);
        }
        public bool Delete(Acq_Amendement_History objADM, out dynamic resultSet)
        {
            return base.Delete(objADM, objRepository, out resultSet);
        }
        public override bool Validate(Acq_Amendement_History objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Acq_Amendement_History objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateDelete(Acq_Amendement_History objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

}
