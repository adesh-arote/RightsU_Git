using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_BLL
{
    public class Platform_Tree_View
    {
        public string _Connection_Str;
        public Platform_Tree_View(string connectionstring)
        {
            _Connection_Str = connectionstring;
        }
        private string[] _PlatformCodes_Selected;
        public string[] PlatformCodes_Selected
        {
            get { return this._PlatformCodes_Selected; }
            set { this._PlatformCodes_Selected = value; }
        }

        //Display selected platform on populate
        private string _PlatformCodes_Display;
        public string PlatformCodes_Display
        {
            get { return this._PlatformCodes_Display; }
            set { this._PlatformCodes_Display = value; }
        }

        //Display selected platform on populate
        private string[] _PlatformCodes_Reference;
        public string[] PlatformCodes_Reference
        {
            get { return this._PlatformCodes_Reference; }
            set { this._PlatformCodes_Reference = value; }
        }

        private string _Reference_From = "H";
        public string Reference_From
        {
            get { return _Reference_From; }
            set { _Reference_From = value; }
        }

        private string[] _SynPlatformCodes_Reference;
        public string[] SynPlatformCodes_Reference
        {
            get { return this._SynPlatformCodes_Reference; }
            set { this._SynPlatformCodes_Reference = value; }
        }

        private string[] _HBPlatformCodes_Reference;
        public string[] HBPlatformCodes_Reference
        {
            get { return this._HBPlatformCodes_Reference; }
            set { this._HBPlatformCodes_Reference = value; }
        }

        private string[] _TOPlatformCodes_Reference;
        public string[] TOPlatformCodes_Reference
        {
            get { return this._TOPlatformCodes_Reference; }
            set { this._TOPlatformCodes_Reference = value; }
        }

        private string[] _AncPlatformCodes_Reference;
        public string[] AncPlatformCodes_Reference
        {
            get { return this._AncPlatformCodes_Reference; }
            set { this._AncPlatformCodes_Reference = value; }
        }

        private string[] _RunPlatformCodes_Reference;
        public string[] RunPlatformCodes_Reference
        {
            get { return this._RunPlatformCodes_Reference; }
            set { this._RunPlatformCodes_Reference = value; }
        }

        private string[] _BudgetPlatformCodes_Reference;
        public string[] BudgetPlatformCodes_Reference
        {
            get { return this._BudgetPlatformCodes_Reference; }
            set { this._BudgetPlatformCodes_Reference = value; }
        }
        private bool _Show_Selected = false;

        public bool Show_Selected
        {
            get { return _Show_Selected; }
            set { _Show_Selected = value; }
        }

        private string _Is_Avail = "N";

        public string Is_Avail
        {
            get { return _Is_Avail; }
            set { _Is_Avail = value; }
        }


        int count = 0;
        public string PopulateTreeNode(string IsView, string IS_Sport_Right = "", string Platform_Hiearachy_Search = "")
        {
            USP_Service objUS = new USP_Service(_Connection_Str);
            if(Platform_Hiearachy_Search != "Buyback")
            {
                if (IsView == "Y" && Show_Selected == false)
                {
                    Platform_Hiearachy_Search = "";
                    PlatformCodes_Display = null;
                }
            }
            
            
            List<USP_Get_Platform_Tree_Hierarchy_Result> lstPlatforms = objUS.USP_Get_Platform_Tree_Hierarchy(PlatformCodes_Display, Platform_Hiearachy_Search, IS_Sport_Right).ToList();

            //if (PlatformCodes_Display == "")
            //    trMenuNode.ExpandAll();
            //else
            //    trMenuNode.Expand();

            if(Is_Avail == "Y")
            {
                if (PlatformCodes_Display == "")
                    lstPlatforms = new List<USP_Get_Platform_Tree_Hierarchy_Result>();
            }
            string tvChildData = "";

            List<USP_Get_Platform_Tree_Hierarchy_Result> arr = lstPlatforms.Where(x => x.Parent_Platform_Code == 0).ToList();

            bool IsMenuReference = false, IsMenuChecked = false;
            for (int i = 0; i < arr.Count; i++)
            {
                USP_Get_Platform_Tree_Hierarchy_Result objPlatform = arr[i];

             objPlatform.Platform_Name = objPlatform.Platform_Name.Replace("'", @"\'");

                string strChild = "";

                bool IsReference = false, IsChecked = false;
                if (objPlatform.ChildCount > 0)
                {
                    string strLeastChild = "";
                    IsChecked = AddChildDetailForGroup(objPlatform.Platform_Code, lstPlatforms, IsView, out IsReference, out strLeastChild, Platform_Hiearachy_Search);
                    strChild += ", key: '0', children: [ " + strLeastChild + " ]";
                }
                else
                    strChild += ", key: '" + objPlatform.Platform_Code + "'";
                if (IsChecked != true)
                {
                    if (PlatformCodes_Selected != null)
                        //if (PlatformCodes_Selected.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                        if (PlatformCodes_Selected.Contains(objPlatform.Platform_Code.ToString()))
                        {
                            IsChecked = true;
                            strChild += ", selected: true, preselected: true";
                        };
                }
                if (IsChecked)
                {

                    IsMenuChecked = true;
                    if (IsReference)
                    {
                        IsMenuReference = true;
                        strChild += ", unselectableStatus: true, preselected : true";
                        strChild += ", tooltip: 'Reference Found'";
                        //if (Reference_From == "H")
                        //    strChild += ", tooltip: 'Holdback is already added for the platform'";
                        //else
                        //    strChild += ", tooltip: 'Platform is already syndicated'";
                    }
                    else
                    {
                        //if (PlatformCodes_Reference != null)
                        //    if (PlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                        //    {
                        //        IsMenuReference = true;
                        //        strChild += ", unselectable: true";
                        //        if (Reference_From == "H")
                        //            strChild += ", tooltip: 'Holdback is already added for the platform'";
                        //        else
                        //            strChild += ", tooltip: 'Platform is already syndicated'";
                        //    }
                        List<string> referenceIn = new List<string>();
                        if (SynPlatformCodes_Reference != null)
                            if (SynPlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                            {
                                referenceIn.Add("Syndication");
                            }
                        if (HBPlatformCodes_Reference != null)
                            if (HBPlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                            {
                                referenceIn.Add("Holdback");
                            }
                        if (TOPlatformCodes_Reference != null)
                            if (TOPlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                            {
                                referenceIn.Add("Title Objection");
                            }
                        if (AncPlatformCodes_Reference != null)
                            if (AncPlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                            {
                                referenceIn.Add("Holdback");
                            }
                        if (RunPlatformCodes_Reference != null)
                            if (RunPlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                            {
                                referenceIn.Add("Run");
                            }

                        if (BudgetPlatformCodes_Reference != null)
                            if (BudgetPlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                            {
                                referenceIn.Add("Budget");
                            }

                        if (referenceIn.Count > 0)
                        {
                            IsReference = true;
                            strChild += ", unselectableStatus: true, preselected : true";
                            strChild += ", tooltip: '" + string.Join(",", referenceIn) + " is already added for the platform'";
                        }
                    }
                }
                else
                {
                    if (Platform_Hiearachy_Search.Trim() != "")
                        strChild += ", expanded: true";
                    else
                        strChild += ", expanded: false";
                }

                if (IsChecked && objPlatform.ChildCount == 0)
                    count++;

                if (IsView == "Y" && Show_Selected == false)
                {
                    if (PlatformCodes_Selected.Contains(objPlatform.Platform_Code.ToString()))
                    {
                        strChild += ", unselectableStatus: true";
                    }
                    else
                    {
                        strChild += ", unselectable: true";
                    }
                        //strChild += ", hideCheckbox: false";      
                }
                else if (IsView == "Y" && Show_Selected == true)
                {
                    strChild += ", checkbox: false";
                }

                if (tvChildData != "")
                    tvChildData += ",";

                //if (objPlatform.ChildCount == 0)
                tvChildData += "{ title: '" + objPlatform.Platform_Name + "' " + (objPlatform.ChildCount > 0 ? ", folder: true" : "") + strChild + " } ";
                //else
                //    tvChildData += "{ title: '" + objPlatform.Platform_Name + "'children: [" + strChild + "] } ";

            }

            string IsRef = "";
            if (IsView == "Y" && Show_Selected == false)
            {
                IsRef += ", unselectableStatus: true";
                count = _PlatformCodes_Selected.Count();
                if (_PlatformCodes_Selected.Contains("0"))
                    count -= 1;
            }
            else if (IsView == "Y" && Show_Selected == true)
            {
                IsRef += ", checkbox: false";
                //count = _PlatformCodes_Selected.Count();
                //if (_PlatformCodes_Selected.Contains("0"))
                //    count -= 1;
            }

            if (IsMenuReference)
            {
                IsRef += ", unselectableStatus: true, preselected: true";
                IsRef += ", tooltip: 'Reference Found'";
                //if (Reference_From == "H")
                //    IsRef += ", tooltip: 'Holdback is already added for the platform'";
                //else
                //    IsRef += ", tooltip: 'Platform is already syndicated'";
            }
            if (IsMenuChecked)
                IsRef += ", selected: true";

            string treeViewData = "";
            if (tvChildData == "")
            {
                if (IsView == "Y")
                {
                    treeViewData = "[{ title: 'Platform / Rights : <span>" + count + "</span>', key: '0', folder: true, expanded: true " + IsRef + "}];";
                }
                else
                    treeViewData = "[{ title: 'Platform / Rights : <span id=\"{AD}\"></span>', key: '0', folder: true, expanded: true " + IsRef + "}];";
            }
            else
                if (IsView == "Y")
                {
                    treeViewData = "[{ title: 'Platform / Rights : <span>" + count + "</span>', key: '0', folder: true, expanded: true " + IsRef + ", children: [" + tvChildData + "] }];";
                }
                else
                    treeViewData = "[{ title: 'Platform / Rights : <span id=\"{AD}\"></span>', key: '0', folder: true, expanded: true " + IsRef + ", children: [" + tvChildData + "] }];";

            return treeViewData;
        }

        private bool AddChildDetailForGroup(int Platform_Code, List<USP_Get_Platform_Tree_Hierarchy_Result> lstPlatforms, string IsView, out bool IsReference, out string strChild, string Platform_Hiearachy_Search = "")
        {
            List<USP_Get_Platform_Tree_Hierarchy_Result> arr = lstPlatforms.Where(x => x.Parent_Platform_Code == Platform_Code).ToList();
            bool IsChecked = false;
            IsReference = false;

            strChild = "";

            for (int i = 0; i < arr.Count; i++)
            {

                string strLocalChild = "";
                //TreeNode trChildNode = new TreeNode();
                USP_Get_Platform_Tree_Hierarchy_Result objPlatform = arr[i];

                if (objPlatform.ChildCount > 0)
                {
                    bool IsLocalReference = false;
                    string strLeastChild = "";
                    if (!IsChecked)
                        IsChecked = AddChildDetailForGroup(objPlatform.Platform_Code, lstPlatforms, IsView, out IsLocalReference, out strLeastChild, Platform_Hiearachy_Search);
                    else
                        AddChildDetailForGroup(objPlatform.Platform_Code, lstPlatforms, IsView, out IsLocalReference, out strLeastChild, Platform_Hiearachy_Search);
                    strLocalChild += ", key: '0', children: [ " + strLeastChild + " ]";

                    if (IsLocalReference)
                    {
                        IsReference = true;
                        strLocalChild += ", unselectableStatus: true, preselected: true";
                        strLocalChild += ", tooltip: 'Reference found'";
                        //if (Reference_From == "H")
                        //    strLocalChild += ", tooltip: 'Holdback is already added for the platform'";
                        //else
                        //    strLocalChild += ", tooltip: 'Platform is already syndicated'";
                    }

                }
                else
                {
                    strLocalChild += ", key: '" + objPlatform.Platform_Code + "'";
                    if (PlatformCodes_Selected != null)
                        if (PlatformCodes_Selected.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                        {
                            IsChecked = true;
                            count++;
                        }
                    //else
                    //    IsChecked = false;
                    //if (PlatformCodes_Reference != null)
                    //    if (PlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                    //    {
                    //        IsReference = true;
                    //        strLocalChild += ", unselectable: true";
                    //        if (Reference_From == "H")
                    //            strLocalChild += ", tooltip: 'Holdback is already added for the platform'";
                    //        else
                    //            strLocalChild += ", tooltip: 'Platform is already syndicated'";
                    //    }
                    List<string> referenceIn = new List<string>();
                    if (SynPlatformCodes_Reference != null)
                        if (SynPlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                        {
                            referenceIn.Add("Syndication");
                        }
                    if (HBPlatformCodes_Reference != null)
                        if (HBPlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                        {
                            referenceIn.Add("Holdback");
                        }
                    if (TOPlatformCodes_Reference != null)
                        if (TOPlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                        {
                            referenceIn.Add("Title Objection");
                        }
                    if (AncPlatformCodes_Reference != null)
                        if (AncPlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                        {
                            referenceIn.Add("Holdback");
                        }
                    if (RunPlatformCodes_Reference != null)
                        if (RunPlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                        {
                            referenceIn.Add("Run");
                        }
                    if (BudgetPlatformCodes_Reference != null)
                        if (BudgetPlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                        {
                            referenceIn.Add("Budget");
                        }
                    if (referenceIn.Count > 0)
                    {
                        IsReference = true;
                        strLocalChild += ", unselectableStatus: true, preselected: true";
                        strLocalChild += ", tooltip: '" + string.Join(",", referenceIn) + " is already added for the platform'";
                    }

                }

                if (PlatformCodes_Selected != null)
                    if (PlatformCodes_Selected.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                        strLocalChild += ", selected: true, preselected : true";


                if (IsView == "Y" && Show_Selected == false)
                {
                    if (PlatformCodes_Selected.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                    {
                        strLocalChild += ", unselectableStatus: true";
                    }
                    else
                    {
                        strLocalChild += ", unselectable: true";
                    }
                                       
                }
                else if (IsView == "Y" && Show_Selected == true)
                {
                    strLocalChild += ", checkbox: false";
                }
                if (Platform_Hiearachy_Search.Trim() != "")
                    strLocalChild += ", expanded: true";
                else
                    strLocalChild += ", expanded: false";

                strChild += (i > 0 ? "," : "") + " { title: '" + objPlatform.Platform_Name + "' " + (objPlatform.ChildCount > 0 ? ", folder: true " : "") + strLocalChild + " }";

            }
            return IsChecked;
        }

    }
}
