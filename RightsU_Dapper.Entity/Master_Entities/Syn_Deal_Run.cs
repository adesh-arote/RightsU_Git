
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Syn_Deal_Run")]
    public partial class Syn_Deal_Run
    {
        public Syn_Deal_Run()
        {
            //this.Syn_Deal_Run_Platform = new HashSet<Syn_Deal_Run_Platform>();
            //this.Syn_Deal_Run_Repeat_On_Day = new HashSet<Syn_Deal_Run_Repeat_On_Day>();
            //this.Syn_Deal_Run_Yearwise_Run = new HashSet<Syn_Deal_Run_Yearwise_Run>();
        }
        [PrimaryKey]
        public int? Syn_Deal_Run_Code { get; set; }
        [ForeignKeyReference(typeof(Syn_Deal))]
        public Nullable<int> Syn_Deal_Code { get; set; }
        public Nullable<int> Title_Code { get; set; }
        public Nullable<int> Episode_From { get; set; }
        public Nullable<int> Episode_To { get; set; }
        public string Run_Type { get; set; }
        public Nullable<int> No_Of_Runs { get; set; }
        public string Is_Yearwise_Definition { get; set; }
        public string Is_Rule_Right { get; set; }
        public string Repeat_Within_Days_Hrs { get; set; }
        public Nullable<int> Right_Rule_Code { get; set; }
        public Nullable<int> No_Of_Days_Hrs { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Last_action_By { get; set; }
        public Nullable<System.DateTime> Last_updated_Time { get; set; }

        public virtual Right_Rule Right_Rule { get; set; }
        public virtual Syn_Deal Syn_Deal { get; set; }
        //public virtual ICollection<Syn_Deal_Run_Platform> Syn_Deal_Run_Platform { get; set; }
        //public virtual ICollection<Syn_Deal_Run_Repeat_On_Day> Syn_Deal_Run_Repeat_On_Day { get; set; }
        public virtual Title Title { get; set; }
       // public virtual ICollection<Syn_Deal_Run_Yearwise_Run> Syn_Deal_Run_Yearwise_Run { get; set; }
    }
}


