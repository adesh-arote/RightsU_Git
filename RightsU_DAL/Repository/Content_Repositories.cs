using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;
using RightsU_Entities;

namespace RightsU_DAL
{

    public class Title_Content_Repository : RightsU_Repository<Title_Content>
    {
        public Title_Content_Repository(string conStr) : base(conStr) { }

        public override void Save(Title_Content objTC)
        {
            ICollection<Title_Content> ContentList = new HashSet<Title_Content>();
            ContentList.Add(objTC);

            Save_Content_Entities_Generic objSaveEntities = new Save_Content_Entities_Generic();
            objTC = objSaveEntities.SaveTitleContents(ContentList, base.DataContext).FirstOrDefault();

            if (objTC.EntityState == State.Added)
            {
                base.Save(ContentList.FirstOrDefault());
            }
            else if (objTC.EntityState == State.Modified)
            {
                base.Update(ContentList.FirstOrDefault());
            }
            else if (objTC.EntityState == State.Deleted)
            {
                base.Delete(ContentList.FirstOrDefault());
            }
        }
    }
    public class Title_Content_Version_Repository : RightsU_Repository<Title_Content_Version>
    {
        public Title_Content_Version_Repository(string conStr) : base(conStr) { }

        public override void Save(Title_Content_Version obj)
        {
            if (obj.EntityState == State.Added)
            {
                base.Save(obj);
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(obj);
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(obj);
            }
        }
        public ICollection<Title_Content_Version> SaveTitleContents(ICollection<Title_Content_Version> entityContents, DbContext dbContext)
        {
            ICollection<Title_Content_Version> UpdatedContents = entityContents;
            foreach (Title_Content_Version objTCV in UpdatedContents)
            {
                new Save_Entitiy_Lists_Generic<Title_Content_Version_Details>().SetListFlagsCUD(objTCV.Title_Content_Version_Details, dbContext);
            }
            UpdatedContents = new Save_Entitiy_Lists_Generic<Title_Content_Version>().SetListFlagsCUD(UpdatedContents, dbContext);
            return UpdatedContents;
        }
        public override void Delete(Title_Content_Version  objTCV)
        {

            Save_Content_Entities_Generic objSaveEntities = new Save_Content_Entities_Generic();
            objSaveEntities.DeleteTitleContentVersionDetails(objTCV.Title_Content_Version_Details, base.DataContext);
            base.Delete(objTCV);

        }

    }
    public class Title_Content_Mapping_Repository : RightsU_Repository<Title_Content_Mapping>
    {
        public Title_Content_Mapping_Repository(string conStr) : base(conStr) { }

        public override void Save(Title_Content_Mapping obj)
        {
            if (obj.EntityState == State.Added)
            {
                base.Save(obj);
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(obj);
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(obj);
            }
        }
    }
    public class Content_Music_Link_Repository : RightsU_Repository<Content_Music_Link>
    {
        public Content_Music_Link_Repository(string conStr) : base(conStr) { }

        public override void Save(Content_Music_Link obj)
        {
            if (obj.EntityState == State.Added)
            {
                base.Save(obj);
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(obj);
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(obj);
            }
        }

        public override void Delete(Content_Music_Link obj)
        {
            base.Delete(obj);
        }
    }

    public class Content_Status_History_Repository : RightsU_Repository<Content_Status_History>
    {
        public Content_Status_History_Repository(string conStr) : base(conStr) { }

        public override void Save(Content_Status_History obj)
        {
            if (obj.EntityState == State.Added)
            {
                base.Save(obj);
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(obj);
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(obj);
            }
        }

        public override void Delete(Content_Status_History obj)
        {
            base.Delete(obj);
        }
    }

    public class Music_Schedule_Exception_Repository : RightsU_Repository<Music_Schedule_Exception>
    {
        public Music_Schedule_Exception_Repository(string conStr) : base(conStr) { }

        public override void Save(Music_Schedule_Exception obj)
        {
            if (obj.EntityState == State.Added)
            {
                base.Save(obj);
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(obj);
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(obj);
            }
        }

        public override void Delete(Music_Schedule_Exception obj)
        {
            base.Delete(obj);
        }
    }

    public class Music_Schedule_Transaction_Repository : RightsU_Repository<Music_Schedule_Transaction>
    {
        public Music_Schedule_Transaction_Repository(string conStr) : base(conStr) { }

        public override void Save(Music_Schedule_Transaction obj)
        {
            if (obj.EntityState == State.Added)
            {
                base.Save(obj);
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(obj);
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(obj);
            }
        }

        public override void Delete(Music_Schedule_Transaction obj)
        {
            base.Delete(obj);
        }
    }

    public class Music_Override_Reason_Repository : RightsU_Repository<Music_Override_Reason>
    {
        public Music_Override_Reason_Repository(string conStr) : base(conStr) { }

        public override void Save(Music_Override_Reason obj)
        {
            if (obj.EntityState == State.Added)
            {
                base.Save(obj);
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(obj);
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(obj);
            }
        }

        public override void Delete(Music_Override_Reason obj)
        {
            base.Delete(obj);
        }
    }

    public class Title_Content_Version_Details_Repository : RightsU_Repository<Title_Content_Version_Details>
    {
        public Title_Content_Version_Details_Repository(string conStr) : base(conStr) { }

        public override void Save(Title_Content_Version_Details obj)
        {
            if(obj.EntityState == State.Added)
            {
                base.Save(obj);
            }
            else if(obj.EntityState == State.Modified)
            {
                base.Update(obj);
            }
            else if(obj.EntityState == State.Deleted)
            {
                base.Delete(obj);
            }
        }
    }

    public class Save_Content_Entities_Generic
    {
        public ICollection<Title_Content> SaveTitleContents(ICollection<Title_Content> entityContents, DbContext dbContext)
        {
            ICollection<Title_Content> UpdatedContents = entityContents;
            foreach (Title_Content objDr in UpdatedContents)
            {
                new Save_Entitiy_Lists_Generic<Title_Content_Mapping>().SetListFlagsCUD(objDr.Title_Content_Mapping, dbContext);
                new Save_Entitiy_Lists_Generic<Content_Music_Link>().SetListFlagsCUD(objDr.Content_Music_Link, dbContext);
                new Save_Entitiy_Lists_Generic<Content_Status_History>().SetListFlagsCUD(objDr.Content_Status_History, dbContext);
                new Save_Entitiy_Lists_Generic<Title_Content_Version>().SetListFlagsCUD(objDr.Title_Content_Version, dbContext);
            }
            UpdatedContents = new Save_Entitiy_Lists_Generic<Title_Content>().SetListFlagsCUD(UpdatedContents, dbContext);
            return UpdatedContents;
        }
        public void DeleteTitleContentVersionDetails(ICollection<Title_Content_Version_Details> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.Title_Content_Version_Details.RemoveRange(deleteList);
        }
    }
    public class Title_Content_Material_Repository : RightsU_Repository<Title_Content_Material>
    {
        public Title_Content_Material_Repository(string conStr) : base(conStr) { }

        public override void Save(Title_Content_Material obj)
        {
            if (obj.EntityState == State.Added)
            {
                base.Save(obj);
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(obj);
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(obj);
            }
        }

    }
}
