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
    
    public partial class USP_List_Acq_PaymentTerms_Result
    {
        public int Acq_Deal_Payment_Terms_Code { get; set; }
        public Nullable<int> Acq_Deal_Code { get; set; }
        public Nullable<int> Title_Code { get; set; }
        public string Title_Name { get; set; }
        public Nullable<int> Episode_From { get; set; }
        public Nullable<int> Episode_To { get; set; }
        public Nullable<int> Cost_Type_Code { get; set; }
        public Nullable<int> Payment_Term_Code { get; set; }
        public Nullable<int> Days_After { get; set; }
        public Nullable<decimal> Percentage { get; set; }
        public Nullable<decimal> Amount { get; set; }
        public Nullable<System.DateTime> Due_Date { get; set; }
        public string Payment_Terms { get; set; }
        public string Cost_Type_Name { get; set; }
    }
}
