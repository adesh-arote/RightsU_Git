
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Acq_Deal_Movie")]
    public partial class Acq_Deal_Movie
    {
        public Acq_Deal_Movie()
        {
            //this.Aireds = new HashSet<Aired>();
            this.Material_Order_Details = new HashSet<Material_Order_Details>();
            //this.Content_Music_Link = new HashSet<Content_Music_Link>();
            //this.Title_Content_Mapping = new HashSet<Title_Content_Mapping>();
        }
        [PrimaryKey]
        public int? Acq_Deal_Movie_Code { get; set; }
        [ForeignKeyReference(typeof(Acq_Deal))]
        public Nullable<int> Acq_Deal_Code { get; set; }
        [ForeignKeyReference(typeof(Title))]
        public Nullable<int> Title_Code { get; set; }
        public Nullable<int> No_Of_Episodes { get; set; }
        public string Notes { get; set; }
        public Nullable<int> No_Of_Files { get; set; }
        public string Is_Closed { get; set; }
        public string Title_Type { get; set; }
        public string Amort_Type { get; set; }
        public Nullable<int> Episode_Starts_From { get; set; }
        public string Closing_Remarks { get; set; }
        public Nullable<System.DateTime> Movie_Closed_Date { get; set; }
        public string Remark { get; set; }
        public string Ref_BMS_Movie_Code { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_UpDated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<int> Episode_End_To { get; set; }
        public Nullable<decimal> Duration_Restriction { get; set; }
        public string Due_Diligence { get; set; }
        public string _Dummy_Guid { get; set; }
        public string Dummy_Guid
        {
            get
            {
                if (string.IsNullOrEmpty(_Dummy_Guid))
                    _Dummy_Guid = GetDummy_Guid();
                return _Dummy_Guid;
            }
        }

        private string GetDummy_Guid()
        {
            return Guid.NewGuid().ToString();
        }

        public int MaxEpisodeFrom { get; set; }
        public int MinEpisodeTo { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Acq_Deal Acq_Deal { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Title Title { get; set; }
        //public virtual ICollection<Aired> Aireds { get; set; }
        [OneToMany]
        public virtual ICollection<Material_Order_Details> Material_Order_Details { get; set; }
        //public virtual ICollection<Content_Music_Link> Content_Music_Link { get; set; }
        //public virtual ICollection<Title_Content_Mapping> Title_Content_Mapping { get; set; }
    }
}


