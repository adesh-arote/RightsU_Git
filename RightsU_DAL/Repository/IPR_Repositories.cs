using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;
using RightsU_Entities;

namespace RightsU_DAL
{
    public class IPR_TYPE_Repository : RightsU_Repository<IPR_TYPE>
    {
        public IPR_TYPE_Repository(string conStr) : base(conStr) { }
    }

    public class IPR_ENTITY_Repository : RightsU_Repository<IPR_ENTITY>
    {
        public IPR_ENTITY_Repository(string conStr) : base(conStr) { }
    }

    public class IPR_APP_STATUS_Repository : RightsU_Repository<IPR_APP_STATUS>
    {
        public IPR_APP_STATUS_Repository(string conStr) : base(conStr) { }
    }

    public class IPR_CLASS_Repository : RightsU_Repository<IPR_CLASS>
    {
        public IPR_CLASS_Repository(string conStr) : base(conStr) { }
    }

    public class IPR_Country_Repository : RightsU_Repository<IPR_Country>
    {
        public IPR_Country_Repository(string conStr) : base(conStr) { }

        public override void Save(IPR_Country obj)
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

        public override void Delete(IPR_Country obj)
        {
            base.Delete(obj);
        }
    }

    public class IPR_REP_Repository : RightsU_Repository<IPR_REP>
    {
        public IPR_REP_Repository(string conStr) : base(conStr) { }

        public override void Save(IPR_REP objIPRR)
        {
            Save_IPR_REP_Entities_Generic objSaveEntities = new Save_IPR_REP_Entities_Generic();

            if (objIPRR.IPR_REP_ATTACHMENTS != null) objIPRR.IPR_REP_ATTACHMENTS = objSaveEntities.SaveAttachments(objIPRR.IPR_REP_ATTACHMENTS, base.DataContext);
            if (objIPRR.IPR_REP_EMAIL_FREQ != null) objIPRR.IPR_REP_EMAIL_FREQ = objSaveEntities.SaveEmailFreq(objIPRR.IPR_REP_EMAIL_FREQ, base.DataContext);
            if (objIPRR.IPR_REP_STATUS_HISTORY != null) objIPRR.IPR_REP_STATUS_HISTORY = objSaveEntities.SaveStatusHistory(objIPRR.IPR_REP_STATUS_HISTORY, base.DataContext);
            if (objIPRR.IPR_REP_CLASS != null) objIPRR.IPR_REP_CLASS = objSaveEntities.SaveClass(objIPRR.IPR_REP_CLASS, base.DataContext);
            if (objIPRR.IPR_Rep_Business_Unit != null) objIPRR.IPR_Rep_Business_Unit = objSaveEntities.SaveBusinessUnit(objIPRR.IPR_Rep_Business_Unit, base.DataContext);
            if (objIPRR.IPR_Rep_Channel != null) objIPRR.IPR_Rep_Channel = objSaveEntities.SaveChannel(objIPRR.IPR_Rep_Channel, base.DataContext);

            if (objIPRR.EntityState == State.Added)
            {
                base.Save(objIPRR);
            }
            else if (objIPRR.EntityState == State.Modified)
            {
                base.Update(objIPRR);
            }
            else if (objIPRR.EntityState == State.Deleted)
            {
                base.Delete(objIPRR);
            }
        }

        public override void Delete(IPR_REP objIPRR)
        {
            Save_IPR_REP_Entities_Generic objSaveEntities = new Save_IPR_REP_Entities_Generic();
            objSaveEntities.DeleteAttachments(objIPRR.IPR_REP_ATTACHMENTS, base.DataContext);
            objSaveEntities.DeleteStatusHistory(objIPRR.IPR_REP_STATUS_HISTORY, base.DataContext);
            objSaveEntities.DeleteEmailFreq(objIPRR.IPR_REP_EMAIL_FREQ, base.DataContext);
            objSaveEntities.DeleteClass(objIPRR.IPR_REP_CLASS, base.DataContext);
            objSaveEntities.DeleteBusinessUnit(objIPRR.IPR_Rep_Business_Unit, base.DataContext);
            objSaveEntities.DeleteChannel(objIPRR.IPR_Rep_Channel, base.DataContext);

            base.Delete(objIPRR);
        }
    }

    public class IPR_REP_CLass_Repository : RightsU_Repository<IPR_REP_CLASS>
    {
        public IPR_REP_CLass_Repository(string conStr) : base(conStr) { }

