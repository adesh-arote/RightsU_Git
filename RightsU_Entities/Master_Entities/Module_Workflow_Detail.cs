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
    
    public partial class Module_Workflow_Detail
    {
        public int Module_Workflow_Detail_Code { get; set; }
        public Nullable<int> Module_Code { get; set; }
        public Nullable<int> Record_Code { get; set; }
        public Nullable<int> Group_Code { get; set; }
        public Nullable<int> Primary_User_Code { get; set; }
        public Nullable<short> Role_Level { get; set; }
        public string Is_Done { get; set; }
        public Nullable<int> Next_Level_Group { get; set; }
        public Nullable<System.DateTime> Entry_Date { get; set; }
    
        public virtual Security_Group Security_Group { get; set; }
        public virtual Security_Group Security_Group1 { get; set; }
        public virtual System_Module System_Module { get; set; }
        public virtual User User { get; set; }
    }
}
