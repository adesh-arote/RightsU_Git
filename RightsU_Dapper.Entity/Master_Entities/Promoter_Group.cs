namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Promoter_Group")]
    public partial class Promoter_Group
    {
        public Promoter_Group()
        {
            this.Acq_Deal_Rights_Promoter_Group = new HashSet<Acq_Deal_Rights_Promoter_Group>();
            this.Syn_Deal_Rights_Promoter_Group = new HashSet<Syn_Deal_Rights_Promoter_Group>();
        }
        [PrimaryKey]
        public int? Promoter_Group_Code { get; set; }
        public string Promoter_Group_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public string Is_Last_Level { get; set; }
        public string Hierarchy_Name { get; set; }
        public string Display_Order { get; set; }
        public Nullable<int> Parent_Group_Code { get; set; }

        public virtual ICollection<Acq_Deal_Rights_Promoter_Group> Acq_Deal_Rights_Promoter_Group { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Promoter_Group> Syn_Deal_Rights_Promoter_Group { get; set; }
    }
}