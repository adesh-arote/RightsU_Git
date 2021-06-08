
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Email_Config_Detail_User")]
    public partial class Email_Config_Detail_User
    {
        public Email_Config_Detail_User()
        {
            Business_Unit_Names = "";
            User_Names = "";
            Security_Group_Names = "";
            Channel_Names = "";
        }
        [PrimaryKey]
        public int? Email_Config_Detail_User_Code { get; set; }
        [ForeignKeyReference(typeof(Email_Config_Detail))]
        public Nullable<int> Email_Config_Detail_Code { get; set; }
        public string User_Type { get; set; }
        public Nullable<int> Security_Group_Code { get; set; }
        public string Business_Unit_Codes { get; set; }
        public string User_Codes { get; set; }
        public string Channel_Codes { get; set; }
        public string CC_Users { get; set; }
        public string BCC_Users { get; set; }
        public string ToUser_MailID { get; set; }
        public string CCUser_MailID { get; set; }
        public string BCCUser_MailID { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public string Business_Unit_Names { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public string User_Names { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public string CC_User_Names { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public string BCC_User_Names { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public string Security_Group_Names { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public string Channel_Names { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public int temp_Id { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Email_Config_Detail Email_Config_Detail { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public string _Dummy_Guid { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public string Dummy_Guid
        {
            get
            {
                if (string.IsNullOrEmpty(_Dummy_Guid))
                    _Dummy_Guid = GetDummy_Guid();
                return _Dummy_Guid;
            }
        }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        private string GetDummy_Guid()
        {
            return Guid.NewGuid().ToString();
        }

    }
}



