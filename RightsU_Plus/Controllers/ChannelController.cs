using RightsU_Dapper.BLL.Services;
using RightsU_Dapper.Entity.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_Dapper.Entity.Master_Entities;
//using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class ChannelController : BaseController
    {
        private readonly Channel_Service objChannelService = new Channel_Service();
        private readonly Entity_Service objEntityService = new Entity_Service();
        private readonly Country_Service objCountryService = new Country_Service();
        private readonly Vendor_Service objVendorService = new Vendor_Service();
        private readonly USP_MODULE_RIGHTS_Service objUSP_MODULE_RIGHTS_Service = new USP_MODULE_RIGHTS_Service();

        //
        // GET: /Channel/
        #region --- Properties ---

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
        private List<RightsU_Dapper.Entity.Master_Entities.Channel> lstChannel
        {
            get
            {
                if (Session["lstChannel"] == null)
                    Session["lstChannel"] = new List<RightsU_Dapper.Entity.Master_Entities.Channel>();
                return (List<RightsU_Dapper.Entity.Master_Entities.Channel>)Session["lstChannel"];
            }
            set { Session["lstChannel"] = value; }
        }
        private List<RightsU_Dapper.Entity.Master_Entities.Channel> lstChannelEdit
        {
            get
            {
                if (Session["lstChannelEdit"] == null)
                    Session["lstChannelEdit"] = new List<RightsU_Dapper.Entity.Master_Entities.Channel>();
                return (List<RightsU_Dapper.Entity.Master_Entities.Channel>)Session["lstChannelEdit"];
            }
            set { Session["lstChannelEdit"] = value; }
        }
        private List<RightsU_Dapper.Entity.Master_Entities.Channel> lstChannel_Searched
        {
            get
            {
                if (Session["lstChannel_Searched"] == null)
                    Session["lstChannel_Searched"] = new List<RightsU_Dapper.Entity.Master_Entities.Channel>();
                return (List<RightsU_Dapper.Entity.Master_Entities.Channel>)Session["lstChannel_Searched"];
            }
            set { Session["lstChannel_Searched"] = value; }
        }
        //private List<RightsU_Dapper.Entity.Master_Entities.Genre> lstGenre
        //{
        //    get
        //    {
        //        if (Session["lstGenre"] == null)
        //            Session["lstGenre"] = new List<RightsU_Dapper.Entity.Master_Entities.Channel>();
        //        return (List<RightsU_Dapper.Entity.Master_Entities.Genre>)Session["lstGenre"];
        //    }
        //    set { Session["lstGenre"] = value; }
        //}
        private string ModuleCode
        {
            get
            {
                if (Session["ModuleCode"] == null)
                {
                    Session["ModuleCode"] = 0;
                }
                return Convert.ToString(Session["ModuleCode"].ToString());
            }
            set
            {
                Session["ModuleCode"] = value;
            }
        }
        Type[] RelationList = new Type[] { typeof(Channel_Territory)
            };
        #endregion

        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForChannel);
            //ModuleCode = Request.QueryString["modulecode"];
            ModuleCode = GlobalParams.ModuleCodeForChannel.ToString();
            return View("~/Views/Channel/Index.cshtml");
        }
        public PartialViewResult BindPartialPages(string key, int ChannelCode)
        {
            if (key == "LIST")
            {
                ViewBag.Code = ModuleCode;
                ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
                List<SelectListItem> lstSort = new List<SelectListItem>();
                lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
                lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
                lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
                ViewBag.SortType = lstSort;
                FetchData();
                ViewBag.RightRuleCode = "";
                ViewBag.Action = "";
                ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/Channel/_Channel.cshtml", lstChannel_Searched);
            }
            else if (key == "EDIT")
            {
                #region

                //Channel_Service objService = new Channel_Service(objLoginEntity.ConnectionStringName);
                //RightsU_Dapper.Entity.Master_Entities.Channel objChannel = objService.GetById(ChannelCode);
                RightsU_Dapper.Entity.Master_Entities.Channel objChannel = objChannelService.GetByID(ChannelCode, RelationList);
               
                lstChannel_Searched = lstChannelEdit = objChannelService.GetAll().Where(a => a.Channel_Code == ChannelCode).ToList();

                //Country_Service objCountryService = new Country_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Master_Entities.Country objCountry = objCountryService.GetByID(ChannelCode);

                //var genList = new Genre_Service(objLoginEntity.ConnectionStringName).SearchFor(a => true).ToList();
                //ViewBag.GenereList = new SelectList(genList, "Genres_Code", "Genres_Name", objChannel.Genre.Genres_Code);

                var entityList = objEntityService.GetAll().ToList();
                ViewBag.EntityList = new SelectList(entityList, "Entity_Code", "Entity_Name", objChannel.Entity_Code);

                var vendorList = objVendorService.GetAll().ToList();
                ViewBag.VendorList = new SelectList(vendorList, "Vendor_Code", "Vendor_Name", objChannel.Entity_Code);

                int[] countryCode =  objChannel.Channel_Territory.Select(s =>Convert.ToInt32(s.Country_Code)).ToArray();
                var countryList = objCountryService.GetAll().ToList();
                ViewBag.CountryList = new MultiSelectList(countryList, "Country_Code", "Country_Name", countryCode);

                if (objChannel.Entity_Type.ToLower() == "o")
                {
                    ViewBag.EntityType = "Own";
                }
                else if (objChannel.Entity_Type.ToLower() == "c")
                {
                    ViewBag.EntityType = "Others";
                }
                //List<SelectListItem> listItems = new List<SelectListItem>();

                //listItems.Add(new SelectListItem
                //{
                //    Text = "Colors India",
                //    Value = "Colors India"
                //});
                //listItems.Add(new SelectListItem
                //{
                //    Text = "Colors UK",
                //    Value = "Colors UK",
                //    //  Selected = true
                //});
                //listItems.Add(new SelectListItem
                //{
                //    Text = "Colors US",
                //    Value = "Colors US"
                //});
                //listItems.Add(new SelectListItem
                //{
                //    Text = "Colors MENA",
                //    Value = "Colors MENA"
                //});
                //listItems.Add(new SelectListItem
                //{
                //    Text = "Colors HD",
                //    Value = "Colors HD"
                //});
                //ViewBag.BeamList = new SelectList(listItems, "Text", "Value", objChannel.Channel_Id);
                ViewBag.ChannelCode = ChannelCode;
                TempData["Action"] = "Edit";
                #endregion
                return PartialView("~/Views/Channel/_Add_Edit_Channel.cshtml", lstChannel_Searched);
            }
            else
            {
                #region

                //List<SelectListItem> listItems = new List<SelectListItem>();
                //listItems.Add(new SelectListItem { Text = "Colors India", Value = "Colors India" });
                //listItems.Add(new SelectListItem { Text = "Colors UK", Value = "Colors UK" });
                //listItems.Add(new SelectListItem { Text = "Colors US", Value = "Colors US" });
                //listItems.Add(new SelectListItem { Text = "Colors MENA", Value = "Colors MENA" });
                //listItems.Add(new SelectListItem { Text = "Colors HD", Value = "Colors HD" });
                //ViewBag.BeamList = new SelectList(listItems, "Text", "Value");



                //Genre_Service objGenre_Service = new Genre_Service(objLoginEntity.ConnectionStringName);
                //var lstgenre = objGenre_Service.SearchFor(a => true).ToList();
                //ViewBag.lstGeneres = new SelectList(lstgenre, "Genres_Code", "Genres_Name", "");


                //Entity_Service objEntityService = new Entity_Service(objLoginEntity.ConnectionStringName);
                var lstentity = objEntityService.GetAll().ToList();
                ViewBag.lstEntity = new SelectList(lstentity, "Entity_Code", "Entity_Name", "");

                //Vendor_Service objVendorService = new Vendor_Service(objLoginEntity.ConnectionStringName);
                var lstvendor = objVendorService.GetAll().ToList();
                ViewBag.lstVendors = new SelectList(lstvendor, "Vendor_Code", "Vendor_Name", "");

                //Channel_Service objChannel = new Channel_Service(objLoginEntity.ConnectionStringName);

                //Country_Service objCountryService = new Country_Service(objLoginEntity.ConnectionStringName);
                var lstcountry = objCountryService.GetAll().ToList();
                ViewBag.lstCountry = new SelectList(lstcountry, "Country_Code", "Country_Name", "");

                ViewBag.EntityType = "Own";

                TempData["Act"] = "Add";
                #endregion
                return PartialView("~/Views/Channel/_Add_Edit_Channel.cshtml");
            }

        }
        public PartialViewResult BindChannelList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Dapper.Entity.Master_Entities.Channel> lst = new List<RightsU_Dapper.Entity.Master_Entities.Channel>();
            int RecordCount = 0;
            RecordCount = lstChannel_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstChannel_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstChannel_Searched.OrderBy(o => o.Channel_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstChannel_Searched.OrderByDescending(o => o.Channel_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Channel/_ChannelList.cshtml", lst);
        }
        #region  --- Other Methods ---
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
        private void FetchData()
        {
            lstChannel_Searched = lstChannel = objChannelService.GetAll().OrderByDescending(o => o.Last_Updated_Time).ToList();
        }
        #endregion

        public JsonResult SearchChannel(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstChannel_Searched = lstChannel.Where(w => w.Channel_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstChannel_Searched = lstChannel;

            var obj = new
            {
                Record_Count = lstChannel_Searched.Count
            };
            return Json(obj);
        }

        public ActionResult EditChannel(int ChannelCode)
        {
            //Channel_Service objService = new Channel_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Master_Entities.Channel objChannel = objChannelService.GetByID(ChannelCode);
            lstChannel_Searched = lstChannelEdit = objChannelService.GetAll().Where(a => a.Channel_Code == ChannelCode).ToList();

            //Country_Service objCountryService = new Country_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Master_Entities.Country objCountry = objCountryService.GetByID(ChannelCode);

            //var genList = new Genre_Service(objLoginEntity.ConnectionStringName).SearchFor(a => true).ToList();
            //ViewBag.GenereList = new SelectList(genList, "Genres_Code", "Genres_Name", objChannel.Genre.Genres_Code);

            var entityList = objEntityService.GetAll().ToList();
            ViewBag.EntityList = new SelectList(entityList, "Entity_Code", "Entity_Name", objChannel.Entity_Code);

            var vendorList = objVendorService.GetAll().ToList();
            ViewBag.VendorList = new SelectList(vendorList, "Vendor_Code", "Vendor_Name", objChannel.Entity_Code);

            string countryCode = string.Join(",", objChannel.Channel_Territory.Select(s => s.Country_Code).ToArray());
            var countryList = objCountryService.GetAll().ToList();
            ViewBag.CountryList = new MultiSelectList(countryList, "Country_Code", "Country_Name", countryCode);

            if (objChannel.Entity_Type.ToLower() == "o")
            {
                ViewBag.EntityType = "Own";
            }
            else if (objChannel.Entity_Type.ToLower() == "c")
            {
                ViewBag.EntityType = "Others";
            }

            //List<SelectListItem> listItems = new List<SelectListItem>();

            //listItems.Add(new SelectListItem
            //{
            //    Text = "Colors India",
            //    Value = "Colors India"
            //});
            //listItems.Add(new SelectListItem
            //{
            //    Text = "Colors UK",
            //    Value = "Colors UK",
            //    //  Selected = true
            //});
            //listItems.Add(new SelectListItem
            //{
            //    Text = "Colors US",
            //    Value = "Colors US"
            //});
            //listItems.Add(new SelectListItem
            //{
            //    Text = "Colors MENA",
            //    Value = "Colors MENA"
            //});
            //listItems.Add(new SelectListItem
            //{
            //    Text = "Colors HD",
            //    Value = "Colors HD"
            //});


            //ViewBag.BeamList = new SelectList(listItems, "Text", "Value", objChannel.Channel_Id);

            ViewBag.ChannelCode = ChannelCode;
            TempData["Action"] = "Edit";
            //  return RedirectToAction("Index");
            return View("~/Views/Channel/_AddEditChannel.cshtml", lstChannel_Searched);
        }

        //public ActionResult DisplaySearchResults(string searchText)
        //{
        //    return PartialView("~/Views/RightRule/_AddEditChannel.cshtml");
        //}

        public JsonResult CheckRecordLock(int ChannelCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (ChannelCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(ChannelCode, GlobalParams.ModuleCodeForChannel, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        public JsonResult UpdateChannel(FormCollection objFormCollection)
        {
            int Entity_Name = 0;
            int Vendor_Name = 0;
            if (objFormCollection["ddlEntity"] != "")
            {
                Entity_Name = Convert.ToInt32(objFormCollection["ddlEntity"]);
            }
            if (objFormCollection["ddlVendor"] != "")
            {
                Vendor_Name = Convert.ToInt32(objFormCollection["ddlVendor"]);
            }
            string Channel_Code = objFormCollection["item.Channel_Code"].ToString();
            string Channel_Name = objFormCollection["Channel_Name"].ToString();
            // string Channel_Id = objFormCollection["ddlBeam"].ToString();
            // string Genres_Name = objFormCollection["ddlGenres"].ToString();
            string Schedule_Source_FilePath = objFormCollection["Schedule_Source_FilePath"].ToString();
            string Schedule_Source_FilePath_Pkg = objFormCollection["Schedule_Source_FilePath_Pkg"].ToString();
            string BV_Channel_Code = objFormCollection["BV_Channel_Code"].ToString();
            string Country_Code = Convert.ToString(objFormCollection["ddlCountry"]);
            string Entity_Type = objFormCollection["item.Entity_Type"].ToString();
            string OffsetTime_Schedule = objFormCollection["OffsetTime_Schedule"].ToString();
            string OffsetTime_Schedule1 = objFormCollection["OffsetTime_Schedule1"].ToString();

            string OffsetTime_AsRun = objFormCollection["OffsetTime_AsRun"].ToString();
            string OffsetTime_AsRun1 = objFormCollection["OffsetTime_AsRun1"].ToString();
            //string Entity_Code = objFormCollection["item.Entity_Code"].ToString();

            //-- Entity_Name = Convert.ToInt32(objFormCollection["ddlEntity"]);
            // string Entity_Name = Convert.ToString(objFormCollection["ddlEntity"]);
            //--Vendor_Name = Convert.ToInt32(objFormCollection["ddlVendor"]);
            //string Vendor_Name = Convert.ToString(objFormCollection["ddlVendor"]);



            //Channel_Service objService = new Channel_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Master_Entities.Channel objChannel = objChannelService.GetByID(Convert.ToInt32(Channel_Code));




            if (Convert.ToChar(Entity_Type) == 'O')
            {
                objChannel.Entity_Code = Entity_Name;

            }

            else if (Convert.ToChar(Entity_Type) == 'C')
            {
                objChannel.Entity_Code = Vendor_Name;
            }

            objChannel.Channel_Name = Channel_Name;
            // objChannel.Channel_Id = Channel_Id;
            // objChannel.Genres_Code = Convert.ToInt32(Genres_Name);
            objChannel.Schedule_Source_FilePath = Schedule_Source_FilePath;
            objChannel.Schedule_Source_FilePath_Pkg = Schedule_Source_FilePath_Pkg;
            objChannel.BV_Channel_Code = Convert.ToInt32(BV_Channel_Code);
            objChannel.Entity_Type = Entity_Type;
            objChannel.OffsetTime_Schedule = OffsetTime_Schedule + ":" + OffsetTime_Schedule1;
            objChannel.OffsetTime_AsRun = OffsetTime_AsRun + ":" + OffsetTime_AsRun1;
            objChannel.Last_Action_By = objLoginUser.Users_Code;
            objChannel.Last_Updated_Time = System.DateTime.Now;
            //objChannel.EntityState = State.Modified;

            dynamic resultSet;
            string status = "S", message = "Record {ACTION} successfully";
            ViewBag.RightRuleCode = "";
            ViewBag.Action = "";
            RedirectToAction("index");


            ICollection<RightsU_Dapper.Entity.Master_Entities.Channel_Territory> BuisnessUnitList = new HashSet<RightsU_Dapper.Entity.Master_Entities.Channel_Territory>();
            if (Country_Code != null)
            {
                var split = Country_Code.Split(',');
                // string[] arrBuisnessCode = LanguageCodes[0].s
                foreach (string BuisnessUnitCode in split)
                {
                    RightsU_Dapper.Entity.Master_Entities.Channel_Territory objTR = new RightsU_Dapper.Entity.Master_Entities.Channel_Territory();
                    //objTR.EntityState = State.Added;
                    objTR.Country_Code = Convert.ToInt32(BuisnessUnitCode);
                    BuisnessUnitList.Add(objTR);
                }
            }
            RightsU_Dapper.Entity.Master_Entities.Channel_Territory objTR1 = new RightsU_Dapper.Entity.Master_Entities.Channel_Territory();

            IEqualityComparer<RightsU_Dapper.Entity.Master_Entities.Channel_Territory> comparerBuisness_Unit = new RightsU_BLL.LambdaComparer<RightsU_Dapper.Entity.Master_Entities.Channel_Territory>((x, y) => x.Country_Code == y.Country_Code);
            var Deleted_Users_Business_Unit = new List<RightsU_Dapper.Entity.Master_Entities.Channel_Territory>();
            var Updated_Users_Business_Unit = new List<RightsU_Dapper.Entity.Master_Entities.Channel_Territory>();

            var Added_Users_Business_Unit = CompareLists<RightsU_Dapper.Entity.Master_Entities.Channel_Territory>(BuisnessUnitList.ToList<RightsU_Dapper.Entity.Master_Entities.Channel_Territory>(), objChannel.Channel_Territory.ToList<RightsU_Dapper.Entity.Master_Entities.Channel_Territory>(), comparerBuisness_Unit, ref Deleted_Users_Business_Unit, ref Updated_Users_Business_Unit);
            Added_Users_Business_Unit.ToList<RightsU_Dapper.Entity.Master_Entities.Channel_Territory>().ForEach(t => objChannel.Channel_Territory.Add(t));
            Deleted_Users_Business_Unit.ToList<RightsU_Dapper.Entity.Master_Entities.Channel_Territory>().ForEach(t => objChannel.Channel_Territory.Remove(t));

            objChannelService.AddEntity(objChannel);
            bool isValid = true;  //objService.Save(objChannel, out resultSet);
            if (isValid)
            {
                lstChannel.Where(w => w.Channel_Code == Convert.ToInt32(Channel_Code)).First();
                lstChannel_Searched.Where(w => w.Channel_Code == Convert.ToInt32(Channel_Code)).First();
                status = "S";
                message = objMessageKey.Recordupdatedsuccessfully;
                ViewBag.Alert = message;

                int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);

                FetchData();
            }
            else
            {
                status = "E";
                message = "";
            }


            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
            //  return RedirectToAction("Index");
        }

        public JsonResult BindVendorDropdown(string other)
        {
            //List<SelectListItem> lstvendor = new SelectList(new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Vendor_Name == other).
            //    OrderBy(o => o.Vendor_Name), "Vendor_Code", "Vendor_Name").ToList();
            List<SelectListItem> lstvendor = new SelectList(objVendorService.GetAll().Where(s => s.Vendor_Name == other).
               OrderBy(o => o.Vendor_Name), "Vendor_Code", "Vendor_Name").ToList();
            var obj = new
            {
                VendorList = lstvendor
            };
            return Json(obj);
        }

        public ActionResult RedirectAdd()
        {


            List<SelectListItem> listItems = new List<SelectListItem>();
            listItems.Add(new SelectListItem { Text = "Colors India", Value = "Colors India" });
            listItems.Add(new SelectListItem { Text = "Colors UK", Value = "Colors UK" });
            listItems.Add(new SelectListItem { Text = "Colors US", Value = "Colors US" });
            listItems.Add(new SelectListItem { Text = "Colors MENA", Value = "Colors MENA" });
            listItems.Add(new SelectListItem { Text = "Colors HD", Value = "Colors HD" });
            ViewBag.BeamList = new SelectList(listItems, "Text", "Value");



            //Genre_Service objGenre_Service = new Genre_Service(objLoginEntity.ConnectionStringName);
            //var lstgenre = objGenre_Service.SearchFor(a => true).ToList();
            //ViewBag.lstGeneres = new SelectList(lstgenre, "Genres_Code", "Genres_Name", "");


            //Entity_Service objEntityService = new Entity_Service(objLoginEntity.ConnectionStringName);
            var lstentity = objEntityService.GetAll().ToList();
            ViewBag.lstEntity = new SelectList(lstentity, "Entity_Code", "Entity_Name", "");

            //Vendor_Service objVendorService = new Vendor_Service(objLoginEntity.ConnectionStringName);
            var lstvendor = objVendorService.GetAll().ToList();
            ViewBag.lstVendors = new SelectList(lstvendor, "Vendor_Code", "Vendor_Name", "");

            //Channel_Service objChannel = new Channel_Service(objLoginEntity.ConnectionStringName);

            //Country_Service objCountryService = new Country_Service(objLoginEntity.ConnectionStringName);
            var lstcountry = objCountryService.GetAll().ToList();
            ViewBag.lstCountry = new SelectList(lstcountry, "Country_Code", "Country_Name", "");

            ViewBag.EntityType = "Own";



            //var genList = new Genre_Service(objLoginEntity.ConnectionStringName).SearchFor(a => true).ToList();
            //ViewBag.GenereList = new SelectList(genList, "Genres_Code", "Genres_Name", objChannel.Genre.Genres_Code);

            //var entityList = new Entity_Service().SearchFor(a => true).ToList();
            //ViewBag.EntityList = new SelectList(entityList, "Entity_Code", "Entity_Name", objChannel.Entity_Code);

            //var vendorList = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(a => true).ToList();
            //ViewBag.VendorList = new SelectList(vendorList, "Vendor_Code", "Vendor_Name", objChannel.Entity_Code);

            //string countryCode = string.Join(",", objChannel.Channel_Territory.Select(s => s.Country_Code).ToArray());
            //var countryList = new Country_Service().SearchFor(a => true).ToList();
            //ViewBag.CountryList = new MultiSelectList(countryList, "Country_Code", "Country_Name", countryCode);

            //if (objChannel.Entity_Type.ToLower() == "o")
            //{
            //    ViewBag.EntityType = "Own";
            //}
            //else if (objChannel.Entity_Type.ToLower() == "c")
            //{
            //    ViewBag.EntityType = "Others";
            //}


            //ViewBag.ChannelCode = ChannelCode;
            TempData["Act"] = "Add";
            return View("~/Views/Channel/_AddEditChannel.cshtml");
        }

        public ActionResult SaveChannel(FormCollection objFormCollection)
        {
            #region SaveCode

            string status = "S", message = "Record {ACTION} successfully";
            int Entity_Name = 0;
            int Vendor_Name = 0;
            if (objFormCollection["ddlEntity"] != "")
            {
                Entity_Name = Convert.ToInt32(objFormCollection["ddlEntity"]);
            }
            if (objFormCollection["ddlVendor"] != "")
            {
                Vendor_Name = Convert.ToInt32(objFormCollection["ddlVendor"]);
            }
            string Channel_Name = objFormCollection["Channel_Name"].ToString();
            // string Channel_Id = objFormCollection["ddlBeam"].ToString();
            //  string Genres_Name = objFormCollection["ddlGenres"].ToString();
            string Schedule_Source_FilePath = objFormCollection["Schedule_Source_FilePath"].ToString();
            string Schedule_Source_FilePath_Pkg = objFormCollection["Schedule_Source_FilePath_Pkg"].ToString();
            string BV_Channel_Code = objFormCollection["BV_Channel_Code"].ToString();
            string Country_Code = Convert.ToString(objFormCollection["ddlCountry"]);
            string Entity_Type = objFormCollection["item.Entity_Type"].ToString();
            string OffsetTime_Schedule = objFormCollection["OffsetTime_Schedule"].ToString();
            string OffsetTime_Schedule1 = objFormCollection["OffsetTime_Schedule1"].ToString();
            string OffsetTime_AsRun = objFormCollection["OffsetTime_AsRun"].ToString();
            string OffsetTime_AsRun1 = objFormCollection["OffsetTime_AsRun1"].ToString();

            //Channel_Service objService = new Channel_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Master_Entities.Channel objChannel = new RightsU_Dapper.Entity.Master_Entities.Channel();
            //objChannel.EntityState = State.Added;
            if (objFormCollection["ddlEntity"] != "")
            {
                if (Convert.ToChar(Entity_Type) == 'O')
                {
                    objChannel.Entity_Code = Entity_Name;

                }
            }
            if (objFormCollection["ddlVendor"] != "")
            {
                if (Convert.ToChar(Entity_Type) == 'C')
                {
                    objChannel.Entity_Code = Vendor_Name;
                }
            }

            objChannel.Channel_Name = Channel_Name;
            //objChannel.Channel_Id = Channel_Id;
            //objChannel.Genres_Code = Convert.ToInt32(Genres_Name);
            objChannel.Schedule_Source_FilePath = Schedule_Source_FilePath;
            objChannel.Schedule_Source_FilePath_Pkg = Schedule_Source_FilePath_Pkg;
            objChannel.BV_Channel_Code = Convert.ToInt32(BV_Channel_Code);
            objChannel.Entity_Type = Entity_Type;
            objChannel.OffsetTime_Schedule = OffsetTime_Schedule + ":" + OffsetTime_Schedule1;
            objChannel.OffsetTime_AsRun = OffsetTime_AsRun + ":" + OffsetTime_AsRun1;
            objChannel.Inserted_On = System.DateTime.Now;
            objChannel.Inserted_By = objLoginUser.Users_Code;
            objChannel.Last_Updated_Time = System.DateTime.Now;
            objChannel.Is_Active = "Y";

            if (Country_Code != null)
            {
                var split = Country_Code.Split(',');
                foreach (string BuisnessUnitCode in split)
                {
                    RightsU_Dapper.Entity.Master_Entities.Channel_Territory objTR = new RightsU_Dapper.Entity.Master_Entities.Channel_Territory();
                    //objTR.EntityState = State.Added;
                    objTR.Country_Code = Convert.ToInt32(BuisnessUnitCode);
                    objChannel.Channel_Territory.Add(objTR);
                }
            }
            dynamic resultSet;
            try
            {
                objChannelService.AddEntity(objChannel);
                bool isValid = true;//objService.Save(objChannel, out resultSet);
                if (isValid)
                {
                    //message = message.Replace("{ACTION}", "added");
                    message = objMessageKey.RecordAddedSuccessfully;
                    FetchData();
                }
            }
            catch (Exception ex)
            {

                throw;
            }

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
            #endregion

        }

        public JsonResult ActiveDeactiveChannel(int Channel_Code, string doActive)
        {
            string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(Channel_Code, GlobalParams.ModuleCodeForChannel, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                //Channel_Service objService = new Channel_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Master_Entities.Channel objChannel = objChannelService.GetByID(Channel_Code);
                objChannel.Is_Active = doActive;
                //objChannel.EntityState = State.Modified;
                dynamic resultSet;
                objChannelService.AddEntity(objChannel);
                bool isValid = true;//objService.Save(objChannel, out resultSet);
                if (isValid)
                {
                    lstChannel.Where(w => w.Channel_Code == Channel_Code).First().Is_Active = doActive;
                    lstChannel_Searched.Where(w => w.Channel_Code == Channel_Code).First().Is_Active = doActive;
                    if (doActive == "Y")
                        message = objMessageKey.Recordactivatedsuccessfully;
                    else
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                }
                else
                {
                    status = "E";
                    if (doActive == "Y")
                        message = objMessageKey.CouldNotActivatedRecord;
                    else
                        message = objMessageKey.CouldNotDeactivatedRecord;
                }
                objCommonUtil.Release_Record(RLCode, objLoginEntity.ConnectionStringName);
            }
            else
            {
                status = "E";
                message = strMessage;
            }

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        private string GetUserModuleRights()
        {
            string lstRights = objUSP_MODULE_RIGHTS_Service.USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForLanguage), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
    }
}
