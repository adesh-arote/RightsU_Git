namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Right_Rule")]
    public partial class Right_Rule
    {
        public Right_Rule()
        {
            this.Acq_Deal_Run = new HashSet<Acq_Deal_Run>();
            this.Syn_Deal_Run = new HashSet<Syn_Deal_Run>();
            this.Music_Deal = new HashSet<Music_Deal>();
            this.Provisional_Deal_Run = new HashSet<Provisional_Deal_Run>();
        }
        [PrimaryKey]
        public int? Right_Rule_Code { get; set; }
        public string Right_Rule_Name { get; set; }
        public string Start_Time { get; set; }
        public Nullable<int> Play_Per_Day { get; set; }
        public Nullable<int> Duration_Of_Day { get; set; }
        public Nullable<int> No_Of_Repeat { get; set; }
        public System.DateTime Inserted_On { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public Nullable<bool> IS_First_Air { get; set; }
        public string Short_Key { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Run> Acq_Deal_Run { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Run> Syn_Deal_Run { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Deal> Music_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Provisional_Deal_Run> Provisional_Deal_Run { get; set; }
    }
}
