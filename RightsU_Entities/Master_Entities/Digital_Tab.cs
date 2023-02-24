namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

   
        public partial class Digital_Tab
        {
            public Digital_Tab()
            {
                this.Digital_Config = new HashSet<Digital_Config>();
            }

            public State EntityState { get; set; }
            public int Digital_Tab_Code { get; set; }
            public string Short_Name { get; set; }
            public string Digital_Tab_Description { get; set; }
            public Nullable<int> Order_No { get; set; }
            public string Tab_Type { get; set; }
            public string EditWindowType { get; set; }
            public Nullable<int> Module_Code { get; set; }
            public Nullable<int> Key_Config_Code { get; set; }
            public string Is_Show { get; set; }

            public virtual ICollection<Digital_Config> Digital_Config { get; set; }
        }
    

}
