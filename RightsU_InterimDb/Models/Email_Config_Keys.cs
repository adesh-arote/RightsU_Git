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
    
    public partial class Email_Config_Keys
    {
    	public State EntityState { get; set; }    public int Email_Config_Keys_Code { get; set; }
    	    public Nullable<int> Email_Config_Code { get; set; }
    	    public Nullable<int> Event_Template_Keys_Code { get; set; }
    
        public virtual Email_Config Email_Config { get; set; }
        public virtual Event_Template_Keys Event_Template_Keys { get; set; }
    }
}