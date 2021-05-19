namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Acq_Deal_Rights_Promoter_Remarks")]
    public partial class Acq_Deal_Rights_Promoter_Remarks
    {
        [PrimaryKey]
        public int? Acq_Deal_Rights_Promoter_Remarks_Code { get; set; }
        [ForeignKeyReference(typeof(Acq_Deal_Rights_Promoter))]
        public Nullable<int> Acq_Deal_Rights_Promoter_Code { get; set; }
        [ForeignKeyReference(typeof(Promoter_Remarks))]
        public Nullable<int> Promoter_Remarks_Code { get; set; }

       // public virtual Acq_Deal_Rights_Promoter Acq_Deal_Rights_Promoter { get; set; }
        //public virtual Promoter_Remarks Promoter_Remarks { get; set; }
    }
}