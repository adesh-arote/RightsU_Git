using Dapper;
using RightsU.BMS.Entities.ReturnClasses;
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
            var entity = base.GetById<Title, Title_Country, Title_Talent, Title_Geners, Language, Deal_Type, Program>(obj);

            if (entity != null)
            {
                if (entity.title_language == null)
                {
                    entity.title_language = new LanguageRepositories().Get(entity.Title_Language_Code.Value);
                }

                if (entity.title_country.Count() > 0)
                {
                    entity.title_country.ToList().ForEach(i =>
                    {
                        if (i.country == null)
                        {
                            i.country = new CountryRepositories().Get(i.Country_Code.Value);
                        }
                    });
                }

                if (entity.title_talent.Count() > 0)
                {
                    entity.title_talent.ToList().ForEach(i =>
                    {
                        if (i.talent == null)
                        {
                            i.talent = new TalentRepositories().Get(i.Talent_Code.Value);
                        }

                        if (i.role == null)
                        {
                            i.role = new RoleRepositories().Get(i.Role_Code.Value);
                        }
                    });
                }

                if (entity.title_genres.Count() > 0)
                {
                    entity.title_genres.ToList().ForEach(i =>
                    {
                        if (i.genres == null)
                        {
                            i.genres = new GenresRepositories().Get(i.Genres_Code.Value);
                        }

                    });
                }
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
            Title oldObj = GetById(entity.Title_Code.Value);
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
            var entity = base.ExecuteSQLProcedure<Title>("USPAPI_Title_List", param).ToList();
            entity.ForEach(i =>
            {
                if (!string.IsNullOrEmpty(i.Language1))
                {
                    var arrLang = i.Language1.Split(new char[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
                    if (arrLang.Length > 0)
                    {
                        i.title_language = new Language() { Language_Code = Convert.ToInt32(arrLang[0]), Language_Name = arrLang[1] };
                    }
                }

                if (!string.IsNullOrEmpty(i.OriginalLanguage1))
                {
                    var arrOGLang = i.OriginalLanguage1.Split(new char[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
                    if (arrOGLang.Length > 0)
                    {
                        i.original_language = new Language() { Language_Code = Convert.ToInt32(arrOGLang[0]), Language_Name = arrOGLang[1] };
                    }
                }

                if (!string.IsNullOrEmpty(i.Program1))
                {
                    var arrProgram = i.Program1.Split(new char[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
                    if (arrProgram.Length > 0)
                    {
                        i.Program = new Program() { Program_Code = Convert.ToInt32(arrProgram[0]), Program_Name = arrProgram[1] };
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
                                Title_Country objTitle_Country = new Title_Country();
                                objTitle_Country.Title_Country_Code = Convert.ToInt32(arrCountry[0]);
                                objTitle_Country.Country_Code = Convert.ToInt32(arrCountry[1]);
                                objTitle_Country.country = new Country() { Country_Code = Convert.ToInt32(arrCountry[1]), Country_Name = arrCountry[2] };
                                objTitle_Country.Title_Code = i.Title_Code;

                                i.title_country.Add(objTitle_Country);
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
                                Title_Talent objTitle_Talent = new Title_Talent();
                                objTitle_Talent.Title_Talent_Code = Convert.ToInt32(arrTalent[0]);
                                objTitle_Talent.Title_Code = i.Title_Code;
                                objTitle_Talent.Talent_Code = Convert.ToInt32(arrTalent[3]);
                                objTitle_Talent.Role_Code = Convert.ToInt32(arrTalent[4]);
                                objTitle_Talent.talent = new Talent() { Talent_Code = Convert.ToInt32(arrTalent[3]), Talent_Name = arrTalent[1] };
                                objTitle_Talent.role = new Role() { Role_Code = Convert.ToInt32(arrTalent[4]), Role_Name = arrTalent[2] };

                                i.title_talent.Add(objTitle_Talent);
                            }
                        }
                    }
                }

                if (!string.IsNullOrEmpty(i.AssetType1))
                {
                    var arrAssetType = i.AssetType1.Split(new char[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
                    if (arrAssetType.Length > 0)
                    {
                        i.deal_type = new Deal_Type() { Deal_Type_Code = Convert.ToInt32(arrAssetType[0]), Deal_Type_Name = arrAssetType[1] };
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
                                Title_Geners objGenre = new Title_Geners();
                                objGenre.Title_Geners_Code = Convert.ToInt32(arrGenre[0]);
                                objGenre.Title_Code = i.Title_Code;
                                objGenre.Genres_Code = Convert.ToInt32(arrGenre[1]);
                                objGenre.genres = new Genres() { Genres_Code = Convert.ToInt32(arrGenre[1]), Genres_Name = arrGenre[2] };
                                i.title_genres.Add(objGenre);
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
            Title_Country oldObj = Get(entity.Title_Country_Code.Value);
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
            Title_Talent oldObj = Get(entity.Title_Talent_Code.Value);
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
            Title_Geners oldObj = Get(entity.Title_Geners_Code.Value);
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
