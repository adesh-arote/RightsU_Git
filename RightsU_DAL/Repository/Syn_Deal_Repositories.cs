using RightsU_Entities;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;

namespace RightsU_DAL
{
    public class Syn_Deal_Repository : RightsU_Repository<Syn_Deal>
    {
        public Syn_Deal_Repository(string conStr) : base(conStr) { }

        public override void Save(Syn_Deal objSD)
        {
            Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();

            if (objSD.Syn_Deal_Movie != null) objSD.Syn_Deal_Movie = objSaveEntities.SaveMovies(objSD.Syn_Deal_Movie, base.DataContext);            
            if (!objSD.SaveGeneralOnly)
            {
                if (objSD.Syn_Deal_Ancillary != null) objSD.Syn_Deal_Ancillary = objSaveEntities.SaveAncillary(objSD.Syn_Deal_Ancillary, base.DataContext);
                if (objSD.Syn_Deal_Rights != null) objSD.Syn_Deal_Rights = objSaveEntities.SaveRights(objSD.Syn_Deal_Rights, base.DataContext);                
                if (objSD.Syn_Deal_Revenue != null) objSD.Syn_Deal_Revenue = objSaveEntities.SaveRevenues(objSD.Syn_Deal_Revenue, base.DataContext);
                //if (objSD.Syn_Deal_Run != null) objSD.Syn_Deal_Run = objSaveEntities.SaveRuns(objSD.Syn_Deal_Run, base.DataContext);
                if (objSD.Syn_Deal_Run != null) objSD.Syn_Deal_Run = objSaveEntities.SaveRuns(objSD.Syn_Deal_Run, base.DataContext);
            }
            if (objSD.EntityState == State.Added)
            {
                base.Save(objSD);
            }
            else if (objSD.EntityState == State.Modified)
            {
                base.Update(objSD);
            }
            else if (objSD.EntityState == State.Deleted)
            {
                base.Delete(objSD);
            }
        }

        public override void Delete(Syn_Deal objSD)
        {

            Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
            objSaveEntities.DeleteMovies(objSD.Syn_Deal_Movie, base.DataContext);            
            objSaveEntities.DeleteAncillary(objSD.Syn_Deal_Ancillary, base.DataContext);
            objSaveEntities.DeleteRights(objSD.Syn_Deal_Rights, base.DataContext);            
            objSaveEntities.DeleteRevenues(objSD.Syn_Deal_Revenue, base.DataContext);
            //objSaveEntities.DeleteRuns(objSD.Syn_Deal_Run, base.DataContext);

            base.Delete(objSD);
        }
    }

    public class Syn_Deal_Ancillary_Repository : RightsU_Repository<Syn_Deal_Ancillary>
    {
        public Syn_Deal_Ancillary_Repository(string conStr) : base(conStr) { }

        public override void Save(Syn_Deal_Ancillary objADA)
        {
            ICollection<Syn_Deal_Ancillary> AncillaryList = new HashSet<Syn_Deal_Ancillary>();
            AncillaryList.Add(objADA);
            Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
            objADA = objSaveEntities.SaveAncillary(AncillaryList, base.DataContext).FirstOrDefault();

            if (objADA.EntityState == State.Added)
            {
                base.Save(AncillaryList.FirstOrDefault());
            }
            else if (objADA.EntityState == State.Modified)
            {
                base.Update(AncillaryList.FirstOrDefault());
            }
            else if (objADA.EntityState == State.Deleted)
            {
                base.Delete(AncillaryList.FirstOrDefault());
            }
            //return true;

        }

        public override void Delete(Syn_Deal_Ancillary objADA)
        {
            ICollection<Syn_Deal_Ancillary> deleteList = new HashSet<Syn_Deal_Ancillary>();
            deleteList.Add(objADA);
            Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
            objSaveEntities.DeleteAncillary(deleteList, base.DataContext);
            base.Delete(objADA);
        }
    }

    public class Syn_Deal_Movie_Repository : RightsU_Repository<Syn_Deal_Movie>
    {
        public Syn_Deal_Movie_Repository(string conStr) : base(conStr) { }

        public override void Save(Syn_Deal_Movie objADM)
        {
            ICollection<Syn_Deal_Movie> MovieList = new HashSet<Syn_Deal_Movie>();
            MovieList.Add(objADM);
            Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
            objADM = objSaveEntities.SaveMovies(MovieList, base.DataContext).FirstOrDefault();

            if (objADM.EntityState == State.Added)
            {
                base.Save(MovieList.FirstOrDefault());
            }
            else if (objADM.EntityState == State.Modified)
            {
                base.Update(MovieList.FirstOrDefault());
            }
            else if (objADM.EntityState == State.Deleted)
            {
                base.Delete(MovieList.FirstOrDefault());
            }
            //return true;

        }

