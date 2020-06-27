using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RightsU_DAL;
using System.Data.Entity;


namespace RightsU_DAL.Repository
{
    public class Provisional_Deal_Repositories : RightsU_Repository<Provisional_Deal>
    {
        public Provisional_Deal_Repositories(string conStr) : base(conStr) { }

        public override void Save(Provisional_Deal objPD)
        {
            Save_Provisional_Deal_Entities_Generic objSaveEntities = new Save_Provisional_Deal_Entities_Generic();
            if (objPD.Provisional_Deal_Licensor != null) { objPD.Provisional_Deal_Licensor = objSaveEntities.SaveProvisionalDeal_Licensor(objPD.Provisional_Deal_Licensor ,base.DataContext);};
            if (objPD.Provisional_Deal_Title != null) { objPD.Provisional_Deal_Title = objSaveEntities.SaveProvisionalDeal_Title(objPD.Provisional_Deal_Title, base.DataContext); };
            

            if (objPD.EntityState == State.Added)
            {
                base.Save(objPD);
            }
            else if (objPD.EntityState == State.Modified)
            {
                base.Update(objPD);
            }
            else if (objPD.EntityState == State.Deleted)
            {
                base.Delete(objPD);
            }
        }

        public override void Delete(Provisional_Deal objPD)
        {
            Save_Provisional_Deal_Entities_Generic objSaveEntities = new Save_Provisional_Deal_Entities_Generic();
            objSaveEntities.DeleteProvisionalDeal_Title(objPD.Provisional_Deal_Title, base.DataContext);
            objSaveEntities.DeleteProvisionalDeal_Licensor(objPD.Provisional_Deal_Licensor, base.DataContext);
            base.Delete(objPD);
        }

    }

    public class Save_Provisional_Deal_Entities_Generic
    {
        public ICollection<Provisional_Deal_Licensor> SaveProvisionalDeal_Licensor(ICollection<Provisional_Deal_Licensor> entityList, DbContext dbContext)
        {
            ICollection<Provisional_Deal_Licensor> updatedEntityList = entityList;
            updatedEntityList = new Save_Entitiy_Lists_Generic<Provisional_Deal_Licensor>().SetListFlagsCUD(updatedEntityList, dbContext);
            return updatedEntityList;
        }

        public void DeleteProvisionalDeal_Licensor(ICollection<Provisional_Deal_Licensor> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.Provisional_Deal_Licensor.RemoveRange(deleteList);
        }


        public ICollection<Provisional_Deal_Title> SaveProvisionalDeal_Title(ICollection<Provisional_Deal_Title> entityList, DbContext dbContext)
        {
            ICollection<Provisional_Deal_Title> updatedEntityList = entityList;

            foreach (Provisional_Deal_Title ObjDt in updatedEntityList)
            {
                foreach (Provisional_Deal_Run objPDR in ObjDt.Provisional_Deal_Run)
                {
                    new Save_Entitiy_Lists_Generic<Provisional_Deal_Run_Channel>().SetListFlagsCUD(objPDR.Provisional_Deal_Run_Channel, dbContext);
                }
                new Save_Entitiy_Lists_Generic<Provisional_Deal_Run>().SetListFlagsCUD(ObjDt.Provisional_Deal_Run, dbContext);
            }
            updatedEntityList = new Save_Entitiy_Lists_Generic<Provisional_Deal_Title>().SetListFlagsCUD(updatedEntityList, dbContext);
            return updatedEntityList;
        }

        public void DeleteProvisionalDeal_Title(ICollection<Provisional_Deal_Title> deleteList, RightsU_NeoEntities dbContext)
        {
            foreach (Provisional_Deal_Title ObjDt in deleteList)
            {  
                foreach (Provisional_Deal_Run objPDR in ObjDt.Provisional_Deal_Run)
                {
                    dbContext.Provisional_Deal_Run_Channel.RemoveRange(objPDR.Provisional_Deal_Run_Channel);

                }
                dbContext.Provisional_Deal_Run.RemoveRange(ObjDt.Provisional_Deal_Run);
            }

            dbContext.Provisional_Deal_Title.RemoveRange(deleteList);

        }

    }
}
