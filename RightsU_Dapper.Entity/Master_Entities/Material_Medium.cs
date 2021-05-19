
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Material_Medium")]
    public partial class Material_Medium
    {
        public Material_Medium()
        {
            this.Material_Order_Details = new HashSet<Material_Order_Details>();
            this.Acq_Deal_Material = new HashSet<Acq_Deal_Material>();
            this.Syn_Deal_Material = new HashSet<Syn_Deal_Material>();
        }
        [PrimaryKey]
        public int? Material_Medium_Code { get; set; }
        public string Material_Medium_Name { get; set; }
        public string Type { get; set; }
        public Nullable<int> Duration { get; set; }
        public string Is_Qc_Required { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        [OneToMany]
        public virtual ICollection<Material_Order_Details> Material_Order_Details { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Material> Acq_Deal_Material { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Material> Syn_Deal_Material { get; set; }
    }
}


