//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_Dapper_InterimDb
{
    using System;
    using System.Collections.Generic;
    
    public partial class Music_Deal_LinkShow
    {
        public int Music_Deal_LinkShow_Code { get; set; }
        public Nullable<int> Music_Deal_Code { get; set; }
        public Nullable<int> Title_Code { get; set; }
    
        public virtual Music_Deal Music_Deal { get; set; }
    }
}
