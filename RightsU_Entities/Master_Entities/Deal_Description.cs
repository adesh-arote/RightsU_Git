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

    public partial class Deal_Description
    {
        [JsonIgnore]
        public State EntityState { get; set; }
        [JsonProperty(Order = -1)]
        public int Deal_Desc_Code { get; set; }
        [JsonProperty(Order = 1)]
        public string Deal_Desc_Name { get; set; }
        [JsonProperty(Order = 2)]
        public string Type { get; set; }
        [JsonProperty(Order = 3)]
        public string Is_Active { get; set; }
        [JsonProperty(Order = 4)]
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [NotMapped]
        [JsonProperty(Order = 5)]
        public string Inserted_By_User { get; set; }
        [JsonProperty(Order = 6)]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
        [NotMapped]
        [JsonProperty(Order = 7)]
        public string Last_Action_By_User { get; set; }
    }
}
