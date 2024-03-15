using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("Users")]
    public partial class User
    {
        public User()
        {
            this.Users_Password_Detail = new HashSet<Users_Password_Detail>();
            //  this.UsersBusinessUnit = new HashSet<UsersBusinessUnit>();
        }
        [PrimaryKey]
        public int? Users_Code { get; set; }
        public string Login_Name { get; set; }
        public string First_Name { get; set; }
        public string Last_Name { get; set; }
        public string Password { get; set; }
        public string Email_Id { get; set; }
        public Nullable<int> Security_Group_Code { get; set; }
        public string Is_Active { get; set; }
        public string Is_System_Password { get; set; }
        public string IsProductionHouseUser { get; set; }
        public int Password_Fail_Count { get; set; }
        //public int moduleCode { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string User_Image { get; set; }
        // public bool Validate_Email { get; set; }
        public string ChangePasswordLinkGUID { get; set; }
        public Nullable<int> Default_Entity_Code { get; set; }

        [OneToMany]
        public virtual ICollection<Users_Password_Detail> Users_Password_Detail { get; set; }

        //[OneToMany]
        //public virtual ICollection<UsersBusinessUnit> UsersBusinessUnit { get; set; }
        //public virtual System_Language System_Language { get; set; }
        //public string DefaultEntityName { get; set; }
        //public string DefaultEntityLogoName { get; set; }

    }
}
