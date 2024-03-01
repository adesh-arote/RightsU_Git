using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_ReadWriteFileProcess.Entities
{
    public class Schedule_Data_UDT
    {
        public string Program_Episode_ID { get; set; }
        public string Program_Episode_Title { get; set; }
        public string Program_Episode_Number { get; set; }
        public string Program_Category { get; set; }
        public string Program_Version_ID { get; set; }
        public string Schedule_Item_Log_Date { get; set; }
        public string Schedule_Item_Log_Time { get; set; }
        public string Schedule_Item_Duration { get; set; }
        public string Scheduled_Version_House_Number_List { get; set; }
        public string Program_Title { get; set; }
        public string File_Code { get; set; }
        public string Channel_Code { get; set; }
        public string Inserted_By { get; set; }
        public string Inserted_On { get; set; }
        public string IsDealApproved { get; set; }
        public string TitleCode { get; set; }
        public string DMCode { get; set; }
        public string Deal_Code { get; set; }
        public string Deal_Type { get; set; }
    }
}
