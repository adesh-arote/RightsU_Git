using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Text.RegularExpressions;

namespace RightsU_Plus.Controllers
{
    public class Syn_MaterialController : BaseController
    {
        #region properties
        public Syn_Deal objDeal
        {
            get
            {
                if (Session["objDeal"] == null)
                    Session["objDeal"] = new Syn_Deal();
                return (Syn_Deal)Session["objDeal"];
            }
            set { Session["objDeal"] = value; }
        }

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

        public int PageNo
        {
            get
            {
                if (ViewBag.PageNo == null)
                    ViewBag.PageNo = 1;
                return (int)ViewBag.PageNo;
            }
            set { ViewBag.PageNo = value; }
        }

        #endregion

        #region Actions

        public PartialViewResult Index(string Message = "", string Mode = "")
        {
            ViewBag.Message = Message;
            ViewBag.Mode = Mode;
            ViewBag.CommandName = "";
            int Deal_Code = objDeal_Schema.Deal_Code;
            objDeal_Schema.Page_From = GlobalParams.Page_From_Material;
            objDeal = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(Deal_Code);
            objDeal_Schema.Deal_Type_Code = Convert.ToInt32(objDeal.Deal_Type_Code);// To be deleted
            Session["objDeal"] = objDeal;
            ViewBag.PageMode = objDeal_Schema.Mode;
            ViewBag.Approver_Remark = objDeal_Schema.Approver_Remark;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
            ViewBag.Remark = objDeal.Material_Remarks;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;
            //return View("Index", objDeal.Syn_Deal_Material.ToList());
            return PartialView("~/Views/Syn_Deal/_Syn_Material.cshtml", objDeal.Syn_Deal_Material.ToList());
        }
        public PartialViewResult Create(string isAdd, int txtPageSize, int pageNo)
        {
            ViewBag.CommandName = "Add";
            string Is_Acq_Syn_Material_MultiTitle = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Acq_Syn_Material_MultiTitle").Select(x => x.Parameter_Value).FirstOrDefault();
            if (Is_Acq_Syn_Material_MultiTitle == "Y")
            {
                ViewBag.Is_Acq_Syn_Material_MultiTitle = Is_Acq_Syn_Material_MultiTitle;
                var lst = new USP_Service(objLoginEntity.ConnectionStringName).USP_Bind_Title(objDeal.Syn_Deal_Code, objDeal_Schema.Deal_Type_Code, "S").ToList();
                TempData["Title_Code"] = new MultiSelectList(lst, "Title_Code", "Title_Name");
            }
            else
            {
                BindTitle("");
            }
            BindMaterialType(0);
            BindMaterialMediumType(0);
            if (isAdd == "1")
            {
                ViewBag.CommandName = "Add";
            }
            else
            {
                ViewBag.CommandName = "";
            }
            return BindGridSynMaterial(txtPageSize, pageNo);
        }

        public ActionResult Cancel()
        {
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            else
                ViewBag.Record_Locking_Code = 0;
            ClearSession();
            objDeal_Schema = null;
            Session[UtoSession.SESS_DEAL] = null;
            if (TempData["TitleData"] != null)
            {
                return RedirectToAction("View", "Title");
            }
            else
            {
                Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
                obj_Dic.Add("Page_No", pageNo.ToString());
                obj_Dic.Add("ReleaseRecord", "Y");
                TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
                return RedirectToAction("Index", "Syn_List");
            }
        }

        public PartialViewResult Edit(int Syn_Deal_Material_Code, int txtPageSize, int pageNo)
        {
            ViewBag.Syn_Deal_Material_Code = Syn_Deal_Material_Code;
            Syn_Deal_Material_Service objSyn_Deal_Material_Service = new Syn_Deal_Material_Service(objLoginEntity.ConnectionStringName);
            Syn_Deal_Material objSyn_Deal_Material = objSyn_Deal_Material_Service.GetById(Syn_Deal_Material_Code);
            ViewBag.CommandName = "Edit";
            ViewBag.Syn_Deal_Material_Code = Syn_Deal_Material_Code;

            string titleCodes = "";
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                titleCodes = string.Join(",", objDeal.Syn_Deal_Movie.Where(x => objSyn_Deal_Material.Title_Code == x.Title_Code && objSyn_Deal_Material.Episode_From == x.Episode_From && objSyn_Deal_Material.Episode_To == x.Episode_End_To).Select(x => x.Syn_Deal_Movie_Code));
            }
            else
            {
                titleCodes = string.Join(", ", objSyn_Deal_Material.Title_Code);
            }
            BindTitle(titleCodes);
            BindMaterialType(Convert.ToInt32(objSyn_Deal_Material.Material_Type_Code));
            BindMaterialMediumType(Convert.ToInt32(objSyn_Deal_Material.Material_Medium_Code));
            return BindGridSynMaterial(txtPageSize, pageNo);
        }

