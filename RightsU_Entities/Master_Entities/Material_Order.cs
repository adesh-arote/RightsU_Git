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
    
    public partial class Material_Order
    {
        public Material_Order()
        {
            this.Material_Order_Details = new HashSet<Material_Order_Details>();
        }
    
        public int Material_Order_Code { get; set; }
        public string Material_Order_No { get; set; }
        public Nullable<System.DateTime> Material_Order_Date { get; set; }
        public Nullable<int> Vendor_Code { get; set; }
        public System.DateTime Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public string Remarks { get; set; }
    
        public virtual ICollection<Material_Order_Details> Material_Order_Details { get; set; }
        public virtual Vendor Vendor { get; set; }
    }
}
