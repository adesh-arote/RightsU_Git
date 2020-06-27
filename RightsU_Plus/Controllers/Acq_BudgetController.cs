using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Acq_BudgetController : BaseController
    {
        //
        // GET: /Acq_Budget/

        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.ACQ_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.ACQ_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.ACQ_DEAL_SCHEMA];
            }
            //get { return new Deal_Schema(); }
            set
            {
                Session[RightsU_Session.ACQ_DEAL_SCHEMA] = value;
            }
        }



        public Acq_Deal objAcq_Deal
        {
            get
            {
                if (Session[RightsU_Session.SESS_DEAL] == null)
                    Session[RightsU_Session.SESS_DEAL] = new Acq_Deal();
                return (Acq_Deal)Session[RightsU_Session.SESS_DEAL];
            }
            set { Session[RightsU_Session.SESS_DEAL] = value; }
        }

        public Acq_Deal_Budget_Service objAcq_Deal_Budget_Service
        {
            get
            {
                if (Session["Acq_Deal_Budget_Service"] == null)
                    Session["Acq_Deal_Budget_Service"] = new Acq_Deal_Budget_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Budget_Service)Session["Acq_Deal_Budget_Service"];
            }
            set { Session["Acq_Deal_Budget_Service"] = value; }
        }

        public SAP_WBS_Service objSAP_WBS_Service
        {
            get
            {
                if (Session["SAP_WBS_Service"] == null)
                    Session["SAP_WBS_Service"] = new SAP_WBS_Service(objLoginEntity.ConnectionStringName);
                return (SAP_WBS_Service)Session["SAP_WBS_Service"];
            }
            set { Session["SAP_WBS_Service"] = value; }
        }

        private List<Acq_Deal_Budget> lst_Acq_Deal_Budget
        {
            get
            {
                if (Session["lst_Acq_Deal_Budget"] == null)
                    Session["lst_Acq_Deal_Budget"] = new List<Acq_Deal_Budget>();
                return (List<Acq_Deal_Budget>)Session["lst_Acq_Deal_Budget"];
            }
            set
            {
                Session["lst_Acq_Deal_Budget"] = value;
            }
        }

        private List<USP_List_Acq_Budget_Result> lst_Usp_Acq_Budget_Result
        {
            get
            {
                if (Session["lst_Usp_Acq_Budget_Result"] == null)
                    Session["lst_Usp_Acq_Budget_Result"] = new List<USP_List_Acq_Budget_Result>();
                return (List<USP_List_Acq_Budget_Result>)Session["lst_Usp_Acq_Budget_Result"];
            }
            set
            {
                Session["lst_Usp_Acq_Budget_Result"] = value;
            }
        }

        public string TitleFilter
        {
            get
            {
                if (Session["TitleFilter"] == null)
                    Session["TitleFilter"] = "0";
                return (string)Session["TitleFilter"];
            }
            set { Session["TitleFilter"] = value; }
        }

        public Acq_Deal_Movie_Service objADMS
        {
            get
            {
                if (Session["Acq_Deal_Movie_Service"] == null)
                    Session["Acq_Deal_Movie_Service"] = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Movie_Service)Session["Acq_Deal_Movie_Service"];
            }
            set { Session["Acq_Deal_Movie_Service"] = value; }
        }

        public Acq_Deal_Budget objAcq_Deal_Budget
        {
            get
            {
                if (Session["Acq_Deal_Budget"] == null)
                    Session["Acq_Deal_Budget"] = new Acq_Deal_Budget();
                return (Acq_Deal_Budget)Session["Acq_Deal_Budget"];
            }
            set { Session["Acq_Deal_Budget"] = value; }
        }

        private const string WBS_Active_Status = "REL";

        public PartialViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDeal);
            if (TempData["TitleData"] != null)
            {
                TempData.Keep("TitleData");
            }
            string str = "PRP";
            char[] c = str.ToCharArray();
            c.Reverse();
            string rev = string.Join("", c);
            objDeal_Schema.Page_From = GlobalParams.Page_From_Budget;
            objAcq_Deal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            BindTitle();
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;
            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            Session["FileName"] = "";
            Session["FileName"] = "acq_Budget";
            return PartialView("~/Views/Acq_Deal/_Acq_Budget_List.cshtml");
        }

        public PartialViewResult BindBudget(int txtPageSize, string TitleFilter, int PageNo = 0, bool isOnLoad = false)
        {
            PageNo = PageNo + 1;
            lst_Usp_Acq_Budget_Result = null;
            lst_Acq_Deal_Budget = null;
            lst_Acq_Deal_Budget = new Acq_Deal_Budget_Service(objLoginEntity.ConnectionStringName).SearchFor(b => b.Acq_Deal_Code == objDeal_Schema.Deal_Code).ToList();
            List<Acq_Deal_Movie> lstAvailableTitle = new List<Acq_Deal_Movie>();
            string[] wbsStartWith = GetWBSType();
            List<int> lstTitleFilter = new List<int>();
            if (TitleFilter != "0" && TitleFilter != "")
                lstTitleFilter.AddRange(TitleFilter.Split(',').Select(s => Convert.ToInt32(s)).ToList());
            if (!wbsStartWith.Equals(""))
            {
                if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                {
                    List<RightsU_Entities.SAP_WBS> lstSap_WBS = new List<RightsU_Entities.SAP_WBS>();
                    List<int> lstINT = objAcq_Deal_Budget_Service.SearchFor(b => b.Acq_Deal_Code != objDeal_Schema.Deal_Code).Select(b => b.SAP_WBS_Code.Value).Distinct().ToList();

                    foreach (var valueToCheck in wbsStartWith)
                    {
                        List<RightsU_Entities.SAP_WBS> lstSW = new List<RightsU_Entities.SAP_WBS>();
                        lstSW = new SAP_WBS_Service(objLoginEntity.ConnectionStringName).SearchFor(s => !lstINT.Contains(s.SAP_WBS_Code) && s.Status.Trim().Equals(WBS_Active_Status)
                        && s.WBS_Code.StartsWith(valueToCheck)).ToList();

                        lstSap_WBS.AddRange(lstSW);
                    }

                    int[] arrTitleCodes = new USP_Service(objLoginEntity.ConnectionStringName).USP_GET_TITLE_FOR_RUN(objDeal_Schema.Deal_Code).Select(s => (int)s.Title_Code).ToArray();
                    IEnumerable<Acq_Deal_Movie> lstTitle = null;

                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    {
                        lstTitle = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(t => t.Acq_Deal_Code == objDeal_Schema.Deal_Code && arrTitleCodes.Contains(t.Acq_Deal_Movie_Code) && ((lstTitleFilter.Contains(t.Acq_Deal_Movie_Code) && lstTitleFilter.Count != 0) || lstTitleFilter.Count == 0)).ToList();

                        if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                            lstAvailableTitle = lstTitle.Where(t => !lst_Acq_Deal_Budget.Any(b => b.Title_Code == t.Title_Code && b.Episode_From == t.Episode_Starts_From)).ToList();
                        else
                            lstAvailableTitle = lstTitle.Where(t => !lst_Acq_Deal_Budget.Any(b => b.Title_Code == t.Title_Code && b.Episode_From == t.Episode_Starts_From && b.Episode_To == t.Episode_End_To)).ToList();
                    }
                    else
                    {
                        lstTitle = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(t => t.Acq_Deal_Code == objDeal_Schema.Deal_Code && 
                        arrTitleCodes.Contains((int)t.Title_Code) 
                        && ((lstTitleFilter.Contains(t.Title_Code.Value) && lstTitleFilter.Count != 0) || lstTitleFilter.Count == 0)).ToList();
                        lstAvailableTitle = lstTitle.Where(t => !lst_Acq_Deal_Budget.Any(b => b.Title_Code == t.Title_Code)).ToList();
                    }
                    if (isOnLoad)
                    {
                        var q = from dealTitle in lstTitle
                                join title in lstAvailableTitle on dealTitle.Title_Code equals title.Title_Code
                                join sapWbs in lstSap_WBS on title.Title.Title_Name.ToUpper() equals sapWbs.WBS_Description.ToUpper()
                                where dealTitle.Episode_Starts_From == title.Episode_Starts_From
                                && dealTitle.Episode_End_To == title.Episode_End_To
                                && dealTitle.Title_Code == title.Title_Code
                                select new Acq_Deal_Budget()
                                {
                                    Title_Code = dealTitle.Title_Code,
                                    Episode_From = dealTitle.Episode_Starts_From,
                                    Episode_To = dealTitle.Episode_End_To,
                                    SAP_WBS_Code = sapWbs.SAP_WBS_Code,
                                    Acq_Deal_Code = objDeal_Schema.Deal_Code,
                                    EntityState = State.Added
                                };
                        dynamic result;

                        foreach (var item in q)
                        {
                            objAcq_Deal_Budget_Service.Save(item, out result);
                            lstAvailableTitle.Remove(lstAvailableTitle.Where(t => t.Title_Code == item.Title_Code && t.Episode_Starts_From == item.Episode_From && t.Episode_End_To == item.Episode_To).FirstOrDefault());
                        }
                    }
                }

                int pageSize;
                if (txtPageSize != null)
                {
                    objDeal_Schema.Budget_PageSize = txtPageSize;
                    pageSize = Convert.ToInt32(txtPageSize);
                }
                else
                {
                    objDeal_Schema.Budget_PageSize = 50;
                    pageSize = 50;
                }

                ViewBag.SrNo_StartFrom = ((PageNo - 1) * pageSize);
                if (PageNo == 0)
                    PageNo = 1;
                lst_Usp_Acq_Budget_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Acq_Budget(objDeal_Schema.Deal_Code, TitleFilter).ToList();

                if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                {
                    foreach (var item in lstAvailableTitle)
                    {
                        RightsU_Entities.Title objTitle = new Title_Service(objLoginEntity.ConnectionStringName).GetById(item.Title_Code.Value);
                        lst_Usp_Acq_Budget_Result.Insert(0, new USP_List_Acq_Budget_Result { Title_Name = DBUtil.GetTitleNameInFormat(objDeal_Schema.Deal_Type_Condition, objTitle.Title_Name, item.Episode_Starts_From, item.Episode_End_To), Title_Code = item.Title_Code, Episode_From = item.Episode_Starts_From, Episode_To = item.Episode_End_To, WBS_Code = "", WBS_Description = "", Studio_Vendor = "", Original_Dubbed = "" });
                    }
                }
                ViewBag.RecordCount = lst_Usp_Acq_Budget_Result.Count;
                ViewBag.PageNo = PageNo;
                if (PageNo == 1)
                    ViewBag.BudgetResult = lst_Usp_Acq_Budget_Result.Take(pageSize).ToList();
                else
                {
                    ViewBag.BudgetResult = lst_Usp_Acq_Budget_Result.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                    if (lst_Usp_Acq_Budget_Result.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList().Count == 0)
                    {
                        if (PageNo != 1)
                        {
                            objDeal_Schema.Budget_PageNo = PageNo - 1;
                            PageNo = PageNo - 1;
                        }
                        ViewBag.BudgetResult = lst_Usp_Acq_Budget_Result.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                    }
                }
            }
            else
                ViewBag.BudgetResult = new List<USP_List_Acq_Budget_Result>();
            return PartialView("~/Views/Acq_Deal/_List_Budget.cshtml", ViewBag.BudgetResult);
        }

        private void BindTitle()
        {
            #region========================Bind Title List================
            string Title_Code_Search = "";
            if (objDeal_Schema.Rights_Titles != null)
                Title_Code_Search = objDeal_Schema.Rights_Titles;
            ViewBag.TitleList = new MultiSelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_GET_TITLE_FOR_RUN(objDeal_Schema.Deal_Code).Select(s => new { s.Title_Code, s.Title_Name }).ToList(), "Title_Code", "Title_Name"); //DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindTitle_List(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Code, Title_Code_Search);
            #endregion
        }

        public string[] GetWBSType()
        {
            string[] wbsStartWith = new WBS_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Deal_Type_Code == objDeal_Schema.Deal_Type_Code).Select(s => s.WBS_Type_Char).ToArray();
            return wbsStartWith;
        }

        public PartialViewResult AddBudget()
        {
            objAcq_Deal_Budget = new Acq_Deal_Budget();
            BindBudgetTitleList();
            return PartialView("~/Views/Acq_Deal/_Acq_Budget.cshtml", objAcq_Deal_Budget);
        }

        public PartialViewResult EditBudget(int Acq_Deal_Budget_Code)
        {
            objAcq_Deal_Budget_Service = new Acq_Deal_Budget_Service(objLoginEntity.ConnectionStringName);
            objAcq_Deal_Budget = objAcq_Deal_Budget_Service.GetById(Acq_Deal_Budget_Code);
            BindBudgetTitleList();
            return PartialView("~/Views/Acq_Deal/_Acq_Budget.cshtml", objAcq_Deal_Budget);
        }

        private void BindBudgetTitleList()
        {

            int[] arrTitleCodes = new USP_Service(objLoginEntity.ConnectionStringName).USP_GET_TITLE_FOR_RUN(objDeal_Schema.Deal_Code).Select(s => (int)s.Title_Code).ToArray();

            List<SelectListItem> lblBudgetTitle = new List<SelectListItem>();
            lblBudgetTitle = objADMS.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code &&
               (
                   (arrTitleCodes.Contains((int)x.Title_Code) && objDeal_Schema.Deal_Type_Condition != GlobalParams.Deal_Program
                   && objDeal_Schema.Deal_Type_Condition != GlobalParams.Deal_Music) ||
                   (arrTitleCodes.Contains(x.Acq_Deal_Movie_Code) && (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program
                   || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music))
               )
               ).ToList().
                   Where(x => !lst_Acq_Deal_Budget.Any(b => b.Title_Code == x.Title_Code && b.Episode_From == x.Episode_Starts_From && b.Episode_To == x.Episode_End_To)).
                   Select(s => new SelectListItem
                   {
                       Value = (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music) ? s.Acq_Deal_Movie_Code.ToString() : s.Title_Code.ToString(),
                       Text = DBUtil.GetTitleNameInFormat(objDeal_Schema.Deal_Type_Condition, s.Title.Title_Name, s.Episode_Starts_From, s.Episode_End_To)
                   }).OrderBy(o => o.Text).ToList();

            if (objAcq_Deal_Budget.Acq_Deal_Budget_Code > 0)
            {
                try
                {
                    var q = objADMS.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code &&
                        (
                            (arrTitleCodes.Contains((int)x.Title_Code) && objDeal_Schema.Deal_Type_Condition != GlobalParams.Deal_Program
                            && objDeal_Schema.Deal_Type_Condition != GlobalParams.Deal_Music) ||
                            (arrTitleCodes.Contains(x.Acq_Deal_Movie_Code) && (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program
                            || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music))
                        )
                        && x.Title_Code == objAcq_Deal_Budget.Title_Code && x.Episode_Starts_From == objAcq_Deal_Budget.Episode_From && x.Episode_End_To == objAcq_Deal_Budget.Episode_To).ToList().
                        Select(s => new SelectListItem
                        {
                            Value = (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music) ? s.Acq_Deal_Movie_Code.ToString() : s.Title_Code.ToString(),
                            Text = DBUtil.GetTitleNameInFormat(objDeal_Schema.Deal_Type_Condition, s.Title.Title_Name, s.Episode_Starts_From, s.Episode_End_To)
                        }).ElementAt(0);

                    lblBudgetTitle.Insert(0, q);
                }
                catch (Exception) { }
            }
        //    lblBudgetTitle.Insert(0, new SelectListItem { Text = "-- Please select --", Value = "0" });

            if (objAcq_Deal_Budget.Acq_Deal_Budget_Code == 0)
                ViewBag.BudgetTitle = new MultiSelectList(lblBudgetTitle, "Value", "Text");
            else
            {
                List<string> lstTitleCodes = new List<string>();
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    lstTitleCodes = objADMS.SearchFor(m => m.Title_Code == objAcq_Deal_Budget.Title_Code && m.Episode_Starts_From == objAcq_Deal_Budget.Episode_From && m.Episode_End_To == objAcq_Deal_Budget.Episode_To).Select(m => m.Acq_Deal_Movie_Code.ToString()).ToList();
                else
                    lstTitleCodes.Add(objAcq_Deal_Budget.Title_Code.ToString());

                ViewBag.BudgetTitle = new MultiSelectList(lblBudgetTitle, "Value", "Text", lstTitleCodes);
            }
        }

        public PartialViewResult Search_SAP_WBS(string txtWBSCode, int selectedWBSCode = 0)
        {
            string filterText = txtWBSCode;
            objSAP_WBS_Service = new SAP_WBS_Service(objLoginEntity.ConnectionStringName);
            List<int> lstWBS_OtherDeal = objAcq_Deal_Budget_Service.SearchFor(b => b.Acq_Deal_Code != objDeal_Schema.Deal_Code).Select(b => b.SAP_WBS_Code.Value).Distinct().ToList();
            List<RightsU_Entities.SAP_WBS> lstSap_WBS = new List<RightsU_Entities.SAP_WBS>();

            string[] wbsStartWith = GetWBSType();
            int wbsCode = 0;
            ViewBag.SelectedWBSCode = selectedWBSCode;

            if (!wbsStartWith.Equals(""))
            {              
                foreach (var valueToCheck in wbsStartWith)
                {
                    List<RightsU_Entities.SAP_WBS> lstSW = new List<RightsU_Entities.SAP_WBS>();
                    lstSW = objSAP_WBS_Service.SearchFor(s => s.SAP_WBS_Code != wbsCode && !lstWBS_OtherDeal.Contains(s.SAP_WBS_Code)
                        && s.WBS_Code.StartsWith(valueToCheck) && s.Status.Equals(WBS_Active_Status) &&
                        (s.WBS_Code.Contains(filterText) || s.WBS_Description.Contains(filterText) || s.Studio_Vendor.Contains(filterText)
                        || s.Original_Dubbed.Contains(filterText) || s.Status.Contains(filterText) || s.Sport_Type.Contains(filterText)
                        || s.Short_ID.Contains(filterText))).ToList();

                    lstSap_WBS.AddRange(lstSW);
                }

            }
            if (wbsCode > 0)
                lstSap_WBS.Insert(0, objSAP_WBS_Service.GetById(wbsCode));

            return PartialView("~/Views/Acq_Deal/_List_SAP_WBS.cshtml", lstSap_WBS);
        }

        public PartialViewResult Get_SAP_WBS_By_Id(string selectedWBSCode)
        {
            objSAP_WBS_Service = new SAP_WBS_Service(objLoginEntity.ConnectionStringName);
            ViewBag.SelectedWBSCode = Convert.ToInt32(selectedWBSCode);
            List<RightsU_Entities.SAP_WBS> lstSap_WBS = new List<RightsU_Entities.SAP_WBS>();
            lstSap_WBS.Insert(0, objSAP_WBS_Service.GetById(Convert.ToInt32(selectedWBSCode)));
            return PartialView("~/Views/Acq_Deal/_List_SAP_WBS.cshtml", lstSap_WBS);
        }

        public string Save_Budget(Acq_Deal_Budget objAcq_Deal_Budget, string lbTitle_Popup, string hdnlbTitleCode , int SAP_WBS_Code = 0)
        {
            dynamic resultSet;
            if (objAcq_Deal_Budget.Acq_Deal_Budget_Code > 0)
            {
                objAcq_Deal_Budget = objAcq_Deal_Budget_Service.GetById(objAcq_Deal_Budget.Acq_Deal_Budget_Code);
                objAcq_Deal_Budget.EntityState = State.Deleted;
                objAcq_Deal_Budget_Service.Save(objAcq_Deal_Budget, out resultSet);           
            }
            else
                objAcq_Deal_Budget = new Acq_Deal_Budget();

            string message = string.Empty;
            string[] arrTitleCode = hdnlbTitleCode.Split(',').ToArray();
            foreach (string lbTitleCode in arrTitleCode)
            {
                    objAcq_Deal_Budget = new Acq_Deal_Budget();
                    int code = Convert.ToInt32(lbTitleCode);
                    Acq_Deal_Movie objDealMovie;
                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                        objDealMovie = objADMS.GetById(code);
                    else
                        objDealMovie = objADMS.SearchFor(s => s.Title_Code == code && s.Acq_Deal_Code == objDeal_Schema.Deal_Code).FirstOrDefault();

                    objAcq_Deal_Budget.Title_Code = objDealMovie.Title_Code;
                    objAcq_Deal_Budget.Episode_From = objDealMovie.Episode_Starts_From;
                    objAcq_Deal_Budget.Episode_To = objDealMovie.Episode_End_To;
                    objAcq_Deal_Budget.Acq_Deal_Code = objDealMovie.Acq_Deal_Code;

                    objAcq_Deal_Budget.SAP_WBS_Code = SAP_WBS_Code;
                    if (objAcq_Deal_Budget.Acq_Deal_Budget_Code > 0)
                    {
                        objAcq_Deal_Budget.EntityState = State.Modified;
                        message = objMessageKey.AcquisitionTitleBudgetupdatedsuccessfully;
                    }
                    else
                    {
                        objAcq_Deal_Budget.EntityState = State.Added;
                        message = objMessageKey.AcquisitionTitleBudgetaddedsuccessfully;
                    }
                   objAcq_Deal_Budget_Service.Save(objAcq_Deal_Budget, out resultSet);
           }      
            return message;
        }

        public void DeleteBudget(int Acq_Deal_Budget_Code)
        {
            dynamic resultSet;
            Acq_Deal_Budget objAcqDealBudget = objAcq_Deal_Budget_Service.GetById(Acq_Deal_Budget_Code);
            objAcqDealBudget.EntityState = State.Deleted;
            objAcq_Deal_Budget_Service.Save(objAcqDealBudget, out resultSet);
        }


        public string ValidateTitle(int code, int SelectedWBSCode)
        {
            string message = "Success";
            int selectWBSCode = SelectedWBSCode;
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                Acq_Deal_Movie objDealMovie = objADMS.GetById(code);
                if (objAcq_Deal_Budget_Service.SearchFor(b => b.Acq_Deal_Budget_Code != objAcq_Deal_Budget.Acq_Deal_Budget_Code && b.Title_Code == objDealMovie.Title_Code && b.Episode_From == objDealMovie.Episode_Starts_From && b.Episode_To == objDealMovie.Episode_End_To && b.SAP_WBS_Code == selectWBSCode && b.Acq_Deal_Code == objDeal_Schema.Deal_Code).Count() > 0)
                {
                    return objMessageKey.TitlewithselectedWBScodewasalreadyadded;
                }
                else
                    if (objAcq_Deal_Budget_Service.SearchFor(b => b.Acq_Deal_Budget_Code != objAcq_Deal_Budget.Acq_Deal_Budget_Code && b.SAP_WBS_Code == selectWBSCode && b.Acq_Deal_Code != objDeal_Schema.Deal_Code).Count() > 0)
                {
                    return objMessageKey.SelectedWBScodewasalreadyassociatedwithotherdeal;
                }
            }
            else
            {
                if (objAcq_Deal_Budget_Service.SearchFor(b => b.Acq_Deal_Budget_Code != objAcq_Deal_Budget.Acq_Deal_Budget_Code && b.Title_Code == code && b.SAP_WBS_Code == selectWBSCode && b.Acq_Deal_Code == objDeal_Schema.Deal_Code).Count() > 0)
                {
                    return objMessageKey.TitlewithselectedWBScodewasalreadyadded;
                }
                else
                    if (objAcq_Deal_Budget_Service.SearchFor(b => b.Acq_Deal_Budget_Code != objAcq_Deal_Budget.Acq_Deal_Budget_Code && b.SAP_WBS_Code == selectWBSCode && b.Acq_Deal_Code != objDeal_Schema.Deal_Code).Count() > 0)
                {
                    return objMessageKey.SelectedWBScodewasalreadyassociatedwithotherdeal;
                }
            }
            return message;
        }

        public ActionResult ChangeTab(string hdnTabName)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code);
        }

    }
}
