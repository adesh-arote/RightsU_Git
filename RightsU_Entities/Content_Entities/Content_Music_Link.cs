namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class Content_Music_Link
    {
        public State EntityState { get; set; }
        public int Content_Music_Link_Code { get; set; }
        public Nullable<int> Acq_Deal_Movie_Code { get; set; }
        public Nullable<int> Music_Title_Code { get; set; }
        public Nullable<System.TimeSpan> From { get; set; }
        public Nullable<int> From_Frame { get; set; }
        public Nullable<System.TimeSpan> To { get; set; }
        public Nullable<int> To_Frame { get; set; }
        public System.TimeSpan Duration { get; set; }
        public Nullable<int> Duration_Frame { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_UpDated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<int> Title_Content_Code { get; set; }
        public Nullable<int> Title_Content_Version_Code { get; set; }

        public virtual Acq_Deal_Movie Acq_Deal_Movie { get; set; }
        public virtual Music_Title Music_Title { get; set; }
        public virtual Title_Content_Version Title_Content_Version { get; set; }
        public virtual Title_Content Title_Content { get; set; }
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
        public Nullable<int> Version_Code { get; set; }
    }
}