        public PartialViewResult Delete(int Syn_Deal_Material_Code, int txtPageSize, int pageNo)
        {
            if (Syn_Deal_Material_Code > 0)
            {
                Syn_Deal_Material_Service objSyn_Deal_Material_Service = new Syn_Deal_Material_Service(objLoginEntity.ConnectionStringName);
                Syn_Deal_Material objSyn_Deal_Material = objSyn_Deal_Material_Service.GetById(Syn_Deal_Material_Code);
                objSyn_Deal_Material.EntityState = State.Deleted;
                dynamic resultSet;
                objSyn_Deal_Material_Service.Save(objSyn_Deal_Material, out resultSet);
            }
            return BindGridSynMaterial(txtPageSize, pageNo);
        }
        
        public JsonResult ChangeTab(string hdnMaterialRemark, string hdnTabName, string hdnReopenMode = "")
        {
            string mode = "";
            string status = "S";
            if (hdnReopenMode == "RO")
            {
                mode = GlobalParams.DEAL_MODE_EDIT;
                status = "SA";
            }
            else
                mode = objDeal_Schema.Mode;

            if (mode == GlobalParams.DEAL_MODE_REOPEN)
            {
                objDeal_Schema.Deal_Workflow_Flag = objDeal.Deal_Workflow_Status = Convert.ToString(mode).Trim();
            }
            string msg = "";
            if (objDeal_Schema.Mode != "V")
                SaveRemark(hdnMaterialRemark);
            if (hdnTabName == "")
            {

                Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
                obj_Dic.Add("Page_No", objDeal_Schema.PageNo.ToString());
                TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;

                string Mode = objDeal_Schema.Mode;
                TempData["RedirectSynDeal"] = objDeal;
                msg = objMessageKey.DealSavedSuccessfully;
                if (Mode == GlobalParams.DEAL_MODE_EDIT)
                    msg = objMessageKey.DealUpdatedSuccessfully;
            }

            string redirectUrl = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetRedirectURL(hdnTabName, objDeal_Schema.PageNo, null, objDeal_Schema.Deal_Type_Code, GlobalParams.ModuleCodeForSynDeal);

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Success_Message", msg);
            obj.Add("Redirect_URL", redirectUrl);
            return Json(obj);
        }

