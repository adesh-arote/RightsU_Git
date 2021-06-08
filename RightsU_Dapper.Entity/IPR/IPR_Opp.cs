﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper.SimpleSave;

namespace RightsU_Dapper.Entity
{
    [Table("IPR_Opp")]
    public partial class IPR_Opp
    {
        public IPR_Opp()
        {
            //this.IPR_Opp_Attachment = new HashSet<IPR_Opp_Attachment>();
            //this.IPR_Opp_Email_Freq = new HashSet<IPR_Opp_Email_Freq>();
            //this.IPR_Opp_Business_Unit = new HashSet<IPR_Opp_Business_Unit>();
            this.IPR_Opp_Channel = new HashSet<IPR_Opp_Channel>();
        }
        [PrimaryKey]
        public int? IPR_Opp_Code { get; set; }
        public string Version { get; set; }
        public string IPR_For { get; set; }
        public string Opp_No { get; set; }
        public Nullable<int> IPR_Rep_Code { get; set; }
        public string Party_Name { get; set; }
        public string Trademark { get; set; }
        public string Application_No { get; set; }
        public Nullable<int> IPR_Class_Code { get; set; }
        public Nullable<int> IPR_App_Status_Code { get; set; }
        public string Journal_No { get; set; }
        public Nullable<System.DateTime> Publication_Date { get; set; }
        public string Page_No { get; set; }
        public Nullable<System.DateTime> Date_Counter_Statement { get; set; }
        public Nullable<System.DateTime> Date_Evidence_UR50 { get; set; }
        public Nullable<System.DateTime> Date_Evidence_UR51 { get; set; }
        public Nullable<System.DateTime> Date_Opposition_Notice { get; set; }
        public Nullable<System.DateTime> Date_Rebuttal_UR52 { get; set; }
        public Nullable<System.DateTime> Deadline_Counter_Statement { get; set; }
        public Nullable<System.DateTime> Deadline_Evidence_UR50 { get; set; }
        public Nullable<System.DateTime> Deadline_Evidence_UR51 { get; set; }
        public Nullable<System.DateTime> Deadline_Opposition_Notice { get; set; }
        public Nullable<System.DateTime> Deadline_Rebuttal_UR52 { get; set; }
        public Nullable<System.DateTime> Order_Date { get; set; }
        public string Outcomes { get; set; }
        public string Comments { get; set; }
        public Nullable<System.DateTime> Creation_Date { get; set; }
        public Nullable<int> Created_By { get; set; }
        public string Workflow_Status { get; set; }
        public Nullable<int> IPR_Opp_Status_Code { get; set; }

        //public virtual IPR_APP_STATUS IPR_APP_STATUS { get; set; }
        //public virtual IPR_CLASS IPR_CLASS { get; set; }
        //public virtual ICollection<IPR_Opp_Attachment> IPR_Opp_Attachment { get; set; }
        //public virtual ICollection<IPR_Opp_Email_Freq> IPR_Opp_Email_Freq { get; set; }
        //public virtual IPR_Opp_Status IPR_Opp_Status { get; set; }
        public virtual IPR_REP IPR_REP { get; set; }
        //public virtual ICollection<IPR_Opp_Business_Unit> IPR_Opp_Business_Unit { get; set; }
        public virtual ICollection<IPR_Opp_Channel> IPR_Opp_Channel { get; set; }
    }
}