        public override void Delete(Syn_Deal_Movie objADM)
        {
            ICollection<Syn_Deal_Movie> deleteList = new HashSet<Syn_Deal_Movie>();
            deleteList.Add(objADM);
            Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
            objSaveEntities.DeleteMovies(deleteList, base.DataContext);
            base.Delete(objADM);
        }
    }

    public class Syn_Deal_Rights_Repository : RightsU_Repository<Syn_Deal_Rights>
    {
        public Syn_Deal_Rights_Repository(string conStr) : base(conStr) { }

        public override void Save(Syn_Deal_Rights objADR)
        {
            ICollection<Syn_Deal_Rights> RightsList = new HashSet<Syn_Deal_Rights>();
            RightsList.Add(objADR);
            Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
            objADR = objSaveEntities.SaveRights(RightsList, base.DataContext).FirstOrDefault();

            if (objADR.EntityState == State.Added)
            {
                base.Save(RightsList.FirstOrDefault());
            }
            else if (objADR.EntityState == State.Modified)
            {
                base.Update(RightsList.FirstOrDefault());
            }
            else if (objADR.EntityState == State.Deleted)
            {
                base.Delete(RightsList.FirstOrDefault());
            }
        }

        public override void Delete(Syn_Deal_Rights objADR)
        {
            ICollection<Syn_Deal_Rights> deleteList = new HashSet<Syn_Deal_Rights>();
            deleteList.Add(objADR);
            Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
            objSaveEntities.DeleteRights(deleteList, base.DataContext);
            base.Delete(objADR);
        }
    }

    public class Syn_Deal_Rights_Title_Repository : RightsU_Repository<Syn_Deal_Rights_Title>
    {
        public Syn_Deal_Rights_Title_Repository(string conStr) : base(conStr) { }
    }

    public class Syn_Deal_Revenue_Repository : RightsU_Repository<Syn_Deal_Revenue>
    {
        public Syn_Deal_Revenue_Repository(string conStr) : base(conStr) { }

        public override void Save(Syn_Deal_Revenue objADR)
        {
            ICollection<Syn_Deal_Revenue> CostList = new HashSet<Syn_Deal_Revenue>();
            CostList.Add(objADR);
            Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
            objADR = objSaveEntities.SaveRevenues(CostList, base.DataContext).FirstOrDefault();

            if (objADR.EntityState == State.Added)
            {
                base.Save(CostList.FirstOrDefault());
            }
            else if (objADR.EntityState == State.Modified)
            {
                base.Update(CostList.FirstOrDefault());
            }
            else if (objADR.EntityState == State.Deleted)
            {
                base.Delete(CostList.FirstOrDefault());
            }
        }

        public override void Delete(Syn_Deal_Revenue objADC)
        {
            ICollection<Syn_Deal_Revenue> deleteList = new HashSet<Syn_Deal_Revenue>();
            deleteList.Add(objADC);
            Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
            objSaveEntities.DeleteRevenues(deleteList, base.DataContext);
            base.Delete(objADC);
        }
    }


    public class Syn_Deal_Run_Repository : RightsU_Repository<Syn_Deal_Run>
    {
        public Syn_Deal_Run_Repository(string conStr) : base(conStr) { }

        public override void Save(Syn_Deal_Run objSDR)
        {
            ICollection<Syn_Deal_Run> CostList = new HashSet<Syn_Deal_Run>();
            CostList.Add(objSDR);
            Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
            objSDR = objSaveEntities.SaveRuns(CostList, base.DataContext).FirstOrDefault();

            if (objSDR.EntityState == State.Added)
            {
                base.Save(CostList.FirstOrDefault());
            }
            else if (objSDR.EntityState == State.Modified)
            {
                base.Update(CostList.FirstOrDefault());
            }
            else if (objSDR.EntityState == State.Deleted)
            {
                base.Delete(CostList.FirstOrDefault());
            }
        }

        public override void Delete(Syn_Deal_Run objSDR)
        {
            ICollection<Syn_Deal_Run> deleteList = new HashSet<Syn_Deal_Run>();
            deleteList.Add(objSDR);
            Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
            objSaveEntities.DeleteRuns(deleteList, base.DataContext);
            base.Delete(objSDR);
        }
    }


