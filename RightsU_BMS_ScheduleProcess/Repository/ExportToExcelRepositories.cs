
using Dapper;
using RightsU_BMS_ScheduleProcess.Entities;
using RightsU_LoadSheet_Export_CA.Entities;
using ROP.Quotes.DAL.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_BMS_ScheduleProcess.Repository
{
    public class MasterRepositories
    {      

        public class ChannelRepositories : MainRepository<Channel>
        {
            public void Add(Channel entity)
            {
                base.AddEntity(entity);
            }

            public Channel GetChannel(int Id)
            {
                var obj = new { Channel_Code = Id };
                
                return base.GetById<Channel>(obj);
            }

            public IEnumerable<Channel> SearchFor(object param)
            {
                return base.SearchForEntity<Channel>(param);
            }


            public void Update(Channel entity)
            {
                Channel oldObj = GetChannel(entity.Channel_Code);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(Channel entity)
            {
                base.DeleteEntity(entity);
            }
        }

        public class Upload_FilesRepositories : MainRepository<Upload_Files>
        {
            public void Add(Upload_Files entity)
            {
                base.AddEntity(entity);
            }

            public Upload_Files GetUpload_Files(int Id)
            {
                var obj = new { Upload_Files_Code = Id };

                return base.GetById<Upload_Files>(obj);
            }

            public IEnumerable<Upload_Files> SearchFor(object param)
            {
                return base.SearchForEntity<Upload_Files>(param);
            }


            public void Update(Upload_Files entity)
            {
                Upload_Files oldObj = GetUpload_Files(entity.File_Code);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(Upload_Files entity)
            {
                base.DeleteEntity(entity);
            }
        }

        public class AL_RecommendationRepositories : MainRepository<AL_Recommendation>
        {
            public void Add(AL_Recommendation entity)
            {
                base.AddEntity(entity);
            }

            public AL_Recommendation GetProposal(int Id)
            {
                var obj = new { AL_Recommendation_Code = Id };

                return base.GetById<AL_Recommendation, AL_Recommendation_Content>(obj);
            }

            public IEnumerable<AL_Recommendation> GetAllRecommendation()
            {
                return base.GetAll<AL_Recommendation, AL_Recommendation_Content>();
            }

            public void Update(AL_Recommendation entity)
            {
                AL_Recommendation oldObj = GetProposal(entity.AL_Recommendation_Code.Value);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(AL_Recommendation entity)
            {
                base.DeleteEntity(entity);
            }
        }

        public class AL_RecommendationContentRepositories : MainRepository<AL_Recommendation_Content>
        {
            public void Add(AL_Recommendation_Content entity)
            {
                base.AddEntity(entity);
            }

            public AL_Recommendation_Content GetAL_Recommendation_Content(int Id)
            {
                var obj = new { AL_Recommendation_Content_Code = Id };

                return base.GetById<AL_Recommendation_Content>(obj);
            }

            public IEnumerable<AL_Recommendation_Content> GetAllRecommendation()
            {
                return base.GetAll<AL_Recommendation_Content>();
            }

            public void Update(AL_Recommendation_Content entity)
            {
                AL_Recommendation_Content oldObj = GetAL_Recommendation_Content(entity.AL_Recommendation_Content_Code.Value);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(AL_Recommendation_Content entity)
            {
                base.DeleteEntity(entity);
            }
        }

        public class AL_Load_SheetRepositories : MainRepository<AL_Load_Sheet>
        {
            public void Add(AL_Load_Sheet entity)
            {
                base.AddEntity(entity);
            }

            public AL_Load_Sheet GetLoadSheet(int Id)
            {
                var obj = new { AL_Load_Sheet_Code = Id };

                //return base.GetById<AL_Load_Sheet, AL_Load_Sheet_Rule, AL_Recommendation, AL_Recommendation_Content>(obj);
                return base.GetById<AL_Load_Sheet,AL_Load_Sheet_Details>(obj);
            }
            public IEnumerable<AL_Load_Sheet> GetALLAL_Load_Sheet()
            {
                return base.GetAll<AL_Load_Sheet, AL_Load_Sheet_Details>();
            }
            public void Update(AL_Load_Sheet entity)
            {
                AL_Load_Sheet oldObj = GetLoadSheet(entity.AL_Load_Sheet_Code.Value);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(AL_Load_Sheet entity)
            {
                base.DeleteEntity(entity);
            }

            public void GetDataWithSQLStmt(string strSQL)
            {
                base.ExecuteSQLStmt<dynamic>(strSQL);
            }
        }

        public class AL_Booking_SheetRepositories : MainRepository<AL_Booking_Sheet>
        {
            public void Add(AL_Booking_Sheet entity)
            {
                base.AddEntity(entity);
            }

            public AL_Booking_Sheet GetBookingSheet(int Id)
            {
                var obj = new { AL_Booking_Sheet_Code = Id };

                //return base.GetById<AL_Booking_Sheet, AL_Booking_Sheet_Rule, AL_Recommendation, AL_Recommendation_Content>(obj);
                return base.GetById<AL_Booking_Sheet, AL_Booking_Sheet_Details>(obj);
            }
            public IEnumerable<AL_Booking_Sheet> GetALLAL_Booking_Sheet()
            {
                return base.GetAll<AL_Booking_Sheet, AL_Booking_Sheet_Details>();
            }
            public void Update(AL_Booking_Sheet entity)
            {
                AL_Booking_Sheet oldObj = GetBookingSheet(entity.AL_Booking_Sheet_Code);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(AL_Booking_Sheet entity)
            {
                base.DeleteEntity(entity);
            }
        }

        public class AL_Booking_Sheet_DetailsRepositories : MainRepository<AL_Booking_Sheet_Details>
        {
            public void Add(AL_Booking_Sheet_Details entity)
            {
                base.AddEntity(entity);
            }

            public AL_Booking_Sheet_Details GetBookingSheetDetails(int Id)
            {
                var obj = new { AL_Booking_Sheet_Details_Code = Id };

                //return base.GetById<AL_Booking_Sheet_Details, AL_Booking_Sheet_Details_Rule, AL_Recommendation, AL_Recommendation_Content>(obj);
                return base.GetById<AL_Booking_Sheet_Details>(obj);
            }
            public IEnumerable<AL_Booking_Sheet_Details> GetALLAL_Booking_Sheet_Details()
            {
                return base.GetAll<AL_Booking_Sheet_Details>();
            }
            public void Update(AL_Booking_Sheet_Details entity)
            {
                AL_Booking_Sheet_Details oldObj = GetBookingSheetDetails(entity.AL_Booking_Sheet_Details_Code);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(AL_Booking_Sheet_Details entity)
            {
                base.DeleteEntity(entity);
            }

            public IEnumerable<AL_Booking_Sheet_Details> SearchFor(object param)
            {
                return base.SearchForEntity<AL_Booking_Sheet_Details>(param);
            }
        }

        public class USP_BMS_Schedule1_Validate_Temp_BV_ScheduleRepositories : MainRepository<dynamic>
        {
            public void USP_BMS_Schedule1_Validate_Temp_BV_Schedule(int File_Code ,string Channel_Code, string IsReprocess, string BV_Episode_ID)
            {
                var param = new DynamicParameters();
                param.Add("@File_Code", File_Code);
                param.Add("@Channel_Code", Channel_Code);
                param.Add("@IsReprocess", IsReprocess);
                param.Add("BV_Episode_ID", BV_Episode_ID);
                base.ExecuteSQLProcedure<dynamic>("USP_BMS_Schedule1_Validate_Temp_BV_Schedule", param);
            }
        }

        public class USP_Music_ScheduleRepositories : MainRepository<dynamic>
        {
            public void USP_Music_Schedule()
            {
                var param = new DynamicParameters();
                base.ExecuteSQLProcedure<dynamic>("USP_Music_Schedule", param);
            }
        }
    }
}
