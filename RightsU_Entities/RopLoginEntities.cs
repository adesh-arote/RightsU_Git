using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public class LoginTokenReturn
    {
        public string access_token { get; set; }
        public string expires_in { get; set; }
        public string token_type { get; set; }
        public string refresh_token { get; set; }
    }

    public class Return
    {
        public string Message { get; set; }
        public bool IsSuccess { get; set; }
        public object Token { get; set; }
        public Nullable<int> SecurityGroupCode { get; set; }
        public object UserName { get; set; }
        public string IsSystemPassword { get; set; }
    }

    public class RopUser
    {
        public int Users_Code { get; set; }
        public string Login_Name { get; set; }
        public string Email_Id { get; set; }
        public int LoginDetailsCode { get; set; }
        public string FullName { get; set; }
        public object UserImage { get; set; }
        public string EncryptedLoginName { get; set; }
    }

    public class UsersDetail
    {
        public int Users_Detail_Code { get; set; }
        public int Users_Code { get; set; }
        public int Attrib_Group_Code { get; set; }
        public string Attrib_Type { get; set; }
        public string Attrib_Group_Name { get; set; }
        public string Icon { get; set; }
    }

    public class BusinessUnit
    {
        public int BU_Code { get; set; }
        public string BU_Name { get; set; }
    }

    public class DashboardType
    {
        public string Name { get; set; }
        public string Value { get; set; }
    }

    public class RootObject
    {
        public Return Return { get; set; }
        public RopUser User { get; set; }
        public List<UsersDetail> UsersDetail { get; set; }
        public List<BusinessUnit> BusinessUnitList { get; set; }
        public List<DashboardType> DashboardType { get; set; }
        public string RightsULink { get; set; }
        public string IsLdapUser { get; set; }
        public virtual LoginTokenReturn LoginTokens { get; set; }
    }
}