        public override void Save(IPR_REP_CLASS objIPRR)
        {
            Save_IPR_REP_Entities_Generic objSaveEntities = new Save_IPR_REP_Entities_Generic();

            //if (objIPRR.IPR_REP_ATTACHMENTS != null) objIPRR.IPR_REP_ATTACHMENTS = objSaveEntities.SaveAttachments(objIPRR.IPR_REP_ATTACHMENTS, base.DataContext);
            //if (objIPRR.IPR_REP_EMAIL_FREQ != null) objIPRR.IPR_REP_EMAIL_FREQ = objSaveEntities.SaveEmailFreq(objIPRR.IPR_REP_EMAIL_FREQ, base.DataContext);
            //if (objIPRR.IPR_REP_STATUS_HISTORY != null) objIPRR.IPR_REP_STATUS_HISTORY = objSaveEntities.SaveStatusHistory(objIPRR.IPR_REP_STATUS_HISTORY, base.DataContext);
            //if (objIPRR.IPR_REP_CLASS != null) objIPRR.IPR_REP_CLASS = objSaveEntities.SaveClass(objIPRR.IPR_REP_CLASS, base.DataContext);
            //if (objIPRR.IPR_Rep_Business_Unit != null) objIPRR.IPR_Rep_Business_Unit = objSaveEntities.SaveBusinessUnit(objIPRR.IPR_Rep_Business_Unit, base.DataContext);
            //if (objIPRR.IPR_Rep_Channel != null) objIPRR.IPR_Rep_Channel = objSaveEntities.SaveChannel(objIPRR.IPR_Rep_Channel, base.DataContext);

            if (objIPRR.EntityState == State.Added)
            {
                base.Save(objIPRR);
            }
            else if (objIPRR.EntityState == State.Modified)
            {
                base.Update(objIPRR);
            }
            else if (objIPRR.EntityState == State.Deleted)
            {
                base.Delete(objIPRR);
            }
        }

        //public override void Delete(IPR_REP objIPRR)
        //{
        //    Save_IPR_REP_Entities_Generic objSaveEntities = new Save_IPR_REP_Entities_Generic();
        //    objSaveEntities.DeleteAttachments(objIPRR.IPR_REP_ATTACHMENTS, base.DataContext);
        //    objSaveEntities.DeleteStatusHistory(objIPRR.IPR_REP_STATUS_HISTORY, base.DataContext);
        //    objSaveEntities.DeleteEmailFreq(objIPRR.IPR_REP_EMAIL_FREQ, base.DataContext);
        //    objSaveEntities.DeleteClass(objIPRR.IPR_REP_CLASS, base.DataContext);
        //    objSaveEntities.DeleteBusinessUnit(objIPRR.IPR_Rep_Business_Unit, base.DataContext);
        //    objSaveEntities.DeleteChannel(objIPRR.IPR_Rep_Channel, base.DataContext);

        //    base.Delete(objIPRR);
        //}
    }

    public class IPR_REP_ATTACHMENTS_Repository : RightsU_Repository<IPR_REP_ATTACHMENTS>
    {
        public IPR_REP_ATTACHMENTS_Repository(string conStr) : base(conStr) { }
    }

    public class IPR_REP_STATUS_HISTORY_Repository : RightsU_Repository<IPR_REP_STATUS_HISTORY>
    {
        public IPR_REP_STATUS_HISTORY_Repository(string conStr) : base(conStr) { }
    }

    public class IPR_REP_CLASS_Repository : RightsU_Repository<IPR_REP_CLASS>
    {
        public IPR_REP_CLASS_Repository(string conStr) : base(conStr) { }
    }

    public class IPR_Opp_Repository : RightsU_Repository<IPR_Opp>
    {
        public IPR_Opp_Repository(string conStr) : base(conStr) { }

