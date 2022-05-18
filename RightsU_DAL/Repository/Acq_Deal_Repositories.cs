using RightsU_Entities;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Data.Entity.Core;
using System.Data.Entity.Core.Objects;

namespace RightsU_DAL
{
    public class Acq_Deal_Repository : RightsU_Repository<Acq_Deal>
    {
        public Acq_Deal_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal objAD)
        {
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();

            if (objAD.Acq_Deal_Movie != null) objAD.Acq_Deal_Movie = objSaveEntities.SaveMovies(objAD.Acq_Deal_Movie, base.DataContext);
            if (objAD.Acq_Deal_Licensor != null) objAD.Acq_Deal_Licensor = objSaveEntities.SaveLicensors(objAD.Acq_Deal_Licensor, base.DataContext);
            if (!objAD.SaveGeneralOnly)
            {
                if (objAD.Acq_Deal_Ancillary != null) objAD.Acq_Deal_Ancillary = objSaveEntities.SaveAncillary(objAD.Acq_Deal_Ancillary, base.DataContext);
                if (objAD.Acq_Deal_Rights != null) objAD.Acq_Deal_Rights = objSaveEntities.SaveRights(objAD.Acq_Deal_Rights, base.DataContext);
                if (objAD.Acq_Deal_Pushback != null) objAD.Acq_Deal_Pushback = objSaveEntities.SavePushbacks(objAD.Acq_Deal_Pushback, base.DataContext);
                if (objAD.Acq_Deal_Cost != null) objAD.Acq_Deal_Cost = objSaveEntities.SaveCosts(objAD.Acq_Deal_Cost, base.DataContext);
                if (objAD.Acq_Deal_Run != null) objAD.Acq_Deal_Run = objSaveEntities.SaveRuns(objAD.Acq_Deal_Run, base.DataContext);
                if (objAD.Acq_Deal_Sport != null) objAD.Acq_Deal_Sport = objSaveEntities.SaveSportRights(objAD.Acq_Deal_Sport, base.DataContext);
                if (objAD.Acq_Deal_Sport_Ancillary != null) objAD.Acq_Deal_Sport_Ancillary = objSaveEntities.SaveSportAncillary(objAD.Acq_Deal_Sport_Ancillary, base.DataContext);
                if (objAD.Acq_Deal_Sport_Monetisation_Ancillary != null) objAD.Acq_Deal_Sport_Monetisation_Ancillary = objSaveEntities.SaveSportMonetisationAncillary(objAD.Acq_Deal_Sport_Monetisation_Ancillary, base.DataContext);
                if (objAD.Acq_Deal_Sport_Sales_Ancillary != null) objAD.Acq_Deal_Sport_Sales_Ancillary = objSaveEntities.SaveSportSalesAncillary(objAD.Acq_Deal_Sport_Sales_Ancillary, base.DataContext);
            }
            if (objAD.EntityState == State.Added)
            {
                base.Save(objAD);
            }
            else if (objAD.EntityState == State.Modified)
            {
                base.Update(objAD);
            }
            else if (objAD.EntityState == State.Deleted)
            {
                base.Delete(objAD);
            }
        }

