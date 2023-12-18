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

    public partial class Party_Category
    {
        public Party_Category()
        {
            this.Vendors = new HashSet<Vendor>();
        }
    
        [JsonIgnore]
    	public State EntityState { get; set; }
        [JsonProperty(Order = -1)]
        public int Party_Category_Code { get; set; }
        [JsonProperty(Order = 1)]
        public string Party_Category_Name { get; set; }
        [JsonProperty(Order = 2)]
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [NotMapped]
        [JsonProperty(Order = 3)]
        public string Inserted_By_User { get; set; }
        [JsonProperty(Order = 4)]
        public Nullable<System.DateTime> Last_Updated_On { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Updated_By { get; set; }
        [NotMapped]
        [JsonProperty(Order = 5)]
        public string Last_Updated_By_User { get; set; }
        [JsonProperty(Order = 6)]
        public string Is_Active { get; set; }
        
        [JsonIgnore]
        public virtual ICollection<Vendor> Vendors { get; set; }
    }
}
