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
    public class Syn_GeneralController : BaseController
    {
        #region --- Properties ---
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
        public int Syn_Deal_Code
        {
            get
            {
                if (Session["Syn_Deal_Code"] == null)
                    Session["Syn_Deal_Code"] = "0";
                return Convert.ToInt32(Session["Syn_Deal_Code"]);
            }
            set { Session["Syn_Deal_Code"] = value; }
        }
        public Syn_Deal objSD_Session
        {
            get
            {
                if (Session[RightsU_Session.SESS_SYNDEAL] == null)
                    Session[RightsU_Session.SESS_SYNDEAL] = new Syn_Deal();

                return (Syn_Deal)Session[RightsU_Session.SESS_SYNDEAL];
            }
            set { Session[RightsU_Session.SESS_SYNDEAL] = value; }
        }
        public Syn_Deal_Service objSDS
        {
            get
            {
                if (Session["SDS_Syn_General"] == null)
                    Session["SDS_Syn_General"] = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
                return (Syn_Deal_Service)Session["SDS_Syn_General"];
            }
            set { Session["SDS_Syn_General"] = value; }
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
        private List<Syn_Deal_Movie> lstSyn_Deal_movie
        {
            get
            {
                if (Session["lstSyn_Deal_movie"] == null)
                    Session["lstSyn_Deal_movie"] = new List<Syn_Deal_Movie>();
                return (List<Syn_Deal_Movie>)Session["lstSyn_Deal_movie"];
            }
            set { Session["lstSyn_Deal_movie"] = value; }
        }
        public int Clone_Syn_Deal_Code
        {
            get
            {
                if (Session["Clone_Syn_Deal_Code"] == null)
                    Session["Clone_Syn_Deal_Code"] = "0";
                return Convert.ToInt32(Session["Clone_Syn_Deal_Code"]);
            }
            set { Session["Clone_Syn_Deal_Code"] = value; }
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
        #endregion

        #region --- Action Methods ---
        public PartialViewResult Index()
        {
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            if (TempData["QueryString"] != null)
            {
                obj_Dictionary = TempData["QueryString"] as Dictionary<string, string>;
                objDeal_Schema = null;
                ClearSession();
                Syn_Deal_Code = Convert.ToInt32(obj_Dictionary["Syn_Deal_Code"]);
                objDeal_Schema.Mode = obj_Dictionary["Mode"];
            }
            else
            {
                Syn_Deal_Code = objDeal_Schema.Deal_Code;
            }
            if (TempData["TitleData"] != null)
            {
                TempData.Keep("TitleData");
            }
            objDeal_Schema.Page_From = GlobalParams.Page_From_General;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD)
            {
                //Added by akshay
                if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_CLONE && Syn_Deal_Code > 0 && objDeal_Schema.Deal_Code == 0)
                {
                    Syn_Deal objExisting_Syn_Deal = objSDS.GetById(Syn_Deal_Code);
                    objSD_Session = CloneSynDealObject(objExisting_Syn_Deal);
                    Syn_Deal_Code = 0;
                }
                else if (Syn_Deal_Code > 0)
                    objSD_Session = objSDS.GetById(Syn_Deal_Code);
            }
            else
            {
                objSD_Session.Agreement_Date = DateTime.Now;
                objSD_Session.Deal_Type_Code = GlobalParams.Deal_Type_Movie;
                objSD_Session.Year_Type = "DY";
                ViewBag.Deal_Mode = GlobalParams.DEAL_MODE_ADD;
            }

            objDeal_Schema.Module_Rights_List = new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Security_Group_Code == objLoginUser.Security_Group_Code
                            && i.System_Module_Rights_Code == i.System_Module_Right.Module_Right_Code
                            && i.System_Module_Right.Module_Code == GlobalParams.ModuleCodeForSynDeal)
                .Select(i => i.System_Module_Right.Right_Code).Distinct().ToList();

            BindSchemaObject();
            string viewName = "~/Views/Syn_Deal/_Syn_General.cshtml";
            string AllowDealSegment = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Gen_Deal_Segment").Select(x => x.Parameter_Value).FirstOrDefault();
            ViewBag.DealSegment = AllowDealSegment;

            string AllowRevenueVertical = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Gen_Revenue_Vertical").Select(x => x.Parameter_Value).FirstOrDefault();
            ViewBag.RevenueVertical = AllowRevenueVertical;

            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ARCHIVE && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_APPROVE)
            {
                ViewBag.Deal_Mode = objDeal_Schema.Mode;
                if (objSD_Session.Deal_Workflow_Status != null)
                    if (Convert.ToString(objSD_Session.Deal_Workflow_Status).Trim() == GlobalParams.dealWorkFlowStatus_Approved)
                    {
                        objSD_Session.Version = (Convert.ToInt32(Convert.ToDouble(objSD_Session.Version)) + 1).ToString("0000");
                        objSD_Session.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_Ammended;
                    }

                if (objSD_Session.Deal_Tag_Code == null)
                    objSD_Session.Deal_Tag_Code = 0;

                BindAllPreReq();
            }
            else
            {
                objDeal_Schema.List_Deal_Tag = new SelectList(new Deal_Tag_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true), "Deal_Tag_Code", "Deal_Tag_Description", objSD_Session.Deal_Tag_Code == 0 ? 1 : objSD_Session.Deal_Tag_Code).ToList();
                ViewBag.CustomerType = objSD_Session.Customer_Type > 0 ? new Role_Service(objLoginEntity.ConnectionStringName).GetById((int)objSD_Session.Customer_Type).Role_Name : GlobalParams.msgNA;

                ViewBag.SalesAgentName = GlobalParams.msgNA;
                ViewBag.SalesAgentContact = GlobalParams.msgNA;
                ViewBag.SalesAgentContactPh = GlobalParams.msgNA;
                ViewBag.SalesAgentEmail = GlobalParams.msgNA;

                if (objSD_Session.Sales_Agent_Code != null && objSD_Session.Sales_Agent_Code > 0)
                {
                    RightsU_Entities.Vendor objVendor = new Vendor_Service(objLoginEntity.ConnectionStringName).GetById((int)objSD_Session.Sales_Agent_Code);

                    ViewBag.SalesAgentName = objVendor.Vendor_Name;

                    if (objSD_Session.Sales_Agent_Contact_Code != null && objSD_Session.Sales_Agent_Contact_Code > 0)
                    {
                        RightsU_Entities.Vendor_Contacts objVC = objVendor.Vendor_Contacts.Where(x => x.Vendor_Contacts_Code == objSD_Session.Sales_Agent_Contact_Code).First();

                        ViewBag.SalesAgentContact = objVC.Contact_Name;
                        ViewBag.SalesAgentContactPh = objVC.Phone_No;
                        ViewBag.SalesAgentEmail = objVC.Email;
                    }
                }
                viewName = "~/Views/Syn_Deal/_Syn_General_View.cshtml";
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
            Session["FileName"] = "";
            Session["FileName"] = "syn_General";
            SearchTitle(objDeal_Schema.General_Search_Title_Codes);
            return PartialView(viewName, objSD_Session);
        }
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
                return RedirectToAction("Index", "Syn_List");
            }
        }
        #endregion

        #region --- Change Events ---
        public JsonResult CustomerType_Change(int Selected_Role_Code)
        {
            SelectList lst = GetVendorList(Selected_Role_Code);
            return Json(lst, JsonRequestBehavior.AllowGet);
        }
        private SelectList GetVendorList(int roleCode)
        {
            string Is_Vendor_Validation_For_Deal = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Is_Vendor_Validation_For_Deal").Select(s => s.Parameter_Value).FirstOrDefault();
            List<SelectListItem> lst_Licensee = new List<SelectListItem>();
            string Role_Type = "V";
            int Vendor_Code = objSD_Session.Vendor_Code ?? 0;
            if (roleCode == GlobalParams.Role_Code_Entity)//THIS IS FOR INTERNAL SALE                
                Role_Type = "E";

            if (roleCode > 0)
            {
                if (Role_Type.ToUpper().Trim() == "V")
                {
                    lst_Licensee = new SelectList(new Vendor_Service(objLoginEntity.ConnectionStringName)
                                        .SearchFor(x => x.Is_Active == "Y" || (Is_Vendor_Validation_For_Deal == "Y" && x.Syn_Deal.Where(w => w.Vendor_Code == Vendor_Code && w.Syn_Deal_Code == objSD_Session.Syn_Deal_Code).Count() > 0))
                                        .SelectMany(y => y.Vendor_Role).Where(y => y.Role_Code == roleCode)
                                        .Select(x => new { Vendor_Name = x.Vendor.Vendor_Name, Vendor_Code = x.Vendor_Code })
                                        , "Vendor_Code", "Vendor_Name").OrderBy(i => i.Text).ToList();
                }
            }

            lst_Licensee.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
            SelectList lst = new SelectList(lst_Licensee, "Value", "Text");
            return lst;
        }
        public JsonResult Licensee_Change(int Selected_Licensee_Code)
        {
            SelectList lst = GetVendorContactList(Selected_Licensee_Code);
            return Json(lst, JsonRequestBehavior.AllowGet);
        }
        public JsonResult SaleAgent_Change(int Selected_SaleAgent_Code)
        {
            SelectList lst = GetVendorContactList(Selected_SaleAgent_Code);
            return Json(lst, JsonRequestBehavior.AllowGet);
        }
        private SelectList GetVendorContactList(int vendorCode)
        {
            List<SelectListItem> lstContact = new List<SelectListItem>();

            if (vendorCode > 0)
            {
                lstContact = new SelectList(new Vendor_Contacts_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Vendor_Code == vendorCode)
                                                    .Select(i => new { Contact_Name = i.Contact_Name, Vendor_Contacts_Code = i.Vendor_Contacts_Code })
                                                    , "Vendor_Contacts_Code", "Contact_Name"
                                                 ).OrderBy(o => o.Text).ToList();
            }

            lstContact.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
            SelectList lst = new SelectList(lstContact, "Value", "Text");
            return lst;
        }
        public JsonResult Licensee_Contact_Change(int Selected_Contact_Code)
        {
            string strPhone = "", strEmail = "";
            Dictionary<string, object> obj = new Dictionary<string, object>();

            if (Selected_Contact_Code > 0)
            {
                Vendor_Contacts objVC = new Vendor_Contacts_Service(objLoginEntity.ConnectionStringName).GetById(Selected_Contact_Code);
                strPhone = objVC.Phone_No;
                strEmail = objVC.Email;
            }

            obj.Add("Vendor_Phone", strPhone);
            obj.Add("Vendor_Email", strEmail);
            return Json(obj, JsonRequestBehavior.AllowGet);
        }
        public JsonResult SaleAgent_Contact_Change(int Selected_Contact_Code)
        {
            string strPhone = "", strEmail = "";
            if (Selected_Contact_Code > 0)
            {
                Vendor_Contacts objVC = new Vendor_Contacts_Service(objLoginEntity.ConnectionStringName).GetById(Selected_Contact_Code);
                strPhone = objVC.Phone_No;
                strEmail = objVC.Email;
            }
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("SA_Phone", strPhone);
            obj.Add("SA_Email", strEmail);
            return Json(obj, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region --- Bind Methods ---
        private void BindSchemaObject(bool BindOnlyTitleList = false)
        {
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            string toolTip;

            if (TempData["QueryString"] != null)
                obj_Dictionary = TempData["QueryString"] as Dictionary<string, string>;

            if (!BindOnlyTitleList)
            {
                objDeal_Schema.Agreement_Date = objSD_Session.Agreement_Date;

                if (objSD_Session.Syn_Deal_Code > 0)
                {
                    objDeal_Schema.Deal_Code = objSD_Session.Syn_Deal_Code;
                    objDeal_Schema.Deal_Type_Code = (int)objSD_Session.Deal_Type_Code;
                    objDeal_Schema.Agreement_No = objSD_Session.Agreement_No;
                    objDeal_Schema.Deal_Desc = objSD_Session.Deal_Description;
                    objDeal_Schema.Version = objSD_Session.Version;

                    if (objSD_Session.Deal_Tag != null)
                        objDeal_Schema.Status = objSD_Session.Deal_Tag.Deal_Tag_Description;
                    else
                        objDeal_Schema.Status = new Deal_Tag_Service(objLoginEntity.ConnectionStringName).GetById((int)objSD_Session.Deal_Tag_Code).Deal_Tag_Description;

                    objDeal_Schema.Year_Type = objSD_Session.Year_Type;
                    objDeal_Schema.Deal_Workflow_Flag = objSD_Session.Deal_Workflow_Status;

                    int[] arrTitleCodes = objSD_Session.Syn_Deal_Movie.Select(x => (int)x.Title_Code).Distinct().ToArray();
                    string titleImagePath = ConfigurationManager.AppSettings["TitleImagePath"];

                    if (arrTitleCodes.Length == 1)
                        objDeal_Schema.Title_Image_Path = titleImagePath + new Title_Service(objLoginEntity.ConnectionStringName).GetById(arrTitleCodes[0]).Title_Image;
                    else
                        objDeal_Schema.Title_Image_Path = titleImagePath + "movieIcon.png";

                    if (string.IsNullOrEmpty(objSD_Session.Deal_Complete_Flag))
                        objSD_Session.Deal_Complete_Flag = "";

                    if (TempData["QueryString"] != null && obj_Dictionary["RLCode"] != null)
                        objDeal_Schema.Record_Locking_Code = Convert.ToInt32(obj_Dictionary["RLCode"]);

                    if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_ADD && objSD_Session.Syn_Deal_Code > 0)
                        objDeal_Schema.Mode = GlobalParams.DEAL_MODE_EDIT;

                    objDeal_Schema.Deal_Type_Condition = GlobalUtil.GetDealTypeCondition((int)objSD_Session.Deal_Type_Code);
                }
                else
                {
                    objDeal_Schema.Agreement_No = "";
                    objDeal_Schema.Version = "0001";
                    objDeal_Schema.Deal_Workflow_Flag = "O";
                }

                if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_CLONE)
                {
                    //var lstVendor = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" ).Select(x => new { x.Vendor_Code, x.Vendor_Name }).ToList();
                    string currency_Name = new Currency_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Currency_Code == objSD_Session.Currency_Code).Select(x => x.Currency_Name).FirstOrDefault();
                    string category_Name = new Category_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Category_Code == objSD_Session.Category_Code).Select(x => x.Category_Name).FirstOrDefault();
                    //string Role_Name = new Role_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Role_Code == objSD_Session.Role_Code).Select(x => x.Role_Name).FirstOrDefault();
                    string entity_Name = new Entity_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Entity_Code == objSD_Session.Entity_Code).Select(x => x.Entity_Name).FirstOrDefault();

                    string Vendor_Name = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Vendor_Code == objSD_Session.Vendor_Code).Select(x => x.Vendor_Name).FirstOrDefault();

                    //Vendor_Name = Vendor_Name.Substring(0, Vendor_Name.Length - 2);
                    ViewBag.Vendor_Name = Vendor_Name;
                    //ViewBag.Role_Name = Role_Name;
                    ViewBag.entity_Name = entity_Name;
                    ViewBag.Currency_Name = currency_Name;
                    ViewBag.Category_Name = category_Name;

                    objDeal_Schema.Deal_Desc = objSD_Session.Deal_Description;
                    objDeal_Schema.Agreement_Date = objSD_Session.Agreement_Date;
                }

                if (TempData["QueryString"] != null && obj_Dictionary["PageNo"] != null)
                    objDeal_Schema.PageNo = Convert.ToInt32(obj_Dictionary["PageNo"].ToString());

                if (TempData["QueryString"] != null && obj_Dictionary["RLCode"] != null)
                    objDeal_Schema.Record_Locking_Code = Convert.ToInt32(obj_Dictionary["RLCode"]);
            }

            objDeal_Schema.Arr_Title_Codes = objSD_Session.Syn_Deal_Movie.Select(s => Convert.ToInt32(s.Title_Code)).ToArray();
            objDeal_Schema.Title_List.Clear();

            GetIconPath(objDeal_Schema.Deal_Type_Code, out toolTip);

            foreach (Syn_Deal_Movie objADM in objSD_Session.Syn_Deal_Movie)
            {
                if (objADM.Is_Closed != "Y" && objADM.Is_Closed != "X")
                {
                    Title_List objTL = new Title_List();

                    objTL.Acq_Deal_Movie_Code = objADM.Syn_Deal_Movie_Code;
                    objTL.Title_Code = (int)objADM.Title_Code;

                    if (objADM.Episode_From != null)
                        objTL.Episode_From = (int)objADM.Episode_From;

                    if (objADM.Episode_End_To != null)
                        objTL.Episode_To = (int)objADM.Episode_End_To;

                    objDeal_Schema.Title_List.Add(objTL);
                }
            }
        }
        public PartialViewResult BindTopBand(int dealTypeCode, string dealDesc, string agreementDate, int dealTagCode)
        {
            objDeal_Schema.Deal_Type_Code = dealTypeCode;
            objDeal_Schema.Agreement_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(agreementDate));
            objDeal_Schema.Deal_Desc = dealDesc;
            objDeal_Schema.Deal_Tag_Code = dealTagCode;
            return PartialView("~/Views/Shared/_Top_Syn_Details.cshtml");
        }
        private Vendor_Contacts GetVendorContacts(int Vendor_Contact_Code)
        {
            Vendor_Contacts objVC = new Vendor_Contacts_Service(objLoginEntity.ConnectionStringName).GetById(Vendor_Contact_Code);
            return objVC;
        }
        private void BindAllPreReq()
        {
            List<USP_Get_Acq_PreReq_Result> lstUSP_Get_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName)
                .USP_Get_Syn_PreReq("DTG,DTP,DTC,ROL,", "GEN", objLoginUser.Users_Code, Syn_Deal_Code, 0, 0).ToList();
            objDeal_Schema.List_Deal_Tag = new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "DTG"), "Display_Value", "Display_Text", objSD_Session.Deal_Tag_Code == 0 ? 1 : objSD_Session.Deal_Tag_Code).ToList();

            #region --- Deal For ---
            ViewBag.Deal_For_List = new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "DTP"), "Display_Value", "Display_Text").ToList();

            if (ViewBag.Deal_For_List.Count > 0)
                ViewBag.Deal_For_List[0].Selected = true;

            ViewBag.Other_Deal_Type_List = new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "DTC"), "Display_Value", "Display_Text").ToList();
            #endregion

            #region --- Customer Type ---
           
            ViewBag.Customer_Type_List = new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For.Contains("ROL")), "Display_Value", "Display_Text").ToList();
            List<SelectListItem> lstCustomer_Type_List_Default = new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "ROL"), "Display_Value", "Display_Text").ToList();
            lstCustomer_Type_List_Default.Insert(2, (new SelectListItem { Text = "Other", Value = "0" }));
            ViewBag.Customer_Type_List_Default = lstCustomer_Type_List_Default;
            List<SelectListItem> lstCustomer_Type_List_Other = new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "ROL_Other"), "Display_Value", "Display_Text").ToList();
            lstCustomer_Type_List_Other.Insert(0, (new SelectListItem { Text = "--Please Select--", Value = "0" }));
            ViewBag.Customer_Type_List_Other = lstCustomer_Type_List_Other;

            if (Syn_Deal_Code <= 0)
                objSD_Session.Customer_Type = Convert.ToInt32(((List<SelectListItem>)ViewBag.Customer_Type_List).First().Value);
            #endregion

            if (objSD_Session.Vendor_Contact_Code > 0)
            {
                Vendor_Contacts objVC = GetVendorContacts((int)objSD_Session.Vendor_Contact_Code);
                ViewBag.Vendor_Email = objVC.Email;
                ViewBag.Vendor_Phone = objVC.Phone_No;
            }
            if (objSD_Session.Sales_Agent_Contact_Code > 0)
            {
                Vendor_Contacts objVC = GetVendorContacts((int)objSD_Session.Sales_Agent_Contact_Code);
                ViewBag.Sale_Agent_Phone = objVC.Phone_No;
                ViewBag.Sale_Agent_Email = objVC.Email;
            }

            string AllowDealSegment = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Gen_Deal_Segment").Select(x => x.Parameter_Value).FirstOrDefault();
            ViewBag.DealSegment = AllowDealSegment;
            if (AllowDealSegment == "Y")
            {
                ViewBag.Deal_Segment = new SelectList(new Deal_Segment_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true), "Deal_Segment_Code", "Deal_Segment_Name").ToList();
            }

            string AllowRevenueVertical = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Gen_Revenue_Vertical").Select(x => x.Parameter_Value).FirstOrDefault();
            ViewBag.RevenueVertical = AllowRevenueVertical;
            if (AllowRevenueVertical == "Y")
            {
                ViewBag.Revenue_Vertical = new SelectList(new Revenue_Vertical_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true), "Revenue_Vertical_Code", "Revenue_Vertical_Name").ToList();
            }

        }
        public JsonResult BindAllPreReq_Async()
        {
            List<USP_Get_Acq_PreReq_Result> lstUSP_Get_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Syn_PreReq("CUR,CTG,BUT,SAV,LAC,ROL", "GEN", objLoginUser.Users_Code, Syn_Deal_Code, 0, 0).ToList();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Currency_List", new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "CUR"), "Display_Value", "Display_Text").ToList());
            obj.Add("Currency_Code", objSD_Session.Currency_Code ?? 0);
            obj.Add("Category_List", new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "CTG"), "Display_Value", "Display_Text").ToList());
            obj.Add("Category_Code", objSD_Session.Category_Code ?? 0);
            obj.Add("Business_Unit_List", new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "BUT"), "Display_Value", "Display_Text").ToList());
            obj.Add("Business_Unit_Code", objSD_Session.Business_Unit_Code ?? 0);
            obj.Add("Vendor_Code", objSD_Session.Vendor_Code ?? 0);
            obj.Add("Licensee_List", GetVendorList((int)objSD_Session.Customer_Type));
            obj.Add("Licensee_Contact_List", GetVendorContactList((int)(objSD_Session.Vendor_Code ?? 0)));
            obj.Add("Licensee_Contact_Code", objSD_Session.Vendor_Contact_Code ?? 0);
            obj.Add("Sales_Agent_List", new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For == "SAV"), "Display_Value", "Display_Text").ToList());
            obj.Add("Sales_Agent_Code", objSD_Session.Sales_Agent_Code ?? 0);
            obj.Add("Sales_Agent_Contact_List", GetVendorContactList((int)(objSD_Session.Sales_Agent_Code ?? 0)));
            obj.Add("Sales_Agent_Contact_Code", objSD_Session.Sales_Agent_Contact_Code ?? 0);
            obj.Add("Customer_List", new SelectList(lstUSP_Get_PreReq_Result.Where(x => x.Data_For.Contains("ROL")), "Display_Value", "Display_Text").ToList());
            obj.Add("Customer_Type", objSD_Session.Customer_Type ?? 0);
            return Json(obj);
        }

        private List<Syn_Deal_Movie> GetSynDealMovieList(int pageNo, int recordPerPage)
        {
            if (lstSyn_Deal_movie.Count == 0)
                SearchTitle("");

            List<Syn_Deal_Movie> lst = null;
            int RecordCount = 0;
            RecordCount = lstSyn_Deal_movie.Count;

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
                lstSyn_Deal_movie.Where(a => a.EntityState != State.Deleted).ToList().ForEach(x =>
                {
                    List<Acq_Deal_Movie> lst_Acq_Deal_Movie = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName)
                                                                .SearchFor(w => w.Title_Code == x.Title_Code && w.Acq_Deal.Deal_Workflow_Status == "A"
                                                                           && w.Acq_Deal.Acq_Deal_Rights.Any(i => i.Is_Tentative == "N" && i.Is_Sub_License == "Y")
                                                                          )
                                                                .Select(s => s)
                                                                .Distinct().ToList();
                    if (lst_Acq_Deal_Movie.Count > 0)
                    {
                        x.Min_Episode_Avail_From = lst_Acq_Deal_Movie.Select(s => s.Episode_Starts_From ?? 0).Min();
                        x.Max_Episode_Avail_To = lst_Acq_Deal_Movie.Select(s => s.Episode_End_To ?? 0).Max();
                    }
                    else
                        x.Min_Episode_Avail_From = x.Max_Episode_Avail_To = 0;
                });

                lst = lstSyn_Deal_movie.Where(a => a.EntityState != State.Deleted).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                objDeal_Schema.General_PageNo = pageNo;
            }
            return lst;
        }
        public JsonResult BindTitlePopup(int dealTypeCode, int replacingTitleCode = 0)
        {
            string SelectedTitle = string.Join(",", objSD_Session.Syn_Deal_Movie.Where(w => w.EntityState != State.Deleted && w.Title_Code != replacingTitleCode)
                                            .Select(s => Convert.ToInt32(s.Title_Code)).ToArray());
            Deal_Type_Code = dealTypeCode;

            int synDealCode = Syn_Deal_Code;
            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_CLONE)
                synDealCode = Clone_Syn_Deal_Code;

            List<SelectListItem> lstTitlePopup = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_Populate_Titles(synDealCode, Deal_Type_Code, 0, SelectedTitle, "S"), "Title_Code", "Title_Name").OrderBy(o => o.Text).ToList();
            return Json(lstTitlePopup, JsonRequestBehavior.AllowGet);
        }
        public PartialViewResult BindTitleGridview(int dealTypeCode, int pageNo, int recordPerPage)
        {
            Deal_Type_Code = dealTypeCode;
            ViewBag.Title_Label = GetTitleLabel(Deal_Type_Code);
            ViewBag.Deal_Type_Code = dealTypeCode;
            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            ViewBag.DealTypeCode_MasterDeal = 0;
            List<Syn_Deal_Movie> lst = GetSynDealMovieList(pageNo, recordPerPage);
            return PartialView("~/Views/Syn_Deal/_List_General_Title.cshtml", lst);
        }
        public JsonResult BindTitleLabel(int dealTypeCode)
        {
            Deal_Type_Code = dealTypeCode;
            string Title_Label = GetTitleLabel(Deal_Type_Code);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Title_Count", objSD_Session.Syn_Deal_Movie.Where(x => x.EntityState != State.Deleted).Count());
            obj.Add("Title_Label", Title_Label);
            obj.Add("Record_Count", lstSyn_Deal_movie.Count);
            obj.Add("Title_Search_List", GetTitleSearchList());
            return Json(obj);
        }
        #endregion

        #region --- Title Search ---
        private List<SelectListItem> GetTitleSearchList()
        {
            string[] arrSelectedTitle = (string.Join(",", objSD_Session.Syn_Deal_Movie.Where(w => w.EntityState != State.Deleted).Select(s => Convert.ToInt32(s.Title_Code)).ToArray())).Split(',');
            List<SelectListItem> lstTitleSearch = new SelectList(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrSelectedTitle.Contains(x.Title_Code.ToString())).Distinct(), "Title_Code", "Title_Name").OrderBy(o => o.Text).ToList();
            return lstTitleSearch;
        }
        public JsonResult SearchTitle(string selectedTitleCodes)
        {
            objDeal_Schema.General_Search_Title_Codes = selectedTitleCodes;
            string[] arrSelectedTitleCodes = selectedTitleCodes.Split(',');

            if (string.IsNullOrEmpty(selectedTitleCodes))
                lstSyn_Deal_movie = objSD_Session.Syn_Deal_Movie.Where(x => x.EntityState != State.Deleted).OrderBy(t => t.Title.Title_Name).ToList();
            else
                lstSyn_Deal_movie = objSD_Session.Syn_Deal_Movie.Where(x => x.EntityState != State.Deleted && arrSelectedTitleCodes.Contains(x.Title_Code.ToString())).OrderBy(t => t.Title.Title_Name).ToList();

            int recordCount = lstSyn_Deal_movie.Count;
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", "S");
            obj.Add("Record_Count", recordCount);
            return Json(obj);
        }
        #endregion

        #region --- Other Methods ---
        private string GetIconPath(int dealTypeCode, out string titleIconTooltip)
        {
            dealTypeCode = (dealTypeCode == 0) ? 1 : dealTypeCode;
            string iconPath = ConfigurationManager.AppSettings["TitleImagePath"].TrimStart('~').TrimStart('/');
            string fileName = ConfigurationManager.AppSettings["DefaultTitleIcon"];

            if (objSD_Session.Syn_Deal_Movie.Where(w => w.EntityState != State.Deleted).Select(i => i.Title_Code).Distinct().Count() == 1)
            {
                int title_Code = (int)objSD_Session.Syn_Deal_Movie.Where(w => w.EntityState != State.Deleted).First().Title_Code;
                RightsU_Entities.Title objT = new Title_Service(objLoginEntity.ConnectionStringName).GetById(title_Code);

                if (!string.IsNullOrEmpty(objT.Title_Image))
                    fileName = objT.Title_Image;
            }

            iconPath += fileName;
            Deal_Type_Code = dealTypeCode;
            objDeal_Schema.Title_Icon_Path = fileName;
            objDeal_Schema.Title_Icon_Tooltip = objMessageKey.DealType + " - " + GetTitleLabel(Deal_Type_Code);
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
                Title_Label = objMessageKey.Music;
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
            objSD_Session = null;
            objSDS = null;
            Session["Syn_Deal_Code"] = null;
            Session["Clone_Syn_Deal_Code"] = null;
        }
        //Added by akshay
        private Syn_Deal CloneSynDealObject(Syn_Deal objExisting_Syn_Deal)
        {
            Clone_Syn_Deal_Code = objExisting_Syn_Deal.Syn_Deal_Code;
            objSD_Session.Agreement_Date = objExisting_Syn_Deal.Agreement_Date;
            objSD_Session.Business_Unit_Code = objExisting_Syn_Deal.Business_Unit_Code;
            objSD_Session.Category_Code = objExisting_Syn_Deal.Category_Code;
            objSD_Session.Currency_Code = objExisting_Syn_Deal.Currency_Code;
            objSD_Session.Deal_Complete_Flag = objExisting_Syn_Deal.Deal_Complete_Flag;
            objSD_Session.Deal_Tag_Code = objExisting_Syn_Deal.Deal_Tag_Code;
            objSD_Session.Deal_Type = objExisting_Syn_Deal.Deal_Type;
            objSD_Session.Deal_Type_Code = objExisting_Syn_Deal.Deal_Type_Code;
            objSD_Session.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_New;
            objSD_Session.Entity_Code = objExisting_Syn_Deal.Entity_Code;
            objSD_Session.Exchange_Rate = objExisting_Syn_Deal.Exchange_Rate;
            objSD_Session.Is_Active = objExisting_Syn_Deal.Is_Active;
            objSD_Session.Is_Completed = objExisting_Syn_Deal.Is_Completed;
            objSD_Session.Is_Migrated = objExisting_Syn_Deal.Is_Migrated;
            objSD_Session.Parent_Syn_Deal_Code = objExisting_Syn_Deal.Parent_Syn_Deal_Code;
            objSD_Session.Payment_Remarks = objExisting_Syn_Deal.Payment_Remarks;
            objSD_Session.Payment_Terms_Conditions = objExisting_Syn_Deal.Payment_Terms_Conditions;
            objSD_Session.Ref_BMS_Code = objExisting_Syn_Deal.Ref_BMS_Code;
            objSD_Session.Ref_No = objExisting_Syn_Deal.Ref_No;
            objSD_Session.Remarks = objExisting_Syn_Deal.Remarks;
            objSD_Session.Rights_Remarks = objExisting_Syn_Deal.Rights_Remarks;
            objSD_Session.SaveGeneralOnly = objExisting_Syn_Deal.SaveGeneralOnly;
            objSD_Session.Status = objExisting_Syn_Deal.Status;
            objSD_Session.Vendor_Code = objExisting_Syn_Deal.Vendor_Code;
            objSD_Session.Vendor_Contact_Code = objExisting_Syn_Deal.Vendor_Contact_Code;
            objSD_Session.Version = "0001";
            objSD_Session.Work_Flow_Code = objExisting_Syn_Deal.Work_Flow_Code;
            objSD_Session.Year_Type = objExisting_Syn_Deal.Year_Type;
            objSD_Session.Other_Deal = objExisting_Syn_Deal.Other_Deal;
            objSD_Session.Deal_Description = objExisting_Syn_Deal.Deal_Description;
            objSD_Session.Total_Sale = objExisting_Syn_Deal.Total_Sale;
            objSD_Session.Customer_Type = objExisting_Syn_Deal.Customer_Type;
            objSD_Session.Sales_Agent_Code = objExisting_Syn_Deal.Sales_Agent_Code;
            objSD_Session.Sales_Agent_Contact_Code = objExisting_Syn_Deal.Sales_Agent_Contact_Code;
            objSD_Session.Attach_Workflow = objExisting_Syn_Deal.Attach_Workflow;
            objSD_Session.Deal_Segment_Code = objExisting_Syn_Deal.Deal_Segment_Code;
            //objSD_Session.Deal_Segment = objExisting_Syn_Deal.Deal_Segment;
            objSD_Session.Revenue_Vertical_Code = objExisting_Syn_Deal.Revenue_Vertical_Code;

            /*
                public State EntityState { get; set; }
                public int Syn_Deal_Movie_Code { get; set; }
                public Nullable<int> Syn_Deal_Code { get; set; }
                public Nullable<int> Title_Code { get; set; }
                public Nullable<int> No_Of_Episode { get; set; }
                public string Is_Closed { get; set; }
                public string Syn_Title_Type { get; set; }
                public string Remark { get; set; }
                public Nullable<int> Episode_From { get; set; }
                public Nullable<int> Episode_End_To { get; set; }


                public string _Dummy_Guid { get; set; }
                public string Dummy_Guid
                {
                    get
                    {
                        if (string.IsNullOrEmpty(_Dummy_Guid))
                            _Dummy_Guid = GetDummy_Guid();
                        return _Dummy_Guid;
                    }
                }
                private string GetDummy_Guid()
                {
                    return Guid.NewGuid().ToString();
                }
                public virtual Syn_Deal Syn_Deal { get; set; }
                public virtual Title Title { get; set; }
                public string Title_Type { get; set; }
                public Nullable<int> Min_Episode_Avail_From { get; set; }
                public Nullable<int> Max_Episode_Avail_To { get; set; }
             
             */
            objExisting_Syn_Deal.Syn_Deal_Movie.ToList().ForEach(a =>
            {
                Syn_Deal_Movie objSDM = new Syn_Deal_Movie();
                objSDM.Title_Code = a.Title_Code;
                objSDM.Title = new Title_Service(objLoginEntity.ConnectionStringName).GetById((int)a.Title_Code);
                objSDM.No_Of_Episode = a.No_Of_Episode;
                objSDM.Is_Closed = a.Is_Closed;
                objSDM.Title_Type = a.Title_Type;
                objSDM.Episode_From = a.Episode_From;
                objSDM.Remark = a.Remark;
                objSDM.Syn_Title_Type = a.Syn_Title_Type;
                objSDM.Episode_End_To = a.Episode_End_To;
                objSDM.EntityState = State.Added;
                objSDM.Is_Closed = "N";

                objSD_Session.Syn_Deal_Movie.Add(objSDM);

                Deal_Rights_Title_UDT objDRT_UDT = new Deal_Rights_Title_UDT();
                objDRT_UDT.Deal_Rights_Code = a.Syn_Deal_Movie_Code;
                objDRT_UDT.Title_Code = a.Title_Code;
                objDRT_UDT.Episode_From = a.Episode_From;
                objDRT_UDT.Episode_To = a.Episode_End_To;
                lstCloneDealRightsTitle.Add(objDRT_UDT);
            });
            return objSD_Session;
        }
        #endregion

        #region --- Save ---
        public JsonResult Save(Syn_Deal objSD_MVC, FormCollection objFormCollection)
        {
            string dealTypeCode = objFormCollection["hdnDeal_Type_Code"];
            //string dealDesc = objFormCollection["hdnDealDesc"];            
            int dealTagCode = Convert.ToInt32(objFormCollection["hdnDealTagStatusCode"]);
            string dealDesc = objFormCollection["hdnDealDesc"];
            string strMessage = "";
            string msg = "";
            string status = "S";
            string mode = "";
            string tabName = objFormCollection["hdnTabName"];
            string Reopenstate = objFormCollection["hdnReopenMode"];
            if (Reopenstate == "RO")
            {
                mode = GlobalParams.DEAL_MODE_EDIT;
                status = "SA";
            }
            else
                mode = objDeal_Schema.Mode;

            if (mode == GlobalParams.DEAL_MODE_REOPEN)
                objDeal_Schema.Deal_Workflow_Flag = objSD_Session.Deal_Workflow_Status = Convert.ToString(mode).Trim();

            int pageNo = objDeal_Schema.PageNo;
            List<USP_Validate_Show_Episode_UDT> result = new List<USP_Validate_Show_Episode_UDT>();
            if (Convert.ToInt32(dealTypeCode) != GlobalParams.Deal_Type_Movie)
                result = Validate_Episodes_Acquired(objSD_MVC.Syn_Deal_Movie.ToList());

            int errorPageIndex = 0, totalRecordCount = 0;
            if (result.Count <= 0)
            {
                //string agreementDate = objFormCollection["Agreement_Date"];                
                string agreementDate = objFormCollection["hdnAgreementDate"];
                /**/
                #region --- Update Original Object ---

                objSD_MVC.Agreement_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(agreementDate));
                objSD_Session.Agreement_Date = objSD_MVC.Agreement_Date;
                objSD_Session.Deal_Description = dealDesc.Trim();//objSD_MVC.Deal_Description;
                objSD_Session.Deal_Tag_Code = dealTagCode;//objSD_MVC.Deal_Tag_Code;
                objSD_Session.Year_Type = objSD_MVC.Year_Type;
                objSD_Session.Ref_No = objSD_MVC.Ref_No;
                objSD_MVC.Deal_Type_Code = Convert.ToInt32(dealTypeCode == "" ? GlobalParams.Deal_Type_Movie.ToString() : dealTypeCode);
                objSD_Session.Deal_Type_Code = objSD_MVC.Deal_Type_Code;
                Deal_Type_Code = (int)objSD_MVC.Deal_Type_Code;
                objSD_MVC.Vendor_Code = objSD_MVC.Vendor_Code;
                objSD_Session.Vendor_Code = objSD_MVC.Vendor_Code;
                objSD_Session.Currency_Code = objSD_MVC.Currency_Code;
                //objSD_Session.Entity_Code = objSD_MVC.Entity_Code;
                objSD_Session.Entity_Code = objLoginUser.Default_Entity_Code;
                objSD_Session.Business_Unit_Code = objSD_MVC.Business_Unit_Code;
                objSD_Session.Category_Code = objSD_MVC.Category_Code;

                if (objSD_MVC.Deal_Segment_Code != null && objSD_MVC.Deal_Segment_Code != 0)
                    objSD_Session.Deal_Segment_Code = objSD_MVC.Deal_Segment_Code;

                if (objSD_MVC.Revenue_Vertical_Code != null && objSD_MVC.Revenue_Vertical_Code != 0)
                    objSD_Session.Revenue_Vertical_Code = objSD_MVC.Revenue_Vertical_Code;

                objSD_Session.Vendor_Contact_Code = objSD_MVC.Vendor_Contact_Code > 0 ? objSD_MVC.Vendor_Contact_Code : null;
                objSD_Session.Sales_Agent_Code = objSD_MVC.Sales_Agent_Code > 0 ? objSD_MVC.Sales_Agent_Code : null;
                objSD_Session.Sales_Agent_Contact_Code = objSD_MVC.Sales_Agent_Contact_Code > 0 ? objSD_MVC.Sales_Agent_Contact_Code : null;
                objSD_Session.Customer_Type = objSD_MVC.Customer_Type;
                if (string.IsNullOrEmpty(objSD_MVC.Remarks))
                    objSD_MVC.Remarks = "";
                objSD_Session.Remarks = objSD_MVC.Remarks.Replace("\r\n", "\n");
                #endregion

                if (objSD_Session.Syn_Deal_Code > 0)
                    objSD_Session.EntityState = State.Modified;
                else
                {
                    objSD_Session.EntityState = State.Added;
                    objSD_Session.Version = "0001";
                    objSD_Session.Inserted_On = DateTime.Now;
                    objSD_Session.Inserted_By = objLoginUser.Users_Code;
                    objSD_Session.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_New;
                }
                objSD_Session.Status = "O";

                if (objSD_Session.Currency_Code != null && objSD_Session.Currency_Code > 0)
                {
                    Currency_Exchange_Rate objCER = new Currency_Service(objLoginEntity.ConnectionStringName).GetById((int)objSD_Session.Currency_Code).Currency_Exchange_Rate.Where(x => x.System_End_Date == null).FirstOrDefault();
                    if (objCER != null && objSD_Session != null)
                        objSD_Session.Exchange_Rate = objCER.Exchange_Rate;
                }
                objSD_Session.Last_Action_By = objLoginUser.Users_Code;
                objSD_Session.Last_Updated_Time = DateTime.Now;
                objSD_Session.Is_Active = "Y";
                bool returnVal = true;
                if (returnVal)
                {
                    strMessage = "";
                    Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
                    foreach (Syn_Deal_Movie objSDM_MVC in objSD_MVC.Syn_Deal_Movie)
                    {
                        Syn_Deal_Movie objSDM_Old = objSD_Session.Syn_Deal_Movie.Where(x => x.Dummy_Guid == objSDM_MVC.Dummy_Guid).FirstOrDefault();
                        if (objSDM_Old != null && objSDM_Old.EntityState == State.Deleted)
                            objSDM_MVC.EntityState = State.Deleted;
                    }
                }
                int pageSize = Convert.ToInt32(objFormCollection["txtPageSize"]);
                if (returnVal)
                {
                    UpdateTitleCollection(objSD_MVC.Syn_Deal_Movie.ToList(), true);
                    string[] arrErrorGuid = objSD_Session.Syn_Deal_Movie.Where(w => w.EntityState != State.Deleted &&
                               (w.Episode_From == null || w.Episode_End_To == null)
                              ).Select(s => s.Dummy_Guid).Distinct().ToArray();

                    if (arrErrorGuid.Length > 0)
                    {
                        lstSyn_Deal_movie = objSD_Session.Syn_Deal_Movie.Where(w => w.EntityState != State.Deleted).OrderBy(o => o.Title.Title_Name).ToList();
                        int[] arrNullTitles = lstSyn_Deal_movie.Where(w => w.EntityState != State.Deleted &&
                            arrErrorGuid.Contains(w.Dummy_Guid)).Select(s => (int)s.Title_Code).Distinct().ToArray();
                        int Object_Index = lstSyn_Deal_movie.FindIndex(w => w.EntityState != State.Deleted &&
                            arrErrorGuid.Contains(w.Dummy_Guid));
                        Object_Index++;

                        errorPageIndex = (Object_Index / pageSize);
                        if ((Object_Index % pageSize) > 0)
                            errorPageIndex++;

                        string strTitleNames = string.Join(", ", new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrNullTitles.Contains(s.Title_Code)).Select(s => s.Title_Name).ToArray());
                        strMessage = objMessageKey.PleaseenterEpisodenofor + strTitleNames;
                        if (Deal_Type_Code == GlobalParams.Deal_Type_Sports)
                            strMessage = objMessageKey.PleaseenterNoofMatchesfor + strTitleNames;
                        else if (Deal_Type_Code == GlobalParams.Deal_Type_Music || Deal_Type_Code == GlobalParams.Deal_Type_ContentMusic)
                            strMessage = objMessageKey.PleaseenterNoofSongsfor + strTitleNames;
                        else if (Deal_Type_Condition == GlobalParams.Sub_Deal_Talent)
                            strMessage = objMessageKey.PleaseenterNoofAppearancesfor + strTitleNames;

                        returnVal = false;
                    }

                    if (returnVal)
                    {
                        arrErrorGuid = (from Syn_Deal_Movie objF in objSD_Session.Syn_Deal_Movie.Where(x => x.EntityState != State.Deleted).ToList()
                                        from Syn_Deal_Movie objS in objSD_Session.Syn_Deal_Movie.Where(x => x.EntityState != State.Deleted).ToList()
                                        where objF.Title_Code == objS.Title_Code &&
                                        objF.Episode_From != null && objS.Episode_From != null
                                        && objF.Episode_End_To != null && objS.Episode_End_To != null
                                        && objF.Dummy_Guid != objS.Dummy_Guid &&
                                        (
                                            (objF.Episode_From >= objS.Episode_From && objF.Episode_From <= objS.Episode_End_To) ||
                                            (objS.Episode_From >= objF.Episode_From && objS.Episode_From <= objF.Episode_End_To)
                                        )
                                        select objF.Dummy_Guid
                        ).Distinct().ToArray();

                        if (arrErrorGuid.Length > 0)
                        {
                            lstSyn_Deal_movie = objSD_Session.Syn_Deal_Movie.Where(w => w.EntityState != State.Deleted).OrderBy(o => o.Title.Title_Name).ToList();
                            int[] arrOverLap = lstSyn_Deal_movie.Where(w => w.EntityState != State.Deleted &&
                            arrErrorGuid.Contains(w.Dummy_Guid)).Select(s => (int)s.Title_Code).Distinct().ToArray();
                            int Object_Index = lstSyn_Deal_movie.FindIndex(w => w.EntityState != State.Deleted &&
                                arrErrorGuid.Contains(w.Dummy_Guid));
                            Object_Index++;

                            errorPageIndex = (Object_Index / pageSize);
                            if ((Object_Index % pageSize) > 0)
                                errorPageIndex++;

                            string strTitleNames = string.Join(", ", new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrOverLap.Contains(s.Title_Code)).Select(s => s.Title_Name).ToArray());
                            strMessage = objMessageKey.OverlappingEpisodenoFor + strTitleNames;
                            if (Deal_Type_Code == GlobalParams.Deal_Type_Music || Deal_Type_Code == GlobalParams.Deal_Type_ContentMusic)
                                strMessage = objMessageKey.DuplicateNoofSongsfor + strTitleNames;

                            returnVal = false;
                        }
                    }

                    if (returnVal)
                    {
                        dynamic resultSet;
                        objSD_Session.Syn_Deal_Movie.Where(w => w.Syn_Deal_Movie_Code <= 0).ToList().ForEach(o => o.Title = null);
                        returnVal = objSDS.Save(objSD_Session, out resultSet);
                        if (returnVal)
                            objSD_Session.Deal_Complete_Flag = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objSD_Session.Syn_Deal_Code).Deal_Complete_Flag;
                        else
                            strMessage = "Error while saving data, " + resultSet;

                        if (returnVal)
                        {
                            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_CLONE && objSD_Session.Syn_Deal_Code > 0)
                            {
                                List<string> lstString = new USP_Service(objLoginEntity.ConnectionStringName)
                                    .USP_Syn_Deal_Clone_UDT(objSD_Session.Syn_Deal_Code, Clone_Syn_Deal_Code, objLoginUser.Users_Code, lstCloneDealRightsTitle).ToList();
                                string SelectedTitle = string.Join(",", objSD_Session.Syn_Deal_Movie.Where(w => w.EntityState != State.Deleted).Select(s => Convert.ToInt32(s.Title_Code)).ToArray());
                                //errorMessage = new USP_Service(objLoginEntity.ConnectionStringName).USP_Acq_Copy_Right_For_Sub_Deal(objSD_Session.Syn_Deal_Code, objSD_Session.Master_Deal_Movie_Code_ToLink,
                                // objLoginUser.Users_Code, SelectedTitle).First().ToString();
                                Session["lstCloneDealRightsTitle"] = null;
                                lstCloneDealRightsTitle = null;
                            }
                        }
                        if (returnVal)
                        {
                            if (!tabName.Equals(""))
                                BindSchemaObject();
                            else
                                objDeal_Schema = null;
                            if (status.Equals("SA"))
                                TempData["RedirectSynDeal"] = objSD_Session;
                            ClearSession();
                        }
                    }

                }

                if (!returnVal)
                {
                    totalRecordCount = lstSyn_Deal_movie.Count;
                    status = "E";
                }

                if ((status.Equals("S") || status.Equals("SA")) && tabName.Equals(""))
                {
                    msg = objMessageKey.DealSavedSuccessfully;
                    if (mode == GlobalParams.DEAL_MODE_EDIT)
                        msg = objMessageKey.DealUpdatedSuccessfully;
                }
            }

            string redirectUrl = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetRedirectURL(tabName, pageNo, null, objDeal_Schema.Deal_Type_Code, GlobalParams.ModuleCodeForSynDeal);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Error_Message", strMessage);
            obj.Add("Error_Page_Index", errorPageIndex);
            obj.Add("Total_Record_Count", totalRecordCount);
            obj.Add("Validation_Result", result);
            obj.Add("Success_Message", msg);
            obj.Add("Redirect_URL", redirectUrl);
            obj.Add("TabName", tabName);
            return Json(obj);
        }
        private void UpdateTitleCollection(List<Syn_Deal_Movie> list, bool isFinalSave = false)
        {
            objSD_Session.Syn_Deal_Movie.ToList<Syn_Deal_Movie>().ForEach(x => x.EntityState = (x.Syn_Deal_Movie_Code > 0 && x.EntityState != State.Deleted) ? State.Modified : x.EntityState);
            Syn_Deal_Movie objADM_Session = null;

            if (objSD_Session.Syn_Deal_Movie != null)
            {
                foreach (Syn_Deal_Movie objADM_MVC in list)
                {
                    objADM_Session = objSD_Session.Syn_Deal_Movie.Where(w => w.EntityState != State.Deleted && w.Dummy_Guid == objADM_MVC.Dummy_Guid).FirstOrDefault();

                    if (objADM_Session != null)
                    {
                        if (objADM_Session != null)
                        {
                            int oldEpisodeFrom = 0, oldEpisodeTo = 0, newEpisodeFrom = 0, newEpisodeTo = 0;
                            bool isUpdateRequired = false;

                            int Title_Code = (int)objADM_Session.Title_Code;

                            if (Deal_Type_Condition == GlobalParams.Deal_Music || Deal_Type_Condition == GlobalParams.Deal_Program)
                            {
                                if (objADM_Session.Syn_Deal_Movie_Code > 0 && isFinalSave)
                                {
                                    if (objADM_MVC.Episode_From != null && objADM_MVC.Episode_End_To != null)
                                    {
                                        isUpdateRequired = true;

                                        if (Deal_Type_Condition == GlobalParams.Deal_Music)
                                        {
                                            newEpisodeFrom = (int)objADM_MVC.Episode_End_To;
                                            newEpisodeTo = (int)objADM_MVC.Episode_End_To;
                                        }
                                        else
                                        {
                                            newEpisodeFrom = (int)objADM_MVC.Episode_From;
                                            newEpisodeTo = (int)objADM_MVC.Episode_End_To;
                                        }

                                        Syn_Deal_Movie objADM_DB = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).GetById(objADM_Session.Syn_Deal_Movie_Code);
                                        oldEpisodeFrom = (int)objADM_DB.Episode_From;
                                        oldEpisodeTo = (int)objADM_DB.Episode_End_To;

                                        if (oldEpisodeFrom == newEpisodeFrom && oldEpisodeTo == newEpisodeTo)
                                            isUpdateRequired = false;
                                    }
                                }
                            }
                            if (Deal_Type_Condition == GlobalParams.Deal_Music)
                            {
                                if (objADM_MVC.Episode_End_To != null)
                                    objADM_Session.Episode_From = objADM_MVC.Episode_End_To;
                                objADM_Session.Episode_End_To = objADM_MVC.Episode_End_To;
                            }
                            else if (Deal_Type_Condition == GlobalParams.Deal_Program)
                            {


                                Deal_Rights_Title_UDT objLstCloneUDT = lstCloneDealRightsTitle.Where(x => x.Title_Code == objADM_Session.Title_Code && x.Episode_From == objADM_Session.Episode_From
                                && x.Episode_To == objADM_Session.Episode_End_To).FirstOrDefault();

                                if (objLstCloneUDT != null)
                                {
                                    objLstCloneUDT.Episode_From = objADM_MVC.Episode_From;
                                    objLstCloneUDT.Episode_To = objADM_MVC.Episode_End_To;
                                }
                                objADM_Session.Episode_From = objADM_MVC.Episode_From;
                                objADM_Session.Episode_End_To = objADM_MVC.Episode_End_To;
                            }
                            //objADM_Session.Title_Type = objADM_MVC.Title_Type;
                            objADM_Session.Syn_Title_Type = objADM_MVC.Syn_Title_Type;
                            if (objADM_Session.Syn_Deal_Movie_Code > 0 && objADM_Session.EntityState != State.Deleted)
                                objADM_Session.EntityState = State.Modified;

                            if (isUpdateRequired)
                            {
                                #region --- Update Right Title ---
                                List<Syn_Deal_Rights_Title> lstRights = (from Syn_Deal_Rights objADR in objSD_Session.Syn_Deal_Rights
                                                                         from Syn_Deal_Rights_Title objADRT in objADR.Syn_Deal_Rights_Title
                                                                         where objADRT.Episode_From == oldEpisodeFrom && objADRT.Episode_To == oldEpisodeTo
                                                                         && objADRT.Title_Code == Title_Code
                                                                         select objADRT).ToList<Syn_Deal_Rights_Title>();

                                lstRights.ForEach(x =>
                                {
                                    x.EntityState = State.Modified;
                                    x.Episode_From = newEpisodeFrom;
                                    x.Episode_To = newEpisodeTo;
                                });
                                #endregion
                                #region --- Update Cost Title ---
                                List<Syn_Deal_Revenue_Title> lstCost = (from Syn_Deal_Revenue objADC in objSD_Session.Syn_Deal_Revenue
                                                                        from Syn_Deal_Revenue_Title objADCT in objADC.Syn_Deal_Revenue_Title
                                                                        where objADCT.Episode_From == oldEpisodeFrom && objADCT.Episode_To == oldEpisodeTo
                                                                                   && objADCT.Title_Code == Title_Code
                                                                        select objADCT).ToList<Syn_Deal_Revenue_Title>();

                                lstCost.ForEach(x =>
                                {
                                    x.EntityState = State.Modified;
                                    x.Episode_From = newEpisodeFrom;
                                    x.Episode_To = newEpisodeTo;
                                });
                                #endregion
                                #region --- Update Run Def Title ---
                                List<Syn_Deal_Run> lstRun = (from Syn_Deal_Run objSR in objSD_Session.Syn_Deal_Run
                                                             where objSR.Episode_From == oldEpisodeFrom && objSR.Episode_To == oldEpisodeTo
                                                                              && objSR.Title_Code == Title_Code
                                                             select objSR).ToList<Syn_Deal_Run>();

                                lstRun.ForEach(x =>
                                {
                                    x.EntityState = State.Modified;
                                    x.Episode_From = newEpisodeFrom;
                                    x.Episode_To = newEpisodeTo;
                                });
                                #endregion
                                #region --- Update Attachment Title ---
                                List<Syn_Deal_Attachment> lstAttachment = (from Syn_Deal_Attachment objADA in objSD_Session.Syn_Deal_Attachment
                                                                           where objADA.Episode_From == oldEpisodeFrom && objADA.Episode_To == oldEpisodeTo
                                                                              && objADA.Title_Code == Title_Code
                                                                           select objADA).ToList<Syn_Deal_Attachment>();

                                lstAttachment.ForEach(x =>
                                {
                                    x.EntityState = State.Modified;
                                    x.Episode_From = newEpisodeFrom;
                                    x.Episode_To = newEpisodeTo;
                                });
                                #endregion
                                #region --- Update Material Title ---
                                List<Syn_Deal_Material> lstMaterial = (from Syn_Deal_Material objADMaterial in objSD_Session.Syn_Deal_Material
                                                                       where objADMaterial.Episode_From == oldEpisodeFrom && objADMaterial.Episode_To == oldEpisodeTo
                                                                              && objADMaterial.Title_Code == Title_Code
                                                                       select objADMaterial).ToList<Syn_Deal_Material>();

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
        }
        private List<USP_Validate_Show_Episode_UDT> Validate_Episodes_Acquired(List<Syn_Deal_Movie> lst_Movie)
        {
            List<Deal_Rights_Title_UDT> listDeal_Rights_Title_UDT = new List<Deal_Rights_Title_UDT>();
            foreach (Syn_Deal_Movie objSDM in lst_Movie)
            {
                if (objSDM.Episode_From > 0 && objSDM.Episode_End_To > 0)
                {
                    Deal_Rights_Title_UDT objDeal_Rights_Title_UDT = new Deal_Rights_Title_UDT();
                    objDeal_Rights_Title_UDT.Title_Code = objSDM.Title_Code;
                    objDeal_Rights_Title_UDT.Episode_From = objSDM.Episode_From;
                    objDeal_Rights_Title_UDT.Episode_To = objSDM.Episode_End_To;
                    listDeal_Rights_Title_UDT.Add(objDeal_Rights_Title_UDT);
                }
            }
            List<USP_Validate_Show_Episode_UDT> result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_Show_Episode_UDT(listDeal_Rights_Title_UDT).ToList();
            return result;
        }

        public JsonResult SaveTitle(string titleCodes, int dealTypeCode)
        {
            string[] arrTitleCodes = titleCodes.Split(',');
            Deal_Type_Code = dealTypeCode;

            foreach (string code in arrTitleCodes)
            {
                int titleCode = Convert.ToInt32(code);
                Syn_Deal_Movie objSyn_Deal_Movie = new Syn_Deal_Movie();
                objSyn_Deal_Movie.EntityState = State.Added;
                objSyn_Deal_Movie.Title_Code = titleCode;
                objSyn_Deal_Movie.Is_Closed = "N";
                objSyn_Deal_Movie.Title = new Title_Service(objLoginEntity.ConnectionStringName).GetById(titleCode);

                if (Deal_Type_Condition == GlobalParams.Deal_Movie)
                {
                    objSyn_Deal_Movie.Episode_From = 1;
                    objSyn_Deal_Movie.Episode_End_To = 1;
                    objSyn_Deal_Movie.No_Of_Episode = 1;
                }
                else if (Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    objSyn_Deal_Movie.Episode_From = 1;
                    objSyn_Deal_Movie.No_Of_Episode = 1;
                }
                else if (Deal_Type_Condition == GlobalParams.Deal_Program && dealTypeCode == GlobalParams.Deal_Type_Sports)
                {
                    objSyn_Deal_Movie.Episode_From = 1;
                    objSyn_Deal_Movie.No_Of_Episode = 1;
                }

                objSD_Session.Syn_Deal_Movie.Add(objSyn_Deal_Movie);
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
        public JsonResult SaveTitleListData(List<Syn_Deal_Movie> titleList)
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
        public JsonResult DeleteTitle(string Dummy_Guid, int synDealMovieCode)
        {
            string status = "S", errorMessage = "";
            Syn_Deal_Movie objSDM = objSD_Session.Syn_Deal_Movie.Where(w => w.Dummy_Guid == Dummy_Guid && w.Syn_Deal_Movie_Code == synDealMovieCode).FirstOrDefault();
            if (objSDM.Syn_Deal_Movie_Code > 0)
            {
                StatusMessage objStatusMessage = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_General_Delete_For_Title(objSDM.Syn_Deal_Code, objSDM.Title_Code, objSDM.Episode_From, objSDM.Episode_End_To, "S").FirstOrDefault();
                if (objStatusMessage.Status == "E")
                {
                    status = objStatusMessage.Status;
                    errorMessage = objStatusMessage.Message;
                }
                else
                {
                    objSD_Session.Syn_Deal_Movie.Where(x => x.Title_Code == objSDM.Title_Code && x.Episode_From == objSDM.Episode_From
                     && x.Episode_End_To == objSDM.Episode_End_To).ToList().ForEach(f => f.EntityState = State.Deleted);
                }
                //int Flag = new USP_Service().USP_Validate_General_Delete_For_Title(objSDM.Syn_Deal_Code, objSDM.Title_Code, objSDM.Episode_From, objSDM.Episode_End_To, "S").ElementAt(0).Value;
                //if (Flag == 1)
                //{
                //    status = "E";
                //    errorMessage = "Can not delete this title as it is being used in other process.";
                //}
                //else
                //{
                //    objSD_Session.Syn_Deal_Movie.Where(x => x.Title_Code == objSDM.Title_Code && x.Episode_From == objSDM.Episode_From
                //    && x.Episode_End_To == objSDM.Episode_End_To).ToList().ForEach(f => f.EntityState = State.Deleted);
                //}
            }
            else
                objSD_Session.Syn_Deal_Movie.Remove(objSDM);
            bool bindSearch = false;
            if (status.Equals("S"))
            {
                lstSyn_Deal_movie.Remove(objSDM);
                if (lstSyn_Deal_movie.Where(x => x.Title_Code == objSDM.Title_Code && x.Episode_From == objSDM.Episode_From
                    && x.Episode_End_To == objSDM.Episode_End_To).Count() == 0)
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

        public JsonResult Replace_Title(string dummyGuid, int titleCode, string titleType, int episodeFrom, int episodeTo, int noOfEpisodes)
        {
            string status = "S", errorMessage = "", titleName = "", titleLanguageName = "", starCast = "", duration = "";
            #region --- actual Logic for Replace Title ---
            Syn_Deal_Movie objADM = objSD_Session.Syn_Deal_Movie.Where(dm => dm.Dummy_Guid == dummyGuid && dm.EntityState != State.Deleted).FirstOrDefault();

            if (objADM != null)
            {
                int oldTitleCode = (int)objADM.Title_Code;

                objADM.Title_Code = titleCode;

                int oldEpisodeFrom = 0;
                int oldEpisodeTo = 0;
                if (objADM.Episode_From != null)
                    oldEpisodeFrom = (int)objADM.Episode_From;
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
                //objADM.Notes = notes;
                objADM.Title_Type = titleType;
                objADM.Episode_From = episodeFrom;
                objADM.Episode_End_To = episodeTo;
                objADM.No_Of_Episode = noOfEpisodes;

                RightsU_Entities.Title objT = new Title_Service(objLoginEntity.ConnectionStringName).GetById(titleCode);
                titleName = objT.Title_Name;
                titleLanguageName = objT.Title_Languages.Language_Name;
                starCast = string.Join(", ", objT.Title_Talent.
                                Where(w => w.Role_Code == GlobalParams.RoleCode_StarCast).Select(s => s.Talent.Talent_Name).ToArray().Distinct());

                duration = Convert.ToString(objT.Duration_In_Min);
                objADM.Title = objT;
                UpdateTitleOnRenew(oldTitleCode, objADM, oldEpisodeFrom, oldEpisodeTo, objADM.Title_Code.Value);

                //if (a != null)
                //{
                //    objSDMS.Save(objADM, objADM, out dynamic resultSet);
                //}

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

        private void UpdateTitleOnRenew(int oldTitleCode, Syn_Deal_Movie objADM, int oldEpisodeFrom, int oldEpisodeTo, int newTitleCode)
        {
            #region --- Update Right Title ---
            List<Syn_Deal_Rights_Title> lstRights = (from Syn_Deal_Rights objADR in objSD_Session.Syn_Deal_Rights
                                                     from Syn_Deal_Rights_Title objADRT in objADR.Syn_Deal_Rights_Title
                                                     where objADRT.Episode_From == oldEpisodeFrom && objADRT.Episode_To == oldEpisodeTo
                                                     && objADRT.Title_Code == oldTitleCode
                                                     select objADRT).ToList<Syn_Deal_Rights_Title>();

            lstRights.ForEach(x =>
            {
                x.Title_Code = newTitleCode;
                x.EntityState = State.Modified;
                x.Episode_From = objADM.Episode_From;
                x.Episode_To = objADM.Episode_End_To;
            });

            objSD_Session.Syn_Deal_Rights.Where(r => r.Syn_Deal_Rights_Title.Any(objADRT => objADRT.Episode_From == oldEpisodeFrom && objADRT.Episode_To == oldEpisodeTo
                                                     && objADRT.Title_Code == oldTitleCode)).ToList().ForEach(r =>
                                                     {
                                                         r.Is_Verified = "N";
                                                     });
            #endregion
            #region --- Update Cost Title ---
            List<Syn_Deal_Revenue_Title> lstCost = (from Syn_Deal_Revenue objADC in objSD_Session.Syn_Deal_Revenue
                                                    from Syn_Deal_Revenue_Title objADCT in objADC.Syn_Deal_Revenue_Title
                                                    where objADCT.Episode_From == oldEpisodeFrom && objADCT.Episode_To == oldEpisodeTo
                                                               && objADCT.Title_Code == oldTitleCode
                                                    select objADCT).ToList<Syn_Deal_Revenue_Title>();

            lstCost.ForEach(x =>
            {
                x.Title_Code = newTitleCode;
                x.EntityState = State.Modified;
                x.Episode_From = objADM.Episode_From;
                x.Episode_To = objADM.Episode_End_To;
            });
            #endregion
            #region --- Update Run Def Title ---
            List<Syn_Deal_Run> lstRun = (from Syn_Deal_Run objSR in objSD_Session.Syn_Deal_Run
                                         where objSR.Episode_From == oldEpisodeFrom && objSR.Episode_To == oldEpisodeTo
                                                          && objSR.Title_Code == oldTitleCode
                                         select objSR).ToList<Syn_Deal_Run>();

            lstRun.ForEach(x =>
            {
                x.Title_Code = newTitleCode;
                x.EntityState = State.Modified;
                x.Episode_From = objADM.Episode_From;
                x.Episode_To = objADM.Episode_End_To;
            });
            #endregion
            #region --- Update Attachment Title ---
            List<Syn_Deal_Attachment> lstAttachment = (from Syn_Deal_Attachment objADA in objSD_Session.Syn_Deal_Attachment
                                                       where objADA.Episode_From == oldEpisodeFrom && objADA.Episode_To == oldEpisodeTo
                                                          && objADA.Title_Code == oldTitleCode
                                                       select objADA).ToList<Syn_Deal_Attachment>();

            lstAttachment.ForEach(x =>
            {
                x.Title_Code = newTitleCode;
                x.EntityState = State.Modified;
                x.Episode_From = objADM.Episode_From;
                x.Episode_To = objADM.Episode_End_To;
            });
            #endregion
            #region --- Update Material Title ---
            List<Syn_Deal_Material> lstMaterial = (from Syn_Deal_Material objADMaterial in objSD_Session.Syn_Deal_Material
                                                   where objADMaterial.Episode_From == oldEpisodeFrom && objADMaterial.Episode_To == oldEpisodeTo
                                                          && objADMaterial.Title_Code == oldTitleCode
                                                   select objADMaterial).ToList<Syn_Deal_Material>();

            lstMaterial.ForEach(x =>
            {
                x.Title_Code = newTitleCode;
                x.EntityState = State.Modified;
                x.Episode_From = objADM.Episode_From;
                x.Episode_To = objADM.Episode_End_To;
            });
            #endregion
        }
        #endregion

        #region--------- View Index Action Methods-------
        public PartialViewResult BindTopSynDetails()
        {
            ViewBag.DealDesc = new SelectList(new Deal_Description_Service(objLoginEntity.ConnectionStringName)
                                                .SearchFor(x => x.Is_Active == "Y" && x.Type == "S").Distinct().ToList(), "Deal_Desc_Name", "Deal_Desc_Name", objDeal_Schema.Deal_Desc); //&& x.Deal_Desc_Name != objDeal_Schema.Deal_Desc
            ViewBag.AcqSyn_Gen_Deal_Desc = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Gen_Deal_Desc_DDL").First().Parameter_Value;
            return PartialView("~/Views/Shared/_Top_Syn_Details.cshtml");
        }
        public JsonResult GetWorkflowStatusFromServer()
        {
            objDeal_Schema.Deal_Workflow_Status = new RightsU_BLL.USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Deal_DealWorkFlowStatus(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Workflow_Flag, 143, "S").First();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("DealWorkflowFlag", objDeal_Schema.Deal_Workflow_Flag);
            obj.Add("DealWorkflowStatus", objDeal_Schema.Deal_Workflow_Status);
            return Json(obj);
        }

        public JsonResult ProgramTitleChange(int replacingTitleCode = 0)
        {
            var TitleDetails = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName)
                .SearchFor(x => x.Title_Code == replacingTitleCode)
                .GroupBy(x => string.Empty)
                .Select(z => new
                {
                    Min = z.Min(x => x.Episode_Starts_From),
                    Max = z.Max(x => x.Episode_End_To)
                }
                ).FirstOrDefault();

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Min_Episode_Avail_From", TitleDetails.Min ?? 0);
            obj.Add("Max_Episode_Avail_To", TitleDetails.Max ?? 0);
            return Json(obj);
        }
        #endregion
    }
}