        public override void Save(IPR_Opp objIPR_Opp)
        {
            Save_IPR_Opp_Entities_Generic objSaveEntities = new Save_IPR_Opp_Entities_Generic();

            if (objIPR_Opp.IPR_Opp_Attachment != null) objIPR_Opp.IPR_Opp_Attachment = objSaveEntities.SaveAttachments(objIPR_Opp.IPR_Opp_Attachment, base.DataContext);
            if (objIPR_Opp.IPR_Opp_Email_Freq != null) objIPR_Opp.IPR_Opp_Email_Freq = objSaveEntities.SaveEmailFreq(objIPR_Opp.IPR_Opp_Email_Freq, base.DataContext);
            if (objIPR_Opp.IPR_Opp_Business_Unit != null) objIPR_Opp.IPR_Opp_Business_Unit = objSaveEntities.SaveBusinessUnit(objIPR_Opp.IPR_Opp_Business_Unit, base.DataContext);
            if (objIPR_Opp.IPR_Opp_Channel != null) objIPR_Opp.IPR_Opp_Channel = objSaveEntities.SaveChannel(objIPR_Opp.IPR_Opp_Channel, base.DataContext);

            if (objIPR_Opp.EntityState == State.Added)
            {
                base.Save(objIPR_Opp);
            }
            else if (objIPR_Opp.EntityState == State.Modified)
            {
                base.Update(objIPR_Opp);
            }
            else if (objIPR_Opp.EntityState == State.Deleted)
            {
                base.Delete(objIPR_Opp);
            }
        }

        public override void Delete(IPR_Opp objIPR_Opp)
        {
            Save_IPR_Opp_Entities_Generic objSaveEntities = new Save_IPR_Opp_Entities_Generic();
            objSaveEntities.DeleteAttachments(objIPR_Opp.IPR_Opp_Attachment, base.DataContext);
            objSaveEntities.DeleteEmailFreq(objIPR_Opp.IPR_Opp_Email_Freq, base.DataContext);
            objSaveEntities.DeleteBusinessUnit(objIPR_Opp.IPR_Opp_Business_Unit, base.DataContext);
            objSaveEntities.DeleteChannel(objIPR_Opp.IPR_Opp_Channel, base.DataContext);
            base.Delete(objIPR_Opp);
        }
    }

    public class IPR_Opp_Status_Repository : RightsU_Repository<IPR_Opp_Status>
    {
        public IPR_Opp_Status_Repository(string conStr) : base(conStr) { }
    }

    public class IPR_Opp_Attachment_Repository : RightsU_Repository<IPR_Opp_Attachment>
    {
        public IPR_Opp_Attachment_Repository(string conStr) : base(conStr) { }
    }

    public class Save_IPR_REP_Entities_Generic
    {
        public ICollection<IPR_REP_ATTACHMENTS> SaveAttachments(ICollection<IPR_REP_ATTACHMENTS> entityAttachment, DbContext dbContext)
        {
            ICollection<IPR_REP_ATTACHMENTS> UpdatedAttachment = entityAttachment;
            UpdatedAttachment = new Save_Entitiy_Lists_Generic<IPR_REP_ATTACHMENTS>().SetListFlagsCUD(UpdatedAttachment, dbContext);
            return UpdatedAttachment;
        }

        public void DeleteAttachments(ICollection<IPR_REP_ATTACHMENTS> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.IPR_REP_ATTACHMENTS.RemoveRange(deleteList);
        }

        public ICollection<IPR_REP_STATUS_HISTORY> SaveStatusHistory(ICollection<IPR_REP_STATUS_HISTORY> entityStatusHistory, DbContext dbContext)
        {
            ICollection<IPR_REP_STATUS_HISTORY> UpdatedStatusHistory = entityStatusHistory;
            UpdatedStatusHistory = new Save_Entitiy_Lists_Generic<IPR_REP_STATUS_HISTORY>().SetListFlagsCUD(UpdatedStatusHistory, dbContext);
            return UpdatedStatusHistory;
        }

        public void DeleteStatusHistory(ICollection<IPR_REP_STATUS_HISTORY> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.IPR_REP_STATUS_HISTORY.RemoveRange(deleteList);
        }

        public ICollection<IPR_REP_EMAIL_FREQ> SaveEmailFreq(ICollection<IPR_REP_EMAIL_FREQ> entityEmailFreq, DbContext dbContext)
        {
            ICollection<IPR_REP_EMAIL_FREQ> UpdatedEmailFreq = entityEmailFreq;
            UpdatedEmailFreq = new Save_Entitiy_Lists_Generic<IPR_REP_EMAIL_FREQ>().SetListFlagsCUD(UpdatedEmailFreq, dbContext);
            return UpdatedEmailFreq;
        }

        public void DeleteEmailFreq(ICollection<IPR_REP_EMAIL_FREQ> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.IPR_REP_EMAIL_FREQ.RemoveRange(deleteList);
        }