        [HttpPost]
        public PartialViewResult BindGridSynMaterial(int txtPageSize, int page_No)
        {
            int pageSize;
            if (txtPageSize != null)
            {
                objDeal_Schema.Cost_PageSize = Convert.ToInt32(txtPageSize);
                pageSize = Convert.ToInt32(txtPageSize);
            }
            else
            {
                objDeal_Schema.Cost_PageSize = 50;
                pageSize = 50;
            }
            PageNo = page_No + 1;
            ICollection<Syn_Deal_Material> lst_Syn_Deal_Material;
            Syn_Deal_Material_Service objSyn_Deal_Material_Service = new Syn_Deal_Material_Service(objLoginEntity.ConnectionStringName);
            if (PageNo == 1)
                lst_Syn_Deal_Material = objSyn_Deal_Material_Service.SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Syn_Deal_Material_Code).Take(pageSize).ToList();
            else
            {
                lst_Syn_Deal_Material = objSyn_Deal_Material_Service.SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Syn_Deal_Material_Code).Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                if (lst_Syn_Deal_Material.Count == 0)
                {
                    if (PageNo != 1)
                    {
                        objDeal_Schema.Cost_PageNo = PageNo - 1;
                        PageNo = PageNo - 1;
                    }
                    lst_Syn_Deal_Material = objSyn_Deal_Material_Service.SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Syn_Deal_Material_Code).Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                }
            }

            ViewBag.RecordCount = objSyn_Deal_Material_Service.SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code).Count();
            ViewBag.PageNo = PageNo;
            ViewBag.PageSize = txtPageSize;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
            ViewBag.PageMode = objDeal_Schema.Mode;
            //return PartialView("View", lst_Syn_Deal_Material);
            return PartialView("~/Views/Syn_Deal/_List_Material.cshtml", lst_Syn_Deal_Material);
        }
        #endregion

        #region Methods

        public string SaveMaterial(int Syn_Deal_Material_Code, int Title_Code, int Material_Type_Code, int Material_Medium_Code, int Quantity, string Title_Codes, string strAddTitle_Code = "")
        {
            string ReturnMessage = "Y";
            if (Syn_Deal_Material_Code == 0)
            {
                Syn_Deal_Material objSyn_Deal_Material = new Syn_Deal_Material();
                Syn_Deal_Material_Service objSyn_Deal_Material_Service = new Syn_Deal_Material_Service(objLoginEntity.ConnectionStringName);
                objSyn_Deal_Material.Syn_Deal_Code = objDeal.Syn_Deal_Code;
                objSyn_Deal_Material.Inserted_On = DateTime.Now;
                objSyn_Deal_Material.Inserted_By = objLoginUser.Users_Code;

                //For Title code
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    Title_List objTitle_List = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == Title_Code).FirstOrDefault();
                    objSyn_Deal_Material.Title_Code = objTitle_List.Title_Code;
                    objSyn_Deal_Material.Episode_From = objTitle_List.Episode_From;
                    objSyn_Deal_Material.Episode_To = objTitle_List.Episode_To;
                }
                else
                {
                    objSyn_Deal_Material.Title_Code = Title_Code;
                    objSyn_Deal_Material.Episode_From = 1;
                    objSyn_Deal_Material.Episode_To = 1;
                }
                //
                objSyn_Deal_Material.Material_Type_Code = Material_Type_Code;
                objSyn_Deal_Material.Material_Medium_Code = Material_Medium_Code;
                objSyn_Deal_Material.Quantity = Quantity;

                string Is_Acq_Syn_Material_MultiTitle = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Acq_Syn_Material_MultiTitle").Select(x => x.Parameter_Value).FirstOrDefault();
                bool IsDuplicate = false;
                List<string> lstTitles = new List<string>();

                if (Is_Acq_Syn_Material_MultiTitle == "Y")
                {
                    var lstTitleCode = strAddTitle_Code.Split(',');
                    var lstTitleName = Title_Codes.Split(',');
                    int i = 0;

                    foreach (var titleCode in lstTitleCode)
                    {
                        objSyn_Deal_Material.Title_Code = Convert.ToInt32(titleCode);
                        objSyn_Deal_Material.Episode_From = 1;
                        objSyn_Deal_Material.Episode_To = 1;

                        if (!CheckDuplicateMaterial(objSyn_Deal_Material, "Add", lstTitleName[i]))
                        {
                            lstTitles.Add(lstTitleName[i]);
                            IsDuplicate = true;
                        }
                        i++;
                    }
                    if (IsDuplicate)
                    {
                        ReturnMessage = string.Join(",", lstTitles);
                        return ReturnMessage;
                    }

                    i = 0;

                    foreach (var titleCode in lstTitleCode)
                    {

                        objSyn_Deal_Material.Title_Code = Convert.ToInt32(titleCode);
                        objSyn_Deal_Material.Episode_From = 1;
                        objSyn_Deal_Material.Episode_To = 1;

                        if (CheckDuplicateMaterial(objSyn_Deal_Material, "Add", lstTitleName[i]))
                        {
                            objSyn_Deal_Material.EntityState = State.Added;
                            dynamic resultSet;
                            objSyn_Deal_Material_Service.Save(objSyn_Deal_Material, out resultSet);
                        }
                        i++;
                    }
                }
                else
                {
                    if (CheckDuplicateMaterial(objSyn_Deal_Material, "Add", Title_Codes))
                    {
                        objSyn_Deal_Material.EntityState = State.Added;
                        dynamic resultSet;
                        objSyn_Deal_Material_Service.Save(objSyn_Deal_Material, out resultSet);
                    }
                    else
                    {
                        ReturnMessage = "N";
                    }
                }
            }
            else
            {
                Syn_Deal_Material_Service objSyn_Deal_Material_Service = new Syn_Deal_Material_Service(objLoginEntity.ConnectionStringName);
                Syn_Deal_Material obj = objSyn_Deal_Material_Service.GetById(Syn_Deal_Material_Code);
                if (obj != null)
                {
                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    {
                        Title_List objTitle_List = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == Title_Code).FirstOrDefault();
                        obj.Title_Code = objTitle_List.Title_Code;
                        obj.Episode_From = objTitle_List.Episode_From;
                        obj.Episode_To = objTitle_List.Episode_To;
                    }
                    else
                    {
                        obj.Title_Code = Title_Code;
                        obj.Episode_From = 1;
                        obj.Episode_To = 1;
                    }

                    obj.Material_Type_Code = Material_Type_Code;
                    obj.Material_Medium_Code = Material_Medium_Code;
                    obj.Quantity = Quantity;
                    obj.Syn_Deal_Code = objDeal.Syn_Deal_Code;

                    obj.Last_Updated_Time = DateTime.Now;
                    obj.Last_Action_By = objLoginUser.Users_Code;
                    if (CheckDuplicateMaterial(obj, "Edit", Title_Codes))
                    {
                        obj.EntityState = State.Modified;
                        dynamic resultSet;
                        objSyn_Deal_Material_Service.Save(obj, out resultSet);
                    }
                    else
                    {
                        ReturnMessage = "N";
                    }
                }

            }
            return ReturnMessage;
        }

        private bool CheckDuplicateMaterial(Syn_Deal_Material objSyn_Deal_Material, string Mode, string hdnTitleName)
        {
            objDeal = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            int count = 0;
            int episode_from = 0;
            int episode_to = 0;
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {


                if (hdnTitleName.Trim().Contains("Unlimited"))
                {
                    episode_from = 0;
                }
                else
                {
                    string regularExpressionPattern = @"\((.*?)\)";
                    Regex re = new Regex(regularExpressionPattern);
                    string EspFT = re.Matches(hdnTitleName)[re.Matches(hdnTitleName).Count - 1].Value;
                    string[] str = Regex.Split(EspFT, @"\D+");

                    foreach (string item in str)
                    {
                        if (!string.IsNullOrEmpty(item))
                        {
                            if (episode_from > 0)
                                episode_to = episode_to < 1 ? Convert.ToInt32(item) : episode_to;
                            episode_from = episode_from < 1 ? Convert.ToInt32(item) : episode_from;
                        }
                    }
                }

                //string[] arr1 = hdnTitleName.Split('-');

                //int i = 0, j = 1;
                //if (arr1.Count() > 2)
                //{
                //    i = arr1.Count() - 2;
                //    j = i + 1;
                //}

                //if (arr1[i] != "")
                //{
                //    string[] arr2 = Convert.ToString(arr1[i]).Split('(');
                //    if (Convert.ToString(arr2[1]).Trim().Contains("Unlimited"))
                //    {
                //        episode_from = 0;
                //    }
                //    else
                //    {
                //        if (Convert.ToString(arr2[1]) != "")
                //        {
                //            string[] arr3 = Convert.ToString(arr2[1]).Split(')');


                //            episode_from = Convert.ToInt32(arr3[0]);
                //            episode_to = Convert.ToInt32(arr3[0]);
                //        }
                //    }
                //}
            }
            if (Mode == "Add")
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    count = (from Syn_Deal_Material obj in objDeal.Syn_Deal_Material
                             where obj.Syn_Deal_Code == objDeal.Syn_Deal_Code && obj.Title_Code == objSyn_Deal_Material.Title_Code
                             && obj.Episode_From == episode_from && obj.Episode_To == episode_to
                             && obj.Material_Type_Code == objSyn_Deal_Material.Material_Type_Code
                             && obj.Material_Medium_Code == objSyn_Deal_Material.Material_Medium_Code
                             select obj).Count();
                }
                else
                {
                    count = (from Syn_Deal_Material obj in objDeal.Syn_Deal_Material
                             where obj.Syn_Deal_Code == objDeal.Syn_Deal_Code && obj.Title_Code == objSyn_Deal_Material.Title_Code
                             && obj.Material_Type_Code == objSyn_Deal_Material.Material_Type_Code
                             && obj.Material_Medium_Code == objSyn_Deal_Material.Material_Medium_Code
                             select obj).Count();
                }
            }
            else
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    count = (from Syn_Deal_Material obj in objDeal.Syn_Deal_Material
                             where obj.Syn_Deal_Code == objDeal.Syn_Deal_Code && obj.Title_Code == objSyn_Deal_Material.Title_Code
                             && obj.Episode_From == episode_from && obj.Episode_To == episode_to
                             && obj.Material_Type_Code == objSyn_Deal_Material.Material_Type_Code
                             && obj.Material_Medium_Code == objSyn_Deal_Material.Material_Medium_Code
                             && obj.Syn_Deal_Material_Code != objSyn_Deal_Material.Syn_Deal_Material_Code
                             select obj).Count();
                }
                else
                {
                    count = (from Syn_Deal_Material obj in objDeal.Syn_Deal_Material
                             where obj.Syn_Deal_Code == objDeal.Syn_Deal_Code && obj.Title_Code == objSyn_Deal_Material.Title_Code
                             && obj.Material_Type_Code == objSyn_Deal_Material.Material_Type_Code
                             && obj.Material_Medium_Code == objSyn_Deal_Material.Material_Medium_Code
                             && obj.Syn_Deal_Material_Code != objSyn_Deal_Material.Syn_Deal_Material_Code
                             select obj).Count();
                }
            }

            if (count > 0)
                return false;
            else
                return true;
        }

        private void BindTitle(string selectedTitleCode)
        {
            List<SelectListItem> lst = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_Bind_Title(objDeal.Syn_Deal_Code, objDeal_Schema.Deal_Type_Code, "S").ToList(), "Title_Code", "Title_Name", selectedTitleCode).ToList();
            lst.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
            ViewBag.lstTitle = lst;
        }

        private void BindMaterialType(int Material_Type_Code)
        {
            if (Material_Type_Code == 0)
            {
                List<SelectListItem> lstMaterial_Type = new SelectList(new Material_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Material_Type_Code", "Material_Type_Name").ToList();
                lstMaterial_Type.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
                ViewBag.lstMaterial_Type = lstMaterial_Type;
            }
            else
            {
                List<SelectListItem> lstMaterial_Type = new SelectList(new Material_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Material_Type_Code", "Material_Type_Name", Material_Type_Code).ToList();
                lstMaterial_Type.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
                ViewBag.lstMaterial_Type = lstMaterial_Type;
            }
        }

        private void BindMaterialMediumType(int Material_Medium_Code)
        {
            if (Material_Medium_Code == 0)
            {
                List<SelectListItem> lstMaterial_Medium = new SelectList(new Material_Medium_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Material_Medium_Code", "Material_Medium_Name").ToList();
                lstMaterial_Medium.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
                ViewBag.lstMaterial_Medium = lstMaterial_Medium;
            }
            else
            {
                List<SelectListItem> lstMaterial_Medium = new SelectList(new Material_Medium_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Material_Medium_Code", "Material_Medium_Name", Material_Medium_Code).ToList();
                lstMaterial_Medium.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
                ViewBag.lstMaterial_Medium = lstMaterial_Medium;
            }
        }

        private void ClearSession()
        {
            objDeal = null;
        }
        private bool SaveRemark(string HdnRemark)
        {
            Syn_Deal_Service objADS = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
            objDeal = objADS.GetById(objDeal_Schema.Deal_Code);
            objDeal.Material_Remarks = HdnRemark.Trim().Substring(0, Math.Min(HdnRemark.Trim().Length, 4000));//TruncateLongString(HdnRemark.Trim(),4000);//.Trim();
            objDeal.EntityState = State.Modified;
            dynamic resultSet;
            bool Result = objADS.Save(objDeal, out resultSet);
            return Result;
        }

        #endregion
    }
}
