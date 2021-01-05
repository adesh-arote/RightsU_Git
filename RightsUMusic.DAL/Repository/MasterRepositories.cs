using Dapper;
using RightsUMusic.DAL.Infrastructure;
using RightsUMusic.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.DAL.Repository
{
    #region -------- User -----------
    public class UserRepositories : MainRepository<User>
    {
        public User Get(int Id)
        {
            var obj = new { Users_Code = Id };

            return base.GetById<User, Users_Password_Detail>(obj);
        }
        public IEnumerable<User> GetAll()
        {
            return base.GetAll<User>();
        }
        public void Update(User entity)
        {
            User oldObj = Get(entity.Users_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public IEnumerable<User> SearchFor(object param)
        {
            return base.SearchForEntity<User, Users_Password_Detail>(param);
        }

        public IEnumerable<User> GetDataWithSQLStmt(string strSQL)
        {
            //string strSQL = "Select Genres_Code,Genres_Name From Genres Where 1 = 1 " + strSearch;
            return base.ExecuteSQLStmt<User>(strSQL);
        }
    }
    #endregion

    #region -------- Users_Password_Detail -----------
    public class Users_Password_DetailRepositories : MainRepository<Users_Password_Detail>
    {
        public void Add(Users_Password_Detail entity)
        {
            base.AddEntity(entity);
        }
        public Users_Password_Detail Get(int Id)
        {
            var obj = new { Users_Password_Detail_Code = Id };

            return base.GetById<Users_Password_Detail>(obj);
        }
        public IEnumerable<Users_Password_Detail> GetAll()
        {
            return base.GetAll<Users_Password_Detail>();
        }
        public void Update(Users_Password_Detail entity)
        {
            Users_Password_Detail oldObj = Get(entity.Users_Password_Detail_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public IEnumerable<Users_Password_Detail> SearchFor(object param)
        {
            return base.SearchForEntity<Users_Password_Detail>(param);
        }

        public IEnumerable<Users_Password_Detail> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Users_Password_Detail>(strSQL);
        }
    }
    #endregion

    #region -------- Login Details -----------
    public class Login_DetailsRepositories : MainRepository<Login_Details>
    {
        public void Add(Login_Details entity)
        {
            base.AddEntity(entity);
        }
        public Login_Details Get(int Id)
        {

            var obj = new { Login_Details_Code = Id };

            return base.GetById<Login_Details>(obj);
        }
        public IEnumerable<Login_Details> GetAll()
        {
            return base.GetAll<Login_Details>();
        }
        public IEnumerable<Login_Details> SearchFor(object param)
        {
            return base.SearchForEntity<Login_Details>(param);
        }
        public void Update(Login_Details entity)
        {
            Login_Details oldObj = Get(entity.Login_Details_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
    }
    #endregion

    #region -------- System Parameter -----------
    public class SystemParametersRepositories : MainRepository<MHSystemParameter>
    {
        public IEnumerable<MHSystemParameter> SearchFor(object param)
        {
            return base.SearchForEntity<MHSystemParameter>(param);
        }
        public IEnumerable<MHSystemParameter> GetAll()
        {
            return base.GetAll<MHSystemParameter>();
        }
    }
    #endregion

    #region -------- Logged In Users  -----------
    public class LoggedInUsersRepository : MainRepository<LoggedInUsers>
    {
        public LoggedInUsers Get(int Id)
        {
            var obj = new { Users_Code = Id };

            return base.GetById<LoggedInUsers>(obj);
        }
        public void Add(LoggedInUsers entity)
        {
            base.AddEntity(entity);
        }
        public void Update(LoggedInUsers entity)
        {
            LoggedInUsers oldObj = Get(entity.LoggedInUsersCode ?? 0);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(LoggedInUsers entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<LoggedInUsers> GetAll()
        {
            return base.GetAll<LoggedInUsers>();
        }
        public IEnumerable<LoggedInUsers> SearchFor(object param)
        {
            return base.SearchForEntity<LoggedInUsers>(param);
        }
    }
    #endregion

    #region----------Music_Label-----------------
    public class MusicLabelRepositories : MainRepository<Music_Label>
    {
        public IEnumerable<Music_Label> GetAll()
        {
            return base.GetAll<Music_Label>();
        }
        public IEnumerable<Music_Label> GetDataWithSQLStmt(string strSQL)
        {
            //string strSQL = "Select Genres_Code,Genres_Name From Genres Where 1 = 1 " + strSearch;
            return base.ExecuteSQLStmt<Music_Label>(strSQL);
        }
    }
    #endregion

    #region----------Genres-----------------
    public class GenreRepositories : MainRepository<Genre>
    {
        public IEnumerable<Genre> GetAll()
        {
            return base.GetAll<Genre>();
        }
        public IEnumerable<Genre> GetDataWithSQLStmt(string strSQL)
        {
            //string strSQL = "Select Genres_Code,Genres_Name From Genres Where 1 = 1 " + strSearch;
            return base.ExecuteSQLStmt<Genre>(strSQL);
        }

    }
    #endregion

    #region----------Music Album-----------------
    public class Music_AlbumRepositories : MainRepository<Music_Album>
    {
        public IEnumerable<Music_Album> GetAll()
        {
            return base.GetAll<Music_Album>();
        }
        public IEnumerable<Music_Album> GetDataWithSQLStmt(string strSQL)
        {
            //string strSQL = "Select Genres_Code,Genres_Name From Genres Where 1 = 1 " + strSearch;
            return base.ExecuteSQLStmt<Music_Album>(strSQL);
        }

    }
    #endregion

    #region----------Channel-----------------
    public class ChannelRepositories : MainRepository<Channel>
    {
        public IEnumerable<Channel> GetAll()
        {
            return base.GetAll<Channel>();
        }
        public IEnumerable<Channel> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Channel>(strSQL);
        }

    }
    #endregion

    #region----------Vendor-----------------
    public class VendorRepositories : MainRepository<Vendor>
    {
        public Vendor Get(int Id)
        {
            var obj = new { Vendor_Code = Id };

            return base.GetById<Vendor>(obj);
        }

    }
    #endregion

    #region------------------MH Request-------------

    public class MHRequestRepositories : MainRepository<MHRequest>
    {
        public MHRequest Get(int Id)
        {
            var obj = new { MHRequestCode = Id };

            return base.GetById<MHRequest>(obj);
        }
        public void Add(MHRequest entity)
        {
            base.AddEntity(entity);
        }
        public void Update(MHRequest entity)
        {
            MHRequest oldObj = Get((int)entity.MHRequestCode);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(MHRequest entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<MHRequest> GetAll()
        {
            return base.GetAll<MHRequest>();
        }
        public IEnumerable<MHRequest> SearchFor(object param)
        {
            return base.SearchForEntity<MHRequest>(param);
        }

        public IEnumerable<MHRequest> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<MHRequest>(strSQL);
        }

    }
    #endregion

    #region------------------MH Request Details-------------
    public class MHRequestDetailsRepositories : MainRepository<MHRequestDetail>
    {
        public MHRequestDetail Get(int Id)
        {
            var obj = new { MHRequestCode = Id };

            return base.GetById<MHRequestDetail>(obj);
        }
        public void Add(MHRequestDetail entity)
        {
            base.AddEntity(entity);
        }
        public void Update(MHRequestDetail entity)
        {
            MHRequestDetail oldObj = Get((int)entity.MHRequestDetailsCode);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(MHRequestDetail entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<MHRequestDetail> GetAll()
        {
            return base.GetAll<MHRequestDetail>();
        }
        public IEnumerable<MHRequestDetail> SearchFor(object param)
        {
            return base.SearchForEntity<MHRequestDetail>(param);
        }

    }
    #endregion

    #region--------------------------MHUsers----------------
    public class MHUsersRepositories : MainRepository<MHUsers>
    {
        public IEnumerable<MHUsers> SearchFor(object param)
        {
            return base.SearchForEntity<MHUsers>(param);
        }
    }
    #endregion

    #region--------------------------MH Cue Sheet----------------
    public class CueSheetRepositories : MainRepository<MHCueSheet>
    {
        public MHCueSheet Get(int Id)
        {
            var obj = new { MHCueSheetCode = Id };

            return base.GetById<MHCueSheet>(obj);
        }
        public void Add(MHCueSheet entity)
        {
            base.AddEntity(entity);
        }

        public string GetDataWithSQLStmt(DataTable dt,int CueSheetCode,string fileWithTimeStamp,int UsersCode,out int _CueSheetCodeOut)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@udt", dt.AsTableValuedParameter());
            parameters.Add("@CueSheetCode", CueSheetCode);
            parameters.Add("@FileName", fileWithTimeStamp);
            parameters.Add("@UsersCode",UsersCode);
            parameters.Add("@CueSheetCodeOut", dbType: DbType.Int32, direction: ParameterDirection.Output);
            var query = "USPMHSaveCueSheetSongs";
            base.ExecuteSQLProcedure<CueSheetSongsUDT>(query, parameters);
            _CueSheetCodeOut = parameters.Get<int>("@CueSheetCodeOut");
            return "CueSheet Upload Success";
            //base.ExecuteScalar(query, parameters);

        }

        public IEnumerable<MHCueSheet> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<MHCueSheet>(strSQL);
        }

        public void Update(MHCueSheet objMHCueSheet)
        {
            MHCueSheet oldObj = Get(Convert.ToInt32(objMHCueSheet.MHCueSheetCode));
            base.UpdateEntity(oldObj, objMHCueSheet);
        }

    }
    #endregion

    #region--------------------------MH Play List----------------
    public class MHPlayListRepositories : MainRepository<MHPlayList>
    {
        public void Add(MHPlayList entity)
        {
            base.AddEntity(entity);
        }
        public IEnumerable<MHPlayList> SearchFor(object param)
        {
            return base.SearchForEntity<MHPlayList,MHPlayListSong>(param);
        }

        public IEnumerable<MHPlayList> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<MHPlayList>(strSQL);
        }
    }
    #endregion

    #region--------------------------MH Play List Songs----------------
    public class MHPlayListSongRepositories : MainRepository<MHPlayListSong>
    {
        public void Add(MHPlayListSong entity)
        {
            base.AddEntity(entity);
        }

        public IEnumerable<MHPlayListSong> SearchFor(object param)
        {
            return base.SearchForEntity<MHPlayListSong>(param);
        }
    }
    #endregion

    #region--------------------------MH NotificationLog----------------
    public class MHNotificationLogRepositories : MainRepository<MHNotificationLog>
    {
        public MHNotificationLog Get(int Id)
        {
            var obj = new { MHNotificationLogCode = Id };

            return base.GetById<MHNotificationLog>(obj);
        }
        public void Add(MHNotificationLog entity)
        {
            base.AddEntity(entity);
        }

        public MHNotificationLog Update(MHNotificationLog objMHNotificationLog)
        {
            MHNotificationLog oldObj = Get(Convert.ToInt32(objMHNotificationLog.MHNotificationLogCode));
            base.UpdateEntity(oldObj, objMHNotificationLog);
            return objMHNotificationLog;
        }

    }
    #endregion

    #region----------MHMusicSongType-----------------
    public class MHMusicSongTypeRepositories : MainRepository<MHMusicSongType>
    {
        public IEnumerable<MHMusicSongType> GetAll()
        {
            return base.GetAll<MHMusicSongType>();
        }
        public IEnumerable<MHMusicSongType> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<MHMusicSongType>(strSQL);
        }

    }
    #endregion

    #region----------Music Language-----------------
    public class Music_LanguageRepositories : MainRepository<Music_Language>
    {
        public IEnumerable<Music_Language> GetAll()
        {
            return base.GetAll<Music_Language>();
        }
        public IEnumerable<Music_Language> GetDataWithSQLStmt(string strSQL)
        {
            //string strSQL = "Select Genres_Code,Genres_Name From Genres Where 1 = 1 " + strSearch;
            return base.ExecuteSQLStmt<Music_Language>(strSQL);
        }

    }
    #endregion
    #region------USP---------------
    public class USPMHShowNameListRepositories : MainRepository<USPMHShowNameList>
    {
        public IEnumerable<USPMHShowNameList> ShowNameList(int UsersCode,int ChannelCode)
        {
            var param = new DynamicParameters();
            param.Add("@UsersCode", UsersCode);
            param.Add("@ChannelCode", ChannelCode);
            return base.ExecuteSQLProcedure<USPMHShowNameList>("USPMHShowNameList", param);
        }
    }

    public class USPMHSearchMusicTrackRepositories : MainRepository<USPMHSearchMusicTrack>
    {
      
        public IEnumerable<USPMHSearchMusicTrack> ShowMusicTrakList(MusicTrackInput objMusicTrackInput , out int _RecordCount)
        {
            var param = new DynamicParameters();
            param.Add("@MusicLabelCode", objMusicTrackInput.MusicLabelCode);
            param.Add("@MusicTrack", objMusicTrackInput.MusicTrack);
            param.Add("@MovieName", objMusicTrackInput.MovieName);
            param.Add("@GenreCode", objMusicTrackInput.GenreCode);
            param.Add("@TalentName", objMusicTrackInput.TalentName);
            param.Add("@Tag", objMusicTrackInput.Tag);
            param.Add("@MHPlayListCode", objMusicTrackInput.MHPlayListCode);
            param.Add("@PagingRequired", objMusicTrackInput.PagingRequired);
            param.Add("@PageSize", objMusicTrackInput.PageSize);
            param.Add("@PageNo", objMusicTrackInput.PageNo);
            param.Add("@ChannelCode", objMusicTrackInput.ChannelCode);
            param.Add("@TitleCode", objMusicTrackInput.TitleCode);
            param.Add("@MusicLanguageCode", objMusicTrackInput.MusicLanguageCode);
            param.Add("@RecordCount", dbType: DbType.Int32, direction: ParameterDirection.Output);
            IEnumerable<USPMHSearchMusicTrack> lstUSPMHSearchMusicTrack = base.ExecuteSQLProcedure<USPMHSearchMusicTrack>("USPMHSearchMusicTrack", param);
            _RecordCount = param.Get<int>("@RecordCount");
            return lstUSPMHSearchMusicTrack;
        }
    }

    public class USPMHConsumptionRequestRepositories : MainRepository<USPMHConsumptionRequestList>
    {
        public IEnumerable<USPMHConsumptionRequestList> GetConsumptionRequestList(MHRequest objMHRequest, ConsumptionRequestListInput objConsumptionRequestList, out int _RecordCount)//,string RecordFor, string PagingRequired, int PageSize, int PageNo, out int _RecordCount)
        {
            var param = new DynamicParameters();
            param.Add("@RequestTypeCode", objMHRequest.MHRequestTypeCode);
            param.Add("@UsersCode", objMHRequest.UsersCode);
            param.Add("@RecordFor", objConsumptionRequestList.RecordFor);
            param.Add("@PagingRequired", objConsumptionRequestList.PagingRequired);
            param.Add("@PageSize", objConsumptionRequestList.PageSize);
            param.Add("@PageNo", objConsumptionRequestList.PageNo);
            param.Add("@RecordCount", dbType: DbType.Int32, direction: ParameterDirection.Output);
            param.Add("@RequestID", objConsumptionRequestList.RequestID);
            param.Add("@ChannelCode", objConsumptionRequestList.ChannelCode);
            param.Add("@ShowCode", objConsumptionRequestList.ShowCode);
            param.Add("@StatusCode", objConsumptionRequestList.StatusCode);
            param.Add("@FromDate", objConsumptionRequestList.FromDate.ToString());
            param.Add("@ToDate", objConsumptionRequestList.ToDate.ToString());
            IEnumerable<USPMHConsumptionRequestList> lstUSPMHConsumptionRequestList = base.ExecuteSQLProcedure<USPMHConsumptionRequestList>("USPMHConsumptionRequestList", param);
            _RecordCount = param.Get<int>("@RecordCount");
            return lstUSPMHConsumptionRequestList;
        }
    }

    public class USPMHMovieAlbumMusicListRepositories : MainRepository<USPMHMovieAlbumMusicList>
    {
        public IEnumerable<USPMHMovieAlbumMusicList> GetMovieAlbumMusicList(MHRequest objMHRequest)
        {
            var param = new DynamicParameters();
            param.Add("@RequestTypeCode", objMHRequest.MHRequestTypeCode);
            param.Add("@UsersCode", objMHRequest.UsersCode);
            return base.ExecuteSQLProcedure<USPMHMovieAlbumMusicList>("USPMHMovieAlbumMusicList", param);
        }
    }

    public class ConsumptionRequestDetailsRepositories : MainRepository<ConsumptionRequestDetails>
    {
        public IEnumerable<ConsumptionRequestDetails> GetConsumptionRequestDetails(string MHRequestCode, int MHRequestTypeCode,char IsCueSheet)
        {
            var param = new DynamicParameters();
            param.Add("@RequestCode", MHRequestCode);
            param.Add("@RequestTypeCode",MHRequestTypeCode);
            param.Add("@IsCueSheet",IsCueSheet);
            return base.ExecuteSQLProcedure<ConsumptionRequestDetails>("USPMHGetRequestDetails", param);
        }
    }

    public class MusicTrackRequestDetailsRepositories : MainRepository<MusicTrackRequestDetails>
    {
        public IEnumerable<MusicTrackRequestDetails> GetMusicTrackRequestDetails(MHRequest objMHRequest)
        {
            var param = new DynamicParameters();
            param.Add("@RequestCode", objMHRequest.MHRequestCode.ToString());
            param.Add("@RequestTypeCode", objMHRequest.MHRequestTypeCode);
            return base.ExecuteSQLProcedure<MusicTrackRequestDetails>("USPMHGetRequestDetails", param);
        }
    }

    public class MovieAlbumRequestDetailsRepositories : MainRepository<MovieAlbumRequestDetails>
    {
        public IEnumerable<MovieAlbumRequestDetails> GetMovieAlbumRequestDetails(MHRequest objMHRequest)
        {
            var param = new DynamicParameters();
            param.Add("@RequestCode", objMHRequest.MHRequestCode.ToString());
            param.Add("@RequestTypeCode", objMHRequest.MHRequestTypeCode);
            return base.ExecuteSQLProcedure<MovieAlbumRequestDetails>("USPMHGetRequestDetails", param);
        }
    }

    public class USPMHGetRequestIDRepositories : MainRepository<string>
    {
        public string GetRequestID(int VendorCode,string requestType)
        {
            var param = new DynamicParameters();
            param.Add("@VendorCode", VendorCode);
            param.Add("@RequestType", requestType);
            return base.ExecuteScalar("USPMHGetRequestID", param);
        }
    }

    public class USPMHGetCueSheetListRepositories : MainRepository<USPMHGetCueSheetList>
    {
        public IEnumerable<USPMHGetCueSheetList> GetCueSheetList(int UsersCode, CueSheetListInput objCueSheetListInput,out int _RecordCount)
        {
            var param = new DynamicParameters();
            param.Add("@MHCueSheetCode", objCueSheetListInput.MHCueSheetCode);
            param.Add("@UsersCode", UsersCode);
            param.Add("@PagingRequired", objCueSheetListInput.PagingRequired);
            param.Add("@PageSize", objCueSheetListInput.PageSize);
            param.Add("@PageNo", objCueSheetListInput.PageNo);
            param.Add("@StatusCode", objCueSheetListInput.StatusCode);
            param.Add("@FromDate", objCueSheetListInput.FromDate);
            param.Add("@ToDate", objCueSheetListInput.ToDate);
            param.Add("@RecordCount", dbType: DbType.Int32, direction: ParameterDirection.Output);
            IEnumerable <USPMHGetCueSheetList> lstUSPMHGetCueSheetList = base.ExecuteSQLProcedure<USPMHGetCueSheetList>("USPMHGetCueSheetList", param);
            _RecordCount = param.Get<int>("@RecordCount");
            return lstUSPMHGetCueSheetList;
        }
    }

    public class USPMHGetCueSheetSongDetailsRepositories : MainRepository<USPMHGetCueSheetSongDetails>
    {
        public IEnumerable<USPMHGetCueSheetSongDetails> GetCueSheetSongDetails(CueSheetDetailInput objCueSheetDetailInput)
        {
            var param = new DynamicParameters();
            param.Add("@CueSheetCode", objCueSheetDetailInput.MHCueSheetCode);
            param.Add("@ViewOn", objCueSheetDetailInput.ViewOn);
            return base.ExecuteSQLProcedure<USPMHGetCueSheetSongDetails>("USPMHGetCueSheetSongDetails", param);
        }
    }

    public class USPMHGetTitleEpisodeRepositories : MainRepository<USPMHGetTitleEpisode>
    {
        public IEnumerable<USPMHGetTitleEpisode> GetTitleEpisode(Title objTitle)
        {
            var param = new DynamicParameters();
            param.Add("@TitleCode", objTitle.Title_Code);
            return base.ExecuteSQLProcedure<USPMHGetTitleEpisode>("USPMHGetTitleEpisode", param);
        }
    }

    public class USPMHGetPieChartDataRepositories : MainRepository<USPMHGetPieChartData>
    {
        public IEnumerable<USPMHGetPieChartData> GetPieChartData(int UsersCode,int NoOfMonths)
        {
            var param = new DynamicParameters();
            param.Add("@UsersCode", UsersCode);
            param.Add("@NoOfMonths", NoOfMonths);
            return base.ExecuteSQLProcedure<USPMHGetPieChartData>("USPMHGetPieChartData", param);
        }
    }

    public class USPMHGetBarChartDataRepositories : MainRepository<USPMHGetBarChartData>
    {
        public IEnumerable<USPMHGetBarChartData> GetBarChartData(int UsersCode,int NoOfMonths)
        {
            var param = new DynamicParameters();
            param.Add("@UsersCode", UsersCode);
            param.Add("@NoOfMonths", NoOfMonths);
            return base.ExecuteSQLProcedure<USPMHGetBarChartData>("USPMHGetBarChartData", param);
        }
    }

    public class USPMHGetLabelWiseUsageRepositories : MainRepository<USPMHGetLabelWiseUsage>
    {
        public IEnumerable<USPMHGetLabelWiseUsage> GetLabelWiseUsage(int UsersCode,string LabelName,string ShowName,int NoOfMonths)
        {
            var param = new DynamicParameters();
            param.Add("@UsersCode", UsersCode);
            param.Add("@LabelName", LabelName);
            param.Add("@ShowName", ShowName);
            param.Add("@NoOfMonths", NoOfMonths);
            return base.ExecuteSQLProcedure<USPMHGetLabelWiseUsage>("USPMHGetLabelWiseUsage", param);
        }
    }

    public class USPMHGetMenuRepositories : MainRepository<USPMHGetMenu>
    {
        public IEnumerable<USPMHGetMenu> GetMenu(int SecurtyGroupCode)
        {
            var param = new DynamicParameters();
            param.Add("@SecurityGroupCode", SecurtyGroupCode);
            return base.ExecuteSQLProcedure<USPMHGetMenu>("USPMHGetMenu", param);
        }
    }

    public class USPMHGetModuleRightsRepositories : MainRepository<string>
    {
        public string GetModuleRights(int ModuleCode,int SecurtyGroupCode)
        {
            var param = new DynamicParameters();
            param.Add("@ModuleCode", ModuleCode);
            param.Add("@SecurityGroupCode", SecurtyGroupCode);
            return base.ExecuteScalar("USPMHGetModuleRights", param);
        }
    }

    public class USPMHGetMusicLabelRepositories : MainRepository<USPMHGetMusicLabel>
    {
        public IEnumerable<USPMHGetMusicLabel> GetMusicLabel(int ChannelCode,int TitleCode)
        {
            var param = new DynamicParameters();
            param.Add("@ChannelCode", ChannelCode);
            param.Add("@TitleCode", TitleCode);
            return base.ExecuteSQLProcedure<USPMHGetMusicLabel>("USPMHGetMusicLabel", param);
        }
    }

    public class USPValidateMHRequestConsumptionRepositories : MainRepository<USPValidateMHRequestConsumption>
    {
        public IEnumerable<USPValidateMHRequestConsumption> ValidateConsumptionRequest(MHRequest objMHRequest)
        {
            var param = new DynamicParameters();
            param.Add("@MHRequestCode", objMHRequest.MHRequestCode);
            return base.ExecuteSQLProcedure<USPValidateMHRequestConsumption>("USPValidateMHRequestConsumption", param);
        }
    }

    public class USPMHNotificationListRepositories : MainRepository<USPMHNotificationList>
    {
        public IEnumerable<USPMHNotificationList> GetNotificationList(string RecordFor, int UserCode, out int _RecordCount)
        {
            var param = new DynamicParameters();
            param.Add("@UsersCode", UserCode);
            param.Add("@RecordFor", RecordFor);
            param.Add("@UnReadCount", dbType: DbType.Int32, direction: ParameterDirection.Output);
            IEnumerable<USPMHNotificationList> lstUSPMHNotificationList = base.ExecuteSQLProcedure<USPMHNotificationList>("USPMHNotificationList", param);
            _RecordCount = param.Get<int>("@UnReadCount");
            return lstUSPMHNotificationList;
        }
    }

    public class USPMHNotificationMailRepositories : MainRepository<string>
    {
        public string SendForApproval(MHRequest objMHRequest,int UserCode)
        {
            var param = new DynamicParameters();
            param.Add("@MHRequestCode", objMHRequest.MHRequestCode);
            param.Add("@MHRequestTypeCode", objMHRequest.MHRequestTypeCode);
            param.Add("@UsersCode", UserCode);
            base.ExecuteScalar("USPMHNotificationMail", param);
            return "Mail sent successfully";
        }
    }

    public class USPMHNotificationMailForCueSheetRepositories : MainRepository<dynamic>
    {
        public void SendCueSheetForApproval(MHCueSheet objMHCueSheet,int UsersCode)
        {
            var param = new DynamicParameters();
            param.Add("@MHCueSheetCode", objMHCueSheet.MHCueSheetCode);
            param.Add("@UsersCode", UsersCode);
            base.ExecuteSQLProcedure<dynamic>("USPMHNotificationMailForCueSheet", param);
        }
    }

    public class USPMHAutoApproveUsageRequestRepositories : MainRepository<dynamic>
    {
        public void AutoApproveUsageRequest(MHRequest objMHRequest, int UsersCode)
        {
            var param = new DynamicParameters();
            param.Add("@MHRequestCode", objMHRequest.MHRequestCode);
            param.Add("@UserCode", UsersCode);
            base.ExecuteSQLProcedure<dynamic>("USPMHAutoApproveUsageRequest", param);
        }
    }

    public class USPMHGetTalentsRepositories : MainRepository<USPMHGetTalents>
    {
        public IEnumerable<USPMHGetTalents> GetTalents(int RoleCode,string strSearch)
        {
            var param = new DynamicParameters();
            param.Add("@RoleCode", RoleCode );
            param.Add("@StrSearch", strSearch);
            IEnumerable<USPMHGetTalents> lstUSPMHGetTalents = base.ExecuteSQLProcedure<USPMHGetTalents>("USPMHGetTalents", param);
            return lstUSPMHGetTalents;
        }
    }

    public class USPMHForgotPasswordRepositories : MainRepository<dynamic>
    {
        public void SendNewPassword(User objUser,string newPassword)
        {
            var param = new DynamicParameters();
            param.Add("@LoginName", objUser.Login_Name);
            param.Add("@EmailID", objUser.Email_Id);
            param.Add("@Password", newPassword);
            base.ExecuteSQLProcedure<dynamic>("USPMHForgotPassword", param);
        }
    }

    public class USPMHGetChannelFromDealRepositories : MainRepository<string>
    {
        public string GetGetChannelFromAcqDeal(int titleCode)
        {
            var param = new DynamicParameters();
            param.Add("@TitleCode", titleCode);
            return base.ExecuteScalar("USPMHGetChannelFromDeal", param);
        }
    }

    #endregion
    #region



    #endregion
}