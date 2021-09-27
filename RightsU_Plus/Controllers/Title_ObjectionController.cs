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
    public class Title_ObjectionController : BaseController
    {
        #region Properties

        private List<RightsU_Entities.USP_Title_Objection_List_Result> lstUSP_Title_Objection_List
        {
            get
            {
                if (Session["lstUSP_Title_Objection_List"] == null)
                    Session["lstUSP_Title_Objection_List"] = new List<RightsU_Entities.USP_Title_Objection_List_Result>();
                return (List<RightsU_Entities.USP_Title_Objection_List_Result>)Session["lstUSP_Title_Objection_List"];
            }
            set { Session["lstUSP_Title_Objection_List"] = value; }
        }
        private List<RightsU_Entities.USP_Title_Objection_List_Result> lstUSP_Title_Objection_List_Searched
        {
            get
            {
                if (Session["lstUSP_Title_Objection_List_Searched"] == null)
                    Session["lstUSP_Title_Objection_List_Searched"] = new List<RightsU_Entities.USP_Title_Objection_List_Result>();
                return (List<RightsU_Entities.USP_Title_Objection_List_Result>)Session["lstUSP_Title_Objection_List_Searched"];
            }
            set { Session["lstUSP_Title_Objection_List_Searched"] = value; }
        }

        private List<RightsU_Entities.USP_Title_Objection_PreReq_Result> lstUSP_Title_Objection_PreReq
        {
            get
            {
                if (Session["lstUSP_Title_Objection_PreReq"] == null)
                    Session["lstUSP_Title_Objection_PreReq"] = new List<RightsU_Entities.USP_Title_Objection_PreReq_Result>();
                return (List<RightsU_Entities.USP_Title_Objection_PreReq_Result>)Session["lstUSP_Title_Objection_PreReq"];
            }
            set { Session["lstUSP_Title_Objection_PreReq"] = value; }
        }

        private List<Title_Licensor> lstTitle_Licensor
        {
            get
            {
                if (Session["lstTitle_Licensor"] == null)
                    Session["lstTitle_Licensor"] = new List<Title_Licensor>();
                return (List<Title_Licensor>)Session["lstTitle_Licensor"];
            }
            set { Session["lstTitle_Licensor"] = value; }
        }

        #endregion
        public ActionResult Index(int TitleObjectCode = 0, string callFrom = "LIST")
        {
            var ListAcq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Title_Objection_List("X", "", "").ToList()
                        .Select(x => new { x.Title_Code, x.Title, x.Licensor, x.Licensor_Code }).ToList().Distinct();

            var ListSyn = new USP_Service(objLoginEntity.ConnectionStringName).USP_Title_Objection_List("Y", "", "").ToList()
                                    .Select(x => new { x.Title_Code, x.Title, x.Licensor, x.Licensor_Code }).ToList().Distinct();

            Title_Licensor obj = null;

            foreach (var item in ListAcq)
            {
                obj = new Title_Licensor
                {
                    Acq_Syn = "A",
                    Title = item.Title,
                    Title_Code = item.Title_Code,
                    Licensor = item.Licensor,
                    Licensor_Code = item.Licensor_Code
                };
                lstTitle_Licensor.Add(obj);
            }

            foreach (var item in ListSyn)
            {
                obj = new Title_Licensor
                {
                    Acq_Syn = "S",
                    Title = item.Title,
                    Title_Code = item.Title_Code,
                    Licensor = item.Licensor,
                    Licensor_Code = item.Licensor_Code
                };
                lstTitle_Licensor.Add(obj);
            }

            ViewBag.TitleObjectCode = TitleObjectCode;
            ViewBag.callFrom = callFrom;
            return View();
        }
        public PartialViewResult BindPartialPages(string key, string Record_Type = "A", int Title_Code = 0, int Deal_Code = 0, int TitleObjectCode = 0)
        {

            if (key != "LIST")
                lstUSP_Title_Objection_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Title_Objection_PreReq(Title_Code, Deal_Code, Record_Type,"").ToList();

            if (key == "LIST")
            {
                ViewBag.Type = Record_Type;
                ViewBag.ddlTitle = new SelectList(lstTitle_Licensor.Where(x => x.Acq_Syn == Record_Type).Select(x => new { x.Title, x.Title_Code }).ToList().Distinct(), "Title_Code", "Title");
                ViewBag.ddlLicensor = new SelectList(lstTitle_Licensor.Where(x => x.Acq_Syn == Record_Type).Select(x => new { x.Licensor_Code, x.Licensor }).ToList().Distinct(), "Licensor_Code", "Licensor");

                lstUSP_Title_Objection_List_Searched = lstUSP_Title_Objection_List = new USP_Service(objLoginEntity.ConnectionStringName).USP_Title_Objection_List(Record_Type, "", "").ToList();
                ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/Title_Objection/_Title_Objection.cshtml");
            }
            else if (key == "ADD")
            {
                Title_Objection objTO = new Title_Objection();
                //ViewBag.objTitle_Objection = objTO;

                ViewBag.Type = Record_Type;

                var CountryList = lstUSP_Title_Objection_PreReq.Where(x => x.MapFor == "TERRITORY" && x.CodeFor == "I").Select(x => new { Country_Code = x.Code, Country_Name = x.Obj_Type_Name }).ToList();
                ViewBag.ddlCT = new SelectList(CountryList, "Country_Code", "Country_Name");

                var SDEDList = lstUSP_Title_Objection_PreReq.Where(x => x.MapFor == "SDED" && x.EndDate != null).Select(x =>
                 new
                 {
                     Display_Value = ((DateTime)x.StartDate).ToString("dd-MMM-yyyy") + "~" + ((DateTime)x.EndDate).ToString("dd-MMM-yyyy"),
                     Display_Text = ((DateTime)x.StartDate).ToString("dd/MM/yyyy") + " To " + ((DateTime)x.EndDate).ToString("dd/MM/yyyy")
                 }).ToList();

                var SDEDList1 = lstUSP_Title_Objection_PreReq.Where(x => x.MapFor == "SDED" && x.EndDate == null).Select(x =>
                 new
                 {
                     Display_Value = ((DateTime)x.StartDate).ToString("dd-MMM-yyyy") + "~(Perpetuity)",
                     Display_Text = ((DateTime)x.StartDate).ToString("dd/MM/yyyy") + " (Perpetuity) "
                 }).ToList();

                SDEDList.AddRange(SDEDList1);
                ViewBag.ddlLP = new SelectList(SDEDList, "Display_Value", "Display_Text");

                ViewBag.ddlTitle_Status = new SelectList(new Title_Objection_Status_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList(), "Title_Objection_Status_Code", "Objection_Status_Name");

                USP_Title_Objection_List_Result objUTO = lstUSP_Title_Objection_List_Searched.Where(x => x.Acq_Deal_Code == Deal_Code && x.Title_Code == Title_Code).FirstOrDefault();
                ViewBag.obj_Usp_TO = objTO;
                return PartialView("~/Views/Title_Objection/_Add_Title_Objection.cshtml", objUTO);
            }
            else if (key == "EDIT")
            {

                Title_Objection objTO = new Title_Objection_Service(objLoginEntity.ConnectionStringName).GetById(TitleObjectCode);
                ViewBag.Type = objTO.Record_Type;
                string PCodes = String.Join(",", new Title_Objection_Platform_Service(objLoginEntity.ConnectionStringName)
                    .SearchFor(x => x.Title_Objection_Code == TitleObjectCode).Select(x => x.Platform_Code).ToList());

                lstUSP_Title_Objection_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Title_Objection_PreReq(objTO.Title_Code, objTO.Record_Code, objTO.Record_Type, PCodes).ToList();

                var objUTO = new USP_Service(objLoginEntity.ConnectionStringName)
                    .USP_Title_Objection_List(objTO.Record_Type, objTO.Title_Code.ToString(), "")
                    .Where(x => x.Acq_Deal_Code == objTO.Record_Code && x.Title_Code == objTO.Title_Code).FirstOrDefault();
                ViewBag.obj_Usp_TO = objTO;

                var lstTOT = new Title_Objection_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Objection_Code == TitleObjectCode).ToList();
                string CTType = lstTOT.FirstOrDefault().Territory_Type;

                ViewBag.CTCodes = CTType == "G" ? String.Join(",", lstTOT.Select(x => x.Territory_Code).ToList()) : String.Join(",", lstTOT.Select(x => x.Country_Code).ToList());
                ViewBag.PCodes = PCodes;

                var abc = new Title_Objection_Rights_Period_Service(objLoginEntity.ConnectionStringName)
                    .SearchFor(x => x.Title_Objection_Code == TitleObjectCode)
                    .Select(x => new { x.Rights_Start_Date, x.Rights_End_Date })
                    .ToList();

                var RPCodes = abc.Where(x => x.Rights_End_Date != null).Select(x => ((DateTime)x.Rights_Start_Date).ToString("dd-MMM-yyyy") + "~" + ((DateTime)x.Rights_End_Date).ToString("dd-MMM-yyyy")).ToList();
                var RPCodes1 = abc.Where(x => x.Rights_End_Date == null).Select(x => ((DateTime)x.Rights_Start_Date).ToString("dd-MMM-yyyy") + "~(Perpetuity)").ToList();
                RPCodes.AddRange(RPCodes1);

                ViewBag.RPCodes = RPCodes.FirstOrDefault();

                var CountryList = lstUSP_Title_Objection_PreReq.Where(x => x.MapFor == "TERRITORY" && x.CodeFor == (CTType == "G" ? "G" : "I")).Select(x => new { Country_Code = x.Code, Country_Name = x.Obj_Type_Name }).ToList();
                ViewBag.ddlCT = new SelectList(CountryList, "Country_Code", "Country_Name");

                var SDEDList = lstUSP_Title_Objection_PreReq.Where(x => x.MapFor == "SDED" && x.EndDate != null).Select(x =>
              new
              {
                  Display_Value = ((DateTime)x.StartDate).ToString("dd-MMM-yyyy") + "~" + ((DateTime)x.EndDate).ToString("dd-MMM-yyyy"),
                  Display_Text = ((DateTime)x.StartDate).ToString("dd/MM/yyyy") + " To " + ((DateTime)x.EndDate).ToString("dd/MM/yyyy")
              }).ToList();

                var SDEDList1 = lstUSP_Title_Objection_PreReq.Where(x => x.MapFor == "SDED" && x.EndDate == null).Select(x =>
                 new
                 {
                     Display_Value = ((DateTime)x.StartDate).ToString("dd-MMM-yyyy") + "~(Perpetuity)",
                     Display_Text = ((DateTime)x.StartDate).ToString("dd/MM/yyyy") + " (Perpetuity) "
                 }).ToList();

                SDEDList.AddRange(SDEDList1);
                ViewBag.ddlLP = new SelectList(SDEDList, "Display_Value", "Display_Text");

                ViewBag.ddlTitle_Status = new SelectList(new Title_Objection_Status_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList(), "Title_Objection_Status_Code", "Objection_Status_Name", objTO.Title_Objection_Status_Code);

                return PartialView("~/Views/Title_Objection/_Edit_Title_Objection.cshtml", objUTO);
            }
            else if (key == "VIEW")
            {

                Title_Objection objTO = new Title_Objection_Service(objLoginEntity.ConnectionStringName).GetById(TitleObjectCode);
                ViewBag.Type = objTO.Record_Type;

                var objUTO = new USP_Service(objLoginEntity.ConnectionStringName)
                    .USP_Title_Objection_List(objTO.Record_Type, objTO.Title_Code.ToString(), "")
                    .Where(x => x.Acq_Deal_Code == objTO.Record_Code && x.Title_Code == objTO.Title_Code).FirstOrDefault();
                ViewBag.obj_Usp_TO = objTO;

                var lstTOT = new Title_Objection_Territory_Service(objLoginEntity.ConnectionStringName)
                    .SearchFor(x => x.Title_Objection_Code == TitleObjectCode).ToList();
                string CTType = lstTOT.FirstOrDefault().Territory_Type;

                int?[] CTCodes = CTType == "G" ? lstTOT.Select(x => x.Territory_Code).ToArray() : lstTOT.Select(x => x.Country_Code).ToArray();

                if (CTType == "G")
                {
                    ViewBag.CTCodes = String.Join(", ", new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x =>
                    CTCodes.Contains(x.Territory_Code)).Select(x => x.Territory_Name).ToList());
                }
                else
                {
                    ViewBag.CTCodes = String.Join(", ", new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x =>
                    CTCodes.Contains(x.Country_Code)).Select(x => x.Country_Name).ToList());
                }

                ViewBag.PCodes = String.Join(",", new Title_Objection_Platform_Service(objLoginEntity.ConnectionStringName)
                    .SearchFor(x => x.Title_Objection_Code == TitleObjectCode).Select(x => x.Platform_Code).ToList());

                var abc = new Title_Objection_Rights_Period_Service(objLoginEntity.ConnectionStringName)
                    .SearchFor(x => x.Title_Objection_Code == TitleObjectCode)
                    .Select(x => new { x.Rights_Start_Date, x.Rights_End_Date })
                    .ToList();

                ViewBag.RPCodes = abc.Select(x => ((DateTime)x.Rights_Start_Date).ToString("dd/MM/yyyy") + "<b>&nbsp;&nbsp;To&nbsp;&nbsp;</b>" + ((DateTime)x.Rights_End_Date).ToString("dd/MM/yyyy")).ToList();

                ViewBag.Title_Status_Name = new Title_Objection_Status_Service(objLoginEntity.ConnectionStringName)
                    .SearchFor(x => x.Title_Objection_Status_Code == objTO.Title_Objection_Status_Code).FirstOrDefault().Objection_Status_Name;

                ViewBag.Object_Type_Name = new Title_Objection_Type_Service(objLoginEntity.ConnectionStringName)
                    .SearchFor(x => x.Objection_Type_Code == objTO.Title_Objection_Type_Code).Select(x => x.Objection_Type_Name).FirstOrDefault();

                return PartialView("~/Views/Title_Objection/_View_Title_Objection.cshtml", objUTO);
            }
            else
                return PartialView();
        }

        public PartialViewResult BindTitleObjectionList(int pageNo, int recordPerPage)
        {
            List<RightsU_Entities.USP_Title_Objection_List_Result> lst = new List<RightsU_Entities.USP_Title_Objection_List_Result>();
            int RecordCount = 0;
            lstUSP_Title_Objection_List_Searched = lstUSP_Title_Objection_List_Searched.ToList();

            RecordCount = lstUSP_Title_Objection_List_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstUSP_Title_Objection_List_Searched.OrderByDescending(o => o.Title).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Title_Objection/_Title_Objection_List.cshtml", lst);
        }

        public PartialViewResult BindPlatformTree(string PlatformCode, string isView = "N")
        {
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);

            objPTV.PlatformCodes_Selected = PlatformCode.Split(',').ToArray();
            if (isView == "Y")
            {
                objPTV.Show_Selected = true;
                objPTV.PlatformCodes_Display = String.Join(",", PlatformCode.Split(',').ToArray());
            }
            else
            {
                objPTV.PlatformCodes_Display = String.Join(",", lstUSP_Title_Objection_PreReq.Where(x => x.MapFor == "PLATFORM").Select(x => x.Code).ToList());
            }
            ViewBag.TV_Platform = objPTV.PopulateTreeNode(isView);

            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }

        #region Other Method
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

        private string GetUserModuleRights()
        {
            List<string> lstRights = new List<string>();
            lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForTitleObjection), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();
            return rights;
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
        public JsonResult SearchTitleObjection(string Type, string Title_Codes = "", string Licensor_Codes = "")
        {
            lstUSP_Title_Objection_List_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USP_Title_Objection_List(Type, Title_Codes, Licensor_Codes).ToList();

            var obj = new
            {
                Record_Count = lstUSP_Title_Objection_List_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult BindTitleLicencor(string Type, string MapFor, string Title_Codes = "", string Licensor_Codes = "")
        {
            Dictionary<object, object> obj_Dictionary = new Dictionary<object, object>();
            if (MapFor == "T")
            {
                var LCodes = Licensor_Codes.Split(',').ToList();
                if (Licensor_Codes != "")
                {
                    SelectList lstTitle = new SelectList(lstTitle_Licensor.Where(x => LCodes.Contains(x.Licensor_Code.ToString()))
                                    .Where(x => x.Acq_Syn == Type).ToList().ToList().Select(x => new { Display_Value = x.Title_Code, Display_Text = x.Title }).ToList().Distinct()
                                    , "Display_Value", "Display_Text");

                    obj_Dictionary.Add("lstTitle", lstTitle);
                }
                else
                {
                    SelectList lstTitle = new SelectList(lstTitle_Licensor.Where(x => x.Acq_Syn == Type).ToList().Select(x => new { Display_Value = x.Title_Code, Display_Text = x.Title })
                                    .ToList().Distinct()
                                    , "Display_Value", "Display_Text");

                    obj_Dictionary.Add("lstTitle", lstTitle);
                }
            }
            else if (MapFor == "L")
            {
                var TCodes = Title_Codes.Split(',').ToList();
                if (Title_Codes != "")
                {
                    SelectList lstLicensor = new SelectList(lstTitle_Licensor.Where(x => TCodes.Contains(x.Title_Code.ToString()))
                        .Where(x => x.Acq_Syn == Type).ToList()
                                .Select(x => new { Display_Value = x.Licensor_Code, Display_Text = x.Licensor }).ToList().Distinct()
                                , "Display_Value", "Display_Text");
                    obj_Dictionary.Add("lstLicensor", lstLicensor);
                }
                else
                {
                    SelectList lstLicensor = new SelectList(lstTitle_Licensor.Where(x => x.Acq_Syn == Type).ToList().Select(x => new { Display_Value = x.Licensor_Code, Display_Text = x.Licensor })
                                   .ToList().Distinct()
                                   , "Display_Value", "Display_Text");

                    obj_Dictionary.Add("lstLicensor", lstLicensor);
                }
            }
            return Json(obj_Dictionary);
        }
        public JsonResult BindCountryTerritory(string Type, string pCodes = "", string mapFor = "", int TitleCode = 0, string RecordType = "A", int RecordCode = 0)
        {
            Dictionary<object, object> obj_Dictionary = new Dictionary<object, object>();

            if (pCodes != "" && mapFor != "")
            {
                lstUSP_Title_Objection_PreReq = new USP_Service(objLoginEntity.ConnectionStringName)
                    .USP_Title_Objection_PreReq(TitleCode, RecordCode, RecordType, pCodes).ToList();

                var SDEDList = lstUSP_Title_Objection_PreReq.Where(x => x.MapFor == "SDED" && x.EndDate != null).Select(x =>
               new
               {
                   Display_Value = ((DateTime)x.StartDate).ToString("dd-MMM-yyyy") + "~" + ((DateTime)x.EndDate).ToString("dd-MMM-yyyy"),
                   Display_Text = ((DateTime)x.StartDate).ToString("dd/MM/yyyy") + " To " + ((DateTime)x.EndDate).ToString("dd/MM/yyyy")
               }).ToList();

                var SDEDList1 = lstUSP_Title_Objection_PreReq.Where(x => x.MapFor == "SDED" && x.EndDate == null).Select(x =>
                 new
                 {
                     Display_Value = ((DateTime)x.StartDate).ToString("dd-MMM-yyyy") + "~(Perpetuity)",
                     Display_Text = ((DateTime)x.StartDate).ToString("dd/MM/yyyy") + " (Perpetuity) "
                 }).ToList();

                SDEDList.AddRange(SDEDList1);

                SelectList lstLP = new SelectList(SDEDList, "Display_Value", "Display_Text");
                obj_Dictionary.Add("lstLP", lstLP);
            }

            if (Type == "C")
            {
                var CountryList = lstUSP_Title_Objection_PreReq.Where(x => x.MapFor == "TERRITORY" && x.CodeFor == "I").Select(x => new { Display_Value = x.Code, Display_Text = x.Obj_Type_Name }).ToList();
                SelectList lstCT = new SelectList(CountryList, "Display_Value", "Display_Text");
                obj_Dictionary.Add("lstCT", lstCT);
            }
            else if (Type == "T")
            {
                var TerritoryList = lstUSP_Title_Objection_PreReq.Where(x => x.MapFor == "TERRITORY" && x.CodeFor == "G").Select(x => new { Display_Value = x.Code, Display_Text = x.Obj_Type_Name }).ToList();
                SelectList lstCT = new SelectList(TerritoryList, "Display_Value", "Display_Text");
                obj_Dictionary.Add("lstCT", lstCT);
            }



            return Json(obj_Dictionary);
        }
        public JsonResult BindObjectionType()
        {
            Dictionary<object, object> obj_Dictionary = new Dictionary<object, object>();
            var lstObjType = lstUSP_Title_Objection_PreReq.Where(x => x.MapFor == "TYPEOFOBJECTION").Select(x => new { x.Code, x.Obj_Type_Group, x.Obj_Type_Name }).ToList();

            obj_Dictionary.Add("lstObjType", lstObjType);
            return Json(obj_Dictionary);
        }
        #endregion

        public JsonResult SaveTitleObjection(int TOC, string PlatformCodes, char CntTerr, int[] CTCodes, string[] LPCodes, string SD, string ED,
            int ObjType, string ObjRemarks, string ResRemarks, int TitleCode, string RecordType, int RecordCode, int Title_Status)
        {
            Dictionary<object, object> obj_Dictionary = new Dictionary<object, object>();
            Title_Objection_Service objTOService = new Title_Objection_Service(objLoginEntity.ConnectionStringName);
            Title_Objection objTO;
            if (TOC > 0)
            {
                objTO = objTOService.GetById(TOC);
                objTO.Title_Objection_Platform.ToList().ForEach(x => x.EntityState = State.Deleted);
                objTO.Title_Objection_Territory.ToList().ForEach(x => x.EntityState = State.Deleted);
                objTO.Title_Objection_Rights_Period.ToList().ForEach(x => x.EntityState = State.Deleted);
                objTO.Last_Updated_Time = System.DateTime.Now;
                objTO.Last_Action_By = objLoginUser.Users_Code;
            }
            else
            {
                objTO = new Title_Objection();
                objTO.Inserted_On = System.DateTime.Now;
                objTO.Inserted_By = objLoginUser.Users_Code;
            }

            objTO.Title_Objection_Status_Code = Title_Status;
            objTO.Title_Objection_Type_Code = ObjType;
            objTO.Title_Code = TitleCode;
            objTO.Record_Code = RecordCode;
            objTO.Record_Type = RecordType;
            objTO.Objection_Start_Date = Convert.ToDateTime(SD);
            objTO.Objection_End_Date = Convert.ToDateTime(ED);
            objTO.Objection_Remarks = ObjRemarks;
            objTO.Resolution_Remarks = ResRemarks;

            objTO.EntityState = TOC > 0 ? State.Modified : State.Added;

            //ICollection<Title_Objection_Platform> VendorCountryList = new HashSet<Title_Objection_Platform>();
            foreach (var item in PlatformCodes.Split(',').Where(x => x != "0").ToList())
            {
                Title_Objection_Platform objTP = new Title_Objection_Platform();
                objTP.Platform_Code = Convert.ToInt32(item);
                objTP.EntityState = State.Added;
                objTP.Title_Objection_Code = TOC;
                objTO.Title_Objection_Platform.Add(objTP);
                //VendorCountryList.Add(objTP);
            }
            //IEqualityComparer<Title_Objection_Platform> comparerVendorCountry = new LambdaComparer<Title_Objection_Platform>((x, y) => x.Platform_Code == y.Platform_Code && x.EntityState != State.Deleted);
            //var DeletedTitle_Objection_Platform = new List<Title_Objection_Platform>();
            //var UpdatedTitle_Objection_Platform = new List<Title_Objection_Platform>();
            //var AddedTitle_Objection_Platform = CompareLists<Title_Objection_Platform>(VendorCountryList.ToList<Title_Objection_Platform>(), objTO.Title_Objection_Platform.ToList<Title_Objection_Platform>(), comparerVendorCountry, ref DeletedTitle_Objection_Platform, ref UpdatedTitle_Objection_Platform);
            //AddedTitle_Objection_Platform.ToList<Title_Objection_Platform>().ForEach(t => objTO.Title_Objection_Platform.Add(t));
            //DeletedTitle_Objection_Platform.ToList<Title_Objection_Platform>().ForEach(t => t.EntityState = State.Deleted);


            foreach (var item in CTCodes)
            {
                Title_Objection_Territory objCT = new Title_Objection_Territory();
                objCT.EntityState = State.Added;
                if (CntTerr == 'C')
                {
                    objCT.Country_Code = item;
                    objCT.Territory_Type = "I";
                }
                else
                {
                    objCT.Territory_Code = item;
                    objCT.Territory_Type = "G";
                }
                objCT.Title_Objection_Code = TOC;
                objTO.Title_Objection_Territory.Add(objCT);
            }

            foreach (var item in LPCodes)
            {
                Title_Objection_Rights_Period objLP = new Title_Objection_Rights_Period();
                objLP.EntityState = State.Added;
                objLP.Rights_Start_Date = Convert.ToDateTime(item.Split('~').ElementAt(0));
                objLP.Rights_End_Date = item.Split('~').ElementAt(1) == "(Perpetuity)" ? (dynamic)null : Convert.ToDateTime(item.Split('~').ElementAt(1));
                objLP.Title_Objection_Code = TOC;
                objTO.Title_Objection_Rights_Period.Add(objLP);
            }

            Title_Objection_UDT objTO_udt = new Title_Objection_UDT();
            objTO_udt.Title_Objection_Code = TOC;
            objTO_udt.PlatformCodes = PlatformCodes;
            objTO_udt.CntTerr = CntTerr;
            objTO_udt.CTCodes = string.Join(",", CTCodes);
            objTO_udt.LPCodes = string.Join(",", LPCodes);
            objTO_udt.SD = Convert.ToDateTime(SD).ToString("dd-MMM-yyyy");
            objTO_udt.ED = Convert.ToDateTime(ED).ToString("dd-MMM-yyyy");
            objTO_udt.Objection_Type_Code = ObjType;
            objTO_udt.ObjRemarks = ObjRemarks;
            objTO_udt.ResRemarks = ResRemarks;
            objTO_udt.TitleCode = TitleCode;
            objTO_udt.RecordType = Convert.ToChar(RecordType);
            objTO_udt.RecordCode = RecordCode;
            objTO_udt.Title_Status_Code = Title_Status;

            List<Title_Objection_UDT> lstVTOD = new List<Title_Objection_UDT>();
            lstVTOD.Add(objTO_udt);

            var a = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_Title_Objection_Dup(lstVTOD, objLoginUser.Users_Code).FirstOrDefault();

            if (a.Result == "N")
            {
                dynamic resultSet;
                bool isValid = objTOService.Save(objTO, out resultSet);
                obj_Dictionary.Add("Status", "S");
            }
            else
            {
                obj_Dictionary.Add("Status", "E");
            }
            return Json(obj_Dictionary);
        }
    }

    class Title_Licensor
    {
        public string Acq_Syn { get; set; }
        public string Licensor { get; set; }
        public string Title { get; set; }
        public Nullable<int> Title_Code { get; set; }
        public int Licensor_Code { get; set; }
    }

}