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
    [Table("Category")]
    public partial class Category
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "category_id")]
        public int? Category_Code { get; set; }

        [JsonProperty(PropertyName = "category_name")]
        public string Category_Name { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_on")]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_by")]
        public Nullable<int> Inserted_By { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_on")]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_by")]
        public Nullable<int> Last_Action_By { get; set; }

        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "is_system_generated")]
        public string Is_System_Generated { get; set; }
    }
}