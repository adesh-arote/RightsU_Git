﻿using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("Title")]
    public partial class Title
    {
        public Title()
        {
            this.MHRequests = new HashSet<MHRequest>();
            this.MHRequestDetails = new HashSet<MHRequestDetail>();
        }
        [PrimaryKey]
        public int? Title_Code { get; set; }
        public string Original_Title { get; set; }
        public string Title_Name { get; set; }
        public string Title_Code_Id { get; set; }
        public string Synopsis { get; set; }
        public Nullable<int> Original_Language_Code { get; set; }
        public Nullable<int> Title_Language_Code { get; set; }
        public Nullable<int> Year_Of_Production { get; set; }
        public Nullable<decimal> Duration_In_Min { get; set; }
        public Nullable<int> Deal_Type_Code { get; set; }
        public Nullable<int> Grade_Code { get; set; }
        public Nullable<int> Reference_Key { get; set; }
        public string Reference_Flag { get; set; }
        public string Is_Active { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_UpDated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public string Title_Image { get; set; }
        public Nullable<int> Music_Label_Code { get; set; }
        public Nullable<int> Program_Code { get; set; }

        public virtual ICollection<MHRequest> MHRequests { get; set; }
        public virtual ICollection<MHRequestDetail> MHRequestDetails { get; set; }

    }
}
