using Dapper;
using RightsU.BMS.Entities.InputClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL.Repository
{
    public class TitleRepositories : MainRepository<Title>
    {
        public Title GetById(Int32? Id)
        {
            var obj = new { Title_Code = Id.Value };
            var entity = base.GetById<Title, Title_Country, Title_Talent, Title_Geners, Language, Program, Deal_Type>(obj);

            if (entity.title_language == null)
            {
                entity.title_language = new LanguageRepositories().Get(entity.title_language_id.Value);
            }

            if (entity.title_country.Count() > 0)
            {
                entity.title_country.ToList().ForEach(i =>
                {
                    if (i.country == null)
                    {
                        i.country = new CountryRepositories().Get(i.country_id.Value);
                    }
                });
            }

            if (entity.title_talent.Count() > 0)
            {
                entity.title_talent.ToList().ForEach(i =>
                {
                    if (i.talent == null)
                    {
                        i.talent = new TalentRepositories().Get(i.talent_id.Value);
                    }

                    if (i.role == null)
                    {
                        i.role = new RoleRepositories().Get(i.role_id.Value);
                    }
                });
            }

            if (entity.title_genres.Count() > 0)
            {
                entity.title_genres.ToList().ForEach(i =>
                {
                    if (i.genres == null)
                    {
                        i.genres = new GenresRepositories().Get(i.genres_id.Value);
                    }

                });
            }

            return entity;
        }

        public IEnumerable<Title> GetAll()
        {
            return base.GetAll<Title, Title_Country, Title_Talent, Title_Geners>();
        }

        public void Add(Title entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Title entity)
        {
            Title oldObj = GetById(entity.title_id.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Title entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Title> SearchFor(object param)
        {
            return base.SearchForEntity<Title, Title_Country, Title_Talent, Title_Geners>(param);
        }

        public IEnumerable<Title> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Title>(strSQL);
        }

        public TitleReturn GetTitle_List(string order, Int32 page, string search_value, Int32 size, string sort, string Date_GT, string Date_LT, Int32 id)
        {
            TitleReturn ObjTitleReturn = new TitleReturn();

            var param = new DynamicParameters();
            param.Add("@order", order);
            param.Add("@page", page);
            param.Add("@search_value", search_value);
            param.Add("@size", size);
            param.Add("@sort", sort);
            param.Add("@date_gt", Date_GT);
            param.Add("@date_lt", Date_LT);
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            var entity = base.ExecuteSQLProcedure<TitleInput>("USPAPI_Title_List", param).ToList();
            entity.ForEach(i =>
            {
                if (!string.IsNullOrEmpty(i.Language))
                {
                    var arrLang = i.Language.Split(new char[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
                    if (arrLang.Length > 0)
                    {
                        i.TitleLanguage.id = Convert.ToInt32(arrLang[0]);
                        i.TitleLanguage.Name = arrLang[1];
                    }
                }

                if (!string.IsNullOrEmpty(i.OriginalLanguage1))
                {
                    var arrOGLang = i.OriginalLanguage1.Split(new char[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
                    if (arrOGLang.Length > 0)
                    {
                        i.OriginalLanguage.id = Convert.ToInt32(arrOGLang[0]);
                        i.OriginalLanguage.Name = arrOGLang[1];
                    }
                }

                if (!string.IsNullOrEmpty(i.Program1))
                {
                    var arrProgram = i.Program1.Split(new char[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
                    if (arrProgram.Length > 0)
                    {
                        i.Program.id = Convert.ToInt32(arrProgram[0]);
                        i.Program.Name = arrProgram[1];
                    }
                }

                if (!string.IsNullOrEmpty(i.Country1))
                {
                    var arrCountryGrp = i.Country1.Split(new char[] { '@' }, StringSplitOptions.RemoveEmptyEntries);
                    if (arrCountryGrp.Length > 0)
                    {
                        foreach (var CountryGroup in arrCountryGrp)
                        {
                            var arrCountry = CountryGroup.Split(new char[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
                            if (arrCountry.Length > 0)
                            {
                                Entities.InputClasses.TitleCountry objCountry = new Entities.InputClasses.TitleCountry();
                                objCountry.id = Convert.ToInt32(arrCountry[0]);
                                objCountry.CountryId = Convert.ToInt32(arrCountry[1]);
                                objCountry.Name = arrCountry[2];

                                i.Country.Add(objCountry);
                            }
                        }
                    }
                }

                if (!string.IsNullOrEmpty(i.TitleTalent1))
                {
                    var arrTalentGrp = i.TitleTalent1.Split(new char[] { '@' }, StringSplitOptions.RemoveEmptyEntries);
                    if (arrTalentGrp.Length > 0)
                    {
                        foreach (var TalentGroup in arrTalentGrp)
                        {
                            var arrTalent = TalentGroup.Split(new char[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
                            if (arrTalent.Length > 0)
                            {
                                Entities.InputClasses.TitleTalent objTalent = new Entities.InputClasses.TitleTalent();
                                objTalent.id = Convert.ToInt32(arrTalent[0]);
                                objTalent.Name = arrTalent[1];
                                objTalent.Role = arrTalent[2];
                                objTalent.TalentId = Convert.ToInt32(arrTalent[3]);
                                objTalent.RoleId = Convert.ToInt32(arrTalent[4]);

                                i.TitleTalent.Add(objTalent);
                            }
                        }
                    }
                }

                if (!string.IsNullOrEmpty(i.AssetType1))
                {
                    var arrAssetType = i.AssetType1.Split(new char[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
                    if (arrAssetType.Length > 0)
                    {
                        i.AssetType.id = Convert.ToInt32(arrAssetType[0]);
                        i.AssetType.Name = arrAssetType[1];
                    }
                }

                if (!string.IsNullOrEmpty(i.Genre1))
                {
                    var arrGenreGrp = i.Genre1.Split(new char[] { '@' }, StringSplitOptions.RemoveEmptyEntries);
                    if (arrGenreGrp.Length > 0)
                    {
                        foreach (var GenreGroup in arrGenreGrp)
                        {
                            var arrGenre = GenreGroup.Split(new char[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
                            if (arrGenre.Length > 0)
                            {
                                Entities.InputClasses.TitleGenre objGenre = new Entities.InputClasses.TitleGenre();
                                objGenre.id = Convert.ToInt32(arrGenre[0]);
                                objGenre.GenreId = Convert.ToInt32(arrGenre[1]);
                                objGenre.Name = arrGenre[2];


                                i.Genre.Add(objGenre);
                            }
                        }
                    }
                }
            });
            ObjTitleReturn.content = entity;
            ObjTitleReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjTitleReturn;
        }

        public List<USPAPI_Title_Bind_Extend_Data> USPAPI_Title_Bind_Extend_Data(Nullable<int> title_Code)
        {
            List<USPAPI_Title_Bind_Extend_Data> ObjExtended = new List<USPAPI_Title_Bind_Extend_Data>();

            var param = new DynamicParameters();
            param.Add("@Title_Code", title_Code);
            ObjExtended = base.ExecuteSQLProcedure<USPAPI_Title_Bind_Extend_Data>("USPAPI_Title_Bind_Extend_Data", param).ToList();
            return ObjExtended;
        }

        public TitleInput GetTitleById(Int32 id)
        {
            TitleInput ObjTitleReturn = new TitleInput();

            var param = new DynamicParameters();
            //param.Add("@id", id);

            param.Add("@order", "ASC");
            param.Add("@page", 1);
            param.Add("@search_value", "");
            param.Add("@size", 1);
            param.Add("@sort", "Last_UpDated_Time");
            param.Add("@date_gt", "");
            param.Add("@date_lt", "");
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            ObjTitleReturn = base.ExecuteSQLProcedure<TitleInput>("USPAPI_Title_List", param).FirstOrDefault();
            return ObjTitleReturn;
        }

        public Title_Validations Title_Validation(string InputValue, string InputType)
        {
            var param = new DynamicParameters();

            param.Add("@InputValue", InputValue);
            param.Add("@InputType", InputType);
            return base.ExecuteSQLProcedure<Title_Validations>("USPAPI_Title_Validations", param).FirstOrDefault();
        }
    }

    #region -------- Title_Country -----------
    public class Title_CountryRepositories : MainRepository<Title_Country>
    {
        public Title_Country Get(int Id)
        {
            var obj = new { Title_Country_Code = Id };

            return base.GetById<Title_Country>(obj);
        }
        public IEnumerable<Title_Country> GetAll()
        {
            return base.GetAll<Title_Country>();
        }
        public void Add(Title_Country entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Title_Country entity)
        {
            Title_Country oldObj = Get(entity.title_country_id.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Title_Country entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Title_Country> SearchFor(object param)
        {
            return base.SearchForEntity<Title_Country>(param);
        }

        public IEnumerable<Title_Country> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Title_Country>(strSQL);
        }
    }
    #endregion

    #region -------- Title_Talent -----------
    public class Title_TalentRepositories : MainRepository<Title_Talent>
    {
        public Title_Talent Get(int Id)
        {
            var obj = new { Title_Talent_Code = Id };

            return base.GetById<Title_Talent>(obj);
        }
        public IEnumerable<Title_Talent> GetAll()
        {
            return base.GetAll<Title_Talent>();
        }
        public void Add(Title_Talent entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Title_Talent entity)
        {
            Title_Talent oldObj = Get(entity.title_talent_id.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Title_Talent entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Title_Talent> SearchFor(object param)
        {
            return base.SearchForEntity<Title_Talent>(param);
        }

        public IEnumerable<Title_Talent> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Title_Talent>(strSQL);
        }
    }
    #endregion

    #region -------- Title_Talent -----------
    public class Title_GenersRepositories : MainRepository<Title_Geners>
    {
        public Title_Geners Get(int Id)
        {
            var obj = new { Title_Geners_Code = Id };

            return base.GetById<Title_Geners>(obj);
        }
        public IEnumerable<Title_Geners> GetAll()
        {
            return base.GetAll<Title_Geners>();
        }
        public void Add(Title_Geners entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Title_Geners entity)
        {
            Title_Geners oldObj = Get(entity.title_genres_id.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Title_Geners entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Title_Geners> SearchFor(object param)
        {
            return base.SearchForEntity<Title_Geners>(param);
        }

        public IEnumerable<Title_Geners> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Title_Geners>(strSQL);
        }
    }
    #endregion
}
