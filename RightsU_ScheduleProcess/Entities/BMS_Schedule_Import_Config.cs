using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_ScheduleProcess.Entities
{
    [Table("BMS_Schedule_Import_Config")]
    public class BMS_Schedule_Import_Config
    {
        [PrimaryKey]
        public int BMS_Import_Config_Code { get; set; }
        public string BMS_Import_Column_Code { get; set; }
        public string Input_Column_Name { get; set; }
        public string File_Format { get; set; }
        public Nullable<int> Column_Type { get; set; }
        public string Validations { get; set; }
        public Nullable<int> Column_Order { get; set; }
    }
}
