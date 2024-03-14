
using Dapper;
using RightsU_ScheduleFileProcess.Entities;
using RightsU_ScheduleFileProcess.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_ScheduleFileProcess.Repository
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

            public Upload_Files GetUpload_FilesById(int Id)
            {
                var obj = new { File_Code = Id };

                return base.GetById<Upload_Files>(obj);
            }

            public IEnumerable<Upload_Files> SearchFor(object param)
            {
                return base.SearchForEntity<Upload_Files>(param);
            }


            public void Update(Upload_Files entity)
            {
                Upload_Files oldObj = GetUpload_FilesById(entity.File_Code.Value);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(Upload_Files entity)
            {
                base.DeleteEntity(entity);
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

        public class BMS_Schedule_Import_ConfigRepositories : MainRepository<BMS_Schedule_Import_Config>
        {
            public void Add(BMS_Schedule_Import_Config entity)
            {
                base.AddEntity(entity);
            }

            public BMS_Schedule_Import_Config GetById(int Id)
            {
                var obj = new { BMS_Import_Config_Code = Id };

                return base.GetById<BMS_Schedule_Import_Config>(obj);
            }

            public IEnumerable<BMS_Schedule_Import_Config> SearchFor(object param)
            {
                return base.SearchForEntity<BMS_Schedule_Import_Config>(param);
            }


            public void Update(BMS_Schedule_Import_Config entity)
            {
                BMS_Schedule_Import_Config oldObj = GetById(entity.BMS_Import_Config_Code);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(BMS_Schedule_Import_Config entity)
            {
                base.DeleteEntity(entity);
            }
        }

        public class BMSUploadData_Repositories : MainRepository<int>
        {
            public int BMSUploadData(DataTable dt, string FileType, int ChannelCode)
            {
                Int32 BMS_Upload_Code = 0;
                var param = new DynamicParameters();
                param.Add("@UDT", dt.AsTableValuedParameter());
                param.Add("@FileType", FileType);
                param.Add("@ChannelCode", ChannelCode);
                var identity = base.ExecuteScalar("USP_BMS_Upload_Data", param);
                BMS_Upload_Code = Convert.ToInt32(identity);
                return BMS_Upload_Code;
            }
        }
    }
}
