using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Acq_Rights_PromoterController : BaseController
    {
        #region --------Session Declaration-----
        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.ACQ_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.ACQ_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.ACQ_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.ACQ_DEAL_SCHEMA] = value; }
        }
        public Acq_Deal_Rights objAcq_Deal_Rights
        {
            get
            {
                if (Session["ACQ_DEAL_RIGHTS"] == null)
                    Session["ACQ_DEAL_RIGHTS"] = new Acq_Deal_Rights();
                return (Acq_Deal_Rights)Session["ACQ_DEAL_RIGHTS"];
            }
            set { Session["ACQ_DEAL_RIGHTS"] = value; }
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
        // GET: /Acq_Rights_Promoter/

        public ActionResult Index()
        {
            return View();
        }
        public PartialViewResult BindPromoter()
        {
            ViewBag.Promoter_Flag = objAcq_Deal_Rights.Promoter_Flag;
            if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_VIEW || objPage_Properties.RMODE == GlobalParams.DEAL_MODE_APPROVE)
                ViewBag.CommandName_PR = objPage_Properties.RMODE;
            else
                ViewBag.CommandName_PR = "LIST";
            List<Acq_Deal_Rights_Promoter> lst = objAcq_Deal_Rights.Acq_Deal_Rights_Promoter.Where(t => t.EntityState != State.Deleted).ToList();
            lst.ToList().ForEach(
                Promoter=>
                {
                    var ParentPromoterCodes = Promoter.Acq_Deal_Rights_Promoter_Group.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Group_Code).ToList();
                    string PromoterCodestoGetChild = string.Join(",", ParentPromoterCodes.ToArray());
                    var PromoterCodes = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_ParentOrChild_Details_Promoter(PromoterCodestoGetChild, "C").ToList();
                    var count = PromoterCodes[0].ToString();
                    string[] PromoterCodesForCount = count.Split(',').ToList<string>().ToArray();
                    Promoter.TotalCount = PromoterCodesForCount.Count().ToString();
                });
            return PartialView("~/Views/Acq_Deal/_Acq_Rights_Promoter_List.cshtml", lst);
        }
        public PartialViewResult Add_Promoter()
        {
            ViewBag.Promoter_Group_Codes = "";
            Promoter_Group_Tree_View objPTV = new Promoter_Group_Tree_View(objLoginEntity.ConnectionStringName);
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            List<Acq_Deal_Rights_Promoter> lst = objAcq_Deal_Rights.Acq_Deal_Rights_Promoter.Where(t => t.EntityState != State.Deleted).ToList();
            List<Promoter_Group> lstPromoterGroup = new Promoter_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Promoter_Group_Name).ToList();
            ViewBag.PromoterList = new MultiSelectList(lstPromoterGroup, "Promoter_Group_Code", "Promoter_Group_Name");

            List<Promoter_Remarks> lstPromoterRemarks = new Promoter_Remarks_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Promoter_Remark_Desc).ToList();
            ViewBag.RemarksList = new MultiSelectList(lstPromoterRemarks, "Promoter_Remarks_Code", "Promoter_Remark_Desc");
            ViewBag.CommandName_PR = "ADD";
            ViewBag.IsAddEditMode = "Y";
            return PartialView("~/Views/Acq_Deal/_Acq_Rights_Promoter_List.cshtml", lst);
        }
        public PartialViewResult Edit_Promoter(string DummyProperty)
        {
            List<Acq_Deal_Rights_Promoter> lst = objAcq_Deal_Rights.Acq_Deal_Rights_Promoter.Where(t => t.EntityState != State.Deleted).ToList();
            List<Promoter_Group> lstPromoterGroup = new Promoter_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Promoter_Group_Name).ToList();
            List<Promoter_Remarks> lstPromoterRemarks = new Promoter_Remarks_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Promoter_Remark_Desc).ToList();

            ViewBag.CommandName_PR = GlobalParams.DEAL_MODE_EDIT;
            ViewBag.DummyProperty = DummyProperty;

            Acq_Deal_Rights_Promoter obj = objAcq_Deal_Rights.Acq_Deal_Rights_Promoter.Where(w => w.strDummyProp == DummyProperty && w.EntityState != State.Deleted).FirstOrDefault();
            string Promoter_Group_Codes = string.Join(",", obj.Acq_Deal_Rights_Promoter_Group.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Group_Code));
            ViewBag.Promoter_Group_Codes = Promoter_Group_Codes;
            var PromterCodes = obj.Acq_Deal_Rights_Promoter_Group.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Group_Code).ToArray();
            ViewBag.PromoterList = new MultiSelectList(lstPromoterGroup, "Promoter_Group_Code", "Promoter_Group_Name", PromterCodes);

            var RemarksCodes = obj.Acq_Deal_Rights_Promoter_Remarks.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Remarks_Code).ToArray();
            ViewBag.RemarksList = new MultiSelectList(lstPromoterRemarks, "Promoter_Remarks_Code", "Promoter_Remark_Desc", RemarksCodes);
            return PartialView("~/Views/Acq_Deal/_Acq_Rights_Promoter_List.cshtml", lst);
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
        public JsonResult Save_Promoter(string PromoterCode, string[] RemarkCode, string DummyProperty)
        {
            string[] PromoterGroups = PromoterCode.Split(',').ToList<string>().ToArray();
             string Message = "";
            ArrayList arrLPromoters = new ArrayList(PromoterGroups);
          
            ObjectParameter objMessage = new ObjectParameter("Message", Message);
            string mode = string.Empty;


            foreach (var item in objAcq_Deal_Rights.Acq_Deal_Rights_Promoter.Where(w => w.strDummyProp != DummyProperty && w.EntityState != State.Deleted))
            {
                Acq_Deal_Rights_Promoter objp = new Acq_Deal_Rights_Promoter();
                objp = item;
                var Promoters = objp.Acq_Deal_Rights_Promoter_Group.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Group_Code).ToList();
                var Remarks = objp.Acq_Deal_Rights_Promoter_Remarks.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Remarks_Code.ToString()).ToList();

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

                var PromoterCodeToAdd = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_ParentOrChild_Details_Promoter(PromoterCode,"P").ToList();
                string PromotercodeTemp = PromoterCodeToAdd[0].ToString();
                string[] PromoterCodesToAdd = PromotercodeTemp.Split(',').ToList<string>().ToArray();

            var PromotercodeForCount = new  USP_Service(objLoginEntity.ConnectionStringName).USP_Get_ParentOrChild_Details_Promoter(PromoterCode,"C").ToList();
            string PromoterForCount = PromotercodeForCount[0].ToString();
            string[] PromoterCodesForCount = PromoterForCount.Split(',').ToList<string>().ToArray();
            objAcq_Deal_Rights.Acq_Deal_Rights_Promoter.Where(w => w.strDummyProp == DummyProperty).Select(s => s.TotalCount = PromoterCodesForCount.Count().ToString()).FirstOrDefault();
         
            Acq_Deal_Rights_Promoter objADRP = null;
            if (DummyProperty != "0" && DummyProperty != null)
            {
                mode = "u";
                objADRP = objAcq_Deal_Rights.Acq_Deal_Rights_Promoter.Where(w => w.strDummyProp == DummyProperty).FirstOrDefault();
                if (objADRP.Acq_Deal_Rights_Promoter_Code > 0)
                    objADRP.EntityState = State.Modified;

                objADRP.Last_Updated_Time = System.DateTime.Now;
                objADRP.Last_Action_By = objLoginUser.Users_Code;
            }
            else
            {
                mode = "A";
                objADRP = new Acq_Deal_Rights_Promoter();
                objADRP.EntityState = State.Added;
                objADRP.Inserted_By = objLoginUser.Users_Code;
                objADRP.Inserted_On = System.DateTime.Now;
                objADRP.Last_Action_By = objLoginUser.Users_Code;
                objADRP.Last_Updated_Time = System.DateTime.Now;
                objAcq_Deal_Rights.Acq_Deal_Rights_Promoter.Add(objADRP);
            }



            ICollection<Acq_Deal_Rights_Promoter_Group> PromoterList = new HashSet<Acq_Deal_Rights_Promoter_Group>();
            foreach (string PromotersCode in PromoterCodesToAdd)
            {
                if (PromotersCode != "0")
                {
                    Acq_Deal_Rights_Promoter_Group objTR = new Acq_Deal_Rights_Promoter_Group();
                    objTR.EntityState = State.Added;
                    objTR.Promoter_Group_Code = Convert.ToInt32(PromotersCode);
                    PromoterList.Add(objTR);
                }
            }

            IEqualityComparer<Acq_Deal_Rights_Promoter_Group> comparerPromoterGroup = new LambdaComparer<Acq_Deal_Rights_Promoter_Group>((x, y) => x.Promoter_Group_Code == y.Promoter_Group_Code && x.EntityState != State.Deleted);
            var Deleted_Promoter = new List<Acq_Deal_Rights_Promoter_Group>();
            var Updated_Promoter = new List<Acq_Deal_Rights_Promoter_Group>();
            var Added_Promoter = CompareLists<Acq_Deal_Rights_Promoter_Group>(PromoterList.ToList<Acq_Deal_Rights_Promoter_Group>(), objADRP.Acq_Deal_Rights_Promoter_Group.ToList<Acq_Deal_Rights_Promoter_Group>(), comparerPromoterGroup, ref Deleted_Promoter, ref Updated_Promoter);
            Added_Promoter.ToList<Acq_Deal_Rights_Promoter_Group>().ForEach(t => objADRP.Acq_Deal_Rights_Promoter_Group.Add(t));
            Deleted_Promoter.ToList<Acq_Deal_Rights_Promoter_Group>().ForEach(t => t.EntityState = State.Deleted);


            ICollection<Acq_Deal_Rights_Promoter_Remarks> RemarksList = new HashSet<Acq_Deal_Rights_Promoter_Remarks>();

            foreach (string RemarksCode in RemarkCode)
            {
                Acq_Deal_Rights_Promoter_Remarks objTR = new Acq_Deal_Rights_Promoter_Remarks();
                objTR.EntityState = State.Added;
                objTR.Promoter_Remarks_Code = Convert.ToInt32(RemarksCode);
                RemarksList.Add(objTR);
            }
            IEqualityComparer<Acq_Deal_Rights_Promoter_Remarks> comparePromoterRemarks = new LambdaComparer<Acq_Deal_Rights_Promoter_Remarks>((x, y) => x.Promoter_Remarks_Code == y.Promoter_Remarks_Code && x.EntityState != State.Deleted);
            var Deleted_Remarks = new List<Acq_Deal_Rights_Promoter_Remarks>();
            var Updated_Remarks = new List<Acq_Deal_Rights_Promoter_Remarks>();
            var Added_Remarks = CompareLists<Acq_Deal_Rights_Promoter_Remarks>(RemarksList.ToList<Acq_Deal_Rights_Promoter_Remarks>(), objADRP.Acq_Deal_Rights_Promoter_Remarks.ToList<Acq_Deal_Rights_Promoter_Remarks>(), comparePromoterRemarks, ref Deleted_Remarks, ref Updated_Remarks);
            Added_Remarks.ToList<Acq_Deal_Rights_Promoter_Remarks>().ForEach(t => objADRP.Acq_Deal_Rights_Promoter_Remarks.Add(t));
            Deleted_Remarks.ToList<Acq_Deal_Rights_Promoter_Remarks>().ForEach(t => t.EntityState = State.Deleted);



            var obj = new
            {
                message = "Success",
                mode = mode
            };
            return Json(obj);
        }
        public JsonResult Delete_Promoter(string DummyProperty)
        {
            objAcq_Deal_Rights.Acq_Deal_Rights_Promoter.Where(w => w.strDummyProp == DummyProperty).Select(s => s.EntityState = State.Deleted).FirstOrDefault();

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
        public PartialViewResult BindPromoterGroupTree(string PromoterGroupCode, string DummyProperty)
        {
            var Parent_Group_Codes = new Promoter_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Select(s => s.Parent_Group_Code).Distinct().ToList();
            Promoter_Group_Tree_View objPG = new Promoter_Group_Tree_View(objLoginEntity.ConnectionStringName);
            Acq_Deal_Rights_Promoter obj = objAcq_Deal_Rights.Acq_Deal_Rights_Promoter.Where(w => w.strDummyProp == DummyProperty && w.EntityState != State.Deleted).FirstOrDefault();
            if (PromoterGroupCode == "")
            {              
                if (obj != null)
                {
                    PromoterGroupCode = string.Join(",", obj.Acq_Deal_Rights_Promoter_Group.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Group_Code));

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
                    ViewBag.TV_Platform = objPG.PopulateTreeNode("N");
                }
            }
            else 
            {
                if (obj != null)
                {
                    var PromotersWithChild = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_ParentOrChild_Details_Promoter(PromoterGroupCode, "C").ToList();
                    string PromotercodeTempToValidate = PromotersWithChild[0].ToString();
                    List<int> PromoterCodesToValidate = PromotercodeTempToValidate.Split(',').Select(int.Parse).ToList();

                    PromoterGroupCode = String.Join(",", PromoterCodesToValidate.ToArray());
                    objPG.Promoter_GroupCodes_Selected = PromoterGroupCode.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

                    objPage_Properties.Acquired_Promoter_Codes = string.Join(",", (obj.Acq_Deal_Rights_Promoter_Group.Select(i => i.Promoter_Group_Code).Distinct().ToList()));
                    string referancePlatforms = "", referancePlatformsAcq = "";

                    if (objPage_Properties.obj_lst_Syn_Rights.Count() > 0 && objPage_Properties.Is_Syn_Acq_Mapp == "Y" && objPage_Properties.RMODE != "C")
                    {
                        int[] arr_Syn_Rights_Code = (new Syn_Acq_Mapping_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Deal_Rights_Code == objPage_Properties.RCODE).Select(i => i.Deal_Rights_Code).Distinct().ToArray());
                        objPage_Properties.Obj_Acq_Deal_Rights = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(i => arr_Syn_Rights_Code.Contains(i.Acq_Deal_Rights_Code)).Select(i => i).ToList();

                        var lstNew = objPage_Properties.Obj_Acq_Deal_Rights.SelectMany(x => x.Acq_Deal_Rights_Promoter.SelectMany(y => y.Acq_Deal_Rights_Promoter_Group)).ToList();

                        var lst = objPage_Properties.obj_lst_Syn_Rights.SelectMany(x => x.Syn_Deal_Rights_Promoter.SelectMany(y => y.Syn_Deal_Rights_Promoter_Group)).ToList();
                        string[] arr_Selected_PGCodes = objPage_Properties.Acquired_Promoter_Codes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        objPG.Reference_From = "S";
                        referancePlatforms += string.Join(",", lst.Where(w => arr_Selected_PGCodes.Contains(w.Promoter_Group_Code.ToString())).Select(s => s.Promoter_Group_Code).Distinct().ToArray());
                        referancePlatformsAcq += string.Join(",", lstNew.Where(w => arr_Selected_PGCodes.Contains(w.Promoter_Group_Code.ToString())).Select(s => s.Promoter_Group_Code).Distinct().ToArray());
                    }

                    if ((referancePlatformsAcq != "" || referancePlatforms != "") && objPage_Properties.RMODE != "C")
                    {
                        objPG.SynPlatformCodes_Reference = referancePlatforms.Trim(',').Split(new char[] { ',' }, StringSplitOptions.None);
                        objPG.SynPlatformCodes_Reference_New = referancePlatformsAcq.Trim(',').Split(new char[] { ',' }, StringSplitOptions.None);
                    }
                    ViewBag.TV_Platform = objPG.PopulateTreeNode("N");
                }
                else
                {
                    ViewBag.TV_Platform = objPG.PopulateTreeNode("N");
                }
            }
            ViewBag.TreeId = "Promoter_Matrix";
            ViewBag.TreeValueId = "hdnPGCodes";
            return PartialView("_TV_Platform");
        }
        public JsonResult GetPromoterCodes(string DummyProperty)
        {
            Acq_Deal_Rights_Promoter obj = objAcq_Deal_Rights.Acq_Deal_Rights_Promoter.Where(w => w.strDummyProp == DummyProperty && w.EntityState != State.Deleted).FirstOrDefault();
           string  PromoterGroupCode = string.Join(",", obj.Acq_Deal_Rights_Promoter_Group.Where(w => w.EntityState != State.Deleted).Select(s => s.Promoter_Group_Code));
           var ob = new
          {
              PromoterCodes = PromoterGroupCode
          };
           return Json(ob);
        }
    }
}
