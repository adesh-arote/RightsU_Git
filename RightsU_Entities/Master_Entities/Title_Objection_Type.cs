﻿//------------------------------------------------------------------------------
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

    public partial class Title_Objection_Type
    {
        public Title_Objection_Type()
        {
            this.Title_Objection = new HashSet<Title_Objection>();
        }
        [JsonIgnore]
        public State EntityState { get; set; }
        public int Objection_Type_Code { get; set; }
        public string Objection_Type_Name { get; set; }
        public string Is_Active { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<int> Parent_Objection_Type_Code { get; set; }
        public virtual ICollection<Title_Objection> Title_Objection { get; set; }
    }
}
