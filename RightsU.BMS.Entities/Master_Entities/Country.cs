﻿using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Country")]
    public partial class Country
    {   
        [PrimaryKey]
        [Column("Country_Code")]
        public int? country_id { get; set; }

        [Column("Country_Name")]
        public string country_name { get; set; }

        [JsonIgnore]
        public string Is_Domestic_Territory { get; set; }
        [JsonIgnore]
        public string Is_Theatrical_Territory { get; set; }
        [JsonIgnore]
        public string Is_Ref_Acq { get; set; }
        [JsonIgnore]
        public string Is_Ref_Syn { get; set; }
        [JsonIgnore]
        public Nullable<int> Parent_Country_Code { get; set; }
        [JsonIgnore]
        public string Applicable_For_Asrun_Schedule { get; set; }
        [JsonIgnore]
        public System.DateTime Inserted_On { get; set; }
        [JsonIgnore]
        public int Inserted_By { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
        [JsonIgnore]
        public string Is_Active { get; set; }
    }
}