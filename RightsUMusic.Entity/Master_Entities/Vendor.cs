﻿using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("Vendor")]
    public partial class Vendor
    {
        [PrimaryKey]
        public int Vendor_Code { get; set; }
        public string Vendor_Name { get; set; }
        public string Address { get; set; }
        public string Phone_No { get; set; }
        public string Fax_No { get; set; }
        public string ST_No { get; set; }
        public string VAT_No { get; set; }
        public string TIN_No { get; set; }
        public string PAN_No { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public string Reference_Id_1 { get; set; }
        public string Reference_Id_2 { get; set; }
        public string Reference_Id_3 { get; set; }
        public string CST_No { get; set; }
        public string SAP_Vendor_Code { get; set; }
        public string Is_External { get; set; }
        public string CIN_No { get; set; }
        public Nullable<int> Ref_Vendor_Key { get; set; }
        public string Province { get; set; }
        public string PostalCode { get; set; }
        public string ExternalId { get; set; }
        public string Record_Status { get; set; }
        public string Error_Description { get; set; }
        public Nullable<System.DateTime> Request_Time { get; set; }
        public Nullable<System.DateTime> Response_Time { get; set; }
        public string GST_No { get; set; }
        public string MDM_Code { get; set; }
        public Nullable<int> MQ_Ref_Code { get; set; }
        public string Is_BV_Push { get; set; }

        public string Short_Code { get; set; }
    }
}
