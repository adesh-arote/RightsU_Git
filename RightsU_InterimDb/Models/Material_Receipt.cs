//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_InterimDb.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Material_Receipt
    {
        public Material_Receipt()
        {
            this.Material_Receipt_Order = new HashSet<Material_Receipt_Order>();
        }
    
    	public State EntityState { get; set; }    public int Material_Receipt_Code { get; set; }
    	    public string Material_Receipt_No { get; set; }
    	    public Nullable<System.DateTime> Received_On { get; set; }
    	    public Nullable<System.DateTime> Inserted_On { get; set; }
    	    public Nullable<int> Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Lock_Time { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    	    public string Remarks { get; set; }
    
        public virtual ICollection<Material_Receipt_Order> Material_Receipt_Order { get; set; }
    }
}