    #region To be implemented later
    //public class Syn_Deal_Run_Repository : RightsU_Repository<Syn_Deal_Run>
    //{
    //    public Syn_Deal_Run_Repository(string conStr) : base(conStr) { }

    //    public override void Save(Syn_Deal_Run objADR)
    //    {
    //        ICollection<Syn_Deal_Run> RunsList = new HashSet<Syn_Deal_Run>();
    //        RunsList.Add(objADR);
    //        Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
    //        objADR = objSaveEntities.SaveRuns(RunsList, base.DataContext).FirstOrDefault();

    //        if (objADR.EntityState == State.Added)
    //        {
    //            base.Save(RunsList.FirstOrDefault());
    //        }
    //        else if (objADR.EntityState == State.Modified)
    //        {
    //            base.Update(RunsList.FirstOrDefault());
    //        }
    //        else if (objADR.EntityState == State.Deleted)
    //        {
    //            base.Delete(RunsList.FirstOrDefault());
    //        }
    //    }

    //    public override void Delete(Syn_Deal_Run objADR)
    //    {
    //        ICollection<Syn_Deal_Run> deleteList = new HashSet<Syn_Deal_Run>();
    //        deleteList.Add(objADR);
    //        Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
    //        objSaveEntities.DeleteRuns(deleteList, base.DataContext);
    //        base.Delete(objADR);
    //    }
    //}
    #endregion


    public class Syn_Deal_Material_Repository : RightsU_Repository<Syn_Deal_Material>
    {
        public Syn_Deal_Material_Repository(string conStr) : base(conStr) { }

        public override void Save(Syn_Deal_Material objADM)
        {
            ICollection<Syn_Deal_Material> MaterialList = new HashSet<Syn_Deal_Material>();
            MaterialList.Add(objADM);

            if (objADM.EntityState == State.Added)
            {
                base.Save(MaterialList.FirstOrDefault());
            }
            else if (objADM.EntityState == State.Modified)
            {
                base.Update(MaterialList.FirstOrDefault());
            }
            else if (objADM.EntityState == State.Deleted)
            {
                base.Delete(MaterialList.FirstOrDefault());
            }
        }
    }

    public class Syn_Deal_Attachment_Repository : RightsU_Repository<Syn_Deal_Attachment>
    {
        public Syn_Deal_Attachment_Repository(string conStr) : base(conStr) { }

        public override void Save(Syn_Deal_Attachment objADA)
        {
            ICollection<Syn_Deal_Attachment> attachmentList = new HashSet<Syn_Deal_Attachment>();
            attachmentList.Add(objADA);

            if (objADA.EntityState == State.Added)
            {
                base.Save(attachmentList.FirstOrDefault());
            }
            else if (objADA.EntityState == State.Modified)
            {
                base.Update(attachmentList.FirstOrDefault());
            }
            else if (objADA.EntityState == State.Deleted)
            {
                base.Delete(attachmentList.FirstOrDefault());
            }
        }
    }

    public class Syn_Deal_Payment_Terms_Repository : RightsU_Repository<Syn_Deal_Payment_Terms>
    {
        public Syn_Deal_Payment_Terms_Repository(string conStr) : base(conStr) { }

        public override void Save(Syn_Deal_Payment_Terms objADPT)
        {
            ICollection<Syn_Deal_Payment_Terms> ptList = new HashSet<Syn_Deal_Payment_Terms>();
            ptList.Add(objADPT);

            if (objADPT.EntityState == State.Added)
            {
                base.Save(ptList.FirstOrDefault());
            }
            else if (objADPT.EntityState == State.Modified)
            {
                base.Update(ptList.FirstOrDefault());
            }
            else if (objADPT.EntityState == State.Deleted)
            {
                base.Delete(ptList.FirstOrDefault());
            }
        }
    }

    public class Syn_Acq_Mapping_Repository : RightsU_Repository<Syn_Acq_Mapping>
    {
        public Syn_Acq_Mapping_Repository(string conStr) : base(conStr) { }

        public override void Save(Syn_Acq_Mapping objADPT)
        {
            ICollection<Syn_Acq_Mapping> ptList = new HashSet<Syn_Acq_Mapping>();
            ptList.Add(objADPT);

            if (objADPT.EntityState == State.Added)
            {
                base.Save(ptList.FirstOrDefault());
            }
            else if (objADPT.EntityState == State.Modified)
            {
                base.Update(ptList.FirstOrDefault());
            }
            else if (objADPT.EntityState == State.Deleted)
            {
                base.Delete(ptList.FirstOrDefault());
            }
        }
    }


