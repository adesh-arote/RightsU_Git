using OfficeOpenXml;
using OfficeOpenXml.Style;
using RightsUMusic.BLL.Services;
using RightsUMusic.Entity;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Cors;

namespace RightsUMusic.API.Controllers
{
    public class RequisitionModuleController : ApiController
    {
        private readonly RequisitionModuleManagementServices obj = new RequisitionModuleManagementServices();
        private readonly MHUsersServices objMHUsersServices = new MHUsersServices();

        HttpActionContext actionContext = new HttpActionContext();

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        // [ActionName("GetUserLogin")]
        //[EnableCors(origins: "*", headers: "*", methods: "*")]
        public HttpResponseMessage GetShowNameList(Channel objChannel)
        {
            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "");
            IEnumerable<USPMHShowNameList> lstShowName = new List<USPMHShowNameList>();
            Return _objRet = new Return();
            try
            {
                lstShowName = obj.GetShowNameList(Convert.ToInt32(UserCode), objChannel.Channel_Code);
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, Show = lstShowName }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetMusicLabel(MusicLabelInput objGetMusicLabelList)
        {
            //IEnumerable<Music_Label> lstMusicLabel = new List<Music_Label>();
            Return _objRet = new Return();
            try
            {
                //string strSearch = "AND Is_active = 'Y'";
                var lstMusicLabel = obj.GetMusicLabelList(objGetMusicLabelList.ChannelCode, objGetMusicLabelList.TitleCode);//.Where(x=>x.Is_Active == 'Y').Select(x=> new { x.Music_Label_Code , x.Music_Label_Name}).ToList();

                lstMusicLabel.ToList();
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, Music = lstMusicLabel }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetGenre()
        {
            Return _objRet = new Return();
            try
            {
                string strSearch = "AND Is_active = 'Y'";
                var lstGenre = obj.GetGenreList(strSearch);/*.Select(x=> new { x.Genres_Code,x.Genres_Name});*/
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, Music = lstGenre }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public HttpResponseMessage GetMusicAlbum()
        {

            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "");
            Return _objRet = new Return();
            try
            {
                string strSearch = "AND Is_active = 'Y'";
                var lstMusicAlbum = obj.GetMusicAlbumList(strSearch);/*.Select(x=> new { x.Genres_Code,x.Genres_Name});*/
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, Music_Album = lstMusicAlbum }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public HttpResponseMessage GetMusicAlbumTextSearch(MusicAlbum objMusicAlbum)
        {

            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "");
            Return _objRet = new Return();
            try
            {
                string strSearch = "AND Is_active = 'Y' AND Music_Album_Name like '%" + objMusicAlbum.MusicAlbumName + "%'";
                var lstMusicAlbum = obj.GetMusicAlbumList(strSearch);/*.Select(x=> new { x.Genres_Code,x.Genres_Name});*/
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, Music_Album = lstMusicAlbum }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetChannel()
        {
            Return _objRet = new Return();
            try
            {
                string strSearch = "AND Is_active = 'Y' AND Channel_Name IN ('Colors Bangla','Colors Gujarati','Colors India','Colors Kannada','Colors Marathi','Colors Oriya','Colors Super','Colors Tamil','MTV')";
                var lstChannel = obj.GetChannelList(strSearch);/*.Select(x=> new { x.Genres_Code,x.Genres_Name});*/
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, Channel = lstChannel }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetMusicTrackList(MusicTrackInput objMusicTrackInput)
        {
            IEnumerable<USPMHSearchMusicTrack> lstMusicTrack = new List<USPMHSearchMusicTrack>();
            Return _objRet = new Return();
            int RecordCount = 0;
            try
            {
                //if (objMusicTrackInput.MusicLabelCode == "0")
                //{
                //    throw new Exception("Music Label Code Should not be blank.");

                //}
                lstMusicTrack = obj.GetMusicTrackList(objMusicTrackInput, out RecordCount);
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, Show = lstMusicTrack, RecordCount = RecordCount }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage MusicConsumptionRequest(MHRequest objMHRequest)
        {
            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "").Trim();

            var objU = new
            {
                Users_Code = Convert.ToInt32(UserCode),
            };
            MHUsers objUser = objMHUsersServices.SearchFor(objU).FirstOrDefault();

            string RequestID = obj.GetRequestID(objUser.Vendor_Code,"MU");


            objMHRequest.MHRequestTypeCode = 1;
            objMHRequest.RequestID = RequestID;
            objMHRequest.RequestedDate = System.DateTime.Now;
            objMHRequest.UsersCode = Convert.ToInt32(UserCode);
            objMHRequest.VendorCode = objUser.Vendor_Code;
            objMHRequest.MHRequestStatusCode = 2;

            Return _objRet = new Return();
            try
            {
                //lstobjRequestetail.AddRange(objMHRequest.MHRequestDetail);
                obj.SaveMusicConsumptionRequest(objMHRequest);
                obj.ValidateConsumptionRequest(objMHRequest);
                string str =  obj.SendForApproval(objMHRequest,Convert.ToInt32(UserCode));
                obj.AutoApproveUsageRequest(objMHRequest, Convert.ToInt32(UserCode));

                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, RequestID = objMHRequest.RequestID }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }

            //  return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage MusicTrackRequest(MHRequest objMHRequest)
        {
            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "");
            var objU = new
            {
                Users_Code = Convert.ToInt32(UserCode),
            };
            MHUsers objUser = objMHUsersServices.SearchFor(objU).FirstOrDefault();
            string RequestID = obj.GetRequestID(objUser.Vendor_Code,"MT");

            objMHRequest.MHRequestTypeCode = 2;
            objMHRequest.RequestID = RequestID;
            objMHRequest.RequestedDate = System.DateTime.Now;
            objMHRequest.UsersCode = Convert.ToInt32(UserCode);
            objMHRequest.VendorCode = objUser.Vendor_Code;
            objMHRequest.MHRequestStatusCode = 2;

            Return _objRet = new Return();
            try
            {
                //lstobjRequestetail.AddRange(objMHRequest.MHRequestDetail);
                obj.SaveMusicConsumptionRequest(objMHRequest);
                obj.ValidateConsumptionRequest(objMHRequest);
                obj.SendForApproval(objMHRequest,Convert.ToInt32(UserCode));
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, RequestID = objMHRequest.RequestID }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }

            //  return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage MusicAlbumRequest(MHRequest objMHRequest)
        {
            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "");
            var objU = new
            {
                Users_Code = Convert.ToInt32(UserCode),
            };
            MHUsers objUser = objMHUsersServices.SearchFor(objU).FirstOrDefault();
            string RequestID = obj.GetRequestID(objUser.Vendor_Code,"MA");

            objMHRequest.MHRequestTypeCode = 3;
            objMHRequest.RequestID = RequestID;
            objMHRequest.RequestedDate = System.DateTime.Now;
            objMHRequest.UsersCode = Convert.ToInt32(UserCode);
            objMHRequest.VendorCode = objUser.Vendor_Code;
            objMHRequest.MHRequestStatusCode = 2;

            Return _objRet = new Return();
            try
            {
                obj.SaveMusicConsumptionRequest(objMHRequest);
                obj.ValidateConsumptionRequest(objMHRequest);
                obj.SendForApproval(objMHRequest,Convert.ToInt32(UserCode));
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, RequestID = objMHRequest.RequestID }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }

            //  return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetConsumptionRequestList(ConsumptionRequestListInput objConsumptionRequestList)
        {
            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "").Trim();
            int RecordCount = 0;

            MHRequest objMHRequest = new MHRequest();
            objMHRequest.MHRequestTypeCode = 1;
            objMHRequest.UsersCode = Convert.ToInt32(UserCode);
            // objMHRequest.UsersCode = Convert.ToInt32(UserCode);
            IEnumerable<USPMHConsumptionRequestList> lstConsumptionRequest = new List<USPMHConsumptionRequestList>();
            Return _objRet = new Return();
            try
            {
                lstConsumptionRequest = obj.GetConsumptionRequestList(objMHRequest, objConsumptionRequestList, out RecordCount);//,objConsumptionRequestList.RecordFor,objConsumptionRequestList.PagingRequired, objConsumptionRequestList.PageSize, objConsumptionRequestList.PageNo,out RecordCount);
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, RequestList = lstConsumptionRequest, RecordCount = RecordCount }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetMovieAlbumMusicList(MHRequest objMHRequest)
        {
            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "").Trim();
            objMHRequest.UsersCode = Convert.ToInt32(UserCode);
            IEnumerable<USPMHMovieAlbumMusicList> lstMovieAlbumMusicList = new List<USPMHMovieAlbumMusicList>();
            Return _objRet = new Return();
            try
            {
                lstMovieAlbumMusicList = obj.GetMovieAlbumMusicList(objMHRequest);
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, RequestList = lstMovieAlbumMusicList }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);

            }

        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetConsumptionRequestDetails(RequestDetailsInput objRequestDetailsInput)
        {
            IEnumerable<ConsumptionRequestDetails> lstConsumptionRequestDetails = new List<ConsumptionRequestDetails>();
            objRequestDetailsInput.MHRequestTypeCode = 1;
            Return _objRet = new Return();
            try
            {
                lstConsumptionRequestDetails = obj.GetConsumptionRequestDetails(objRequestDetailsInput.MHRequestCode, objRequestDetailsInput.MHRequestTypeCode,Convert.ToChar(objRequestDetailsInput.IsCueSheet));
                var objRemarkSpecialInstruction = lstConsumptionRequestDetails.Select(x => new
                {
                    Remarks = x.Remarks,
                    SpecialInstructions = x.SpecialInstruction
                }).Distinct().First();

                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, RequestDetails = lstConsumptionRequestDetails, RemarkSpecialInstruction = objRemarkSpecialInstruction }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);

            }

        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetMusicTrackRequestDetails(MHRequest objMHRequest)
        {
            IEnumerable<MusicTrackRequestDetails> lstMusicTrackRequestDetails = new List<MusicTrackRequestDetails>();
            objMHRequest.MHRequestTypeCode = 2;
            Return _objRet = new Return();
            try
            {
                lstMusicTrackRequestDetails = obj.GetMusicTrackRequestDetails(objMHRequest);
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, RequestDetails = lstMusicTrackRequestDetails }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);

            }

        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetMovieAlbumRequestDetails(MHRequest objMHRequest)
        {
            IEnumerable<MovieAlbumRequestDetails> lstMovieAlbumRequestDetails = new List<MovieAlbumRequestDetails>();
            objMHRequest.MHRequestTypeCode = 3;
            Return _objRet = new Return();
            try
            {
                lstMovieAlbumRequestDetails = obj.GetMovieAlbumRequestDetails(objMHRequest);
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, RequestDetails = lstMovieAlbumRequestDetails }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);

            }

        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage CreatePlayList(MHPlayList objMHPlayList)
        {
            Return _objRet = new Return();
            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "").Trim();
            var objU = new
            {
                Users_Code = Convert.ToInt32(UserCode),
            };
            MHUsers objUser = objMHUsersServices.SearchFor(objU).FirstOrDefault();


            var objParam = new
            {
                PlaylistName = objMHPlayList.PlaylistName,
                TitleCode = objMHPlayList.TitleCode

            };

            int searchCount = obj.SearchPlayList(objParam).Count();
            if (searchCount > 0)
            {
                _objRet.Message = "Playlist already created";
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }

            objMHPlayList.VendorCode = objUser.Vendor_Code;
            objMHPlayList.IsActive = "Y";
            try
            {
                obj.CreatePlayList(objMHPlayList);
                _objRet.Message = "Playlist created successfully.";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage CreatePlayListSong(MHPlayListSong objMHPlayListSong)
        {
            Return _objRet = new Return();
            var objParam = new
            {
                MHPlayListCode = objMHPlayListSong.MHPlayListCode,
                MusicTitleCode = objMHPlayListSong.MusicTitleCode

            };

            int searchCount = obj.SearchPlayListSong(objParam).Count();
            if (searchCount > 0)
            {
                _objRet.Message = "Song already assigned to PlayList.";
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }


            objMHPlayListSong.MHPlayListSongCode = objMHPlayListSong.MHPlayListSongCode ?? 0;
            try
            {
                obj.CreatePlayListSong(objMHPlayListSong);
                _objRet.Message = "Song assigned to playlist successfully.";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetPlayList(MHPlayList objMHPlayList)
        {
            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "").Trim();

            var objU = new
            {
                Users_Code = Convert.ToInt32(UserCode),
            };
            MHUsers objUser = objMHUsersServices.SearchFor(objU).FirstOrDefault();

            objMHPlayList.VendorCode = objUser.Vendor_Code;

            IEnumerable<MHPlayList> lstMHPlayList = new List<MHPlayList>();
            Return _objRet = new Return();
            try
            {
                string strSearch = "TitleCode = " + objMHPlayList.TitleCode + "AND VendorCode =" + objMHPlayList.VendorCode;
                lstMHPlayList = obj.GetPlayList(strSearch);
                var MHPlayList = lstMHPlayList.Select(x => new { MHPlayListCode = x.MHPlayListCode, PlaylistName = x.PlaylistName }).ToList();
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, MHPlayList = MHPlayList }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);

            }

        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetTitleEpisode(Title objTitle)
        {
            IEnumerable<USPMHGetTitleEpisode> lstTitleEpisode = new List<USPMHGetTitleEpisode>();
            Return _objRet = new Return();
            try
            {
                lstTitleEpisode = obj.GetTitleEpisode(objTitle);
                var lst = lstTitleEpisode.Select(x => new { MinEpisode = x.MinEpisode, MaxEpisode = x.MaxEpisode }).FirstOrDefault();
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, MinEpisode = lst.MinEpisode, MaxEpisode = lst.MaxEpisode }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);

            }

        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage ExportConsumptionList(ConsumptionRequestListInput objConsumptionRequestList)
        {
            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "").Trim();
            int RecordCount = 0;

            objConsumptionRequestList.PagingRequired = "N";

            MHRequest objMHRequest = new MHRequest();
            objMHRequest.MHRequestTypeCode = 1;
            objMHRequest.UsersCode = Convert.ToInt32(UserCode);
            // objMHRequest.UsersCode = Convert.ToInt32(UserCode);
            List<USPMHConsumptionRequestList> lstConsumptionRequest = new List<USPMHConsumptionRequestList>();
            Return _objRet = new Return();
            try
            {
                lstConsumptionRequest = (List<USPMHConsumptionRequestList>)obj.GetConsumptionRequestList(objMHRequest, objConsumptionRequestList, out RecordCount);//,objConsumptionRequestList.RecordFor,objConsumptionRequestList.PagingRequired, objConsumptionRequestList.PageSize, objConsumptionRequestList.PageNo,out RecordCount);


                HttpResponseMessage response;
                response = Request.CreateResponse(HttpStatusCode.OK);
                MediaTypeHeaderValue mediaType = new MediaTypeHeaderValue("application/octet-stream");

                var consumptionList = lstConsumptionRequest;

                string Destination = HttpContext.Current.Server.MapPath("~/") + (objConsumptionRequestList.ExportFor == "A" ? "Temp\\AuthorisedReport.xlsx" : "Temp\\ConsumptionRequestList.xlsx");
                FileInfo OldFile = new FileInfo(HttpContext.Current.Server.MapPath("~/") + "Temp\\Sample1.xlsx");
                FileInfo newFile = new FileInfo(Destination);
                string Name = newFile.Name.ToString();
                if (newFile.Exists)
                {
                    newFile.Delete(); // ensures we create a new workbook
                    newFile = new FileInfo(Destination);
                }
                _objRet.Message = newFile.Name;
                var excelPackage = new ExcelPackage(newFile, OldFile);
                var sheet = excelPackage.Workbook.Worksheets["Sheet1"];
                sheet.Name = "Studio";
                if(objConsumptionRequestList.ExportFor == "A")
                {
                    sheet.Cells[1, 1].Value = "Request #";
                    sheet.Cells[1, 2].Value = "Channel";
                    sheet.Cells[1, 3].Value = "Show";
                    sheet.Cells[1, 4].Value = "Songs requested";
                    sheet.Cells[1, 5].Value = "Songs approved";
                    sheet.Cells[1, 6].Value = "Episode";
                    sheet.Cells[1, 7].Value = "Telecast";
                    sheet.Cells[1, 8].Value = "Status";
                    sheet.Cells[1, 9].Value = "Requested By";
                    sheet.Cells[1, 10].Value = "Requested Date";
                }
                else
                {
                    sheet.Cells[1, 1].Value = "Request #";
                    sheet.Cells[1, 2].Value = "Channel";
                    sheet.Cells[1, 3].Value = "Show";
                    sheet.Cells[1, 4].Value = "No. of Songs";
                    sheet.Cells[1, 5].Value = "Episode";
                    sheet.Cells[1, 6].Value = "Telecast";
                    sheet.Cells[1, 7].Value = "Status";
                    sheet.Cells[1, 8].Value = "Requested By";
                    sheet.Cells[1, 9].Value = "Requested Date";
                }
                

                for (int i = 1; i <= 10; i++)
                {
                    Color colFromHex = System.Drawing.ColorTranslator.FromHtml("#C0C0C0");
                    sheet.Cells[1, i].Style.Font.Bold = true;
                    sheet.Cells[1, i].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    sheet.Cells[1, i].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                    sheet.Cells[1, i].Style.Font.Size = 11;
                    sheet.Cells[1, i].Style.Font.Name = "Calibri";
                    sheet.Cells[1, i].Style.Fill.PatternType = ExcelFillStyle.Solid;
                    sheet.Cells[1, i].Style.Fill.BackgroundColor.SetColor(colFromHex);
                    //sheet.Cells.AutoFitColumns(10,50);
                    sheet.Cells[1, i].AutoFitColumns();
                }

                ExcelColumn col1 = sheet.Column(1);
                ExcelColumn col2 = sheet.Column(2);
                ExcelColumn col3 = sheet.Column(3);
                ExcelColumn col4 = sheet.Column(4);
                ExcelColumn col5 = sheet.Column(5);
                ExcelColumn col6 = sheet.Column(6);
                ExcelColumn col7 = sheet.Column(7);
                ExcelColumn col8 = sheet.Column(8);
                ExcelColumn col9 = sheet.Column(9);
                ExcelColumn col10 = sheet.Column(10);

                col1.Width = 18;
                col2.Width = 20;
                col3.Width = 25;
                col4.Width = 18;
                col5.Width = objConsumptionRequestList.ExportFor == "A" ? 18: 12;
                col6.Width = 25;
                col7.Width = 15;
                col8.Width = 18;
                col9.Width = 22;
                col10.Width = 25;

                for (int i = 0; i < consumptionList.Count; i++)
                {
                    //.Remove(10, 9);
                    DateTime dtFrom = Convert.ToDateTime(consumptionList[i].TelecastFrom.ToString()); 
                    string TelecastFrom = dtFrom.ToString("dd-MMM-yyyy");

                    DateTime dtTo = Convert.ToDateTime(consumptionList[i].TelecastTo.ToString());
                    string TelecastTo = dtTo.ToString("dd-MMM-yyyy");
                    if(objConsumptionRequestList.ExportFor == "A")
                    {
                        sheet.Cells["A" + (i + 2)].Value = consumptionList[i].RequestID;
                        sheet.Cells["B" + (i + 2)].Value = consumptionList[i].ChannelName;
                        sheet.Cells["C" + (i + 2)].Value = consumptionList[i].Title_Name;
                        sheet.Cells["D" + (i + 2)].Value = consumptionList[i].CountRequest;
                        sheet.Cells["E" + (i + 2)].Value = consumptionList[i].ApprovedRequest;
                        sheet.Cells["F" + (i + 2)].Value = consumptionList[i].EpisodeFrom == consumptionList[i].EpisodeTo ? consumptionList[i].EpisodeFrom.ToString() : consumptionList[i].EpisodeFrom + " - " + consumptionList[i].EpisodeTo;
                        sheet.Cells["G" + (i + 2)].Value = consumptionList[i].TelecastFrom.ToString().Remove(10, 9) == consumptionList[i].TelecastTo.ToString().Remove(10, 9) ?
                          TelecastFrom : TelecastFrom + " To " + TelecastTo;
                        sheet.Cells["H" + (i + 2)].Value = consumptionList[i].Status;
                        sheet.Cells["I" + (i + 2)].Value = consumptionList[i].Login_Name;
                        sheet.Cells["J" + (i + 2)].Value = consumptionList[i].RequestDate.ToString();
                    }
                    else
                    {
                        sheet.Cells["A" + (i + 2)].Value = consumptionList[i].RequestID;
                        sheet.Cells["B" + (i + 2)].Value = consumptionList[i].ChannelName;
                        sheet.Cells["C" + (i + 2)].Value = consumptionList[i].Title_Name;
                        sheet.Cells["D" + (i + 2)].Value = consumptionList[i].CountRequest;
                        sheet.Cells["E" + (i + 2)].Value = consumptionList[i].EpisodeFrom == consumptionList[i].EpisodeTo ? consumptionList[i].EpisodeFrom.ToString() : consumptionList[i].EpisodeFrom + " - " + consumptionList[i].EpisodeTo;
                        sheet.Cells["F" + (i + 2)].Value = consumptionList[i].TelecastFrom.ToString().Remove(10, 9) == consumptionList[i].TelecastTo.ToString().Remove(10, 9) ?
                          TelecastFrom : TelecastFrom + " To " + TelecastTo;
                        sheet.Cells["G" + (i + 2)].Value = consumptionList[i].Status;
                        sheet.Cells["H" + (i + 2)].Value = consumptionList[i].Login_Name;
                        sheet.Cells["I" + (i + 2)].Value = consumptionList[i].RequestDate.ToString();
                    }

                    

                    sheet.Cells["A" + (i + 2)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                    sheet.Cells["A" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["B" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["C" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["D" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["E" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["F" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["G" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["H" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["I" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["J" + (i + 2)].Style.Font.Name = "Calibri";

                    sheet.Cells["D" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    sheet.Cells["E" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    sheet.Cells["F" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    //sheet.Cells["A" + (i + 2)].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                    //sheet.Cells["B" + (i + 2)].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                    //sheet.Cells["C" + (i + 2)].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                }

                excelPackage.Workbook.Properties.Title = "PlanIT";
                excelPackage.Workbook.Properties.Author = "";
                excelPackage.Workbook.Properties.Comments = "";

                // set some extended property values
                excelPackage.Workbook.Properties.Company = "";

                // set some custom property values
                excelPackage.Workbook.Properties.SetCustomPropertyValue("Checked by", "");
                excelPackage.Workbook.Properties.SetCustomPropertyValue("AssemblyName", "EPPlus");
                // save our new workbook and we are done!
                excelPackage.Save();

                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage ExportMovieAlbumMusicList(MHRequest objMHRequest)
        {
            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "").Trim();
            objMHRequest.UsersCode = Convert.ToInt32(UserCode);
            List<USPMHMovieAlbumMusicList> lstMovieAlbumMusicList = new List<USPMHMovieAlbumMusicList>();
            Return _objRet = new Return();
            try
            {
                lstMovieAlbumMusicList = (List<USPMHMovieAlbumMusicList>)obj.GetMovieAlbumMusicList(objMHRequest);
                HttpResponseMessage response;
                response = Request.CreateResponse(HttpStatusCode.OK);
                MediaTypeHeaderValue mediaType = new MediaTypeHeaderValue("application/octet-stream");

                var movieAlbumMusicList = lstMovieAlbumMusicList;
                string Destination = objMHRequest.MHRequestTypeCode == 2 ? HttpContext.Current.Server.MapPath("~/") + "Temp\\MusicTrackList.xlsx" : HttpContext.Current.Server.MapPath("~/") + "Temp\\MovieAlbumList.xlsx";
                FileInfo OldFile = new FileInfo(HttpContext.Current.Server.MapPath("~/") + "Temp\\Sample1.xlsx");
                FileInfo newFile = new FileInfo(Destination);
                string Name = newFile.Name.ToString();
                if (newFile.Exists)
                {
                    newFile.Delete(); // ensures we create a new workbook
                    newFile = new FileInfo(Destination);
                }
                _objRet.Message = newFile.Name;
                var excelPackage = new ExcelPackage(newFile, OldFile);
                var sheet = excelPackage.Workbook.Worksheets["Sheet1"];
                sheet.Name = "Studio";


                sheet.Cells[1, 1].Value = "Request #";
                sheet.Cells[1, 2].Value = objMHRequest.MHRequestTypeCode == 2 ? "No. Of Songs" : "No. of Movie/Album";
                sheet.Cells[1, 3].Value = "Requested By";
                sheet.Cells[1, 4].Value = "Requested Date";
                sheet.Cells[1, 5].Value = "Status";

                for (int i = 1; i <= 5; i++)
                {
                    Color colFromHex = System.Drawing.ColorTranslator.FromHtml("#C0C0C0");
                    sheet.Cells[1, i].Style.Font.Bold = true;
                    sheet.Cells[1, i].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    sheet.Cells[1, i].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                    sheet.Cells[1, i].Style.Font.Size = 11;
                    sheet.Cells[1, i].Style.Font.Name = "Calibri";
                    sheet.Cells[1, i].Style.Fill.PatternType = ExcelFillStyle.Solid;
                    sheet.Cells[1, i].Style.Fill.BackgroundColor.SetColor(colFromHex);
                    sheet.Cells[1, i].AutoFitColumns();

                }

                ExcelColumn col1 = sheet.Column(1);
                ExcelColumn col2 = sheet.Column(2);
                ExcelColumn col3 = sheet.Column(3);
                ExcelColumn col4 = sheet.Column(4);
                ExcelColumn col5 = sheet.Column(5);

                col1.Width = 25;
                col2.Width = 16;
                col3.Width = 20;
                col4.Width = 20;
                col5.Width = 20;


                for (int i = 0; i < movieAlbumMusicList.Count; i++)
                {
                    DateTime dt = Convert.ToDateTime(movieAlbumMusicList[i].RequestDate.ToString());
                    string RequestedDate = dt.ToString("dd-MMM-yyyy h:mm tt");

                    sheet.Cells["A" + (i + 2)].Value = movieAlbumMusicList[i].RequestID;
                    sheet.Cells["B" + (i + 2)].Value = movieAlbumMusicList[i].CountRequest;
                    sheet.Cells["C" + (i + 2)].Value = movieAlbumMusicList[i].RequestedBy;
                    sheet.Cells["D" + (i + 2)].Value = RequestedDate;
                    sheet.Cells["E" + (i + 2)].Value = movieAlbumMusicList[i].Status;
                    sheet.Cells["A" + (i + 2)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                    sheet.Cells["A" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["B" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["C" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["D" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["E" + (i + 2)].Style.Font.Name = "Calibri";

                    sheet.Cells["B" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                }

                excelPackage.Workbook.Properties.Title = "PlanIT";
                excelPackage.Workbook.Properties.Author = "";
                excelPackage.Workbook.Properties.Comments = "";

                // set some extended property values
                excelPackage.Workbook.Properties.Company = "";

                // set some custom property values
                excelPackage.Workbook.Properties.SetCustomPropertyValue("Checked by", "");
                excelPackage.Workbook.Properties.SetCustomPropertyValue("AssemblyName", "EPPlus");
                // save our new workbook and we are done!
                excelPackage.Save();

                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);

            }

        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetTalents(TalentInput objTalentInput)
        {
            IEnumerable<USPMHGetTalents> lstUSPMHGetTalents = new List<USPMHGetTalents>();
            Return _objRet = new Return();
            try
            {
                lstUSPMHGetTalents = obj.GetTalents(objTalentInput.RoleCode, objTalentInput.strSearch).ToList();
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, Talents = lstUSPMHGetTalents }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);

            }

        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetMusicSongType()
        {
            Return _objRet = new Return();
            try
            {
                string strSearch = "Select MHMusicSongTypeCode,SongType from MHMusicSongType Where IsActive = 'Y'";
                var lstSongType = obj.GetMusicSongType(strSearch);
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, SongType = lstSongType }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage CheckPlayList(MHPlayList objMHPlayList)
        {
            int ChannelCode = 0;
            IEnumerable<MHPlayList> lstPlayList = new List<MHPlayList>();
            Return _objRet = new Return();

            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "").Trim();

            var objU = new
            {
                Users_Code = Convert.ToInt32(UserCode),
            };
            MHUsers objUser = objMHUsersServices.SearchFor(objU).FirstOrDefault();

            var objParam = new
            {
                TitleCode = objMHPlayList.TitleCode,
                VendorCode = objUser.Vendor_Code
            };
           
            try
            {
                lstPlayList = obj.SearchPlayList(objParam).ToList();
                //int searchCount = lstPlayList.Count();
                if (lstPlayList.Count() == 0) {
                    string strSearch = "Select top 1 ChannelCode from MHRequest Where TitleCode = " + objMHPlayList.TitleCode + " AND VendorCode = "+objUser.Vendor_Code+" AND MHRequestTypeCode = 1 order by 1 desc";
                    ChannelCode = obj.GetChannelCode(strSearch,objMHPlayList.TitleCode);
                    _objRet.Message = "Play List not found.";
                    _objRet.IsSuccess = false;
                }
                else
                {
                  
                    _objRet.Message = "Play List found.";
                    _objRet.IsSuccess = true;
                }
                
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet,ChannelCode = ChannelCode}, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);

            }

        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetMusicLanguage()
        {
            Return _objRet = new Return();
            try
            {
                string strSearch = "AND Is_active = 'Y'";
                var lstMusicLanguage = obj.GetMusicLanguageList(strSearch);/*.Select(x=> new { x.Genres_Code,x.Genres_Name});*/
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, MusicLanguage = lstMusicLanguage }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetNotificationHeader(MHRequest objMHRequest)
        {
            Return _objRet = new Return();
            string UsersCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UsersCode = UsersCode.Replace("Bearer ", "");
            int RecordCount = 0;
            string Header = "";

           
            objMHRequest.UsersCode = Convert.ToInt32(UsersCode);
            // objMHRequest.UsersCode = Convert.ToInt32(UserCode);
            IEnumerable<USPMHConsumptionRequestList> lstConsumptionRequest = new List<USPMHConsumptionRequestList>();

            try
            {
                if(objMHRequest.MHRequestTypeCode == 1)
                {
                    ConsumptionRequestListInput objConsumptionRequestList = new ConsumptionRequestListInput()
                    {
                        RecordFor = "L",
                        PagingRequired = "Y",
                        PageSize = 10,
                        PageNo = 1,
                        RequestID = "",
                        ChannelCode = "",
                        ShowCode = "",
                        StatusCode = "",
                        FromDate = "",
                        ToDate = ""
                    };
                    lstConsumptionRequest = obj.GetConsumptionRequestList(objMHRequest, objConsumptionRequestList, out RecordCount);
                    Header = lstConsumptionRequest.Where(x => x.RequestCode == objMHRequest.MHRequestCode).Select(x =>
                                "Details: " + x.RequestID + " / " + x.ChannelName + " / " + x.Title_Name + " ( " + x.EpisodeFrom + " )").FirstOrDefault().ToString();
                }
                else if (objMHRequest.MHRequestTypeCode == 2)
                {
                     Header = "Music Detail for : "+ obj.GetMHRequest(Convert.ToInt32(objMHRequest.MHRequestCode)).RequestID.ToString();
                }
                else
                {
                    Header = "Movie / Album Detail for : " + obj.GetMHRequest(Convert.ToInt32(objMHRequest.MHRequestCode)).RequestID.ToString();
                }
              
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new
                {
                    Return = _objRet,
                    Header = Header
                }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }
    }

    public class MusicAlbum
    {
        public string MusicAlbumName { get; set; }
    }

    public class MusicLabelInput
    {
        public int ChannelCode { get; set; }
        public int TitleCode { get; set; }
    }

    public class TalentInput
    {
        public int RoleCode { get; set; }
        public string strSearch { get; set; }
    }

    public class RequestDetailsInput
    {
        public string MHRequestCode { get; set; }
        public int MHRequestTypeCode { get; set; }
        public string IsCueSheet { get; set; }
    }

    //public class ConsumptionRequestList
    //{
    //    public string RecordFor { get; set; }
    //    public string PagingRequired { get; set; }
    //    public int PageSize { get; set; }
    //    public int PageNo { get; set; }
    //    public string RequestID { get; set; } 
    //    public int ChannelCode { get; set; }
    //    public int ShowCode { get; set; }
    //    public int StatusCode { get; set; }
    //    public string FromDate { get; set; }
    //}

    //Committed by Rahul AND Aditya 
    //This is comment is purposely written
    
}