        public override void Delete(Acq_Deal objAD)
        {

            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objSaveEntities.DeleteMovies(objAD.Acq_Deal_Movie, base.DataContext);
            objSaveEntities.DeleteLicensors(objAD.Acq_Deal_Licensor, base.DataContext);
            objSaveEntities.DeleteAncillary(objAD.Acq_Deal_Ancillary, base.DataContext);
            objSaveEntities.DeleteRights(objAD.Acq_Deal_Rights, base.DataContext);
            objSaveEntities.DeletePushbacks(objAD.Acq_Deal_Pushback, base.DataContext);
            objSaveEntities.DeleteCosts(objAD.Acq_Deal_Cost, base.DataContext);
            objSaveEntities.DeleteRuns(objAD.Acq_Deal_Run, base.DataContext);
            objSaveEntities.DeleteSportAncillary(objAD.Acq_Deal_Sport_Ancillary, base.DataContext);
            objSaveEntities.DeleteSportMonetisationAncillary(objAD.Acq_Deal_Sport_Monetisation_Ancillary, base.DataContext);
            objSaveEntities.DeleteSportSalesAncillary(objAD.Acq_Deal_Sport_Sales_Ancillary, base.DataContext);
            base.Delete(objAD);

        }
    }

    public class Acq_Deal_Ancillary_Repository : RightsU_Repository<Acq_Deal_Ancillary>
    {
        public Acq_Deal_Ancillary_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Ancillary objADA)
        {
            ICollection<Acq_Deal_Ancillary> AncillaryList = new HashSet<Acq_Deal_Ancillary>();
            AncillaryList.Add(objADA);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
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

        public override void Delete(Acq_Deal_Ancillary objADA)
        {
            ICollection<Acq_Deal_Ancillary> deleteList = new HashSet<Acq_Deal_Ancillary>();
            deleteList.Add(objADA);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objSaveEntities.DeleteAncillary(deleteList, base.DataContext);
            base.Delete(objADA);
        }
    }

    public class Acq_Deal_Licensor_Repository : RightsU_Repository<Acq_Deal_Licensor>
    {
        public Acq_Deal_Licensor_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Licensor objADL)
        {
            ICollection<Acq_Deal_Licensor> LicensorList = new HashSet<Acq_Deal_Licensor>();
            LicensorList.Add(objADL);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objADL = objSaveEntities.SaveLicensors(LicensorList, base.DataContext).FirstOrDefault();

            if (objADL.EntityState == State.Added)
            {
                base.Save(LicensorList.FirstOrDefault());
            }
            else if (objADL.EntityState == State.Modified)
            {
                base.Update(LicensorList.FirstOrDefault());
            }
            else if (objADL.EntityState == State.Deleted)
            {
                base.Delete(LicensorList.FirstOrDefault());
            }
            //return true;

        }

        public override void Delete(Acq_Deal_Licensor objADL)
        {
            ICollection<Acq_Deal_Licensor> deleteList = new HashSet<Acq_Deal_Licensor>();
            deleteList.Add(objADL);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objSaveEntities.DeleteLicensors(deleteList, base.DataContext);
            base.Delete(objADL);
        }
    }

    public class Acq_Deal_Movie_Repository : RightsU_Repository<Acq_Deal_Movie>
    {
        public Acq_Deal_Movie_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Movie objADM)
        {
            ICollection<Acq_Deal_Movie> MovieList = new HashSet<Acq_Deal_Movie>();
            MovieList.Add(objADM);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
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

        public override void Delete(Acq_Deal_Movie objADM)
        {
            ICollection<Acq_Deal_Movie> deleteList = new HashSet<Acq_Deal_Movie>();
            deleteList.Add(objADM);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objSaveEntities.DeleteMovies(deleteList, base.DataContext);
            base.Delete(objADM);
        }
    }

    public class Acq_Deal_Rights_Repository : RightsU_Repository<Acq_Deal_Rights>
    {
        public Acq_Deal_Rights_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Rights objADR)
        {
            ICollection<Acq_Deal_Rights> RightsList = new HashSet<Acq_Deal_Rights>();
            RightsList.Add(objADR);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
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

        public override void Delete(Acq_Deal_Rights objADR)
        {
            ICollection<Acq_Deal_Rights> deleteList = new HashSet<Acq_Deal_Rights>();
            deleteList.Add(objADR);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objSaveEntities.DeleteRights(deleteList, base.DataContext);
            base.Delete(objADR);
        }
    }

    public class Acq_Deal_Rights_Territory_Repository : RightsU_Repository<Acq_Deal_Rights_Territory>
    {
        public Acq_Deal_Rights_Territory_Repository(string conStr) : base(conStr) { }
    }

    public class Acq_Deal_Pushback_Repository : RightsU_Repository<Acq_Deal_Pushback>
    {
        public Acq_Deal_Pushback_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Pushback objADR)
        {
            ICollection<Acq_Deal_Pushback> PushBackList = new HashSet<Acq_Deal_Pushback>();
            PushBackList.Add(objADR);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objADR = objSaveEntities.SavePushbacks(PushBackList, base.DataContext).FirstOrDefault();

            if (objADR.EntityState == State.Added)
            {
                base.Save(PushBackList.FirstOrDefault());
            }
            else if (objADR.EntityState == State.Modified)
            {
                base.Update(PushBackList.FirstOrDefault());
            }
            else if (objADR.EntityState == State.Deleted)
            {
                base.Delete(PushBackList.FirstOrDefault());
            }
        }

        public override void Delete(Acq_Deal_Pushback objADP)
        {
            ICollection<Acq_Deal_Pushback> deleteList = new HashSet<Acq_Deal_Pushback>();
            deleteList.Add(objADP);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objSaveEntities.DeletePushbacks(deleteList, base.DataContext);
            base.Delete(objADP);
        }
    }

    public class Acq_Deal_Pushback_Territory_Repository : RightsU_Repository<Acq_Deal_Pushback_Territory>
    {
        public Acq_Deal_Pushback_Territory_Repository(string conStr) : base(conStr) { }
    }

    public class Acq_Deal_Cost_Repository : RightsU_Repository<Acq_Deal_Cost>
    {
        public Acq_Deal_Cost_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Cost objADR)
        {
            ICollection<Acq_Deal_Cost> CostList = new HashSet<Acq_Deal_Cost>();
            CostList.Add(objADR);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objADR = objSaveEntities.SaveCosts(CostList, base.DataContext).FirstOrDefault();

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

        public override void Delete(Acq_Deal_Cost objADC)
        {
            ICollection<Acq_Deal_Cost> deleteList = new HashSet<Acq_Deal_Cost>();
            deleteList.Add(objADC);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objSaveEntities.DeleteCosts(deleteList, base.DataContext);
            base.Delete(objADC);
        }
    }

    public class Acq_Deal_Tab_Version_Repository : RightsU_Repository<Acq_Deal_Tab_Version>
    {
        public Acq_Deal_Tab_Version_Repository(string conStr) : base(conStr) { }
    }


    public class Acq_Deal_Run_Repository : RightsU_Repository<Acq_Deal_Run>
    {
        public Acq_Deal_Run_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Run objADR)
        {
            ICollection<Acq_Deal_Run> RunsList = new HashSet<Acq_Deal_Run>();
            RunsList.Add(objADR);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objADR = objSaveEntities.SaveRuns(RunsList, base.DataContext).FirstOrDefault();

            if (objADR.EntityState == State.Added)
            {
                base.Save(RunsList.FirstOrDefault());
            }
            else if (objADR.EntityState == State.Modified)
            {
                base.Update(RunsList.FirstOrDefault());
            }
            else if (objADR.EntityState == State.Deleted)
            {
                base.Delete(RunsList.FirstOrDefault());
            }
        }

        public override void Delete(Acq_Deal_Run objADR)
        {
            ICollection<Acq_Deal_Run> deleteList = new HashSet<Acq_Deal_Run>();
            deleteList.Add(objADR);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objSaveEntities.DeleteRuns(deleteList, base.DataContext);
            base.Delete(objADR);
        }
    }

    public class Acq_Deal_Sport_Repository : RightsU_Repository<Acq_Deal_Sport>
    {
        public Acq_Deal_Sport_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Sport objADRS)
        {
            ICollection<Acq_Deal_Sport> SportsList = new HashSet<Acq_Deal_Sport>();
            SportsList.Add(objADRS);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objADRS = objSaveEntities.SaveSportRights(SportsList, base.DataContext).FirstOrDefault();

            if (objADRS.EntityState == State.Added)
            {
                base.Save(SportsList.FirstOrDefault());
            }
            else if (objADRS.EntityState == State.Modified)
            {
                base.Update(SportsList.FirstOrDefault());
            }
            else if (objADRS.EntityState == State.Deleted)
            {
                base.Delete(SportsList.FirstOrDefault());
            }
        }

        public override void Delete(Acq_Deal_Sport objADRS)
        {
            ICollection<Acq_Deal_Sport> deleteList = new HashSet<Acq_Deal_Sport>();
            deleteList.Add(objADRS);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objSaveEntities.DeleteSportRights(deleteList, base.DataContext);
            base.Delete(objADRS);
        }
    }

    public class Acq_Deal_Material_Repository : RightsU_Repository<Acq_Deal_Material>
    {
        public Acq_Deal_Material_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Material objADM)
        {
            ICollection<Acq_Deal_Material> MaterialList = new HashSet<Acq_Deal_Material>();
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

    public class Acq_Deal_Attachment_Repository : RightsU_Repository<Acq_Deal_Attachment>
    {
        public Acq_Deal_Attachment_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Attachment objADA)
        {
            ICollection<Acq_Deal_Attachment> attachmentList = new HashSet<Acq_Deal_Attachment>();
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

    public class Acq_Deal_Payment_Terms_Repository : RightsU_Repository<Acq_Deal_Payment_Terms>
    {
        public Acq_Deal_Payment_Terms_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Payment_Terms objADPT)
        {
            ICollection<Acq_Deal_Payment_Terms> ptList = new HashSet<Acq_Deal_Payment_Terms>();
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

    public class Save_Acq_Deal_Entities_Generic
    {
        public ICollection<Acq_Deal_Movie> SaveMovies(ICollection<Acq_Deal_Movie> entityMovies, DbContext dbContext)
        {
            ICollection<Acq_Deal_Movie> UpdatedMovies = entityMovies;
            foreach (Acq_Deal_Movie objMovie in UpdatedMovies)
            {
                new Save_Entitiy_Lists_Generic<Title_Content_Mapping>().SetListFlagsCUD(objMovie.Title_Content_Mapping, dbContext);
            }

            UpdatedMovies = new Save_Entitiy_Lists_Generic<Acq_Deal_Movie>().SetListFlagsCUD(UpdatedMovies, dbContext);

            return UpdatedMovies;
        }
        public void DeleteMovies(ICollection<Acq_Deal_Movie> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Acq_Deal_Movie objMovie in deleteList)
            {
                dbContext.Title_Content_Mapping.RemoveRange(objMovie.Title_Content_Mapping);
            }

            dbContext.Acq_Deal_Movie.RemoveRange(deleteList);
        }

        public ICollection<Acq_Deal_Licensor> SaveLicensors(ICollection<Acq_Deal_Licensor> entityLicensors, DbContext dbContext)
        {
            ICollection<Acq_Deal_Licensor> UpdatedLicensors = entityLicensors;
            UpdatedLicensors.ToList<Acq_Deal_Licensor>().ForEach(t => { if (t.EntityState == State.Deleted) dbContext.Entry(t).State = EntityState.Deleted; });
            return UpdatedLicensors;
        }
        public void DeleteLicensors(ICollection<Acq_Deal_Licensor> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.Acq_Deal_Licensor.RemoveRange(deleteList);
        }
        public ICollection<Acq_Deal_Budget> Save_Budget(ICollection<Acq_Deal_Budget> entityLicensors, DbContext dbContext)
        {
            ICollection<Acq_Deal_Budget> UpdatedLicensors = entityLicensors;
            UpdatedLicensors.ToList<Acq_Deal_Budget>().ForEach(t => { if (t.EntityState == State.Deleted) dbContext.Entry(t).State = EntityState.Deleted; });
            return UpdatedLicensors;
        }
        public void Delete_Budget(ICollection<Acq_Deal_Budget> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.Acq_Deal_Budget.RemoveRange(deleteList);
        }

        public ICollection<Acq_Deal_Ancillary> SaveAncillary(ICollection<Acq_Deal_Ancillary> entityAncillary, DbContext dbContext)
        {
            ICollection<Acq_Deal_Ancillary> UpdatedAncillary = entityAncillary;


            foreach (Acq_Deal_Ancillary objADA in UpdatedAncillary)
            {
                objADA.Acq_Deal_Ancillary_Title = new Save_Entitiy_Lists_Generic<Acq_Deal_Ancillary_Title>().SetListFlagsCUD(objADA.Acq_Deal_Ancillary_Title, dbContext);

                foreach (Acq_Deal_Ancillary_Platform objADAP in objADA.Acq_Deal_Ancillary_Platform)
                {
                    objADAP.Acq_Deal_Ancillary_Platform_Medium = new Save_Entitiy_Lists_Generic<Acq_Deal_Ancillary_Platform_Medium>().SetListFlagsCUD(objADAP.Acq_Deal_Ancillary_Platform_Medium, dbContext);
                }

                objADA.Acq_Deal_Ancillary_Platform = new Save_Entitiy_Lists_Generic<Acq_Deal_Ancillary_Platform>().SetListFlagsCUD(objADA.Acq_Deal_Ancillary_Platform, dbContext);
            }

            UpdatedAncillary = new Save_Entitiy_Lists_Generic<Acq_Deal_Ancillary>().SetListFlagsCUD(UpdatedAncillary, dbContext);
            return UpdatedAncillary;
        }
        public void DeleteAncillary(ICollection<Acq_Deal_Ancillary> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Acq_Deal_Ancillary objADA in deleteList)
            {
                dbContext.Acq_Deal_Ancillary_Title.RemoveRange(objADA.Acq_Deal_Ancillary_Title);

                foreach (Acq_Deal_Ancillary_Platform objADAP in objADA.Acq_Deal_Ancillary_Platform)
                {
                    dbContext.Acq_Deal_Ancillary_Platform_Medium.RemoveRange(objADAP.Acq_Deal_Ancillary_Platform_Medium);
                }

                dbContext.Acq_Deal_Ancillary_Platform.RemoveRange(objADA.Acq_Deal_Ancillary_Platform);
            }

            dbContext.Acq_Deal_Ancillary.RemoveRange(deleteList);
        }

        public ICollection<Acq_Deal_Rights> SaveRights(ICollection<Acq_Deal_Rights> entityRights, DbContext dbContext)
        {
            ICollection<Acq_Deal_Rights> UpdatedRights = entityRights;

            foreach (Acq_Deal_Rights objDr in UpdatedRights)
            {
                new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Title>().SetListFlagsCUD(objDr.Acq_Deal_Rights_Title, dbContext);
                new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Platform>().SetListFlagsCUD(objDr.Acq_Deal_Rights_Platform, dbContext);
                new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Territory>().SetListFlagsCUD(objDr.Acq_Deal_Rights_Territory, dbContext);
                new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Subtitling>().SetListFlagsCUD(objDr.Acq_Deal_Rights_Subtitling, dbContext);
                new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Dubbing>().SetListFlagsCUD(objDr.Acq_Deal_Rights_Dubbing, dbContext);

                //foreach (Acq_Deal_Rights_Blackout objADRH in objDr.Acq_Deal_Rights_Blackout)
                //{
                //    new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Blackout_Platform>().SetListFlagsCUD(objADRH.Acq_Deal_Rights_Blackout_Platform, dbContext);
                //    new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Blackout_Territory>().SetListFlagsCUD(objADRH.Acq_Deal_Rights_Blackout_Territory, dbContext);
                //    new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Blackout_Subtitling>().SetListFlagsCUD(objADRH.Acq_Deal_Rights_Blackout_Subtitling, dbContext);
                //    new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Blackout_Dubbing>().SetListFlagsCUD(objADRH.Acq_Deal_Rights_Blackout_Dubbing, dbContext);
                //}
                new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Blackout>().SetListFlagsCUD(objDr.Acq_Deal_Rights_Blackout, dbContext);

                foreach (Acq_Deal_Rights_Promoter objADP in objDr.Acq_Deal_Rights_Promoter)
                {
                    new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Promoter_Group>().SetListFlagsCUD(objADP.Acq_Deal_Rights_Promoter_Group, dbContext);
                    new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Promoter_Remarks>().SetListFlagsCUD(objADP.Acq_Deal_Rights_Promoter_Remarks, dbContext);
                }
                new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Promoter>().SetListFlagsCUD(objDr.Acq_Deal_Rights_Promoter, dbContext);

                foreach (Acq_Deal_Rights_Holdback objADRH in objDr.Acq_Deal_Rights_Holdback)
                {
                    new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Holdback_Platform>().SetListFlagsCUD(objADRH.Acq_Deal_Rights_Holdback_Platform, dbContext);
                    new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Holdback_Territory>().SetListFlagsCUD(objADRH.Acq_Deal_Rights_Holdback_Territory, dbContext);
                    new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Holdback_Subtitling>().SetListFlagsCUD(objADRH.Acq_Deal_Rights_Holdback_Subtitling, dbContext);
                    new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Holdback_Dubbing>().SetListFlagsCUD(objADRH.Acq_Deal_Rights_Holdback_Dubbing, dbContext);
                }
                new Save_Entitiy_Lists_Generic<Acq_Deal_Rights_Holdback>().SetListFlagsCUD(objDr.Acq_Deal_Rights_Holdback, dbContext);
            }

            UpdatedRights = new Save_Entitiy_Lists_Generic<Acq_Deal_Rights>().SetListFlagsCUD(UpdatedRights, dbContext);
            return UpdatedRights;
        }
        public void DeleteRights(ICollection<Acq_Deal_Rights> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Acq_Deal_Rights objADR in deleteList)
            {
                dbContext.Acq_Deal_Rights_Title.RemoveRange(objADR.Acq_Deal_Rights_Title);
                dbContext.Acq_Deal_Rights_Platform.RemoveRange(objADR.Acq_Deal_Rights_Platform);
                dbContext.Acq_Deal_Rights_Territory.RemoveRange(objADR.Acq_Deal_Rights_Territory);
                dbContext.Acq_Deal_Rights_Subtitling.RemoveRange(objADR.Acq_Deal_Rights_Subtitling);
                dbContext.Acq_Deal_Rights_Dubbing.RemoveRange(objADR.Acq_Deal_Rights_Dubbing);

                foreach (Acq_Deal_Rights_Holdback objADRH in objADR.Acq_Deal_Rights_Holdback)
                {
                    dbContext.Acq_Deal_Rights_Holdback_Platform.RemoveRange(objADRH.Acq_Deal_Rights_Holdback_Platform);
                    dbContext.Acq_Deal_Rights_Holdback_Territory.RemoveRange(objADRH.Acq_Deal_Rights_Holdback_Territory);
                    dbContext.Acq_Deal_Rights_Holdback_Subtitling.RemoveRange(objADRH.Acq_Deal_Rights_Holdback_Subtitling);
                    dbContext.Acq_Deal_Rights_Holdback_Dubbing.RemoveRange(objADRH.Acq_Deal_Rights_Holdback_Dubbing);
                }
                dbContext.Acq_Deal_Rights_Holdback.RemoveRange(objADR.Acq_Deal_Rights_Holdback);

                foreach (Acq_Deal_Rights_Blackout objADRB in objADR.Acq_Deal_Rights_Blackout)
                {
                    dbContext.Acq_Deal_Rights_Blackout_Platform.RemoveRange(objADRB.Acq_Deal_Rights_Blackout_Platform);
                    dbContext.Acq_Deal_Rights_Blackout_Territory.RemoveRange(objADRB.Acq_Deal_Rights_Blackout_Territory);
                    dbContext.Acq_Deal_Rights_Blackout_Subtitling.RemoveRange(objADRB.Acq_Deal_Rights_Blackout_Subtitling);
                    dbContext.Acq_Deal_Rights_Blackout_Dubbing.RemoveRange(objADRB.Acq_Deal_Rights_Blackout_Dubbing);
                }
                dbContext.Acq_Deal_Rights_Blackout.RemoveRange(objADR.Acq_Deal_Rights_Blackout);

                foreach (Acq_Deal_Rights_Promoter objADRP in objADR.Acq_Deal_Rights_Promoter)
                {
                    dbContext.Acq_Deal_Rights_Promoter_Group.RemoveRange(objADRP.Acq_Deal_Rights_Promoter_Group);
                    dbContext.Acq_Deal_Rights_Promoter_Remarks.RemoveRange(objADRP.Acq_Deal_Rights_Promoter_Remarks);
                }
                dbContext.Acq_Deal_Rights_Promoter.RemoveRange(objADR.Acq_Deal_Rights_Promoter);
            }

            dbContext.Acq_Deal_Rights.RemoveRange(deleteList);
        }

        public ICollection<Acq_Deal_Pushback> SavePushbacks(ICollection<Acq_Deal_Pushback> entityRightsPushbacks, DbContext dbContext)
        {
            ICollection<Acq_Deal_Pushback> UpdatedRightsPushbacks = entityRightsPushbacks;

            foreach (Acq_Deal_Pushback objDRRHB in UpdatedRightsPushbacks)
            {
                new Save_Entitiy_Lists_Generic<Acq_Deal_Pushback_Title>().SetListFlagsCUD(objDRRHB.Acq_Deal_Pushback_Title, dbContext);
                new Save_Entitiy_Lists_Generic<Acq_Deal_Pushback_Platform>().SetListFlagsCUD(objDRRHB.Acq_Deal_Pushback_Platform, dbContext);
                new Save_Entitiy_Lists_Generic<Acq_Deal_Pushback_Territory>().SetListFlagsCUD(objDRRHB.Acq_Deal_Pushback_Territory, dbContext);
                new Save_Entitiy_Lists_Generic<Acq_Deal_Pushback_Subtitling>().SetListFlagsCUD(objDRRHB.Acq_Deal_Pushback_Subtitling, dbContext);
                new Save_Entitiy_Lists_Generic<Acq_Deal_Pushback_Dubbing>().SetListFlagsCUD(objDRRHB.Acq_Deal_Pushback_Dubbing, dbContext);
            }

            UpdatedRightsPushbacks = new Save_Entitiy_Lists_Generic<Acq_Deal_Pushback>().SetListFlagsCUD(UpdatedRightsPushbacks, dbContext);

            return UpdatedRightsPushbacks;
        }
        public void DeletePushbacks(ICollection<Acq_Deal_Pushback> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Acq_Deal_Pushback objADP in deleteList)
            {
                dbContext.Acq_Deal_Pushback_Title.RemoveRange(objADP.Acq_Deal_Pushback_Title);
                dbContext.Acq_Deal_Pushback_Platform.RemoveRange(objADP.Acq_Deal_Pushback_Platform);
                dbContext.Acq_Deal_Pushback_Territory.RemoveRange(objADP.Acq_Deal_Pushback_Territory);
                dbContext.Acq_Deal_Pushback_Subtitling.RemoveRange(objADP.Acq_Deal_Pushback_Subtitling);
                dbContext.Acq_Deal_Pushback_Dubbing.RemoveRange(objADP.Acq_Deal_Pushback_Dubbing);
            }

            dbContext.Acq_Deal_Pushback.RemoveRange(deleteList);
        }

        public ICollection<Acq_Deal_Cost> SaveCosts(ICollection<Acq_Deal_Cost> entityCosts, DbContext dbContext)
        {
            ICollection<Acq_Deal_Cost> UpdatedCosts = entityCosts;

            foreach (Acq_Deal_Cost objADC in UpdatedCosts)
            {
                objADC.Acq_Deal_Cost_Title = new Save_Entitiy_Lists_Generic<Acq_Deal_Cost_Title>().SetListFlagsCUD(objADC.Acq_Deal_Cost_Title, dbContext);

                objADC.Acq_Deal_Cost_Additional_Exp = (objADC.Acq_Deal_Cost_Additional_Exp != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Cost_Additional_Exp>().SetListFlagsCUD(objADC.Acq_Deal_Cost_Additional_Exp, dbContext) : null;

                objADC.Acq_Deal_Cost_Commission = (objADC.Acq_Deal_Cost_Commission != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Cost_Commission>().SetListFlagsCUD(objADC.Acq_Deal_Cost_Commission, dbContext) : null;

                objADC.Acq_Deal_Cost_Variable_Cost = (objADC.Acq_Deal_Cost_Variable_Cost != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Cost_Variable_Cost>().SetListFlagsCUD(objADC.Acq_Deal_Cost_Variable_Cost, dbContext) : null;

                foreach (Acq_Deal_Cost_Costtype objADCC in objADC.Acq_Deal_Cost_Costtype)
                {
                    objADCC.Acq_Deal_Cost_Costtype_Episode = new Save_Entitiy_Lists_Generic<Acq_Deal_Cost_Costtype_Episode>().SetListFlagsCUD(objADCC.Acq_Deal_Cost_Costtype_Episode, dbContext);
                }

                objADC.Acq_Deal_Cost_Costtype = new Save_Entitiy_Lists_Generic<Acq_Deal_Cost_Costtype>().SetListFlagsCUD(objADC.Acq_Deal_Cost_Costtype, dbContext);
            }

            UpdatedCosts = new Save_Entitiy_Lists_Generic<Acq_Deal_Cost>().SetListFlagsCUD(UpdatedCosts, dbContext);

            return UpdatedCosts;
        }
        public void DeleteCosts(ICollection<Acq_Deal_Cost> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Acq_Deal_Cost objADC in deleteList)
            {
                dbContext.Acq_Deal_Cost_Title.RemoveRange(objADC.Acq_Deal_Cost_Title);
                dbContext.Acq_Deal_Cost_Additional_Exp.RemoveRange(objADC.Acq_Deal_Cost_Additional_Exp);
                dbContext.Acq_Deal_Cost_Commission.RemoveRange(objADC.Acq_Deal_Cost_Commission);
                dbContext.Acq_Deal_Cost_Variable_Cost.RemoveRange(objADC.Acq_Deal_Cost_Variable_Cost);

                foreach (Acq_Deal_Cost_Costtype objADCC in objADC.Acq_Deal_Cost_Costtype)
                {
                    dbContext.Acq_Deal_Cost_Costtype_Episode.RemoveRange(objADCC.Acq_Deal_Cost_Costtype_Episode);
                }

                dbContext.Acq_Deal_Cost_Costtype.RemoveRange(objADC.Acq_Deal_Cost_Costtype);
            }
            dbContext.Acq_Deal_Cost.RemoveRange(deleteList);
        }

        public ICollection<Acq_Deal_Run> SaveRuns(ICollection<Acq_Deal_Run> entitySaveRuns, DbContext dbContext)
        {
            ICollection<Acq_Deal_Run> UpdatedRuns = entitySaveRuns;

            foreach (Acq_Deal_Run objADR in UpdatedRuns)
            {
                objADR.Acq_Deal_Run_Channel = (objADR.Acq_Deal_Run_Channel != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Run_Channel>().SetListFlagsCUD(objADR.Acq_Deal_Run_Channel, dbContext) : null;

                objADR.Acq_Deal_Run_Repeat_On_Day = (objADR.Acq_Deal_Run_Repeat_On_Day != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Run_Repeat_On_Day>().SetListFlagsCUD(objADR.Acq_Deal_Run_Repeat_On_Day, dbContext) : null;

                objADR.Acq_Deal_Run_Title = new Save_Entitiy_Lists_Generic<Acq_Deal_Run_Title>().SetListFlagsCUD(objADR.Acq_Deal_Run_Title, dbContext);

                if (objADR.Acq_Deal_Run_Yearwise_Run != null)
                {
                    foreach (Acq_Deal_Run_Yearwise_Run objADRYR in objADR.Acq_Deal_Run_Yearwise_Run)
                    {
                        objADRYR.Acq_Deal_Run_Yearwise_Run_Week = new Save_Entitiy_Lists_Generic<Acq_Deal_Run_Yearwise_Run_Week>().SetListFlagsCUD(objADRYR.Acq_Deal_Run_Yearwise_Run_Week, dbContext);
                    }
                }

                objADR.Acq_Deal_Run_Yearwise_Run = (objADR.Acq_Deal_Run_Yearwise_Run != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Run_Yearwise_Run>().SetListFlagsCUD(objADR.Acq_Deal_Run_Yearwise_Run, dbContext) : null;

                objADR.Acq_Deal_Run_Shows = new Save_Entitiy_Lists_Generic<Acq_Deal_Run_Shows>().SetListFlagsCUD(objADR.Acq_Deal_Run_Shows, dbContext);

            }

            UpdatedRuns = new Save_Entitiy_Lists_Generic<Acq_Deal_Run>().SetListFlagsCUD(UpdatedRuns, dbContext);

            return UpdatedRuns;
        }
        public void DeleteRuns(ICollection<Acq_Deal_Run> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Acq_Deal_Run objADR in deleteList)
            {
                dbContext.Acq_Deal_Run_Channel.RemoveRange(objADR.Acq_Deal_Run_Channel);
                dbContext.Acq_Deal_Run_Repeat_On_Day.RemoveRange(objADR.Acq_Deal_Run_Repeat_On_Day);
                dbContext.Acq_Deal_Run_Title.RemoveRange(objADR.Acq_Deal_Run_Title);
                foreach (Acq_Deal_Run_Yearwise_Run objADRYR in objADR.Acq_Deal_Run_Yearwise_Run)
                {
                    dbContext.Acq_Deal_Run_Yearwise_Run_Week.RemoveRange(objADRYR.Acq_Deal_Run_Yearwise_Run_Week);
                }
                dbContext.Acq_Deal_Run_Yearwise_Run.RemoveRange(objADR.Acq_Deal_Run_Yearwise_Run);
                dbContext.Acq_Deal_Run_Shows.RemoveRange(objADR.Acq_Deal_Run_Shows);
            }
            dbContext.Acq_Deal_Run.RemoveRange(deleteList);
        }

        public ICollection<Acq_Deal_Sport> SaveSportRights(ICollection<Acq_Deal_Sport> entitySaveSport, DbContext dbContext)
        {
            ICollection<Acq_Deal_Sport> UpdatedSport = entitySaveSport;

            foreach (Acq_Deal_Sport objADR in UpdatedSport)
            {
                objADR.Acq_Deal_Sport_Title = (objADR.Acq_Deal_Sport_Title != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Sport_Title>().SetListFlagsCUD(objADR.Acq_Deal_Sport_Title, dbContext) : null;
                objADR.Acq_Deal_Sport_Platform = (objADR.Acq_Deal_Sport_Platform != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Sport_Platform>().SetListFlagsCUD(objADR.Acq_Deal_Sport_Platform, dbContext) : null;
                objADR.Acq_Deal_Sport_Broadcast = new Save_Entitiy_Lists_Generic<Acq_Deal_Sport_Broadcast>().SetListFlagsCUD(objADR.Acq_Deal_Sport_Broadcast, dbContext);
                objADR.Acq_Deal_Sport_Language = new Save_Entitiy_Lists_Generic<Acq_Deal_Sport_Language>().SetListFlagsCUD(objADR.Acq_Deal_Sport_Language, dbContext);
            }

            UpdatedSport = new Save_Entitiy_Lists_Generic<Acq_Deal_Sport>().SetListFlagsCUD(UpdatedSport, dbContext);

            return UpdatedSport;
        }
        public void DeleteSportRights(ICollection<Acq_Deal_Sport> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Acq_Deal_Sport objADSR in deleteList)
            {
                dbContext.Acq_Deal_Sport_Title.RemoveRange(objADSR.Acq_Deal_Sport_Title);
                dbContext.Acq_Deal_Sport_Platform.RemoveRange(objADSR.Acq_Deal_Sport_Platform);
                dbContext.Acq_Deal_Sport_Broadcast.RemoveRange(objADSR.Acq_Deal_Sport_Broadcast);
                dbContext.Acq_Deal_Sport_Language.RemoveRange(objADSR.Acq_Deal_Sport_Language);
            }
            dbContext.Acq_Deal_Sport.RemoveRange(deleteList);
        }

        public ICollection<Acq_Deal_Sport_Ancillary> SaveSportAncillary(ICollection<Acq_Deal_Sport_Ancillary> entitySaveSportAncillary, DbContext dbContext)
        {
            ICollection<Acq_Deal_Sport_Ancillary> UpdatedSportAncillary = entitySaveSportAncillary;

            foreach (Acq_Deal_Sport_Ancillary objADR in UpdatedSportAncillary)
            {
                objADR.Acq_Deal_Sport_Ancillary_Broadcast = (objADR.Acq_Deal_Sport_Ancillary_Broadcast != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Sport_Ancillary_Broadcast>().SetListFlagsCUD(objADR.Acq_Deal_Sport_Ancillary_Broadcast, dbContext) : null;
                objADR.Acq_Deal_Sport_Ancillary_Source = (objADR.Acq_Deal_Sport_Ancillary_Source != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Sport_Ancillary_Source>().SetListFlagsCUD(objADR.Acq_Deal_Sport_Ancillary_Source, dbContext) : null;
                objADR.Acq_Deal_Sport_Ancillary_Title = (objADR.Acq_Deal_Sport_Ancillary_Title != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Sport_Ancillary_Title>().SetListFlagsCUD(objADR.Acq_Deal_Sport_Ancillary_Title, dbContext) : null;
            }

            UpdatedSportAncillary = new Save_Entitiy_Lists_Generic<Acq_Deal_Sport_Ancillary>().SetListFlagsCUD(UpdatedSportAncillary, dbContext);

            return UpdatedSportAncillary;
        }

        public void DeleteSportAncillary(ICollection<Acq_Deal_Sport_Ancillary> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Acq_Deal_Sport_Ancillary objADSR in deleteList)
            {
                dbContext.Acq_Deal_Sport_Ancillary_Title.RemoveRange(objADSR.Acq_Deal_Sport_Ancillary_Title);
                dbContext.Acq_Deal_Sport_Ancillary_Source.RemoveRange(objADSR.Acq_Deal_Sport_Ancillary_Source);
                dbContext.Acq_Deal_Sport_Ancillary_Broadcast.RemoveRange(objADSR.Acq_Deal_Sport_Ancillary_Broadcast);

            }
            dbContext.Acq_Deal_Sport_Ancillary.RemoveRange(deleteList);
        }

        public ICollection<Acq_Deal_Sport_Monetisation_Ancillary> SaveSportMonetisationAncillary(ICollection<Acq_Deal_Sport_Monetisation_Ancillary> entitySaveSportMonetisationAncillary, DbContext dbContext)
        {
            ICollection<Acq_Deal_Sport_Monetisation_Ancillary> UpdatedSportMAncillary = entitySaveSportMonetisationAncillary;

            foreach (Acq_Deal_Sport_Monetisation_Ancillary objADR in UpdatedSportMAncillary)
            {
                objADR.Acq_Deal_Sport_Monetisation_Ancillary_Type = (objADR.Acq_Deal_Sport_Monetisation_Ancillary_Type != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Sport_Monetisation_Ancillary_Type>().SetListFlagsCUD(objADR.Acq_Deal_Sport_Monetisation_Ancillary_Type, dbContext) : null;
                objADR.Acq_Deal_Sport_Monetisation_Ancillary_Title = (objADR.Acq_Deal_Sport_Monetisation_Ancillary_Title != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Sport_Monetisation_Ancillary_Title>().SetListFlagsCUD(objADR.Acq_Deal_Sport_Monetisation_Ancillary_Title, dbContext) : null;
            }

            UpdatedSportMAncillary = new Save_Entitiy_Lists_Generic<Acq_Deal_Sport_Monetisation_Ancillary>().SetListFlagsCUD(UpdatedSportMAncillary, dbContext);

            return UpdatedSportMAncillary;
        }

        public void DeleteSportMonetisationAncillary(ICollection<Acq_Deal_Sport_Monetisation_Ancillary> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Acq_Deal_Sport_Monetisation_Ancillary objADSR in deleteList)
            {
                dbContext.Acq_Deal_Sport_Monetisation_Ancillary_Title.RemoveRange(objADSR.Acq_Deal_Sport_Monetisation_Ancillary_Title);
                dbContext.Acq_Deal_Sport_Monetisation_Ancillary_Type.RemoveRange(objADSR.Acq_Deal_Sport_Monetisation_Ancillary_Type);

            }
            dbContext.Acq_Deal_Sport_Monetisation_Ancillary.RemoveRange(deleteList);
        }

        public ICollection<Acq_Deal_Sport_Sales_Ancillary> SaveSportSalesAncillary(ICollection<Acq_Deal_Sport_Sales_Ancillary> entitySaveSportSalesAncillary, DbContext dbContext)
        {
            ICollection<Acq_Deal_Sport_Sales_Ancillary> UpdatedSportSAncillary = entitySaveSportSalesAncillary;

            foreach (Acq_Deal_Sport_Sales_Ancillary objADR in UpdatedSportSAncillary)
            {
                objADR.Acq_Deal_Sport_Sales_Ancillary_Sponsor = (objADR.Acq_Deal_Sport_Sales_Ancillary_Sponsor != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Sport_Sales_Ancillary_Sponsor>().SetListFlagsCUD(objADR.Acq_Deal_Sport_Sales_Ancillary_Sponsor, dbContext) : null;
                objADR.Acq_Deal_Sport_Sales_Ancillary_Title = (objADR.Acq_Deal_Sport_Sales_Ancillary_Title != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Sport_Sales_Ancillary_Title>().SetListFlagsCUD(objADR.Acq_Deal_Sport_Sales_Ancillary_Title, dbContext) : null;
            }

            UpdatedSportSAncillary = new Save_Entitiy_Lists_Generic<Acq_Deal_Sport_Sales_Ancillary>().SetListFlagsCUD(UpdatedSportSAncillary, dbContext);

            return UpdatedSportSAncillary;
        }

        public void DeleteSportSalesAncillary(ICollection<Acq_Deal_Sport_Sales_Ancillary> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Acq_Deal_Sport_Sales_Ancillary objADSR in deleteList)
            {
                dbContext.Acq_Deal_Sport_Sales_Ancillary_Title.RemoveRange(objADSR.Acq_Deal_Sport_Sales_Ancillary_Title);
                dbContext.Acq_Deal_Sport_Sales_Ancillary_Sponsor.RemoveRange(objADSR.Acq_Deal_Sport_Sales_Ancillary_Sponsor);

            }
            dbContext.Acq_Deal_Sport_Sales_Ancillary.RemoveRange(deleteList);
        }

        public ICollection<Acq_Deal_Supplementary> SaveSupplementary(ICollection<Acq_Deal_Supplementary> entitySaveSupplementary, DbContext dbContext)
        {
            ICollection<Acq_Deal_Supplementary> UpdatedSupplementary = entitySaveSupplementary;

            foreach (Acq_Deal_Supplementary objADR in UpdatedSupplementary)
            {
                objADR.Acq_Deal_Supplementary_detail = (objADR.Acq_Deal_Supplementary_detail != null) ? new Save_Entitiy_Lists_Generic<Acq_Deal_Supplementary_detail>().SetListFlagsCUD(objADR.Acq_Deal_Supplementary_detail, dbContext) : null;
            }

            UpdatedSupplementary = new Save_Entitiy_Lists_Generic<Acq_Deal_Supplementary>().SetListFlagsCUD(UpdatedSupplementary, dbContext);

            return UpdatedSupplementary;
        }
        public void DeleteSupplementary(ICollection<Acq_Deal_Supplementary> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Acq_Deal_Supplementary objADR in deleteList)
            {
                dbContext.Acq_Deal_Supplementary_detail.RemoveRange(objADR.Acq_Deal_Supplementary_detail);
            }
            dbContext.Acq_Deal_Supplementary.RemoveRange(deleteList);
        }

    }

    public class Acq_Deal_Mass_Territory_Update_Repository : RightsU_Repository<Acq_Deal_Mass_Territory_Update>
    {
        public Acq_Deal_Mass_Territory_Update_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Mass_Territory_Update objADMTU)
        {
            ICollection<Acq_Deal_Mass_Territory_Update> MassTerritory = new HashSet<Acq_Deal_Mass_Territory_Update>();
            MassTerritory.Add(objADMTU);

            if (objADMTU.EntityState == State.Added)
            {
                base.Save(MassTerritory.FirstOrDefault());
            }
            else if (objADMTU.EntityState == State.Modified)
            {
                base.Update(MassTerritory.FirstOrDefault());
            }
            else if (objADMTU.EntityState == State.Deleted)
            {
                base.Delete(MassTerritory.FirstOrDefault());
            }
        }
    }

    public class Acq_Deal_Mass_Territory_Update_Details_Repository : RightsU_Repository<Acq_Deal_Mass_Territory_Update_Details>
    {
        public Acq_Deal_Mass_Territory_Update_Details_Repository(string conStr) : base(conStr) { }
    }

    public class Avail_Acq_Repository : RightsU_Repository<Avail_Acq>
    {
        public Avail_Acq_Repository(string conStr) : base(conStr) { }
    }

    public class Acq_Deal_Sport_Ancillary_Repository : RightsU_Repository<Acq_Deal_Sport_Ancillary>
    {
        public Acq_Deal_Sport_Ancillary_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Sport_Ancillary objADRS)
        {
            ICollection<Acq_Deal_Sport_Ancillary> SportsAncillaryList = new HashSet<Acq_Deal_Sport_Ancillary>();
            SportsAncillaryList.Add(objADRS);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objADRS = objSaveEntities.SaveSportAncillary(SportsAncillaryList, base.DataContext).FirstOrDefault();

            if (objADRS.EntityState == State.Added)
            {
                base.Save(SportsAncillaryList.FirstOrDefault());
            }
            else if (objADRS.EntityState == State.Modified)
            {
                base.Update(SportsAncillaryList.FirstOrDefault());
            }
            else if (objADRS.EntityState == State.Deleted)
            {
                base.Delete(SportsAncillaryList.FirstOrDefault());
            }
        }

        public override void Delete(Acq_Deal_Sport_Ancillary objADRS)
        {
            ICollection<Acq_Deal_Sport_Ancillary> deleteList = new HashSet<Acq_Deal_Sport_Ancillary>();
            deleteList.Add(objADRS);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objSaveEntities.DeleteSportAncillary(deleteList, base.DataContext);
            base.Delete(objADRS);
        }
    }

    public class Acq_Deal_Sport_Monetisation_Ancillary_Repository : RightsU_Repository<Acq_Deal_Sport_Monetisation_Ancillary>
    {
        public Acq_Deal_Sport_Monetisation_Ancillary_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Sport_Monetisation_Ancillary objADRS)
        {
            ICollection<Acq_Deal_Sport_Monetisation_Ancillary> SportsAncillaryList = new HashSet<Acq_Deal_Sport_Monetisation_Ancillary>();
            SportsAncillaryList.Add(objADRS);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objADRS = objSaveEntities.SaveSportMonetisationAncillary(SportsAncillaryList, base.DataContext).FirstOrDefault();

            if (objADRS.EntityState == State.Added)
            {
                base.Save(SportsAncillaryList.FirstOrDefault());
            }
            else if (objADRS.EntityState == State.Modified)
            {
                base.Update(SportsAncillaryList.FirstOrDefault());
            }
            else if (objADRS.EntityState == State.Deleted)
            {
                base.Delete(SportsAncillaryList.FirstOrDefault());
            }
        }

        public override void Delete(Acq_Deal_Sport_Monetisation_Ancillary objADRS)
        {
            ICollection<Acq_Deal_Sport_Monetisation_Ancillary> deleteList = new HashSet<Acq_Deal_Sport_Monetisation_Ancillary>();
            deleteList.Add(objADRS);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objSaveEntities.DeleteSportMonetisationAncillary(deleteList, base.DataContext);
            base.Delete(objADRS);
        }
    }

    public class Acq_Deal_Sport_Sales_Ancillary_Repository : RightsU_Repository<Acq_Deal_Sport_Sales_Ancillary>
    {
        public Acq_Deal_Sport_Sales_Ancillary_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Sport_Sales_Ancillary objADRS)
        {
            ICollection<Acq_Deal_Sport_Sales_Ancillary> SportsAncillaryList = new HashSet<Acq_Deal_Sport_Sales_Ancillary>();
            SportsAncillaryList.Add(objADRS);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objADRS = objSaveEntities.SaveSportSalesAncillary(SportsAncillaryList, base.DataContext).FirstOrDefault();

            if (objADRS.EntityState == State.Added)
            {
                base.Save(SportsAncillaryList.FirstOrDefault());
            }
            else if (objADRS.EntityState == State.Modified)
            {
                base.Update(SportsAncillaryList.FirstOrDefault());
            }
            else if (objADRS.EntityState == State.Deleted)
            {
                base.Delete(SportsAncillaryList.FirstOrDefault());
            }
        }

        public override void Delete(Acq_Deal_Sport_Sales_Ancillary objADRS)
        {
            ICollection<Acq_Deal_Sport_Sales_Ancillary> deleteList = new HashSet<Acq_Deal_Sport_Sales_Ancillary>();
            deleteList.Add(objADRS);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objSaveEntities.DeleteSportSalesAncillary(deleteList, base.DataContext);
            base.Delete(objADRS);
        }
    }
    public class Acq_Deal_Budget_Repository : RightsU_Repository<Acq_Deal_Budget>
    {
        public Acq_Deal_Budget_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Budget objADA)
        {
            ICollection<Acq_Deal_Budget> BudgetList = new HashSet<Acq_Deal_Budget>();
            BudgetList.Add(objADA);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objADA = objSaveEntities.Save_Budget(BudgetList, base.DataContext).FirstOrDefault();

            if (objADA.EntityState == State.Added)
            {
                base.Save(BudgetList.FirstOrDefault());
            }
            else if (objADA.EntityState == State.Modified)
            {
                base.Update(BudgetList.FirstOrDefault());
            }
            else if (objADA.EntityState == State.Deleted)
            {
                base.Delete(BudgetList.FirstOrDefault());
            }
        }

        public override void Delete(Acq_Deal_Budget objADA)
        {
            ICollection<Acq_Deal_Budget> deleteList = new HashSet<Acq_Deal_Budget>();
            deleteList.Add(objADA);
            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
            objSaveEntities.Delete_Budget(deleteList, base.DataContext);
            base.Delete(objADA);
        }
    }

    public class Acq_Deal_Movie_Music_Repository : RightsU_Repository<Acq_Deal_Movie_Music>
    {
        public Acq_Deal_Movie_Music_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Movie_Music obj)
        {
            ICollection<Acq_Deal_Movie_Music> list = new HashSet<Acq_Deal_Movie_Music>();
            list.Add(obj);

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

    public class Acq_Deal_Movie_Music_Link_Repository : RightsU_Repository<Acq_Deal_Movie_Music_Link>
    {
        public Acq_Deal_Movie_Music_Link_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Movie_Music_Link obj)
        {
            ICollection<Acq_Deal_Movie_Music_Link> list = new HashSet<Acq_Deal_Movie_Music_Link>();
            list.Add(obj);

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

    public class Acq_Deal_Rights_Holdback_Repository : RightsU_Repository<Acq_Deal_Rights_Holdback>
    {
        public Acq_Deal_Rights_Holdback_Repository(string conStr) : base(conStr) { }
    }
    public class Acq_Deal_Rights_Title_Repository : RightsU_Repository<Acq_Deal_Rights_Title>
    {
        public Acq_Deal_Rights_Title_Repository(string conStr) : base(conStr) { }
    }

    public class Rights_Bulk_Update_Repository : RightsU_Repository<Rights_Bulk_Update>
    {
        public Rights_Bulk_Update_Repository(string conStr) : base(conStr) { }

        public override void Save(Rights_Bulk_Update obj)
        {
            ICollection<Rights_Bulk_Update> list = new HashSet<Rights_Bulk_Update>();
            list.Add(obj);

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

    public class Deal_Rights_Process_Repository : RightsU_Repository<Deal_Rights_Process>
    {
        public Deal_Rights_Process_Repository(string conStr) : base(conStr) { }

        public override void Save(Deal_Rights_Process obj)
        {
            ICollection<Deal_Rights_Process> list = new HashSet<Deal_Rights_Process>();
            list.Add(obj);

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

    public class Acq_Deal_Rights_Error_Details_Repository : RightsU_Repository<Acq_Deal_Rights_Error_Details>
    {
        public Acq_Deal_Rights_Error_Details_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Rights_Error_Details obj)
        {
            ICollection<Acq_Deal_Rights_Error_Details> list = new HashSet<Acq_Deal_Rights_Error_Details>();
            list.Add(obj);

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

    public class Acq_Rights_Template_Repository : RightsU_Repository<Acq_Rights_Template>
    {
        public Acq_Rights_Template_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Rights_Template obj)
        {
            ICollection<Acq_Rights_Template> list = new HashSet<Acq_Rights_Template>();
            list.Add(obj);

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

    public class Acq_Deal_Supplementary_Repository : RightsU_Repository<Acq_Deal_Supplementary>
    {
        public Acq_Deal_Supplementary_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Supplementary obj)
        {
            ICollection<Acq_Deal_Supplementary> list = new HashSet<Acq_Deal_Supplementary>();
            list.Add(obj);

            Save_Acq_Deal_Entities_Generic objSaveEntities = new Save_Acq_Deal_Entities_Generic();
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
}
