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
    using System;
    using System.Collections.Generic;
    
    public partial class Royalty_Commission_Details
    {
        public int Royalty_Commission_Details_Code { get; set; }
        public Nullable<int> Royalty_Commission_Code { get; set; }
        public string Commission_Type { get; set; }
        public Nullable<int> Commission_Type_Code { get; set; }
        public string Add_Subtract { get; set; }
        public Nullable<int> Position { get; set; }
    
        public virtual Royalty_Commission Royalty_Commission { get; set; }
    }
}
