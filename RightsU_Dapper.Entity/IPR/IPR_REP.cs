﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper.SimpleSave;
using Dapper.SimpleLoad;
using RightsU_Entities;

namespace RightsU_Dapper.Entity
{
    [Table("IPR_REP")]
    public partial class IPR_REP
    {
        public IPR_REP()
        {
            this.IPR_REP_ATTACHMENTS = new HashSet<IPR_REP_ATTACHMENTS>();
            this.IPR_REP_EMAIL_FREQ = new HashSet<IPR_REP_EMAIL_FREQ>();
            this.IPR_REP_CLASS = new HashSet<IPR_REP_CLASS>();
            this.IPR_REP_STATUS_HISTORY = new HashSet<IPR_REP_STATUS_HISTORY>();
            this.IPR_Opp = new HashSet<IPR_Opp>();
            this.IPR_Rep_Business_Unit = new HashSet<IPR_Rep_Business_Unit>();
            this.IPR_Rep_Channel = new HashSet<IPR_Rep_Channel>();
        }
        [PrimaryKey]
        public int? IPR_Rep_Code { get; set; }
        public string Trademark_No { get; set; }
        public string Trademark { get; set; }
        public Nullable<int> IPR_Type_Code { get; set; }
        public string Application_No { get; set; }
        public Nullable<System.DateTime> Application_Date { get; set; }
        [ForeignKeyReference(typeof(Country))]
        public Nullable<int> Country_Code { get; set; }
        public string Proposed_Or_Date { get; set; }
        public Nullable<System.DateTime> Date_Of_Use { get; set; }
        public Nullable<int> Application_Status_Code { get; set; }
        public Nullable<System.DateTime> Renewed_Until { get; set; }
        public Nullable<int> Applicant_Code { get; set; }
        public string Trademark_Attorney { get; set; }
        public string Comments { get; set; }
        public Nullable<System.DateTime> Creation_Date { get; set; }
        public Nullable<int> Created_By { get; set; }
        public string Version { get; set; }
        public string Workflow_Status { get; set; }
        public string Class_Comments { get; set; }
        public Nullable<System.DateTime> Date_Of_Actual_Use { get; set; }
        public string International_Trademark_Attorney { get; set; }
        public Nullable<System.DateTime> Date_Of_Registration { get; set; }
        public string Registration_No { get; set; }
        public string IPR_For { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Country Country { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual IPR_APP_STATUS IPR_APP_STATUS { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual IPR_ENTITY IPR_ENTITY { get; set; }
        [OneToMany]
        public virtual ICollection<IPR_REP_ATTACHMENTS> IPR_REP_ATTACHMENTS { get; set; }
        [OneToMany]
        public virtual ICollection<IPR_REP_EMAIL_FREQ> IPR_REP_EMAIL_FREQ { get; set; }
        [OneToMany]
        public virtual ICollection<IPR_REP_CLASS> IPR_REP_CLASS { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual IPR_TYPE IPR_TYPE { get; set; }
        [OneToMany]
        public virtual ICollection<IPR_REP_STATUS_HISTORY> IPR_REP_STATUS_HISTORY { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual IPR_Country IPR_Country { get; set; }
        [OneToMany]
        public virtual ICollection<IPR_Opp> IPR_Opp { get; set; }
        [OneToMany]
        public virtual ICollection<IPR_Rep_Business_Unit> IPR_Rep_Business_Unit { get; set; }
        [OneToMany]
        public virtual ICollection<IPR_Rep_Channel> IPR_Rep_Channel { get; set; }
    }
}