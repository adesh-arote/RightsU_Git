
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Acq_Deal")]
    public partial class Acq_Deal_Run
    {
        public Acq_Deal_Run()
        {
            //this.Acq_Deal_Run_Channel = new HashSet<Acq_Deal_Run_Channel>();
            //this.Acq_Deal_Run_Repeat_On_Day = new HashSet<Acq_Deal_Run_Repeat_On_Day>();
            //this.Acq_Deal_Run_Title = new HashSet<Acq_Deal_Run_Title>();
            //this.Acq_Deal_Run_Yearwise_Run = new HashSet<Acq_Deal_Run_Yearwise_Run>();
            //this.Acq_Deal_Run_Shows = new HashSet<Acq_Deal_Run_Shows>();
        }
        [PrimaryKey]
        public int? Acq_Deal_Run_Code { get; set; }
        [ForeignKeyReference(typeof(Acq_Deal))]
        public Nullable<int> Acq_Deal_Code { get; set; }
        public string Run_Type { get; set; }
        public Nullable<int> No_Of_Runs { get; set; }
        public Nullable<int> No_Of_Runs_Sched { get; set; }
        public Nullable<int> No_Of_AsRuns { get; set; }
        public string Is_Yearwise_Definition { get; set; }
        public string Is_Rule_Right { get; set; }
        public Nullable<int> Right_Rule_Code { get; set; }
        public string Repeat_Within_Days_Hrs { get; set; }
        public Nullable<int> No_Of_Days_Hrs { get; set; }
        public string Is_Channel_Definition_Rights { get; set; }
        public Nullable<int> Primary_Channel_Code { get; set; }
        public string Run_Definition_Type { get; set; }
        public Nullable<int> Run_Definition_Group_Code { get; set; }
        public string All_Channel { get; set; }
        public Nullable<System.TimeSpan> Prime_Start_Time { get; set; }
        public Nullable<System.TimeSpan> Prime_End_Time { get; set; }
        public Nullable<System.TimeSpan> Off_Prime_Start_Time { get; set; }
        public Nullable<System.TimeSpan> Off_Prime_End_Time { get; set; }
        public Nullable<System.TimeSpan> Time_Lag_Simulcast { get; set; }
        public Nullable<int> Prime_Run { get; set; }
        public Nullable<int> Off_Prime_Run { get; set; }
        public Nullable<int> Prime_Time_Provisional_Run_Count { get; set; }
        public Nullable<int> Prime_Time_AsRun_Count { get; set; }
        public Nullable<int> Prime_Time_Balance_Count { get; set; }
        public Nullable<int> Off_Prime_Time_Provisional_Run_Count { get; set; }
        public Nullable<int> Off_Prime_Time_AsRun_Count { get; set; }
        public Nullable<int> Off_Prime_Time_Balance_Count { get; set; }
        public Nullable<int> Syndication_Runs { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Last_action_By { get; set; }
        public Nullable<System.DateTime> Last_updated_Time { get; set; }
        public string Channel_Type { get; set; }
        public Nullable<int> Channel_Category_Code { get; set; }
        public virtual Acq_Deal Acq_Deal { get; set; }
        public virtual Channel Channel { get; set; }
        //public virtual ICollection<Acq_Deal_Run_Channel> Acq_Deal_Run_Channel { get; set; }
        //public virtual ICollection<Acq_Deal_Run_Repeat_On_Day> Acq_Deal_Run_Repeat_On_Day { get; set; }
        public virtual Right_Rule Right_Rule { get; set; }
        //public virtual ICollection<Acq_Deal_Run_Title> Acq_Deal_Run_Title { get; set; }
        //public virtual ICollection<Acq_Deal_Run_Yearwise_Run> Acq_Deal_Run_Yearwise_Run { get; set; }
        //public virtual ICollection<Acq_Deal_Run_Shows> Acq_Deal_Run_Shows { get; set; }
    }
}

