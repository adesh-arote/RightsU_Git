using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Syn_Rights_PromoterController : BaseController
    {
        #region --Session Declaration
        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.Syn_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.Syn_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.Syn_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.Syn_DEAL_SCHEMA] = value; }
        }
        public Syn_Deal_Rights objSyn_Deal_Rights
        {
            get
            {
                if (Session["SYN_DEAL_RIGHTS"] == null)
                    Session["SYN_DEAL_RIGHTS"] = new Syn_Deal_Rights();
                return (Syn_Deal_Rights)Session["SYN_DEAL_RIGHTS"];
            }
            set { Session["SYN_DEAL_RIGHTS"] = value; }
        }

        public Rights_Page_Properties objPage_Properties
        {
            get
            {
                if (Session["Rights_Page_Properties"] == null)
                    Session["Rights_Page_Properties"] = new Rights_Page_Properties();
                return (Rights_Page_Properties)Session["Rights_Page_Properties"];
            }
            set { Session["Rights_Page_Properties"] = value; }
        }
        #endregion
        //
        // GET: /Syn_Rights_Promoter/

        public ActionResult Index()
        {
            return View();
        }
        public PartialViewResult BindPromoter()
        {
            ViewBag.Promoter_Flag = objSyn_Deal_Rights.Promoter_Flag;
            if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_VIEW || objPage_Properties.RMODE == GlobalParams.DEAL_MODE_APPROVE)
                ViewBag.CommandName_PR = objPage_Properties.RMODE;
            else
                ViewBag.CommandName_PR = "LIST";
            List<Syn_Deal_Rights_Promoter> lst = objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.Where(t => t.EntityState != State.Deleted).ToList();
            lst.ToList().ForEach(
                Promoter =>
                {
                    var ParentPromoterCodes = Promoter.Syn_Deal_Rights_Promoter_Group.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Group_Code).ToList();
                    string PromoterCodestoGetChild = string.Join(",", ParentPromoterCodes.ToArray());
                    var PromoterCodes = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_ParentOrChild_Details_Promoter(PromoterCodestoGetChild, "C").ToList();
                    var count = PromoterCodes[0].ToString();
                    string[] PromoterCodesForCount = count.Split(',').ToList<string>().ToArray();
                    Promoter.TotalCount = PromoterCodesForCount.Count().ToString();
                });
            return PartialView("~/Views/Syn_Deal/_Syn_Rights_Promoter_List.cshtml", lst);
        }
        public PartialViewResult Add_Promoter()
        {
            ViewBag.Promoter_Group_Codes = "";
            Promoter_Group_Tree_View objPTV = new Promoter_Group_Tree_View(objLoginEntity.ConnectionStringName);
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            List<Syn_Deal_Rights_Promoter> lst = objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.Where(t => t.EntityState != State.Deleted).ToList();
            List<Promoter_Group> lstPromoterGroup = new Promoter_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Promoter_Group_Name).ToList();
            ViewBag.PromoterList = new MultiSelectList(lstPromoterGroup, "Promoter_Group_Code", "Promoter_Group_Name");

            List<Promoter_Remarks> lstPromoterRemarks = new Promoter_Remarks_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Promoter_Remark_Desc).ToList();
            ViewBag.RemarksList = new MultiSelectList(lstPromoterRemarks, "Promoter_Remarks_Code", "Promoter_Remark_Desc");
            ViewBag.CommandName_PR = "ADD";
            ViewBag.IsAddEditMode = "Y";
            return PartialView("~/Views/syn_Deal/_Syn_Rights_Promoter_List.cshtml", lst);
        }
        protected List<T> CompareLists<T>(List<T> FirstList, List<T> SecondList, IEqualityComparer<T> comparer, ref List<T> DelResult, ref List<T> UPResult) where T : class
        {
            var AddResult = FirstList.Except(SecondList, comparer);
            var DeleteResult = SecondList.Except(FirstList, comparer);
            var UpdateResult = FirstList.Except(DeleteResult, comparer);
            var Modified_Result = UpdateResult.Except(AddResult);

            DelResult = DeleteResult.ToList<T>();
            UPResult = Modified_Result.ToList<T>();

            return AddResult.ToList<T>();
        }
        public PartialViewResult Edit_Promoter(string DummyProperty)
        {
            List<Syn_Deal_Rights_Promoter> lst = objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.Where(t => t.EntityState != State.Deleted).ToList();
            List<Promoter_Group> lstPromoterGroup = new Promoter_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Promoter_Group_Name).ToList();

            List<Promoter_Remarks> lstPromoterRemarks = new Promoter_Remarks_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Promoter_Remark_Desc).ToList();

            ViewBag.CommandName_PR = GlobalParams.DEAL_MODE_EDIT;
            ViewBag.DummyProperty = DummyProperty;

            Syn_Deal_Rights_Promoter obj = objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.Where(w => w.strDummyProp == DummyProperty && w.EntityState != State.Deleted).FirstOrDefault();
            string Promoter_Group_Codes = string.Join(",", obj.Syn_Deal_Rights_Promoter_Group.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Group_Code));
            ViewBag.Promoter_Group_Codes = Promoter_Group_Codes;
            var PromterCodes = obj.Syn_Deal_Rights_Promoter_Group.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Group_Code).ToArray();
            ViewBag.PromoterList = new MultiSelectList(lstPromoterGroup, "Promoter_Group_Code", "Promoter_Group_Name", PromterCodes);

            var RemarksCodes = obj.Syn_Deal_Rights_Promoter_Remarks.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Remarks_Code).ToArray();
            ViewBag.RemarksList = new MultiSelectList(lstPromoterRemarks, "Promoter_Remarks_Code", "Promoter_Remark_Desc", RemarksCodes);
            return PartialView("~/Views/Syn_Deal/_Syn_Rights_Promoter_List.cshtml", lst);
        }
        public JsonResult Save_Promoter(string PromoterCode, string[] RemarkCode, string DummyProperty)
        {
            string[] PromoterGroups = PromoterCode.Split(',').ToList<string>().ToArray();
            string Message = "";
            ArrayList arrLPromoters = new ArrayList(PromoterGroups);
            string mode = string.Empty;
            foreach (var item in objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.Where(w => w.strDummyProp != DummyProperty && w.EntityState != State.Deleted))
            {
                Syn_Deal_Rights_Promoter objp = new Syn_Deal_Rights_Promoter();
                objp = item;
                var Promoters = objp.Syn_Deal_Rights_Promoter_Group.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Group_Code).ToList();
                var Remarks = objp.Syn_Deal_Rights_Promoter_Remarks.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Remarks_Code.ToString()).ToList();

                string ParentPromoters = string.Join(",", Promoters);
                var PromotersWithChild = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_ParentOrChild_Details_Promoter(ParentPromoters, "C").ToList();
                string PromotercodeTempToValidate = PromotersWithChild[0].ToString();
                List<int> PromoterCodesToValidate = PromotercodeTempToValidate.Split(',').Select(int.Parse).ToList();

                var countPromoter = PromoterGroups.Where(x => PromotercodeTempToValidate.Contains(x.ToString())).Count();
                var countRemark = RemarkCode.Where(x => Remarks.Contains(x.ToString())).Count();


                if (Convert.ToInt32(countPromoter) > 0 && Convert.ToInt32(countRemark) > 0)
                {
                    return Json(objMessageKey.DuplicateCombinationofPromoterandRemark);
                }
            }

            var PromoterCodeToAdd = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_ParentOrChild_Details_Promoter(PromoterCode, "P").ToList();
            string PromotercodeTemp = PromoterCodeToAdd[0].ToString();
            string[] PromoterCodesToAdd = PromotercodeTemp.Split(',').ToList<string>().ToArray();

            var PromotercodeForCount = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_ParentOrChild_Details_Promoter(PromoterCode, "C").ToList();
            string PromoterForCount = PromotercodeForCount[0].ToString();
            string[] PromoterCodesForCount = PromoterForCount.Split(',').ToList<string>().ToArray();
            objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.Where(w => w.strDummyProp == DummyProperty).Select(s => s.TotalCount = PromoterCodesForCount.Count().ToString()).FirstOrDefault();

            Syn_Deal_Rights_Promoter objSDRP = null;
            if (DummyProperty != "0" && DummyProperty != null)
            {
                mode = "u";
                objSDRP = objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.Where(w => w.strDummyProp == DummyProperty).FirstOrDefault();
                if (objSDRP.Syn_Deal_Rights_Promoter_Code > 0)
                    objSDRP.EntityState = State.Modified;

                objSDRP.Last_Updated_Time = System.DateTime.Now;
                objSDRP.Last_Action_By = objLoginUser.Users_Code;
            }
            else
            {
                mode = "A";
                objSDRP = new Syn_Deal_Rights_Promoter();
                objSDRP.EntityState = State.Added;
                objSDRP.Inserted_By = objLoginUser.Users_Code;
                objSDRP.Inserted_On = System.DateTime.Now;
                objSDRP.Last_Action_By = objLoginUser.Users_Code;
                objSDRP.Last_Updated_Time = System.DateTime.Now;
                objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.Add(objSDRP);
            }
            ICollection<Syn_Deal_Rights_Promoter_Group> PromoterList = new HashSet<Syn_Deal_Rights_Promoter_Group>();
            foreach (string PromotersCode in PromoterCodesToAdd)
            {
                if (PromotersCode != "0")
                {
                    Syn_Deal_Rights_Promoter_Group objTR = new Syn_Deal_Rights_Promoter_Group();
                    objTR.EntityState = State.Added;
                    objTR.Promoter_Group_Code = Convert.ToInt32(PromotersCode);
                    PromoterList.Add(objTR);
                }
            }

            IEqualityComparer<Syn_Deal_Rights_Promoter_Group> comparerPromoterGroup = new LambdaComparer<Syn_Deal_Rights_Promoter_Group>((x, y) => x.Promoter_Group_Code == y.Promoter_Group_Code && x.EntityState != State.Deleted);
            var Deleted_Promoter = new List<Syn_Deal_Rights_Promoter_Group>();
            var Updated_Promoter = new List<Syn_Deal_Rights_Promoter_Group>();
            var Added_Promoter = CompareLists<Syn_Deal_Rights_Promoter_Group>(PromoterList.ToList<Syn_Deal_Rights_Promoter_Group>(), objSDRP.Syn_Deal_Rights_Promoter_Group.ToList<Syn_Deal_Rights_Promoter_Group>(), comparerPromoterGroup, ref Deleted_Promoter, ref Updated_Promoter);
            Added_Promoter.ToList<Syn_Deal_Rights_Promoter_Group>().ForEach(t => objSDRP.Syn_Deal_Rights_Promoter_Group.Add(t));
            Deleted_Promoter.ToList<Syn_Deal_Rights_Promoter_Group>().ForEach(t => t.EntityState = State.Deleted);


            ICollection<Syn_Deal_Rights_Promoter_Remarks> RemarksList = new HashSet<Syn_Deal_Rights_Promoter_Remarks>();

            foreach (string RemarksCode in RemarkCode)
            {
                Syn_Deal_Rights_Promoter_Remarks objTR = new Syn_Deal_Rights_Promoter_Remarks();
                objTR.EntityState = State.Added;
                objTR.Promoter_Remarks_Code = Convert.ToInt32(RemarksCode);
                RemarksList.Add(objTR);
            }
            IEqualityComparer<Syn_Deal_Rights_Promoter_Remarks> comparePromoterRemarks = new LambdaComparer<Syn_Deal_Rights_Promoter_Remarks>((x, y) => x.Promoter_Remarks_Code == y.Promoter_Remarks_Code && x.EntityState != State.Deleted);
            var Deleted_Remarks = new List<Syn_Deal_Rights_Promoter_Remarks>();
            var Updated_Remarks = new List<Syn_Deal_Rights_Promoter_Remarks>();
            var Added_Remarks = CompareLists<Syn_Deal_Rights_Promoter_Remarks>(RemarksList.ToList<Syn_Deal_Rights_Promoter_Remarks>(), objSDRP.Syn_Deal_Rights_Promoter_Remarks.ToList<Syn_Deal_Rights_Promoter_Remarks>(), comparePromoterRemarks, ref Deleted_Remarks, ref Updated_Remarks);
            Added_Remarks.ToList<Syn_Deal_Rights_Promoter_Remarks>().ForEach(t => objSDRP.Syn_Deal_Rights_Promoter_Remarks.Add(t));
            Deleted_Remarks.ToList<Syn_Deal_Rights_Promoter_Remarks>().ForEach(t => t.EntityState = State.Deleted);



            var obj = new
            {
                message = "Success",
                mode = mode
            };
            return Json(obj);
        }
        public JsonResult Delete_Promoter(string DummyProperty)
        {
            objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.Where(w => w.strDummyProp == DummyProperty).Select(s => s.EntityState = State.Deleted).FirstOrDefault();

            var objs = new
            {
            };
            return Json(objs);
        }
        public JsonResult Save_Remarks(string Remark_Name)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            Promoter_Remarks_Service objService = new Promoter_Remarks_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Promoter_Remarks objPR = new RightsU_Entities.Promoter_Remarks();
            objPR.EntityState = State.Added;
            objPR.Inserted_On = DateTime.Now;
            objPR.Inserted_By = objLoginUser.Users_Code;
            objPR.Last_Updated_Time = DateTime.Now;
            objPR.Last_Action_By = objLoginUser.Users_Code;
            objPR.Is_Active = "Y";
            objPR.Promoter_Remark_Desc = Remark_Name;
            dynamic resultSet;
            bool isValid = objService.Save(objPR, out resultSet);
            if (!isValid)
            {
                status = "E";
                message = resultSet;
            }
            var obj = new
            {

                Status = status,
                Message = message,
                Value = objPR.Promoter_Remarks_Code,
                Text = objPR.Promoter_Remark_Desc
            };

            return Json(obj);
        }
        public PartialViewResult BindPromoterGroupTree(string PromoterGroupCode, string DummyProperty, string[] lbTitles, string[] lbTerritory,
            string[] lbSub_Language, string[] lbDub_Language, string Perpetuity_Date, string Start_Date, string End_Date, string hdnTVCodes,
            string Is_Title_Language_Right, string rdoTerritoryHB, string Term, string rdoSubGroup, string rdoDubGroup)
        {
            string strStart_Date = "", strEnd_Date = "";
            string strTitles = lbTitles == null ? "" : string.Join(",", lbTitles);
            string strTerritory = lbTerritory == null ? "" : string.Join(",", lbTerritory);
            string strSub_Language = lbSub_Language == null ? "" : string.Join(",", lbSub_Language);
            string strDub_Language = lbDub_Language == null ? "" : string.Join(",", lbDub_Language);
            if (rdoTerritoryHB == "Y")
                strTerritory += "T";
            strSub_Language = rdoSubGroup == "Y" ? strSub_Language + 'T' : strSub_Language;
            strDub_Language = rdoDubGroup == "Y" ? strDub_Language + 'T' : strDub_Language;
            if (Term == "Y")
            {
                if (Start_Date != "" && End_Date != "")
                {
                    DateTime strtDate = Convert.ToDateTime(Start_Date);
                    strStart_Date = strtDate.Month.ToString() + "/" + strtDate.Day.ToString() + "/" + strtDate.Year.ToString();
                    DateTime endDate = Convert.ToDateTime(End_Date);
                    strEnd_Date = endDate.Month.ToString() + "/" + endDate.Day.ToString() + "/" + endDate.Year.ToString();
                }
            }
            else if (Term == "P")
            {
                if (Perpetuity_Date != "")
                {
                    DateTime strtDate = Convert.ToDateTime(Perpetuity_Date);
                    strStart_Date = strtDate.Month.ToString() + "/" + strtDate.Day.ToString() + "/" + strtDate.Year.ToString();
                }
            }

            var Parent_Group_Codes = new Promoter_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Select(s => s.Parent_Group_Code).Distinct().ToList();
            Promoter_Group_Tree_View objPG = new Promoter_Group_Tree_View(objLoginEntity.ConnectionStringName);
            Syn_Deal_Rights_Promoter obj = objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.Where(w => w.strDummyProp == DummyProperty && w.EntityState != State.Deleted).FirstOrDefault();

            if (strTitles == "" || strTerritory == "T" || strTerritory == "" || hdnTVCodes == "")
            {
                ViewBag.TV_Platform = objPG.PopulateTreeNode("N", "", true);
                goto END_Label;
            }

            if (PromoterGroupCode == "")
            {
                if (obj != null)
                {
                    PromoterGroupCode = string.Join(",", obj.Syn_Deal_Rights_Promoter_Group.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Group_Code));
                    var PromotersWithChild = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_ParentOrChild_Details_Promoter(PromoterGroupCode, "C").ToList();
                    string PromotercodeTempToShow = PromotersWithChild[0].ToString();
                    List<int> PromoterCodesToValidate = PromotercodeTempToShow.Split(',').Select(int.Parse).ToList();

                    PromoterGroupCode = String.Join(",", PromoterCodesToValidate.ToArray());
                    objPG.Promoter_GroupCodes_Selected = PromoterGroupCode.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                    objPG.Show_Selected = true;
                    objPG.Promoter_GroupCodes_Display = PromoterGroupCode;
                    ViewBag.TV_Platform = objPG.PopulateTreeNode("Y");
                }
                else
                {
                    //ViewBag.TV_Platform = objPG.PopulateTreeNode("N");

                    PromoterGroupCode = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetPromoterCodes(strTitles, hdnTVCodes, strTerritory, strSub_Language,
                          strDub_Language, Is_Title_Language_Right, objDeal_Schema.Deal_Type_Code, Term, strStart_Date, strEnd_Date).FirstOrDefault();
                    //PromoterGroupCode = string.Join(",", obj.Syn_Deal_Rights_Promoter_Group.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Group_Code));
                    if (PromoterGroupCode != "")
                    {
                        var PromotersWithChild = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_ParentOrChild_Details_Promoter(PromoterGroupCode, "C").ToList();
                        string PromotercodeTempToShow = PromotersWithChild[0].ToString();
                        List<int> PromoterCodesToValidate = PromotercodeTempToShow.Split(',').Select(int.Parse).ToList();

                        PromoterGroupCode = String.Join(",", PromoterCodesToValidate.ToArray());
                        // objPG.Promoter_GroupCodes_Selected = PromoterGroupCode.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        objPG.Show_Selected = false;
                        objPG.Promoter_GroupCodes_Display = PromoterGroupCode;
                        ViewBag.TV_Platform = objPG.PopulateTreeNode("N");
                    }
                    else
                        ViewBag.TV_Platform = objPG.PopulateTreeNode("N", "", true);
                }
            }
            else
            {
                if (obj != null)
                {
                    string temp_PC = PromoterGroupCode;

                    var PromotersWithChild_temp = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_ParentOrChild_Details_Promoter(temp_PC, "C").ToList();
                    string PromotercodeTempToValidate_temp = PromotersWithChild_temp[0].ToString().Replace(" ", "");
                    List<int> PromoterCodesToValidate_temp = PromotercodeTempToValidate_temp.Split(',').Select(int.Parse).ToList();

                    PromoterGroupCode = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetPromoterCodes(strTitles, hdnTVCodes, strTerritory, strSub_Language,
                            strDub_Language, Is_Title_Language_Right, objDeal_Schema.Deal_Type_Code, Term, strStart_Date, strEnd_Date).FirstOrDefault();


                    if (PromoterGroupCode != "")
                    {
                        if (IsAlphabets((PromoterGroupCode.ElementAt(0)).ToString()))
                            PromoterGroupCode = "";

                        var PromotersWithChild = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_ParentOrChild_Details_Promoter(PromoterGroupCode, "C").ToList();
                        string PromotercodeTempToValidate = PromotersWithChild[0].ToString();
                        List<int> PromoterCodesToValidate = PromotercodeTempToValidate.Split(',').Select(int.Parse).ToList();


                        PromoterGroupCode = String.Join(",", PromoterCodesToValidate.ToArray());
                        objPG.Promoter_GroupCodes_Selected = PromotercodeTempToValidate_temp.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        objPG.Promoter_GroupCodes_Display = PromoterGroupCode;
                        ViewBag.TV_Platform = objPG.PopulateTreeNode("N");
                    }
                    else
                        ViewBag.TV_Platform = objPG.PopulateTreeNode("Y", "", true);
                }
                else
                {
                    PromoterGroupCode = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetPromoterCodes(strTitles, hdnTVCodes, strTerritory, strSub_Language,
                       strDub_Language, Is_Title_Language_Right, objDeal_Schema.Deal_Type_Code, Term, strStart_Date, strEnd_Date).FirstOrDefault();
                    //PromoterGroupCode = string.Join(",", obj.Syn_Deal_Rights_Promoter_Group.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Group_Code));
                    if (PromoterGroupCode != "")
                    {
                        var PromotersWithChild = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_ParentOrChild_Details_Promoter(PromoterGroupCode, "C").ToList();
                        string PromotercodeTempToShow = PromotersWithChild[0].ToString();
                        List<int> PromoterCodesToValidate = PromotercodeTempToShow.Split(',').Select(int.Parse).ToList();

                        PromoterGroupCode = String.Join(",", PromoterCodesToValidate.ToArray());
                        // objPG.Promoter_GroupCodes_Selected = PromoterGroupCode.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        objPG.Show_Selected = false;
                        objPG.Promoter_GroupCodes_Display = PromoterGroupCode;
                        ViewBag.TV_Platform = objPG.PopulateTreeNode("N");
                    }
                    else
                        ViewBag.TV_Platform = objPG.PopulateTreeNode("N", "", true);
                }
            }

        END_Label:
            ViewBag.TreeId = "Promoter_Matrix";
            ViewBag.TreeValueId = "hdnPGCodes";
            return PartialView("_TV_Platform");
        }

        public JsonResult GetPromoterCodes(string DummyProperty)
        {
            Syn_Deal_Rights_Promoter obj = objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.Where(w => w.strDummyProp == DummyProperty && w.EntityState != State.Deleted).FirstOrDefault();
            string PromoterGroupCode = string.Join(",", obj.Syn_Deal_Rights_Promoter_Group.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Group_Code));

            var ob = new
            {
                PromoterCodes = PromoterGroupCode
            };
            return Json(ob);
        }

        public bool IsAlphabets(string inputString)
        {
            Regex r = new Regex("^[a-zA-Z ]+$");
            if (r.IsMatch(inputString))
                return true;
            else
                return false;
        }
    }
}
