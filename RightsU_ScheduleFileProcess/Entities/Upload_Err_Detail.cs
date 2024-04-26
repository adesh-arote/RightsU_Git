using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_ScheduleFileProcess.Entities
{
    [Table("Upload_Err_Detail")]
    public partial class Upload_Err_Detail
    {
        [PrimaryKey]
        public long? Upload_Detail_Code { get; set; }
        public long File_Code { get; set; }
        public Nullable<int> Row_Num { get; set; }
        public string Row_Delimed { get; set; }
        public string Err_Cols { get; set; }
        public string Upload_Type { get; set; }
        public string Upload_Title_Type { get; set; }
    }
}