    public class Save_Syn_Deal_Entities_Generic
    {
        public ICollection<Syn_Deal_Movie> SaveMovies(ICollection<Syn_Deal_Movie> entityMovies, DbContext dbContext)
        {
            ICollection<Syn_Deal_Movie> UpdatedMovies = entityMovies;

            UpdatedMovies = new Save_Entitiy_Lists_Generic<Syn_Deal_Movie>().SetListFlagsCUD(UpdatedMovies, dbContext);

            return UpdatedMovies;
        }
        public void DeleteMovies(ICollection<Syn_Deal_Movie> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.Syn_Deal_Movie.RemoveRange(deleteList);
        }

        public ICollection<Syn_Deal_Ancillary> SaveAncillary(ICollection<Syn_Deal_Ancillary> entityAncillary, DbContext dbContext)
        {
            ICollection<Syn_Deal_Ancillary> UpdatedAncillary = entityAncillary;


            foreach (Syn_Deal_Ancillary objADA in UpdatedAncillary)
            {
                objADA.Syn_Deal_Ancillary_Title = new Save_Entitiy_Lists_Generic<Syn_Deal_Ancillary_Title>().SetListFlagsCUD(objADA.Syn_Deal_Ancillary_Title, dbContext);

                foreach (Syn_Deal_Ancillary_Platform objADAP in objADA.Syn_Deal_Ancillary_Platform)
                {
                    objADAP.Syn_Deal_Ancillary_Platform_Medium = new Save_Entitiy_Lists_Generic<Syn_Deal_Ancillary_Platform_Medium>().SetListFlagsCUD(objADAP.Syn_Deal_Ancillary_Platform_Medium, dbContext);
                }

                objADA.Syn_Deal_Ancillary_Platform = new Save_Entitiy_Lists_Generic<Syn_Deal_Ancillary_Platform>().SetListFlagsCUD(objADA.Syn_Deal_Ancillary_Platform, dbContext);
            }

            UpdatedAncillary = new Save_Entitiy_Lists_Generic<Syn_Deal_Ancillary>().SetListFlagsCUD(UpdatedAncillary, dbContext);
            return UpdatedAncillary;
        }
        public void DeleteAncillary(ICollection<Syn_Deal_Ancillary> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Syn_Deal_Ancillary objADA in deleteList)
            {
                dbContext.Syn_Deal_Ancillary_Title.RemoveRange(objADA.Syn_Deal_Ancillary_Title);

                foreach (Syn_Deal_Ancillary_Platform objADAP in objADA.Syn_Deal_Ancillary_Platform)
                {
                    dbContext.Syn_Deal_Ancillary_Platform_Medium.RemoveRange(objADAP.Syn_Deal_Ancillary_Platform_Medium);
                }

                dbContext.Syn_Deal_Ancillary_Platform.RemoveRange(objADA.Syn_Deal_Ancillary_Platform);
            }

            dbContext.Syn_Deal_Ancillary.RemoveRange(deleteList);
        }

