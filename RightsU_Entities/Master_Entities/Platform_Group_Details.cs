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

    public partial class Platform_Group_Details
    {
        [JsonIgnore]
        public State EntityState { get; set; }
        public int Platform_Group_Details_Code { get; set; }
        public Nullable<int> Platform_Code { get; set; }
        public Nullable<int> Platform_Group_Code { get; set; }
        [JsonIgnore]
        public virtual Platform Platform { get; set; }
        [JsonIgnore]
        public virtual Platform_Group Platform_Group { get; set; }
    }
}
