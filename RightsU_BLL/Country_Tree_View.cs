using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_BLL
{
    public class Country_Tree_View
    {
        public string objLoginEntityConnectionStringName;
        private string[] _CountryCodes_Selected;
        public  Country_Tree_View(string connectionstring)
        {
            objLoginEntityConnectionStringName = connectionstring;
        }
        public string[] CountryCodes_Selected
        {
            get { return this._CountryCodes_Selected; }
            set { this._CountryCodes_Selected = value; }
        }

        //Display selected Country on populate
        private string _CountryCodes_Display;
        public string CountryCodes_Display
        {
            get { return this._CountryCodes_Display; }
            set { this._CountryCodes_Display = value; }
        }
        private string _objLoginUserSecurityGroupCode;
        public string objLoginUserSecurityGroupCode
        {
            get { return this._objLoginUserSecurityGroupCode; }
            set { this._objLoginUserSecurityGroupCode = value; }
        }
        //Display selected Country on populate
        private string[] _CountryCodes_Reference;
        public string[] CountryCodes_Reference
        {
            get { return this._CountryCodes_Reference; }
            set { this._CountryCodes_Reference = value; }
        }

        private string _Reference_From = "H";
        public string Reference_From
        {
            get { return _Reference_From; }
            set { _Reference_From = value; }
        }

        private string[] _SynCountryCodes_Reference;
        public string[] SynCountryCodes_Reference
        {
            get { return this._SynCountryCodes_Reference; }
            set { this._SynCountryCodes_Reference = value; }
        }

        private string[] _HBCountryCodes_Reference;
        public string[] HBCountryCodes_Reference
        {
            get { return this._HBCountryCodes_Reference; }
            set { this._HBCountryCodes_Reference = value; }
        }

        private string[] _RunCountryCodes_Reference;
        public string[] RunCountryCodes_Reference
        {
            get { return this._RunCountryCodes_Reference; }
            set { this._RunCountryCodes_Reference = value; }
        }

        private string[] _BudgetCountryCodes_Reference;
        public string[] BudgetCountryCodes_Reference
        {
            get { return this._BudgetCountryCodes_Reference; }
            set { this._BudgetCountryCodes_Reference = value; }
        }
        private bool _Show_Selected = false;

        public bool Show_Selected
        {
            get { return _Show_Selected; }
            set { _Show_Selected = value; }
        }
        private string _Is_Theatrical = "N";
        public string Is_Theatrical
        {
            get { return _Is_Theatrical; }
            set { _Is_Theatrical = value; }
        }
        private string _ModuleCode;
        public string ModuleCode
        {
            get { return this._ModuleCode; }
            set { this._ModuleCode = value; }
        }
        int count = 0;
        public string PopulateTreeNode(string IsView, string Country_Hiearachy_Search = "")
        {
            USP_Service objUS = new USP_Service(objLoginEntityConnectionStringName);
            if (IsView == "Y" && Show_Selected == false)
            {
                Country_Hiearachy_Search = "";
                CountryCodes_Display = null;
            }

            string tvChildData = "";
            List<Country> lstCountry = null;
            if (Is_Theatrical == "N")
            {
                //if (string.IsNullOrEmpty(CountryCodes_Display))
                //{
                //    string SecGroupCode = new System_Parameter_New_Service(objLoginEntityConnectionStringName).SearchFor(w => w.Parameter_Name == "Security_Group_Code_Avail").ToList().FirstOrDefault().Parameter_Value;
                //    if(SecGroupCode == objLoginUserSecurityGroupCode)
                //    {
                //        lstCountry = new Country_Service(objLoginEntityConnectionStringName).SearchFor(s => s.Is_Active == "Y" && s.Is_Theatrical_Territory == "N" && s.Country_Name != "India").OrderBy(x => x.Country_Name).ToList();
                //    }
                //    else
                //    {
                //        lstCountry = new Country_Service(objLoginEntityConnectionStringName).SearchFor(s => s.Is_Active == "Y" && s.Is_Theatrical_Territory == "N").OrderBy(x => x.Country_Name).ToList();
                //    }
                //}
                //else
                //{
                string SecGroupCode = new System_Parameter_New_Service(objLoginEntityConnectionStringName).SearchFor(w => w.Parameter_Name == "Security_Group_Code_Avail").ToList().FirstOrDefault().Parameter_Value;
                if (SecGroupCode == objLoginUserSecurityGroupCode || ModuleCode == "184" || ModuleCode == "185")
                {
                    if (string.IsNullOrEmpty(CountryCodes_Display))
                    {
                        string[] arrCountryCode = CountryCodes_Display.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        lstCountry = new Country_Service(objLoginEntityConnectionStringName).SearchFor(s => arrCountryCode.Contains(s.Country_Code.ToString())).OrderBy(x => x.Country_Name).ToList();
                    }
                    else
                    {
                        lstCountry = new Country_Service(objLoginEntityConnectionStringName).SearchFor(s => s.Is_Active == "Y" && s.Is_Theatrical_Territory == "N" && s.Country_Name != "India").OrderBy(x => x.Country_Name).ToList();
                    }
                }
                else
                {
                    string[] arrCountryCode = CountryCodes_Display.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                    lstCountry = new Country_Service(objLoginEntityConnectionStringName).SearchFor(s => arrCountryCode.Contains(s.Country_Code.ToString())).OrderBy(x => x.Country_Name).ToList();
                }
                //}
            }
            if(Is_Theatrical == "Y")
            {
                //if (string.IsNullOrEmpty(CountryCodes_Display))
                //{
                //    string SecGroupCode = new System_Parameter_New_Service(objLoginEntityConnectionStringName).SearchFor(w => w.Parameter_Name == "Security_Group_Code_Avail").ToList().FirstOrDefault().Parameter_Value;
                //    if (SecGroupCode == objLoginUserSecurityGroupCode)
                //    {
                //        lstCountry = new Country_Service(objLoginEntityConnectionStringName).SearchFor(s => s.Is_Active == "Y" && s.Is_Theatrical_Territory == "Y" && s.Country_Name != "India").OrderBy(x => x.Country_Name).ToList();
                //     }
                //    else
                //    {
                //        lstCountry = new Country_Service(objLoginEntityConnectionStringName).SearchFor(s => s.Is_Active == "Y" && s.Is_Theatrical_Territory == "Y").OrderBy(x => x.Country_Name).ToList();
                //    }
                //}
                //else
                //{
                    string[] arrCountryCode = CountryCodes_Display.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                    lstCountry = new Country_Service(objLoginEntityConnectionStringName).SearchFor(s => arrCountryCode.Contains(s.Country_Code.ToString())).OrderBy(x => x.Country_Name).ToList();
                //}
            }

            bool IsMenuReference = false, IsMenuChecked = false;
            foreach (Country objCountry in lstCountry)
            {
                objCountry.Country_Name = objCountry.Country_Name.Replace("'", @"\'"); 
                
                
                string strChild = "";
                bool IsReference = false, IsChecked = false;
                strChild += ", key: '" + objCountry.Country_Code + "'";
                if (!IsChecked)
                {
                    if (CountryCodes_Selected != null)
                    {
                        if (CountryCodes_Selected.Contains(objCountry.Country_Code.ToString()))
                        {
                            IsChecked = true;
                            strChild += ", selected: true, preselected : true";
                        }
                    }
                }

                if (IsChecked)
                {
                    IsMenuChecked = true;
                    if (IsReference)
                    {
                        IsMenuReference = true;
                        strChild += ", unselectable: true";
                        strChild += ", tooltip: 'Reference Found'";
                    }
                }
                else
                {
                    if (Country_Hiearachy_Search.Trim() != "")
                        strChild += ", expanded: true";
                    else
                        strChild += ", expanded: false";
                }

                if (IsChecked)
                    count++;

                if (IsView == "Y" && Show_Selected == false)
                {
                    strChild += ", unselectable: true";
                }
                else if (IsView == "Y" && Show_Selected == true)
                {
                    strChild += ", hideCheckbox: true";
                }

                if (tvChildData != "")
                    tvChildData += ",";

                tvChildData += "{ title: '" + objCountry.Country_Name + "'" + strChild + " } ";
                
            }

            string IsRef = "";
            if (IsView == "Y" && Show_Selected == false)
            {
                IsRef += ", unselectable: true";
                count = _CountryCodes_Selected.Count();
                if (_CountryCodes_Selected.Contains("0"))
                    count -= 1;
            }
            else if (IsView == "Y" && Show_Selected == true)
            {
                IsRef += ", hideCheckbox: true";
                count = _CountryCodes_Selected.Count();
                if (_CountryCodes_Selected.Contains("0"))
                    count -= 1;
            }

            if (IsMenuReference)
            {
                IsRef += ", unselectable: true";
                IsRef += ", tooltip: 'Reference Found'";
            }
            if (IsMenuChecked)
                IsRef += ", selected: true";

            string treeViewData = "";
            if (Is_Theatrical == "N")
            {
                if (tvChildData == "")
                {
                    if (IsView == "Y")
                    {
                        treeViewData = "[{ title: 'Country: <span>" + count + "</span>', key: '0', folder: true, expanded: true " + IsRef + "}];";
                    }
                    else
                        treeViewData = "[{ title: 'Country: <span id=\"{AD}\"></span>', key: '0', folder: true, expanded: true " + IsRef + "}];";
                }
                else
                    if (IsView == "Y")
                {
                    treeViewData = "[{ title: 'Country: <span>" + count + "</span>', key: '0', folder: true, expanded: true " + IsRef + ", children: [" + tvChildData + "] }];";
                }
                else
                    treeViewData = "[{ title: 'Country: <span id=\"{AD}\"></span>', key: '0', folder: true, expanded: true " + IsRef + ", children: [" + tvChildData + "] }];";
            }
            else
            {
                if (tvChildData == "")
                {
                    if (IsView == "Y")
                    {
                        treeViewData = "[{ title: 'Circuit: <span>" + count + "</span>', key: '0', folder: true, expanded: true " + IsRef + "}];";
                    }
                    else
                        treeViewData = "[{ title: 'Circuit: <span id=\"{AD}\"></span>', key: '0', folder: true, expanded: true " + IsRef + "}];";
                }
                else
                   if (IsView == "Y")
                {
                    treeViewData = "[{ title: 'Circuit: <span>" + count + "</span>', key: '0', folder: true, expanded: true " + IsRef + ", children: [" + tvChildData + "] }];";
                }
                else
                    treeViewData = "[{ title: 'Circuit: <span id=\"{AD}\"></span>', key: '0', folder: true, expanded: true " + IsRef + ", children: [" + tvChildData + "] }];";

            }
            return treeViewData;
        }

    }
}
