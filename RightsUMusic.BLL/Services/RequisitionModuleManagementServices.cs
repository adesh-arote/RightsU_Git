using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RightsUMusic.DAL.Repository;
using RightsUMusic.Entity;

namespace RightsUMusic.BLL.Services
{
    public class RequisitionModuleManagementServices
    {
        private readonly USPMHShowNameListRepositories objUSPMHShowNameListRepositories = new USPMHShowNameListRepositories();
        private readonly MusicLabelRepositories objMusicLabelRepositories = new MusicLabelRepositories();
        private readonly GenreRepositories objGenreRepositories = new GenreRepositories();
        private readonly USPMHSearchMusicTrackRepositories objUSPMHSearchMusicTrackRepositories = new USPMHSearchMusicTrackRepositories();
        private readonly MHRequestRepositories objMHRequestRepositories = new MHRequestRepositories();
        private readonly MHRequestDetailsRepositories objMHRequestDetailsRepositories = new MHRequestDetailsRepositories();
        private readonly Music_AlbumRepositories objMusic_AlbumRepositories = new Music_AlbumRepositories();
        private readonly USPMHConsumptionRequestRepositories objUSPMHConsumptionRequestRepositories = new USPMHConsumptionRequestRepositories();
        private readonly USPMHMovieAlbumMusicListRepositories objUSPMHMovieAlbumMusicListRepositories = new USPMHMovieAlbumMusicListRepositories();
        private readonly ConsumptionRequestDetailsRepositories objConsumptionRequestDetailsRepositories = new ConsumptionRequestDetailsRepositories();
        private readonly MusicTrackRequestDetailsRepositories objMusicTrackRequestDetailsRepositories = new MusicTrackRequestDetailsRepositories();
        private readonly MovieAlbumRequestDetailsRepositories objMovieAlbumRequestDetailsRepositories = new MovieAlbumRequestDetailsRepositories();
        private readonly MHUsersServices objMHUsersServices = new MHUsersServices();
        private readonly USPMHGetRequestIDRepositories objUSPMHGetRequestIDRepositories = new USPMHGetRequestIDRepositories();
        private readonly ChannelRepositories objChannelRepositories = new ChannelRepositories();
        private readonly MHPlayListRepositories objMHPlayListRepositories = new MHPlayListRepositories();
        private readonly MHPlayListSongRepositories objMHPlayListSongRepositories = new MHPlayListSongRepositories();
        private readonly USPMHGetMusicLabelRepositories objUSPMHGetMusicLabelRepositories = new USPMHGetMusicLabelRepositories();
        private readonly USPValidateMHRequestConsumptionRepositories objUSPValidateMHRequestConsumptionRepositories = new USPValidateMHRequestConsumptionRepositories();
        private readonly USPMHNotificationMailRepositories objUSPMHNotificationMailRepositories = new USPMHNotificationMailRepositories();
        private readonly USPMHAutoApproveUsageRequestRepositories objUSPMHAutoApproveUsageRequestRepositories = new USPMHAutoApproveUsageRequestRepositories();
        private readonly USPMHGetTalentsRepositories objUSPMHGetTalentsRepositories = new USPMHGetTalentsRepositories();
        private readonly MHMusicSongTypeRepositories objMHMusicSongTypeRepositories = new MHMusicSongTypeRepositories();
        private readonly USPMHGetChannelFromDealRepositories objUSPMHGetChannelFromDealRepositories = new USPMHGetChannelFromDealRepositories();
        private readonly Music_LanguageRepositories objMusic_LanguageRepositories = new Music_LanguageRepositories();
        private readonly USPMHConsumptionRequestDetailRepositories objUSPMHConsumptionRequestDetailRepositories = new USPMHConsumptionRequestDetailRepositories();
        private readonly USPMHMovieAlbumMusicDetailsListRepositories objUSPMHMovieAlbumMusicDetailsListRepositories = new USPMHMovieAlbumMusicDetailsListRepositories();
        public IEnumerable<USPMHShowNameList> GetShowNameList(int UsersCode,int ChannelCode)
        {
          
            return objUSPMHShowNameListRepositories.ShowNameList(UsersCode,ChannelCode);
        }

        public IEnumerable<USPMHSearchMusicTrack> GetMusicTrackList(MusicTrackInput objMusicTrackInput,out int _RecordCount)
        {

            return objUSPMHSearchMusicTrackRepositories.ShowMusicTrakList(objMusicTrackInput,out _RecordCount);
        }
       
        public IEnumerable<USPMHConsumptionRequestList> GetConsumptionRequestList(MHRequest objMHRequest, ConsumptionRequestListInput objConsumptionRequestList, out int _RecordCount)//,string RecordFor,string PagingRequired,int PageSize,int PageNo, out int _RecordCount)
        {
            return objUSPMHConsumptionRequestRepositories.GetConsumptionRequestList(objMHRequest,objConsumptionRequestList, out _RecordCount);//,RecordFor,PagingRequired,PageSize,PageNo, out _RecordCount);
        }

