
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Business_Unit")]
    public partial class Business_Unit
    {
        public Business_Unit()
        {
            this.Acq_Deal = new HashSet<Acq_Deal>();
            //this.Users_Business_Unit = new HashSet<Users_Business_Unit>();
            //this.Workflow_BU = new HashSet<Workflow_BU>();
            //this.Workflow_Module_BU = new HashSet<Workflow_Module_BU>();
            //this.Workflows = new HashSet<Workflow>();
            //this.Workflow_Module = new HashSet<Workflow_Module>();
            this.Syn_Deal = new HashSet<Syn_Deal>();
            //this.IPR_Opp_Business_Unit = new HashSet<IPR_Opp_Business_Unit>();
            //this.IPR_Rep_Business_Unit = new HashSet<IPR_Rep_Business_Unit>();
            this.Music_Deal = new HashSet<Music_Deal>();
            //this.Provisional_Deal = new HashSet<Provisional_Deal>();
        }
        [PrimaryKey]
        public int? Business_Unit_Code { get; set; }
        public string Business_Unit_Name { get; set; }
        public string Is_Active { get; set; }

        public virtual ICollection<Acq_Deal> Acq_Deal { get; set; }
        //public virtual ICollection<Users_Business_Unit> Users_Business_Unit { get; set; }
        //public virtual ICollection<Workflow_BU> Workflow_BU { get; set; }
        //public virtual ICollection<Workflow_Module_BU> Workflow_Module_BU { get; set; }
        //public virtual ICollection<Workflow> Workflows { get; set; }
        //public virtual ICollection<Workflow_Module> Workflow_Module { get; set; }
        public virtual ICollection<Syn_Deal> Syn_Deal { get; set; }
        //public virtual ICollection<IPR_Opp_Business_Unit> IPR_Opp_Business_Unit { get; set; }
        //public virtual ICollection<IPR_Rep_Business_Unit> IPR_Rep_Business_Unit { get; set; }
        public virtual ICollection<Music_Deal> Music_Deal { get; set; }
       // public virtual ICollection<Provisional_Deal> Provisional_Deal { get; set; }
    }
}


