
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Acq_Deal_Material")]
    public partial class Acq_Deal_Material
    {
        [PrimaryKey]
        public int? Acq_Deal_Material_Code { get; set; }
        [ForeignKeyReference(typeof(Acq_Deal))]
        public Nullable<int> Acq_Deal_Code { get; set; }
        [ForeignKeyReference(typeof(Title))]
        public Nullable<int> Title_Code { get; set; }
        [ForeignKeyReference(typeof(Material_Medium))]
        public Nullable<int> Material_Medium_Code { get; set; }
        public Nullable<int> Material_Type_Code { get; set; }
        public Nullable<int> Quantity { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<int> Episode_From { get; set; }
        public Nullable<int> Episode_To { get; set; }

        public virtual Acq_Deal Acq_Deal { get; set; }
        public virtual Title Title { get; set; }
        public virtual Material_Medium Material_Medium { get; set; }
        //public virtual Material_Type Material_Type { get; set; }
    }
}