        public IEnumerable<USPMHConsumptionRequestListDetail> GetConsumptionRequestListDetail(MHRequest objMHRequest, ConsumptionRequestListInput objConsumptionRequestList, out int _RecordCount)//,string RecordFor,string PagingRequired,int PageSize,int PageNo, out int _RecordCount)
        {
            return objUSPMHConsumptionRequestDetailRepositories.GetConsumptionRequestDetailList(objMHRequest, objConsumptionRequestList, out _RecordCount);//,RecordFor,PagingRequired,PageSize,PageNo, out _RecordCount);
        }

        public IEnumerable<USPMHMovieAlbumMusicList> GetMovieAlbumMusicList(MHRequest objMHRequest)
        {
            return objUSPMHMovieAlbumMusicListRepositories.GetMovieAlbumMusicList(objMHRequest);
        }

        public IEnumerable<USPMHMovieAlbumMusicDetailsList> GetMovieAlbumMusicDetailsList(MHRequest objMHRequest)
        {
            return objUSPMHMovieAlbumMusicDetailsListRepositories.GetMovieAlbumMusicDetailsList(objMHRequest);
        }

        public IEnumerable<ConsumptionRequestDetails> GetConsumptionRequestDetails(string MHRequestCode,int MHRequestTypeCode,char IsCueSheet)
        {
            return objConsumptionRequestDetailsRepositories.GetConsumptionRequestDetails(MHRequestCode,MHRequestTypeCode,IsCueSheet);

        }
        public IEnumerable<MusicTrackRequestDetails> GetMusicTrackRequestDetails(MHRequest objMHRequest)
        {
            return objMusicTrackRequestDetailsRepositories.GetMusicTrackRequestDetails(objMHRequest);

        }
        public IEnumerable<MovieAlbumRequestDetails> GetMovieAlbumRequestDetails(MHRequest objMHRequest)
        {
            return objMovieAlbumRequestDetailsRepositories.GetMovieAlbumRequestDetails(objMHRequest);

        }
        public IEnumerable<USPMHGetMusicLabel> GetMusicLabelList(int ChannelCode,int TitleCode)
        {
            //string strSQL = "Select  Music_Label_Code,Music_Label_Name From Music_Label Where 1 = 1 " + strSearch;
            //var lstMusiCLabel = objMusicLabelRepositories.GetDataWithSQLStmt(strSQL).ToList();
            //return lstMusiCLabel;
            return objUSPMHGetMusicLabelRepositories.GetMusicLabel(ChannelCode, TitleCode);
        }
        public IEnumerable<Genre> GetGenreList(string strSearch)
        {
            string strSQL = "Select Genres_Code,Genres_Name From Genres Where 1 = 1 " + strSearch;
            var lstGenre = objGenreRepositories.GetDataWithSQLStmt(strSQL).ToList();
            return lstGenre;
        }

        public IEnumerable<Music_Album> GetMusicAlbumList(string strSearch)
        {
            string strSQL = "Select top 100 Music_Album_Code,Music_Album_Name From Music_Album Where 1 = 1 " + strSearch;
            var lstMusicAlbum = objMusic_AlbumRepositories.GetDataWithSQLStmt(strSQL).ToList();
            return lstMusicAlbum;
        }

        public IEnumerable<Channel> GetChannelList(string strSearch)
        {
            string strSQL = "Select Channel_Code,Channel_Name from Channel Where 1=1 " + strSearch;
            var lstChannel = objChannelRepositories.GetDataWithSQLStmt(strSQL).ToList();
            return lstChannel;
        }

        public string SaveMusicConsumptionRequest(MHRequest objMHRequest)
        {
            objMHRequestRepositories.Add(objMHRequest);
            
            return "BT-001";
        }

        public string GetRequestID(int VendorCode,string requestType)
        {
            string RequestID = objUSPMHGetRequestIDRepositories.GetRequestID(VendorCode,requestType);
            return RequestID;
        }

        public void CreatePlayList(MHPlayList objMHPlayList)
        {
            objMHPlayListRepositories.Add(objMHPlayList);
        }

        public void DeletePlayList(MHPlayList objMHPlayList)
        {
            objMHPlayListRepositories.Delete(objMHPlayList);
        }

        public MHPlayList GetByID(int? id)
        {
            return objMHPlayListRepositories.GetByID(id);
        }

        public void CreatePlayListSong(MHPlayListSong objMHPlayListSong)
        {
            objMHPlayListSongRepositories.Add(objMHPlayListSong);
        }

        public MHPlayListSong GetBySongID(int? id)
        {
            return objMHPlayListSongRepositories.GetByID(id);
        }

