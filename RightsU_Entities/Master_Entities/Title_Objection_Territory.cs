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
    using System;
    using System.Collections.Generic;

    public partial class Title_Objection_Territory
    {
        public State EntityState { get; set; }
        public int Title_Objection_Territory_Code { get; set; }
        public Nullable<int> Title_Objection_Code { get; set; }
        public string Territory_Type { get; set; }
        public Nullable<int> Country_Code { get; set; }
        public Nullable<int> Territory_Code { get; set; }

        public virtual Title_Objection Title_Objection { get; set; }
    }
}
