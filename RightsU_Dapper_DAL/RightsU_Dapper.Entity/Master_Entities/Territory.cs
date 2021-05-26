using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Territory")]
    public partial class Territory
    {
        public Territory()
        {
            //this.Acq_Deal_Rights_Blackout_Territory = new HashSet<Acq_Deal_Rights_Blackout_Territory>();
            //this.Acq_Deal_Rights_Holdback_Territory = new HashSet<Acq_Deal_Rights_Holdback_Territory>();
            //this.Acq_Deal_Rights_Territory = new HashSet<Acq_Deal_Rights_Territory>();
            //this.Syn_Deal_Rights_Blackout_Territory = new HashSet<Syn_Deal_Rights_Blackout_Territory>();
            //this.Syn_Deal_Rights_Holdback_Territory = new HashSet<Syn_Deal_Rights_Holdback_Territory>();
            //this.Syn_Deal_Rights_Territory = new HashSet<Syn_Deal_Rights_Territory>();
            this.Territory_Details = new HashSet<Territory_Details>();
            //this.Acq_Deal_Pushback_Territory = new HashSet<Acq_Deal_Pushback_Territory>();
            //this.Acq_Deal_Mass_Territory_Update_Details = new HashSet<Acq_Deal_Mass_Territory_Update_Details>();
        }
        [PrimaryKey]
        public int? Territory_Code { get; set; }
        public string Territory_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public string Is_Ref_Acq { get; set; }
        public string Is_Ref_Syn { get; set; }
        public string Is_Thetrical { get; set; }

        //public virtual ICollection<Acq_Deal_Rights_Blackout_Territory> Acq_Deal_Rights_Blackout_Territory { get; set; }
        //public virtual ICollection<Acq_Deal_Rights_Holdback_Territory> Acq_Deal_Rights_Holdback_Territory { get; set; }
        //public virtual ICollection<Acq_Deal_Rights_Territory> Acq_Deal_Rights_Territory { get; set; }
        //public virtual ICollection<Syn_Deal_Rights_Blackout_Territory> Syn_Deal_Rights_Blackout_Territory { get; set; }
        //public virtual ICollection<Syn_Deal_Rights_Holdback_Territory> Syn_Deal_Rights_Holdback_Territory { get; set; }
        //public virtual ICollection<Syn_Deal_Rights_Territory> Syn_Deal_Rights_Territory { get; set; }
        [OneToMany]
        public virtual ICollection<Territory_Details> Territory_Details { get; set; }
        //public virtual ICollection<Acq_Deal_Pushback_Territory> Acq_Deal_Pushback_Territory { get; set; }
        //public virtual ICollection<Acq_Deal_Mass_Territory_Update_Details> Acq_Deal_Mass_Territory_Update_Details { get; set; }

    }
}
