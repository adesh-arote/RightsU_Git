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
    
    public partial class System_Parameter_New
    {
        [JsonIgnore]
        public State EntityState { get; set; }
        public int Id { get; set; }
        public string Parameter_Name { get; set; }
        public string Parameter_Value { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<int> Channel_Code { get; set; }
        public string Type { get; set; }
        public string IsActive { get; set; }
        public string Description { get; set; }
        public string IS_System_Admin { get; set; }
        public string Client_Name { get; set; }
    }
}
