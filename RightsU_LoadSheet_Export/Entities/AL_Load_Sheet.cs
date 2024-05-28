using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_LoadSheet_Export.Entities
{
    [Table("AL_Load_Sheet")]
    public partial class AL_Load_Sheet
    {
        [PrimaryKey]
        public int? AL_Load_Sheet_Code { get; set; }
        public string Load_Sheet_No { get; set; }
        public Nullable<System.DateTime> Load_Sheet_Month { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }
        public string Download_File_Name { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Updated_By { get; set; }
        public Nullable<System.DateTime> Updated_On { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }

        [OneToMany]
        public virtual ICollection<AL_Load_Sheet_Details> AL_Load_Sheet_Details { get; set; }
    }
}
