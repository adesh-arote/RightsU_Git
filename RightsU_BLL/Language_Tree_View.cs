using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_BLL
{
 
    public class Language_Tree_View
    {
        public string objLoginEntityConnectionStringName;
        
        public Language_Tree_View(string connectionstring)
        {
            objLoginEntityConnectionStringName = connectionstring;
        }
        private string[] _LanguageCodes_Selected;
        public string[] LanguageCodes_Selected
        {
            get { return this._LanguageCodes_Selected; }
            set { this._LanguageCodes_Selected = value; }
        }

        //Display selected Language on populate
        private string _LanguageCodes_Display;
        public string LanguageCodes_Display
        {
            get { return this._LanguageCodes_Display; }
            set { this._LanguageCodes_Display = value; }
        }

        //Display selected Language on populate
        private string[] _LanguageCodes_Reference;
        public string[] LanguageCodes_Reference
        {
            get { return this._LanguageCodes_Reference; }
            set { this._LanguageCodes_Reference = value; }
        }

        private string _Reference_From = "H";
        public string Reference_From
        {
            get { return _Reference_From; }
            set { _Reference_From = value; }
        }

        private string[] _SynLanguageCodes_Reference;
        public string[] SynLanguageCodes_Reference
        {
            get { return this._SynLanguageCodes_Reference; }
            set { this._SynLanguageCodes_Reference = value; }
        }

        private string[] _HBLanguageCodes_Reference;
        public string[] HBLanguageCodes_Reference
        {
            get { return this._HBLanguageCodes_Reference; }
            set { this._HBLanguageCodes_Reference = value; }
        }

        private string[] _RunLanguageCodes_Reference;
        public string[] RunLanguageCodes_Reference
        {
            get { return this._RunLanguageCodes_Reference; }
            set { this._RunLanguageCodes_Reference = value; }
        }

        private string[] _BudgetLanguageCodes_Reference;
        public string[] BudgetLanguageCodes_Reference
        {
            get { return this._BudgetLanguageCodes_Reference; }
            set { this._BudgetLanguageCodes_Reference = value; }
        }
        private bool _Show_Selected = false;

        public bool Show_Selected
        {
            get { return _Show_Selected; }
            set { _Show_Selected = value; }
        }


        int count = 0;
        public string PopulateTreeNode(string IsView, string Language_Hiearachy_Search = "")
        {
            USP_Service objUS = new USP_Service(objLoginEntityConnectionStringName);
            if (IsView == "Y" && Show_Selected == false)
            {
                Language_Hiearachy_Search = "";
                LanguageCodes_Display = null;
            }

            string tvChildData = "";
            List<Language> lstLanguage = null;
            //if (string.IsNullOrEmpty(LanguageCodes_Display))
            //    lstLanguage = new Language_Service(objLoginEntityConnectionStringName).SearchFor(s => true).OrderBy(s=>s.Language_Name).ToList();
            //else
            //{
                string[] arrLanguageCode = LanguageCodes_Display.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                lstLanguage = new Language_Service(objLoginEntityConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Language_Code.ToString())).OrderBy(x=>x.Language_Name).ToList();
            //}

            bool IsMenuReference = false, IsMenuChecked = false;
            foreach(Language objLanguage in lstLanguage)
            {
                objLanguage.Language_Name = objLanguage.Language_Name.Replace("'", @"\'"); 
                string strChild = "";
                bool IsReference = false, IsChecked = false;
                strChild += ", key: '" + objLanguage.Language_Code + "'";
                if (!IsChecked)
                {
                    if (LanguageCodes_Selected != null)
                    {
                        if (LanguageCodes_Selected.Contains(objLanguage.Language_Code.ToString()))
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
                    if (Language_Hiearachy_Search.Trim() != "")
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

                tvChildData += "{ title: '" + objLanguage.Language_Name + "'" + strChild + " } ";
            }

            string IsRef = "";
            if (IsView == "Y" && Show_Selected == false)
            {
                IsRef += ", unselectable: true";
                count = _LanguageCodes_Selected.Count();
                if (_LanguageCodes_Selected.Contains("0"))
                    count -= 1;
            }
            else if (IsView == "Y" && Show_Selected == true)
            {
                IsRef += ", hideCheckbox: true";
                count = _LanguageCodes_Selected.Count();
                if (_LanguageCodes_Selected.Contains("0"))
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
            if (tvChildData == "")
            {
                if (IsView == "Y")
                {
                    treeViewData = "[{ title: 'Language: <span>" + count + "</span>', key: '0', folder: true, expanded: true " + IsRef + "}];";
                }
                else
                    treeViewData = "[{ title: 'Language: <span id=\"{AD}\"></span>', key: '0', folder: true, expanded: true " + IsRef + "}];";
            }
            else
                if (IsView == "Y")
                {
                    treeViewData = "[{ title: 'Language: <span>" + count + "</span>', key: '0', folder: true, expanded: true " + IsRef + ", children: [" + tvChildData + "] }];";
                }
                else
                    treeViewData = "[{ title: 'Language: <span id=\"{AD}\"></span>', key: '0', folder: true, expanded: true " + IsRef + ", children: [" + tvChildData + "] }];";

            return treeViewData;
        }
    }
}
