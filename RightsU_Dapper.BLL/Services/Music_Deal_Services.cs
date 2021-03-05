using RightsU_Dapper.DAL.Repository;
using RightsU_Dapper.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.BLL.Services
{
    public class Music_DealServices
    {
        Music_Deal_Repository objMusic_Deal_Repository = new Music_Deal_Repository();
        public Music_DealServices()
        {
            this.objMusic_Deal_Repository = new Music_Deal_Repository();
        }
        public Music_Deal_Dapper GetMusic_DealByID(int? ID, Type[] RelationList = null)
        {
            return objMusic_Deal_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Music_Deal_Dapper> GetMusic_DealList()
        {
            return objMusic_Deal_Repository.GetAll();
        }
        public void AddEntity(Music_Deal_Dapper param)
        {
            objMusic_Deal_Repository.Add(param);
        }
        public void UpdateMusic_Deal(Music_Deal_Dapper obj)
        {
            objMusic_Deal_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Music_Deal_Dapper obj)
        {
            objMusic_Deal_Repository.Delete(obj);
        }

        public IEnumerable<Music_Deal_Dapper> SearchFor(object param)
        {
            return objMusic_Deal_Repository.SearchFor(param);
        }

        public IEnumerable<USP_List_Music_Deal_Result> USP_List_Music_Deal(string searchText, string agreement_No, Nullable<System.DateTime> startDate, Nullable<System.DateTime> endDate, string deal_Type_Code, string status_Code, Nullable<int> business_Unit_Code, Nullable<int> deal_Tag_Code, string workflow_Status, string vendor_Codes, string show_Type_Code, string title_Code, string music_Label_Codes, string isAdvance_Search, Nullable<int> user_Code, int pageNo, Nullable<int> pageSize, out int recordCount)
        {
            return objMusic_Deal_Repository.USP_List_Music_Deal(searchText, agreement_No, startDate, endDate, deal_Type_Code, status_Code, business_Unit_Code, deal_Tag_Code, workflow_Status, vendor_Codes, show_Type_Code, title_Code, music_Label_Codes, isAdvance_Search, user_Code, pageNo, pageSize, out recordCount);
        }

        public IEnumerable<USP_Music_Deal_Link_Show_Result> USP_Music_Deal_Link_Show(string channel_Code, string title_Name, string mode, Nullable<int> music_Deal_Code, string selectedTitleCodes)
        {
            return objMusic_Deal_Repository.USP_Music_Deal_Link_Show(channel_Code, title_Name, mode, music_Deal_Code, selectedTitleCodes);
        }
        public IEnumerable<USP_Music_Deal_Schedule_Validation_Result> USP_Music_Deal_Schedule_Validation(int? Music_Deal_Code, string Channel_Codes, string Start_Date, string End_Date, string Title_Codes, string LinkshowType)
        {
            return objMusic_Deal_Repository.USP_Music_Deal_Schedule_Validation(Music_Deal_Code, Channel_Codes, Start_Date, End_Date, Title_Codes, LinkshowType);
        }
        public string USP_RollBack_Music_Deal(Nullable<int> music_Deal_Code, Nullable<int> user_Code, out string errorMessage)
        {
            return objMusic_Deal_Repository.USP_RollBack_Music_Deal(music_Deal_Code, user_Code, out errorMessage);
        }
    }

    public class Music_Deal_PlatformServices
    {
        Music_Deal_Platform_Repository objMusic_Deal_Platform_Repository = new Music_Deal_Platform_Repository();
        public Music_Deal_PlatformServices()
        {
            this.objMusic_Deal_Platform_Repository = new Music_Deal_Platform_Repository();
        }

        public void DeleteAllMusic_Deal_Platform(List<Music_Deal_Platform_Dapper> list)
        {
            objMusic_Deal_Platform_Repository.DeleteAllEntity(list);
        }
    }
}
