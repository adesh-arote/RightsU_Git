namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Syn_Deal_Rights_Promoter_Remarks")]
    public partial class Syn_Deal_Rights_Promoter_Remarks
    {
        [PrimaryKey]
        public int? Syn_Deal_Rights_Promoter_Remarks_Code { get; set; }
        [ForeignKeyReference(typeof(Syn_Deal_Rights_Promoter))]
        public Nullable<int> Syn_Deal_Rights_Promoter_Code { get; set; }
        [ForeignKeyReference(typeof(Promoter_Remarks))]
        public Nullable<int> Promoter_Remarks_Code { get; set; }

        //public virtual Promoter_Remarks Promoter_Remarks { get; set; }
        //public virtual Syn_Deal_Rights_Promoter Syn_Deal_Rights_Promoter { get; set; }
    }
}