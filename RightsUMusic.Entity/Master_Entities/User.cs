using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper.SimpleSave;

namespace RightsUMusic.Entity
{
    [Table("Users")]
    public partial class User
    {
        public User()
        {
            this.Users_Password_Detail = new HashSet<Users_Password_Detail>();
        }
        [PrimaryKey]
        public int? Users_Code { get; set; }
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

        public string IsProductionHouseUser { get; set; }
        public int Password_Fail_Count { get; set; }
        //public int moduleCode { get; set; }
        public Nullable<int> Default_Channel_Code { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<int> Default_Entity_Code { get; set; }
        public string User_Image { get; set; }
        // public bool Validate_Email { get; set; }
        public Nullable<int> System_Language_Code { get; set; }

        //public string Full_Name
        //{
        //    get
        //    {
        //        return First_Name + " " + Middle_Name + " " + Last_Name;
        //    }
        //    set
        //    {

        //    }
        //}
        //public string Business_Unit_Names { get; set; }

        //public virtual Security_Group Security_Group { get; set; }
        [OneToMany]
        public virtual ICollection<Users_Password_Detail> Users_Password_Detail { get; set; }

        //public virtual System_Language System_Language { get; set; }
        //public string DefaultEntityName { get; set; }
        //public string DefaultEntityLogoName { get; set; }

    }
}

