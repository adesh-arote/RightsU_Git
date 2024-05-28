using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Acq_Cost_NewController : BaseController
    {
        #region --- Attributes & Properties ---

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

        public Acq_Deal_Cost_Service objAcq_Deal_Cost_Service
        {
            get
            {
                if (Session["Acq_Deal_Cost_Service"] == null)
                    Session["Acq_Deal_Cost_Service"] = new Acq_Deal_Cost_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Cost_Service)Session["Acq_Deal_Cost_Service"];
            }
            set { Session["Acq_Deal_Cost_Service"] = value; }
        }

        public Acq_Deal_Cost objAcq_Deal_Cost
        {
            get
            {
                if (Session["Acq_Deal_Cost"] == null)
                    Session["Acq_Deal_Cost"] = new Acq_Deal_Cost();
                return (Acq_Deal_Cost)Session["Acq_Deal_Cost"];
            }
            set { Session["Acq_Deal_Cost"] = value; }
        }

        public int PageNumber { get; set; }
        public int RecordCountGrid { get; set; }
        #endregion

        #region --- Actions ---

        public PartialViewResult Index(string Message = "", string MessageType = "")
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDeal);
            ViewBag.Message = Message;
            ViewBag.CommandName = "";
            int Deal_Code = objDeal_Schema.Deal_Code;
            objDeal_Schema.Page_From = GlobalParams.Page_From_Cost;
            objDeal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(Deal_Code);
            Session["objDeal"] = objDeal;
            ViewBag.PageMode = objDeal_Schema.Mode;
            ViewBag.Approver_Remark = objDeal_Schema.Approver_Remark;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
            if (objDeal_Schema.Cost_PageNo > 0)
            {
                ViewBag.Cost_PageNo = objDeal_Schema.Cost_PageNo;
            }
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;
            return PartialView("~/Views/Acq_Deal/_Acq_Cost_New_List.cshtml", objDeal.Acq_Deal_Cost.ToList());
        }
        
        public ActionResult Create(string isAdd, int page_No, int txtPageSize)
        {
            objAcq_Deal_Cost = objAcq_Deal_Cost_Service.GetById(0);
            ViewBag.CommandName = "Add";
            BindTitle("");
            BindCostType(0);
            if (isAdd == "1")
            {
                ViewBag.CommandName = "Add";
            }
            else
            {
                ViewBag.CommandName = "";
            }
            //return BindGridAcqCostNew(10, PageNo);
            return BindGridAcqCostNew(txtPageSize, page_No);
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
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            obj_Dic.Add("Page_No", pageNo.ToString());
            obj_Dic.Add("ReleaseRecord", "Y");
            TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
            return RedirectToAction("Index", "Acq_List");
        }

        public PartialViewResult Edit(int Acq_Deal_Cost_Code, int page_No, int txtPageSize)
        {
            ViewBag.Acq_Deal_Cost_Code = Acq_Deal_Cost_Code;
            Acq_Deal_Cost_Service objAcq_Deal_Cost_Service = new Acq_Deal_Cost_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal_Cost objAcq_Deal_Cost = objAcq_Deal_Cost_Service.GetById(Acq_Deal_Cost_Code);
            
            ViewBag.CommandName = "Edit";

            string titleCodes = "";
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                //titleCodes = string.Join(",", objAcq_Deal_Cost.Acq_Deal_Cost_Title.Where(x => objDeal.Acq_Deal_Movie.Any(y => y.Title_Code == x.Title_Code && y.Episode_Starts_From == x.Episode_From && y.Episode_End_To == x.Episode_To)).Select(x => x.));
                titleCodes = string.Join(",", objDeal.Acq_Deal_Movie.Where(x => objAcq_Deal_Cost.Acq_Deal_Cost_Title.Any(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_Starts_From && y.Episode_To == x.Episode_End_To)).Select(x => x.Acq_Deal_Movie_Code));
            }
            else
            {
                titleCodes = string.Join(",", objAcq_Deal_Cost.Acq_Deal_Cost_Title.Select(y => y.Title.Title_Code));
            }
            ViewBag.IsRefPayTerm = false;
            List<int> lstCostTypeCode = objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Select(r => (int)r.Cost_Type_Code).ToList();

            if (objDeal.Acq_Deal_Payment_Terms.Where(p => lstCostTypeCode.Contains((int)p.Cost_Type_Code)).Count() > 0)
            {
                ViewBag.IsRefPayTerm = true;
            }
            BindTitle(titleCodes);
            int CostTypeCode = objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Select(y => y.Cost_Type.Cost_Type_Code).Distinct().FirstOrDefault();

            BindCostType(CostTypeCode);

            return BindGridAcqCostNew(txtPageSize, page_No);
        }

        private void BindTitle(string titleCodes)
        {
            if (titleCodes == "")
            {
                ViewBag.lstTitle = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindTitle_List(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Code, "");
            }
            else
            {
                ViewBag.lstTitle = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindTitle_List(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Code, titleCodes);
            }
        }

        public string Delete(int Acq_Deal_Cost_Code)
        {
            string returnError = "N";
            if (Acq_Deal_Cost_Code > 0)
            {
                ViewBag.IsAddEditMode = "N";

                Acq_Deal_Cost objADC = objAcq_Deal_Cost_Service.GetById(Acq_Deal_Cost_Code);

                List<int> lstCostTypeCode = objADC.Acq_Deal_Cost_Costtype.Select(r => (int)r.Cost_Type_Code).ToList();

                if (objDeal.Acq_Deal_Payment_Terms.Where(p => lstCostTypeCode.Contains((int)p.Cost_Type_Code)).Count() > 0)
                {
                    returnError = "Y";
                }
                else
                {
                    foreach (Acq_Deal_Cost_Additional_Exp additionalExpInstance in objADC.Acq_Deal_Cost_Additional_Exp)
                    {
                        additionalExpInstance.EntityState = State.Deleted;
                    }

                    foreach (Acq_Deal_Cost_Commission commissionInstance in objADC.Acq_Deal_Cost_Commission)
                    {
                        commissionInstance.EntityState = State.Deleted;
                    }

                    foreach (Acq_Deal_Cost_Costtype costTypeInstance in objADC.Acq_Deal_Cost_Costtype)
                    {
                        costTypeInstance.EntityState = State.Deleted;
                    }

                    foreach (Acq_Deal_Cost_Title titleInstance in objADC.Acq_Deal_Cost_Title)
                    {
                        titleInstance.EntityState = State.Deleted;
                    }

                    foreach (Acq_Deal_Cost_Variable_Cost variableobjADC in objADC.Acq_Deal_Cost_Variable_Cost)
                    {
                        variableobjADC.EntityState = State.Deleted;
                    }

                    if (objADC != null)
                    {
                        dynamic resultStr;
                        objADC.EntityState = State.Deleted;
                        objAcq_Deal_Cost_Service.Save(objADC, out resultStr);
                    }
                }
            }
            return returnError;
        }

        [HttpPost]
        public PartialViewResult BindGridAcqCostNew(int txtPageSize, int page_No)
        {
            if (page_No > 1)
                page_No = page_No - 1;
            int Deal_Code = objDeal_Schema.Deal_Code;
            ModelState.Clear();
            objAcq_Deal_Cost_Service = new Acq_Deal_Cost_Service(objLoginEntity.ConnectionStringName);
            objDeal = null;
            objDeal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(Deal_Code);
            Session["objDeal"] = objDeal;

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
            TempData["SchemaPageNo"] = page_No + 1;

            List<Acq_Deal_Cost> lst_Acq_Deal_Cost;
            if (PageNo == 1)
                lst_Acq_Deal_Cost = objAcq_Deal_Cost_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Acq_Deal_Cost_Code).Take(pageSize).ToList();
            else
            {
                lst_Acq_Deal_Cost = objAcq_Deal_Cost_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Acq_Deal_Cost_Code).Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                if (lst_Acq_Deal_Cost.Count == 0)
                {
                    if (PageNo != 1)
                    {
                        objDeal_Schema.Cost_PageNo = PageNo - 1;
                        PageNo = PageNo - 1;
                    }
                    lst_Acq_Deal_Cost = objAcq_Deal_Cost_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Acq_Deal_Cost_Code).Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                }
            }

            ICollection<Acq_Deal_Cost> lst_Acq_Deal_CostTotal = objAcq_Deal_Cost_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).ToList();

            decimal TotalCost = Convert.ToDecimal((from Acq_Deal_Cost objDealCost in lst_Acq_Deal_CostTotal
                                                   select objDealCost.Deal_Cost).Sum());
            ViewBag.TotalDealCost = GlobalParams.CurrencyFormat((double)TotalCost);

            ViewBag.RecordCount = objAcq_Deal_Cost_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).Count();
            ViewBag.PageNo = PageNo;
            ViewBag.PageSize = txtPageSize;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;
            ViewBag.PageMode = objDeal_Schema.Mode;
            return PartialView("~/Views/Acq_Deal/_List_Cost_New.cshtml", lst_Acq_Deal_Cost);
        }

        public ActionResult ChangeTab(string hdnTabName)
        {
            objDeal_Schema.Cost_PageNo = Convert.ToInt32(TempData["SchemaPageNo"]);
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.Cost_PageNo, objDeal_Schema.Deal_Type_Code);
        }

        #endregion

        #region --- Methods ---
        private void ClearSession()
        {
            objDeal = null;
        }
        private void UpdateTitlesAndCostType(Acq_Deal_Cost objADC, string strCodes, int costType)
        {
            string[] arrCodes = strCodes.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            if (objADC.Acq_Deal_Cost_Title == null)
                objADC.Acq_Deal_Cost_Title = new HashSet<Acq_Deal_Cost_Title>();

            if (objADC.Acq_Deal_Cost_Costtype == null)
                objADC.Acq_Deal_Cost_Costtype = new HashSet<Acq_Deal_Cost_Costtype>();

            objADC.Acq_Deal_Cost_Title.ToList<Acq_Deal_Cost_Title>().ForEach(x => x.EntityState = State.Deleted);
            objADC.Acq_Deal_Cost_Costtype.ToList<Acq_Deal_Cost_Costtype>().ForEach(x => x.EntityState = State.Deleted);

            foreach (string strCode in arrCodes)
            {
                Acq_Deal_Cost_Title objADC_Title = new Acq_Deal_Cost_Title();
                Acq_Deal_Cost_Costtype obj_ADC_Costtype = new Acq_Deal_Cost_Costtype();

                int code = Convert.ToInt32((string.IsNullOrEmpty(strCode)) ? "0" : strCode);

                if (code > 0)
                {
                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    {
                        Title_List objTL = null;
                        objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == code).FirstOrDefault();

                        if (objTL != null)
                        {
                            objADC_Title.Episode_From = objTL.Episode_From;
                            objADC_Title.Episode_To = objTL.Episode_To;
                            objADC_Title.Title_Code = objTL.Title_Code;
                        }
                    }
                    else
                    {
                        objADC_Title.Episode_From = 1;
                        objADC_Title.Episode_To = 1;
                        objADC_Title.Title_Code = code;
                    }

                    objADC_Title.EntityState = State.Added;
                    objADC.Acq_Deal_Cost_Title.Add(objADC_Title);


                    obj_ADC_Costtype.Acq_Deal_Cost_Code = objADC.Acq_Deal_Cost_Code;
                    obj_ADC_Costtype.Cost_Type_Code = costType;
                    obj_ADC_Costtype.Amount = objADC.Deal_Cost;
                    obj_ADC_Costtype.Inserted_By = objLoginUser.Users_Code;
                    obj_ADC_Costtype.Inserted_On = DBUtil.getServerDate();
                    obj_ADC_Costtype.EntityState = State.Added;
                    objADC.Acq_Deal_Cost_Costtype.Add(obj_ADC_Costtype);
                }
            }
        }
        public string SaveCostNew(int Acq_Deal_Cost_Code, string Title_Codes, int Cost_Type_Code, decimal Deal_Cost, string Incentive, string Remarks)
        {
            string ReturnMessage = "Y";
            if (Acq_Deal_Cost_Code == 0)
            {
                if (ValidateCostTitleDuplication(Acq_Deal_Cost_Code, Title_Codes, Cost_Type_Code))
                {
                    Acq_Deal_Cost objAcq_Deal_Cost = new Acq_Deal_Cost();
                    Acq_Deal_Cost_Service objAcq_Deal_Cost_Service = new Acq_Deal_Cost_Service(objLoginEntity.ConnectionStringName);
                    objAcq_Deal_Cost.Acq_Deal_Code = objDeal.Acq_Deal_Code;
                    objAcq_Deal_Cost.Inserted_On = DateTime.Now;
                    objAcq_Deal_Cost.Inserted_By = objLoginUser.Users_Code;
                    objAcq_Deal_Cost.Currency_Code = objDeal.Currency_Code;
                    objAcq_Deal_Cost.Currency_Exchange_Rate= objDeal.Exchange_Rate;

                    objAcq_Deal_Cost.Deal_Cost = Deal_Cost;
                    objAcq_Deal_Cost.Incentive = Incentive;
                    objAcq_Deal_Cost.Remarks = Remarks;
                    //For Title and CostType
                    List<string> arrTitleCode = Title_Codes.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).ToList();

                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    {
                        List<int> lstTitleCode = objDeal_Schema.Title_List.Where(x => arrTitleCode.Contains(x.Acq_Deal_Movie_Code.ToString())).Select(x => x.Title_Code).ToList();

                        foreach (Acq_Deal_Cost_Title titleInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Title.Where(t => lstTitleCode.Contains(t.Title_Code.Value)))
                        {
                            titleInstance.EntityState = State.Modified;
                        }

                        foreach (Acq_Deal_Cost_Title titleInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Title.Where(t => !lstTitleCode.Contains(t.Title_Code.Value)))
                        {
                            titleInstance.EntityState = State.Deleted;
                        }
                    }
                    else
                    {
                        foreach (Acq_Deal_Cost_Title titleInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Title.Where(t => arrTitleCode.Contains(t.Title_Code.Value.ToString())))
                        {
                            titleInstance.EntityState = State.Modified;
                        }

                        foreach (Acq_Deal_Cost_Title titleInstance in objAcq_Deal_Cost.Acq_Deal_Cost_Title.Where(t => !arrTitleCode.Contains(t.Title_Code.Value.ToString())))
                        {
                            titleInstance.EntityState = State.Deleted;
                        }
                    }

                    foreach (string strTitleCode in arrTitleCode)
                    {
                        int titleCode = strTitleCode == "" ? 0 : Convert.ToInt32(strTitleCode.Trim());

                        if (titleCode > 0)
                        {
                            Acq_Deal_Cost_Title objADCT = new Acq_Deal_Cost_Title();
                            Acq_Deal_Cost_Costtype obj_ADC_Costtype = new Acq_Deal_Cost_Costtype();

                            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                            {
                                Title_List objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == titleCode).FirstOrDefault();

                                if (objAcq_Deal_Cost.Acq_Deal_Cost_Title.Where(w => w.Title_Code == objTL.Title_Code && w.Episode_From == objTL.Episode_From &&
                                    w.Episode_To == objTL.Episode_To).Count() == 0)
                                {
                                    objADCT.Title_Code = objTL.Title_Code;
                                    objADCT.Episode_From = objTL.Episode_From;
                                    objADCT.Episode_To = objTL.Episode_To;
                                    objAcq_Deal_Cost.Acq_Deal_Cost_Title.Add(objADCT);
                                }
                            }
                            else
                            {
                                if (objAcq_Deal_Cost.Acq_Deal_Cost_Title.Where(t => t.Title_Code == titleCode).Count() == 0)
                                {
                                    objADCT.Title_Code = titleCode;
                                    objADCT.Episode_From = 1;
                                    objADCT.Episode_To = 1;
                                    objAcq_Deal_Cost.Acq_Deal_Cost_Title.Add(objADCT);
                                }
                            }

                            obj_ADC_Costtype.Acq_Deal_Cost_Code = objAcq_Deal_Cost.Acq_Deal_Cost_Code;
                            obj_ADC_Costtype.Cost_Type_Code = Cost_Type_Code;
                            obj_ADC_Costtype.Amount = objAcq_Deal_Cost.Deal_Cost;
                            obj_ADC_Costtype.Inserted_By = objLoginUser.Users_Code;//objLoginUser.IntCode;
                            obj_ADC_Costtype.Inserted_On = DBUtil.getServerDate();
                            obj_ADC_Costtype.EntityState = State.Added;
                            objAcq_Deal_Cost.Acq_Deal_Cost_Costtype.Add(obj_ADC_Costtype);
                        }
                    }
                    //
                   

                    objAcq_Deal_Cost.EntityState = State.Added;
                    dynamic resultSet;
                    objAcq_Deal_Cost_Service.Save(objAcq_Deal_Cost, out resultSet);
                }
                else
                {
                    ReturnMessage = "N";
                }

            }
            else
            {
                Acq_Deal_Cost_Service objAcq_Deal_Cost_Service = new Acq_Deal_Cost_Service(objLoginEntity.ConnectionStringName);
                Acq_Deal_Cost objADC = objAcq_Deal_Cost_Service.GetById(Acq_Deal_Cost_Code);

                List<int> lstCostTypeCode = objADC.Acq_Deal_Cost_Costtype.Select(r => (int)r.Cost_Type_Code).ToList();
                int CostTypeCode = objADC.Acq_Deal_Cost_Costtype.Select(r => (int)r.Cost_Type_Code).FirstOrDefault();

                if (objDeal.Acq_Deal_Payment_Terms.Where(p => lstCostTypeCode.Contains((int)p.Cost_Type_Code)).Count() > 0)
                {
                    if(CostTypeCode != Cost_Type_Code)
                    {
                        ReturnMessage = "E";
                        return ReturnMessage;
                        //ReturnMessage = "N";
                    }
                }
                if (ReturnMessage != "N")
                {
                    Acq_Deal_Cost obj = objAcq_Deal_Cost_Service.GetById(Acq_Deal_Cost_Code);
                    if (obj != null)
                    {
                        if (ValidateCostTitleDuplication(Acq_Deal_Cost_Code, Title_Codes, Cost_Type_Code))
                        {
                            obj.EntityState = State.Modified;
                            obj.Acq_Deal_Code = objDeal.Acq_Deal_Code;
                            obj.Currency_Code = objDeal.Currency_Code;
                            obj.Currency_Exchange_Rate = objDeal.Exchange_Rate;
                            obj.Incentive = Incentive;
                            obj.Deal_Cost = Deal_Cost;
                            obj.Remarks = Remarks;
                            obj.Variable_Cost_Type = "N";
                            obj.Variable_Cost_Sharing_Type = "L";

                            UpdateTitlesAndCostType(obj, Title_Codes, Cost_Type_Code);
                            dynamic resultSet;
                            objAcq_Deal_Cost_Service.Save(obj, out resultSet);
                            string strResult = resultSet;
                        }
                        else
                        {
                            ReturnMessage = "N";
                        }
                    }
                }
            }
            return ReturnMessage;
        }
        private bool ValidateCostTitleDuplication(int Acq_Deal_Cost_Code, string strTitleCodes, int costTypeCode)
        {
            string validate = "";

            List<string> temp = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_Cost_Duplication_Colors(objDeal_Schema.Deal_Type_Condition, strTitleCodes, costTypeCode, Acq_Deal_Cost_Code, objDeal_Schema.Deal_Code).ToList();

            if (temp.Count() > 0)
                validate = temp[0][0].ToString();

            return validate == "Y" ? true : false;
        }
        private void BindCostType(int Cost_Type_Code)
        {
            if (Cost_Type_Code == 0)
            {
                List<SelectListItem> lstCost_Type = new SelectList(new Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Cost_Type_Code", "Cost_Type_Name").ToList();
                lstCost_Type.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
                ViewBag.lstCost_Type = lstCost_Type;
            }
            else
            {
                List<SelectListItem> lstCost_Type = new SelectList(new Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Cost_Type_Code", "Cost_Type_Name", Cost_Type_Code).ToList();
                lstCost_Type.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
                ViewBag.lstCost_Type = lstCost_Type;
            }
        }
        #endregion
    }
}
