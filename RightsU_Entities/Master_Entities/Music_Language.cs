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

    public partial class Music_Language
    {
        public Music_Language()
        {
            this.Music_Title_Language = new HashSet<Music_Title_Language>();
            this.Music_Deal_Language = new HashSet<Music_Deal_Language>();
        }

        public State EntityState { get; set; }    public int Music_Language_Code { get; set; }
        public string Language_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public Nullable<int> Original_Language_Code { get; set; }

        public virtual ICollection<Music_Title_Language> Music_Title_Language { get; set; }
        public virtual ICollection<Music_Deal_Language> Music_Deal_Language { get; set; }
    }
}
