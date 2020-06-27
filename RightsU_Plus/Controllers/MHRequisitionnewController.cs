using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.IO;
using System.Reflection;

namespace RightsU_Plus.Controllers
{
    public partial class MHRequisitionController : BaseController
    {
        public MHRequestSearch objPage_Properties
        {
            get
            {
                if (Session["MHRequestSearch_Page_Properties"] == null)
                    Session["MHRequestSearch_Page_Properties"] = new MHRequestSearch();
                return (MHRequestSearch)Session["MHRequestSearch_Page_Properties"];
            }
            set { Session["MHRequestSearch_Page_Properties"] = value; }
        }
        public RightsU_Entities.Music_Title objTitle
        {
            get
            {
                if (Session["Session_Music_Title"] == null)
                    Session["Session_Music_Title"] = new RightsU_Entities.Music_Title();
                return (RightsU_Entities.Music_Title)Session["Session_Music_Title"];
            }
            set { Session["Session_Music_Title"] = value; }
        }
        #region Approve
        public PartialViewResult Approve(int MHRequestCode)
        {
            MHRequest objMH = new MHRequest_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.MHRequestCode == MHRequestCode).FirstOrDefault();
            ViewBag.MHRequestCode = MHRequestCode;
            return PartialView("~/Views/MHRequisition/_MHRequisitionApprove.cshtml", objMH);
        }
        public JsonResult PopulateTitleForMapping(string keyword, string Type)
        {
            if (Type == "Music")
            {
                var result = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name.ToUpper().Contains(keyword.ToUpper()))
                    .Select(R => new { Mapping_Name = R.Music_Title_Name, Mapping_Code = R.Music_Title_Code }).Take(25).ToList();
                return Json(result);
            }
            else
            {
                var result = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Name.ToUpper().Contains(keyword.ToUpper()))
                    .Select(R => new { Mapping_Name = R.Music_Album_Name, Mapping_Code = R.Music_Album_Code }).Take(25).ToList();
                return Json(result);
            }
        }
        public JsonResult GetShowName(string Searched_Title, string TabName)
        {
            List<string> terms = Searched_Title.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();

            //Extract the term to be searched from the list
            string searchString = terms.LastOrDefault().ToString().Trim();
            int typecode = 1;
            if (TabName == "OT")
            {
                typecode = 2;
            }
            else if (TabName == "SM")
            {
                typecode = 3;
            }
            var result = new MHRequest_Service(objLoginEntity.ConnectionStringName)
                .SearchFor(x => x.Title.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.MHRequestTypeCode == typecode)
               .Select(R => new { Mapping_Name = R.Title.Title_Name, Mapping_Code = R.Title.Title_Code }).Distinct().ToList();
            return Json(result);
        }
        public PartialViewResult AddMusicTitle(int MHRequestDetailsCode, int MusicAlbumCode, string MusicAlbumName, int MusicLabelCode, string MusicLabelName,
            string Type)
        {
            MHRequestDetail objMHReqDetail = new MHRequestDetails_Service(objLoginEntity.ConnectionStringName).GetById(MHRequestDetailsCode);
            List<SelectListItem> lstMovieAlbum = new List<SelectListItem>();
            lstMovieAlbum = new SelectList(new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Music_Album_Code", "Music_Album_Name",objMHReqDetail.MovieAlbumCode).ToList();
            lstMovieAlbum.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            ViewBag.MusicMovieAlbumList = lstMovieAlbum;

            List<SelectListItem> lstMusicLabel = new List<SelectListItem>();
            lstMusicLabel = new SelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Music_Label_Code", "Music_Label_Name", objMHReqDetail.MusicLabelCode).ToList();
            lstMusicLabel.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            ViewBag.MusicLabelList = lstMusicLabel;

            //var lstTalent = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Talent_Name().ToList();
            //var lstSinger = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_Code_Singer);

            int Original_Language_code = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "Title_OriginalLanguage").Select(i => i.Parameter_Value).FirstOrDefault());
            
            if (Type == "Movie")
            {
                ViewBag.AlbumType = objMHReqDetail.MovieAlbum == "M" ? "Movie" : "Album";
                ViewBag.Movie = objMHReqDetail.TitleName;
                List<RightsU_Entities.Talent> lstTalent = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Talent_Role.Any(a => a.Role_Code == GlobalParams.Role_code_StarCast)).OrderBy(o => o.Talent_Name).ToList();
                ViewBag.TalentList = new MultiSelectList(lstTalent, "Talent_Code", "Talent_Name");
            }
            else if (Type == "Music")
            {
                //int?[] arrSingerCodes = new Music_Title_Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true && x.Role_Code == GlobalParams.Role_Code_Singer).Select(s => s.Talent_Code).Distinct().ToArray();
                //ViewBag.SingersList = new MultiSelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                //    .Where(x => arrSingerCodes.Contains(x.Talent_Code)).Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }).Distinct().OrderBy(i => i.Display_Value).ToList(),
                //    "Display_Value", "Display_Text", objMHReqDetail.Singers.Split(','));

                //int?[] arrstarcastCodes = new Music_Title_Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true && x.Role_Code == GlobalParams.Role_code_StarCast).Select(s => s.Talent_Code).Distinct().ToArray();
                //MultiSelectList lstMStarCast = new MultiSelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                //    .Where(x => arrstarcastCodes.Contains(x.Talent_Code)).Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }).Distinct().OrderBy(i => i.Display_Value).ToList(),
                //    "Display_Value", "Display_Text",objMHReqDetail.StarCasts.Split(','));
                //ViewBag.StarcastList = lstMStarCast;

                MultiSelectList lstMusicLanguage = new MultiSelectList(new Music_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                 .Select(i => new { Language_Code = i.Music_Language_Code, Language_Name = i.Language_Name }).ToList(), "Language_Code", "Language_Name");

                List<RightsU_Entities.Talent> lststarcast = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Talent_Role.Any(a => a.Role_Code == GlobalParams.Role_code_StarCast)).OrderBy(o => o.Talent_Name).ToList();
                ViewBag.StarcastList = new MultiSelectList(lststarcast, "Talent_Code", "Talent_Name", objMHReqDetail.StarCasts.Split(','));

                List<RightsU_Entities.Talent> lstSingers = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Talent_Role.Any(a => a.Role_Code == GlobalParams.Role_Code_Singer)).OrderBy(o => o.Talent_Name).ToList();
                ViewBag.SingersList = new MultiSelectList(lstSingers, "Talent_Code", "Talent_Name", objMHReqDetail.Singers.Split(','));

                ViewBag.Language = lstMusicLanguage;
                ViewBag.MusicLabelCode = MusicLabelCode; 
                ViewBag.MusicLabelName = MusicLabelName;
                ViewBag.MusicAlbumCode = MusicAlbumCode;
                ViewBag.MusicAlbumName = MusicAlbumName;
                ViewBag.Music = objMHReqDetail.MusicTrackName;
            }
            ViewBag.MHRequestDetailsCode = MHRequestDetailsCode;
            ViewBag.Type = Type;
            return PartialView("~/Views/MHRequisition/_Create.cshtml");
        }
        public JsonResult ValidateIsDuplicate(string TitleName, int MusicAlbumCode, string Music_Album_Type, string ViewType = "Music")
        {
            if (ViewType == "Movie")
            {
                TitleName = TitleName.Trim(' ');
                int Count = 0;
                Music_Album objMusic_Album = new Music_Album();
                Count = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Name == TitleName).Count();

                Dictionary<string, object> objJson = new Dictionary<string, object>();
                if (Count > 0)
                    objJson.Add("Message", "Music Album with same name already exists");
                else
                    objJson.Add("Message", "");

                return Json(objJson);
            }
            else
            {
                TitleName = TitleName.Trim(' ');
                int Count = 0;
                Count = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name == TitleName && x.Music_Album_Code == MusicAlbumCode).Distinct().Count();
                Dictionary<string, object> objJson = new Dictionary<string, object>();
                if (Count > 0)
                    objJson.Add("Message", "Music Track with same name already exists");
                else
                    objJson.Add("Message", "");
                return Json(objJson);
            }
        }
        public JsonResult FinalMovieMusicApprove(List<MHRequestDetailSave> lstRequestDetails, string SpecialInstruction = "",string InternalRmk = "", int MHRequestCode = 0, string IsApprove = "", string Type = "")
        {
            string Message = string.Empty;
            string status = "";
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            MHRequest_Service objMHReqService = new MHRequest_Service(objLoginEntity.ConnectionStringName);
            MHRequest objMHReq = objMHReqService.GetById(MHRequestCode);
            objMHReq.SpecialInstruction = SpecialInstruction;
            objMHReq.InternalRemarks = InternalRmk;
            dynamic resultSet;
            objMHReq.EntityState = State.Modified;
            if (lstRequestDetails != null)
                foreach (MHRequestDetailSave item in lstRequestDetails)
                {
                    int DetailCode = Convert.ToInt32(item.MHRequestDetailCode);
                    MHRequestDetail objMHReqDetail = objMHReq.MHRequestDetails.Where(x => x.MHRequestDetailsCode == DetailCode).FirstOrDefault();

                    if (objMHReqDetail.IsApprove == "N")
                        objMHReqDetail.EntityState = State.Unchanged;
                    else
                        objMHReqDetail.EntityState = State.Modified;
                    if (Type == "Music")
                    {
                        
                        if (!string.IsNullOrEmpty(item.MusicTitleCode) && item.MusicTitleCode != "0")
                        {
                            objMHReqDetail.MusicTitleCode = Convert.ToInt32(item.MusicTitleCode);
                        }
                    }
                    else if (Type == "Movie")
                    {
                        if (!string.IsNullOrEmpty(item.MusicAlbumCode))
                        {
                            objMHReqDetail.MovieAlbumCode = Convert.ToInt32(item.MusicAlbumCode);
                        }
                    }
                    objMHReqDetail.Remarks = item.Remarks;
                    if (IsApprove == "A" || IsApprove == "PA")
                    {
                        if (objMHReqDetail.IsApprove != "N")
                        {
                            objMHReqDetail.IsApprove = "Y";
                        }
                        //else
                        //{
                        //    IsApprove = "PA";
                        //}
                    }
                    else
                    {
                        if (objMHReqDetail.IsApprove != "Y")
                        {
                            objMHReqDetail.IsApprove = "N";
                        }
                        //else
                        //{
                        //    IsApprove = "PA";
                        //}
                    }
                    objMHReqDetail.CreateMap = item.CreateMap;
                }
            int ApprovedCount = objMHReq.MHRequestDetails.Where(x => x.IsApprove == "Y").Count();
            int RejectedCount = objMHReq.MHRequestDetails.Where(x => x.IsApprove == "N").Count();
            //if ((ApprovedCount != 0 && RejectedCount != 0) || ApprovedCount < objMHReq.MHRequestDetails.Count() || RejectedCount < objMHReq.MHRequestDetails.Count())
            //{
            //    objMHReq.MHRequestStatusCode = 4;
            //}
            //else 
            if (ApprovedCount == objMHReq.MHRequestDetails.Count())
            {
                objMHReq.MHRequestStatusCode = 1;
            }
            else if (RejectedCount == objMHReq.MHRequestDetails.Count())
            {
                objMHReq.MHRequestStatusCode = 3;
            }
            else
            {
                objMHReq.MHRequestStatusCode = 4;
            }
            objMHReq.ApprovedOn = DateTime.Now;
            objMHReq.ApprovedBy = objLoginUser.Users_Code;
            objMHReqService.Update(objMHReq, out resultSet);
            if (objMHReq.MHRequestDetails.Where(x => x.IsApprove == "P").Count() == 0)
            {
                var result = new USP_Service(objLoginEntity.ConnectionStringName).USPMHMailNotification((int)objMHReq.MHRequestCode, objMHReq.MHRequestTypeCode, 0).FirstOrDefault();
            }

            if (IsApprove != "")
            {
                Message = "Record Saved Successfully";
                status = "S";
            }
           

            objJson.Add("Message", Message);
            objJson.Add("status", status);
            return Json(objJson);
        }
        public JsonResult SaveTitle(string TitleName, string MovieAlbumCode, string hdnddlLanguage, string hdnMusicLabel, string Type, string[] Talent_Code, string Starcast, string Singer,
            int MHRequestDetailsCode = 0, string Music_Album_Type = "")
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            string Message = "";
            MHRequestDetails_Service objMHService = new MHRequestDetails_Service(objLoginEntity.ConnectionStringName);
            MHRequestDetail objMHRequestDetail = objMHService.SearchFor(x => x.MHRequestDetailsCode == MHRequestDetailsCode).FirstOrDefault();
            objMHRequestDetail.EntityState = State.Modified;
            if (Type == "Movie")
            {
                Music_Album objMusic_Album = new Music_Album();
                Music_Album_Service ObjMusicAlbumService = new Music_Album_Service(objLoginEntity.ConnectionStringName);

             


                objMusic_Album.EntityState = State.Added;
                objMusic_Album.Is_Active = "Y";

                objMusic_Album.Last_UpDated_Time = DateTime.Now;
                objMusic_Album.Music_Album_Name = TitleName;
                if (Music_Album_Type == "Movie")
                { objMusic_Album.Album_Type = "M"; }
                else
                { objMusic_Album.Album_Type = "A"; }
                dynamic resultSet1;
                string status = "S", message = "Record {ACTION} successfully";
                ICollection<Music_Album_Talent> TalentList = new HashSet<Music_Album_Talent>();
                if (Talent_Code != null)
                {
                    foreach (string TalentCodes in Talent_Code)
                    {
                        Music_Album_Talent objMAT = new Music_Album_Talent();
                        objMAT.EntityState = State.Added;
                        objMAT.Role_Code = GlobalParams.Role_code_StarCast;
                        objMAT.Talent_Code = Convert.ToInt32(TalentCodes);
                        TalentList.Add(objMAT);
                    }
                }

                IEqualityComparer<Music_Album_Talent> comparerTalent_Code = new LambdaComparer<Music_Album_Talent>((x, y) => x.Talent_Code == y.Talent_Code && x.EntityState != State.Deleted);
                var Deleted_Music_Album_Talent = new List<Music_Album_Talent>();
                var Updated_Music_Album_Talent = new List<Music_Album_Talent>();
                var Added_Music_Album_Talent = CompareLists<Music_Album_Talent>(TalentList.ToList<Music_Album_Talent>(), objMusic_Album.Music_Album_Talent.ToList<Music_Album_Talent>(), comparerTalent_Code, ref Deleted_Music_Album_Talent, ref Updated_Music_Album_Talent);
                Added_Music_Album_Talent.ToList<Music_Album_Talent>().ForEach(t => objMusic_Album.Music_Album_Talent.Add(t));
                Deleted_Music_Album_Talent.ToList<Music_Album_Talent>().ForEach(t => t.EntityState = State.Deleted);

                bool valid = ObjMusicAlbumService.Save(objMusic_Album, out resultSet1);
                objMHRequestDetail.MovieAlbumCode = objMusic_Album.Music_Album_Code;
                Message = objMessageKey.RecordAddedSuccessfully;
                objJson.Add("TitleName", objMusic_Album.Music_Album_Name);
                objJson.Add("TitleCode", objMusic_Album.Music_Album_Code);
            }
            else
            {
                //dynamic resultSet1;
                Music_Title objMusicTitle = new Music_Title();
                //Music_Title_Service ObjMusicTitleService = new Music_Title_Service(objLoginEntity.ConnectionStringName);
                objMusicTitle.Music_Title_Name = TitleName;
                objMusicTitle.Movie_Album = "";
                int Music_Version = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Music_Version_Code").Select(x => x.Parameter_Value).FirstOrDefault());
                objMusicTitle.Music_Version_Code = Music_Version;
                objMusicTitle.EntityState = State.Added;
                objMusicTitle.Inserted_By = objLoginUser.Users_Code;
                objMusicTitle.Inserted_On = DateTime.Now;
                objMusicTitle.Last_UpDated_Time = DateTime.Now;
                objMusicTitle.Is_Active = "Y";
                objMusicTitle.Public_Domain = "N";
                if (MovieAlbumCode != "")
                {
                    objMusicTitle.Music_Album_Code = Convert.ToInt32(MovieAlbumCode);
                }
                new Music_Title_Service(objLoginEntity.ConnectionStringName).Save(objMusicTitle);
                Music_Title_Label objMusicLabel = new Music_Title_Label();
                objMusicLabel.Music_Label_Code = Convert.ToInt32(hdnMusicLabel);
                objMusicLabel.Music_Title_Code = objMusicTitle.Music_Title_Code;
                objMusicLabel.Effective_From = Convert.ToDateTime(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "Music_Label_Effective_From").Select(i => i.Parameter_Value).FirstOrDefault());
                objMusicLabel.EntityState = State.Added;

                new Music_Title_Label_Service(objLoginEntity.ConnectionStringName).Save(objMusicLabel);

                #region ========= Music Language creation =========
                string[] Language_Codes = hdnddlLanguage.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string languageCodes in Language_Codes)
                {
                    if (languageCodes != "")
                    {
                        int lanCode = Convert.ToInt32(languageCodes);
                        Music_Title_Language objTL = new Music_Title_Language();
                        objTL.EntityState = State.Added;
                        objTL.Music_Title_Code = objMusicTitle.Music_Title_Code;
                        objTL.Music_Language_Code = Convert.ToInt32(languageCodes);
                        new Music_Title_Language_Service(objLoginEntity.ConnectionStringName).Save(objTL);
                    }
                }
                #endregion
              
                #region ========= Music Starcast creation =========
                string[] Starcast_Codes = Starcast.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string starcastCodes in Starcast_Codes)
                {
                    if (starcastCodes != "")
                    {
                        int SCCode = Convert.ToInt32(starcastCodes);
                        Music_Title_Talent objTT = new Music_Title_Talent();
                        objTT.EntityState = State.Added;
                        objTT.Music_Title_Code = objMusicTitle.Music_Title_Code;
                        objTT.Role_Code = GlobalParams.Role_code_StarCast;
                        objTT.Talent_Code = Convert.ToInt32(starcastCodes);
                        new Music_Title_Talent_Service(objLoginEntity.ConnectionStringName).Save(objTT);
                    }
                }
                #endregion
              
                #region ========= Music Singers creation =========
                string[] Singer_Codes = Singer.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string singerCodes in Singer_Codes)
                {
                    if (singerCodes != "")
                    {
                        int SGCode = Convert.ToInt32(singerCodes);
                        Music_Title_Talent objTT = new Music_Title_Talent();
                        objTT.EntityState = State.Added;
                        objTT.Music_Title_Code = objMusicTitle.Music_Title_Code;
                        objTT.Role_Code = GlobalParams.Role_Code_Singer;
                        objTT.Talent_Code = Convert.ToInt32(singerCodes);
                        new Music_Title_Talent_Service(objLoginEntity.ConnectionStringName).Save(objTT);
                    }
                }
                #endregion
                objMHRequestDetail.MusicTitleCode = objMusicTitle.Music_Title_Code;
                objJson.Add("TitleName", objMusicTitle.Music_Title_Name);
                objJson.Add("TitleCode", objMusicTitle.Music_Title_Code);
            }
            dynamic resultSet;
            objMHRequestDetail.CreateMap = "C";
            objMHService.Update(objMHRequestDetail, out resultSet);
            Message = objMessageKey.RecordAddedSuccessfully;
            objJson.Add("Message", Message);
            return Json(objJson);

         
      
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
        public JsonResult BindAdvanced_Search_Controls()
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();

            //var lstTalent = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Talent_Name().ToList();
            //var lstStarCast = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_code_StarCast);
            //var lstDirector = lstTalent.Where(x => x.Role_Code == GlobalParams.RoleCode_Director);

            //MultiSelectList lstLanguage = new MultiSelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
            //    .Select(i => new { Display_Value = i.Language_Code, Display_Text = i.Language_Name }).ToList(), "Display_Value", "Display_Text");

            //var lst_title = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Original_Language_Code != null).Select(x => x.Original_Language_Code).Distinct().ToList();
            //var lst_Lang = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();

            //var lstOgLang = (from t1 in lst_title
            //                 join t2 in lst_Lang on t1.Value equals t2.Language_Code
            //                 select new { t1.Value, t2.Language_Name }).ToList();

            //MultiSelectList lstOrigLang = new MultiSelectList(lstOgLang
            //   .Select(i => new { Display_Value = i.Value, Display_Text = i.Language_Name }).ToList(), "Display_Value", "Display_Text");


            //MultiSelectList lstCountry = new MultiSelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
            //    .Select(i => new { Display_Value = i.Country_Code, Display_Text = i.Country_Name }).ToList(), "Display_Value", "Display_Text");
            //MultiSelectList lstDealType = new MultiSelectList(new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
            //    .Select(i => new { Display_Value = i.Deal_Type_Code, Display_Text = i.Deal_Type_Name }).ToList(), "Display_Value", "Display_Text");
            //MultiSelectList lstTStarCast = new MultiSelectList(lstStarCast.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }),
            //    "Display_Value", "Display_Text");
            //MultiSelectList lstTDirector = new MultiSelectList(lstDirector.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }),
            //    "Display_Value", "Display_Text");
            //SelectList lstProgram = new SelectList(new Program_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
            //.Select(i => new { Display_Value = i.Program_Code, Display_Text = i.Program_Name }).ToList(), "Display_Value", "Display_Text");


            var lstVen = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").Select(x=> new { x.Vendor_Code, x.Vendor_Name}).ToList();
            var lstMHVendor = new MHRequest_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.VendorCode != null).Select(x => x.VendorCode).Distinct().ToList();
            var lstVendor = from V in lstVen join MHV in lstMHVendor on V.Vendor_Code equals MHV.Value select V;

            List<SelectListItem> lstProdHouseVendor = new SelectList(lstVendor, "Vendor_Code", "Vendor_Name", 0).ToList();
            List<SelectListItem> lstStatus = new SelectList(new MHRequestStatu_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.RequestStatusName != "")
                , "MHRequestStatusCode", "RequestStatusName", 0).ToList();
            MultiSelectList lstMusicLabel = new MultiSelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                .Select(i => new { Display_Value = i.Music_Label_Code, Display_Text = i.Music_Label_Name }).ToList(), "Display_Value", "Display_Text");

            //lstProdHouseVendor.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            //lstStatus.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            objJson.Add("ddlVendor", lstProdHouseVendor);
            objJson.Add("ddlStatus", lstStatus);

            objJson.Add("ddlMusicLabel", lstMusicLabel);

            if (objPage_Properties.VendorCodes_Search != "" && objPage_Properties.VendorCodes_Search != null)
                objPage_Properties.VendorCodes_Search = objPage_Properties.VendorCodes_Search;
            else
                objPage_Properties.VendorCodes_Search = "";

            if (objPage_Properties.StatusCode_Search != "" && objPage_Properties.StatusCode_Search != null)
                objPage_Properties.StatusCode_Search = objPage_Properties.StatusCode_Search;
            else
                objPage_Properties.StatusCode_Search = "";

            if (objPage_Properties.LabelCodes_Search != "" && objPage_Properties.LabelCodes_Search != null)
                objPage_Properties.LabelCodes_Search = objPage_Properties.LabelCodes_Search;
            else
                objPage_Properties.LabelCodes_Search = "";

            objJson.Add("objPage_Properties", objPage_Properties);
            return Json(objJson);
        }
        #endregion
        //public JsonResult ValidateRequest(int MHRequest)
        //{
        //    Dictionary<string, object> objJson = new Dictionary<string, object>();
        //    List<USPValidateMHRequestConsumption_Result> validatedList = objUSP_Service.USPValidateMHRequestConsumption(MHRequest).ToList();
        //    objJson.Add("validatedList", validatedList);
        //    return Json(objJson);
        //}

        public JsonResult ValidateIsDuplicateforMovie(string MusicTitleName, int MusicAlbumCode, string MusicAlbumName, string mode = "Add")
        {
            string Music_Album_Code = "", Message = "";
            int MusicAlbum = 0;
            //  MusicTitleName = MusicTitleName.Trim(' ');
            char[] splitchar = { '~' };
            string[] parts = MusicTitleName.Split(splitchar,
                         StringSplitOptions.RemoveEmptyEntries);

            foreach (string MusicTitleNameNew in parts)
            {
                int Count = 0;
                if (mode == "Add")
                {
                    Count = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name == MusicTitleNameNew && x.Music_Album_Code == MusicAlbumCode).Distinct().Count();
                }

                if (Count > 0)
                    Message = Message + MusicTitleNameNew + "Already Exists, ";

            }
            if (MusicAlbumCode == 0)
            {
                Music_Album_Code = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Name == MusicAlbumName).Select(x => x.Music_Album_Code).FirstOrDefault().ToString();
                MusicAlbumCode = Convert.ToInt32(Music_Album_Code);
            }
            if (MusicAlbumCode != 0)
            {
                MusicAlbum = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Name == MusicAlbumName).Select(x => x.Music_Album_Code).FirstOrDefault();
            }

            Dictionary<string, object> objJson = new Dictionary<string, object>();

            objJson.Add("Message", Message);

            if (MusicAlbum == 0)
                objJson.Add("ErrorMessage", objMessageKey.MusicAlbumisnotFound);
            else
                objJson.Add("ErrorMessage", "");
            if (Music_Album_Code != "")
            {
                objJson.Add("MusicAlbumCode", Music_Album_Code);
            }
            else
                objJson.Add("MusicAlbumCode", "");
            return Json(objJson);
        }

        public PartialViewResult AddMusicTitleForMovie()
        {

            int Original_Language_code = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "Title_OriginalLanguage").Select(i => i.Parameter_Value).FirstOrDefault());

            MultiSelectList lstMusicLanguage = new MultiSelectList(new Music_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                 .Select(i => new { Language_Code = i.Music_Language_Code, Language_Name = i.Language_Name }).ToList(), "Language_Code", "Language_Name");


            ViewBag.Language = lstMusicLanguage;


            //ViewBag.PageNo = PageNo;
            //ViewBag.SearchedTitle = objPage_Properties.SearchText;
            //ViewBag.PageSize = MusicPageSize;
            List<SelectListItem> lstMusicLabel = new List<SelectListItem>();
            lstMusicLabel = new SelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Music_Label_Code", "Music_Label_Name", 0).ToList();
            lstMusicLabel.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            ViewBag.MusicLabelList = lstMusicLabel;

            // ViewBag.MovieAlbum = BindMovieAlbum();

            return PartialView("_CreateNewTitle", new Music_Title());
        }

        public JsonResult SaveTitleForMovie(string MusicTitleName, string MovieAlbumName, string hdnddlLanguage, string hdnMusicLabel)
        {
            char[] splitchar = { '~' };
            string[] parts = MusicTitleName.Split(splitchar,StringSplitOptions.RemoveEmptyEntries);
            foreach (string MusicTitleNameNew in parts)
            {

                Music_Title objMusicTitle = new Music_Title();
                objMusicTitle.Music_Title_Name = MusicTitleNameNew;
                objMusicTitle.Movie_Album = "";
                int Music_Version = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Music_Version_Code").Select(x => x.Parameter_Value).FirstOrDefault());
                objMusicTitle.Music_Version_Code = Music_Version;
                objMusicTitle.EntityState = State.Added;
                //objMusicTitle.Language_Code = Convert.ToInt32(hdnddlLanguage);
                objMusicTitle.Inserted_By = objLoginUser.Users_Code;
                objMusicTitle.Inserted_On = DateTime.Now;
                objMusicTitle.Last_UpDated_Time = DateTime.Now;
                objMusicTitle.Is_Active = "Y";
                objMusicTitle.Public_Domain = "N";
                if (MovieAlbumName != "")
                {
                    objMusicTitle.Music_Album_Code = Convert.ToInt32(MovieAlbumName);
                }
                new Music_Title_Service(objLoginEntity.ConnectionStringName).Save(objMusicTitle);

                Music_Title_Label objMusicLabel = new Music_Title_Label();
                objMusicLabel.Music_Label_Code = Convert.ToInt32(hdnMusicLabel);
                objMusicLabel.Music_Title_Code = objMusicTitle.Music_Title_Code;
                objMusicLabel.Effective_From = Convert.ToDateTime(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "Music_Label_Effective_From").Select(i => i.Parameter_Value).FirstOrDefault());
                objMusicLabel.EntityState = State.Added;
                new Music_Title_Label_Service(objLoginEntity.ConnectionStringName).Save(objMusicLabel);


                #region ========= Music Language creation =========
                string[] Language_Codes = hdnddlLanguage.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string languageCodes in Language_Codes)
                {
                    if (languageCodes != "")
                    {
                        int lanCode = Convert.ToInt32(languageCodes);
                        Music_Title_Language objTL = new Music_Title_Language();
                        objTL.EntityState = State.Added;
                        objTL.Music_Title_Code = objMusicTitle.Music_Title_Code;
                        objTL.Music_Language_Code = Convert.ToInt32(languageCodes);
                        //objTitle.Music_Title_Language.Add(objT);
                        new Music_Title_Language_Service(objLoginEntity.ConnectionStringName).Save(objTL);
                    }
                }
                #endregion

            }

            string Message = "Record Added Successfully";
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            objJson.Add("Message", Message);
            return Json(objJson);
        }
    }
    public class MHRequestDetailSave
    {
        public string MHRequestDetailCode { get; set; }
        public string MusicTitleCode { get; set; }
        public string MusicAlbumCode { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }
        public string CreateMap { get; set; }
    }
    public class MHRequestSearch
    {
        public string VendorCodes_Search { get; set; }
        public string StatusCode_Search { get; set; }
        public string LabelCodes_Search { get; set; }
    }
}
