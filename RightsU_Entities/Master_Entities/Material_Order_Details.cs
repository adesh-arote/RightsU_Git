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
    
    public partial class Material_Order_Details
    {
        public Material_Order_Details()
        {
            this.Material_Receipt_Order = new HashSet<Material_Receipt_Order>();
        }
    
        public int Material_Order_Detail_Code { get; set; }
        public Nullable<int> Material_Order_Code { get; set; }
        public Nullable<int> Acq_Deal_Code { get; set; }
        public Nullable<int> Acq_Deal_Movie_Code { get; set; }
        public Nullable<int> Material_Medium_Code { get; set; }
        public Nullable<int> Order_Quantity { get; set; }
        public Nullable<int> Currency_Code { get; set; }
        public Nullable<decimal> Rate { get; set; }
        public Nullable<decimal> Amount { get; set; }
        public int Received_Quantity { get; set; }
    
        public virtual Acq_Deal Acq_Deal { get; set; }
        public virtual Acq_Deal_Movie Acq_Deal_Movie { get; set; }
        public virtual Currency Currency { get; set; }
        public virtual Material_Medium Material_Medium { get; set; }
        public virtual Material_Order Material_Order { get; set; }
        public virtual ICollection<Material_Receipt_Order> Material_Receipt_Order { get; set; }
    }
}
