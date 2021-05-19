
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Platform")]
    public partial class Platform
    {
        public Platform()
        {
            //this.Acq_Deal_Rights_Blackout_Platform = new HashSet<Acq_Deal_Rights_Blackout_Platform>();
            //this.Acq_Deal_Rights_Holdback_Platform = new HashSet<Acq_Deal_Rights_Holdback_Platform>();
            //this.Acq_Deal_Rights_Platform = new HashSet<Acq_Deal_Rights_Platform>();
            //this.Syn_Deal_Rights_Blackout_Platform = new HashSet<Syn_Deal_Rights_Blackout_Platform>();
            //this.Syn_Deal_Rights_Holdback_Platform = new HashSet<Syn_Deal_Rights_Holdback_Platform>();
            //this.Syn_Deal_Rights_Platform = new HashSet<Syn_Deal_Rights_Platform>();
            //this.Acq_Deal_Pushback_Platform = new HashSet<Acq_Deal_Pushback_Platform>();
            //this.Syn_Deal_Revenue_Platform = new HashSet<Syn_Deal_Revenue_Platform>();
            //this.Acq_Deal_Sport_Platform = new HashSet<Acq_Deal_Sport_Platform>();
            //this.Avail_Acq = new HashSet<Avail_Acq>();
            //this.Syn_Deal_Run_Platform = new HashSet<Syn_Deal_Run_Platform>();
            this.Platform_Group_Details = new HashSet<Platform_Group_Details>();
            //this.Title_Release_Platforms = new HashSet<Title_Release_Platforms>();
            //this.Acq_Deal_Ancillary_Platform = new HashSet<Acq_Deal_Ancillary_Platform>();

        }
        [PrimaryKey]
        public int? Platform_Code { get; set; }
        public string Platform_Name { get; set; }
        public string Is_No_Of_Run { get; set; }
        public string Applicable_For_Holdback { get; set; }
        public string Applicable_For_Demestic_Territory { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public string Applicable_For_Asrun_Schedule { get; set; }
        public Nullable<int> Parent_Platform_Code { get; set; }
        public string Is_Last_Level { get; set; }
        public string Module_Position { get; set; }
        public Nullable<int> Base_Platform_Code { get; set; }
        public string Platform_Hiearachy { get; set; }
        public string Is_Sport_Right { get; set; }
        public string Is_Applicable_Syn_Run { get; set; }

        //public virtual ICollection<Acq_Deal_Rights_Blackout_Platform> Acq_Deal_Rights_Blackout_Platform { get; set; }
        //public virtual ICollection<Acq_Deal_Rights_Holdback_Platform> Acq_Deal_Rights_Holdback_Platform { get; set; }
        //public virtual ICollection<Acq_Deal_Rights_Platform> Acq_Deal_Rights_Platform { get; set; }
        //public virtual ICollection<Syn_Deal_Rights_Blackout_Platform> Syn_Deal_Rights_Blackout_Platform { get; set; }
        //public virtual ICollection<Syn_Deal_Rights_Holdback_Platform> Syn_Deal_Rights_Holdback_Platform { get; set; }
        //public virtual ICollection<Syn_Deal_Rights_Platform> Syn_Deal_Rights_Platform { get; set; }
        //public virtual ICollection<Acq_Deal_Pushback_Platform> Acq_Deal_Pushback_Platform { get; set; }
        //public virtual ICollection<Syn_Deal_Revenue_Platform> Syn_Deal_Revenue_Platform { get; set; }
        //public virtual ICollection<Acq_Deal_Sport_Platform> Acq_Deal_Sport_Platform { get; set; }
        //public virtual ICollection<Avail_Acq> Avail_Acq { get; set; }
        //public virtual ICollection<Syn_Deal_Run_Platform> Syn_Deal_Run_Platform { get; set; }
        public virtual ICollection<Platform_Group_Details> Platform_Group_Details { get; set; }
        //public virtual ICollection<Title_Release_Platforms> Title_Release_Platforms { get; set; }
        //public virtual ICollection<Acq_Deal_Ancillary_Platform> Acq_Deal_Ancillary_Platform { get; set; }

    }
}