        public void DeletePlayListSong(MHPlayListSong objMHPlayListSong)
        {
            objMHPlayListSongRepositories.Delete(objMHPlayListSong);
        }

        public IEnumerable<MHPlayList> GetPlayList(string strSearch)
        {
            string strSQL = "Select MHPlayListCode,PlaylistName from MHPlayList Where " + strSearch;
            var lstMusicAlbum = objMHPlayListRepositories.GetDataWithSQLStmt(strSQL).ToList();
            return lstMusicAlbum;
        }

        public IEnumerable<MHPlayList> SearchPlayList(object param)
        {
            List<MHPlayList> lstPlayList = new List<MHPlayList>();
            MHPlayListServices obj = new MHPlayListServices();
            lstPlayList = (List<MHPlayList>)objMHPlayListRepositories.SearchFor(param);
            return lstPlayList;
        }

        public IEnumerable<MHPlayListSong> SearchPlayListSong(object param)
        {
            List<MHPlayListSong> lstPlayListSong = new List<MHPlayListSong>();
            MHPlayListServices obj = new MHPlayListServices();
            lstPlayListSong = (List<MHPlayListSong>)objMHPlayListSongRepositories.SearchFor(param);
            return lstPlayListSong;
        }

        public IEnumerable<USPMHGetTitleEpisode> GetTitleEpisode(Title objTitle)
        {
            USPMHGetTitleEpisodeRepositories objUSPMHGetTitleEpisodeRepositories = new USPMHGetTitleEpisodeRepositories();
            return objUSPMHGetTitleEpisodeRepositories.GetTitleEpisode(objTitle);
        }

        public void ValidateConsumptionRequest(MHRequest objMHRequest)
        {
            objUSPValidateMHRequestConsumptionRepositories.ValidateConsumptionRequest(objMHRequest);
        }

        public string SendForApproval(MHRequest objMHRequest,int UserCode)
        {
            return objUSPMHNotificationMailRepositories.SendForApproval(objMHRequest,UserCode);
        }

        public void AutoApproveUsageRequest(MHRequest objMHRequest,int UserCode)
        {
            objUSPMHAutoApproveUsageRequestRepositories.AutoApproveUsageRequest(objMHRequest, UserCode);
        }

        public IEnumerable<USPMHGetTalents> GetTalents(int RoleCode,string strSearch)
        {
            return objUSPMHGetTalentsRepositories.GetTalents(RoleCode, strSearch).ToList();
        }

        public IEnumerable<MHMusicSongType> GetMusicSongType(string strSearch)
        {
            string strSQL = "Select Channel_Code,Channel_Name from Channel Where 1=1 " + strSearch;
            var lstSongType = objMHMusicSongTypeRepositories.GetDataWithSQLStmt(strSearch).ToList();
            return lstSongType;
        }

        public IEnumerable<MHPlayList> CheckPlayList(object param)
        {
            List<MHPlayList> lstPlayList = new List<MHPlayList>();
            //MHPlayListServices obj = new MHPlayListServices();
            lstPlayList = (List<MHPlayList>)objMHPlayListRepositories.SearchFor(param);
            return lstPlayList;
        }

        public int  GetChannelCode(string strSearch,int titleCode)
        {
            int ChannelCode; 
            var lst = objMHRequestRepositories.GetDataWithSQLStmt(strSearch).FirstOrDefault();
          
            if (lst == null)
            {
                string chCode = objUSPMHGetChannelFromDealRepositories.GetGetChannelFromAcqDeal(titleCode).ToString();
                //"Select Channel_Code from Channel where Channel_Name = 'Colors India'";
                //var lstChannel = objChannelRepositories.GetDataWithSQLStmt(strSQL).ToList();
                ChannelCode = Convert.ToInt32(chCode); //Convert.ToInt32(lstChannel[0].Channel_Code);
            }
            else
            {
                ChannelCode = Convert.ToInt32(lst.ChannelCode);
            }

            return ChannelCode;
        }

        public IEnumerable<Music_Language> GetMusicLanguageList(string strSearch)
        {
            List<Music_Language> lstMusic_Language = new List<Music_Language>();
            string strSQL = "Select Music_Language_Code, Language_Name from Music_Language Where 1 = 1 " + strSearch;
            lstMusic_Language = objMusic_LanguageRepositories.GetDataWithSQLStmt(strSQL).ToList();
            return lstMusic_Language;
        }

        public MHRequest GetMHRequest(int Id)
        {
            return objMHRequestRepositories.Get(Id);
        }

        public MHPlayList UpdatePlaylist(MHPlayList objMHPlaylist)
        {
            objMHPlaylist = objMHPlayListRepositories.Update(objMHPlaylist);
            return objMHPlaylist;
        }
    }
}