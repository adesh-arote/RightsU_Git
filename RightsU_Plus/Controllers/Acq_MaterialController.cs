﻿using System;
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
    public class Acq_MaterialController : BaseController
    {
        #region properties
        public Acq_Deal objDeal
        {
            get
            {
                if (Session["objDeal"] == null)
                    Session["objDeal"] = new Acq_Deal();
                return (Acq_Deal)Session["objDeal"];
            }
            set { Session["objDeal"] = value; }
        }

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
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDeal);
            ViewBag.Message = Message;
            ViewBag.Mode = Mode;
            ViewBag.CommandName = "";
            //ViewBag.IsAddEditMode = "N";
            int Deal_Code = objDeal_Schema.Deal_Code;
            objDeal_Schema.Page_From = GlobalParams.Page_From_Material;
            objDeal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(Deal_Code);
            Session["objDeal"] = objDeal;
            ViewBag.PageMode = objDeal_Schema.Mode;
            ViewBag.Approver_Remark = objDeal_Schema.Approver_Remark;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;
            //return View("Index", objDeal.Acq_Deal_Material.ToList());

            int prevAcq_Deal = 0;
            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_VIEW && TempData["prevAcqDeal"] != null)
            {
                prevAcq_Deal = Convert.ToInt32(TempData["prevAcqDeal"]);
                TempData.Keep("prevAcqDeal");
            }
            ViewBag.prevAcq_Deal = prevAcq_Deal;
            return PartialView("~/Views/Acq_Deal/_Acq_Material.cshtml", objDeal.Acq_Deal_Material.ToList());
        }

        public PartialViewResult Create(string isAdd, int txtPageSize, int pageNo)
        {
            ViewBag.CommandName = "Add";
            string Is_Acq_Syn_Material_MultiTitle = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Acq_Syn_Material_MultiTitle").Select(x => x.Parameter_Value).FirstOrDefault();
            if (Is_Acq_Syn_Material_MultiTitle == "Y")
            {
                ViewBag.Is_Acq_Syn_Material_MultiTitle = Is_Acq_Syn_Material_MultiTitle;
                var lst = new USP_Service(objLoginEntity.ConnectionStringName).USP_Bind_Title(objDeal.Acq_Deal_Code, objDeal_Schema.Deal_Type_Code, "A").ToList();
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
            return BindGridAcqMaterial(txtPageSize, pageNo);
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
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            obj_Dic.Add("Page_No", pageNo.ToString());
            obj_Dic.Add("ReleaseRecord", "Y");
            TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
            if (TempData["TitleData"] != null)
            {
                return RedirectToAction("View", "Title");
            }
            else
            {
                return RedirectToAction("Index", "Acq_List");
            }
            //return RedirectToAction("Index", "Acq_List", new { Page_No = pageNo, ReleaseRecord = "Y" });
        }

        public PartialViewResult Edit(int Acq_Deal_Material_Code, int txtPageSize, int pageNo)
        {
            ViewBag.Acq_Deal_Material_Code = Acq_Deal_Material_Code;
            Acq_Deal_Material_Service objAcq_Deal_Material_Service = new Acq_Deal_Material_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal_Material objAcq_Deal_Material = objAcq_Deal_Material_Service.GetById(Acq_Deal_Material_Code);
            ViewBag.CommandName = "Edit";
            ViewBag.Acq_Deal_Material_Code = Acq_Deal_Material_Code;

            string titleCodes = "";
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                //titleCodes = (from Acq_Deal_Movie obj in objDeal.Acq_Deal_Movie
                //              where obj.Title_Code == objAcq_Deal_Material.Title_Code //code
                //              select Convert.ToString(obj.Acq_Deal_Movie_Code)).FirstOrDefault();
                titleCodes = string.Join(",", objDeal.Acq_Deal_Movie.Where(x => objAcq_Deal_Material.Title_Code == x.Title_Code && objAcq_Deal_Material.Episode_From == x.Episode_Starts_From && objAcq_Deal_Material.Episode_To == x.Episode_End_To).Select(x => x.Acq_Deal_Movie_Code));
            }
            else
            {
                titleCodes = string.Join(", ", objAcq_Deal_Material.Title_Code);
            }
            BindTitle(titleCodes);
            BindMaterialType(Convert.ToInt32(objAcq_Deal_Material.Material_Type_Code));
            BindMaterialMediumType(Convert.ToInt32(objAcq_Deal_Material.Material_Medium_Code));
            return BindGridAcqMaterial(txtPageSize, pageNo);
        }

        public PartialViewResult Delete(int Acq_Deal_Material_Code, int txtPageSize, int pageNo)
        {
            if (Acq_Deal_Material_Code > 0)
            {
                Acq_Deal_Material_Service objAcq_Deal_Material_Service = new Acq_Deal_Material_Service(objLoginEntity.ConnectionStringName);
                Acq_Deal_Material objAcq_Deal_Material = objAcq_Deal_Material_Service.GetById(Acq_Deal_Material_Code);
                objAcq_Deal_Material.EntityState = State.Deleted;
                dynamic resultSet;
                objAcq_Deal_Material_Service.Save(objAcq_Deal_Material, out resultSet);
            }
            return BindGridAcqMaterial(txtPageSize, pageNo);
        }

        public ActionResult ChangeTab(string hdnTabName)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code);
        }

        [HttpPost]
        public PartialViewResult BindGridAcqMaterial(int txtPageSize, int page_No)
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
            ICollection<Acq_Deal_Material> lst_Acq_Deal_Material;
            Acq_Deal_Material_Service objAcq_Deal_Material_Service = new Acq_Deal_Material_Service(objLoginEntity.ConnectionStringName);
            if (PageNo == 1)
                lst_Acq_Deal_Material = objAcq_Deal_Material_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Acq_Deal_Material_Code).Take(pageSize).ToList();
            else
            {
                lst_Acq_Deal_Material = objAcq_Deal_Material_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Acq_Deal_Material_Code).Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                if (lst_Acq_Deal_Material.Count == 0)
                {
                    if (PageNo != 1)
                    {
                        objDeal_Schema.Cost_PageNo = PageNo - 1;
                        PageNo = PageNo - 1;
                    }
                    lst_Acq_Deal_Material = objAcq_Deal_Material_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Acq_Deal_Material_Code).Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                }
            }

            ViewBag.RecordCount = objAcq_Deal_Material_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).Count();
            ViewBag.PageNo = PageNo;
            ViewBag.PageSize = txtPageSize;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
            ViewBag.PageMode = objDeal_Schema.Mode;

            return PartialView("~/Views/Acq_Deal/_List_Material.cshtml", lst_Acq_Deal_Material);
        }

        #endregion

        #region Methods

        public string SaveMaterial(int Acq_Deal_Material_Code, int Title_Code, int Material_Type_Code, int Material_Medium_Code, int Quantity, string Title_Codes, string strAddTitle_Code = "")
        {
            string ReturnMessage = "Y";
            if (Acq_Deal_Material_Code == 0)
            {
                Acq_Deal_Material objAcq_Deal_Material = new Acq_Deal_Material();
                Acq_Deal_Material_Service objAcq_Deal_Material_Service = new Acq_Deal_Material_Service(objLoginEntity.ConnectionStringName);
                objAcq_Deal_Material.Acq_Deal_Code = objDeal.Acq_Deal_Code;
                objAcq_Deal_Material.Inserted_On = DateTime.Now;
                objAcq_Deal_Material.Inserted_By = objLoginUser.Users_Code;

                //For Title code
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    Title_List objTitle_List = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == Title_Code).FirstOrDefault();
                    objAcq_Deal_Material.Title_Code = objTitle_List.Title_Code;
                    objAcq_Deal_Material.Episode_From = objTitle_List.Episode_From;
                    objAcq_Deal_Material.Episode_To = objTitle_List.Episode_To;
                }
                else
                {
                    objAcq_Deal_Material.Title_Code = Title_Code;
                    objAcq_Deal_Material.Episode_From = 1;
                    objAcq_Deal_Material.Episode_To = 1;
                }

                objAcq_Deal_Material.Material_Type_Code = Material_Type_Code;
                objAcq_Deal_Material.Material_Medium_Code = Material_Medium_Code;
                objAcq_Deal_Material.Quantity = Quantity;

                string Is_Acq_Syn_Material_MultiTitle = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Acq_Syn_Material_MultiTitle").Select(x => x.Parameter_Value).FirstOrDefault();

                if (Is_Acq_Syn_Material_MultiTitle == "Y")
                {
                    var lstTitleCode = strAddTitle_Code.Split(',');
                    var lstTitleName = Title_Codes.Split(',');
                    int i = 0;
                    bool IsDuplicate = false;
                    List<string> lstTitles = new List<string>();

                    foreach (var titleCode in lstTitleCode)
                    {
                        objAcq_Deal_Material.Title_Code = Convert.ToInt32(titleCode);
                        objAcq_Deal_Material.Episode_From = 1;
                        objAcq_Deal_Material.Episode_To = 1;

                        if (!CheckDuplicateMaterial(objAcq_Deal_Material, "Add", lstTitleName[i]))
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

                        objAcq_Deal_Material.Title_Code = Convert.ToInt32(titleCode);
                        objAcq_Deal_Material.Episode_From = 1;
                        objAcq_Deal_Material.Episode_To = 1;

                        if (CheckDuplicateMaterial(objAcq_Deal_Material, "Add", lstTitleName[i]))
                        {
                            objAcq_Deal_Material.EntityState = State.Added;
                            dynamic resultSet;
                            objAcq_Deal_Material_Service.Save(objAcq_Deal_Material, out resultSet);
                        }
                        i++;
                    }
                }
                else
                {
                    if (CheckDuplicateMaterial(objAcq_Deal_Material, "Add", Title_Codes))
                    {
                        objAcq_Deal_Material.EntityState = State.Added;
                        dynamic resultSet;
                        objAcq_Deal_Material_Service.Save(objAcq_Deal_Material, out resultSet);
                    }
                    else
                    {
                        ReturnMessage = "N";
                    }
                }


            }
            else
            {
                Acq_Deal_Material_Service objAcq_Deal_Material_Service = new Acq_Deal_Material_Service(objLoginEntity.ConnectionStringName);
                Acq_Deal_Material obj = objAcq_Deal_Material_Service.GetById(Acq_Deal_Material_Code);
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
                    obj.Acq_Deal_Code = objDeal.Acq_Deal_Code;

                    obj.Last_Updated_Time = DateTime.Now;
                    obj.Last_Action_By = objLoginUser.Users_Code;
                    if (CheckDuplicateMaterial(obj, "Edit", Title_Codes))
                    {
                        obj.EntityState = State.Modified;
                        dynamic resultSet;
                        objAcq_Deal_Material_Service.Save(obj, out resultSet);
                    }
                    else
                    {
                        ReturnMessage = "N";
                    }
                }

            }
            return ReturnMessage;
        }

        private bool CheckDuplicateMaterial(Acq_Deal_Material objAcq_Deal_Material, string Mode, string hdnTitleName)
        {
            objDeal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            int count = 0;
            int? episode_from = 0;
            int? episode_to = 0;
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
                //if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program)
                //{
                //    if (arr1[j] != "")
                //    {
                //        arr1[j] = arr1[j].Replace(')', ' ');
                //        episode_to = Convert.ToInt32(arr1[j]);
                //    }
                //}
            }
            if (Mode == "Add")
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    count = (from Acq_Deal_Material obj in objDeal.Acq_Deal_Material
                             where obj.Acq_Deal_Code == objDeal.Acq_Deal_Code && obj.Title_Code == objAcq_Deal_Material.Title_Code
                             && obj.Episode_From == episode_from && obj.Episode_To == episode_to
                             && obj.Material_Type_Code == objAcq_Deal_Material.Material_Type_Code
                             && obj.Material_Medium_Code == objAcq_Deal_Material.Material_Medium_Code
                             select obj).Count();
                }
                else
                {
                    count = (from Acq_Deal_Material obj in objDeal.Acq_Deal_Material
                             where obj.Acq_Deal_Code == objDeal.Acq_Deal_Code && obj.Title_Code == objAcq_Deal_Material.Title_Code
                             && obj.Material_Type_Code == objAcq_Deal_Material.Material_Type_Code
                             && obj.Material_Medium_Code == objAcq_Deal_Material.Material_Medium_Code
                             select obj).Count();
                }
            }
            else
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    count = (from Acq_Deal_Material obj in objDeal.Acq_Deal_Material
                             where obj.Acq_Deal_Code == objDeal.Acq_Deal_Code && obj.Title_Code == objAcq_Deal_Material.Title_Code
                             && obj.Episode_From == episode_from && obj.Episode_To == episode_to
                             && obj.Material_Type_Code == objAcq_Deal_Material.Material_Type_Code
                             && obj.Material_Medium_Code == objAcq_Deal_Material.Material_Medium_Code
                             && obj.Acq_Deal_Material_Code != objAcq_Deal_Material.Acq_Deal_Material_Code
                             select obj).Count();
                }
                else
                {
                    count = (from Acq_Deal_Material obj in objDeal.Acq_Deal_Material
                             where obj.Acq_Deal_Code == objDeal.Acq_Deal_Code && obj.Title_Code == objAcq_Deal_Material.Title_Code
                             && obj.Material_Type_Code == objAcq_Deal_Material.Material_Type_Code
                             && obj.Material_Medium_Code == objAcq_Deal_Material.Material_Medium_Code
                             && obj.Acq_Deal_Material_Code != objAcq_Deal_Material.Acq_Deal_Material_Code
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
            List<SelectListItem> lst = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_Bind_Title(objDeal.Acq_Deal_Code, objDeal_Schema.Deal_Type_Code, "A").ToList(), "Title_Code", "Title_Name", selectedTitleCode).ToList();
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

        #endregion
    }
}

