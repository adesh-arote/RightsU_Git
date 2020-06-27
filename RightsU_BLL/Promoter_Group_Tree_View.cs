using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_BLL
{
    public class Promoter_Group_Tree_View
    {
        public string _Connection_Str;
        public Promoter_Group_Tree_View(string connectionstring)
        {
            _Connection_Str = connectionstring;
        }
        private string[] _Promoter_GroupCodes_Selected;
        public string[] Promoter_GroupCodes_Selected
        {
            get { return this._Promoter_GroupCodes_Selected; }
            set { this._Promoter_GroupCodes_Selected = value; }
        }

        //Display selected platform on populate
        private string _Promoter_GroupCodes_Display;
        public string Promoter_GroupCodes_Display
        {
            get { return this._Promoter_GroupCodes_Display; }
            set { this._Promoter_GroupCodes_Display = value; }
        }

        //Display selected platform on populate
        private string[] _Promoter_GroupCodes_Reference;
        public string[] Promoter_GroupCodes_Reference
        {
            get { return this._Promoter_GroupCodes_Reference; }
            set { this._Promoter_GroupCodes_Reference = value; }
        }

        private string _Reference_From = "H";
        public string Reference_From
        {
            get { return _Reference_From; }
            set { _Reference_From = value; }
        }

        private bool _Show_Selected = false;
        public bool Show_Selected
        {
            get { return _Show_Selected; }
            set { _Show_Selected = value; }
        }

        private string[] _SynPlatformCodes_Reference;
        public string[] SynPlatformCodes_Reference
        {
            get { return this._SynPlatformCodes_Reference; }
            set { this._SynPlatformCodes_Reference = value; }
        }

        private string[] _SynPlatformCodes_Reference_New;
        public string[] SynPlatformCodes_Reference_New
        {
            get { return this._SynPlatformCodes_Reference_New; }
            set { this._SynPlatformCodes_Reference_New = value; }
        }

        int count = 0;
        public string PopulateTreeNode(string IsView, string Promoter_Group_Hiearachy_Search = "", bool Is_emptyPromoterCode = false)
        {
            USP_Service objUS = new USP_Service(_Connection_Str);
            List<USP_Get_Promoter_Group_Tree_Hierarchy_Result> lstPromoters = objUS.USP_Get_Promoter_Group_Tree_Hierarchy(Promoter_GroupCodes_Display, Promoter_Group_Hiearachy_Search).ToList();
            if (Is_emptyPromoterCode)
                lstPromoters.Clear();

            string tvChildData = "";

            List<USP_Get_Promoter_Group_Tree_Hierarchy_Result> arr = lstPromoters.Where(x => x.Parent_Group_Code == 0).ToList();

            bool IsMenuReference = false, IsMenuChecked = false;
            for (int i = 0; i < arr.Count; i++)
            {
                USP_Get_Promoter_Group_Tree_Hierarchy_Result objPromoter = arr[i];

                objPromoter.Promoter_Group_Name = objPromoter.Promoter_Group_Name.Replace("'", @"\'");

                string strChild = "";

                bool IsReference = false, IsChecked = false;
                if (objPromoter.Is_Last_Level == "N")
                {
                    string strLeastChild = "";
                    IsChecked = AddChildDetailForGroup(objPromoter.Promoter_Group_Code, lstPromoters, IsView, out IsReference, out strLeastChild, Promoter_Group_Hiearachy_Search);
                    //IsReference = false;
                    strChild += ", key: '0', children: [ " + strLeastChild + " ]";
                }
                else
                    strChild += ", key: '" + objPromoter.Promoter_Group_Code + "'";
                if (IsChecked != true)
                {
                    if (Promoter_GroupCodes_Selected != null)
                        //if (PlatformCodes_Selected.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                        if (Promoter_GroupCodes_Selected.Contains(objPromoter.Promoter_Group_Code.ToString()))
                        {
                            IsChecked = true;
                            strChild += ", selected: true, preselected : true";
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
                        List<string> referenceIn = new List<string>();
                        if (SynPlatformCodes_Reference != null)
                            if (SynPlatformCodes_Reference.Where(x => x == Convert.ToString(objPromoter.Promoter_Group_Code)).Count() > 0)
                            {
                                referenceIn.Add("Syndication");
                            }
                        //if (SynPlatformCodes_Reference_New != null)
                        //    if (SynPlatformCodes_Reference_New.Where(x => x == Convert.ToString(objPromoter.Promoter_Group_Code)).Count() > 0)
                        //    {
                        //        referenceIn.Add("Syndication");
                        //    }


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
                    if (Promoter_Group_Hiearachy_Search.Trim() != "")
                        strChild += ", expanded: true";
                    else
                        strChild += ", expanded: false";
                }

                if (IsChecked && objPromoter.ChildCount == 0)
                    count++;

                if (IsView == "Y" && Show_Selected == false)
                {
                    if (Promoter_GroupCodes_Selected.Where(x => x == Convert.ToString(objPromoter.Promoter_Group_Code)).Count() > 0)
                    {
                        strChild += ", unselectableStatus: true";
                    }
                    else
                    {
                        strChild += ", unselectable: true";
                    }
                    //strChild += ", Checkbox: false";
                    //strChild += ", unselectable: true";
                }
                else if (IsView == "Y" && Show_Selected == true)
                {
                    strChild += ", checkbox: false";
                }

                if (tvChildData != "")
                    tvChildData += ",";

                //if (objPlatform.ChildCount == 0)
                tvChildData += "{ title: '" + objPromoter.Promoter_Group_Name + "' " + (objPromoter.ChildCount > 0 ? ", folder: true" : "") + strChild + " } ";
                //else
                //    tvChildData += "{ title: '" + objPlatform.Platform_Name + "'children: [" + strChild + "] } ";

            }

            string IsRef = "";
            if (IsView == "Y" && Show_Selected == false)
            {
                if (Is_emptyPromoterCode)
                    count = 0;
                else
                {
                    IsRef += ", unselectableStatus: true";
                    count = _Promoter_GroupCodes_Selected.Count();
                    if (_Promoter_GroupCodes_Selected.Contains("0"))
                    { count -= 1; }
                }
            }
            else if (IsView == "Y" && Show_Selected == true)
            {
                if (Is_emptyPromoterCode)
                    count = 0;
                else
                {
                    IsRef += ", checkbox: false";
                    count = _Promoter_GroupCodes_Selected.Count();
                    if (_Promoter_GroupCodes_Selected.Contains("0"))
                    { count -= 1; }
                }
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
                    treeViewData = "[{ title: 'Self Utilization  : <span>" + count + "</span>', key: '0', folder: true, expanded: true " + IsRef + "}];";
                }
                else
                    treeViewData = "[{ title: 'Self Utilization  : <span id=\"{AD}\"></span>', key: '0', folder: true, expanded: true " + IsRef + "}];";
            }
            else
                if (IsView == "Y")
            {
                treeViewData = "[{ title: 'Self Utilization  : <span>" + count + "</span>', key: '0', folder: true, expanded: true " + IsRef + ", children: [" + tvChildData + "] }];";
            }
            else
                treeViewData = "[{ title: 'Self Utilization  : <span id=\"{AD}\"></span>', key: '0', folder: true, expanded: true " + IsRef + ", children: [" + tvChildData + "] }];";

            return treeViewData;
        }

        private bool AddChildDetailForGroup(int Platform_Code, List<USP_Get_Promoter_Group_Tree_Hierarchy_Result> lstPromoter, string IsView, out bool IsReference, out string strChild, string Promoter_Group_Hiearachy_Search = "")
        {
            List<USP_Get_Promoter_Group_Tree_Hierarchy_Result> arr = lstPromoter.Where(x => x.Parent_Group_Code == Platform_Code).ToList();
            bool IsChecked = false;
            IsReference = false;

            strChild = "";

            for (int i = 0; i < arr.Count; i++)
            {

                string strLocalChild = "";
                //TreeNode trChildNode = new TreeNode();
                USP_Get_Promoter_Group_Tree_Hierarchy_Result objPromoter = arr[i];

                if (objPromoter.Is_Last_Level == "N")
                {
                    bool IsLocalReference = false;
                    string strLeastChild = "";
                    if (!IsChecked)
                        IsChecked = AddChildDetailForGroup(objPromoter.Promoter_Group_Code, lstPromoter, IsView, out IsLocalReference, out strLeastChild, Promoter_Group_Hiearachy_Search);
                    else
                        AddChildDetailForGroup(objPromoter.Promoter_Group_Code, lstPromoter, IsView, out IsLocalReference, out strLeastChild, Promoter_Group_Hiearachy_Search);
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
                    strLocalChild += ", key: '" + objPromoter.Promoter_Group_Code + "'";
                    if (Promoter_GroupCodes_Selected != null)
                        if (Promoter_GroupCodes_Selected.Where(x => x == Convert.ToString(objPromoter.Promoter_Group_Code)).Count() > 0)
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
                        if (SynPlatformCodes_Reference.Where(x => x == Convert.ToString(objPromoter.Parent_Group_Code)).Count() > 0)
                        {
                            referenceIn.Add("Syndication");
                        }

                    //if (SynPlatformCodes_Reference_New != null)
                    //    if (SynPlatformCodes_Reference_New.Where(x => x == Convert.ToString(objPromoter.Parent_Group_Code)).Count() > 0)
                    //    {
                    //        referenceIn.Add("Syndication");
                    //    }

                    if (referenceIn.Count > 0)
                    {
                        IsReference = true;
                        strLocalChild += ", unselectableStatus: true, preselected : true";
                        strLocalChild += ", tooltip: '" + string.Join(",", referenceIn) + " is already added for the platform'";
                    }

                }

                if (Promoter_GroupCodes_Selected != null)
                    if (Promoter_GroupCodes_Selected.Where(x => x == Convert.ToString(objPromoter.Promoter_Group_Code)).Count() > 0)
                        strLocalChild += ", selected: true, preselected : true";


                if (IsView == "Y" && Show_Selected == false)
                {
                    if (Promoter_GroupCodes_Selected.Where(x => x == Convert.ToString(objPromoter.Promoter_Group_Code)).Count() > 0)
                    {
                        strLocalChild += ", unselectableStatus: true";
                    }
                    else
                    {
                        strLocalChild += ", unselectable: true";
                    }
                    //strLocalChild += ", unselectableStatus: true";
                }
                else if (IsView == "Y" && Show_Selected == true)
                {
                    strLocalChild += ", checkbox: false";
                }
                if (Promoter_Group_Hiearachy_Search.Trim() != "")
                    strLocalChild += ", expanded: true";
                else
                    strLocalChild += ", expanded: false";

                strChild += (i > 0 ? "," : "") + " { title: '" + objPromoter.Promoter_Group_Name + "' " + (objPromoter.ChildCount > 0 ? ", folder: true " : "") + strLocalChild + " }";

            }

            return IsChecked;
        }

    }
}

