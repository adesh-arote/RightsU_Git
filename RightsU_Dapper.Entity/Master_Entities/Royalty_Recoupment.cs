﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
    using RightsU_Entities;

    [Table("Royalty_Recoupment")]
    public partial class Royalty_Recoupment
    {
        public Royalty_Recoupment()
        {
            this.Royalty_Recoupment_Details = new HashSet<Royalty_Recoupment_Details>();
            this.Acq_Deal_Cost = new HashSet<Acq_Deal_Cost>();
            this.Syn_Deal_Revenue = new HashSet<Syn_Deal_Revenue>();
        }
        [PrimaryKey]
        public int? Royalty_Recoupment_Code { get; set; }
        public string Royalty_Recoupment_Name { get; set; }
        public string Is_Active { get; set; }
        public System.DateTime Inserted_On { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }

        [OneToMany]
        public virtual ICollection<Royalty_Recoupment_Details> Royalty_Recoupment_Details { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Cost> Acq_Deal_Cost { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Revenue> Syn_Deal_Revenue { get; set; }
    }
}