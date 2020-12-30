using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RightsUMusic.DAL.Repository;
using RightsUMusic.Entity;

namespace RightsUMusic.BLL.Services
{
    public class CueSheetManagementServices
    {
        private readonly CueSheetRepositories objCueSheetRepositories = new CueSheetRepositories();
        private readonly USPMHGetCueSheetListRepositories objUSPMHGetCueSheetListRepositories = new USPMHGetCueSheetListRepositories();
        private readonly USPMHGetCueSheetSongDetailsRepositories objUSPMHGetCueSheetSongDetailsRepositories = new USPMHGetCueSheetSongDetailsRepositories();
        private readonly USPMHNotificationMailForCueSheetRepositories objUSPMHNotificationMailForCueSheetRepositories = new USPMHNotificationMailForCueSheetRepositories();
        private readonly USPMHGetRequestIDRepositories objUSPMHGetRequestIDRepositories = new USPMHGetRequestIDRepositories();

        public int SaveCueSheet(DataTable dt,int CueSheetCode,string fileWithTimeStamp,int UsersCode, out int _CueSheetCodeOut)
        {
            objCueSheetRepositories.GetDataWithSQLStmt(dt,CueSheetCode, fileWithTimeStamp, UsersCode, out _CueSheetCodeOut);
            return _CueSheetCodeOut;
        }

        public void SaveMHCueSheet(MHCueSheet objMHCueSheet)
        {
            objCueSheetRepositories.Add(objMHCueSheet);
        }

        public IEnumerable<USPMHGetCueSheetList> GetCueSheetList(int UsersCode, CueSheetListInput objCueSheetListInput,out int _RecordCount)
        {
            var lstMusiCLabel = objUSPMHGetCueSheetListRepositories.GetCueSheetList(UsersCode,objCueSheetListInput,out _RecordCount);
            return lstMusiCLabel;
        }

        public IEnumerable<USPMHGetCueSheetSongDetails> GetCueSheetSongDetails(CueSheetDetailInput objCueSheetDetailInput)
        {
            var lstCueSheetSongs = objUSPMHGetCueSheetSongDetailsRepositories.GetCueSheetSongDetails(objCueSheetDetailInput);
            return lstCueSheetSongs;
        }

        public void SubmitCueSheet(MHCueSheet objMHCueSheet)
        {
            objCueSheetRepositories.Update(objMHCueSheet);
        }

        public MHCueSheet GetByIdCueSheet(int MHCueSheetCode)
        {
            List<MHCueSheet> lstMHCueSheet = new List<MHCueSheet>();
            MHCueSheet ObjCueSheet = objCueSheetRepositories.Get(Convert.ToInt32(MHCueSheetCode));
            return ObjCueSheet;
        }

        public void SendCueSheetForApproval(MHCueSheet objMHCueSheet,int UsersCode)
        {
            objUSPMHNotificationMailForCueSheetRepositories.SendCueSheetForApproval(objMHCueSheet,UsersCode);
        }

        public void CueSheetSaveManually(MHCueSheet objMHCueSheet)
        {
            objCueSheetRepositories.Add(objMHCueSheet);
        }

        public string GetRequestID(int VendorCode,string requestType)
        {
            string RequestID = objUSPMHGetRequestIDRepositories.GetRequestID(VendorCode,requestType);
            return RequestID;
        }
    }
}
