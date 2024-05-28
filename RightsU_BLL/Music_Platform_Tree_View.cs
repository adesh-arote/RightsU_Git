using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_BLL
{
   public class Music_Platform_Tree_View
    {
        public string _Connection_Str;
        public Music_Platform_Tree_View(string connectionstring)
        {
            _Connection_Str = connectionstring;
        }
        private string[] _MusicPlatformCodes_Selected;
        public string[] MusicPlatformCodes_Selected
        {
            get { return this._MusicPlatformCodes_Selected; }
            set { this._MusicPlatformCodes_Selected = value; }
        }

        private string _MusicPlatformCodes_Display;
        public string MusicPlatformCodes_Display
        {
            get { return this._MusicPlatformCodes_Display; }
            set { this._MusicPlatformCodes_Display = value; }
        }

        private string[] _MusicPlatformCodes_Reference;
        public string[] MusicPlatformCodes_Reference
        {
            get { return this._MusicPlatformCodes_Reference; }
            set { this._MusicPlatformCodes_Reference = value; }
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
        int count = 0;
        public string PopulateTreeNode(string IsView, string Music_Platform_Hiearachy_Search = "")
        {
            USP_Service objUS = new USP_Service(_Connection_Str);
            if (IsView == "Y" && Show_Selected == false)
            {
                Music_Platform_Hiearachy_Search = "";
                MusicPlatformCodes_Display = null;
            }
            List<USP_Get_Music_Platform_Tree_Hierarchy_Result> lstPlatforms = objUS.USP_Get_Music_Platform_Tree_Hierarchy(MusicPlatformCodes_Display, Music_Platform_Hiearachy_Search).ToList();

            string tvChildData = "";

            List<USP_Get_Music_Platform_Tree_Hierarchy_Result> arr = lstPlatforms.Where(x => x.Parent_Code == 0).ToList();

            bool IsMenuReference = false, IsMenuChecked = false;
            for (int i = 0; i < arr.Count; i++)
            {
                USP_Get_Music_Platform_Tree_Hierarchy_Result objMusicPlatform = arr[i];

                objMusicPlatform.Platform_Name = objMusicPlatform.Platform_Name.Replace("'", @"\'");

                string strChild = "";

                bool IsReference = false, IsChecked = false;
                if (objMusicPlatform.ChildCount > 0)
                {
                    string strLeastChild = "";
                    IsChecked = AddChildDetailForGroup(objMusicPlatform.Music_Platform_Code, lstPlatforms, IsView, out IsReference, out strLeastChild, Music_Platform_Hiearachy_Search);
                    strChild += ", key: '0', children: [ " + strLeastChild + " ]";
                }
                else
                    strChild += ", key: '" + objMusicPlatform.Music_Platform_Code + "'";
                if (IsChecked != true)
                {
                    if (MusicPlatformCodes_Selected != null)
                        if (MusicPlatformCodes_Selected.Contains(objMusicPlatform.Music_Platform_Code.ToString()))
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
                    }
                    else
                    {
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
                    if (Music_Platform_Hiearachy_Search.Trim() != "")
                        strChild += ", expanded: true";
                    else
                        strChild += ", expanded: false";
                }

                if (IsChecked && objMusicPlatform.ChildCount == 0)
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

                tvChildData += "{ title: '" + objMusicPlatform.Platform_Name + "' " + (objMusicPlatform.ChildCount > 0 ? ", folder: true" : "") + strChild + " } ";

            }

            string IsRef = "";
            if (IsView == "Y" && Show_Selected == false)
            {
                IsRef += ", unselectable: true";
                count = _MusicPlatformCodes_Selected.Count();
                if (_MusicPlatformCodes_Selected.Contains("0"))
                    count -= 1;
            }
            else if (IsView == "Y" && Show_Selected == true)
            {
                IsRef += ", hideCheckbox: true";
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

        private bool AddChildDetailForGroup(int Music_Platform_Code, List<USP_Get_Music_Platform_Tree_Hierarchy_Result> lstPlatforms, string IsView, out bool IsReference, out string strChild, string Music_Platform_Hiearachy_Search = "")
        {
            List<USP_Get_Music_Platform_Tree_Hierarchy_Result> arr = lstPlatforms.Where(x => x.Parent_Code == Music_Platform_Code).ToList();
            bool IsChecked = false;
            IsReference = false;

            strChild = "";

            for (int i = 0; i < arr.Count; i++)
            {

                string strLocalChild = "";
                USP_Get_Music_Platform_Tree_Hierarchy_Result objMusicPlatform = arr[i];

                if (objMusicPlatform.ChildCount > 0)
                {
                    bool IsLocalReference = false;
                    string strLeastChild = "";
                    if (!IsChecked)
                        IsChecked = AddChildDetailForGroup(objMusicPlatform.Music_Platform_Code, lstPlatforms, IsView, out IsLocalReference, out strLeastChild, Music_Platform_Hiearachy_Search);
                    else
                        AddChildDetailForGroup(objMusicPlatform.Music_Platform_Code, lstPlatforms, IsView, out IsLocalReference, out strLeastChild, Music_Platform_Hiearachy_Search);
                    strLocalChild += ", key: '0', children: [ " + strLeastChild + " ]";

                    if (IsLocalReference)
                    {
                        IsReference = true;
                        strLocalChild += ", unselectable: true";
                        strLocalChild += ", tooltip: 'Reference found'";
                    }

                }
                else
                {
                    strLocalChild += ", key: '" + objMusicPlatform.Music_Platform_Code + "'";
                    if (MusicPlatformCodes_Selected != null)
                        if (MusicPlatformCodes_Selected.Where(x => x == Convert.ToString(objMusicPlatform.Music_Platform_Code)).Count() > 0)
                        {
                            IsChecked = true;
                            count++;
                        }
                    List<string> referenceIn = new List<string>();
                    if (referenceIn.Count > 0)
                    {
                        IsReference = true;
                        strLocalChild += ", unselectable: true";
                        strLocalChild += ", tooltip: '" + string.Join(",", referenceIn) + " is already added for the platform'";
                    }

                }

                if (MusicPlatformCodes_Selected != null)
                    if (MusicPlatformCodes_Selected.Where(x => x == Convert.ToString(objMusicPlatform.Music_Platform_Code)).Count() > 0)
                        strLocalChild += ", selected: true, preselected : true";


                if (IsView == "Y" && Show_Selected == false)
                {
                    if (MusicPlatformCodes_Selected.Where(x => x == Convert.ToString(objMusicPlatform.Music_Platform_Code)).Count() > 0)
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
                    strLocalChild += ", hideCheckbox: true";
                }
                if (Music_Platform_Hiearachy_Search.Trim() != "")
                    strLocalChild += ", expanded: true";
                else
                    strLocalChild += ", expanded: false";

                strChild += (i > 0 ? "," : "") + " { title: '" + objMusicPlatform.Platform_Name + "' " + (objMusicPlatform.ChildCount > 0 ? ", folder: true " : "") + strLocalChild + " }";

            }
            return IsChecked;
        }
    }
}
