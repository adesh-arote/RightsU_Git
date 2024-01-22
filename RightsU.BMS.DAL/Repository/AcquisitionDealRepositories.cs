using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL.Repository
{
    public class AcquisitionDealRepositories : MainRepository<Acq_Deal_Rights>
    {
        public Acq_Deal_Rights GetById(Int32? Id)
        {
            var obj = new { Acq_Deal_Rights_Code = Id.Value };
            //var entity = base.GetById<Acq_Deal_Rights, Sub_License, Acq_Deal_Rights_Title, Title, Acq_Deal_Rights_Territory, Territory, Country, Acq_Deal_Rights_Platform>(obj);
            var entity = base.GetById<Acq_Deal_Rights, Sub_License, Acq_Deal_Rights_Title, Acq_Deal_Rights_Territory, Acq_Deal_Rights_Platform, Acq_Deal_Rights_Subtitling, Acq_Deal_Rights_Dubbing>(obj);
            //var entity = base.GetById<Acq_Deal_Rights, Sub_License, Acq_Deal_Rights_Title, Acq_Deal_Rights_Platform, Acq_Deal_Rights_Territory, Acq_Deal_Rights_Subtitling, Acq_Deal_Rights_Dubbing>(obj);

            if (entity != null)
            {
                if (entity.Titles.Count > 0)
                {
                    entity.Titles.ToList().ForEach(i =>
                    {
                        if (i.title == null)
                        {
                            i.title = new TitleRepositories().GetById(i.Title_Code.Value);
                        }
                    });
                }

                if (entity.Platform.Count > 0)
                {
                    entity.Platform.ToList().ForEach(i =>
                    {
                        if (i.platform == null)
                        {
                            i.platform = new PlatformRepositories().Get(i.Platform_Code.Value);
                        }
                    });
                }

                if (entity.Region.Count > 0)
                {
                    entity.Region.ToList().ForEach(i =>
                    {
                        if (i.Territory == null)
                        {
                            i.Territory = new TerritoryRepositories().Get(i.Territory_Code.Value);
                        }

                        if (i.Country == null)
                        {
                            i.Country = new CountryRepositories().Get(i.Country_Code.Value);
                        }
                    });
                }

                if (entity.Subtitling.Count > 0)
                {
                    entity.Subtitling.ToList().ForEach(i =>
                    {
                        if (i.language == null)
                        {
                            i.language = new LanguageRepositories().Get(i.Language_Code.Value);
                        }
                    });

                    //entity.Subtitling.ToList().ForEach(i =>
                    //{
                    //    if (i.language == null)
                    //    {
                    //        i.language = new LanguageRepositories().Get(i.Language_Code.Value);
                    //    }
                    //});
                }

                if (entity.Dubbing.Count > 0)
                {
                    entity.Dubbing.ToList().ForEach(i =>
                    {
                        if (i.language == null)
                        {
                            i.language = new LanguageRepositories().Get(i.Language_Code.Value);
                        }
                    });
                }
            }

            return entity;
        }

        public void Add(Acq_Deal_Rights entity)
        {
            base.AddEntity(entity);
        }

        public void Delete(Acq_Deal_Rights entity)
        {
            base.DeleteEntity(entity);
        }

        public void Update(Acq_Deal_Rights entity)
        {
            Acq_Deal_Rights oldObj = GetById(entity.Acq_Deal_Rights_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public IEnumerable<Acq_Deal_Rights> SearchFor(object param)
        {
            var entity = base.SearchForEntity<Acq_Deal_Rights, Sub_License, Acq_Deal_Rights_Title, Acq_Deal_Rights_Territory, Acq_Deal_Rights_Platform, Acq_Deal_Rights_Subtitling, Acq_Deal_Rights_Dubbing>(param);
            entity.ToList().ForEach(i =>
            {
                if (i.Titles.Count() > 0)
                {
                    i.Titles.ToList().ForEach(j =>
                    {
                        if (j.title == null)
                        {
                            j.title = new TitleRepositories().GetById(j.Title_Code);
                        }
                    });
                }

                if (i.Platform.Count > 0)
                {
                    i.Platform.ToList().ForEach(j =>
                    {
                        if (j.platform == null)
                        {
                            j.platform = new PlatformRepositories().Get(j.Platform_Code.Value);
                        }
                    });
                }

                if (i.Region.Count > 0)
                {
                    i.Region.ToList().ForEach(j =>
                    {
                        if (j.Territory == null)
                        {
                            j.Territory = new TerritoryRepositories().Get(j.Territory_Code.Value);
                        }

                        if (j.Country == null)
                        {
                            j.Country = new CountryRepositories().Get(j.Country_Code.Value);
                        }
                    });
                }

                if (i.Subtitling.Count > 0)
                {
                    i.Subtitling.ToList().ForEach(j =>
                    {
                        if (j.language == null)
                        {
                            j.language = new LanguageRepositories().Get(j.Language_Code.Value);
                        }
                    });
                }

                if (i.Dubbing.Count > 0)
                {
                    i.Dubbing.ToList().ForEach(j =>
                    {
                        if (j.language == null)
                        {
                            j.language = new LanguageRepositories().Get(j.Language_Code.Value);
                        }
                    });
                }

            });

            return entity;
        }

        public IEnumerable<Acq_Deal_Rights> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Acq_Deal_Rights>(strSQL);
        }
    }

    #region -------- Acq_Rights_Title -----------
    public class Acq_Deal_Rights_TitleRepositories : MainRepository<Acq_Deal_Rights_Title>
    {
        public Acq_Deal_Rights_Title Get(int Id)
        {
            var obj = new { Acq_Deal_Rights_Title_Code = Id };

            return base.GetById<Acq_Deal_Rights_Title>(obj);
        }
        public IEnumerable<Acq_Deal_Rights_Title> GetAll()
        {
            return base.GetAll<Acq_Deal_Rights_Title>();
        }
        public void Add(Acq_Deal_Rights_Title entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Acq_Deal_Rights_Title entity)
        {
            Acq_Deal_Rights_Title oldObj = Get(entity.Acq_Deal_Rights_Title_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Acq_Deal_Rights_Title entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Acq_Deal_Rights_Title> SearchFor(object param)
        {
            return base.SearchForEntity<Acq_Deal_Rights_Title>(param);
        }

        public IEnumerable<Acq_Deal_Rights_Title> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Acq_Deal_Rights_Title>(strSQL);
        }
    }
    #endregion

    #region -------- Acq_Rights_Platform -----------
    public class Acq_Deal_Rights_PlatformRepositories : MainRepository<Acq_Deal_Rights_Platform>
    {
        public Acq_Deal_Rights_Platform Get(int Id)
        {
            var obj = new { Acq_Deal_Rights_Platform_Code = Id };

            return base.GetById<Acq_Deal_Rights_Platform>(obj);
        }
        public IEnumerable<Acq_Deal_Rights_Platform> GetAll()
        {
            return base.GetAll<Acq_Deal_Rights_Platform>();
        }
        public void Add(Acq_Deal_Rights_Platform entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Acq_Deal_Rights_Platform entity)
        {
            Acq_Deal_Rights_Platform oldObj = Get(entity.Acq_Deal_Rights_Platform_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Acq_Deal_Rights_Platform entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Acq_Deal_Rights_Platform> SearchFor(object param)
        {
            return base.SearchForEntity<Acq_Deal_Rights_Platform>(param);
        }

        public IEnumerable<Acq_Deal_Rights_Platform> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Acq_Deal_Rights_Platform>(strSQL);
        }
    }
    #endregion

    #region -------- Acq_Rights_Deal_Rights_Territory -----------
    public class Acq_Deal_Rights_TerritoryRepositories : MainRepository<Acq_Deal_Rights_Territory>
    {
        public Acq_Deal_Rights_Territory Get(int Id)
        {
            var obj = new { Acq_Deal_Rights_Territory_Code = Id };

            return base.GetById<Acq_Deal_Rights_Territory>(obj);
        }
        public IEnumerable<Acq_Deal_Rights_Territory> GetAll()
        {
            return base.GetAll<Acq_Deal_Rights_Territory>();
        }
        public void Add(Acq_Deal_Rights_Territory entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Acq_Deal_Rights_Territory entity)
        {
            Acq_Deal_Rights_Territory oldObj = Get(entity.Acq_Deal_Rights_Territory_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Acq_Deal_Rights_Territory entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Acq_Deal_Rights_Territory> SearchFor(object param)
        {
            return base.SearchForEntity<Acq_Deal_Rights_Territory>(param);
        }

        public IEnumerable<Acq_Deal_Rights_Territory> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Acq_Deal_Rights_Territory>(strSQL);
        }
    }
    #endregion

    #region -------- Acq_Rights_Deal_Rights_Subtitling -----------
    public class Acq_Deal_Rights_SubtitlingRepositories : MainRepository<Acq_Deal_Rights_Subtitling>
    {
        public Acq_Deal_Rights_Subtitling Get(int Id)
        {
            var obj = new { Acq_Deal_Rights_Subtitling_Code = Id };

            return base.GetById<Acq_Deal_Rights_Subtitling>(obj);
        }
        public IEnumerable<Acq_Deal_Rights_Subtitling> GetAll()
        {
            return base.GetAll<Acq_Deal_Rights_Subtitling>();
        }
        public void Add(Acq_Deal_Rights_Subtitling entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Acq_Deal_Rights_Subtitling entity)
        {
            Acq_Deal_Rights_Subtitling oldObj = Get(entity.Acq_Deal_Rights_Subtitling_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Acq_Deal_Rights_Subtitling entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Acq_Deal_Rights_Subtitling> SearchFor(object param)
        {
            return base.SearchForEntity<Acq_Deal_Rights_Subtitling>(param);
        }

        public IEnumerable<Acq_Deal_Rights_Subtitling> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Acq_Deal_Rights_Subtitling>(strSQL);
        }
    }
    #endregion

    #region -------- Acq_Deal_Rights_Dubbing -----------
    public class Acq_Deal_Rights_DubbingRepositories : MainRepository<Acq_Deal_Rights_Dubbing>
    {
        public Acq_Deal_Rights_Dubbing Get(int Id)
        {
            var obj = new { Acq_Deal_Rights_Dubbing_Code = Id };

            return base.GetById<Acq_Deal_Rights_Dubbing>(obj);
        }
        public IEnumerable<Acq_Deal_Rights_Dubbing> GetAll()
        {
            return base.GetAll<Acq_Deal_Rights_Dubbing>();
        }
        public void Add(Acq_Deal_Rights_Dubbing entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Acq_Deal_Rights_Dubbing entity)
        {
            Acq_Deal_Rights_Dubbing oldObj = Get(entity.Acq_Deal_Rights_Dubbing_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Acq_Deal_Rights_Dubbing entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Acq_Deal_Rights_Dubbing> SearchFor(object param)
        {
            return base.SearchForEntity<Acq_Deal_Rights_Dubbing>(param);
        }

        public IEnumerable<Acq_Deal_Rights_Dubbing> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Acq_Deal_Rights_Dubbing>(strSQL);
        }
    }
    #endregion
}
