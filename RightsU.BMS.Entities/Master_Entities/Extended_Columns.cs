﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public partial class Extended_Columns
    {
        public Extended_Columns()
        {
            //this.Extended_Columns_Value = new HashSet<Extended_Columns_Value>();
            //this.Map_Extended_Columns = new HashSet<Map_Extended_Columns>();
            //this.AL_Vendor_Rule_Criteria = new HashSet<AL_Vendor_Rule_Criteria>();
            this.Extended_Group_Config = new HashSet<Extended_Group_Config>();
            //this.AL_Booking_Sheet_Details = new HashSet<AL_Booking_Sheet_Details>();
        }
                
        public int Columns_Code { get; set; }
        public string Columns_Name { get; set; }
        public string Control_Type { get; set; }
        public string Is_Ref { get; set; }
        public string Is_Defined_Values { get; set; }
        public string Is_Multiple_Select { get; set; }
        public string Ref_Table { get; set; }
        public string Ref_Display_Field { get; set; }
        public string Ref_Value_Field { get; set; }
        public string Additional_Condition { get; set; }
        public string Is_Add_OnScreen { get; set; }

        //public virtual ICollection<Extended_Columns_Value> Extended_Columns_Value { get; set; }
        //public virtual ICollection<Map_Extended_Columns> Map_Extended_Columns { get; set; }
        //public virtual ICollection<AL_Vendor_Rule_Criteria> AL_Vendor_Rule_Criteria { get; set; }
        public virtual ICollection<Extended_Group_Config> Extended_Group_Config { get; set; }
        //public virtual ICollection<AL_Booking_Sheet_Details> AL_Booking_Sheet_Details { get; set; }
    }
}