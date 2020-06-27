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
    
    public partial class Document_Type
    {
        public Document_Type()
        {
            this.Acq_Deal_Attachment = new HashSet<Acq_Deal_Attachment>();
            this.Syn_Deal_Attachment = new HashSet<Syn_Deal_Attachment>();
        }

        public State EntityState { get; set; }    
        public int Document_Type_Code { get; set; }
        public string Document_Type_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
    
        public virtual ICollection<Acq_Deal_Attachment> Acq_Deal_Attachment { get; set; }
        public virtual ICollection<Syn_Deal_Attachment> Syn_Deal_Attachment { get; set; }
    }
}
