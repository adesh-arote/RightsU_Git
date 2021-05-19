
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Material_Type")]
    public partial class Material_Type
    {
        public Material_Type()
        {
            this.Acq_Deal_Material = new HashSet<Acq_Deal_Material>();
            this.Syn_Deal_Material = new HashSet<Syn_Deal_Material>();
        }
        [PrimaryKey]
        public int? Material_Type_Code { get; set; }
        public string Material_Type_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Material> Acq_Deal_Material { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Material> Syn_Deal_Material { get; set; }
    }
}


