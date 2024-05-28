using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RightsU_Entities;

namespace RightsU_DAL
{
    public class System_Module_Repository : RightsU_Repository<System_Module>
    {
        public System_Module_Repository(string conStr) : base(conStr) { }

        public override void Save(System_Module objToSave)
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
        public override void Delete(System_Module objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class System_Right_Repository : RightsU_Repository<System_Right>
    {
        public System_Right_Repository(string conStr) : base(conStr) { }
    }

    public class System_Module_Right_Repository : RightsU_Repository<System_Module_Right>
    {
        public System_Module_Right_Repository(string conStr) : base(conStr) { }
    }

    public class Security_Group_Repository : RightsU_Repository<Security_Group>
    {
        public Security_Group_Repository(string conStr) : base(conStr) { }

        public override void Save(Security_Group objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();
            if (objToSave.Security_Group_Rel != null) objToSave.Security_Group_Rel = objSaveEntities.SaveSecurityGroupRel(objToSave.Security_Group_Rel, base.DataContext);

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
        public override void Delete(Security_Group objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Security_Group_Rel_Repository : RightsU_Repository<Security_Group_Rel>
    {
        public Security_Group_Rel_Repository(string conStr) : base(conStr) { }
    }

    public class System_Module_Message_Repository : RightsU_Repository<System_Module_Message>
    {
        public System_Module_Message_Repository(string conStr) : base(conStr) { }

        public override void Save(System_Module_Message objToSave)
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
        public override void Delete(System_Module_Message objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

}
