using System;
using RightsU_Entities;
using RightsU_BLL;
using System.Collections.Generic;
using System.Web.Mvc;
using System.Linq;
using System.Web;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Acq_Rights_TemplateController : BaseController
    {
        private List<RightsU_Entities.Acq_Rights_Template> lstAcq_Rights_Template
        {
            get
            {
                if (Session["lstAcq_Rights_Template"] == null)
                    Session["lstAcq_Rights_Template"] = new List<RightsU_Entities.Acq_Rights_Template>();
                return (List<RightsU_Entities.Acq_Rights_Template>)Session["lstAcq_Rights_Template"];
            }
            set { Session["lstAcq_Rights_Template"] = value; }
        }
        private List<RightsU_Entities.Acq_Rights_Template> lstAcq_Rights_Template_Searched
        {
            get
            {
                if (Session["lstAcq_Rights_Template_Searched"] == null)
                    Session["lstAcq_Rights_Template_Searched"] = new List<RightsU_Entities.Acq_Rights_Template>();
                return (List<RightsU_Entities.Acq_Rights_Template>)Session["lstAcq_Rights_Template_Searched"];
            }
            set { Session["lstAcq_Rights_Template_Searched"] = value; }
        }

        public ActionResult Index()
        {
            return View();
        }
        public PartialViewResult BindAcq_Rights_TemplateList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Entities.Acq_Rights_Template> lst = new List<RightsU_Entities.Acq_Rights_Template>();
            int RecordCount = 0;
            RecordCount = lstAcq_Rights_Template_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstAcq_Rights_Template_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstAcq_Rights_Template_Searched.OrderBy(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstAcq_Rights_Template_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Acq_Rights_Template/_Acq_Rights_TemplateList.cshtml", lst);
        }
        public PartialViewResult BindPartialPages(string key, int Acq_Rights_TemplateCode)
        {

            Acq_Rights_Template_Service objService = new Acq_Rights_Template_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Acq_Rights_Template objAcq_Rights_Template = null;
            if (key == "LIST")
            {
                ////ViewBag.Code = ModuleCode;
                List<SelectListItem> lstSort = new List<SelectListItem>();
                lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
                lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
                lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
                ViewBag.SortType = lstSort;
                lstAcq_Rights_Template_Searched = lstAcq_Rights_Template = new Acq_Rights_Template_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();

                ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/Acq_Rights_Template/_Acq_Rights_Template.cshtml");
            }
            else
            {
                Session["Acq_Rights_TemplateCode_AddEdit"] = Acq_Rights_TemplateCode;
                if (Acq_Rights_TemplateCode > 0 && key != "VIEW")
                {
                    ViewBag.Mode = "";
                    ViewData["Status"] = "U";
                    objAcq_Rights_Template = objService.GetById(Acq_Rights_TemplateCode);

                    ViewData["MyAcq_Rights_Template"] = objAcq_Rights_Template;
                }
                else if (key == "VIEW")
                {
                    objAcq_Rights_Template = objService.GetById(Acq_Rights_TemplateCode);
                    ViewBag.Mode = "V";
                    ViewData["MyAcq_Rights_Template"] = objAcq_Rights_Template;
                }
                else
                {
                    ViewData["Status"] = "A";
                    ViewData["MyVendor"] = "";
                    ViewData["MyAcq_Rights_Template"] = "";
                }
                // Send this list to the view                     
                return PartialView("~/Views/Acq_Rights_Template/_AddEditAcq_Rights_Template.cshtml");
            }
            return PartialView("~/Views/Acq_Rights_Template/_Acq_Rights_Template.cshtml");
        }
        private MultiSelectList BindCountry(string Is_Theatrical_Right, string Selected_Country_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindCountry_List(Is_Theatrical_Right, Selected_Country_Code);
        }
        private MultiSelectList BindTerritory(string Is_Theatrical_Right, string Selected_Territory_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindTerritory_List(Is_Theatrical_Right, Selected_Territory_Code);
        }
        private MultiSelectList BindLanguage(string Selected_Language_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindLanguage_List(Selected_Language_Code);
        }
        private MultiSelectList BindLanguage_Group(string Selected_Language_Group_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindLanguage_Group_List(Selected_Language_Group_Code);
        }
        public JsonResult Bind_JSON_ListBox(string str_Type)
        {
            // I - Country // G -Territory // SL -Sub Lang // SG - Sub Lang Group // DL -Dub Lang // DG - Dubb Lang Group

            if (str_Type == "I")
            {
                var arr = BindCountry("N");
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            else if (str_Type == "T" || str_Type == "G")
            {
                var arr = BindTerritory("N");
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            else if (str_Type == "SL" || str_Type == "DL")
            {
                var arr = BindLanguage();
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            else if (str_Type == "SG" || str_Type == "DG")
            {
                var arr = BindLanguage_Group();
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            return Json("", JsonRequestBehavior.AllowGet);
        }
        public JsonResult BindAllPreReq_Async(int ARTCode = 0)
        {
            string dataFor = "CTR,STL,DBL,MUN,SBL";

            Acq_Rights_Template_Service objService = new Acq_Rights_Template_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Acq_Rights_Template objAcq_Rights_Template = null;
            if (ARTCode > 0)
            {
                objAcq_Rights_Template = objService.GetById(ARTCode);
            }

            #region --- Data For Region ---
            string Region_Type = "I";
            if (ARTCode > 0)
                Region_Type = objAcq_Rights_Template.Region_Type;
            string dataFor_Region = "CTR";
            if (Region_Type != "I")
                dataFor_Region = "TER";

            dataFor = dataFor.Replace("CTR", dataFor_Region);
            #endregion

            #region --- Data For Subtitling ---
            string Sub_Type = "L";
            if (ARTCode > 0)
                Sub_Type = objAcq_Rights_Template.Subtitling_Type;

            string dataFor_Sub = "STL";
            if (Sub_Type == "G")
                dataFor_Sub = "STG";
            dataFor = dataFor.Replace("STL", dataFor_Sub);
            #endregion

            #region --- Data For Dubbing ---
            string dubType = "L";
            if (ARTCode > 0)
                dubType = objAcq_Rights_Template.Dubbing_Type;

            string dataFor_Dub = "DBL";
            if (dubType == "G")
                dataFor_Dub = "DBG";
            dataFor = dataFor.Replace("DBL", dataFor_Dub);
            #endregion

            string Selected_Region_Code = objAcq_Rights_Template == null ? "" : objAcq_Rights_Template.Region_Codes;
            string Selected_Subtitling_Code = objAcq_Rights_Template == null ? "" : objAcq_Rights_Template.Subtitling_Codes;
            string Selected_Dubbing_Code = objAcq_Rights_Template == null ? "" : objAcq_Rights_Template.Dubbing_Codes;


            List<USP_Get_Acq_PreReq_Result> lstUSP_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Acq_Rights_PreReq(0, dataFor, 0, "N").ToList();
            var subList = new SelectList(lstUSP_PreReq_Result.Where(x => x.Data_For == "SBL"), "Display_Value", "Display_Text").ToList();
            subList.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Sub_License_List", subList);
            if (ARTCode == 0)
                obj.Add("Sub_License_Code", 0);
            else if (objAcq_Rights_Template.SubLicense_Code == null)
                obj.Add("Sub_License_Code", -1);
            else
                obj.Add("Sub_License_Code", objAcq_Rights_Template.SubLicense_Code);


            obj.Add("Region_List", new SelectList(lstUSP_PreReq_Result.Where(x => x.Data_For == dataFor_Region), "Display_Value", "Display_Text").ToList());
            obj.Add("Selected_Region_Code", Selected_Region_Code);
            obj.Add("Subtitle_List", new SelectList(lstUSP_PreReq_Result.Where(x => x.Data_For == dataFor_Sub), "Display_Value", "Display_Text").ToList());
            obj.Add("Selected_Subtitling_Code", Selected_Subtitling_Code);
            obj.Add("Dubbing_List", new SelectList(lstUSP_PreReq_Result.Where(x => x.Data_For == dataFor_Dub), "Display_Value", "Display_Text").ToList());
            obj.Add("Selected_Dubbing_Code", Selected_Dubbing_Code);
            return Json(obj);
        }
        public PartialViewResult BindPlatformTreeView(string strPlatform, string IsBulk = "N")
        {
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }
        private int GetPaging(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
        {
            noOfRecordSkip = noOfRecordTake = 0;
            if (recordCount > 0)
            {
                int cnt = pageNo * recordPerPage;
                if (cnt >= recordCount)
                {
                    int v1 = recordCount / recordPerPage;
                    if ((v1 * recordPerPage) == recordCount)
                        pageNo = v1;
                    else
                        pageNo = v1 + 1;
                }
                noOfRecordSkip = recordPerPage * (pageNo - 1);
                if (recordCount < (noOfRecordSkip + recordPerPage))
                    noOfRecordTake = recordCount - noOfRecordSkip;
                else
                    noOfRecordTake = recordPerPage;
            }
            return pageNo;
        }
        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForAcq_Rights_Template), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();
            return rights;
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
     
        public JsonResult SearchAcq_Rights_Template(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstAcq_Rights_Template_Searched = lstAcq_Rights_Template.Where(w => w.Template_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstAcq_Rights_Template_Searched = lstAcq_Rights_Template;

            var obj = new
            {
                Record_Count = lstAcq_Rights_Template_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult SaveAcq_Rights_Template(FormCollection formData)
        {
            string status = "S", message = "";

            int ARTCode = Convert.ToInt32(formData["hdnAcq_Rights_TemplateCode"]);
            Acq_Rights_Template_Service objService = new Acq_Rights_Template_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Acq_Rights_Template objAcq_Rights_Template = new RightsU_Entities.Acq_Rights_Template();
            if (ARTCode > 0)
            {
                objAcq_Rights_Template = objService.GetById(ARTCode);
                objAcq_Rights_Template.EntityState = State.Modified;
                objAcq_Rights_Template.Last_Action_By = objLoginUser.Users_Code;
            }
            else
            {
                objAcq_Rights_Template.Type = "A";
                objAcq_Rights_Template.Is_Theatrical = "N";
                objAcq_Rights_Template.Is_Active = "Y";
                objAcq_Rights_Template.Inserted_By = objLoginUser.Users_Code;
                objAcq_Rights_Template.Inserted_On = System.DateTime.Now;
                objAcq_Rights_Template.EntityState = State.Added;
            }

            objAcq_Rights_Template.Template_Name = formData["txtTemplateName"].ToString().Trim();
            objAcq_Rights_Template.Is_Exclusive = formData["hdnExclusive"].ToString().Trim();
            objAcq_Rights_Template.Is_Title_Language = formData["hdnIs_Title_Language_Right"].ToString().Trim();
            objAcq_Rights_Template.Is_Sublicense = formData["rdoSublicensing"].ToString().Trim();
            objAcq_Rights_Template.SubLicense_Code = Convert.ToInt32(formData["ddlSub_License_Code"]);
            objAcq_Rights_Template.Region_Type = formData["rdoTerritoryType"].ToString().Trim();
            objAcq_Rights_Template.Region_Codes = formData["lbTerritory"].ToString().Trim();
            objAcq_Rights_Template.Platform_Codes = formData["strPlatform"].ToString().Trim();
            objAcq_Rights_Template.Subtitling_Type = formData["rdoSubtitlingLanguage"].ToString().Trim();
            objAcq_Rights_Template.Subtitling_Codes = formData["lbSub_Language"].ToString().Trim();
            objAcq_Rights_Template.Dubbing_Type = formData["rdoDubbingLanguage"].ToString().Trim();
            objAcq_Rights_Template.Dubbing_Codes = formData["lbDub_Language"].ToString().Trim();
            objAcq_Rights_Template.Last_Updated_Time = System.DateTime.Now;

            dynamic resultSet;
            bool isDuplicate = objService.Validate(objAcq_Rights_Template, out resultSet);
            if (isDuplicate)
            {              
                bool isValid = objService.Save(objAcq_Rights_Template, out resultSet);
                if (isValid)
                {
                    lstAcq_Rights_Template_Searched = lstAcq_Rights_Template = new Acq_Rights_Template_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();

                    //int recordLockingCode = Convert.ToInt32(objFormCollection["Record_Code"]);
                    //DBUtil.Release_Record(recordLockingCode);
                    if (ARTCode > 0)
                        message = objMessageKey.Recordupdatedsuccessfully;
                    else
                        message = objMessageKey.RecordAddedSuccessfully;
                }
                else
                {
                    status = "E";
                    message = resultSet;
                }
            }
            else
            {
                status = "E";
                message = resultSet;
            }

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult ActiveDeactiveAcq_Rights_Template(int Acq_Rights_TemplateCode, string doActive)
        {
            string status = "S", message = "Record {ACTION} successfully";        
            Acq_Rights_Template_Service objService = new Acq_Rights_Template_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Acq_Rights_Template objAcq_Rights_Template = objService.GetById(Acq_Rights_TemplateCode);
            objAcq_Rights_Template.Is_Active = doActive;
            objAcq_Rights_Template.EntityState = State.Modified;
            dynamic resultSet;
          
            bool isValid = objService.Save(objAcq_Rights_Template, out resultSet);
            if (isValid)
            {
                lstAcq_Rights_Template.Where(w => w.Acq_Rights_Template_Code == Acq_Rights_TemplateCode).First().Is_Active = doActive;
                lstAcq_Rights_Template_Searched.Where(w => w.Acq_Rights_Template_Code == Acq_Rights_TemplateCode).First().Is_Active = doActive;
            }
            else
            {
                status = "E";
                message = "Cound not {ACTION} record";
            }
            if (doActive == "Y")
                if (status == "E")
                    message = objMessageKey.CouldNotActivatedRecord;
                else
                    message = objMessageKey.Recordactivatedsuccessfully;
            else
            {
                if (status == "E")
                    message = objMessageKey.CouldNotDeactivatedRecord;
                else
                    message = objMessageKey.Recorddeactivatedsuccessfully;
            }         
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

    }
}
