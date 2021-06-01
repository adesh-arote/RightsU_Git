﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
    using RightsU_Entities;

    [Table("Entity")]
    public partial class Entity
    {
        public Entity()
        {
            this.Acq_Deal = new HashSet<Acq_Deal>();
            this.Syn_Deal = new HashSet<Syn_Deal>();
            this.Acq_Deal_Cost_Variable_Cost = new HashSet<Acq_Deal_Cost_Variable_Cost>();
            this.Syn_Deal_Revenue_Variable_Cost = new HashSet<Syn_Deal_Revenue_Variable_Cost>();
            this.Acq_Deal_Cost_Commission = new HashSet<Acq_Deal_Cost_Commission>();
            this.Syn_Deal_Revenue_Commission = new HashSet<Syn_Deal_Revenue_Commission>();
            this.Music_Deal = new HashSet<Music_Deal>();
            this.Provisional_Deal = new HashSet<Provisional_Deal>();
        }
        [PrimaryKey]
        public int? Entity_Code { get; set; }
        public string Entity_Name { get; set; }
        public System.DateTime Inserted_On { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public string Logo_Path { get; set; }
        public string Logo_Name { get; set; }
        public Nullable<int> ParentEntityCode { get; set; }

        [OneToMany]
        public virtual ICollection<Acq_Deal> Acq_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal> Syn_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Cost_Variable_Cost> Acq_Deal_Cost_Variable_Cost { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Revenue_Variable_Cost> Syn_Deal_Revenue_Variable_Cost { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Cost_Commission> Acq_Deal_Cost_Commission { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Revenue_Commission> Syn_Deal_Revenue_Commission { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Deal> Music_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Provisional_Deal> Provisional_Deal { get; set; }

    }
}
