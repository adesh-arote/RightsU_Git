//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;
    
    public partial class Acq_Deal_Run_Channel
    {
        public State EntityState { get; set; }
        public int Acq_Deal_Run_Channel_Code { get; set; }

        public Nullable<int> Acq_Deal_Run_Code { get; set; }

        public Nullable<int> Channel_Code { get; set; }

        public Nullable<int> Min_Runs { get; set; }

        public Nullable<int> Max_Runs { get; set; }

        public Nullable<int> No_Of_Runs_Sched { get; set; }

        public Nullable<int> No_Of_AsRuns { get; set; }

        public string Do_Not_Consume_Rights { get; set; }

        public string Is_Primary { get; set; }

        public Nullable<int> Inserted_By { get; set; }

        public Nullable<System.DateTime> Inserted_On { get; set; }

        public Nullable<int> Last_action_By { get; set; }

        public Nullable<System.DateTime> Last_updated_Time { get; set; }

        public virtual Acq_Deal_Run Acq_Deal_Run { get; set; }

        private string _ChannelNames;
        public string ChannelNames
        {
            get { return this._ChannelNames; }
            set { this._ChannelNames = value; }
        }        
    }
}
