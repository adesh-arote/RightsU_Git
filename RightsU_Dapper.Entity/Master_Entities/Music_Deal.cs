
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Music_Deal")]
    public partial class Music_Deal
    {
        public Music_Deal()
        {
            //this.Music_Deal_Channel = new HashSet<Music_Deal_Channel>();
            //this.Music_Deal_Country = new HashSet<Music_Deal_Country>();
            //this.Music_Deal_Language = new HashSet<Music_Deal_Language>();
            //this.Music_Deal_LinkShow = new HashSet<Music_Deal_LinkShow>();
            //this.Music_Deal_Vendor = new HashSet<Music_Deal_Vendor>();
            //this.Music_Deal_DealType = new HashSet<Music_Deal_DealType>();
            //this.Music_Deal_Platform = new HashSet<Music_Deal_Platform>();
        }
        [PrimaryKey]
        public int? Music_Deal_Code { get; set; }
        public string Agreement_No { get; set; }
        public string Version { get; set; }
        public Nullable<System.DateTime> Agreement_Date { get; set; }
        public string Description { get; set; }
        public string Reference_No { get; set; }
        public Nullable<int> Entity_Code { get; set; }
        public Nullable<int> Primary_Vendor_Code { get; set; }
        public Nullable<int> Music_Label_Code { get; set; }
        public string Title_Type { get; set; }
        public Nullable<decimal> Duration_Restriction { get; set; }
        public Nullable<System.DateTime> Rights_Start_Date { get; set; }
        public Nullable<System.DateTime> Rights_End_Date { get; set; }
        public string Term { get; set; }
        public string Run_Type { get; set; }
        public Nullable<int> No_Of_Songs { get; set; }
        public string Channel_Type { get; set; }
        public Nullable<int> Right_Rule_Code { get; set; }
        public string Link_Show_Type { get; set; }
        public Nullable<int> Business_Unit_Code { get; set; }
        public Nullable<int> Deal_Type_Code { get; set; }
        public string Deal_Workflow_Status { get; set; }
        public Nullable<int> Work_Flow_Code { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<int> Deal_Tag_Code { get; set; }
        public Nullable<int> Parent_Deal_Code { get; set; }
        public string Remarks { get; set; }
        public Nullable<decimal> Agreement_Cost { get; set; }
        public string Channel_Or_Category { get; set; }
        public Nullable<int> Channel_Category_Code { get; set; }

        public System.TimeSpan Duration { get; set; }
        public string Right_Rule_Type { get; set; }
        //public virtual Business_Unit Business_Unit { get; set; }
        //public virtual Deal_Type Deal_Type { get; set; }
        //public virtual Entity Entity { get; set; }
        //public virtual ICollection<Music_Deal_Channel> Music_Deal_Channel { get; set; }
        //public virtual ICollection<Music_Deal_Country> Music_Deal_Country { get; set; }
        //public virtual ICollection<Music_Deal_Language> Music_Deal_Language { get; set; }
        //public virtual ICollection<Music_Deal_LinkShow> Music_Deal_LinkShow { get; set; }
        //public virtual Music_Label Music_Label { get; set; }
        public virtual Right_Rule Right_Rule { get; set; }
        //public virtual Vendor Vendor { get; set; }
        //public virtual ICollection<Music_Deal_Vendor> Music_Deal_Vendor { get; set; }
        //public virtual Deal_Tag Deal_Tag { get; set; }
        //public virtual Channel_Category Channel_Category { get; set; }
        //public virtual ICollection<Music_Deal_DealType> Music_Deal_DealType { get; set; }
        //public virtual ICollection<Music_Deal_Platform> Music_Deal_Platform { get; set; }
    }
}


