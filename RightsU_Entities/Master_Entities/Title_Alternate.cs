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

    public partial class Title_Alternate
    {
        public Title_Alternate()
        {
            this.Title_Alternate_Content = new HashSet<Title_Alternate_Content>();
            this.Title_Alternate_Country = new HashSet<Title_Alternate_Country>();
            this.Title_Alternate_Genres = new HashSet<Title_Alternate_Genres>();
            this.Title_Alternate_Talent = new HashSet<Title_Alternate_Talent>();
        }

        public State EntityState { get; set; }
        public int Title_Alternate_Code { get; set; }
        public Nullable<int> Alternate_Config_Code { get; set; }
        public Nullable<int> Title_Code { get; set; }
        public Nullable<int> Year_Of_Production { get; set; }
        public Nullable<int> Deal_Type_Code { get; set; }
        public string Title_Name { get; set; }
        public string Original_Title { get; set; }
        public Nullable<int> Title_Language_Code { get; set; }
        public Nullable<int> Original_Language_Code { get; set; }
        public string Synopsis { get; set; }
        public string Title_Image { get; set; }
        public string Is_Active { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_UpDated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }

        public virtual Alternate_Config Alternate_Config { get; set; }
        public virtual Deal_Type Deal_Type { get; set; }
        public virtual Language Language { get; set; }
        public virtual Language Language1 { get; set; }
        public virtual Title Title { get; set; }
        public virtual ICollection<Title_Alternate_Content> Title_Alternate_Content { get; set; }
        public virtual ICollection<Title_Alternate_Country> Title_Alternate_Country { get; set; }
        public virtual ICollection<Title_Alternate_Genres> Title_Alternate_Genres { get; set; }
        public virtual ICollection<Title_Alternate_Talent> Title_Alternate_Talent { get; set; }
    }
}
