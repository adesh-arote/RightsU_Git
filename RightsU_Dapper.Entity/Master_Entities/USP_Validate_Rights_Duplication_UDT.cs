using System;
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
    [Table("USP_Insert_Music_Title_Import_UDT")]
    public class USP_Insert_Music_Title_Import_UDT
    {
        //[StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Music_Title_Import")]
        //public List<Music_Title_Import_UDT> Music_Title_Import { get; set; }

        //[StoredProcedureParameter(SqlDbType.Int, ParameterName = "User_Code")]
        public int User_Code { get; set; }
        public int Line_Number { get; set; }
        public string Music_Title_Name { get; set; }
        public string Movie_Album { get; set; }
        //public string Title_Type { get; set; }
        public string Title_Language { get; set; }
        public string Year_of_Release { get; set; }
        //public string Duration { get; set; }
        //public string Singers { get; set; }
        //public string Lyricist { get; set; }
        //public string Music_Director { get; set; }
        public string Music_Label { get; set; }
        public string Movie_Star_Cast { get; set; }

        public string Music_Album_Type { get; set; }
        public string Error_Messages { get; set; }
        //public string Genres { get; set; }
        //public string Star_Cast { get; set; }
        //public string Music_Version { get; set; }
    }
    public class Music_Title_Import_UDT
    {
        public string Music_Title_Name { get; set; }
        public string Duration { get; set; }
        public string Movie_Album { get; set; }
        public string Singers { get; set; }
        public string Lyricist { get; set; }
        public string Music_Director { get; set; }
        public string Title_Language { get; set; }
        public string Music_Label { get; set; }
        public string Year_of_Release { get; set; }
        public string Title_Type { get; set; }
        public string Genres { get; set; }
        public string Star_Cast { get; set; }
        public string Music_Version { get; set; }
        public string Effective_Start_Date { get; set; }
        public string Theme { get; set; }
        public string Music_Tag { get; set; }
        public string Movie_Star_Cast { get; set; }
        public string Music_Album_Type { get; set; }
        public string DM_Master_Import_Code { get; set; }
        public string Excel_Line_No { get; set; }
        public string Public_Domain { get; set; }
    }
}
    
