﻿namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class Digital_Config
    {
        public State EntityState { get; set; }
        public int Digital_Config_Code { get; set; }
        public Nullable<int> Digital_Code { get; set; }
        public Nullable<int> Digital_Tab_Code { get; set; }
        public string Page_Group { get; set; }
        public string Label_Name { get; set; }
        public string Control_Type { get; set; }
        public string Is_Mandatory { get; set; }
        public string Is_Multiselect { get; set; }
        public Nullable<int> Max_Length { get; set; }
        public Nullable<int> Page_Control_Order { get; set; }
        public Nullable<int> Control_Field_Order { get; set; }
        public string Default_Values { get; set; }
        public string View_Name { get; set; }
        public string Text_Field { get; set; }
        public string Value_Field { get; set; }
        public string Whr_Criteria { get; set; }
        public string LP_Digital_Data_Code { get; set; }
        public string LP_Digital_Value_Config_Code { get; set; }

        public virtual Digital Digital { get; set; }
        public virtual Digital_Tab Digital_Tab { get; set; }
    }
}
