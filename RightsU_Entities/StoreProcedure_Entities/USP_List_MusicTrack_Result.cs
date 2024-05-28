namespace RightsU_Entities
{
    using System;
    
    public partial class USP_List_MusicTrack_Result
    {
        public int Music_Title_Code { get; set; }
        public string Music_Title_Name { get; set; }
        public Nullable<int> Release_Year { get; set; }
        public Nullable<decimal> Duration_In_Min { get; set; }
        public string Movie_Album { get; set; }
        public string Music_Label_Name { get; set; }
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
        public bool isSelected { get; set; }

    }
}
