using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Workflow_Module")]
    public partial class Workflow_Module
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }
        
        [PrimaryKey]
        [JsonProperty(PropertyName = "workflow_module_id")]
        public int ? Workflow_Module_Code { get; set; }

        [ForeignKeyReference(typeof(Workflow))]
        [JsonProperty(PropertyName = "workflow_id")]
        public Nullable<int> Workflow_Code { get; set; }

       
        public Nullable<int> Module_Code { get; set; }

        [ForeignKeyReference(typeof(Business_Unit))]
        [JsonProperty(PropertyName = "business_unit_id")]
        public Nullable<int> Business_Unit_Code { get; set; }

        [JsonIgnore]
        public Nullable<short> Ideal_Process_Days { get; set; }

        [JsonProperty(PropertyName = "effective_start_date")]
        public Nullable<System.DateTime> Effective_Start_Date { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> System_End_Date { get; set; }

        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }

        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }

        [ForeignKeyReference(typeof(Workflow))]
        [ManyToOne]
        [SimpleSaveIgnore]
        [Column("Workflow_Code")]
        public virtual Workflow workflow_name { get; set; }

        [ForeignKeyReference(typeof(Business_Unit))]
        [ManyToOne]
        [SimpleSaveIgnore]
        [Column("Business_Unit_Code")]
        public virtual Business_Unit business_unit { get; set; }

        [ForeignKeyReference(typeof(System_Module))]
        [ManyToOne]
        [SimpleSaveIgnore]
        [Column("Module_Code")]
        public virtual System_Module module_name { get; set; }
    }
}
