using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Acq_GeneralController : BaseController
    {
        #region --- Properties ---
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
        public int Acq_Deal_Code
        {
            get
            {
                if (Session["Acq_Deal_Code"] == null)
                    Session["Acq_Deal_Code"] = "0";
                return Convert.ToInt32(Session["Acq_Deal_Code"]);
            }
            set { Session["Acq_Deal_Code"] = value; }
        }
        public Acq_Deal objAD_Session
        {
            get
            {
                if (Session[RightsU_Session.SESS_DEAL] == null)
                    Session[RightsU_Session.SESS_DEAL] = new Acq_Deal();

                return (Acq_Deal)Session[RightsU_Session.SESS_DEAL];
            }
            set { Session[RightsU_Session.SESS_DEAL] = value; }
        }
        public Acq_Deal_Service objADS
        {
            get
            {
                if (Session["ADS_Acq_General"] == null)
                    Session["ADS_Acq_General"] = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Service)Session["ADS_Acq_General"];
            }
            set { Session["ADS_Acq_General"] = value; }
        }
        public int Deal_Type_Code
        {
            get;
            set;
        }
        public string Deal_Type_Condition
        {
            get
            {
                return GlobalUtil.GetDealTypeCondition(Deal_Type_Code);
            }
        }
        public int Clone_Acq_Deal_Code
        {
            get
            {
                if (Session["Clone_Acq_Deal_Code"] == null)
                    Session["Clone_Acq_Deal_Code"] = "0";
                return Convert.ToInt32(Session["Clone_Acq_Deal_Code"]);
            }
            set { Session["Clone_Acq_Deal_Code"] = value; }
        }
        public int closeMovieCount
        {
            get
            {
                if (Session["closeMovieCount"] == null)
                    Session["closeMovieCount"] = "0";
                return Convert.ToInt32(Session["closeMovieCount"]);
            }
            set { Session["closeMovieCount"] = value; }
        }

        private List<Deal_Rights_Title_UDT> lstCloneDealRightsTitle
        {
            get
            {
                if (Session["lstCloneDealRightsTitle"] == null)
                    Session["lstCloneDealRightsTitle"] = new List<Deal_Rights_Title_UDT>();
                return (List<Deal_Rights_Title_UDT>)Session["lstCloneDealRightsTitle"];
            }
            set { Session["lstCloneDealRightsTitle"] = value; }
        }
        private List<Acq_Deal_Movie> lstAcq_Deal_movie
        {
            get
            {
                if (Session["lstAcq_Deal_movie"] == null)
                    Session["lstAcq_Deal_movie"] = new List<Acq_Deal_Movie>();
                return (List<Acq_Deal_Movie>)Session["lstAcq_Deal_movie"];
            }
            set { Session["lstAcq_Deal_movie"] = value; }
        }

        #endregion

        #region --- Actions ---
        public ActionResult Cancel()
        {
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                DBUtil.Release_Record(objDeal_Schema.Record_Locking_Code);
            ClearSession();
            objDeal_Schema = null;
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
                return RedirectToAction("Index", "Acq_List");
            }
        }
        #endregion

        #region --- New Changes ---
        public PartialViewResult Index()
        {
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            Dictionary<string, string> obj_Dictionary_Title = new Dictionary<string, string>();
            if (TempData["QueryString"] != null)
            {
                obj_Dictionary = TempData["QueryString"] as Dictionary<string, string>;
                objDeal_Schema = null;
                if (Convert.ToString(obj_Dictionary["Mode"]).Trim() == GlobalParams.DEAL_MODE_REOPEN)
                    ClearSession();
                Acq_Deal_Code = Convert.ToInt32(obj_Dictionary["Acq_Deal_Code"]);
                objDeal_Schema.Mode = Convert.ToString(obj_Dictionary["Mode"]).Trim();
                objDeal_Schema.Pushback_Text = obj_Dictionary["Pushback_Text"];


            }
            else
            {
                Acq_Deal_Code = objDeal_Schema.Deal_Code;
            }
            if (TempData["TitleData"] != null)
            {
                TempData.Keep("TitleData");
            }
            objDeal_Schema.Page_From = GlobalParams.Page_From_General;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD)
            {
                if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_CLONE && Acq_Deal_Code > 0 && objDeal_Schema.Deal_Code == 0)
                {
                    Acq_Deal objExisting_Acq_Deal = objADS.GetById(Acq_Deal_Code);
                    objAD_Session = CloneAcqDealObject(objExisting_Acq_Deal);
                    Acq_Deal_Code = 0;
                }
                else if (Acq_Deal_Code > 0)
                    objAD_Session = objADS.GetById(Acq_Deal_Code);
            }
            else
            {
                objAD_Session.Is_Master_Deal = "Y";
                objAD_Session.Agreement_Date = DateTime.Now;
                objAD_Session.Deal_Type_Code = GlobalParams.Deal_Type_Movie;
                objAD_Session.Year_Type = "DY";

                ViewBag.Deal_Mode = GlobalParams.DEAL_MODE_ADD;
            }

            objDeal_Schema.Module_Rights_List = new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Security_Group_Code == objLoginUser.Security_Group_Code
                            && i.System_Module_Rights_Code == i.System_Module_Right.Module_Right_Code
                            && i.System_Module_Right.Module_Code == 30)
                .Select(i => i.System_Module_Right.Right_Code).Distinct().ToList();

            BindSchemaObject();
            string viewName = "~/Views/Acq_Deal/_Acq_General.cshtml";
            string temp = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Gen_Deal_Segment").Select(x => x.Parameter_Value).FirstOrDefault();
            ViewBag.DealSegment = temp;


            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ARCHIVE && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_APPROVE && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_EDIT_WO_APPROVAL)
            {
                ViewBag.Deal_Mode = objDeal_Schema.Mode;
                if (objAD_Session.Deal_Workflow_Status != null)
                    if (Convert.ToString(objAD_Session.Deal_Workflow_Status).Trim() == GlobalParams.dealWorkFlowStatus_Approved)
                    {
                        objAD_Session.Version = (Convert.ToInt32(Convert.ToDouble(objAD_Session.Version)) + 1).ToString("0000");
                        objAD_Session.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_Ammended;
                        objAD_Session.Amendment_Date = DateTime.Now;
                    }

                ViewBag.DealTypeCode_MasterDeal = 0;
                if (objAD_Session.Is_Master_Deal.Equals("N"))
                    ViewBag.DealTypeCode_MasterDeal = (new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Acq_Deal_Movie_Code == objAD_Session.Master_Deal_Movie_Code_ToLink).Select(s => (int)s.Acq_Deal.Deal_Type_Code).FirstOrDefault();

                if (objAD_Session.Deal_Tag_Code == null)
                    objAD_Session.Deal_Tag_Code = 0;

                if (objAD_Session.Is_Master_Deal == null)
                    objAD_Session.Is_Master_Deal = "Y";

                if (objAD_Session.Master_Deal_Movie_Code_ToLink == null)
                    objAD_Session.Master_Deal_Movie_Code_ToLink = 0;

                if (objAD_Session.Deal_Type_Code == null)
                    objAD_Session.Deal_Type_Code = GlobalParams.Deal_Type_Movie;

                BindAllPreReq();
            }
            else
            {
                objDeal_Schema.List_Deal_Tag = new SelectList(new Deal_Tag_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true), "Deal_Tag_Code", "Deal_Tag_Description", objAD_Session.Deal_Tag_Code == 0 ? 1 : objAD_Session.Deal_Tag_Code).ToList();

                if (objAD_Session.Master_Deal_Movie_Code_ToLink == null)
                    objAD_Session.Master_Deal_Movie_Code_ToLink = 0;

                viewName = "~/Views/Acq_Deal/_Acq_General_View.cshtml";
            }
            ViewBag.Record_Locking_Code = 0;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                if (TempData["QueryString"] != null && obj_Dictionary["RLCode"] != null && obj_Dictionary["RLCode"] != "")
                {
                    objDeal_Schema.Record_Locking_Code = Convert.ToInt32(obj_Dictionary["RLCode"]);
                    ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
                }
            }

            #region --- Bind Title Search DropDownList ---
            List<SelectListItem> lstTitleSearch = GetTitleSearchList();
            ViewBag.Title_Search_List = lstTitleSearch;
            #endregion

            if (string.IsNullOrEmpty(objDeal_Schema.General_Search_Title_Codes))
                objDeal_Schema.General_Search_Title_Codes = "";

            SearchTitle(objDeal_Schema.General_Search_Title_Codes);

            Session["FileName"] = "";
            // TempData.Remove("FileName");

            Acq_Deal_Tab_Version objADTV = null;
            List<Acq_Deal_Tab_Version> lstADT = new Acq_Deal_Tab_Version_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == objAD_Session.Acq_Deal_Code).ToList();
            if (lstADT.Count != 0)
                objADTV = lstADT.LastOrDefault();
            if (objADTV != null)
                objDeal_Schema.EWA_Remark = objADTV.Remarks;
            Session["FileName"] = "acq_General";
            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_EDIT_WO_APPROVAL && Session["EditWOA"] == "Y")
            {
                objUSP_Service.USP_Edit_Without_Approval(objDeal_Schema.Deal_Code, "EWA", objLoginUser.Users_Code, "");
                Session["EditWOA"] = "N";
                var controller = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.Acq_Run_ListController>();
                controller.ControllerContext = new ControllerContext(Request.RequestContext, controller);
                return controller.Index("",objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            }
            else
                return PartialView(viewName, objAD_Session);
        }
        public PartialViewResult BindTopAcqDetails()
        {
            ViewBag.DealDesc = new SelectList(new Deal_Description_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Type == "A" && x.Deal_Desc_Name != objDeal_Schema.Deal_Desc).Distinct().ToList(), "Deal_Desc_Code", "Deal_Desc_Name",objDeal_Schema.Deal_Desc);
            ViewBag.AcqSyn_Gen_Deal_Desc = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Gen_Deal_Desc_DDL").First().Parameter_Value; //.Select(x=>x.Parameter_Value="Y").                                                                                                                                                                                                
            //catch
            //{
            //    ViewBag.AcqSyn_Rights_Thetrical = "Y";
            //}

            return PartialView("~/Views/Shared/_Top_Acq_Details.cshtml");
        }
        #endregion

        #region --- Bind Methods ---
        private void BindSchemaObject(bool BindOnlyTitleList = false)
        {
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            if (TempData["QueryString"] != null)
                obj_Dictionary = TempData["QueryString"] as Dictionary<string, string>;
            if (!BindOnlyTitleList)
            {
                objDeal_Schema.Agreement_Date = objAD_Session.Agreement_Date;

                if (objAD_Session.Deal_Type_Code != null)
                    objDeal_Schema.Deal_Type_Code = (int)objAD_Session.Deal_Type_Code;

                if (objAD_Session.Acq_Deal_Code > 0)
                {
                    objDeal_Schema.Deal_Code = objAD_Session.Acq_Deal_Code;
                    objDeal_Schema.Agreement_No = objAD_Session.Agreement_No;
                    objDeal_Schema.Deal_Desc = objAD_Session.Deal_Desc;
                    objDeal_Schema.Version = objAD_Session.Version;

                    if (objAD_Session.Deal_Tag != null)
                        objDeal_Schema.Status = objAD_Session.Deal_Tag.Deal_Tag_Description;
                    else
                        objDeal_Schema.Status = new Deal_Tag_Service(objLoginEntity.ConnectionStringName).GetById((int)objAD_Session.Deal_Tag_Code).Deal_Tag_Description;

                    objDeal_Schema.Year_Type = objAD_Session.Year_Type;
                    objDeal_Schema.Deal_Workflow_Flag = Convert.ToString(objAD_Session.Deal_Workflow_Status).Trim();

                    int[] arrTitleCodes = objAD_Session.Acq_Deal_Movie.Select(x => (int)x.Title_Code).Distinct().ToArray();
                    string titleImagePath = ConfigurationManager.AppSettings["TitleImagePath"];
                    if (arrTitleCodes.Length == 1)
                        objDeal_Schema.Title_Image_Path = titleImagePath + new Title_Service(objLoginEntity.ConnectionStringName).GetById(arrTitleCodes[0]).Title_Image;
                    else
                    {
                        objDeal_Schema.Title_Image_Path = titleImagePath + "movieIcon.png";
                    }


                    if (string.IsNullOrEmpty(objAD_Session.Deal_Complete_Flag))
                        objAD_Session.Deal_Complete_Flag = "";

                    if (TempData["QueryString"] != null && obj_Dictionary["RLCode"] != null)
                        objDeal_Schema.Record_Locking_Code = Convert.ToInt32(obj_Dictionary["RLCode"]);
                    if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_ADD && objAD_Session.Acq_Deal_Code > 0)
                        objDeal_Schema.Mode = GlobalParams.DEAL_MODE_EDIT;
                    objDeal_Schema.Deal_Type_Condition = GlobalUtil.GetDealTypeCondition((int)objAD_Session.Deal_Type_Code);
                    objDeal_Schema.Master_Deal_Movie_Code = (objAD_Session.Master_Deal_Movie_Code_ToLink == null) ? 0 : (int)objAD_Session.Master_Deal_Movie_Code_ToLink;
                }
                else
                {
                    objDeal_Schema.Agreement_No = "";
                    objDeal_Schema.Version = "0001";
                    objDeal_Schema.Deal_Workflow_Flag = "O";

                    if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_CLONE)
                    {
                        var lstVendor = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").Select(x => new { x.Vendor_Code, x.Vendor_Name }).ToList();
                        string currency_Name = new Currency_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Currency_Code == objAD_Session.Currency_Code).Select(x => x.Currency_Name).FirstOrDefault(); 
                        string category_Name = new Category_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Category_Code == objAD_Session.Category_Code).Select(x => x.Category_Name).FirstOrDefault();
                        string Role_Name = new Role_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Role_Code == objAD_Session.Role_Code).Select(x => x.Role_Name).FirstOrDefault();
                        string entity_Name = new Entity_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Entity_Code == objAD_Session.Entity_Code).Select(x => x.Entity_Name).FirstOrDefault();

                        string Vendor_Name = "";
                        foreach (var item in objAD_Session.Acq_Deal_Licensor)
                        {
                            string temp = lstVendor.Where(x => x.Vendor_Code == item.Vendor_Code).Select(x => x.Vendor_Name.ToString()).FirstOrDefault();
                            Vendor_Name = Vendor_Name + temp + ", ";
                        }
                        Vendor_Name = Vendor_Name.Substring(0, Vendor_Name.Length - 2);
                        ViewBag.Vendor_Name = Vendor_Name;
                        ViewBag.Role_Name = Role_Name;
                        ViewBag.entity_Name = entity_Name;
                        ViewBag.Currency_Name = currency_Name;
                        ViewBag.Category_Name = category_Name;

                        objDeal_Schema.Deal_Desc = objAD_Session.Deal_Desc;
                        objDeal_Schema.Agreement_Date = objAD_Session.Agreement_Date;
                    }
                }

                if (TempData["QueryString"] != null && obj_Dictionary["PageNo"] != null)
                    objDeal_Schema.PageNo = Convert.ToInt32(obj_Dictionary["PageNo"].ToString());
                //objDeal_Schema.PageNo = Convert.ToInt32(obj_Dictionary["PageNo"] != null ? obj_Dictionary["PageNo"].ToString() : "1");
                if (TempData["QueryString"] != null && obj_Dictionary["RLCode"] != null)
                    objDeal_Schema.Record_Locking_Code = Convert.ToInt32(obj_Dictionary["RLCode"]);
            }
            objDeal_Schema.Arr_Title_Codes = objAD_Session.Acq_Deal_Movie.Where(x => x.Is_Closed != "X" && x.Is_Closed != "Y").Select(s => Convert.ToInt32(s.Title_Code)).ToArray();
            objDeal_Schema.Title_List.Clear();

            string toolTip;
            GetIconPath(objDeal_Schema.Deal_Type_Code, out toolTip);

            foreach (Acq_Deal_Movie objADM in objAD_Session.Acq_Deal_Movie)
            {
                if (objADM.Is_Closed != "Y" && objADM.Is_Closed != "X")
                {
                    Title_List objTL = new Title_List();

                    objTL.Acq_Deal_Movie_Code = objADM.Acq_Deal_Movie_Code;
                    objTL.Title_Code = (int)objADM.Title_Code;

                    if (objADM.Episode_Starts_From != null)
                        objTL.Episode_From = (int)objADM.Episode_Starts_From;
                    if (objADM.Episode_End_To != null)
                        objTL.Episode_To = (int)objADM.Episode_End_To;

                    objDeal_Schema.Title_List.Add(objTL);
                }
            }
        }
        public PartialViewResult BindTopBand(int dealTypeCode, string dealDesc, string agreementDate, int dealTagCode, string IsAmort)
        { 
            objDeal_Schema.Deal_Type_Code = dealTypeCode;
            objDeal_Schema.Agreement_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(agreementDate));
            objDeal_Schema.Deal_Desc = dealDesc;
            objDeal_Schema.Deal_Tag_Code = dealTagCode;
            ViewBag.IsAmort = IsAmort;
            return PartialView("~/Views/Shared/_Top_Acq_Details.cshtml");
        }
        private List<SelectListItem> GetVendorContactList(int vendorCode, bool isSelect = true)
        {
            List<SelectListItem> lstVendor_Contacts = new SelectList(new Vendor_Contacts_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Vendor_Code > 0 && x.Vendor_Code == vendorCode),
                "Vendor_Contacts_Code", "Contact_Name").OrderBy(o => o.Text).ToList();
            if (isSelect)
                lstVendor_Contacts.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
            return lstVendor_Contacts;
        }
        private void BindAllPreReq()
        {
            //DTG,ROL,DTP,MDS,DTC,CTG,ENT,BUT,CUR,VEN
            List<USP_Get_Acq_PreReq_Result> lstUSP_Get_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName)
                .USP_Get_Acq_PreReq("DTG,DTC,ROL,DTP", "GEN", objLoginUser.Users_Code, Acq_Deal_Code, 0, 0).ToList();
            objDeal_Schema.List_Deal_Tag = new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "DTG"), "Display_Value", "Display_Text", objAD_Session.Deal_Tag_Code == 0 ? 1 : objAD_Session.Deal_Tag_Code).ToList();

            #region --- Deal Type (Master / Sub) Radio ---
            SelectListItem liMaster = new SelectListItem() { Value = "Y", Text = objMessageKey.MasterDeal, Selected = true };
            SelectListItem liSub = new SelectListItem() { Value = "N", Text = objMessageKey.SubDeal, Selected = false };
            List<SelectListItem> lstMasterDealType = new List<SelectListItem>();
            lstMasterDealType.Add(liMaster);
            lstMasterDealType.Add(liSub);
            ViewBag.Master_Sub_Deal_Type_List = lstMasterDealType;
            #endregion

            #region --- Mode of Acquisition ---
            ViewBag.Mode_Acquisition_list = new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "ROL"), "Display_Value", "Display_Text").ToList();

            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_ADD)
                if (ViewBag.Mode_Acquisition_list.Count > 0)
                    objAD_Session.Role_Code = Convert.ToInt32(ViewBag.Mode_Acquisition_list[0].Value);
            #endregion

            #region --- Deal For ---
            ViewBag.Deal_For_List = new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "DTP"), "Display_Value", "Display_Text").ToList();

            if (ViewBag.Deal_For_List.Count > 0)
                ViewBag.Deal_For_List[0].Selected = true;

            ViewBag.Other_Deal_Type_List = new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "DTC"), "Display_Value", "Display_Text").ToList();

            #endregion

            #region --- Bind Vendor Contact Metadata Data ---
            ViewBag.Vendor_Phone = "";
            ViewBag.Vendor_Email = "";
            if (objAD_Session.Vendor_Contacts != null)
            {
                ViewBag.Vendor_Phone = objAD_Session.Vendor_Contacts.Phone_No;
                ViewBag.Vendor_Email = objAD_Session.Vendor_Contacts.Email;
            }
            #endregion

            string temp = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Gen_Deal_Segment").Select(x => x.Parameter_Value).FirstOrDefault();
            ViewBag.DealSegment = temp;
            if (temp == "Y")
            {
                ViewBag.Deal_Segment = new SelectList(new Deal_Segment_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true), "Deal_Segment_Code", "Deal_Segment_Name").ToList();
            }
        }
        public JsonResult BindAllPreReq_Async()
        {
            List<USP_Get_Acq_PreReq_Result> lstUSP_Get_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Acq_PreReq("MDS,CTG,ENT,BUT,CUR,VEN,VPC", "GEN", objLoginUser.Users_Code, Acq_Deal_Code, 0, 0).ToList();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Category_List", new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "CTG"), "Display_Value", "Display_Text").ToList());
            obj.Add("Category_Code", objAD_Session.Category_Code ?? 0);
            obj.Add("Licensee_List", new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "ENT"), "Display_Value", "Display_Text").ToList());
            obj.Add("Entity_Code", objAD_Session.Entity_Code ?? 0);
            obj.Add("Business_Unit_List", new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "BUT"), "Display_Value", "Display_Text").ToList());
            obj.Add("Business_Unit_Code", objAD_Session.Business_Unit_Code ?? 0);
            obj.Add("Currency_List", new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "CUR"), "Display_Value", "Display_Text").ToList());
            obj.Add("Currency_Code", objAD_Session.Currency_Code ?? 0);
            obj.Add("Licensor_List", new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "VEN"), "Display_Value", "Display_Text").OrderBy(o => o.Text).ToList());
            obj.Add("Vendor_Codes", string.Join(",", objAD_Session.Acq_Deal_Licensor.Select(s => s.Vendor_Code.ToString())));
            obj.Add("Master_Deal_List", new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "MDS"), "Display_Value", "Display_Text").ToList());
            obj.Add("Master_Deal_Movie_Code", objAD_Session.Master_Deal_Movie_Code_ToLink ?? 0);
            obj.Add("Vendor_Contact_List", new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "VPC"), "Display_Value", "Display_Text").ToList());
            obj.Add("Vendor_Contact_Code", objAD_Session.Vendor_Contacts_Code);
            obj.Add("Deal_Desc_Name", objAD_Session.Deal_Desc);
            return Json(obj);
        }
        private List<Acq_Deal_Movie> GetAcqDealMovieList(int pageNo, int recordPerPage)
        {
            if (lstAcq_Deal_movie.Count == 0)
                SearchTitle("");

            List<Acq_Deal_Movie> lst = null;
            int RecordCount = 0;
            RecordCount = lstAcq_Deal_movie.Count;

            objDeal_Schema.General_PageNo = pageNo;
            objDeal_Schema.General_PageSize = recordPerPage;

            if (RecordCount > 0)
            {
                int cnt = pageNo * recordPerPage;
                if (cnt >= RecordCount)
                {
                    int v1 = RecordCount / recordPerPage;
                    if ((v1 * recordPerPage) == RecordCount)
                        pageNo = v1;
                    else
                        pageNo = v1 + 1;
                }
                int noOfRecordSkip = recordPerPage * (pageNo - 1);
                int noOfRecordTake = 0;
                if (RecordCount < (noOfRecordSkip + recordPerPage))
                    noOfRecordTake = RecordCount - noOfRecordSkip;
                else
                    noOfRecordTake = recordPerPage;

                lst = lstAcq_Deal_movie.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                objDeal_Schema.General_PageNo = pageNo;
            }

            return lst;
        }
        public JsonResult BindTitlePopup(int MasterDealMovieCode, int dealTypeCode, int replacingTitleCode)
        {
            objAD_Session.Master_Deal_Movie_Code_ToLink = MasterDealMovieCode;
            string SelectedTitle = string.Join(",", objAD_Session.Acq_Deal_Movie.Where(w => w.EntityState != State.Deleted && w.Title_Code != replacingTitleCode).Select(s => Convert.ToInt32(s.Title_Code)).ToArray());
            Deal_Type_Code = dealTypeCode;

            int acqDealCode = Acq_Deal_Code;
            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_CLONE)
                acqDealCode = Clone_Acq_Deal_Code;

            List<SelectListItem> lstTitlePopup = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_Populate_Titles(acqDealCode, Deal_Type_Code, MasterDealMovieCode, SelectedTitle, "A"), "Title_Code", "Title_Name").OrderBy(o => o.Text).ToList();
            return Json(lstTitlePopup, JsonRequestBehavior.AllowGet);
        }
        public PartialViewResult BindTitleGridview(int dealTypeCode, int masterDealMovieCode, int pageNo, int recordPerPage)
        {
            Deal_Type_Code = dealTypeCode;
            ViewBag.Title_Label = GetTitleLabel(Deal_Type_Code);
            ViewBag.Deal_Type_Code = dealTypeCode;
            //ViewBag.Deal_Mode = objDeal_Schema.Mode;
            ViewBag.Deal_Mode = objAD_Session.Is_Auto_Push == "Y" ? "V" : objDeal_Schema.Mode;

            ViewBag.DealTypeCode_MasterDeal = 0;
            if (masterDealMovieCode > 0)
                ViewBag.DealTypeCode_MasterDeal = (new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Acq_Deal_Movie_Code == masterDealMovieCode).Select(s => (int)s.Acq_Deal.Deal_Type_Code).FirstOrDefault();

            var IsMovieType_Premier = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "IsMovieType_Premier").Select(w => w.Parameter_Value).SingleOrDefault();
            ViewBag.IsMovieType_Premier = IsMovieType_Premier;

            List<Acq_Deal_Movie> lst = GetAcqDealMovieList(pageNo, recordPerPage);
            return PartialView("~/Views/Acq_Deal/_List_General_Title.cshtml", lst);
        }
        public JsonResult BindTitleLabel(int dealTypeCode)
        {
            Deal_Type_Code = dealTypeCode;
            string Title_Label = GetTitleLabel(Deal_Type_Code);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Title_Count", objAD_Session.Acq_Deal_Movie.Where(x => x.EntityState != State.Deleted).Count());
            obj.Add("Title_Label", Title_Label);
            obj.Add("Record_Count", lstAcq_Deal_movie.Count);
            obj.Add("Title_Search_List", GetTitleSearchList());
            return Json(obj);
        }
        public JsonResult BindContactDropDown(int vendorCode)
        {
            List<SelectListItem> lstVendor_Contacts = GetVendorContactList(vendorCode);
            return Json(lstVendor_Contacts, JsonRequestBehavior.AllowGet);
        }
        public JsonResult BindPrimaryContactDetail(int vendorContactCode)
        {
            string strPhone = "", strEmail = "";
            if (vendorContactCode > 0)
            {
                Vendor_Contacts objVC = new Vendor_Contacts_Service(objLoginEntity.ConnectionStringName).GetById(vendorContactCode);
                strPhone = objVC.Phone_No;
                strEmail = objVC.Email;
            }

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Vendor_Phone", strPhone);
            obj.Add("Vendor_Email", strEmail);

            return Json(obj);
        }
        public JsonResult PopulateMasterDealData(int currentADMCode, int priviousADMCode)
        {
            int Currency_Code = 0, Entity_Code = 0, Business_Unit_Code = 0, Category_Code = 0, Vendor_Code = 0, Vendor_Contact_Code = 0;
            string Selected_Vendor_Codes = "";

            if (priviousADMCode > 0)
            {
                Acq_Deal objAD_Privious = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).GetById(priviousADMCode).Acq_Deal;
                int[] arrVendorCodes = objAD_Privious.Acq_Deal_Licensor.Select(s => Convert.ToInt32(s.Vendor_Code)).Distinct().ToArray();

                if (objAD_Session.Currency_Code == objAD_Privious.Currency_Code)
                {
                    objAD_Session.Currency_Code = 0;
                    Currency_Code = 0;
                }
                if (objAD_Session.Entity_Code == objAD_Privious.Entity_Code)
                {
                    objAD_Session.Entity_Code = 0;
                    Entity_Code = 0;
                }

                if (objAD_Session.Business_Unit_Code == objAD_Privious.Business_Unit_Code)
                {
                    objAD_Session.Business_Unit_Code = 0;
                    Business_Unit_Code = 0;
                }

                if (objAD_Session.Category_Code == objAD_Privious.Category_Code)
                {
                    objAD_Session.Category_Code = 0;
                    Category_Code = 0;
                }

                foreach (Acq_Deal_Licensor objADL in objAD_Session.Acq_Deal_Licensor.ToArray())
                {
                    if (arrVendorCodes.Contains((int)objADL.Vendor_Code))
                        objAD_Session.Acq_Deal_Licensor.Remove(objADL);
                }

                if (arrVendorCodes.Contains((int)objAD_Session.Vendor_Code))
                {
                    objAD_Session.Vendor_Code = 0;
                    Vendor_Code = 0;
                }

                Selected_Vendor_Codes = string.Join(",", objAD_Session.Acq_Deal_Licensor.Select(s => s.Vendor_Code));

                if (objAD_Session.Vendor_Contacts_Code == objAD_Privious.Vendor_Contacts_Code)
                {
                    objAD_Session.Vendor_Contacts_Code = 0;
                }

            }

            if (currentADMCode > 0)
            {
                Acq_Deal objAD_Current = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).GetById(currentADMCode).Acq_Deal;
                int[] arrVendorCodes = objAD_Current.Acq_Deal_Licensor.Select(s => Convert.ToInt32(s.Vendor_Code)).Distinct().ToArray();

                objAD_Session.Entity_Code = objAD_Current.Entity_Code;
                Entity_Code = (int)objAD_Session.Entity_Code;

                objAD_Session.Currency_Code = objAD_Current.Currency_Code;
                Currency_Code = (int)objAD_Session.Currency_Code;

                objAD_Session.Business_Unit_Code = objAD_Current.Business_Unit_Code;
                Business_Unit_Code = (int)objAD_Session.Business_Unit_Code;

                objAD_Session.Category_Code = objAD_Current.Category_Code;
                Category_Code = (int)objAD_Session.Category_Code;

                objAD_Session.Vendor_Code = objAD_Current.Vendor_Code;
                Vendor_Code = (int)objAD_Session.Vendor_Code;

                foreach (int vendorCode in arrVendorCodes)
                {
                    int count = objAD_Session.Acq_Deal_Licensor.Where(s => s.Vendor_Code == vendorCode).Count();
                    if (count <= 0)
                    {
                        Acq_Deal_Licensor objADL = new Acq_Deal_Licensor();
                        objADL.EntityState = State.Added;
                        objADL.Vendor_Code = vendorCode;
                        objAD_Session.Acq_Deal_Licensor.Add(objADL);
                    }
                }

                Selected_Vendor_Codes = string.Join(",", objAD_Session.Acq_Deal_Licensor.Select(s => s.Vendor_Code));

                objAD_Session.Vendor_Contacts_Code = objAD_Current.Vendor_Contacts_Code;
                Vendor_Contact_Code = (int)objAD_Session.Vendor_Contacts_Code;
            }

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Entity_Code", Entity_Code);
            obj.Add("Currency_Code", Currency_Code);
            obj.Add("Business_Unit_Code", Business_Unit_Code);
            obj.Add("Category_Code", Category_Code);
            obj.Add("Vendor_Code", Vendor_Code);
            obj.Add("Selected_Vendor_Codes", Selected_Vendor_Codes);
            obj.Add("Vendor_Contact_Code", Vendor_Contact_Code);
            return Json(obj);
        }
        #endregion

        #region --- Title Search ---
        private List<SelectListItem> GetTitleSearchList()
        {
            string[] arrSelectedTitle = (string.Join(",", objAD_Session.Acq_Deal_Movie.Where(w => w.EntityState != State.Deleted).Select(s => Convert.ToInt32(s.Title_Code)).ToArray())).Split(',');
            List<SelectListItem> lstTitleSearch = new SelectList(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrSelectedTitle.Contains(x.Title_Code.ToString())).Distinct(), "Title_Code", "Title_Name").OrderBy(o => o.Text).ToList();
            return lstTitleSearch;
        }
        public JsonResult SearchTitle(string selectedTitleCodes)
        {
            objDeal_Schema.General_Search_Title_Codes = selectedTitleCodes;
            string[] arrSelectedTitleCodes = selectedTitleCodes.Split(',');
            if (string.IsNullOrEmpty(selectedTitleCodes))
                lstAcq_Deal_movie = objAD_Session.Acq_Deal_Movie.Where(x => x.EntityState != State.Deleted).OrderBy(t => t.Title.Title_Name).ToList();
            else
                lstAcq_Deal_movie = objAD_Session.Acq_Deal_Movie.Where(x => x.EntityState != State.Deleted && arrSelectedTitleCodes.Contains(x.Title_Code.ToString())).OrderBy(t => t.Title.Title_Name).ToList();

            int recordCount = lstAcq_Deal_movie.Count;

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", "S");
            obj.Add("Record_Count", recordCount);
            return Json(obj);
        }
        #endregion

        #region --- Other Methods ---
        private Acq_Deal CloneAcqDealObject(Acq_Deal objExisting_Acq_Deal)
        {
            Clone_Acq_Deal_Code = objExisting_Acq_Deal.Acq_Deal_Code;
            objAD_Session.Agreement_Date = objExisting_Acq_Deal.Agreement_Date;
            objAD_Session.All_Channel = objExisting_Acq_Deal.All_Channel;
            objAD_Session.Business_Unit_Code = objExisting_Acq_Deal.Business_Unit_Code;
            objAD_Session.Category_Code = objExisting_Acq_Deal.Category_Code;
            objAD_Session.Content_Type = objExisting_Acq_Deal.Content_Type;
            objAD_Session.Cost_Center_Id = objExisting_Acq_Deal.Cost_Center_Id;
            objAD_Session.Currency_Code = objExisting_Acq_Deal.Currency_Code;
            objAD_Session.Deal_Complete_Flag = objExisting_Acq_Deal.Deal_Complete_Flag;
            objAD_Session.Deal_Desc = objExisting_Acq_Deal.Deal_Desc;
            objAD_Session.Deal_Tag_Code = objExisting_Acq_Deal.Deal_Tag_Code;
            objAD_Session.Deal_Type_Code = objExisting_Acq_Deal.Deal_Type_Code;
            objAD_Session.Deal_Type1 = objExisting_Acq_Deal.Deal_Type1;
            objAD_Session.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_New;
            objAD_Session.Entity_Code = objExisting_Acq_Deal.Entity_Code;
            objAD_Session.Exchange_Rate = objExisting_Acq_Deal.Exchange_Rate;
            objAD_Session.Is_Active = objExisting_Acq_Deal.Is_Active;
            objAD_Session.Is_Auto_Generated = objExisting_Acq_Deal.Is_Auto_Generated;
            objAD_Session.Is_Completed = objExisting_Acq_Deal.Is_Completed;
            objAD_Session.Is_Master_Deal = objExisting_Acq_Deal.Is_Master_Deal;
            objAD_Session.Is_Migrated = objExisting_Acq_Deal.Is_Migrated;
            objAD_Session.Is_Released = objExisting_Acq_Deal.Is_Released;
            objAD_Session.Master_Deal_Movie_Code_ToLink = objExisting_Acq_Deal.Master_Deal_Movie_Code_ToLink;
            objAD_Session.Parent_Deal_Code = objExisting_Acq_Deal.Parent_Deal_Code;
            objAD_Session.Payment_Remarks = objExisting_Acq_Deal.Payment_Remarks;
            objAD_Session.Payment_Terms_Conditions = objExisting_Acq_Deal.Payment_Terms_Conditions;
            objAD_Session.Ref_BMS_Code = objExisting_Acq_Deal.Ref_BMS_Code;
            objAD_Session.Ref_No = objExisting_Acq_Deal.Ref_No;
            objAD_Session.Remarks = objExisting_Acq_Deal.Remarks;
            objAD_Session.Rights_Remarks = objExisting_Acq_Deal.Rights_Remarks;
            objAD_Session.Role_Code = objExisting_Acq_Deal.Role_Code;
            objAD_Session.SaveGeneralOnly = objExisting_Acq_Deal.SaveGeneralOnly;
            objAD_Session.Status = objExisting_Acq_Deal.Status;
            objAD_Session.Validate_CostWith_Budget = objExisting_Acq_Deal.Validate_CostWith_Budget;
            objAD_Session.Vendor_Code = objExisting_Acq_Deal.Vendor_Code;
            objAD_Session.Vendor_Contacts_Code = objExisting_Acq_Deal.Vendor_Contacts_Code;
            objAD_Session.Version = "0001";
            objAD_Session.Work_Flow_Code = objExisting_Acq_Deal.Work_Flow_Code;
            objAD_Session.Year_Type = objExisting_Acq_Deal.Year_Type;
            objAD_Session.Is_Auto_Push = objExisting_Acq_Deal.Is_Auto_Push;
            objAD_Session.Deal_Segment_Code = objExisting_Acq_Deal.Deal_Segment_Code;
            objAD_Session.Deal_Segment = objExisting_Acq_Deal.Deal_Segment;
            objExisting_Acq_Deal.Acq_Deal_Movie.ToList().ForEach(a =>
            {
                Acq_Deal_Movie objADM = new Acq_Deal_Movie();
                objADM.Title_Code = a.Title_Code;
                objADM.Title = new Title_Service(objLoginEntity.ConnectionStringName).GetById((int)a.Title_Code);
                objADM.No_Of_Episodes = a.No_Of_Episodes;
                objADM.Notes = a.Notes;
                objADM.No_Of_Files = a.No_Of_Files;
                objADM.Is_Closed = a.Is_Closed;
                objADM.Title_Type = a.Title_Type;
                objADM.Amort_Type = a.Amort_Type;
                objADM.Episode_Starts_From = a.Episode_Starts_From;
                objADM.Remark = a.Remark;
                objADM.Ref_BMS_Movie_Code = a.Ref_BMS_Movie_Code;
                objADM.Episode_End_To = a.Episode_End_To;
                objADM.EntityState = State.Added;
                objADM.Is_Closed = "N";
                objADM.Movie_Closed_Date = null;

                objAD_Session.Acq_Deal_Movie.Add(objADM);

                Deal_Rights_Title_UDT objDRT_UDT = new Deal_Rights_Title_UDT();
                objDRT_UDT.Deal_Rights_Code = a.Acq_Deal_Movie_Code;
                objDRT_UDT.Title_Code = a.Title_Code;
                objDRT_UDT.Episode_From = a.Episode_Starts_From;
                objDRT_UDT.Episode_To = a.Episode_End_To;
                lstCloneDealRightsTitle.Add(objDRT_UDT);
            }
                );


            objExisting_Acq_Deal.Acq_Deal_Licensor.ToList().ForEach(l =>
            {
                Acq_Deal_Licensor licensorInstance = new Acq_Deal_Licensor();
                licensorInstance.Vendor_Code = l.Vendor_Code;
                licensorInstance.EntityState = State.Added;
                objAD_Session.Acq_Deal_Licensor.Add(licensorInstance);
            }
                );

            return objAD_Session;
        }
        protected List<T> CompareLists<T>(List<T> FirstList,
                                          List<T> SecondList,
                                          IEqualityComparer<T> comparer,
                                          ref List<T> DelResult) where T : class
        {

            var AddResult = FirstList.Except(SecondList, comparer);
            var DeleteResult = SecondList.Except(FirstList, comparer);

            DelResult = DeleteResult.ToList<T>();

            return AddResult.ToList<T>();
        }
        private string GetIconPath(int dealTypeCode, out string titleIconTooltip)
        {
            dealTypeCode = (dealTypeCode == 0) ? 1 : dealTypeCode;
            string iconPath = ConfigurationManager.AppSettings["TitleImagePath"].TrimStart('~').TrimStart('/');
            string fileName = ConfigurationManager.AppSettings["DefaultTitleIcon"];
            if (objAD_Session.Acq_Deal_Movie.Where(w => w.EntityState != State.Deleted).Select(i => i.Title_Code).Distinct().Count() == 1)
            {
                int title_Code = (int)objAD_Session.Acq_Deal_Movie.Where(w => w.EntityState != State.Deleted).First().Title_Code;
                RightsU_Entities.Title objT = new Title_Service(objLoginEntity.ConnectionStringName).GetById(title_Code);

                if (!string.IsNullOrEmpty(objT.Title_Image))
                    fileName = objT.Title_Image;
            }

            iconPath += fileName;
            Deal_Type_Code = dealTypeCode;
            objDeal_Schema.Title_Icon_Path = fileName;
            objDeal_Schema.Title_Icon_Tooltip = "Deal Type - " + GetTitleLabel(Deal_Type_Code);

            titleIconTooltip = objDeal_Schema.Title_Icon_Tooltip;
            return iconPath;
        }
        private string GetTitleLabel(int dealTypeCode)
        {
            Deal_Type_Code = dealTypeCode;
            string Title_Label = "";
            if (Deal_Type_Code == GlobalParams.Deal_Type_Movie)
                Title_Label = objMessageKey.Movie;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Documentary_Film)
                Title_Label = objMessageKey.DocumentaryFilm;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Content)
                Title_Label = objMessageKey.Program;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Event)
                Title_Label = objMessageKey.Event;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Documentary_Show)
                Title_Label = objMessageKey.DealDocumentaryShow;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Sports)
                Title_Label = objMessageKey.Sports;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Music)
                Title_Label = objMessageKey.EmbeddedMusic;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_ContentMusic)
                Title_Label = objMessageKey.ContentMusic;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Format_Program)
                Title_Label = objMessageKey.FormatProgram;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Performer)
                Title_Label = objMessageKey.Performer;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Writer)
                Title_Label = objMessageKey.Writer;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Music_Composer)
                Title_Label = objMessageKey.MusicComposer;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_DOP)
                Title_Label = objMessageKey.DOP;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Choreographer)
                Title_Label = objMessageKey.Choreographer;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Lyricist)
                Title_Label = objMessageKey.Lyricist;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Director)
                Title_Label = objMessageKey.Director;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_VideoMusic)
                Title_Label = objMessageKey.VideoCompany;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Singer)
                Title_Label = objMessageKey.Singer;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Other_Talent)
                Title_Label = objMessageKey.OtherTalent;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Contestant)
                Title_Label = objMessageKey.ContestantName;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Producer)
                Title_Label = objMessageKey.Producer;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_ShortFlim)
                Title_Label = objMessageKey.DealForShortFilm;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_WebSeries)
                Title_Label = objMessageKey.WebSeries;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Featurette)
                Title_Label = objMessageKey.Featurette;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Cineplay)
                Title_Label = objMessageKey.Cineplay;
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Drama_Play)
                Title_Label = "Drama And Play";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Tele_Film)
                Title_Label = "Tele-Film";

            return Title_Label;
        }
        private void ClearSession()
        {
            objAD_Session = null;
            objADS = null;
            Session["Acq_Deal_Code"] = null;
            Session["Clone_Acq_Deal_Code"] = null;
        }
        #endregion

        #region --- Save ---
        public JsonResult Save(Acq_Deal objAD_MVC, FormCollection objFormCollection)
        {
            string status = "S", mode = "";
            //string agreementDate = objFormCollection["Agreement_Date"];
            string agreementDate = objFormCollection["hdnAgreementDate"];
            string isMasterDeal = objFormCollection["hdnIs_Master_Deal"];
            string masterDealMovieCode = objFormCollection["hdnMaster_Deal_Movie_Code"];
            string dealTypeCode = objFormCollection["hdnDeal_Type_Code"];
            string vendorCodes = objFormCollection["hdnVendorCodes"];
            string primaryVendorCode = objFormCollection["hdnPrimaryVendorCode"];
            string tabName = objFormCollection["hdnTabName"];
            string dealDesc = objFormCollection["hdnDealDesc"];
            int dealTagCode = Convert.ToInt32(objFormCollection["hdnDealTagStatusCode"]);
            string Reopenstate = Convert.ToString(objFormCollection["hdnReopenMode"]);

            #region --- Update Original Object ---
            objAD_MVC.Agreement_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(agreementDate));
            objAD_Session.Agreement_Date = objAD_MVC.Agreement_Date;

            int intdeal = Convert.ToInt32(dealDesc); 

            dealDesc = new Deal_Description_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Desc_Code == intdeal).Select(x=>x.Deal_Desc_Name).First();

            objAD_Session.Deal_Desc = dealDesc; //objAD_MVC.Deal_Desc;
            objAD_Session.Deal_Tag_Code = dealTagCode; //objAD_MVC.Deal_Tag_Code;
            objAD_Session.Role_Code = objAD_MVC.Role_Code;
            objAD_Session.Year_Type = objAD_MVC.Year_Type;
            objAD_Session.Ref_No = objAD_MVC.Ref_No;
            objAD_MVC.Is_Master_Deal = isMasterDeal;
            objAD_Session.Is_Master_Deal = objAD_MVC.Is_Master_Deal;

            objAD_MVC.Master_Deal_Movie_Code_ToLink = Convert.ToInt32(masterDealMovieCode);
            objAD_Session.Master_Deal_Movie_Code_ToLink = objAD_MVC.Master_Deal_Movie_Code_ToLink;
            objAD_MVC.Deal_Type_Code = Convert.ToInt32(dealTypeCode);
            objAD_Session.Deal_Type_Code = objAD_MVC.Deal_Type_Code;
            Deal_Type_Code = (int)objAD_MVC.Deal_Type_Code;

            objAD_MVC.Vendor_Code = Convert.ToInt32(primaryVendorCode);
            objAD_Session.Vendor_Code = objAD_MVC.Vendor_Code;

            objAD_Session.Currency_Code = objAD_MVC.Currency_Code;
            objAD_Session.Entity_Code = objAD_MVC.Entity_Code;
            objAD_Session.Business_Unit_Code = objAD_MVC.Business_Unit_Code;

            objAD_Session.Category_Code = objAD_MVC.Category_Code;

            if(objAD_MVC.Deal_Segment_Code != null && objAD_MVC.Deal_Segment_Code != 0)
                objAD_Session.Deal_Segment_Code = objAD_MVC.Deal_Segment_Code;

            objAD_Session.Vendor_Contacts_Code = objAD_MVC.Vendor_Contacts_Code;
            if (string.IsNullOrEmpty(objAD_MVC.Remarks))
                objAD_MVC.Remarks = "";
            objAD_Session.Remarks = objAD_MVC.Remarks.Replace("\r\n", "\n");

            #endregion

            if (objAD_Session.Acq_Deal_Code > 0)
                objAD_Session.EntityState = State.Modified;
            else
            {
                objAD_Session.EntityState = State.Added;
                objAD_Session.Version = "0001";
                objAD_Session.Inserted_On = DateTime.Now;
                objAD_Session.Inserted_By = objLoginUser.Users_Code;
                objAD_Session.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_New;
            }

            objAD_Session.Status = "O";
            objAD_Session.Content_Type = "";
            Currency_Exchange_Rate objCER = new Currency_Service(objLoginEntity.ConnectionStringName).GetById((int)objAD_Session.Currency_Code).Currency_Exchange_Rate.Where(x => x.System_End_Date == null).FirstOrDefault();

            if (objCER != null && objAD_Session != null)
                objAD_Session.Exchange_Rate = objCER.Exchange_Rate;

            objAD_Session.Last_Action_By = objLoginUser.Users_Code;
            objAD_Session.Last_Updated_Time = DateTime.Now;
            objAD_Session.Is_Active = "Y";

            #region --- Validate on Object  ---

            int masterDeal_dealTypeCode = (new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Acq_Deal_Movie_Code == objAD_Session.Master_Deal_Movie_Code_ToLink).Select(s => (int)s.Acq_Deal.Deal_Type_Code).FirstOrDefault();
            bool returnVal = true;
            string strMessage = "";
            if (returnVal)
            {
                Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
                foreach (Acq_Deal_Movie objADM_MVC in objAD_MVC.Acq_Deal_Movie)
                {
                    Acq_Deal_Movie objADM_Old = objAD_Session.Acq_Deal_Movie.Where(x => x.Dummy_Guid == objADM_MVC.Dummy_Guid).FirstOrDefault();

                    if (objADM_Old.EntityState == State.Deleted)
                        objADM_MVC.EntityState = State.Deleted;
                }
            }
            #endregion
            if (Reopenstate == "RO")
            {
                mode = GlobalParams.DEAL_MODE_EDIT;
                status = "SA";
            }
            else
                mode = objDeal_Schema.Mode;

            if (mode == GlobalParams.DEAL_MODE_REOPEN)
            {
                objDeal_Schema.Deal_Workflow_Flag = Convert.ToString(mode).Trim();
                objAD_Session.Deal_Workflow_Status = Convert.ToString(mode).Trim();
            }
            int pageNo = objDeal_Schema.PageNo;
            int errorPageIndex = 0;
            int pageSize = Convert.ToInt32(objFormCollection["txtPageSize"]);
            if (returnVal)
            {
                UpdateTitleCollection(objAD_MVC.Acq_Deal_Movie.ToList(), true);
                string[] arrErrorGuid = objAD_Session.Acq_Deal_Movie.Where(w => w.EntityState != State.Deleted &&
                               (w.Episode_Starts_From == null ||
                                   (
                                       (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
                                       && w.Episode_End_To == null
                                   ) ||
                                   (Deal_Type_Condition == GlobalParams.Sub_Deal_Talent && masterDeal_dealTypeCode != GlobalParams.Deal_Type_Movie && w.No_Of_Episodes == null)
                              )).Select(s => s.Dummy_Guid).Distinct().ToArray();

                if (arrErrorGuid.Length > 0)
                {
                    lstAcq_Deal_movie = objAD_Session.Acq_Deal_Movie.Where(w => w.EntityState != State.Deleted).OrderBy(o => o.Title.Title_Name).ToList();
                    int[] arrNullTitles = lstAcq_Deal_movie.Where(w => w.EntityState != State.Deleted &&
                        arrErrorGuid.Contains(w.Dummy_Guid)).Select(s => (int)s.Title_Code).Distinct().ToArray();
                    int Object_Index = lstAcq_Deal_movie.FindIndex(w => w.EntityState != State.Deleted &&
                        arrErrorGuid.Contains(w.Dummy_Guid));
                    Object_Index++;

                    errorPageIndex = (Object_Index / pageSize);
                    if ((Object_Index % pageSize) > 0)
                        errorPageIndex++;

                    string strTitleNames = string.Join(", ", new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrNullTitles.Contains(s.Title_Code)).Select(s => s.Title_Name).ToArray());
                    strMessage = "Please enter Episode no. for " + strTitleNames;
                    if (Deal_Type_Code == GlobalParams.Deal_Type_Sports)
                        strMessage = "Please enter No. of Matches for " + strTitleNames;
                    else if (Deal_Type_Code == GlobalParams.Deal_Type_Music || Deal_Type_Code == GlobalParams.Deal_Type_ContentMusic)
                        strMessage = "Please enter No. of Songs for " + strTitleNames;
                    else if (Deal_Type_Condition == GlobalParams.Sub_Deal_Talent)
                        strMessage = "Please enter No. of Appearances for " + strTitleNames;
                    returnVal = false;
                }


                if (returnVal)
                {
                    arrErrorGuid = (from Acq_Deal_Movie objF in objAD_Session.Acq_Deal_Movie.Where(x => x.EntityState != State.Deleted).ToList()
                                    from Acq_Deal_Movie objS in objAD_Session.Acq_Deal_Movie.Where(x => x.EntityState != State.Deleted).ToList()
                                    where objF.Title_Code == objS.Title_Code &&
                                    objF.Episode_Starts_From != null && objS.Episode_Starts_From != null
                                    && objF.Episode_End_To != null && objS.Episode_End_To != null
                                    && objF.Dummy_Guid != objS.Dummy_Guid &&
                                    ((
                                        Deal_Type_Condition == GlobalParams.Deal_Program &&
                                        (
                                            (objF.Episode_Starts_From >= objS.Episode_Starts_From && objF.Episode_Starts_From <= objS.Episode_End_To) ||
                                            (objS.Episode_Starts_From >= objF.Episode_Starts_From && objS.Episode_Starts_From <= objF.Episode_End_To)
                                        )
                                    ) ||
                                    (Deal_Type_Condition == GlobalParams.Deal_Music && (objF.Episode_End_To == objS.Episode_End_To)))
                                    select objF.Dummy_Guid
                     ).Distinct().ToArray();

                    if (arrErrorGuid.Length > 0)
                    {
                        lstAcq_Deal_movie = objAD_Session.Acq_Deal_Movie.Where(w => w.EntityState != State.Deleted).OrderBy(o => o.Title.Title_Name).ToList();
                        int[] arrOverLap = lstAcq_Deal_movie.Where(w => w.EntityState != State.Deleted &&
                            arrErrorGuid.Contains(w.Dummy_Guid)).Select(s => (int)s.Title_Code).Distinct().ToArray();
                        int Object_Index = lstAcq_Deal_movie.FindIndex(w => w.EntityState != State.Deleted &&
                            arrErrorGuid.Contains(w.Dummy_Guid));
                        Object_Index++;

                        errorPageIndex = (Object_Index / pageSize);
                        if ((Object_Index % pageSize) > 0)
                            errorPageIndex++;

                        string strTitleNames = string.Join(", ", new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrOverLap.Contains(s.Title_Code)).Select(s => s.Title_Name).ToArray());
                        strMessage = "Overlapping Episode no. for " + strTitleNames;
                        if (Deal_Type_Code == GlobalParams.Deal_Type_Music || Deal_Type_Code == GlobalParams.Deal_Type_ContentMusic)
                            strMessage = "Duplicate No. of Songs for " + strTitleNames;

                        returnVal = false;
                    }
                }

                if (returnVal)
                {
                    #region --- Add Licensors to List ---
                    string[] arrSelectedVendor = vendorCodes.Split(',');

                    ICollection<Acq_Deal_Licensor> selectVendors = new HashSet<Acq_Deal_Licensor>();
                    foreach (string vendorCode in arrSelectedVendor)
                    {
                        Acq_Deal_Licensor objADL = null;
                        objADL = new Acq_Deal_Licensor();
                        objADL.EntityState = State.Added;
                        objADL.Vendor_Code = Convert.ToInt32(vendorCode);
                        selectVendors.Add(objADL);
                    }

                    IEqualityComparer<Acq_Deal_Licensor> comparerV = new LambdaComparer<Acq_Deal_Licensor>((x, y) => x.Vendor_Code == y.Vendor_Code && x.EntityState != State.Deleted);

                    var Deleted_Acq_Deal_Licensor = new List<Acq_Deal_Licensor>();
                    var Added_Acq_Deal_Licensor = CompareLists<Acq_Deal_Licensor>(selectVendors.ToList<Acq_Deal_Licensor>(), objAD_Session.Acq_Deal_Licensor.ToList<Acq_Deal_Licensor>(), comparerV, ref Deleted_Acq_Deal_Licensor);
                    Added_Acq_Deal_Licensor.ToList<Acq_Deal_Licensor>().ForEach(t => objAD_Session.Acq_Deal_Licensor.Add(t));
                    Deleted_Acq_Deal_Licensor.ToList<Acq_Deal_Licensor>().ForEach(t => t.EntityState = State.Deleted);

                    foreach (Acq_Deal_Licensor objADL in objAD_Session.Acq_Deal_Licensor.ToList<Acq_Deal_Licensor>())
                    {
                        if (objADL.EntityState == State.Deleted && (objADL.Acq_Deal_Code == 0 || objADL.Acq_Deal_Code == null))
                            objAD_Session.Acq_Deal_Licensor.Remove(objADL);
                    }
                    #endregion

                    dynamic resultSet;
                    objAD_Session.Acq_Deal_Movie.Where(w => w.Acq_Deal_Movie_Code <= 0).ToList().ForEach(o => o.Title = null);
                    returnVal = objADS.Save(objAD_Session, out resultSet);
                    if (returnVal)
                    {
                        new USP_Service(objLoginEntity.ConnectionStringName).USP_DeleteContentMapping(objAD_Session.Acq_Deal_Code, "A");
                        objAD_Session.Deal_Complete_Flag = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objAD_Session.Acq_Deal_Code).Deal_Complete_Flag;
                        if (objAD_Session.Is_Master_Deal == "Y")
                        {
                            var Rights_For_Own = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Add_Rights_For_Ownership").Select(x => x.Parameter_Value).SingleOrDefault();
                            if (Rights_For_Own.ToString() == "Y")
                            {
                                var objParameter_Value = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Own_Production").Select(x => x.Parameter_Value).SingleOrDefault();
                                if (objAD_Session.Role_Code == Convert.ToInt32(objParameter_Value))
                                {
                                    var Acq_Deal_Rights_Code_List = objAD_Session.Acq_Deal_Rights.Select(x => x.Acq_Deal_Rights_Code.ToString()).ToArray();
                                    var Title_Code_List = new Acq_Deal_Rights_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Where(x => Acq_Deal_Rights_Code_List.Contains(x.Acq_Deal_Rights_Code.ToString())).Select(x => x.Title_Code).Distinct().ToArray();
                                    var _result = objAD_Session.Acq_Deal_Movie.Where(x => !Title_Code_List.Contains(x.Title_Code)).ToArray();
                                    var Acq_Deal_Movie_Codes = string.Join(",", _result.Select(x => x.Acq_Deal_Movie_Code).ToArray());
                                    if (Acq_Deal_Movie_Codes.Trim() != "")
                                    {
                                        USP_Deal_Rights_Template_Result objDeal_Rights_Template = new USP_Service(objLoginEntity.ConnectionStringName).USP_Deal_Rights_Template(Convert.ToInt32(objAD_Session.Acq_Deal_Code), Acq_Deal_Movie_Codes, objLoginUser.Users_Code, objAD_Session.Agreement_Date.ToString()).FirstOrDefault();
                                    }
                                }
                            }
                        }
                    }
                    else
                        strMessage = "Error while saving data, " + resultSet;
                }

                if (returnVal)
                {
                    string errorMessage = "";
                    if (objAD_Session.Is_Master_Deal == "N" && Deal_Type_Condition != GlobalParams.Deal_Music && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_CLONE)
                    {
                        string SelectedTitle = string.Join(",", objAD_Session.Acq_Deal_Movie.Where(w => w.EntityState != State.Deleted).Select(s => Convert.ToInt32(s.Title_Code)).ToArray());
                        errorMessage = new USP_Service(objLoginEntity.ConnectionStringName).USP_Acq_Copy_Right_For_Sub_Deal(objAD_Session.Acq_Deal_Code, objAD_Session.Master_Deal_Movie_Code_ToLink,
                            objLoginUser.Users_Code, SelectedTitle).First().ToString();
                    }

                    if (!errorMessage.Trim().Equals(""))
                    {
                        strMessage = "Could not copy master deal's rights";
                        returnVal = false;
                    }
                    else
                    {
                        if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_CLONE && objAD_Session.Acq_Deal_Code > 0)
                        {
                            List<string> lstString = new USP_Service(objLoginEntity.ConnectionStringName).USP_Acq_Deal_Clone_UDT(objAD_Session.Acq_Deal_Code, Clone_Acq_Deal_Code, objLoginUser.Users_Code, lstCloneDealRightsTitle).ToList();
                            string SelectedTitle = string.Join(",", objAD_Session.Acq_Deal_Movie.Where(w => w.EntityState != State.Deleted).Select(s => Convert.ToInt32(s.Title_Code)).ToArray());
                            errorMessage = new USP_Service(objLoginEntity.ConnectionStringName).USP_Acq_Copy_Right_For_Sub_Deal(objAD_Session.Acq_Deal_Code, objAD_Session.Master_Deal_Movie_Code_ToLink,
                                objLoginUser.Users_Code, SelectedTitle).First().ToString();
                            Session["lstCloneDealRightsTitle"] = null;
                            lstCloneDealRightsTitle = null;
                        }

                        if (objDeal_Schema.Mode == GlobalParams.DEAL_MOVIE_CLOSE || closeMovieCount > 0)
                        {
                            new USP_Service(objLoginEntity.ConnectionStringName).USP_Close_Deal_Movie(objAD_Session.Acq_Deal_Code);
                            objDeal_Schema.List_Rights.Clear();
                        }

                        if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_ADD && !tabName.Equals(""))
                        {
                            string strUserLockMessage;
                            int RLCode;
                            bool isLocked = DBUtil.Lock_Record(objAD_Session.Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, out RLCode, out strUserLockMessage);
                            objDeal_Schema.Record_Locking_Code = RLCode;
                        }
                        //else if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                        //{
                        //    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "RL", "ReleaseRecordLock();", true);
                        //}
                    }

                    if (!tabName.Equals(""))
                    {
                        BindSchemaObject();
                        //if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_CLONE)
                        //    objDeal_Schema.Mode = GlobalParams.DEAL_MODE_EDIT;
                    }
                    else
                        objDeal_Schema = null;

                    if (status.Equals("SA"))
                        TempData["RedirectAcqDeal"] = objAD_Session;

                    ClearSession();
                }
            }

            int totalRecordCount = 0;
            if (!returnVal)
            {
                totalRecordCount = lstAcq_Deal_movie.Count;
                status = "E";
            }

            string msg = "";
            if ((status.Equals("S") || status.Equals("SA")) && tabName.Equals(""))
            {
                msg = "Deal saved successfully";
                if (mode == GlobalParams.DEAL_MODE_EDIT)
                    msg = "Deal updated successfully";
            }

            string redirectUrl = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetRedirectURL(tabName, pageNo, null, objDeal_Schema.Deal_Type_Code);

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Error_Message", strMessage);
            obj.Add("Error_Page_Index", errorPageIndex);
            obj.Add("Total_Record_Count", totalRecordCount);
            obj.Add("Success_Message", msg);
            obj.Add("Redirect_URL", redirectUrl);
            obj.Add("TabName", tabName);
            return Json(obj);
        }
        private void UpdateTitleCollection(List<Acq_Deal_Movie> list, bool isFinalSave = false)
        {
            objAD_Session.Acq_Deal_Movie.ToList<Acq_Deal_Movie>().ForEach(x => x.EntityState = (x.Acq_Deal_Movie_Code > 0 && x.EntityState != State.Deleted) ? State.Modified : x.EntityState);

            Acq_Deal_Movie objADM_Session = null;
            if (objAD_Session.Acq_Deal_Movie != null)
            {
                foreach (Acq_Deal_Movie objADM_MVC in list)
                {
                    objADM_Session = objAD_Session.Acq_Deal_Movie.Where(w => w.EntityState != State.Deleted && w.Dummy_Guid == objADM_MVC.Dummy_Guid).FirstOrDefault();

                    if (objADM_Session != null)
                    {
                        int oldEpisodeFrom = 0, oldEpisodeTo = 0, newEpisodeFrom = 0, newEpisodeTo = 0;
                        bool isUpdateRequired = false;

                        int Title_Code = (int)objADM_Session.Title_Code;
                        if (Deal_Type_Condition == GlobalParams.Deal_Music || Deal_Type_Condition == GlobalParams.Deal_Program)
                        {
                            if (objADM_Session.Acq_Deal_Movie_Code > 0 && isFinalSave)
                            {
                                if (objADM_MVC.Episode_Starts_From != null && objADM_MVC.Episode_End_To != null)
                                {
                                    isUpdateRequired = true;
                                    if (Deal_Type_Condition == GlobalParams.Deal_Music)
                                    {
                                        newEpisodeFrom = (int)objADM_MVC.Episode_End_To;
                                        newEpisodeTo = (int)objADM_MVC.Episode_End_To;
                                    }
                                    else
                                    {
                                        newEpisodeFrom = (int)objADM_MVC.Episode_Starts_From;
                                        newEpisodeTo = (int)objADM_MVC.Episode_End_To;
                                    }
                                    Acq_Deal_Movie objADM_DB = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).GetById(objADM_Session.Acq_Deal_Movie_Code);
                                    oldEpisodeFrom = (int)objADM_DB.Episode_Starts_From;
                                    oldEpisodeTo = (int)objADM_DB.Episode_End_To;

                                    if (oldEpisodeFrom == newEpisodeFrom && oldEpisodeTo == newEpisodeTo)
                                        isUpdateRequired = false;
                                }
                            }

                            #region --- In Case of Clone ---
                            int oldEF = 0, oldET = 0;
                            if (objADM_Session.Episode_Starts_From != null)
                                oldEF = (int)objADM_Session.Episode_Starts_From;
                            if (objADM_Session.Episode_End_To != null)
                                oldET = (int)objADM_Session.Episode_End_To;

                            Deal_Rights_Title_UDT objDRT_UDT = lstCloneDealRightsTitle.Where(t => t.Title_Code == Title_Code && t.Episode_From == oldEF && t.Episode_To == oldET).FirstOrDefault();
                            if (objDRT_UDT != null)
                            {
                                if (objADM_MVC.Episode_Starts_From != null && objADM_MVC.Episode_End_To != null)
                                {
                                    int newEF = 0, newET = 0;
                                    //decimal newDu = 0;
                                    if (Deal_Type_Condition == GlobalParams.Deal_Music)
                                    {
                                        newEF = (int)objADM_MVC.Episode_End_To;
                                        newET = (int)objADM_MVC.Episode_End_To;
                                        //if (objADM_MVC.Duration_Restriction!=null)
                                        //newDu = (decimal)objADM_MVC.Duration_Restriction;
                                    }
                                    else
                                    {
                                        newEF = (int)objADM_MVC.Episode_Starts_From;
                                        newET = (int)objADM_MVC.Episode_End_To;
                                    }

                                    objDRT_UDT.Episode_From = newEF;
                                    objDRT_UDT.Episode_To = newET;
                                }
                            }

                            #endregion
                        }

                        if (Deal_Type_Condition == GlobalParams.Deal_Music)
                        {
                            if (objADM_MVC.Episode_End_To != null)
                                objADM_Session.Episode_Starts_From = objADM_MVC.Episode_End_To;

                            objADM_Session.Episode_End_To = objADM_MVC.Episode_End_To;
                            if (objADM_MVC.Duration_Restriction != null)
                                objADM_Session.Duration_Restriction = objADM_MVC.Duration_Restriction;
                        }
                        else if (Deal_Type_Condition == GlobalParams.Deal_Program)
                        {
                            objADM_Session.Episode_Starts_From = objADM_MVC.Episode_Starts_From;
                            objADM_Session.Episode_End_To = objADM_MVC.Episode_End_To;
                        }
                        else if (Deal_Type_Condition == GlobalParams.Sub_Deal_Talent)
                        {
                            objADM_Session.No_Of_Episodes = objADM_MVC.No_Of_Episodes;
                        }


                        objADM_Session.Notes = objADM_MVC.Notes;
                        objADM_Session.Title_Type = objADM_MVC.Title_Type;
                        objADM_Session.Due_Diligence = objADM_MVC.Due_Diligence;

                        if (objADM_Session.Acq_Deal_Movie_Code > 0 && objADM_Session.EntityState != State.Deleted)
                            objADM_Session.EntityState = State.Modified;

                        if (isUpdateRequired)
                        {

                            #region --- Update Right Title ---

                            List<Acq_Deal_Rights_Title> lstRights = (from Acq_Deal_Rights objADR in objAD_Session.Acq_Deal_Rights
                                                                     from Acq_Deal_Rights_Title objADRT in objADR.Acq_Deal_Rights_Title
                                                                     where objADRT.Episode_From == oldEpisodeFrom && objADRT.Episode_To == oldEpisodeTo
                                                                     && objADRT.Title_Code == Title_Code
                                                                     select objADRT).ToList<Acq_Deal_Rights_Title>();

                            lstRights.ForEach(x =>
                            {
                                x.EntityState = State.Modified;
                                x.Episode_From = newEpisodeFrom;
                                x.Episode_To = newEpisodeTo;
                            });
                            #endregion

                            #region --- Update Pushback Title ---
                            List<Acq_Deal_Pushback_Title> lstPushback = (from Acq_Deal_Pushback objADP in objAD_Session.Acq_Deal_Pushback
                                                                         from Acq_Deal_Pushback_Title objADPT in objADP.Acq_Deal_Pushback_Title
                                                                         where objADPT.Episode_From == oldEpisodeFrom && objADPT.Episode_To == oldEpisodeTo
                                                                         && objADPT.Title_Code == Title_Code
                                                                         select objADPT).ToList<Acq_Deal_Pushback_Title>();

                            lstPushback.ForEach(x =>
                            {
                                x.EntityState = State.Modified;
                                x.Episode_From = newEpisodeFrom;
                                x.Episode_To = newEpisodeTo;
                            });
                            #endregion

                            #region --- Update Budget Title ---
                            List<Acq_Deal_Budget> lstBudget = (from Acq_Deal_Budget objADB in objAD_Session.Acq_Deal_Budget
                                                               where objADB.Episode_From == oldEpisodeFrom && objADB.Episode_To == oldEpisodeTo
                                                               && objADB.Title_Code == Title_Code
                                                               select objADB).ToList<Acq_Deal_Budget>();

                            lstBudget.ForEach(x =>
                            {
                                x.EntityState = State.Modified;
                                x.Episode_From = newEpisodeFrom;
                                x.Episode_To = newEpisodeTo;
                            });
                            #endregion

                            #region --- Update Ancillary Title ---
                            List<Acq_Deal_Ancillary_Title> lstAncillary = (from Acq_Deal_Ancillary objADA in objAD_Session.Acq_Deal_Ancillary
                                                                           from Acq_Deal_Ancillary_Title objADAT in objADA.Acq_Deal_Ancillary_Title
                                                                           where objADAT.Episode_From == oldEpisodeFrom && objADAT.Episode_To == oldEpisodeTo
                                                                          && objADAT.Title_Code == Title_Code
                                                                           select objADAT).ToList<Acq_Deal_Ancillary_Title>();

                            lstAncillary.ForEach(x =>
                            {
                                x.EntityState = State.Modified;
                                x.Episode_From = newEpisodeFrom;
                                x.Episode_To = newEpisodeTo;
                            });
                            #endregion

                            #region --- Update Run Def Title ---
                            List<Acq_Deal_Run_Title> lstRun = (from Acq_Deal_Run objADR in objAD_Session.Acq_Deal_Run
                                                               from Acq_Deal_Run_Title objADRT in objADR.Acq_Deal_Run_Title
                                                               where objADRT.Episode_From == oldEpisodeFrom && objADRT.Episode_To == oldEpisodeTo
                                                                          && objADRT.Title_Code == Title_Code
                                                               select objADRT).ToList<Acq_Deal_Run_Title>();

                            lstRun.ForEach(x =>
                            {
                                x.EntityState = State.Modified;
                                x.Episode_From = newEpisodeFrom;
                                x.Episode_To = newEpisodeTo;
                            });
                            #endregion

                            #region --- Update Cost Title ---
                            List<Acq_Deal_Cost_Title> lstCost = (from Acq_Deal_Cost objADC in objAD_Session.Acq_Deal_Cost
                                                                 from Acq_Deal_Cost_Title objADCT in objADC.Acq_Deal_Cost_Title
                                                                 where objADCT.Episode_From == oldEpisodeFrom && objADCT.Episode_To == oldEpisodeTo
                                                                            && objADCT.Title_Code == Title_Code
                                                                 select objADCT).ToList<Acq_Deal_Cost_Title>();

                            lstCost.ForEach(x =>
                            {
                                x.EntityState = State.Modified;
                                x.Episode_From = newEpisodeFrom;
                                x.Episode_To = newEpisodeTo;
                            });
                            #endregion

                            #region --- Update Sports Title ---
                            List<Acq_Deal_Sport_Title> lstSport = (from Acq_Deal_Sport objADS in objAD_Session.Acq_Deal_Sport
                                                                   from Acq_Deal_Sport_Title objADST in objADS.Acq_Deal_Sport_Title
                                                                   where objADST.Episode_From == oldEpisodeFrom && objADST.Episode_To == oldEpisodeTo
                                                                     && objADST.Title_Code == Title_Code
                                                                   select objADST).ToList<Acq_Deal_Sport_Title>();

                            lstSport.ForEach(x =>
                            {
                                x.EntityState = State.Modified;
                                x.Episode_From = newEpisodeFrom;
                                x.Episode_To = newEpisodeTo;
                            });
                            #endregion

                            #region --- Update Attachment Title ---
                            List<Acq_Deal_Attachment> lstAttachment = (from Acq_Deal_Attachment objADA in objAD_Session.Acq_Deal_Attachment
                                                                       where objADA.Episode_From == oldEpisodeFrom && objADA.Episode_To == oldEpisodeTo
                                                                          && objADA.Title_Code == Title_Code
                                                                       select objADA).ToList<Acq_Deal_Attachment>();

                            lstAttachment.ForEach(x =>
                            {
                                x.EntityState = State.Modified;
                                x.Episode_From = newEpisodeFrom;
                                x.Episode_To = newEpisodeTo;
                            });
                            #endregion

                            #region --- Update Material Title ---
                            List<Acq_Deal_Material> lstMaterial = (from Acq_Deal_Material objADMaterial in objAD_Session.Acq_Deal_Material
                                                                   where objADMaterial.Episode_From == oldEpisodeFrom && objADMaterial.Episode_To == oldEpisodeTo
                                                                          && objADMaterial.Title_Code == Title_Code
                                                                   select objADMaterial).ToList<Acq_Deal_Material>();

                            lstMaterial.ForEach(x =>
                            {
                                x.EntityState = State.Modified;
                                x.Episode_From = newEpisodeFrom;
                                x.Episode_To = newEpisodeTo;
                            });
                            #endregion
                        }
                    }
                }
            }
        }

        public JsonResult SaveTitle(string titleCodes, int dealTypeCode)
        {
            string[] arrTitleCodes = titleCodes.Split(',');
            Deal_Type_Code = dealTypeCode;
            foreach (string code in arrTitleCodes)
            {
                int titleCode = Convert.ToInt32(code);
                Acq_Deal_Movie objAcq_Deal_Movie = new Acq_Deal_Movie();
                objAcq_Deal_Movie.EntityState = State.Added;
                objAcq_Deal_Movie.Title_Code = titleCode;
                objAcq_Deal_Movie.Is_Closed = "N";
                objAcq_Deal_Movie.Title = new Title_Service(objLoginEntity.ConnectionStringName).GetById(titleCode);

                if (Deal_Type_Condition == GlobalParams.Deal_Movie)
                {
                    objAcq_Deal_Movie.Episode_Starts_From = 1;
                    objAcq_Deal_Movie.Episode_End_To = 1;
                    objAcq_Deal_Movie.No_Of_Episodes = 1;
                }
                else if (Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    objAcq_Deal_Movie.Episode_Starts_From = 1;
                    objAcq_Deal_Movie.No_Of_Episodes = 1;
                }
                else if (Deal_Type_Condition == GlobalParams.Deal_Program && dealTypeCode == GlobalParams.Deal_Type_Sports)
                {
                    objAcq_Deal_Movie.Episode_Starts_From = 1;
                    objAcq_Deal_Movie.No_Of_Episodes = 1;
                }
                else if (Deal_Type_Condition == GlobalParams.Sub_Deal_Talent)
                {
                    int masterDeal_dealTypeCode = (new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Acq_Deal_Movie_Code == objAD_Session.Master_Deal_Movie_Code_ToLink).Select(s => (int)s.Acq_Deal.Deal_Type_Code).FirstOrDefault();
                    objAcq_Deal_Movie.Episode_Starts_From = 1;
                    objAcq_Deal_Movie.Episode_End_To = 1;
                    if (masterDeal_dealTypeCode == GlobalParams.Deal_Type_Movie)
                        objAcq_Deal_Movie.No_Of_Episodes = 1;

                }

                objAD_Session.Acq_Deal_Movie.Add(objAcq_Deal_Movie);
            }

            string toolTip;
            string iconPath = GetIconPath(Deal_Type_Code, out toolTip);

            objDeal_Schema.Deal_Type_Code = dealTypeCode;
            BindSchemaObject(true);
            SearchTitle("");
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", "S");
            obj.Add("Title_Icon_Path", iconPath);
            obj.Add("Title_Icon_Tooltip", toolTip);
            return Json(obj);
        }
        public JsonResult SaveTitleListData(List<Acq_Deal_Movie> titleList)
        {
            if (objDeal_Schema.Deal_Type_Code > 0)
                Deal_Type_Code = objDeal_Schema.Deal_Type_Code;

            if (titleList != null)
                UpdateTitleCollection(titleList);

            string status = "S", errorMessag = "";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Error_Message", errorMessag);
            return Json(obj);
        }
        public JsonResult DeleteTitle(string Dummy_Guid, int acqDealMovieCode)
        {
            string status = "S", errorMessage = "";
            Acq_Deal_Movie objADM = objAD_Session.Acq_Deal_Movie.Where(w => w.Dummy_Guid == Dummy_Guid && w.Acq_Deal_Movie_Code == acqDealMovieCode).FirstOrDefault();
            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_CLONE)
            {
                if (lstCloneDealRightsTitle.Where(t => t.Title_Code == objADM.Title_Code).Count() > 0)
                    lstCloneDealRightsTitle.Remove(lstCloneDealRightsTitle.Where(t => t.Title_Code == objADM.Title_Code).FirstOrDefault());
            }
            if (objADM.Acq_Deal_Movie_Code > 0)
            {
                //int Flag = new USP_Service().USP_Validate_General_Delete_For_Title(objADM.Acq_Deal_Code, objADM.Title_Code, objADM.Episode_Starts_From, objADM.Episode_End_To, "A").ElementAt(0).Value;
                StatusMessage  objStatusMessage = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_General_Delete_For_Title(objADM.Acq_Deal_Code, objADM.Title_Code, objADM.Episode_Starts_From, objADM.Episode_End_To, "A").FirstOrDefault();
                if(objStatusMessage.Status == "E")
                {
                    status = objStatusMessage.Status;
                    errorMessage = objStatusMessage.Message;
                }
                else
                {
                    objADM.EntityState = State.Deleted;
                }
                //if (Flag == 1)
                //{
                //    status = "E";
                //    errorMessage = "Can not delete this title as it is being used in other process.";
                //}

                //if (status.Equals("S"))
                //{
                //    objADM.EntityState = State.Deleted;
                //}
            }
            else
                objAD_Session.Acq_Deal_Movie.Remove(objADM);

            bool bindSearch = false;
            if (status.Equals("S"))
            {
                lstAcq_Deal_movie.Remove(objADM);
                if (lstAcq_Deal_movie.Where(x => x.Title_Code == objADM.Title_Code && x.Episode_Starts_From == objADM.Episode_Starts_From
                    && x.Episode_End_To == objADM.Episode_End_To).Count() == 0)
                    bindSearch = true;
            }

            string toolTip;
            string iconPath = GetIconPath(Deal_Type_Code, out toolTip);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Error_Message", errorMessage);
            obj.Add("Bind_Search", bindSearch);
            obj.Add("Title_Icon_Path", iconPath);
            obj.Add("Title_Icon_Tooltip", toolTip);
            return Json(obj);
        }
        public JsonResult Close_Title(int acqDealMovieCode, string notes, string titleType, string closingDate, string closingRemark, int episodeFrom, int episodeTo, int noOfEpisodes, string confirmationDone)
        {
            string status = "S", errorMessage = "", showConfirmation = "N";

            #region --- actual logic for close title ---

            Acq_Deal_Movie objADM = objAD_Session.Acq_Deal_Movie.Where(dm => dm.Acq_Deal_Movie_Code == acqDealMovieCode && dm.EntityState != State.Deleted).FirstOrDefault();
            if (objADM != null)
            {
                DateTime objClosingDate = Convert.ToDateTime(GlobalUtil.MakedateFormat(closingDate));
                if (!confirmationDone.Equals("Y"))
                {
                    // need to pass two parameter which is newly added in USP (int episodeFrom, int episodeTo)
                    USP_Validate_Close_Movie__Scheduled_Run_Result objResult = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_Close_Movie__Scheduled_Run(acqDealMovieCode, objADM.Title_Code, objClosingDate.ToString("MM/dd/yyyy"), episodeFrom, episodeTo).FirstOrDefault();

                    if (objResult != null)
                    {
                        if (objResult.Msg != String.Empty)
                        {
                            if (objClosingDate != objResult.Max_Date)
                            {
                                status = "E";

                                if (objResult.Show_Confirmation.Equals("Y"))
                                {
                                    showConfirmation = "Y";
                                    errorMessage = objResult.Msg;
                                }
                                else if (objResult.Show_Confirmation.Equals("N"))
                                {
                                    if (Convert.ToDateTime(objResult.Max_Date).ToString("dd/MM/yyyy") == "01/01/1900")
                                        errorMessage = objResult.Msg;
                                    else
                                        errorMessage = objResult.Msg + " " + Convert.ToDateTime(objResult.Max_Date).ToString("dd/MM/yyyy");
                                }
                            }
                        }
                    }
                }

                if (status.Equals("S"))
                {
                    objADM.Notes = notes;
                    objADM.Title_Type = titleType;
                    objADM.Movie_Closed_Date = objClosingDate;
                    objADM.Closing_Remarks = closingRemark;
                    objADM.Is_Closed = "X";
                    objADM.Episode_Starts_From = episodeFrom;
                    objADM.Episode_End_To = episodeTo;
                    objADM.No_Of_Episodes = noOfEpisodes;
                    closeMovieCount++;
                }
            }
            else
            {
                status = "E";
                errorMessage = "Object not found";
            }
            #endregion

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Error_Message", errorMessage);
            obj.Add("Show_Confirmation", showConfirmation);
            return Json(obj);
        }
        public JsonResult Replace_Title(string dummyGuid, int titleCode, string notes, string titleType, int episodeFrom, int episodeTo, int noOfEpisodes)
        {
            string status = "S", errorMessage = "", titleName = "", titleLanguageName = "", starCast = "", duration = "";

            #region --- actual Logic for Replace Title ---
            Acq_Deal_Movie objADM = objAD_Session.Acq_Deal_Movie.Where(dm => dm.Dummy_Guid == dummyGuid && dm.EntityState != State.Deleted).FirstOrDefault();
            if (objADM != null)
            {
                int oldTitleCode = (int)objADM.Title_Code;


                objADM.Title_Code = titleCode;

                int oldEpisodeFrom = 0;
                int oldEpisodeTo = 0;
                if (objADM.Episode_Starts_From != null)
                    oldEpisodeFrom = (int)objADM.Episode_Starts_From;
                if (objADM.Episode_End_To != null)
                    oldEpisodeTo = (int)objADM.Episode_End_To;

                Deal_Rights_Title_UDT objDRT_UDT = lstCloneDealRightsTitle.Where(t => t.Title_Code == oldTitleCode && t.Episode_From == oldEpisodeFrom && t.Episode_To == oldEpisodeTo).FirstOrDefault();
                if (objDRT_UDT != null)
                {
                    objDRT_UDT.Title_Code = titleCode;
                    objDRT_UDT.Episode_From = episodeFrom;
                    objDRT_UDT.Episode_To = episodeTo;
                }

                objADM.Title = null;
                objADM.Notes = notes;
                objADM.Title_Type = titleType;
                objADM.Episode_Starts_From = episodeFrom;
                objADM.Episode_End_To = episodeTo;
                objADM.No_Of_Episodes = noOfEpisodes;

                RightsU_Entities.Title objT = new Title_Service(objLoginEntity.ConnectionStringName).GetById(titleCode);
                titleName = objT.Title_Name;
                titleLanguageName = objT.Title_Languages.Language_Name;
                starCast = string.Join(", ", objT.Title_Talent.
                                Where(w => w.Role_Code == GlobalParams.RoleCode_StarCast).Select(s => s.Talent.Talent_Name).ToArray().Distinct());

                duration = Convert.ToString(objT.Duration_In_Min);
                objADM.Title = objT;
                UpdateTitleOnRenew(oldTitleCode, objADM, oldEpisodeFrom, oldEpisodeTo, objADM.Title_Code.Value);

                objDeal_Schema.List_Rights.Clear();
                objDeal_Schema.List_Pushback.Clear();
                objDeal_Schema.List_Sports.Clear();
            }
            else
            {
                status = "E";
                errorMessage = "Object not found";
            }
            #endregion

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Error_Message", errorMessage);
            obj.Add("Title_Name", titleName);
            obj.Add("Title_Language_Name", titleLanguageName);
            obj.Add("Star_Cast", starCast);
            obj.Add("Duration_In_Min", duration);
            return Json(obj);
        }
        private void UpdateTitleOnRenew(int oldTitleCode, Acq_Deal_Movie objADM, int oldEpisodeFrom, int oldEpisodeTo, int newTitleCode)
        {
            #region --- Update Right Title ---

            List<Acq_Deal_Rights_Title> lstRights = (from Acq_Deal_Rights objADR in objAD_Session.Acq_Deal_Rights
                                                     from Acq_Deal_Rights_Title objADRT in objADR.Acq_Deal_Rights_Title
                                                     where objADRT.Episode_From == oldEpisodeFrom && objADRT.Episode_To == oldEpisodeTo
                                                     && objADRT.Title_Code == oldTitleCode
                                                     select objADRT).ToList<Acq_Deal_Rights_Title>();

            lstRights.ForEach(x =>
            {
                x.Title_Code = newTitleCode;
                x.EntityState = State.Modified;
                x.Episode_From = objADM.Episode_Starts_From;
                x.Episode_To = objADM.Episode_End_To;
            });

            objAD_Session.Acq_Deal_Rights.Where(r => r.Acq_Deal_Rights_Title.Any(objADRT => objADRT.Episode_From == oldEpisodeFrom && objADRT.Episode_To == oldEpisodeTo
                                                     && objADRT.Title_Code == oldTitleCode)).ToList().ForEach(r =>
                                                     {
                                                         r.Is_Verified = "N";
                                                     });
            #endregion

            #region --- Update Pushback Title ---
            List<Acq_Deal_Pushback_Title> lstPushback = (from Acq_Deal_Pushback objADP in objAD_Session.Acq_Deal_Pushback
                                                         from Acq_Deal_Pushback_Title objADPT in objADP.Acq_Deal_Pushback_Title
                                                         where objADPT.Episode_From == oldEpisodeFrom && objADPT.Episode_To == oldEpisodeTo
                                                         && objADPT.Title_Code == oldTitleCode
                                                         select objADPT).ToList<Acq_Deal_Pushback_Title>();

            lstPushback.ForEach(x =>
            {
                x.Title_Code = newTitleCode;
                x.EntityState = State.Modified;
                x.Episode_From = objADM.Episode_Starts_From;
                x.Episode_To = objADM.Episode_End_To;
            });
            #endregion

            #region --- Update Ancillary Title ---
            List<Acq_Deal_Ancillary_Title> lstAncillary = (from Acq_Deal_Ancillary objADA in objAD_Session.Acq_Deal_Ancillary
                                                           from Acq_Deal_Ancillary_Title objADAT in objADA.Acq_Deal_Ancillary_Title
                                                           where objADAT.Episode_From == oldEpisodeFrom && objADAT.Episode_To == oldEpisodeTo
                                                          && objADAT.Title_Code == oldTitleCode
                                                           select objADAT).ToList<Acq_Deal_Ancillary_Title>();

            lstAncillary.ForEach(x =>
            {
                x.Title_Code = newTitleCode;
                x.EntityState = State.Modified;
                x.Episode_From = objADM.Episode_Starts_From;
                x.Episode_To = objADM.Episode_End_To;
            });
            #endregion

            #region --- Update Run Def Title ---
            List<Acq_Deal_Run_Title> lstRun = (from Acq_Deal_Run objADR in objAD_Session.Acq_Deal_Run
                                               from Acq_Deal_Run_Title objADRT in objADR.Acq_Deal_Run_Title
                                               where objADRT.Episode_From == oldEpisodeFrom && objADRT.Episode_To == oldEpisodeTo
                                                          && objADRT.Title_Code == oldTitleCode
                                               select objADRT).ToList<Acq_Deal_Run_Title>();

            lstRun.ForEach(x =>
            {
                x.Title_Code = newTitleCode;
                x.EntityState = State.Modified;
                x.Episode_From = objADM.Episode_Starts_From;
                x.Episode_To = objADM.Episode_End_To;
            });
            #endregion

            #region --- Update Cost Title ---
            List<Acq_Deal_Cost_Title> lstCost = (from Acq_Deal_Cost objADC in objAD_Session.Acq_Deal_Cost
                                                 from Acq_Deal_Cost_Title objADCT in objADC.Acq_Deal_Cost_Title
                                                 where objADCT.Episode_From == oldEpisodeFrom && objADCT.Episode_To == oldEpisodeTo
                                                            && objADCT.Title_Code == oldTitleCode
                                                 select objADCT).ToList<Acq_Deal_Cost_Title>();

            lstCost.ForEach(x =>
            {
                x.Title_Code = newTitleCode;
                x.EntityState = State.Modified;
                x.Episode_From = objADM.Episode_Starts_From;
                x.Episode_To = objADM.Episode_End_To;
            });
            #endregion

            #region --- Update Sports Title ---
            List<Acq_Deal_Sport_Title> lstSport = (from Acq_Deal_Sport objADS in objAD_Session.Acq_Deal_Sport
                                                   from Acq_Deal_Sport_Title objADST in objADS.Acq_Deal_Sport_Title
                                                   where objADST.Episode_From == oldEpisodeFrom && objADST.Episode_To == oldEpisodeTo
                                                     && objADST.Title_Code == oldTitleCode
                                                   select objADST).ToList<Acq_Deal_Sport_Title>();

            lstSport.ForEach(x =>
            {
                x.Title_Code = newTitleCode;
                x.EntityState = State.Modified;
                x.Episode_From = objADM.Episode_Starts_From;
                x.Episode_To = objADM.Episode_End_To;
            });
            #endregion

            #region --- Update Attachment Title ---
            List<Acq_Deal_Attachment> lstAttachment = (from Acq_Deal_Attachment objADA in objAD_Session.Acq_Deal_Attachment
                                                       where objADA.Episode_From == oldEpisodeFrom && objADA.Episode_To == oldEpisodeTo
                                                          && objADA.Title_Code == oldTitleCode
                                                       select objADA).ToList<Acq_Deal_Attachment>();

            lstAttachment.ForEach(x =>
            {
                x.Title_Code = newTitleCode;
                x.EntityState = State.Modified;
                x.Episode_From = objADM.Episode_Starts_From;
                x.Episode_To = objADM.Episode_End_To;
            });
            #endregion

            #region --- Update Material Title ---
            List<Acq_Deal_Material> lstMaterial = (from Acq_Deal_Material objADMaterial in objAD_Session.Acq_Deal_Material
                                                   where objADMaterial.Episode_From == oldEpisodeFrom && objADMaterial.Episode_To == oldEpisodeTo
                                                          && objADMaterial.Title_Code == oldTitleCode
                                                   select objADMaterial).ToList<Acq_Deal_Material>();

            lstMaterial.ForEach(x =>
            {
                x.Title_Code = newTitleCode;
                x.EntityState = State.Modified;
                x.Episode_From = objADM.Episode_Starts_From;
                x.Episode_To = objADM.Episode_End_To;
            });
            #endregion
        }
        #endregion

        public JsonResult GetDealTypeCodeFromServer()
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("DealTypeCode", objDeal_Schema.Deal_Type_Code);
            return Json(obj);
        }

        public JsonResult GetWorkflowStatusFromServer()
        {
            objDeal_Schema.Deal_Workflow_Status = new RightsU_BLL.USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Deal_DealWorkFlowStatus(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Workflow_Flag, 143, "A").First();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("DealWorkflowFlag", objDeal_Schema.Deal_Workflow_Flag);
            obj.Add("DealWorkflowStatus", objDeal_Schema.Deal_Workflow_Status);
            return Json(obj);
        }
    }
}
