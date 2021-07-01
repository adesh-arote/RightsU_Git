using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RightsU_BLL;
using RightsU_Entities;

namespace RightsU_WebApp.UserControl
{
    public partial class UC_Platform_Tree_Selected : System.Web.UI.UserControl
    {
        #region ------------Properties------------
        public LoginEntity objLoginEntity
        {
            get
            {
                if (Session[RightsU_Session.CurrentLoginEntity] == null)
                    Session[RightsU_Session.CurrentLoginEntity] = new LoginEntity();
                return (LoginEntity)Session[RightsU_Session.CurrentLoginEntity];
            }
            set { Session[RightsU_Session.CurrentLoginEntity] = value; }
        }
        private string _TREEVIEWID;
        public string TREEVIEWID
        {
            get { return this._TREEVIEWID; }
            set { this._TREEVIEWID = value; }
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

        public string PlatformCodes_Selected_Out
        {
            get { return GetSelectedPlatforms(trView.Nodes); }
        }
        private string _Reference_From = "H";
        public string Reference_From
        {
            get { return _Reference_From; }
            set { _Reference_From = value; }
        }

        private string _TV_Id = "trView";
        public string TV_Id
        {
            get { return _TV_Id; }
            set { _TV_Id = value; }
        }
        //GetSelectedPlatforms

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            trView.ID = TV_Id;
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "SetHiddenField1", "SetHiddenField1('" + TREEVIEWID + "');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alertKey1", "callOnPageLoad1();", true);
        }

