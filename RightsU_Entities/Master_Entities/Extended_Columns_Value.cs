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
    
    public partial class Extended_Columns_Value
    {
        public Extended_Columns_Value()
        {
            this.Map_Extended_Columns_Details = new HashSet<Map_Extended_Columns_Details>();
            this.Map_Extended_Columns = new HashSet<Map_Extended_Columns>();
        }

        [JsonIgnore]
        public State EntityState { get; set; }    
        public int Columns_Value_Code { get; set; }
        public Nullable<int> Columns_Code { get; set; }
        public string Columns_Value { get; set; }
        
        [JsonIgnore]
        public virtual Extended_Columns Extended_Columns { get; set; }
        [JsonIgnore]
        public virtual ICollection<Map_Extended_Columns_Details> Map_Extended_Columns_Details { get; set; }
        [JsonIgnore]
        public virtual ICollection<Map_Extended_Columns> Map_Extended_Columns { get; set; }
    }
}