        public ICollection<Syn_Deal_Rights> SaveRights(ICollection<Syn_Deal_Rights> entityRights, DbContext dbContext)
        {
            ICollection<Syn_Deal_Rights> UpdatedRights = entityRights;

            foreach (Syn_Deal_Rights objDr in UpdatedRights)
            {
                new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Title>().SetListFlagsCUD(objDr.Syn_Deal_Rights_Title, dbContext);
                new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Platform>().SetListFlagsCUD(objDr.Syn_Deal_Rights_Platform, dbContext);
                new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Territory>().SetListFlagsCUD(objDr.Syn_Deal_Rights_Territory, dbContext);
                new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Subtitling>().SetListFlagsCUD(objDr.Syn_Deal_Rights_Subtitling, dbContext);
                new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Dubbing>().SetListFlagsCUD(objDr.Syn_Deal_Rights_Dubbing, dbContext);

                foreach (Syn_Deal_Rights_Blackout objADRH in objDr.Syn_Deal_Rights_Blackout)
                {
                    new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Blackout_Platform>().SetListFlagsCUD(objADRH.Syn_Deal_Rights_Blackout_Platform, dbContext);
                    new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Blackout_Territory>().SetListFlagsCUD(objADRH.Syn_Deal_Rights_Blackout_Territory, dbContext);
                    new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Blackout_Subtitling>().SetListFlagsCUD(objADRH.Syn_Deal_Rights_Blackout_Subtitling, dbContext);
                    new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Blackout_Dubbing>().SetListFlagsCUD(objADRH.Syn_Deal_Rights_Blackout_Dubbing, dbContext);
                }
                new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Blackout>().SetListFlagsCUD(objDr.Syn_Deal_Rights_Blackout, dbContext);

                foreach (Syn_Deal_Rights_Holdback objADRH in objDr.Syn_Deal_Rights_Holdback)
                {
                    new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Holdback_Platform>().SetListFlagsCUD(objADRH.Syn_Deal_Rights_Holdback_Platform, dbContext);
                    new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Holdback_Territory>().SetListFlagsCUD(objADRH.Syn_Deal_Rights_Holdback_Territory, dbContext);
                    new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Holdback_Subtitling>().SetListFlagsCUD(objADRH.Syn_Deal_Rights_Holdback_Subtitling, dbContext);
                    new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Holdback_Dubbing>().SetListFlagsCUD(objADRH.Syn_Deal_Rights_Holdback_Dubbing, dbContext);
                }
                new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Holdback>().SetListFlagsCUD(objDr.Syn_Deal_Rights_Holdback, dbContext);

                foreach (Syn_Deal_Rights_Promoter objSDRP in objDr.Syn_Deal_Rights_Promoter)
                {
                    new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Promoter_Group>().SetListFlagsCUD(objSDRP.Syn_Deal_Rights_Promoter_Group, dbContext);
                    new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Promoter_Remarks>().SetListFlagsCUD(objSDRP.Syn_Deal_Rights_Promoter_Remarks, dbContext);
                }
                new Save_Entitiy_Lists_Generic<Syn_Deal_Rights_Promoter>().SetListFlagsCUD(objDr.Syn_Deal_Rights_Promoter, dbContext);
            }

            UpdatedRights = new Save_Entitiy_Lists_Generic<Syn_Deal_Rights>().SetListFlagsCUD(UpdatedRights, dbContext);
            return UpdatedRights;
        }
        public void DeleteRights(ICollection<Syn_Deal_Rights> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Syn_Deal_Rights objADR in deleteList)
            {
                dbContext.Syn_Deal_Rights_Title.RemoveRange(objADR.Syn_Deal_Rights_Title);
                dbContext.Syn_Deal_Rights_Platform.RemoveRange(objADR.Syn_Deal_Rights_Platform);
                dbContext.Syn_Deal_Rights_Territory.RemoveRange(objADR.Syn_Deal_Rights_Territory);
                dbContext.Syn_Deal_Rights_Subtitling.RemoveRange(objADR.Syn_Deal_Rights_Subtitling);
                dbContext.Syn_Deal_Rights_Dubbing.RemoveRange(objADR.Syn_Deal_Rights_Dubbing);

                foreach (Syn_Deal_Rights_Holdback objADRH in objADR.Syn_Deal_Rights_Holdback)
                {
                    dbContext.Syn_Deal_Rights_Holdback_Platform.RemoveRange(objADRH.Syn_Deal_Rights_Holdback_Platform);
                    dbContext.Syn_Deal_Rights_Holdback_Territory.RemoveRange(objADRH.Syn_Deal_Rights_Holdback_Territory);
                    dbContext.Syn_Deal_Rights_Holdback_Subtitling.RemoveRange(objADRH.Syn_Deal_Rights_Holdback_Subtitling);
                    dbContext.Syn_Deal_Rights_Holdback_Dubbing.RemoveRange(objADRH.Syn_Deal_Rights_Holdback_Dubbing);
                }
                dbContext.Syn_Deal_Rights_Holdback.RemoveRange(objADR.Syn_Deal_Rights_Holdback);

                foreach (Syn_Deal_Rights_Blackout objADRB in objADR.Syn_Deal_Rights_Blackout)
                {
                    dbContext.Syn_Deal_Rights_Blackout_Platform.RemoveRange(objADRB.Syn_Deal_Rights_Blackout_Platform);
                    dbContext.Syn_Deal_Rights_Blackout_Territory.RemoveRange(objADRB.Syn_Deal_Rights_Blackout_Territory);
                    dbContext.Syn_Deal_Rights_Blackout_Subtitling.RemoveRange(objADRB.Syn_Deal_Rights_Blackout_Subtitling);
                    dbContext.Syn_Deal_Rights_Blackout_Dubbing.RemoveRange(objADRB.Syn_Deal_Rights_Blackout_Dubbing);
                }
                dbContext.Syn_Deal_Rights_Blackout.RemoveRange(objADR.Syn_Deal_Rights_Blackout);


                foreach (Syn_Deal_Rights_Promoter objSDRP in objADR.Syn_Deal_Rights_Promoter)
                {
                    dbContext.Syn_Deal_Rights_Promoter_Group.RemoveRange(objSDRP.Syn_Deal_Rights_Promoter_Group);
                    dbContext.Syn_Deal_Rights_Promoter_Remarks.RemoveRange(objSDRP.Syn_Deal_Rights_Promoter_Remarks);
                }
                dbContext.Syn_Deal_Rights_Promoter.RemoveRange(objADR.Syn_Deal_Rights_Promoter);
            }

