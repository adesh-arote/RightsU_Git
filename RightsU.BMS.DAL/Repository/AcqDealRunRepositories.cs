using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL.Repository
{
    public class AcqDealRunRepositories : MainRepository<Acq_Deal_Run>
    {
        public Acq_Deal_Run Get(Int32? Id)
        {
            var obj = new { Acq_Deal_Run_Code = Id.Value };
            var entity = base.GetById < Acq_Deal_Run, Acq_Deal_Run_Title, Acq_Deal_Run_Channel, Acq_Deal_Run_Yearwise_Run, Acq_Deal_Run_Repeat_On_Day, Channel_Category, Channel>(obj);

            if (entity != null)
            {
                if (entity.right_rule == null && (entity.Right_Rule_Code != null || entity.Right_Rule_Code > 0))
                {
                    entity.right_rule = new RightRuleRepositories().GetById(entity.Right_Rule_Code.Value);
                }
                
                if (entity.primary_channel == null && (entity.Primary_Channel_Code != null || entity.Primary_Channel_Code > 0))
                {
                    entity.primary_channel = new ChannelRepositories().Get(entity.Primary_Channel_Code.Value);
                }

                //if (entity.channels.Count() > 0)
                //{
                //    entity.channels.ToList().ForEach(i =>
                //    {
                //        if (i.chan == null)
                //        {
                //            i.Channel = new ChannelRepositories().Get(i.Channel_Code.Value);
                //        }
                //    });
                //}
            }

            return entity;
        }

        public IEnumerable<Acq_Deal_Run> GetAll()
        {
            return base.GetAll<Acq_Deal_Run>();
        }

        public void Add(Acq_Deal_Run entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Acq_Deal_Run entity)
        {
            Acq_Deal_Run oldObj = Get(entity.Acq_Deal_Run_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Acq_Deal_Run entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Acq_Deal_Run> SearchFor(object param)
        {
            var entity = base.SearchForEntity<Acq_Deal_Run, Acq_Deal_Run_Title, Acq_Deal_Run_Channel, Acq_Deal_Run_Yearwise_Run, Acq_Deal_Run_Repeat_On_Day, Channel_Category>(param);
            entity.ToList().ForEach(i =>
            {
                if (i.right_rule == null && (i.Right_Rule_Code != null || i.Right_Rule_Code > 0))
                {
                    i.right_rule = new RightRuleRepositories().GetById(i.Right_Rule_Code.Value);
                }

                if (i.primary_channel == null && (i.Primary_Channel_Code != null || i.Primary_Channel_Code > 0))
                {
                    i.primary_channel = new ChannelRepositories().Get(i.Primary_Channel_Code.Value);
                }

                if (i.channels.Count() > 0)
                {
                    i.channels.ToList().ForEach(j =>
                    {
                        if (j.Channel == null)
                        {
                            j.Channel = new ChannelRepositories().Get(j.Channel_Code.Value);
                        }
                    });
                }
            });

            return entity;
        }

        public IEnumerable<Acq_Deal_Run> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Acq_Deal_Run>(strSQL);
        }
    }

    #region -------- Acq_Deal_Run_Title -----------
    public class Acq_Deal_Run_Title_Repositories : MainRepository<Acq_Deal_Run_Title>
    {
        public Acq_Deal_Run_Title Get(int Id)
        {
            var obj = new { Acq_Deal_Run_Title_Code = Id };

            return base.GetById<Acq_Deal_Run_Title>(obj);
        }

        public IEnumerable<Acq_Deal_Run_Title> GetAll()
        {
            return base.GetAll<Acq_Deal_Run_Title>();
        }

        public void Add(Acq_Deal_Run_Title entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Acq_Deal_Run_Title entity)
        {
            Acq_Deal_Run_Title oldObj = Get(entity.Acq_Deal_Run_Title_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Acq_Deal_Run_Title entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Acq_Deal_Run_Title> SearchFor(object param)
        {
            return base.SearchForEntity<Acq_Deal_Run_Title>(param);
        }

        public IEnumerable<Acq_Deal_Run_Title> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Acq_Deal_Run_Title>(strSQL);
        }
    }
    #endregion

    #region -------- Acq_Deal_Run_Channel -----------
    public class Acq_Deal_Run_Channel_Repositories : MainRepository<Acq_Deal_Run_Channel>
    {
        public Acq_Deal_Run_Channel Get(int Id)
        {
            var obj = new { Acq_Deal_Run_Channel_Code = Id };

            return base.GetById<Acq_Deal_Run_Channel>(obj);
        }

        public IEnumerable<Acq_Deal_Run_Channel> GetAll()
        {
            return base.GetAll<Acq_Deal_Run_Channel>();
        }

        public void Add(Acq_Deal_Run_Channel entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Acq_Deal_Run_Channel entity)
        {
            Acq_Deal_Run_Channel oldObj = Get(entity.Acq_Deal_Run_Channel_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Acq_Deal_Run_Channel entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Acq_Deal_Run_Channel> SearchFor(object param)
        {
            return base.SearchForEntity<Acq_Deal_Run_Channel>(param);
        }

        public IEnumerable<Acq_Deal_Run_Channel> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Acq_Deal_Run_Channel>(strSQL);
        }
    }
    #endregion

    #region -------- Acq_Deal_Run_Yearwise_Run -----------
    public class Acq_Deal_Run_Yearwise_Run_Repositories : MainRepository<Acq_Deal_Run_Yearwise_Run>
    {
        public Acq_Deal_Run_Yearwise_Run Get(int Id)
        {
            var obj = new { Acq_Deal_Run_Yearwise_Run_Code = Id };

            return base.GetById<Acq_Deal_Run_Yearwise_Run>(obj);
        }

        public IEnumerable<Acq_Deal_Run_Yearwise_Run> GetAll()
        {
            return base.GetAll<Acq_Deal_Run_Yearwise_Run>();
        }

        public void Add(Acq_Deal_Run_Yearwise_Run entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Acq_Deal_Run_Yearwise_Run entity)
        {
            Acq_Deal_Run_Yearwise_Run oldObj = Get(entity.Acq_Deal_Run_Yearwise_Run_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Acq_Deal_Run_Yearwise_Run entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Acq_Deal_Run_Yearwise_Run> SearchFor(object param)
        {
            return base.SearchForEntity<Acq_Deal_Run_Yearwise_Run>(param);
        }

        public IEnumerable<Acq_Deal_Run_Yearwise_Run> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Acq_Deal_Run_Yearwise_Run>(strSQL);
        }
    }
    #endregion

    #region -------- Acq_Deal_Run_Repeat_On_Day -----------
    public class Acq_Deal_Run_Repeat_On_Day_Repositories : MainRepository<Acq_Deal_Run_Repeat_On_Day>
    {
        public Acq_Deal_Run_Repeat_On_Day Get(int Id)
        {
            var obj = new { Acq_Deal_Run_Repeat_On_Day_Code = Id };

            return base.GetById<Acq_Deal_Run_Repeat_On_Day>(obj);
        }

        public IEnumerable<Acq_Deal_Run_Repeat_On_Day> GetAll()
        {
            return base.GetAll<Acq_Deal_Run_Repeat_On_Day>();
        }

        public void Add(Acq_Deal_Run_Repeat_On_Day entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Acq_Deal_Run_Repeat_On_Day entity)
        {
            Acq_Deal_Run_Repeat_On_Day oldObj = Get(entity.Acq_Deal_Run_Repeat_On_Day_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Acq_Deal_Run_Repeat_On_Day entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Acq_Deal_Run_Repeat_On_Day> SearchFor(object param)
        {
            return base.SearchForEntity<Acq_Deal_Run_Repeat_On_Day>(param);
        }

        public IEnumerable<Acq_Deal_Run_Repeat_On_Day> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Acq_Deal_Run_Repeat_On_Day>(strSQL);
        }
    }
    #endregion
}
