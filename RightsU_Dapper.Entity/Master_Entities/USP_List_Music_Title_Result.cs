﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;

    [Table("")]
    public partial class USP_List_Music_Title_Result
    {
        [PrimaryKey]
        public string Music_Title_Code { get; set; }
        public string Music_Title_Name { get; set; }
        public string Duration_In_Min { get; set; }
        public string Movie_Album { get; set; }
        public string Release_Year { get; set; }
        public string Language_Code { get; set; }
        public string Language_Name { get; set; }
        public string Music_Type_Code { get; set; }
        public string Image_Path { get; set; }
        public string Is_Active { get; set; }
        public string RowNumber { get; set; }
        public string Music_Type_Name { get; set; }
        public string Singer { get; set; }
        public string Lyricist { get; set; }
        public string Music_Tag { get; set; }
        public string Music_Composer { get; set; }
        public string Music_Label { get; set; }
        public Nullable<int> Id { get; set; }
        public string Music_Album_Name { get; set; }
        public string Masters_Value { get; set; }
        public string Sort { get; set; }
        public System.DateTime Last_Updated_Time { get; set; }
        public string Public_Domain { get; set; }
        public string Genres_Code { get; set; }
        public string StarCast { get; set; }
        public string Genres_Name { get; set; }
        public string Music_Version { get; set; }
        public string Music_Theme { get; set; }
    }
}