            dbContext.Syn_Deal_Rights.RemoveRange(deleteList);
        }

        public ICollection<Syn_Deal_Revenue> SaveRevenues(ICollection<Syn_Deal_Revenue> entityCosts, DbContext dbContext)
        {
            ICollection<Syn_Deal_Revenue> UpdatedCosts = entityCosts;

            foreach (Syn_Deal_Revenue objADC in UpdatedCosts)
            {
                objADC.Syn_Deal_Revenue_Title = new Save_Entitiy_Lists_Generic<Syn_Deal_Revenue_Title>().SetListFlagsCUD(objADC.Syn_Deal_Revenue_Title, dbContext);

                objADC.Syn_Deal_Revenue_Platform = new Save_Entitiy_Lists_Generic<Syn_Deal_Revenue_Platform>().SetListFlagsCUD(objADC.Syn_Deal_Revenue_Platform, dbContext);

                objADC.Syn_Deal_Revenue_Additional_Exp = (objADC.Syn_Deal_Revenue_Additional_Exp != null) ? new Save_Entitiy_Lists_Generic<Syn_Deal_Revenue_Additional_Exp>().SetListFlagsCUD(objADC.Syn_Deal_Revenue_Additional_Exp, dbContext) : null;

                objADC.Syn_Deal_Revenue_Commission = (objADC.Syn_Deal_Revenue_Commission != null) ? new Save_Entitiy_Lists_Generic<Syn_Deal_Revenue_Commission>().SetListFlagsCUD(objADC.Syn_Deal_Revenue_Commission, dbContext) : null;

                objADC.Syn_Deal_Revenue_Variable_Cost = (objADC.Syn_Deal_Revenue_Variable_Cost != null) ? new Save_Entitiy_Lists_Generic<Syn_Deal_Revenue_Variable_Cost>().SetListFlagsCUD(objADC.Syn_Deal_Revenue_Variable_Cost, dbContext) : null;

                foreach (Syn_Deal_Revenue_Costtype objADCC in objADC.Syn_Deal_Revenue_Costtype)
                {
                    objADCC.Syn_Deal_Revenue_Costtype_Episode = new Save_Entitiy_Lists_Generic<Syn_Deal_Revenue_Costtype_Episode>().SetListFlagsCUD(objADCC.Syn_Deal_Revenue_Costtype_Episode, dbContext);
                }

                objADC.Syn_Deal_Revenue_Costtype = new Save_Entitiy_Lists_Generic<Syn_Deal_Revenue_Costtype>().SetListFlagsCUD(objADC.Syn_Deal_Revenue_Costtype, dbContext);
            }

            UpdatedCosts = new Save_Entitiy_Lists_Generic<Syn_Deal_Revenue>().SetListFlagsCUD(UpdatedCosts, dbContext);

            return UpdatedCosts;
        }
        public void DeleteRevenues(ICollection<Syn_Deal_Revenue> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Syn_Deal_Revenue objADC in deleteList)
            {
                dbContext.Syn_Deal_Revenue_Title.RemoveRange(objADC.Syn_Deal_Revenue_Title);
                dbContext.Syn_Deal_Revenue_Platform.RemoveRange(objADC.Syn_Deal_Revenue_Platform);
                dbContext.Syn_Deal_Revenue_Additional_Exp.RemoveRange(objADC.Syn_Deal_Revenue_Additional_Exp);
                dbContext.Syn_Deal_Revenue_Commission.RemoveRange(objADC.Syn_Deal_Revenue_Commission);
                dbContext.Syn_Deal_Revenue_Variable_Cost.RemoveRange(objADC.Syn_Deal_Revenue_Variable_Cost);

                foreach (Syn_Deal_Revenue_Costtype objADCC in objADC.Syn_Deal_Revenue_Costtype)
                {
                    dbContext.Syn_Deal_Revenue_Costtype_Episode.RemoveRange(objADCC.Syn_Deal_Revenue_Costtype_Episode);
                }

                dbContext.Syn_Deal_Revenue_Costtype.RemoveRange(objADC.Syn_Deal_Revenue_Costtype);
            }
            dbContext.Syn_Deal_Revenue.RemoveRange(deleteList);
        }


        public ICollection<Syn_Deal_Run> SaveRuns(ICollection<Syn_Deal_Run> entityCosts, DbContext dbContext)
        {
            ICollection<Syn_Deal_Run> UpdatedRuns = entityCosts;

            foreach (Syn_Deal_Run objSDR in UpdatedRuns)
            {
                objSDR.Syn_Deal_Run_Platform = new Save_Entitiy_Lists_Generic<Syn_Deal_Run_Platform>().SetListFlagsCUD(objSDR.Syn_Deal_Run_Platform, dbContext);
                objSDR.Syn_Deal_Run_Yearwise_Run = (objSDR.Syn_Deal_Run_Yearwise_Run != null) ? new Save_Entitiy_Lists_Generic<Syn_Deal_Run_Yearwise_Run>().SetListFlagsCUD(objSDR.Syn_Deal_Run_Yearwise_Run, dbContext) : null;
                objSDR.Syn_Deal_Run_Repeat_On_Day = (objSDR.Syn_Deal_Run_Repeat_On_Day != null) ? new Save_Entitiy_Lists_Generic<Syn_Deal_Run_Repeat_On_Day>().SetListFlagsCUD(objSDR.Syn_Deal_Run_Repeat_On_Day, dbContext) : null;
            }
            UpdatedRuns = new Save_Entitiy_Lists_Generic<Syn_Deal_Run>().SetListFlagsCUD(UpdatedRuns, dbContext);

            return UpdatedRuns;
        }
        public void DeleteRuns(ICollection<Syn_Deal_Run> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Syn_Deal_Run objSDR in deleteList)
            {
                dbContext.Syn_Deal_Run_Platform.RemoveRange(objSDR.Syn_Deal_Run_Platform);
                dbContext.Syn_Deal_Run_Yearwise_Run.RemoveRange(objSDR.Syn_Deal_Run_Yearwise_Run);
                dbContext.Syn_Deal_Run_Repeat_On_Day.RemoveRange(objSDR.Syn_Deal_Run_Repeat_On_Day);
            }
            dbContext.Syn_Deal_Run.RemoveRange(deleteList);
        }


        #region To be implemented later
        //public ICollection<Syn_Deal_Run> SaveRuns(ICollection<Syn_Deal_Run> entitySaveRuns, DbContext dbContext)
        //{
        //    ICollection<Syn_Deal_Run> UpdatedRuns = entitySaveRuns;

        //    foreach (Syn_Deal_Run objADR in UpdatedRuns)
        //    {
        //        objADR.Syn_Deal_Run_Channel = (objADR.Syn_Deal_Run_Channel != null) ? new Save_Entitiy_Lists_Generic<Syn_Deal_Run_Channel>().SetListFlagsCUD(objADR.Syn_Deal_Run_Channel, dbContext) : null;

        //        objADR.Syn_Deal_Run_Repeat_On_Day = (objADR.Syn_Deal_Run_Repeat_On_Day != null) ? new Save_Entitiy_Lists_Generic<Syn_Deal_Run_Repeat_On_Day>().SetListFlagsCUD(objADR.Syn_Deal_Run_Repeat_On_Day, dbContext) : null;

        //        objADR.Syn_Deal_Run_Title = new Save_Entitiy_Lists_Generic<Syn_Deal_Run_Title>().SetListFlagsCUD(objADR.Syn_Deal_Run_Title, dbContext);

        //        if (objADR.Syn_Deal_Run_Yearwise_Run != null)
        //        {
        //            foreach (Syn_Deal_Run_Yearwise_Run objADRYR in objADR.Syn_Deal_Run_Yearwise_Run)
        //            {
        //                objADRYR.Syn_Deal_Run_Yearwise_Run_Week = new Save_Entitiy_Lists_Generic<Syn_Deal_Run_Yearwise_Run_Week>().SetListFlagsCUD(objADRYR.Syn_Deal_Run_Yearwise_Run_Week, dbContext);
        //            }
        //        }

        //        objADR.Syn_Deal_Run_Yearwise_Run = (objADR.Syn_Deal_Run_Yearwise_Run != null) ? new Save_Entitiy_Lists_Generic<Syn_Deal_Run_Yearwise_Run>().SetListFlagsCUD(objADR.Syn_Deal_Run_Yearwise_Run, dbContext) : null;


        //    }

        //    UpdatedRuns = new Save_Entitiy_Lists_Generic<Syn_Deal_Run>().SetListFlagsCUD(UpdatedRuns, dbContext);

        //    return UpdatedRuns;
        //}
        //public void DeleteRuns(ICollection<Syn_Deal_Run> deleteList, RightsU_NeoEntities dbContext)
        //{
        //    foreach (Syn_Deal_Run objADR in deleteList)
        //    {
        //        dbContext.Syn_Deal_Run_Channel.RemoveRange(objADR.Syn_Deal_Run_Channel);
        //        dbContext.Syn_Deal_Run_Repeat_On_Day.RemoveRange(objADR.Syn_Deal_Run_Repeat_On_Day);
        //        dbContext.Syn_Deal_Run_Title.RemoveRange(objADR.Syn_Deal_Run_Title);
        //        foreach (Syn_Deal_Run_Yearwise_Run objADRYR in objADR.Syn_Deal_Run_Yearwise_Run)
        //        {
        //            dbContext.Syn_Deal_Run_Yearwise_Run_Week.RemoveRange(objADRYR.Syn_Deal_Run_Yearwise_Run_Week);
        //        }
        //        dbContext.Syn_Deal_Run_Yearwise_Run.RemoveRange(objADR.Syn_Deal_Run_Yearwise_Run);
        //    }
        //    dbContext.Syn_Deal_Run.RemoveRange(deleteList);
        //}
        #endregion

        public ICollection<Syn_Deal_Supplementary> SaveSupplementary(ICollection<Syn_Deal_Supplementary> entitySaveSupplementary, DbContext dbContext)
        {
            ICollection<Syn_Deal_Supplementary> UpdatedSupplementary = entitySaveSupplementary;

            foreach (Syn_Deal_Supplementary objADR in UpdatedSupplementary)
            {
                objADR.Syn_Deal_Supplementary_Detail = (objADR.Syn_Deal_Supplementary_Detail != null) ? new Save_Entitiy_Lists_Generic<Syn_Deal_Supplementary_Detail>().SetListFlagsCUD(objADR.Syn_Deal_Supplementary_Detail, dbContext) : null;
            }

            UpdatedSupplementary = new Save_Entitiy_Lists_Generic<Syn_Deal_Supplementary>().SetListFlagsCUD(UpdatedSupplementary, dbContext);

            return UpdatedSupplementary;
        }
        public ICollection<Syn_Deal_Digital> SaveDigital(ICollection<Syn_Deal_Digital> entitySaveDigital, DbContext dbContext)
        {
            ICollection<Syn_Deal_Digital> UpdatedDigital = entitySaveDigital;

            foreach (Syn_Deal_Digital objADR in UpdatedDigital)
            {
                objADR.Syn_Deal_Digital_Detail = (objADR.Syn_Deal_Digital_Detail != null) ? new Save_Entitiy_Lists_Generic<Syn_Deal_Digital_Detail>().SetListFlagsCUD(objADR.Syn_Deal_Digital_Detail, dbContext) : null;
            }

            UpdatedDigital = new Save_Entitiy_Lists_Generic<Syn_Deal_Digital>().SetListFlagsCUD(UpdatedDigital, dbContext);

            return UpdatedDigital;
        }
    }

    public class Syn_Deal_Supplementary_Repository : RightsU_Repository<Syn_Deal_Supplementary>
    {
        public Syn_Deal_Supplementary_Repository(string conStr) : base(conStr) { }

        public override void Save(Syn_Deal_Supplementary obj)
        {
            ICollection<Syn_Deal_Supplementary> list = new HashSet<Syn_Deal_Supplementary>();
            list.Add(obj);

            Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
            obj = objSaveEntities.SaveSupplementary(list, base.DataContext).FirstOrDefault();

            if (obj.EntityState == State.Added)
            {
                base.Save(list.FirstOrDefault());
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(list.FirstOrDefault());
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(list.FirstOrDefault());
            }
        }
    }
    public class Syn_Deal_Digital_Repository : RightsU_Repository<Syn_Deal_Digital>
    {
        public Syn_Deal_Digital_Repository(string conStr) : base(conStr) { }

        public override void Save(Syn_Deal_Digital obj)
        {
            ICollection<Syn_Deal_Digital> list = new HashSet<Syn_Deal_Digital>();
            list.Add(obj);

            Save_Syn_Deal_Entities_Generic objSaveEntities = new Save_Syn_Deal_Entities_Generic();
            obj = objSaveEntities.SaveDigital(list, base.DataContext).FirstOrDefault();

            if (obj.EntityState == State.Added)
            {
                base.Save(list.FirstOrDefault());
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(list.FirstOrDefault());
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(list.FirstOrDefault());
            }
        }
    }
}
