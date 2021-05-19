namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Promoter_Remarks")]
    public partial class Promoter_Remarks
    {
        public Promoter_Remarks()
        {
            this.Acq_Deal_Rights_Promoter_Remarks = new HashSet<Acq_Deal_Rights_Promoter_Remarks>();
            this.Syn_Deal_Rights_Promoter_Remarks = new HashSet<Syn_Deal_Rights_Promoter_Remarks>();
        }
        [PrimaryKey]
        public int? Promoter_Remarks_Code { get; set; }
        public string Promoter_Remark_Desc { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }

        [OneToMany]
        public virtual ICollection<Acq_Deal_Rights_Promoter_Remarks> Acq_Deal_Rights_Promoter_Remarks { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Rights_Promoter_Remarks> Syn_Deal_Rights_Promoter_Remarks { get; set; }
    }
}