        public ICollection<IPR_REP_CLASS> SaveClass(ICollection<IPR_REP_CLASS> entityClass, DbContext dbContext)
        {
            ICollection<IPR_REP_CLASS> UpdatedClass = entityClass;
            UpdatedClass = new Save_Entitiy_Lists_Generic<IPR_REP_CLASS>().SetListFlagsCUD(UpdatedClass, dbContext);
            UpdatedClass = new Save_Entitiy_Lists_Generic<IPR_REP_CLASS>().SetListFlagsCUD(UpdatedClass, dbContext);
            return UpdatedClass;
        }

        public void DeleteClass(ICollection<IPR_REP_CLASS> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.IPR_REP_CLASS.RemoveRange(deleteList);
        }

        public ICollection<IPR_Rep_Business_Unit> SaveBusinessUnit(ICollection<IPR_Rep_Business_Unit> entityBusinessUnit, DbContext dbContext)
        {
            ICollection<IPR_Rep_Business_Unit> UpdatedBusinessUnit = entityBusinessUnit;
            UpdatedBusinessUnit = new Save_Entitiy_Lists_Generic<IPR_Rep_Business_Unit>().SetListFlagsCUD(UpdatedBusinessUnit, dbContext);
            return UpdatedBusinessUnit;
        }

        public void DeleteBusinessUnit(ICollection<IPR_Rep_Business_Unit> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.IPR_Rep_Business_Unit.RemoveRange(deleteList);
        }

        public ICollection<IPR_Rep_Channel> SaveChannel(ICollection<IPR_Rep_Channel> entityChannel, DbContext dbContext)
        {
            ICollection<IPR_Rep_Channel> UpdatedChannel = entityChannel;
            UpdatedChannel = new Save_Entitiy_Lists_Generic<IPR_Rep_Channel>().SetListFlagsCUD(UpdatedChannel, dbContext);
            return UpdatedChannel;
        }

        public void DeleteChannel(ICollection<IPR_Rep_Channel> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.IPR_Rep_Channel.RemoveRange(deleteList);
        }
    }

    public class Save_IPR_Opp_Entities_Generic
    {
        public ICollection<IPR_Opp_Attachment> SaveAttachments(ICollection<IPR_Opp_Attachment> entityAttachment, DbContext dbContext)
        {
            ICollection<IPR_Opp_Attachment> UpdatedAttachment = entityAttachment;
            UpdatedAttachment = new Save_Entitiy_Lists_Generic<IPR_Opp_Attachment>().SetListFlagsCUD(UpdatedAttachment, dbContext);
            return UpdatedAttachment;
        }

        public void DeleteAttachments(ICollection<IPR_Opp_Attachment> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.IPR_Opp_Attachment.RemoveRange(deleteList);
        }

        public ICollection<IPR_Opp_Email_Freq> SaveEmailFreq(ICollection<IPR_Opp_Email_Freq> entityEmailFreq, DbContext dbContext)
        {
            ICollection<IPR_Opp_Email_Freq> UpdatedEmailFreq = entityEmailFreq;
            UpdatedEmailFreq = new Save_Entitiy_Lists_Generic<IPR_Opp_Email_Freq>().SetListFlagsCUD(UpdatedEmailFreq, dbContext);
            return UpdatedEmailFreq;
        }

        public void DeleteEmailFreq(ICollection<IPR_Opp_Email_Freq> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.IPR_Opp_Email_Freq.RemoveRange(deleteList);
        }

        public ICollection<IPR_Opp_Business_Unit> SaveBusinessUnit(ICollection<IPR_Opp_Business_Unit> entityBusinessUnit, DbContext dbContext)
        {
            ICollection<IPR_Opp_Business_Unit> UpdatedBusinessUnit = entityBusinessUnit;
            UpdatedBusinessUnit = new Save_Entitiy_Lists_Generic<IPR_Opp_Business_Unit>().SetListFlagsCUD(UpdatedBusinessUnit, dbContext);
            return UpdatedBusinessUnit;
        }

        public void DeleteBusinessUnit(ICollection<IPR_Opp_Business_Unit> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.IPR_Opp_Business_Unit.RemoveRange(deleteList);
        }

        public ICollection<IPR_Opp_Channel> SaveChannel(ICollection<IPR_Opp_Channel> entityChannel, DbContext dbContext)
        {
            ICollection<IPR_Opp_Channel> UpdatedChannel = entityChannel;
            UpdatedChannel = new Save_Entitiy_Lists_Generic<IPR_Opp_Channel>().SetListFlagsCUD(UpdatedChannel, dbContext);
            return UpdatedChannel;
        }

        public void DeleteChannel(ICollection<IPR_Opp_Channel> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.IPR_Opp_Channel.RemoveRange(deleteList);
        }
    }
}
