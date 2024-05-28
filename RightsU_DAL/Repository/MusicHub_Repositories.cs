using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_DAL
{
    public class MHRequest_Repository : RightsU_Repository<MHRequest>
    {
        public MHRequest_Repository(string conStr) : base(conStr) { }

        public override void Save(MHRequest objToSave)
        {
            Save_MusicHub_Entities_Generic objSaveEntities = new Save_MusicHub_Entities_Generic();
            if (objToSave.MHRequestDetails != null) objToSave.MHRequestDetails = objSaveEntities.SaveMHRequestDetails(objToSave.MHRequestDetails, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(MHRequest objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class MHRequestDetail_Repository : RightsU_Repository<MHRequestDetail>
    {
        public MHRequestDetail_Repository(string conStr) : base(conStr) { }
        public override void Save(MHRequestDetail objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(MHRequestDetail objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class MHCueSheet_Repository : RightsU_Repository<MHCueSheet>
    {
        public MHCueSheet_Repository(string conStr) : base(conStr) { }

        public override void Save(MHCueSheet objToSave)
        {
            Save_MusicHub_Entities_Generic objSaveEntities = new Save_MusicHub_Entities_Generic();
            if (objToSave.MHCueSheetSongs != null) objToSave.MHCueSheetSongs = objSaveEntities.SaveMHCueSheetSong(objToSave.MHCueSheetSongs, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(MHCueSheet objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class MHCueSheetSongs_Repository : RightsU_Repository<MHCueSheetSong>
    {
        public MHCueSheetSongs_Repository(string conStr) : base(conStr) { }
        public override void Save(MHCueSheetSong objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(MHCueSheetSong objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class MHRequestStatu_Repository : RightsU_Repository<MHRequestStatu>
    {
        public MHRequestStatu_Repository(string conStr) : base(conStr) { }
    }
    public class MHUser_Repository : RightsU_Repository<MHUser>
    {
        public MHUser_Repository(string conStr) : base(conStr) { }
    }
    public class Save_MusicHub_Entities_Generic
    {
        public ICollection<MHRequestDetail> SaveMHRequestDetails(ICollection<MHRequestDetail> entityList, DbContext dbContext)
        {
            ICollection<MHRequestDetail> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<MHRequestDetail>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<MHCueSheetSong> SaveMHCueSheetSong(ICollection<MHCueSheetSong> entityList, DbContext dbContext)
        {
            ICollection<MHCueSheetSong> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<MHCueSheetSong>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
    }
}