        public void PopulateTreeNode(string IsView, string Platform_Hiearachy_Search = "")
        {
            USP_Service objUS = new USP_Service(objLoginEntity.ConnectionStringName);
            List<USP_Get_Platform_Tree_Hierarchy_Result> lstPlatforms = objUS.USP_Get_Platform_Tree_Hierarchy(PlatformCodes_Display, Platform_Hiearachy_Search).ToList();

            trView.Nodes.Clear();
            trView.ShowLines = true;
            trView.NodeWrap = false;

            TreeNode trMenuNode = new TreeNode();
            trMenuNode.SelectAction = TreeNodeSelectAction.None;

            trView.Nodes.Add(trMenuNode);


            trMenuNode.Text = "Platform / Rights";
            if (PlatformCodes_Display == "")
                trMenuNode.ExpandAll();
            else
                trMenuNode.Expand();


            List<USP_Get_Platform_Tree_Hierarchy_Result> arr = lstPlatforms.Where(x => x.Parent_Platform_Code == 0).ToList();

            bool IsMenuReference = false;
            for (int i = 0; i < arr.Count; i++)
            {
                TreeNode trNode = new TreeNode();
                USP_Get_Platform_Tree_Hierarchy_Result objPlatform = arr[i];
                trNode.Text = objPlatform.Platform_Name;
                trNode.Value = objPlatform.Platform_Code.ToString();
                trNode.NavigateUrl = "#";
                trNode.SelectAction = TreeNodeSelectAction.None;

                bool IsReference = false;
                //if (lstPlatforms.Where(x => x.Parent_Platform_Code == objPlatform.Platform_Code && x.Is_Last_Level == "N").Count() > 0)
                if (objPlatform.ChildCount > 0)
                    trNode.Checked = AddChildDetailForGroup(trNode, objPlatform.Platform_Code, lstPlatforms, IsView, out IsReference, Platform_Hiearachy_Search);

                if (trNode.Checked != true)
                {
                    if (PlatformCodes_Selected != null)
                        if (PlatformCodes_Selected.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                            trNode.Checked = true;
                }
                if (trNode.Checked)
                {
                    trMenuNode.Checked = true;
                    if (IsReference)
                    {
                        IsMenuReference = true;
                        trNode.ShowCheckBox = false;
                        if (Reference_From == "H")
                            trNode.ToolTip = "Holdback is already added for the platform";
                        else
                            trNode.ToolTip = "Platform is already syndicated";

                        trNode.Text = "<input type='checkbox' disabled='disabled' checked='checked'><fontcolor='GRAY'>" + trNode.Text + "</font></input>";
                    }
                    else
                    {
                        if (PlatformCodes_Reference != null)
                            if (PlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                            {
                                trNode.ShowCheckBox = false;
                                if (Reference_From == "H")
                                    trNode.ToolTip = "Holdback is already added for the platform";
                                else
                                    trNode.ToolTip = "Platform is already syndicated";
                                trNode.Text = "<input type='checkbox' disabled='disabled' checked='checked'><fontcolor='GRAY'>" + trNode.Text + "</font></input>";
                            }

                    }
                    //if (IsHoldbackPltform == "Y" || IsView == "Y") { }
                    //else
                    //{
                    //    if (HB_AddedPlatform != null)
                    //        if (Array.IndexOf(HB_AddedPlatform, objPlatform.Platform_Code.ToString()) >= 0)
                    //        {
                    //            trNode.ShowCheckBox = false;
                    //            trNode.ToolTip = "Holdback is already added for the platform";
                    //            trNode.Text = "<input type='checkbox' disabled='disabled' checked='checked'><fontcolor='GRAY'>" + trNode.Text + "</font></input>";
                    //        }
                    //}
                }
                else
                {
                    if (Platform_Hiearachy_Search.Trim() != "")
                        trNode.ExpandAll();
                    else
                        trNode.CollapseAll();
                }

                trNode.SelectAction = TreeNodeSelectAction.None;
                trNode.ToolTip = "";
                if (IsView == "Y")
                {
                    trMenuNode.ShowCheckBox = false;
                    trNode.ShowCheckBox = false;
                }

                trMenuNode.ChildNodes.Add(trNode);
            }
            if (IsMenuReference)
            {
                trMenuNode.ShowCheckBox = false;
                if (Reference_From == "H")
                    trMenuNode.ToolTip = "Holdback is already added for the platform";
                else
                    trMenuNode.ToolTip = "Platform is already syndicated";
                trMenuNode.Text = "<input type='checkbox' disabled='disabled' checked='checked'><fontcolor='GRAY'>" + trMenuNode.Text + "</font></input>";
            }
        }

        private bool AddChildDetailForGroup(TreeNode trNode, int Platform_Code, List<USP_Get_Platform_Tree_Hierarchy_Result> lstPlatforms, string IsView, out bool IsReference, string Platform_Hiearachy_Search = "")
        {
            List<USP_Get_Platform_Tree_Hierarchy_Result> arr = lstPlatforms.Where(x => x.Parent_Platform_Code == Platform_Code).ToList();
            bool IsChecked = false;
            IsReference = false;

            for (int i = 0; i < arr.Count; i++)
            {
                TreeNode trChildNode = new TreeNode();
                USP_Get_Platform_Tree_Hierarchy_Result objPlatform = arr[i];
                trChildNode.Text = objPlatform.Platform_Name;
                trChildNode.Value = objPlatform.Platform_Code.ToString();
                trChildNode.NavigateUrl = "#";
                trChildNode.SelectAction = TreeNodeSelectAction.None;

                if (objPlatform.ChildCount > 0)
                {
                    bool IsLocalReference = false;
                    trChildNode.Checked = AddChildDetailForGroup(trChildNode, objPlatform.Platform_Code, lstPlatforms, IsView, out IsLocalReference, Platform_Hiearachy_Search);

                    if (IsLocalReference)
                    {
                        IsReference = true;
                        trChildNode.ShowCheckBox = false;
                        if (Reference_From == "H")
                            trChildNode.ToolTip = "Holdback is already added for the platform";
                        else
                            trChildNode.ToolTip = "Platform is already syndicated";
                        trChildNode.Text = "<input type='checkbox' disabled='disabled' checked='checked'><fontcolor='GRAY'>" + trChildNode.Text + "</font></input>";
                    }
                }
                else
                {
                    if (PlatformCodes_Selected != null)
                        if (PlatformCodes_Selected.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                            trChildNode.Checked = true;

                    if (PlatformCodes_Reference != null)
                        if (PlatformCodes_Reference.Where(x => x == Convert.ToString(objPlatform.Platform_Code)).Count() > 0)
                        {
                            IsReference = true;
                            trChildNode.ShowCheckBox = false;
                            if (Reference_From == "H")
                                trChildNode.ToolTip = "Holdback is already added for the platform";
                            else
                                trChildNode.ToolTip = "Platform is already syndicated";
                            trChildNode.Text = "<input type='checkbox' disabled='disabled' checked='checked'><fontcolor='GRAY'>" + trChildNode.Text + "</font></input>";
                        }
                }

                if (trChildNode.Checked)
                    IsChecked = true;

                if (IsView == "Y")
                    trChildNode.ShowCheckBox = false;
                if (Platform_Hiearachy_Search.Trim() != "")
                    trChildNode.ExpandAll();
                trNode.ChildNodes.Add(trChildNode);
            }
            return IsChecked;
        }

        public string GetSelectedPlatforms(TreeNodeCollection trNodes)
        {
            string strPlatforms = "";
            foreach (TreeNode tn in trNodes)
            {
                if (tn.Checked)
                {
                    if (tn.ChildNodes.Count > 0)
                        strPlatforms += GetSelectedPlatforms(tn.ChildNodes) + ",";
                    else
                        strPlatforms += tn.Value + ",";
                }
            }
            if (strPlatforms.EndsWith(","))
                strPlatforms = strPlatforms.Substring(0, strPlatforms.Length - 1);

            return strPlatforms;
        }

        //public ArrayList getPltformArray(string IsHoldbackPltform)
        //{
        //    ArrayList arrSecRelation = new ArrayList();

        //    if (DealLevel == "GlobalParams.Syn_Deal_Rights" && IsHoldbackPltform == "Y")
        //        PlatformCodesHB = "";

        //    TreeNodeCollection tn = trView.Nodes;
        //    for (int i = 0; i < tn.Count; i++)
        //    {
        //        if (tn[i].Checked)
        //        {
        //            if (tn[i].ChildNodes.Count > 0)
        //                FillArrayList(tn[i], arrSecRelation, IsHoldbackPltform);
        //        }
        //    }

        //    return arrSecRelation;
        //}
        //private void FillArrayList(TreeNode trNode, ArrayList arr, string IsHoldbackPltform)
        //{
        //    TreeNodeCollection tn = trNode.ChildNodes;
        //    for (int i = 0; i < tn.Count; i++)
        //    {
        //        if (tn[i].Checked)
        //        {
        //            if (tn[i].ChildNodes.Count > 0)
        //                FillArrayList(tn[i], arr, IsHoldbackPltform);
        //            else
        //            {
        //                string PlatFormCode = Convert.ToString(tn[i].Value);

        //                if (IsHoldbackPltform == "Y")
        //                {
        //                    PlatformCodesHB = PlatformCodesHB + "~" + PlatFormCode;
        //                }
        //                else
        //                {
        //                    PlatformCodes = PlatformCodes + "~" + PlatFormCode;
        //                }
        //            }
        //        }
        //    }
        //    if (IsHoldbackPltform == "Y")
        //    {
        //        PlatformCodesHB = PlatformCodesHB.Trim('~');
        //    }
        //    else
        //    {
        //        PlatformCodes = PlatformCodes.Trim('~');
        //    }
        //}

        //public void PopulateTreeNode(string IsHoldbackPltform, int rowIndex, string IsView, ArrayList arrDealMovieRightHolback_Wrapper)
        //{
        //    string strSelectedPtTemp = string.Empty;
        //    string strPltformFilter = string.Empty;
        //    string strGetParent = string.Empty;
        //    string strParents = string.Empty;

        //    //if (IsHoldbackPltform == "Y")
        //    //{
        //    //    #region holdback tree
        //    //    string selectedhbplatforms = "";
        //    //    string selectedvwholdbackplatforms = "";

        //    //    int cnt = 0;
        //    //    if (DealLevel == "GlobalParams.Acq_Deal_Rights" || DealLevel == "GlobalParams.Acq_Deal_Rights" + "_VW")
        //    //    {
        //    //        foreach (DealMovieRightHolback_Wrapper objHBWrapper in arrDealMovieRightHolback_Wrapper)
        //    //        {
        //    //            if (cnt != rowIndex)
        //    //            {
        //    //                if (IsView != "V")
        //    //                    selectedhbplatforms += objHBWrapper.PlatformCodes;
        //    //            }
        //    //            else selectedvwholdbackplatforms += objHBWrapper.PlatformCodes;
        //    //            cnt++;
        //    //        }
        //    //    }
        //    //    else
        //    //    {
        //    //        foreach (SynDealMovieRightHolback_Wrapper objHBWrapper in arrDealMovieRightHolback_Wrapper)
        //    //        {
        //    //            //if (cnt != rowIndex)
        //    //            //{
        //    //            //    if (IsView != "V")
        //    //            //        selectedhbplatforms += objHBWrapper.PlatformCodes;
        //    //            //}
        //    //            //else selectedvwholdbackplatforms += objHBWrapper.PlatformCodes;                    
        //    //            //cnt++;
        //    //            if (cnt == rowIndex)
        //    //                selectedvwholdbackplatforms += objHBWrapper.PlatformCodes;
        //    //            cnt++;
        //    //        }
        //    //    }

        //    //    if (selectedhbplatforms == string.Empty) selectedhbplatforms = "0";
        //    //    else selectedhbplatforms += "0";

        //    //    if (selectedvwholdbackplatforms == string.Empty) selectedvwholdbackplatforms = "0";
        //    //    else selectedvwholdbackplatforms += "0";

        //    //    string strSelectedPlatforms = PlatformCodes.Replace("~", ",").Trim('~').Trim(',');
        //    //    string searchStrForRelease = " applicable_for_holdback = 'N' and"; // This condition is for HB TYpe Release

        //    //    HBType_Release_Date = (HBType_Release_Date.Trim().ToUpper() == "DATE" || HBType_Release_Date.ToUpper() == "D") ? "D" : "R";
        //    //    if (HBType_Release_Date.ToUpper() == "D") searchStrForRelease = "";

        //    //    if (IsView == "V")
        //    //    {
        //    //        strPltformFilter = " and (platform_code in (select base_platform_code from platform where platform_code in (" + strSelectedPlatforms + ") "
        //    //            + " and platform_code not in (" + selectedhbplatforms + ")  and platform_code  in (" + selectedvwholdbackplatforms + ")  ) "
        //    //            + " OR  ( " + searchStrForRelease + " Is_Last_Level='Y' and platform_code in (" + selectedvwholdbackplatforms + ") ))"
        //    //            + " and ISNULL(parent_platform_code,0) <= 0 ";
        //    //    }
        //    //    else
        //    //    {
        //    //        strPltformFilter = " and (platform_code in (select base_platform_code from platform where platform_code in (" + strSelectedPlatforms + ") "
        //    //                                  + " and platform_code not in (" + selectedhbplatforms + ") ) "
        //    //                                  + " OR  ( " + searchStrForRelease + " Is_Last_Level='Y' "
        //    //                                  + " and platform_code in (" + ((DealLevel == "GlobalParams.Syn_Deal_Rights" || DealLevel == "GlobalParams.Syn_Deal_Rights" + "_VW")
        //    //                                  ? AcquisitionPlatformCodes : strSelectedPlatforms) + ") "
        //    //                                  + " and platform_code in (" + strSelectedPlatforms + ")"
        //    //                                  + " and platform_code not in (" + selectedhbplatforms + ")  )) "
        //    //                                  + " and ISNULL(parent_platform_code,0) <= 0 ";
        //    //    }

        //    //    string strSelectedPt = PlatformCodes.Replace("~", ",").Trim(',');

        //    //    if (IsView == "V")
        //    //    {
        //    //        if (DealLevel == "GlobalParams.Syn_Deal_Rights")
        //    //            strSelectedPt = selectedvwholdbackplatforms.Replace('~', ',').ToString();
        //    //        else
        //    //            strSelectedPt = PlatformCodesHB.Replace('~', ',').ToString();
        //    //    }


        //    //    if (IsView == "V")
        //    //    {
        //    //        // strGetParent = " SELECT stuff(( SELECT DISTINCT '~' + cast(  parent_platform_code as varchar(max)) "
        //    //        //+ " FROM PLATFORM WHERE platform_code in (" + strSelectedPt + ") and platform_code not in (" + selectedhbplatforms + ") and platform_code  in (" + selectedvwholdbackplatforms + ")  FOR XML PATH('')), 1, 1, '') as parent_platform_code; ";
        //    //        strGetParent = " SELECT dbo.fn_getParentPlatform_Recursive('" + selectedvwholdbackplatforms + "','','') ";
        //    //    }
        //    //    else
        //    //    {
        //    //        // strGetParent = " SELECT stuff(( SELECT DISTINCT '~' + cast(  parent_platform_code as varchar(max)) "
        //    //        //+ " FROM PLATFORM WHERE platform_code in (" + strSelectedPt + ") and platform_code not in (" + selectedhbplatforms + ")  FOR XML PATH('')), 1, 1, '') as parent_platform_code; ";
        //    //        strGetParent = " SELECT dbo.fn_getParentPlatform_Recursive('" + strSelectedPt + "','','" + selectedhbplatforms + "') ";

        //    //    }
        //    //    strParents = DatabaseBroker.ProcessScalarReturnString(strGetParent);


        //    //    var arrMainPlatform = strSelectedPt.Split(',');
        //    //    var arrSelectedHB = selectedhbplatforms.Split(',');
        //    //    var listUnSelected = arrMainPlatform.Except(arrSelectedHB);

        //    //    string strUnCommonPlatform = "0";
        //    //    if (DealLevel == "GlobalParams.Syn_Deal_Rights" + "_VW")
        //    //    {
        //    //        foreach (var item in listUnSelected)
        //    //        {
        //    //            if (item != "")
        //    //                strUnCommonPlatform += "~" + item;
        //    //        }
        //    //    }
        //    //    else
        //    //    {
        //    //        foreach (var item in arrMainPlatform)
        //    //        {
        //    //            if (item != "")
        //    //                strUnCommonPlatform += "~" + item;
        //    //        }
        //    //    }

        //    //    strSelectedPtTemp = "~" + strUnCommonPlatform + "~" + strParents + "~";
        //    //    #endregion
        //    //}
        //    //else
        //    //{
        //    strPltformFilter = " and ISNULL(parent_platform_code,0) <= 0 ";

        //    if (DealLevel == "GlobalParams.Syn_Deal_Rights" || DealLevel == "GlobalParams.Syn_Deal_Rights_RHB")
        //    {
        //        strPltformFilter += " and platform_code in (" + AcquisitionPlatformCodes + ")";
        //    }

        //    //if (DealLevel.Contains("_VW"))
        //    //{
        //    //    strGetParent = " SELECT dbo.fn_getParentPlatform_Recursive('" + PlatformCodes + "','','') ";
        //    //    strParents = DatabaseBroker.ProcessScalarReturnString(strGetParent);


        //    //    if (DealLevel == "GlobalParams.Syn_Deal_Rights" + "_VW")
        //    //    {
        //    //        strPltformFilter += " and platform_code in (" + PlatformCodes + strParents.Replace('~', ',').TrimEnd(',') + ")";
        //    //    }
        //    //    else
        //    //        strPltformFilter += " and platform_code in (" + strParents.Replace('~', ',').TrimEnd(',') + ")";

        //    //    strPltformFilter = strPltformFilter.Replace("(,", "(");
        //    //    strSelectedPtTemp = "~" + PlatformCodes.Replace(",", "~") + "~" + strParents + "~";
        //    //}
        //    //}

        //    //Criteria objCri = new Criteria(new Platform());
        //    //ArrayList arr = objCri.Execute(strPltformFilter);

        //    //List<RightsU_Entities.Platform> arr = db.Platforms.Where(x => x.Base_Platform_Code == null && x.Is_Active == "Y").ToList();

        //    List<RightsU_Entities.Platform> arr = db.Platforms.Where(x => x.Base_Platform_Code == null && x.Is_Active == "Y").ToList();

        //    trView.Nodes.Clear();
        //    trView.ShowLines = true;
        //    trView.NodeWrap = false;

        //    TreeNode trMenuNode = new TreeNode();
        //    trMenuNode.SelectAction = TreeNodeSelectAction.None;

        //    trView.Nodes.Add(trMenuNode);


        //    trMenuNode.Text = "Platform / Rights";
        //    if (PlatformCodes == "")
        //        trMenuNode.ExpandAll();
        //    else
        //        trMenuNode.Expand();


        //    for (int i = 0; i < arr.Count; i++)
        //    {
        //        TreeNode trNode = new TreeNode();
        //        Platform objPlatform = (Platform)arr[i];
        //        trNode.Text = objPlatform.Platform_Name;
        //        trNode.Value = objPlatform.Platform_Code.ToString();
        //        trNode.NavigateUrl = "#";
        //        trNode.Checked = AddChildDetailForGroup(trNode, objPlatform.Platform_Code, 2, IsHoldbackPltform, strSelectedPtTemp, rowIndex, IsView, arrDealMovieRightHolback_Wrapper);

        //        if (trNode.Checked != true)
        //        {
        //            string[] comparison = PlatformCodes.ToString().Split(',');

        //            foreach (String str in comparison)
        //            {
        //                if (str == objPlatform.Platform_Code.ToString())
        //                {
        //                    if (objPlatform.Parent_Platform_Code == 0 && objPlatform.Is_Last_Level == "Y")
        //                    {
        //                        trNode.Checked = true;
        //                    }
        //                }
        //            }
        //        }
        //        if (trNode.Checked)
        //        {
        //            trMenuNode.Checked = true;
        //            if (IsHoldbackPltform == "Y" || IsView == "V") { }
        //            else
        //            {
        //                if (HB_AddedPlatform != null)
        //                    if (Array.IndexOf(HB_AddedPlatform, objPlatform.Platform_Code.ToString()) >= 0)
        //                    {
        //                        trNode.ShowCheckBox = false;
        //                        trNode.ToolTip = "Holdback is already added for the platform";
        //                        trNode.Text = "<input type='checkbox' disabled='disabled' checked='checked'><fontcolor='GRAY'>" + trNode.Text + "</font></input>";
        //                    }
        //            }
        //        }
        //        else
        //        {
        //            trNode.CollapseAll();
        //        }

        //        trNode.SelectAction = TreeNodeSelectAction.None;
        //        trNode.ToolTip = "";
        //        if (IsView == "V")
        //        {
        //            trMenuNode.ShowCheckBox = false;
        //            trNode.ShowCheckBox = false;
        //        }

        //        trMenuNode.ChildNodes.Add(trNode);
        //    }
        //    if (IsHoldbackPltform == "N" && (DealLevel == "GlobalParams.Syn_Deal_Rights")) CheckifAllReference(trMenuNode);
        //    if (DealLevel.Contains("_VW"))
        //    {
        //        trView.ShowCheckBoxes = TreeNodeTypes.None;
        //        trMenuNode.ShowCheckBox = false;
        //    }
        //}

        //private bool AddChildDetailForGroup(TreeNode trNode, int ParentPlatformCode, int length, string IsHoldbackPltform, string strSelectedPtTemp, int rowIndex, string IsView, ArrayList arrDealMovieRightHolback_Wrapper)
        //{
        //    //Criteria objCri = new Criteria(new Platform());

        //    string selectedhbplatforms = "";
        //    string selectedvwholdbackplatforms = "";
        //    //if (IsHoldbackPltform == "Y")
        //    //{
        //    //    int cnt = 0;
        //    //    if (DealLevel == "GlobalParams.Acq_Deal_Rights" || DealLevel == "GlobalParams.Acq_Deal_Rights" + "_VW")
        //    //    {
        //    //        foreach (DealMovieRightHolback_Wrapper objHBWrapper in arrDealMovieRightHolback_Wrapper)
        //    //        {
        //    //            if (cnt != rowIndex)
        //    //                selectedhbplatforms += objHBWrapper.PlatformCodes;

        //    //            selectedvwholdbackplatforms += objHBWrapper.PlatformCodes;
        //    //            cnt++;
        //    //        }
        //    //    }
        //    //    else if (IsView == "V") //if(IsView == "V") //if (DealLevel == "GlobalParams.Syn_Deal_Rights" + "_VW")
        //    //    {
        //    //        foreach (SynDealMovieRightHolback_Wrapper objHBWrapper in arrDealMovieRightHolback_Wrapper)
        //    //        {  

        //    //            if (cnt == rowIndex)
        //    //                selectedvwholdbackplatforms += objHBWrapper.PlatformCodes;

        //    //            cnt++;
        //    //        }
        //    //    }
        //    //}
        //    selectedhbplatforms += "0";
        //    selectedvwholdbackplatforms += "0";


        //    //if (DealLevel == "GlobalParams.Acq_Deal_Rights" || DealLevel == "GlobalParams.Acq_Deal_Rights" + "_VW")
        //    //{
        //    //    arr = objCri.Execute(" and parent_platform_code = " + ParentPlatformCode + " and platform_code not in (" + selectedhbplatforms + ") and IS_ACTIVE='Y' ");
        //    //}
        //    //else if (DealLevel == "GlobalParams.Syn_Deal_Rights" + "_VW")
        //    //{
        //    //    arr = objCri.Execute(" and parent_platform_code = " + ParentPlatformCode + " and platform_code not in (" + selectedhbplatforms + ")  and platform_code in (" + strSelectedPtTemp.TrimStart('~').TrimEnd('~').Replace("~~", "~").Replace('~', ',') + ") and IS_ACTIVE='Y' ");
        //    //}
        //    //else 
        //    //arr = objCri.Execute(" and parent_platform_code = " + ParentPlatformCode + " and platform_code not in (" + selectedhbplatforms + ")  and platform_code in (" + AcquisitionPlatformCodes + ") and IS_ACTIVE='Y' ");
        //    List<Platform> arr = db.Platforms.Where(x => x.Parent_Platform_Code == ParentPlatformCode).ToList();

        //    string isLastLevelOnly = "N";
        //    if (arr.Count == 0)
        //    {
        //        //arr = objCri.Execute(" and platform_code = " + ParentPlatformCode + " and platform_code not in (" + selectedhbplatforms + ") and IS_ACTIVE='Y' and Is_Last_Level='Y' ");
        //        arr = db.Platforms.Where(x => x.Platform_Code == ParentPlatformCode && x.Is_Active == "Y" && x.Is_Last_Level == "Y").ToList();
        //        isLastLevelOnly = (arr.Count == 0) ? "N" : "Y";
        //    }


        //    bool IsCheck = false;
        //    string strTemp = IsHoldbackPltform;

        //    if (IsHoldbackPltform == "Y" || IsView == "V")
        //    {
        //        #region holdback tree
        //        foreach (Platform objPlatform in arr)
        //        {
        //            if (strSelectedPtTemp.Contains("~" + Convert.ToString(objPlatform.Platform_Code) + "~"))
        //            {
        //                if (isLastLevelOnly == "Y")
        //                {
        //                    if (objPlatform.Is_Last_Level == "Y")
        //                        IsCheck = GeneratedTableModuleandRights(trNode, objPlatform.Platform_Code, IsHoldbackPltform);
        //                }
        //                else
        //                {
        //                    TreeNode trModuleNode = new TreeNode();
        //                    trModuleNode.Text = objPlatform.Platform_Name;
        //                    trModuleNode.Value = objPlatform.Platform_Code.ToString();//""; //objSysModule.Platform_Code.ToString();
        //                    trModuleNode.NavigateUrl = "#";
        //                    trModuleNode.SelectAction = TreeNodeSelectAction.None;
        //                    trModuleNode.CollapseAll();
        //                    trModuleNode.ToolTip = "";

        //                    if (objPlatform.Is_Last_Level == "N")
        //                        trModuleNode.Checked = AddChildDetailForGroup(trModuleNode, objPlatform.Platform_Code, length + 1, strTemp, strSelectedPtTemp, rowIndex, IsView, arrDealMovieRightHolback_Wrapper);
        //                    else
        //                    {
        //                        trModuleNode.Checked = GeneratedTableModuleandRights(trModuleNode, objPlatform.Platform_Code, IsHoldbackPltform);
        //                    }

        //                    if (trModuleNode.Checked)
        //                    {
        //                        IsCheck = true;
        //                    }

        //                    if (IsView == "V")
        //                        trModuleNode.ShowCheckBox = false;
        //                    trNode.ChildNodes.Add(trModuleNode);
        //                }
        //            }
        //        }
        //        #endregion
        //    }
        //    else
        //    {

        //        foreach (Platform objPlatform in arr)
        //        {
        //            if (isLastLevelOnly == "Y")
        //            {
        //                if (objPlatform.Is_Last_Level == "Y")
        //                    IsCheck = GeneratedTableModuleandRights(trNode, objPlatform.Platform_Code, IsHoldbackPltform);
        //                trNode.Value = objPlatform.Platform_Code.ToString();
        //                trNode.Text = objPlatform.Platform_Name;
        //                if (DealLevel == "GlobalParams.Syn_Deal_Rights") ValidateRevenueRefrence(trNode, objPlatform.Platform_Code);
        //                if (trNode.Checked)
        //                {
        //                    if (HB_AddedPlatform != null)
        //                        if (Array.IndexOf(HB_AddedPlatform, objPlatform.Platform_Code.ToString()) >= 0)
        //                        {
        //                            trNode.ShowCheckBox = false;
        //                            trNode.ToolTip = "Holdback is already added for the platform";
        //                            trNode.Text = "<input type='checkbox' disabled='disabled' checked='checked'><fontcolor='GRAY'>" + trNode.Text + "</font></input>";
        //                        }
        //                }
        //            }
        //            else
        //            {
        //                TreeNode trModuleNode = new TreeNode();
        //                trModuleNode.Text = objPlatform.Platform_Name;
        //                trModuleNode.Value = objPlatform.Platform_Code.ToString();//""; //objSysModule.Platform_Code.ToString();
        //                trModuleNode.NavigateUrl = "#";
        //                trModuleNode.SelectAction = TreeNodeSelectAction.None;
        //                trModuleNode.CollapseAll();
        //                trModuleNode.ToolTip = "";

        //                if (objPlatform.Is_Last_Level == "N")
        //                    trModuleNode.Checked = AddChildDetailForGroup(trModuleNode, objPlatform.Platform_Code, length + 1, strTemp, strSelectedPtTemp, rowIndex, IsView, arrDealMovieRightHolback_Wrapper);
        //                else
        //                {
        //                    trModuleNode.Checked = GeneratedTableModuleandRights(trModuleNode, objPlatform.Platform_Code, IsHoldbackPltform);
        //                }
        //                if (trModuleNode.Checked)
        //                    IsCheck = true;

        //                if (DealLevel == "GlobalParams.Syn_Deal_Rights") ValidateRevenueRefrence(trModuleNode, objPlatform.Platform_Code);
        //                if (trModuleNode.Checked)
        //                {
        //                    if (HB_AddedPlatform != null)
        //                        if (Array.IndexOf(HB_AddedPlatform, objPlatform.Platform_Code.ToString()) >= 0)
        //                        {
        //                            trModuleNode.ShowCheckBox = false;
        //                            trModuleNode.ToolTip = "Holdback is already added for the platform";
        //                            trModuleNode.Text = "<input type='checkbox' disabled='disabled' checked='checked'><fontcolor='GRAY'>" + trModuleNode.Text + "</font></input>";
        //                        }
        //                }
        //                trNode.ChildNodes.Add(trModuleNode);
        //            }


        //        }


        //    }

        //    return IsCheck;
        //}

        //private void CheckifAllReference(TreeNode trMenuNode)
        //{
        //    foreach (TreeNode trChild in trMenuNode.ChildNodes)
        //    {
        //        if (trChild.ChildNodes.Count > 1) CheckifAllReference(trChild);
        //    }

        //    int CntDisabled = (from TreeNode trChild in trMenuNode.ChildNodes
        //                       where trChild.ShowCheckBox == false
        //                       select trChild).Count();

        //    if (CntDisabled == trMenuNode.ChildNodes.Count)
        //    {
        //        trMenuNode.ShowCheckBox = false;
        //        trMenuNode.ToolTip = "Revenue has reference of this platform";
        //        trMenuNode.Text = "<input type='checkbox' disabled='disabled' checked='checked'><fontcolor='GRAY'>" + trMenuNode.Text + "</font></input>";
        //    }

        //    if (CntDisabled > 0 && CntDisabled < trMenuNode.ChildNodes.Count)
        //    {
        //        //Temp color change to be changed later on
        //        trMenuNode.ShowCheckBox = false;
        //        trMenuNode.ToolTip = "Holdback / Revenue has reference of one of the children of this platform";
        //        //trMenuNode.Text = "<span style='color:red'>" + trMenuNode.Text + "</font></span>";
        //        trMenuNode.Text = "<input type='checkbox' disabled='disabled' checked='checked'><fontcolor='GRAY'>" + trMenuNode.Text + "</font></input>";
        //    }

        //}

        //private void ValidateRevenueRefrence(TreeNode trNode, int ptCode)
        //{
        //    var arrRevPlatCodes = RevenuePlatformCodes.Split(',');
        //    var arrPtCode = ptCode.ToString().Split(',');
        //    var arrRemainder = arrPtCode.Except(arrRevPlatCodes);
        //    int ReferencePlatformCnt = Convert.ToInt32((from string varPtCode in arrRemainder where varPtCode != "" select varPtCode).Count());
        //    if (ReferencePlatformCnt > 0) trNode.ShowCheckBox = true;
        //    else
        //    {
        //        trNode.ShowCheckBox = false;
        //        trNode.ToolTip = "Revenue has reference of this platform";
        //        trNode.Text = "<input type='checkbox' disabled='disabled' checked='checked'><fontcolor='GRAY'>" + trNode.Text + "</font></input>";
        //    }
        //}

        //private bool GeneratedTableModuleandRights(TreeNode trNode, int Platform_Code, string IsHoldbackPltform)
        //{
        //    bool IsCheck = false;
        //    string SelectedPlatforms = string.Empty;
        //    if (IsHoldbackPltform == "N")
        //    {
        //        SelectedPlatforms = "~" + PlatformCodes + "~";
        //    }
        //    else if (IsHoldbackPltform == "Y" && !isHBFooter)
        //    {
        //        if (DealLevel == "GlobalParams.Syn_Deal_Rights" && hdnEPlatform != null) SelectedPlatforms = "~" + hdnEPlatform.TrimStart(',').TrimEnd(',').Replace(',', '~') + "~";
        //        else SelectedPlatforms = "~" + PlatformCodesHB + "~";
        //    }
        //    else if (isHBFooter)
        //    {
        //        SelectedPlatforms = "~" + HB_Selected + "~";
        //    }

        //    if (SelectedPlatforms.Replace(",", "").Contains("~" + Convert.ToString(Platform_Code) + "~"))
        //    {
        //        IsCheck = true;
        //    }

        //    return IsCheck;
        //}

        //public ArrayList getPltformArray(string IsHoldbackPltform)
        //{
        //    ArrayList arrSecRelation = new ArrayList();

        //    if (DealLevel == "GlobalParams.Syn_Deal_Rights" && IsHoldbackPltform == "Y")
        //        PlatformCodesHB = "";

        //    TreeNodeCollection tn = trView.Nodes;
        //    for (int i = 0; i < tn.Count; i++)
        //    {
        //        if (tn[i].Checked)
        //        {
        //            if (tn[i].ChildNodes.Count > 0)
        //                FillArrayList(tn[i], arrSecRelation, IsHoldbackPltform);
        //        }
        //    }

        //    return arrSecRelation;
        //}

        //private void FillArrayList(TreeNode trNode, ArrayList arr, string IsHoldbackPltform)
        //{
        //    TreeNodeCollection tn = trNode.ChildNodes;
        //    for (int i = 0; i < tn.Count; i++)
        //    {
        //        if (tn[i].Checked)
        //        {
        //            if (tn[i].ChildNodes.Count > 0)
        //                FillArrayList(tn[i], arr, IsHoldbackPltform);
        //            else
        //            {
        //                string PlatFormCode = Convert.ToString(tn[i].Value);

        //                if (IsHoldbackPltform == "Y")
        //                {
        //                    PlatformCodesHB = PlatformCodesHB + "~" + PlatFormCode;
        //                }
        //                else
        //                {
        //                    PlatformCodes = PlatformCodes + "~" + PlatFormCode;
        //                }
        //            }
        //        }
        //    }
        //    if (IsHoldbackPltform == "Y")
        //    {
        //        PlatformCodesHB = PlatformCodesHB.Trim('~');
        //    }
        //    else
        //    {
        //        PlatformCodes = PlatformCodes.Trim('~');
        //    }
        //}

        //public int[] getArrPlatformCodeForSelectedMovies(int DealMoviesSelected, ArrayList arrSyndicationDealMovie)
        //{
        //    int[] arrPlatform = { };
        //    if (DealMoviesSelected > 0)
        //    {
        //        SyndicationDealMovie objDM = (SyndicationDealMovie)(from SyndicationDealMovie obj in arrSyndicationDealMovie where obj.TitleCode == DealMoviesSelected select obj).First();
        //        arrPlatform = (from SynDealMovieRights objSDMR in objDM.arrSynDealMovieRights
        //                       select objSDMR.PlatformCode).ToArray();
        //    }
        //    return arrPlatform;
        //}

    }
}