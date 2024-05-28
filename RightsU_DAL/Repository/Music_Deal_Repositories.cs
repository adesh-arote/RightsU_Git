using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_DAL
{
    public class Music_Deal_Repository : RightsU_Repository<Music_Deal>
    {
        public Music_Deal_Repository(string conStr) : base(conStr) { }

        public override void Save(Music_Deal objMD)
        {
            Save_Music_Deal_Entities_Generic objSaveEntities = new Save_Music_Deal_Entities_Generic();

            if (objMD.Music_Deal_Channel != null) objMD.Music_Deal_Channel = objSaveEntities.SaveMusicDealChannel(objMD.Music_Deal_Channel, base.DataContext);
            if (objMD.Music_Deal_Country != null) objMD.Music_Deal_Country = objSaveEntities.SaveMusicDealCountry(objMD.Music_Deal_Country, base.DataContext);
            if (objMD.Music_Deal_Language != null) objMD.Music_Deal_Language = objSaveEntities.SaveMusicDealLanguage(objMD.Music_Deal_Language, base.DataContext);
            if (objMD.Music_Deal_LinkShow != null) objMD.Music_Deal_LinkShow = objSaveEntities.SaveMusicDealLinkShow(objMD.Music_Deal_LinkShow, base.DataContext);
            if (objMD.Music_Deal_Vendor != null) objMD.Music_Deal_Vendor = objSaveEntities.SaveMusicDealVendor(objMD.Music_Deal_Vendor, base.DataContext);
            if (objMD.Music_Deal_DealType != null) objMD.Music_Deal_DealType = objSaveEntities.SaveMusicDealDealType(objMD.Music_Deal_DealType, base.DataContext);
            if (objMD.Music_Deal_Platform != null) objMD.Music_Deal_Platform = objSaveEntities.SaveMusicDealDealType(objMD.Music_Deal_Platform, base.DataContext);

            if (objMD.EntityState == State.Added)
            {
                base.Save(objMD);
            }
            else if (objMD.EntityState == State.Modified)
            {
                base.Update(objMD);
            }
            else if (objMD.EntityState == State.Deleted)
            {
                base.Delete(objMD);
            }
        }

        public override void Delete(Music_Deal objMD)
        {

            Save_Music_Deal_Entities_Generic objSaveEntities = new Save_Music_Deal_Entities_Generic();
            objSaveEntities.DeleteMusicDealChannel(objMD.Music_Deal_Channel, base.DataContext);
            objSaveEntities.DeleteMusicDealCountry(objMD.Music_Deal_Country, base.DataContext);
            objSaveEntities.DeleteMusicDealLanguage(objMD.Music_Deal_Language, base.DataContext);
            objSaveEntities.DeleteMusicDealLinkShow(objMD.Music_Deal_LinkShow, base.DataContext);
            objSaveEntities.DeleteMusicDealVendor(objMD.Music_Deal_Vendor, base.DataContext);
            objSaveEntities.DeleteMusicDealDealType(objMD.Music_Deal_DealType, base.DataContext);
            objSaveEntities.DeleteMusicDealDealType(objMD.Music_Deal_Platform, base.DataContext);
            base.Delete(objMD);

        }
    }

    public class Music_Platform_Repository : RightsU_Repository<Music_Platform>
    {
           public Music_Platform_Repository(string conStr) : base(conStr) { }
    }

    public class Music_Deal_Channel_Repository : RightsU_Repository<Music_Deal_Channel>
    {
        public Music_Deal_Channel_Repository(string conStr) : base(conStr) { }
    }

    public class Music_Deal_Country_Repository : RightsU_Repository<Music_Deal_Country>
    {
        public Music_Deal_Country_Repository(string conStr) : base(conStr) { }
    }

    public class Music_Deal_Language_Repository : RightsU_Repository<Music_Deal_Language>
    {
        public Music_Deal_Language_Repository(string conStr) : base(conStr) { }
    }

    public class Music_Deal_LinkShow_Repository : RightsU_Repository<Music_Deal_LinkShow>
    {
        public Music_Deal_LinkShow_Repository(string conStr) : base(conStr) { }
    }

    public class Music_Deal_Vendor_Repository : RightsU_Repository<Music_Deal_Vendor>
    {
        public Music_Deal_Vendor_Repository(string conStr) : base(conStr) { }
    }

    public class Music_Deal_DealType_Repository : RightsU_Repository<Music_Deal_DealType>
    {
        public Music_Deal_DealType_Repository(string conStr) : base(conStr) { }
    }

    public class Music_Deal_Platform_Repository : RightsU_Repository<Music_Deal_Platform>
    {
        public Music_Deal_Platform_Repository(string conStr) : base(conStr) { }
    }

    public class Save_Music_Deal_Entities_Generic
    {
        public ICollection<Music_Deal_Channel> SaveMusicDealChannel(ICollection<Music_Deal_Channel> entityList, DbContext dbContext)
        {
            ICollection<Music_Deal_Channel> updatedEntityList = entityList;
            updatedEntityList = new Save_Entitiy_Lists_Generic<Music_Deal_Channel>().SetListFlagsCUD(updatedEntityList, dbContext);
            return updatedEntityList;
        }

        public void DeleteMusicDealChannel(ICollection<Music_Deal_Channel> deleteList, RightsU_NeoEntities dbContext)
        {   
            dbContext.Music_Deal_Channel.RemoveRange(deleteList);
        }

        public ICollection<Music_Deal_Country> SaveMusicDealCountry(ICollection<Music_Deal_Country> entityList, DbContext dbContext)
        {
            ICollection<Music_Deal_Country> updatedEntityList = entityList;
            updatedEntityList = new Save_Entitiy_Lists_Generic<Music_Deal_Country>().SetListFlagsCUD(updatedEntityList, dbContext);
            return updatedEntityList;
        }

        public void DeleteMusicDealCountry(ICollection<Music_Deal_Country> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.Music_Deal_Country.RemoveRange(deleteList);
        }

        public ICollection<Music_Deal_Language> SaveMusicDealLanguage(ICollection<Music_Deal_Language> entityList, DbContext dbContext)
        {
            ICollection<Music_Deal_Language> updatedEntityList = entityList;
            updatedEntityList = new Save_Entitiy_Lists_Generic<Music_Deal_Language>().SetListFlagsCUD(updatedEntityList, dbContext);
            return updatedEntityList;
        }

        public void DeleteMusicDealLanguage(ICollection<Music_Deal_Language> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.Music_Deal_Language.RemoveRange(deleteList);
        }

        public ICollection<Music_Deal_LinkShow> SaveMusicDealLinkShow(ICollection<Music_Deal_LinkShow> entityList, DbContext dbContext)
        {
            ICollection<Music_Deal_LinkShow> updatedEntityList = entityList;
            updatedEntityList = new Save_Entitiy_Lists_Generic<Music_Deal_LinkShow>().SetListFlagsCUD(updatedEntityList, dbContext);
            return updatedEntityList;
        }

        public void DeleteMusicDealLinkShow(ICollection<Music_Deal_LinkShow> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.Music_Deal_LinkShow.RemoveRange(deleteList);
        }

        public ICollection<Music_Deal_Vendor> SaveMusicDealVendor(ICollection<Music_Deal_Vendor> entityList, DbContext dbContext)
        {
            ICollection<Music_Deal_Vendor> updatedEntityList = entityList;
            updatedEntityList = new Save_Entitiy_Lists_Generic<Music_Deal_Vendor>().SetListFlagsCUD(updatedEntityList, dbContext);
            return updatedEntityList;
        }

        public void DeleteMusicDealVendor(ICollection<Music_Deal_Vendor> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.Music_Deal_Vendor.RemoveRange(deleteList);
        }

        public ICollection<Music_Deal_DealType> SaveMusicDealDealType(ICollection<Music_Deal_DealType> entityList, DbContext dbContext)
        {
            ICollection<Music_Deal_DealType> updatedEntityList = entityList;
            updatedEntityList = new Save_Entitiy_Lists_Generic<Music_Deal_DealType>().SetListFlagsCUD(updatedEntityList, dbContext);
            return updatedEntityList;
        }

        public ICollection<Music_Deal_Platform> SaveMusicDealDealType(ICollection<Music_Deal_Platform> entityList, DbContext dbContext)
        {
            ICollection<Music_Deal_Platform> updatedEntityList = entityList;
            updatedEntityList = new Save_Entitiy_Lists_Generic<Music_Deal_Platform>().SetListFlagsCUD(updatedEntityList, dbContext);
            return updatedEntityList;
        }

        public void DeleteMusicDealDealType(ICollection<Music_Deal_DealType> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.Music_Deal_DealType.RemoveRange(deleteList);
        }

        public void DeleteMusicDealDealType(ICollection<Music_Deal_Platform> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.Music_Deal_Platform.RemoveRange(deleteList);
        }
   
   
    }
}
