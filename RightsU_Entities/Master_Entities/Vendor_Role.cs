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

    public partial class Vendor_Role
    {
        [JsonIgnore]
        public State EntityState { get; set; }
        [JsonProperty(Order = -1)]
        public int Vendor_Role_Code { get; set; }
        [JsonProperty(Order = 1)]
        public int Vendor_Code { get; set; }
        [JsonIgnore]
        public int Role_Code { get; set; }
        [NotMapped]
        [JsonProperty(Order = 2)]
        public string Role_Name { get; set; }
        [JsonProperty(Order = 3)]
        public string Is_Active { get; set; }
        [JsonIgnore]
        public virtual Vendor Vendor { get; set; }
        [JsonIgnore]
        public virtual Role Role { get; set; }
    }
}
