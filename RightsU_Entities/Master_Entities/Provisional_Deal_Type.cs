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

    public partial class Provisional_Deal_Type
    {
        public Provisional_Deal_Type()
        {
            this.Provisional_Deal = new HashSet<Provisional_Deal>();
        }

        public State EntityState { get; set; }
        public int Provisional_Deal_Type_Code { get; set; }
        public string Provisional_Deal_Type_Name { get; set; }
        public string Is_Active { get; set; }

        public virtual ICollection<Provisional_Deal> Provisional_Deal { get; set; }
    }
}
