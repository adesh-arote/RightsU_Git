using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;
using RightsU_Entities;

namespace RightsU_DAL
{
    public class Login_Details_Repository : RightsU_Repository<Login_Details>
    {
        public Login_Details_Repository(string conStr) : base(conStr) { }
        public override void Save(Login_Details objIPRR)
        {
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
    }
}
