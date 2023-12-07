//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_Entities
{
    using Newtonsoft.Json;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class Material_Type
    {
        public Material_Type()
        {
            this.Acq_Deal_Material = new HashSet<Acq_Deal_Material>();
            this.Syn_Deal_Material = new HashSet<Syn_Deal_Material>();
        }

        [JsonIgnore]
        public State EntityState { get; set; }
        public int Material_Type_Code { get; set; }
        public string Material_Type_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [NotMapped]
        public string Inserted_By_User { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
        [NotMapped]
        public string Last_Action_By_User { get; set; }
        public string Is_Active { get; set; }

        [JsonIgnore]
        public virtual ICollection<Acq_Deal_Material> Acq_Deal_Material { get; set; }
        [JsonIgnore]
        public virtual ICollection<Syn_Deal_Material> Syn_Deal_Material { get; set; }
    }
}
