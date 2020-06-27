using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_BLL
{
    public class User_Security_Tree_View
    {
        public string _Connection_Str;

        public User_Security_Tree_View(string connectionstring)
        {
            _Connection_Str = connectionstring;
        }
        private string[] _SecurityCodes_Selected;
        public string[] SecurityCodes_Selected
        {
            get { return this._SecurityCodes_Selected; }
            set { this._SecurityCodes_Selected = value; }
        }

        //Display selected platform on populate
        private string _SecurityCodes_Display;
        public string SecurityCodes_Display
        {
            get { return this._SecurityCodes_Display; }
            set { this._SecurityCodes_Display = value; }
        }

        //Display selected platform on populate
        private string[] _SecurityCodes_Reference;
        public string[] SecurityCodes_Reference
        {
            get { return this._SecurityCodes_Reference; }
            set { this._SecurityCodes_Reference = value; }
        }

        private string _Reference_From = "H";
        public string Reference_From
        {
            get { return _Reference_From; }
            set { _Reference_From = value; }
        }



        int count = 0;
        public string PopulateTreeNode(string IsView, string Security_Hiearachy_Search = "")
        {
            USP_Service objUS = new USP_Service(_Connection_Str);

            List<USP_Get_User_Security_Group_Tree_Hierarchy_Result> lstSecurity = objUS.USP_Get_User_Security_Group_Tree_Hierarchy(SecurityCodes_Display, Security_Hiearachy_Search).ToList();

            //if (PlatformCodes_Display == "")
            //    trMenuNode.ExpandAll();
            //else
            //    trMenuNode.Expand();

            string tvChildData = "";

            List<USP_Get_User_Security_Group_Tree_Hierarchy_Result> arr = lstSecurity.Where(x => x.Parent_Module_Code == 0).ToList();

            bool IsMenuReference = false, IsMenuChecked = false;
            for (int i = 0; i < arr.Count; i++)
            {
                USP_Get_User_Security_Group_Tree_Hierarchy_Result objSecurity = arr[i];

                string strChild = "";

                bool IsReference = false, IsChecked = false;
                if (objSecurity.ChildCount > 0 || objSecurity.RightsCount > 0)
                {
                    string strLeastChild = "";

                    if (!IsChecked)
                        IsChecked = AddChildDetailForGroup(objSecurity.Module_Code, objSecurity.RightsCount, lstSecurity, IsView, out IsReference, out strLeastChild, Security_Hiearachy_Search);
                    else
                        AddChildDetailForGroup(objSecurity.Module_Code, objSecurity.RightsCount, lstSecurity, IsView, out IsReference, out strLeastChild, Security_Hiearachy_Search);


                    strChild += ", key: '0', children: [ " + strLeastChild + " ]";
                }
                else
                    strChild += ", key: '" + objSecurity.Module_Code + "'";
                if (IsChecked != true)
                {
                    if (SecurityCodes_Selected != null)
                        //if (PlatformCodes_Selected.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                        if (SecurityCodes_Selected.Contains(objSecurity.Module_Code.ToString()))
                        {
                            IsChecked = true;
                            strChild += ", selected: true";
                        };
                }
                if (IsChecked)
                {

                    IsMenuChecked = true;
                    if (IsReference)
                    {
                        IsMenuReference = true;
                        strChild += ", unselectable: true";
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


                        if (referenceIn.Count > 0)
                        {
                            IsReference = true;
                            strChild += ", unselectable: true";
                            strChild += ", tooltip: '" + string.Join(",", referenceIn) + " is already added for the platform'";
                        }
                    }
                }
                else
                {
                    if (Security_Hiearachy_Search.Trim() != "")
                        strChild += ", expanded: true";
                    else
                        strChild += ", expanded: false";
                }

                if (IsChecked && objSecurity.ChildCount == 0)
                    count++;

                if (IsView == "Y")
                {
                    strChild += ", hideCheckbox: false";
                }

                if (tvChildData != "")
                    tvChildData += ",";

                //if (objPlatform.ChildCount == 0)
                tvChildData += "{ title: '" + objSecurity.Module_Name + "' " + (objSecurity.ChildCount > 0 ? ", folder: true" : "") + strChild + " } ";
                //else
                //    tvChildData += "{ title: '" + objPlatform.Platform_Name + "'children: [" + strChild + "] } ";

            }

            string IsRef = "";
            if (IsView == "Y")
            {
                IsRef += ", hideCheckbox: false";
                count = lstSecurity.Where(x => x.Parent_Module_Code == 0).Count();
            }

            if (IsMenuReference)
            {
                IsRef += ", unselectable: true";
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
                    treeViewData = "[{ title: 'Root : <span>" + count + "</span>', key: '0', folder: true, expanded: true " + IsRef + "}];";
                }
                else
                    treeViewData = "[{ title: 'Root : <span id=\"{AD}\"></span>', key: '0', folder: true, expanded: true " + IsRef + "}];";
            }
            else
                if (IsView == "Y")
                {
                    treeViewData = "[{ title: 'Root : <span>" + count + "</span>', key: '0', folder: true, expanded: true " + IsRef + ", children: [" + tvChildData + "] }];";
                }
                else
                    treeViewData = "[{ title: 'Root : <span id=\"{AD}\"></span>', key: '0', folder: true, expanded: true " + IsRef + ", children: [" + tvChildData + "] }];";

            return treeViewData;
        }

        private bool AddChildDetailForGroup(int Security_Code, int? RightsCount, List<USP_Get_User_Security_Group_Tree_Hierarchy_Result> lstSecurity, string IsView, out bool IsReference, out string strChild, string Security_Hiearachy_Search = "")
        {
            RightsU_Entities.System_Right objSR = new System_Right();

            List<USP_Get_User_Security_Group_Tree_Hierarchy_Result> arr;
            System_Right_Service objService = new System_Right_Service(_Connection_Str);
            //if (RightsCount == null)
            arr = lstSecurity.Where(x => x.Parent_Module_Code == Security_Code).ToList();


            //else
            //    arr = lstSecurity.Where(x => x.Module_Code == Security_Code && x.Rights_Codes != "").ToList();
            bool IsChecked = false;
            IsReference = false;

            strChild = "";

            for (int i = 0; i < arr.Count; i++)
            {

                string strLocalChild = "";
                //TreeNode trChildNode = new TreeNode();
                USP_Get_User_Security_Group_Tree_Hierarchy_Result objSecurity = arr[i];
                string[] str = objSecurity.Right_Codes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                string[] strModuleRightCode = objSecurity.Module_Right_Codes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                if (objSecurity.ChildCount > 0 || objSecurity.RightsCount > 0)
                {
                    bool IsLocalReference = false;
                    string strLeastChild = "";
                    if (!IsChecked)
                        IsChecked = AddChildDetailForGroup(objSecurity.Module_Code, objSecurity.RightsCount, lstSecurity, IsView, out IsLocalReference, out strLeastChild, Security_Hiearachy_Search);
                    else
                        AddChildDetailForGroup(objSecurity.Module_Code, objSecurity.RightsCount, lstSecurity, IsView, out IsLocalReference, out strLeastChild, Security_Hiearachy_Search);
                    for (int j = 0; j < strModuleRightCode.Length; j++)
                    {
                        if (strModuleRightCode[j] != " ")
                        {
                            for (int k = 0; k < str.Length; k++)
                            {
                                if (str[k] != " ")
                                {
                                    if (SecurityCodes_Selected.Contains(strModuleRightCode[j]))
                                    {
                                        strLeastChild += "{title: '" + str[j] + "',key: '" + strModuleRightCode[j] + "',selected : true, preselected : true},";
                                    }
                                    else
                                    {
                                        strLeastChild += "{title: '" + str[j] + "',key: '" + strModuleRightCode[j] + "'},";
                                    }
                                    break;
                                }
                            }
                        }
                    }




                    strLeastChild = strLeastChild.TrimEnd(',');
                    strLocalChild += ", key: '0', children: [ " + strLeastChild + " ]";



                    if (IsLocalReference)
                    {
                        IsReference = true;
                        strLocalChild += ", unselectable: true";
                        strLocalChild += ", tooltip: 'Reference found'";
                        //if (Reference_From == "H")
                        //    strLocalChild += ", tooltip: 'Holdback is already added for the platform'";
                        //else
                        //    strLocalChild += ", tooltip: 'Platform is already syndicated'";
                    }

                }
                else
                {
                    strLocalChild += ", key: '" + objSecurity.Module_Code + "'";

                    //if (SecurityCodes_Selected != null)
                    //    if (SecurityCodes_Selected.Where(x => x == Convert.ToString(str)).Count() > 0)
                    //    {
                    //        IsChecked = true;
                    //        count++;
                    //    }

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

                    if (referenceIn.Count > 0)
                    {
                        IsReference = true;
                        strLocalChild += ", unselectable: true";
                        strLocalChild += ", tooltip: '" + string.Join(",", referenceIn) + " is already added for the Security'";
                    }

                }


                //strLocalChild += "]";
                //if (SecurityCodes_Selected != null)
                //    for (int j = 0; j < strModuleRightCode.Length; j++)
                //    {
                //        if (SecurityCodes_Selected.Contains(strModuleRightCode[j]))
                //        {
                //            strLocalChild += ", selected: true";
                //        }
                //    }


                if (IsView == "Y")
                {
                    strLocalChild += ", hideCheckbox: false";

                }
                if (Security_Hiearachy_Search.Trim() != "")
                    strLocalChild += ", expanded: true";
                else
                    strLocalChild += ", expanded: false";


                strChild += (i > 0 ? "," : "") + " { title: '" + objSecurity.Module_Name + "' " + strLocalChild + ",folder: true }";
                //strChild += (i > 0 ? "," : "") + " { title: '" + objSecurity.Module_Name + "' " + (objSecurity.ChildCount > 0 ? ", folder: true " : "") + strLocalChild + " }";
                // strChild += ", key: '0', children: [ " + strLeastChild + " ]";



            }

            return IsChecked;
        }

    }
}
