
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("User")]
    public partial class User
    {
        public User()
        {
            //this.BVException_Users = new HashSet<BVException_Users>();
            //this.Module_Workflow_Detail = new HashSet<Module_Workflow_Detail>();
            //this.Users_Channel = new HashSet<Users_Channel>();
            //this.Users_Entity = new HashSet<Users_Entity>();
            //this.Users_Password_Detail = new HashSet<Users_Password_Detail>();
            this.Users_Business_Unit = new HashSet<Users_Business_Unit>();
            //this.Glossary_AskExpert = new HashSet<Glossary_AskExpert>();
            //this.MHUsers = new HashSet<MHUser>();
            //this.Users_Configuration = new HashSet<Users_Configuration>();
            //this.Users_Exclusion_Rights = new HashSet<Users_Exclusion_Rights>();
            //this.Users_Detail = new HashSet<Users_Detail>();
        }
        public int Users_Code { get; set; }
        public string Login_Name { get; set; }
        public string First_Name { get; set; }
        public string Middle_Name { get; set; }
        public string Last_Name { get; set; }
        public string Password { get; set; }
        public string Email_Id { get; set; }
        public string Contact_No { get; set; }
        public Nullable<int> Security_Group_Code { get; set; }
        public string Is_Active { get; set; }
        public string Is_System_Password { get; set; }
        public int Password_Fail_Count { get; set; }
        public int moduleCode { get; set; }
        public Nullable<int> Default_Channel_Code { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<int> Default_Entity_Code { get; set; }
        public string User_Image { get; set; }
        public bool Validate_Email { get; set; }
        public Nullable<int> System_Language_Code { get; set; }
        public string Full_Name
        {
            get
            {
                return First_Name + " " + Middle_Name + " " + Last_Name;
            }
            set
            {

            }
        }
        public string Business_Unit_Names { get; set; }
        public string IsLDAPUser { get; set; }
        public string IsProductionHouseUser { get; set; }
        public Nullable<System.DateTime> Created_On { get; set; }
        public Nullable<int> Created_By { get; set; }


        //public virtual ICollection<BVException_Users> BVException_Users { get; set; }
        //public virtual ICollection<Module_Workflow_Detail> Module_Workflow_Detail { get; set; }
        //public virtual Security_Group Security_Group { get; set; }
        //public virtual ICollection<Users_Channel> Users_Channel { get; set; }
        //public virtual ICollection<Users_Entity> Users_Entity { get; set; }
        //public virtual ICollection<Users_Password_Detail> Users_Password_Detail { get; set; }
        public virtual ICollection<Users_Business_Unit> Users_Business_Unit { get; set; }
        //public virtual ICollection<Glossary_AskExpert> Glossary_AskExpert { get; set; }
        //public virtual System_Language System_Language { get; set; }
        //public string DefaultEntityName { get; set; }
        //public string DefaultEntityLogoName { get; set; }
        //public virtual ICollection<MHUser> MHUsers { get; set; }
        //public virtual ICollection<Users_Configuration> Users_Configuration { get; set; }
        //public virtual ICollection<Users_Exclusion_Rights> Users_Exclusion_Rights { get; set; }
        //public virtual ICollection<Users_Detail> Users_Detail { get; set; }

    }
}


